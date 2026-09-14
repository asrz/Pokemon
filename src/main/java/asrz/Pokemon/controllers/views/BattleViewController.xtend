package asrz.Pokemon.controllers.views

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.controllers.controls.HpBar
import asrz.Pokemon.controllers.controls.MoveButtons
import asrz.Pokemon.controllers.controls.XpBar
import asrz.Pokemon.model.Abilities
import asrz.Pokemon.model.Ability
import asrz.Pokemon.model.Item
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.Moves
import asrz.Pokemon.model.Pokeball
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.StatusAilmentInfo
import asrz.Pokemon.model.Trainer
import asrz.Pokemon.model.enums.BattleSlot
import asrz.Pokemon.model.enums.BattleType
import asrz.Pokemon.model.enums.ItemCategory
import asrz.Pokemon.model.enums.MoveCategory
import asrz.Pokemon.model.enums.MoveTarget
import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.model.enums.Stat
import asrz.Pokemon.model.enums.StatusAilment
import asrz.Pokemon.model.enums.Terrain
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.model.enums.Weather
import asrz.Pokemon.util.BattleCalculator
import asrz.Pokemon.util.DialogUtil
import asrz.Pokemon.util.ImageLoader
import asrz.Pokemon.util.ListMap
import asrz.Pokemon.util.TurnAction
import asrz.Pokemon.util.TurnAction.BattleAction
import asrz.Pokemon.util.Util
import java.util.ArrayList
import java.util.Comparator
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.Map.Entry
import java.util.function.Predicate
import javafx.fxml.FXML
import javafx.scene.control.Button
import javafx.scene.control.ButtonBar.ButtonData
import javafx.scene.control.Label
import javafx.scene.control.ScrollPane
import javafx.scene.image.ImageView
import javafx.scene.layout.GridPane
import javafx.scene.layout.HBox
import javafx.scene.layout.VBox
import xtendfx.beans.FXBindable

import static asrz.Pokemon.model.enums.BattleSlot.*

@FXBindable
class BattleViewController extends BasicController {
	
	@FXML
	ScrollPane scrollPane
	@FXML
	Label textBox
	
	@FXML
	GridPane battleMenu
	
	@FXML
	HBox playerPokemonSprites
	
	@FXML
	HBox opponentPokemonSprites
	
	@FXML
	MoveButtons moveButtons
	
	@FXML
	VBox playerHpBars
	@FXML
	VBox opponentHpBars
	
	Trainer opponent
//	Pokemon opponentPokemon
//	
//	Pokemon playerPokemon
	
	
	@FXML
	Button itemButton
	@FXML
	Button pokemonButton
	@FXML
	Button runButton
	
	ListMap<Pokemon, Pokemon> battleParticipants = new ListMap//used for awarding xp
	
	List<Pokemon> switchedInThisTurn = new ArrayList
	
	BattleCalculator battleCalculator
	
	Weather weather
	Integer weatherDuration
	
	Terrain terrain
	Integer terrainDuration
	
	BattleType battleType
	List<BattleSlot> battleSlots
	Map<BattleSlot, Pokemon> pokemonByBattleSlot
	Map<BattleSlot, HpBar> hpBarsByBattleSlot
	Map<BattleSlot, XpBar> xpBarsByBattleSlot
	
	Map<BattleSlot, TurnAction> turnActionByBattleSlot = new HashMap
	
	int escapeAttempts = 0
	int round = 1
	
	new() {
		battleCalculator = new BattleCalculator(this)
	}
	
	def void battleTrainer(Trainer opponent, BattleType battleType) {
		this.opponent = opponent
		this.battleType = battleType
		
		if (battleType.double) {
			battleSlots = Util.list(PLAYER_PRIMARY, PLAYER_SECONDARY, OPPONENT_PRIMARY, OPPONENT_SECONDARY)
		} else {
			battleSlots = Util.list(PLAYER_PRIMARY, OPPONENT_PRIMARY)
		}
		
		pokemonByBattleSlot = new HashMap
		pokemonByBattleSlot.put(PLAYER_PRIMARY, player.team.firstLivingPokemon)
		pokemonByBattleSlot.put(OPPONENT_PRIMARY, opponent.team.firstLivingPokemon)
		
		if (battleType.double) {
			pokemonByBattleSlot.put(PLAYER_SECONDARY, player.team.secondLivingPokemon)
			pokemonByBattleSlot.put(OPPONENT_SECONDARY, opponent.team.secondLivingPokemon)
		}
		
		playerHpBars.children.clear()
		opponentHpBars.children.clear()
		hpBarsByBattleSlot = new HashMap
		xpBarsByBattleSlot = new HashMap
		for (slot : battleSlots) {
			val hpBar = new HpBar => [
				pokemon = pokemonByBattleSlot.get(slot)
			]
			hpBar.initialize()
			hpBarsByBattleSlot.put(slot, hpBar)
			if (slot.isPlayer) {
				playerHpBars.children.add(hpBar)
			} else {
				opponentHpBars.children.add(hpBar)
			}
			
			if (slot.isPlayer) {
				val xpBar = new XpBar => [
					pokemon = pokemonByBattleSlot.get(slot)
				]
				xpBar.initialize()
				xpBarsByBattleSlot.put(slot, xpBar)
				playerHpBars.children.add(xpBar)
			}
		}
		
		initialize()
	}
	
	override initialize() {
		if (opponent !== null) {
			battleParticipants.clear()
			for (pokemon : activeOpponentPokemon) {
				battleParticipants.addAll(pokemon, getActivePlayerPokemon)
			}
			
			for (team : Util.list(player.team, opponent.team)) {
				for (pokemon : team.allPokemon) {
					if (pokemon.ability === null) {
						println(pokemon.fullLabel)
					}
					pokemon.ability.battleStartFunction?.run()
				}
			}
			
			playerPokemonSprites.children.clear()
			opponentPokemonSprites.children.clear()
			for (BattleSlot slot : battleSlots) {
				val pokemon = pokemonByBattleSlot.get(slot)
				if (slot.player) {
					playerPokemonSprites.children.add(new ImageView(ImageLoader.loadImage(pokemon?.backSprite)))
				} else {
					opponentPokemonSprites.children.add(new ImageView(ImageLoader.loadImage(pokemon?.frontSprite)))
				}
			}
			
			textBox.text = ""
			addText("A Battle Begins!")
			if (opponent.wild) {
				addText("You encounter a wild %s", opponent.team.firstLivingPokemon.label)
			} else {
				addText("%s challenges you to a battle", opponent.label)
				addText("%s sends out %s", opponent.label, opponent.team.firstLivingPokemon.label)
			}
			
			scrollPane.vvalueProperty.bind(textBox.heightProperty)
			
			moveButtons.activePokemon = pokemonByBattleSlot.get(PLAYER_PRIMARY)
			moveButtons.moveButtonHandler = [moveButton | selectMove(moveButtons.activePokemon, moveButton.move)]
			moveButtons.initialize()
			
			escapeAttempts = 0
			round = 1
			
			battleCalculator.getInOrderOfSpeed(pokemonByBattleSlot.entrySet.filter[value !== null]).forEach[ pokemonEntry |
				val pokemon = pokemonEntry.value
				if (pokemon?.ability?.switchInFunction !== null) {
					pokemon.ability.switchInFunction?.apply(this, pokemon)
				}
			]
			
			doBeginningOfRound([enableButtons()])
		}
	}
	
	private def List<Pokemon> getActivePokemon(Predicate<BattleSlot> filter) {
		val result = new ArrayList
		
		for (slot: battleSlots) {
			val pokemon = pokemonByBattleSlot.get(slot)
			if (filter.test(slot) && pokemon !== null) {
				result.add(pokemon)
			}
		}
		
		return result
	}
	
	private def List<Pokemon> getActivePlayerPokemon() {
		return getActivePokemon[BattleSlot slot | slot.player]
	}
	
	private def List<Pokemon> getActiveOpponentPokemon() {
		return getActivePokemon[BattleSlot slot | !slot.player]
	}
	
	def List<Pokemon> getActiveOpponents(Pokemon pokemon) {
		if (pokemon.slot.player) {
			return getActiveOpponentPokemon()
		} else {
			return getActivePlayerPokemon()
		}
	}
	
	def Pokemon getAlly(Pokemon pokemon) {
		if (pokemon === null) {
			return null
		}
		
		return pokemonByBattleSlot.get(getSlot(pokemon).allySlot)
	}

	def BattleSlot getSlot(Pokemon pokemon) {
		if (pokemon === null) {
			return null
		}
		
		for (BattleSlot slot : pokemonByBattleSlot.keySet) {
			if (pokemonByBattleSlot.get(slot) == pokemon) {
				return slot
			}
		}
		
		throw new RuntimeException("Pokemon with unknown slot:" + pokemon)
	}
	
	def List<Pokemon> getAllActivePokemon() {
		return pokemonByBattleSlot.values.filterNull.toList
	}
	
	private def tryToRunAway(BattleSlot slot, Runnable callback) {
		val pokemon = pokemonByBattleSlot.get(slot)
		
		if (!opponent.isWild()) {
			addText("You cannot run from a trainer battle!")
			callback.run()
			return
		}
		
		escapeAttempts = escapeAttempts + 1
		
		var Boolean canEscape = null
		if (pokemon.ability.abilityDaoName == Abilities.RUN_AWAY) {
			showAbility(pokemon, pokemon.ability)
			canEscape = true
		}
		
		for (opponentPokemon : activeOpponentPokemon) {
			if (canEscape === null && !battleCalculator.canEscape(pokemon, opponentPokemon, escapeAttempts)) {
				canEscape = false
				addText("%s cannot escape", pokemon.label)
				callback.run()
				return
			}
		}
		
		if (canEscape === null) {
			canEscape = true
		}
		
		if (canEscape) {
			val opponentLabel = battleSlots.filter[!isPlayer].map[pokemonByBattleSlot.get(it)?.label].join(" and ")
			
			addText("%s escapes from the wild %s", player.label, opponentLabel)
			
			c.pokemonService.updatePokedexes(opponent.team.allPokemon, PokedexEntryStatus.SEEN)
			
			Application.setScene(SceneHandle.MAIN_VIEW, [ return new MainViewController ], [])
		}
		
		callback.run()
		return
	}
	
	@FXML
	private def onRunButton() {
		selectAction(moveButtons.activePokemon.slot, TurnAction.runAway(moveButtons.activePokemon))
	}
	
	@FXML
	private def onItemButton() {
		disableButtons()
		
		Application.setScene(SceneHandle.BAG_VIEW, [ new BagViewController() ], [ controller |
			val bagViewController= controller as BagViewController
			bagViewController.cancelButtonCallback = [
				Application.setScene(SceneHandle.BATTLE_VIEW, [ return this ], [ enableButtons() ])
			]
		])
	}
	
	def void useItem(Item item, Pokemon user, Pokemon target, Runnable callback) {
		selectAction(moveButtons.activePokemon.slot, TurnAction.useItem(moveButtons.activePokemon, item, target))
		
		if (item.category == ItemCategory.STANDARD_BALLS) {
			catchPokemon(item as Pokeball, user, target, callback)
		}
	}
	
	def catchPokemon(Pokeball pokeball, Pokemon user, Pokemon target, Runnable callback) {
		if (!opponent.wild) {
			addText("You cannot catch another trainer's Pokémon")
			callback.run()
			return
		}
		
		if (activeOpponentPokemon.filter[alive].size > 1) {
			addText("You cannot catch a Pokémon when another is in the battle.")
			callback.run()
			return
		}
		
		addText("%s throws %s %s", player.label, Util.getIndefiniteArticle(pokeball.label), pokeball.label)
		
		if (battleCalculator.catchSucceeds(pokeball, user, target)) {
			DialogUtil.createInfoDialog("%s caught the %s!", player.label, target.label).showAndWait().ifPresent[
				player.addPokemon(target)
				c.pokemonService.updatePokedexes(target, PokedexEntryStatus.CAUGHT)
			]
			Application.setScene(SceneHandle.MAIN_VIEW, [ return new MainViewController ], [c.playerService.saveGame(player)])
		} else {
			addText("%s escapes the %s", target.label, pokeball.label)
			callback.run()
			return
		}
	}
	
	@FXML
	private def onPokemonButton() {
		Application.setScene(SceneHandle.TEAM_VIEW, [ new TeamViewController() ], [controller |
			val userPokemon = moveButtons.activePokemon
			val battleSlot = userPokemon.slot
			val teamViewController = controller as TeamViewController 
			teamViewController.setBattleSlot(battleSlot)
			teamViewController.setSwitchCallback[ pokemon | selectAction(battleSlot, TurnAction.switchPokemon(userPokemon, pokemon)) ]
			teamViewController.cancelButtonCallback = [ Application.setScene(SceneHandle.BATTLE_VIEW, [ return this ], [ enableButtons() ]) ]
		])
	}
	
	def switchPokemon(BattleSlot slot, Pokemon newPokemon, Runnable callback) {
		switchedInThisTurn.add(newPokemon)
		
		val oldPokemon = pokemonByBattleSlot.get(slot)
		
		oldPokemon.volatileStatusAilments.clear()
		oldPokemon.tempStatChanges.clear()
		if (oldPokemon.formerAbility !== null) {
			oldPokemon.ability = oldPokemon.formerAbility
			oldPokemon.formerAbility = null
		}
		
		if (slot.player) {
			addText("That's enough, %s", oldPokemon.label)
		}
		updatePokemon(slot, newPokemon)
	}
	
	private def ImageView getSpriteButton(BattleSlot battleSlot) {
		switch(battleSlot) {
			case OPPONENT_PRIMARY: {
				return opponentPokemonSprites.children.first as ImageView
			}
			case OPPONENT_SECONDARY: {
				return opponentPokemonSprites.children.last as ImageView
			}
			case PLAYER_PRIMARY: {
				return playerPokemonSprites.children.first as ImageView
			}
			case PLAYER_SECONDARY: {
				return playerPokemonSprites.children.last as ImageView
			}
			default: throw new RuntimeException("Unhandled BattleSlot: " + battleSlot)
		}
	}
	
	def updatePokemon(BattleSlot battleSlot, Pokemon newPokemon) {
		if (battleSlot.player) {
			addText("Let's go, %s!", newPokemon.label)
			for (pokemon : activeOpponentPokemon) {
				battleParticipants.addIfAbsent(pokemon, newPokemon)
			}
		} else {
			battleParticipants.addAllAbsent(newPokemon, activePlayerPokemon)
		}
		
		pokemonByBattleSlot.put(battleSlot, newPokemon)
		val hpBar = hpBarsByBattleSlot.get(battleSlot)
		
		val spriteButton = getSpriteButton(battleSlot) 
		
		val newSprite = if (battleSlot.player) {
			newPokemon.backSprite
		} else {
			newPokemon.frontSprite
		}
		
		spriteButton.image = ImageLoader.loadImage(newSprite)
		hpBar.pokemon = newPokemon
		hpBar.initialize()
	}
	
	def List<BattleSlot> getTargets(Pokemon user, Move move, Pokemon opponent) {
		switch(move.target) {
			case RANDOM_OPPONENT,
			case ALL_OTHER_POKEMON,
			case SELECTED_POKEMON,
			case ALL_OPPONENTS: return Util.list(opponent.getSlot)
			
			case USER,
			case USER_AND_ALLIES,
			case USER_OR_ALLY: return Util.list(user.getSlot)
			
			case ALL_POKEMON: return Util.list(user.getSlot, opponent.getSlot)
			default: throw new RuntimeException("Unhandled MoveTarget: " + move.target)
		}
	}
	
	def void selectAction(BattleSlot slot, TurnAction turnAction) {
		turnActionByBattleSlot.put(slot, turnAction)
		
		val playerSlots = battleSlots.filter[it.player].toList
		
		if (slot == playerSlots.lastOrNull) {
			selectOpponentTurnActions()
		} else {
			val nextSlot = playerSlots.get(playerSlots.indexOf(slot) + 1)
			val nextPokemon = pokemonByBattleSlot.get(nextSlot)
			if (nextPokemon === null) {
				selectOpponentTurnActions()
			} else {
				moveButtons.activePokemon = nextPokemon
				moveButtons.initialize
			}
		}
	}
	
	def void selectOpponentTurnActions() {
		for (slot : battleSlots.filter[slot | !slot.player]) {
			turnActionByBattleSlot.put(slot, selectOpponentAction(slot))
		}
		
		resolveTurnActions()
	}
	
	def void resolveTurnActions() {
		val turnActions = turnActionByBattleSlot.entrySet().toList()
		
		for (entry : turnActions) {
			val battleSlot = entry.key
			val turnAction = entry.value
			val pokemon = pokemonByBattleSlot.get(battleSlot)
			if (pokemon.ability.abilityDaoName == Abilities.QUICK_DRAW && turnAction.battleAction == BattleAction.USE_MOVE) {
				if (Util.randomPercentage() <= 30) {
					showAbility(pokemon, pokemon.ability)
					pokemon.ability.counter = 1
				} else {
					pokemon.ability.counter = 0
				}
			}
		}
		
		turnActions.sort(Comparator.comparing([value], new TurnAction.TurnActionOrder(battleCalculator)))
		
		val firstTurnAction = turnActions.remove(0)
		resolveTurnAction(firstTurnAction, turnActions, [
			if (!checkForBattleEnd()) {
				doEndOfRound([
					doBeginningOfRound([enableButtons()])
				])
			}
		])
	}
	
	def void resolveTurnAction(Entry<BattleSlot, TurnAction> firstTurnAction, List<Entry<BattleSlot, TurnAction>> remainingTurnActions, Runnable callback) {
		val battleslot = firstTurnAction.key
		val turnAction = firstTurnAction.value
		
		val Runnable nextCallback = [
			doEndOfTurn(battleslot, [
				if (remainingTurnActions.empty) {
					callback.run()
				} else {
					remainingTurnActions.sort(Comparator.comparing([value], new TurnAction.TurnActionOrder(battleCalculator)))
					val nextTurnAction = remainingTurnActions.remove(0)
					resolveTurnAction(nextTurnAction, remainingTurnActions, callback)
				}
			])
		]
		
		switch(turnAction.battleAction) {
			case RUN_AWAY: { 
				tryToRunAway(battleslot, nextCallback)
			}
			case SWITCH_POKEMON: {
				switchPokemon(firstTurnAction.key, turnAction.pokemon, nextCallback)
			}
			case USE_ITEM: {
				useItem(turnAction.item, turnAction.user, turnAction.pokemon, nextCallback)
			}
			case USE_MOVE: {
				if (pokemonByBattleSlot.values.contains(turnAction.user) && turnAction.user.hp > 0) {
					if (turnAction.user.ability?.abilityDaoName == Abilities.ANALYTIC && remainingTurnActions.empty) {
						turnAction.user.ability.counter = 1
					}
					
					//if pokemon still on field and alive
					useMove(turnAction.user, turnAction.move, turnAction.targets, nextCallback)
				} else {
					nextCallback.run()
				}
			}
		}
	}
	
	def useMove(Pokemon user, Move move, List<BattleSlot> slotTargets, Runnable callback) {
		println(String.format("useMove(%s, %s, %s)", user.label, move.label, slotTargets.map[name].join(',')))
		if (user.volatileStatusAilments.remove(StatusAilment.FLINCH) !== null) {
			addText("%s flinched!", getFullLabel(user))
			callback.run()
			return
		}
		
		val skipTurn = user.ability?.offensiveBeforeMoveFunction?.apply(this, user, move) ?: false
		
		if (skipTurn) {
			//e.g. Truant
			addText("%s is loafing around", getFullLabel(user))
			callback.run()
			return
		}
		
		addText("%s uses %s", getFullLabel(user), move.label)
		reducePp(user, move, slotTargets)
		
		if (slotTargets === null) {
			addText("It failed")
			callback.run()
			return
		}
		
		
		var ignoreAbilities = false
		if (Util.in(user.ability?.abilityDaoName, Abilities.MOLD_BREAKER, Abilities.TERAVOLT, Abilities.TURBOBLAZE)) {
			ignoreAbilities = true
		} else if (user.ability?.abilityDaoName == Abilities.MYCELIUM_MIGHT && move.isStatus()) {
			ignoreAbilities = true
		} else if (Util.in(move.moveDaoName, Moves.IGNORE_ABILITIES)) {
			ignoreAbilities = true
		}
		//ability shield
		
		
		
		if (slotTargets.size == 1) {
			val targetSlot = slotTargets.get(0)
			val targetPokemon = pokemonByBattleSlot.get(targetSlot)
			
			//if you target a slot that no longer has a pokemon on move resolution, target the other slot instead
			if (targetPokemon === null || targetPokemon.fainted) {
				slotTargets.set(0, targetSlot.allySlot)
				
				//redirection abilities
				if (!Util.in(user.ability.abilityDaoName, Abilities.PREVENT_REDIRECTION_ABILITIES)) {
					if (!ignoreAbilities && pokemonByBattleSlot.get(targetSlot.allySlot)?.abilityDaoName == Abilities.LIGHTNING_ROD && move.type == Type.ELECTRIC) {
						slotTargets.set(0, targetSlot.allySlot)
					} else if (!!ignoreAbilities && pokemonByBattleSlot.get(targetSlot.allySlot)?.abilityDaoName == Abilities.STORM_DRAIN && move.type == Type.WATER) {
						slotTargets.set(0, targetSlot.allySlot)
					}
				}
			}
		}
		
		if (slotTargets.size > 0) {
			val battleSlot = slotTargets.remove(0)
			
			val target = pokemonByBattleSlot.get(battleSlot)
			target?.ability?.defensiveBeforeMoveFunction?.apply(this, user, move, target)
			
			doHit(user, move, battleSlot, slotTargets, 0, ignoreAbilities, callback)
		} else {
			callback.run()
		}
		
	}
	
	def void reducePp(Pokemon user, Move move, List<BattleSlot> slotTargets) {
		var pp = 1
		
		val pressurePokemon = getActiveOpponents(user).filterNull.filter[alive].filter[ability?.abilityDaoName == Abilities.PRESSURE]
		if (!pressurePokemon.empty) {
			if (Util.in(move.moveDaoName, "snatch", "imprison", "spikes", "stealth rock", "toxic spikes", "tera blast")) {
				pp = pressurePokemon.size()
			} else if (move.target == MoveTarget.ENTIRE_FIELD) {
				pp = pressurePokemon.size()
			} else if (Util.in(move.moveDaoName, "curse") && !user.types.contains(Type.GHOST) && !user.slot.player) {
				pp = pressurePokemon.size()
			} else {
				val pressurePokemonTargeted = pressurePokemon.filter[slotTargets.contains(getSlot(it))]
				pp = Math.min(1, pressurePokemonTargeted.size())
			}
		}
		
		move.pp = Math.max(0, move.pp - pp)
	}
	
	def void doHit(Pokemon user, Move move, BattleSlot slotTarget, List<BattleSlot> nextTargets, int hits, boolean ignoreAbilities, Runnable callback) {
		println(String.format("doHit(%s, %s, %s, %s, %d)", user.label, move.label, slotTarget, nextTargets.map[name].join(','), hits))
		val minHits = move.minHits ?: 0
		val maxHits = move.maxHits ?: 1
		
		if (hits == maxHits) {
			if (minHits > 1) {
				addText("It hits %d times")
			}
			
			if (nextTargets.empty) {
				callback.run()
			} else {
				doHit(user, move, nextTargets.remove(0), nextTargets, 0, ignoreAbilities, callback)
			}
			return
		}
		
		val target = pokemonByBattleSlot.get(slotTarget)
		
		if (target === null) {
			addText("It failed")
			callback.run()
			return
		}
		
		if (minHits > 1 && hits < minHits) {
			applyMove(user, move, slotTarget, ignoreAbilities, [
				doHit(user, move, slotTarget, nextTargets, hits+1, ignoreAbilities, callback)
			])
		}
		
		if (hits < maxHits) {
			if (!battleCalculator.doesMoveHit(user, move, target, null, null, weather, ignoreAbilities)) {
				if (minHits <= 1) {
					addText("%s avoided the attack", getFullLabel(target))
				} else {
					addText("It hits %d times", hits)
				}
				
				if (nextTargets.empty) {
					callback.run()
				} else {
					doHit(user, move, nextTargets.remove(0), nextTargets, 0, ignoreAbilities, callback)
				}
				
				return
			} else {
				applyMove(user, move, slotTarget, ignoreAbilities, [
					doHit(user, move, slotTarget, nextTargets, hits+1, ignoreAbilities, callback)
				])
			}
		} else {
			callback.run()
			return
		}
	}
	
	def applyMove(Pokemon user, Move move, BattleSlot slotTarget, boolean ignoreAbilities, Runnable callback) {
		println(String.format("applyMove(%s, %s, %s)", user.label, move.label, slotTarget))
		val target = pokemonByBattleSlot.get(slotTarget)
		
		val damage = battleCalculator.getDamage(user, move, target, ignoreAbilities)
		if (damage !== null) {
			val typeModifier = Type.getDamageModifier(move.type, target.types)
			if (typeModifier == 0) {
				addText("It has no effect")
			} else if (typeModifier < 0.5) {
				addText("It is mostly ineffective")
			} else if (typeModifier < 1.0) { 
				addText("It's not very effective")
			} else if (typeModifier > 2.0) {
				addText("It's extremely effective!")
			} else if (typeModifier > 1.0) {
				addText("It's super effective!")
			}
			
			applyDamage(target, damage, [
				if (move.healing !== null) {
					val drain = battleCalculator.getDrain(user, move, target, damage)
					if (drain != 0) {
						applyDamage(user, -drain, [
							applyMoveEffects(user, move, slotTarget, ignoreAbilities, callback)
						])
					} else {
						applyMoveEffects(user, move, slotTarget, ignoreAbilities, callback)
					}
				} else {
					applyMoveEffects(user, move, slotTarget, ignoreAbilities, callback)
				}
			])
		} else {
			applyMoveEffects(user, move, slotTarget, ignoreAbilities, callback)
		}
	}
	
	def void applyDamage(Pokemon target, int damage, Runnable callback) {
		println(String.format("applyDamage(%s, %d)", target.label, damage))
		val targetHpBar = hpBarsByBattleSlot.get(target.slot)
		targetHpBar.applyDamage(damage, [
			callback.run()
		])
	}
	
	def void applyMoveEffects(Pokemon user, Move move, BattleSlot slotTarget, boolean ignoreAbilities, Runnable callback) {
		println(String.format("applyMoveEffects(%s, %s, %s)", user.label, move.label, slotTarget))
		val target = pokemonByBattleSlot.get(slotTarget)
		if (target.hp == 0) {
			addText("%s has fainted", getFullLabel(target))
			
			target.ability?.defensiveOnDeathFunction?.apply(this, user, move, target, ignoreAbilities)
			user.ability?.offensiveOnKillFunction?.apply(this, user, move, target)
			for (pokemon : getAllActivePokemon().filter[alive]) {
				pokemon.ability.globalOnFaintFunction?.apply(this, pokemon, target)
			}
			
			if (player.team.allPokemon.contains(user) && !slotTarget.isPlayer) {
				c.pokemonService.updatePokedexes(target, PokedexEntryStatus.SEEN)
				assignXp(target, [ callback.run() ])
				return
			}
		} else {
			if (battleCalculator.ailmentApplies(user, move, target, ignoreAbilities)) {
				if (move.statusAilment.volatile && !target.volatileStatusAilments.containsKey(move.statusAilment)) {
					addText(move.statusAilment.getMessage(target, user))
				} else if (target.statusAilment === null) {
					addText(move.statusAilment.getMessage(target, user))
				}
				applyMoveAilment(user, move, target)
			}
			
			if (battleCalculator.flinchApplies(user, move, target, ignoreAbilities)) {
				target.volatileStatusAilments.put(StatusAilment.FLINCH, new StatusAilmentInfo => [
					inflicter = user.getSlot
				]);
			}
			
			if (battleCalculator.statChangesApply(user, move, target)) {
				val statChangeTarget = 
				if (Util.in(move.category, MoveCategory.DAMAGE_RAISE)) {
					user
				} else if (Util.in(move.category, MoveCategory.DAMAGE_LOWER, MoveCategory.SWAGGER, MoveCategory.NET_GOOD_STATS)) {
					target
				} else {
					throw new RuntimeException("Unexpected move category: " + move.category)
				}
				
				for (Stat stat : move.statChanges.keySet()) {
					val valueChange = move.statChanges.get(stat)
					applyStatChange(user, statChangeTarget, stat, valueChange, ignoreAbilities)
				}
			}
		}
		
		if (move.healing !== null) {
			val healing = battleCalculator.getHealing(user, move, target)
			if (healing != 0) {
				applyDamage(user, -healing, [
					callback.run()
				])
			} else {
				callback.run()
			}
			return
		}
		
		
		callback.run()
	}
	
	def applyMoveAilment(Pokemon user, Move move, Pokemon target) {
		val statusAilment = move.statusAilment
		val info = new StatusAilmentInfo()
		
		if (move.moveDaoName == 'toxic') {
			info.strength = 1
		}
		if (statusAilment == StatusAilment.SLEEP) {
			info.duration = Util.randomInt(1,3)
			if (target.ability.abilityDaoName == Abilities.EARLY_BIRD) {
				info.duration = info.duration / 2
			}
		} else if (statusAilment == StatusAilment.LEECH_SEED) {
			info.inflicter = user.slot
		}
		
		applyStatusAilment(user, statusAilment, target, info)
	}
	
	def applyStatusAilment(Pokemon user, StatusAilment statusAilment, Pokemon target, StatusAilmentInfo info) {
		if (statusAilment.isVolatile && !target.volatileStatusAilments.containsKey(statusAilment)) {
			target.volatileStatusAilments.put(statusAilment, info)
		}
		if (!statusAilment.volatile && target.statusAilment === null) {
			target.statusAilment = statusAilment
			target.statusAilmentInfo = info
		}
		
		target.ability?.onStatusAilmentFunction?.apply(this, user, statusAilment, target)
	}
	
	/**
	 * modifies the specified stat by the amount specified
	 */
	def void applyStatChange(Pokemon user, Pokemon target, Stat stat, int valueChange, boolean ignoreAbilities) {
		var actualChange =  target.ability?.defensiveStatChangeModifierFunction?.apply(this, user, target, stat, valueChange, ignoreAbilities) ?: valueChange
		val ally = getAlly(target)
		if (ally !== null && ally.alive) {
			actualChange = ally.ability?.defensiveAllyStatChangeModifierFunction?.apply(this, user, target, stat, valueChange, ignoreAbilities) ?: actualChange
		}
		
		val int oldValue = target.tempStatChanges.getOrDefault(stat, 0)
		if (oldValue == 6 && actualChange > 0) {
			addText("%s's %s cannot be raised any further", target.fullLabel, stat.label)
		} else if (oldValue == -6 && actualChange < 0) {
			addText("%s's %s cannot be lowered any further", target.fullLabel, stat.label)
		}
		var newValue = oldValue + actualChange
		if (newValue > 6) {
			newValue = 6
		} else if (newValue < -6) {
			newValue = -6
		}
		
		val trueChange = newValue - oldValue
		if (trueChange >= 3) {
			addText("%s's %s rose drastically!", target.fullLabel, stat.label)
		} else if (trueChange == 2) {
			addText("%s's %s rose sharply!", target.fullLabel, stat.label)
		} else if (trueChange == 1) {
			addText("%s's %s rose", target.fullLabel, stat.label)
		} else if (trueChange == -1) {
			addText("%s's %s fell", target.fullLabel, stat.label)
		} else if (trueChange == -2) {
			addText("%s's %s harshly fell!", target.fullLabel, stat.label)
		} else if (trueChange <= -3) {
			addText("%s's %s severely fell!", target.fullLabel, stat.label)
		}
		
		target.tempStatChanges.put(stat, newValue)
		
		target.ability?.onStatChangeFunction?.apply(this, user, target, stat, valueChange)
	}
	
	/**
	 * sets the specified stat to the specified value
	 */
	def void applyStatValue(Pokemon user, Pokemon target, Stat stat, int value) {
		if (value == 6) {
			addText("%s's %s is maximized!", target.fullLabel, stat.label)
		}
		
		target.tempStatChanges.put(stat, value)
	}
	
	def void selectMove(Pokemon pokemon, Move move) {
		val List<BattleSlot> targets = selectTargets(pokemon, move)
		
		if (targets === null || targets.contains(null)) {
			enableButtons()
			return
		} else {
			disableButtons()
		}
		
		selectAction(pokemon.getSlot, TurnAction.useMove(pokemon, move, targets))
		
		
		escapeAttempts = 0
	}
	
	def List<BattleSlot> selectTargets(Pokemon pokemon, Move move) {
		val pokemonSlot = pokemon.slot
		
		val allySlot = pokemonSlot.allySlot
		val opponentSlot = pokemonSlot.opponentSlot
		switch(move.target) {
			case ALL_ALLIES:  {
				if (battleType == BattleType.SINGLE) { return null; }
				if (battleType == BattleType.DOUBLE) { return Util.list(allySlot) }
			}
			case ALLY: {  
				if (battleType == BattleType.SINGLE) { return null; }
				if (battleType == BattleType.DOUBLE) { return Util.list(allySlot) }
			}
			case ALL_OPPONENTS: {
				if (battleType == BattleType.SINGLE) { return Util.list(opponentSlot) }
				if (battleType == BattleType.DOUBLE) { return Util.list(opponentSlot, opponentSlot.allySlot) }
			}
			case ALL_OTHER_POKEMON: {
				if (battleType == BattleType.SINGLE) { return Util.list(opponentSlot) }
				if (battleType == BattleType.DOUBLE) { return Util.list(opponentSlot, opponentSlot.allySlot, allySlot) }
			}
			case ALL_POKEMON: {
				if (battleType == BattleType.SINGLE) { return Util.list(pokemonSlot, opponentSlot) }
				if (battleType == BattleType.DOUBLE) { return Util.list(pokemonSlot, allySlot, opponentSlot, opponentSlot.allySlot) }
			}
			case ENTIRE_FIELD: {
				return Util.list()
			}
			case FAINTING_POKEMON: {
				//TODO
				throw new RuntimeException("Unhandled target FAINTING_POKEMON")
			}
			case OPPONENTS_FIELD: {
				return Util.list()
			}
			case RANDOM_OPPONENT: {
				if (battleType == BattleType.SINGLE) { return Util.list(opponentSlot) }
				if (battleType == BattleType.DOUBLE) { return Util.list(Util.randomChoice(opponentSlot, opponentSlot.allySlot)) }
			}
			case SELECTED_POKEMON_ME_FIRST,
			case SELECTED_POKEMON: {
				if (battleType == BattleType.SINGLE) { 
					if (pokemonSlot.player) {
						return Util.list(opponentSlot)
					} else {
						return Util.list(opponentSlot)
					}
				}
				if (battleType == BattleType.DOUBLE) {
					if (pokemonSlot.player) {
						return Util.list(DialogUtil.chooseTarget(pokemonByBattleSlot, Util.list(allySlot, opponentSlot, opponentSlot.allySlot)))
					} else {
						val primaryTarget = pokemonByBattleSlot.get(opponentSlot)
						val secondaryTarget = pokemonByBattleSlot.get(opponentSlot.allySlot)
						if (primaryTarget === null || primaryTarget.fainted) {
							return Util.list(opponentSlot.allySlot)
						} else if (secondaryTarget === null || secondaryTarget.fainted) {
							return Util.list(opponentSlot)
						} else {
							return Util.list(Util.randomChoice(opponentSlot, opponentSlot.allySlot)) //TODO AI
						}
					}
				}
			}
			case SPECIFIC_MOVE: {
				throw new RuntimeException("Unhandled target SPECIFIC_MOVE")
				//TODO
			}
			case USER: {
				return Util.list(pokemonSlot)
			}
			case USERS_FIELD: {
				return Util.list()
			}
			case USER_AND_ALLIES: {
				if (battleType == BattleType.SINGLE) { return Util.list(pokemonSlot) }
				if (battleType == BattleType.DOUBLE) { return Util.list(pokemonSlot, allySlot) }
			}
			case USER_OR_ALLY: {
				if (battleType == BattleType.SINGLE) { return Util.list(pokemonSlot) }
				if (battleType == BattleType.DOUBLE) {
					if (pokemonSlot.isPlayer) {
						return Util.list(DialogUtil.chooseTarget(pokemonByBattleSlot, Util.list(pokemonSlot, allySlot)))
					} else {
						return Util.list(Util.randomChoice(pokemonSlot, allySlot))
					}
				}
			}
			
		}
	}
	
	def selectOpponentAction(BattleSlot slot) {
		//TODO AI
		val pokemon = pokemonByBattleSlot.get(slot)
		val move = Util.randomChoice(pokemon.moves)
		val targets = selectTargets(pokemon, move)
		return TurnAction.useMove(pokemon, move, targets)
	}
	
	def doBeginningOfRound(Runnable callback) {
		addText("--- Round %d ---", round)
		round = round + 1
		moveButtons.activePokemon = pokemonByBattleSlot.get(PLAYER_PRIMARY)
		moveButtons.initialize
		callback.run()
	}
	
	def doEndOfRound(Runnable callback) {
		val List<BattleSlot> emptySlots = battleSlots
			.filter[pokemonByBattleSlot.get(it) !== null && !pokemonByBattleSlot.get(it).alive]
			.toList
		
		for (emptyPlayerSlot : emptySlots.filter[isPlayer]) {
			if (Util.difference(player.team.allPokemon.filterNull.filter[alive].toList, activePlayerPokemon).size() > 0) {
				Application.setScene(SceneHandle.TEAM_VIEW, [ new TeamViewController() ], [controller |
					val teamViewController = controller as TeamViewController 
					teamViewController.setBattleSlot(emptyPlayerSlot)
					teamViewController.setSwitchCallback[ pokemon | updatePokemon(emptyPlayerSlot, pokemon) ]
				])
			}
		}
		
		for (emptyOpponentSlot : emptySlots.filter[!isPlayer]) {
			if (Util.difference(opponent.team.allPokemon.filterNull.filter[alive].toList, activeOpponentPokemon).size() > 0) {
				val newPokemon = opponent.team.allPokemon.filter[pokemon | !activeOpponentPokemon.contains(pokemon)].filter[alive].toList.first
				updatePokemon(emptyOpponentSlot, newPokemon)
				addText("%s sends out %s", opponent.label, newPokemon.fullLabel)
			}
		}
		
		doWeatherEndOfRound()
		doTerrainEndOfRound()
		
		callback.run()
	}
	
	def void doTerrainEndOfRound() {
		if (terrain === null) {
			return
		}
		
		terrainDuration = terrainDuration - 1
		if (terrainDuration == 0) {
			terrain = null
			terrainDuration = null
			for (pokemon : allActivePokemon) {
				pokemon.ability.onTerrainChangeFunction?.apply(this, pokemon, null)
			}
		}
		
		if (terrain == Terrain.GRASSY) {
			for (entry : battleCalculator.getInOrderOfSpeed(pokemonByBattleSlot.entrySet())) {
				val pokemon = entry.value
				if (pokemon.grounded) {
					val healing = pokemon.maxHp / 16
					applyDamage(pokemon, -healing, [])
				}
			}
		}
	}
	
	def void doWeatherEndOfRound() {
		if (weather === null) {
			return
		}
		
		if (!weather.primordial) {
			weatherDuration = weatherDuration - 1
			if (weatherDuration == 0) {
				addText(weather.endingMessage)
				weather = null
				weatherDuration = null
			}
		}
		
		if (weather == Weather.SANDSTORM && !weatherDisabled) {
			for (entry : battleCalculator.getInOrderOfSpeed(pokemonByBattleSlot.entrySet())) {
				val pokemon = entry.value
				if (Util.in(Type.ROCK, pokemon.types) || Util.in(Type.GROUND, pokemon.types) || Util.in(Type.STEEL, pokemon.types) 
					|| pokemon.ability.isImmuneToWeatherDamageFunction?.apply(weather) ?: false
				) {
					//pass
				} else {
					val damage = pokemon.maxHp / 16
					addText("%s is buffeted by the sandstorm", pokemon.fullLabel)
					applyDamage(pokemon, damage, [])
				}
			} 
		}
	}
	
	def void doEndOfTurn(BattleSlot battleSlot, Runnable callback) {
		println(String.format("doEndOfTurn(%s)", battleSlot))
		val pokemon = pokemonByBattleSlot.get(battleSlot)
		val ailmentsToProcess = pokemon.volatileStatusAilments.entrySet.map[entry | entry.key -> entry.value].toList
		
		if (pokemon.statusAilment !== null) {
			ailmentsToProcess.add(0, pokemon.statusAilment -> pokemon.statusAilmentInfo)
		}
		
		pokemon?.ability?.endOfTurnFunction?.apply(this, pokemon)
		
		if (ailmentsToProcess.empty) {
			callback.run()
		} else {
			val nextAilmentEntry = ailmentsToProcess.remove(0)
			processAilmentEndOfTurn(battleSlot, nextAilmentEntry.key, nextAilmentEntry.value, ailmentsToProcess, callback)
		}
		
		switchedInThisTurn.clear()
	}
	
	def void processAilmentEndOfTurn(BattleSlot battleSlot, StatusAilment statusAilment, StatusAilmentInfo ailmentInfo, List<Pair<StatusAilment, StatusAilmentInfo>> ailmentsToProcess, Runnable callback) {
		val Runnable nextCallback = [
			if (ailmentsToProcess.empty) {
				callback.run()
			} else {
				val nextAilmentEntry = ailmentsToProcess.remove(0)
				processAilmentEndOfTurn(battleSlot, nextAilmentEntry.key, nextAilmentEntry.value, ailmentsToProcess, callback)
			}
		]
		
		val pokemon = pokemonByBattleSlot.get(battleSlot)
		val damageModifier = pokemon.ability?.defensiveStatusAilmentDamageModifierFunction?.apply(this, pokemon, statusAilment) ?: 1.0
		
		if (statusAilment == StatusAilment.BURN) {
			addText("%s was hurt by the burn", getFullLabel(pokemon))
			val damage = Math.floor((pokemon.maxHp / 16) * damageModifier) as int
			applyDamage(pokemon, damage, nextCallback)
		} else if (statusAilment == StatusAilment.POISON) {
			addText("%s was hurt by poison")
			var damage = Math.floor((pokemon.maxHp / 8) * damageModifier) as int
			if (ailmentInfo.strength >= 0) {
				damage = damage * ailmentInfo.strength
				ailmentInfo.strength = ailmentInfo.strength + 1
			}
			applyDamage(pokemon, damage, nextCallback)
		} else if (statusAilment == StatusAilment.LEECH_SEED) {
			val damage = Math.floor((pokemon.hp / 8) * damageModifier) as int
			addText("%s is damaged by Leech Seed", getFullLabel(pokemon))
			val inflicter = pokemonByBattleSlot.get(ailmentInfo.inflicter)
			hpBarsByBattleSlot.get(battleSlot).applyDamage(damage, [
				addText("%s is healed by Leech Seed", getFullLabel(inflicter))
				applyDamage(inflicter, -damage, nextCallback)
			])
		} else if (statusAilment == StatusAilment.DISABLE) {
			ailmentInfo.duration = ailmentInfo.duration - 1
			if (ailmentInfo.duration <= 0) {
				pokemon.volatileStatusAilments.remove(statusAilment)
			}
		} else if (statusAilment == StatusAilment.PERISH_SONG) {
			ailmentInfo.duration = ailmentInfo.duration - 1
			if (ailmentInfo.duration <= 0) {
				addText("%s perishes", pokemon.fullLabel)
				pokemon.hp = 0
				//TODO
			}
		} else {
			throw new RuntimeException("Unhandled end of turn statusAilment: " + statusAilment.name)
		}
	}
	
//	def chooseOpponentMove(Trainer trainer, Pokemon pokemon) {
//		//TODO trainer AI
//		return Util.randomChoice(opponentPokemon.moves)
//	}
	
	private def boolean checkForBattleEnd() {
		println("checkForBattleEnd")
		if (player.team.firstLivingPokemon === null) {
			loseBattle()
			return true
		} else if (opponent.team.firstLivingPokemon === null) {
			winBattle()
			return true
		} else {
			return false
		}
	}
	
	def winBattle() {
		addText("%s defeated %s", player.label, opponent.label)
		
		if (player.currentGym === null) {
			player.team.healAllPokemon()
		} else {
			player.currentGymProgress = player.currentGymProgress + 1
		}
		
		c.pokemonService.updatePokedexes(opponent.team.allPokemon, PokedexEntryStatus.SEEN)
		Application.setScene(SceneHandle.MAIN_VIEW, [ c.mainViewController ], [ controller |
			c.playerService.saveGame(player)
			(controller as MainViewController).updateGymView()
		])
	}
	
	def loseBattle() {
		var String message = String.format("%s has no more Pokémon. Would you like to try again?", player.label)
		if (player.currentGymId !== null) {
			message += " You will have to start the gym again from the first trainer."
		}
		val dialog = DialogUtil.createYesNoDialog(message)
		dialog.show()
		dialog.resultProperty.addListener[ resultProperty, oldButtonType, buttonType |
			if(buttonType.buttonData == ButtonData.YES) {
				player.team.healAllPokemon()
				
				if (player.currentGymId !== null) {
					//start the gym over
					if (player.currentGymProgress > 0) {
						player.currentGymProgress = 0
						battleTrainer(player.currentGym.trainers.first, battleType)
					} else {
						opponent.team.healAllPokemon()
						battleTrainer(opponent, battleType)
					}
				} else {
					opponent.team.healAllPokemon()
					battleTrainer(opponent, battleType)
				}
			} else {
				player.team.healAllPokemon()
				
				c.pokemonService.updatePokedexes(opponent.team.allPokemon, PokedexEntryStatus.SEEN)
				
				player.currentGymId = null
				player.currentGymProgress = null
				
				Application.setScene(SceneHandle.MAIN_VIEW, [ return new MainViewController ], [c.playerService.saveGame(player)])
			}
		]
	}
	
	def void showAbility(Pokemon pokemon, Ability ability) {
		addText("%s's %s ability activates", getFullLabel(pokemon), ability.label)
	}
	
	def void assignXp(Pokemon faintingPokemon, Runnable callback) {
		println(String.format("assignXP(%s)", faintingPokemon.label))
		val trainerModifier = opponent.wild ? 1.0 : 1.5
		val int xpPool = Math.floor(((faintingPokemon.species.baseExperience * faintingPokemon.level) / 7.0) * trainerModifier) as int
		//TODO exp share, lucky egg
		
		val xpShare = xpPool / battleParticipants.get(faintingPokemon).filter[alive].size()
		
		val activePlayerPokemon = battleSlots.filter[isPlayer].map[pokemonByBattleSlot.get(it)]
		for (playerPokemon : activePlayerPokemon) {
			battleParticipants.get(faintingPokemon).remove(playerPokemon)
			
			if (playerPokemon !== null && playerPokemon.alive) {
				assignXp(playerPokemon, faintingPokemon, xpShare, [callback.run()])
			} else if (!battleParticipants.get(faintingPokemon).isEmpty) {
				assignXp(battleParticipants.get(faintingPokemon).remove(0), faintingPokemon, xpShare, [callback.run()])
			}
		}
		
		callback.run()
	}
	
	def void assignXp(Pokemon pokemon, Pokemon faintingPokemon, int xpShare, Runnable callback) {
		println(String.format("assignXp(%s, %s, %d)", pokemon.label, faintingPokemon.label, xpShare))
		if (!pokemon.isAlive()) {
			if (!battleParticipants.get(faintingPokemon).filter[alive].isEmpty) {
				assignXp(battleParticipants.get(faintingPokemon).remove(0), faintingPokemon, xpShare, callback)
			} else {
				callback.run()
			}
		}
		
		addText("%s gains %d experience points", pokemon.label, xpShare)
		
		for (battleSlot : battleSlots.filter[isPlayer]) {
			if (pokemonByBattleSlot.get(battleSlot) == pokemon) {
				val xpBar = xpBarsByBattleSlot.get(battleSlot)
				
				xpBar.addXp(pokemon, xpShare, activePlayerPokemon.contains(pokemon), [
					if (!battleParticipants.get(faintingPokemon).filter[alive].isEmpty) {
						assignXp(battleParticipants.get(faintingPokemon).remove(0), faintingPokemon, xpShare, callback)
					} else {
						callback.run()
					}
				])
			}
		}
		
		callback.run()
	}
	
	private def void disableButtons() {
		itemButton.disable = true
		pokemonButton.disable = true
		runButton.disable = true
		moveButtons.disable = true
	}
	
	private def void enableButtons() {
		itemButton.disable = false
		pokemonButton.disable = false
		runButton.disable = false
		moveButtons.disable = false
	}
	
	def void addText(String text, Object...args) {
		println(String.format(text, args))
		textBox.text = textBox.text + "\n" + String.format(text, args)
	}
	
	def String getFullLabel(Pokemon pokemon) {
		if (pokemon.getSlot.isPlayer()) {
			return pokemon.label
		} else if (opponent.isWild) {
			return String.format("The wild %s", pokemon.label)
		} else {
			return String.format("The foe's %s", pokemon.label)
		}
	}
	
	def void changeWeather(Weather weather, Integer duration) {
		if (this.weather !== null && this.weather.isPrimordial()) {
			if (weather !== null && !weather.isPrimordial()) {
				return
			}
		}
		
		addText(weather.creationMessage)
		
		this.weather = weather
		this.weatherDuration = duration
	}
	
	def void changeTerrain(Terrain terrain, Integer duration) {
		if (terrain != this.terrain) {
			for (pokemon : allActivePokemon) {
				pokemon.ability.onTerrainChangeFunction?.apply(this, pokemon, terrain)
			}
		}
		
		this.terrain = terrain
		this.terrainDuration = duration
	}
	
	def boolean isGrounded(Pokemon pokemon) {
		if (pokemon.types.contains(Type.FLYING)) {
			return false
		}
		
		if (pokemon.ability.abilityDaoName == Abilities.LEVITATE) {
			return false
		}
		
		//TODO air balloon, iron ball, magnet rise, telekinesis, gravity, ingrain, smack down, thousand arrows, roost?
		
		return true
	}
	
	def boolean isWeatherDisabled() {
		return getAllActivePokemon().filter[alive]
			.findFirst[Util.in(it.ability.abilityDaoName, Abilities.AIR_LOCK, Abilities.CLOUD_NINE)] !== null
	}
}
