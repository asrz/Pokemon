package asrz.Pokemon.controllers.views

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.controllers.controls.HpBar
import asrz.Pokemon.controllers.controls.MoveButtons
import asrz.Pokemon.controllers.controls.XpBar
import asrz.Pokemon.model.Ability
import asrz.Pokemon.model.Item
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.Trainer
import asrz.Pokemon.model.enums.BattleSlot
import asrz.Pokemon.model.enums.BattleType
import asrz.Pokemon.model.enums.ItemCategory
import asrz.Pokemon.model.enums.PokedexEntryStatus
import asrz.Pokemon.model.enums.Stat
import asrz.Pokemon.model.enums.StatusAilment
import asrz.Pokemon.model.enums.Terrain
import asrz.Pokemon.model.enums.Weather
import asrz.Pokemon.util.BattleCalculator
import asrz.Pokemon.util.DialogUtil
import asrz.Pokemon.util.ImageLoader
import asrz.Pokemon.util.Util
import com.mongodb.client.model.Filters
import java.util.ArrayList
import java.util.List
import java.util.Map
import javafx.fxml.FXML
import javafx.scene.control.Button
import javafx.scene.control.ButtonBar.ButtonData
import javafx.scene.control.Label
import javafx.scene.control.ScrollPane
import javafx.scene.image.ImageView
import javafx.scene.layout.GridPane
import xtendfx.beans.FXBindable

@FXBindable
class BattleViewController extends BasicController {
	
	@FXML
	ScrollPane scrollPane
	@FXML
	Label textBox
	
	@FXML
	GridPane battleMenu
	
	@FXML
	ImageView pokemonSprite
	
	@FXML
	ImageView opponentSprite
	
	@FXML
	MoveButtons moveButtons
	
	@FXML
	HpBar playerHpBar
	@FXML
	HpBar opponentHpBar
	
	@FXML
	XpBar playerXpBar
	
	Trainer opponent
	Pokemon opponentPokemon
	
	Pokemon playerPokemon
	
	BattleType battleType
	
	@FXML
	Button itemButton
	@FXML
	Button pokemonButton
	@FXML
	Button runButton
	@FXML
	Label hpLabel
	
	List<Pokemon> battleParticipants = new ArrayList//used for awarding xp
	
	List<Pokemon> switchedInThisTurn = new ArrayList
	
	BattleCalculator battleCalculator
	
	Weather weather
	Integer weatherDuration
	
	Terrain terrain
	Integer terrainDuration
	
	int escapeAttempts = 0
	int round = 1
	
	new() {
		playerPokemon = player.team.firstLivingPokemon
		battleCalculator = new BattleCalculator(this)
	}
	
	def void battleTrainer(Trainer opponent) {
		this.opponent = opponent
		playerPokemon = player.team.firstLivingPokemon
		opponentPokemon = opponent.team.firstLivingPokemon
		initialize()
	}
	
	override initialize() {
		if (opponent !== null) {
			battleParticipants.clear()
			battleParticipants.add(playerPokemon)
			
			pokemonSprite.image = ImageLoader.loadImage(playerPokemon.backSprite)
			opponentSprite.image = ImageLoader.loadImage(opponentPokemon.frontSprite)
			
			textBox.text = ""
			addText("A Battle Begins!")
			if (opponent.wild) {
				addText("You encounter a wild %s", opponent.team.firstLivingPokemon.label)
			} else {
				addText("%s challenges you to a battle", opponent.label)
				addText("%s sends out %s", opponent.label, opponent.team.firstLivingPokemon.label)
			}
			
			scrollPane.vvalueProperty.bind(textBox.heightProperty)
			
			moveButtons.activePokemon = playerPokemon
			moveButtons.opponentPokemon = opponentPokemon
			moveButtons.moveButtonHandler = [ selectMove(move) ]
			moveButtons.initialize
			
			playerHpBar.pokemon = playerPokemon
			playerHpBar.initialize
			opponentHpBar.pokemon = opponentPokemon
			opponentHpBar.initialize
			
			playerXpBar.battleViewController = this
			playerXpBar.initialize
			
			escapeAttempts = 0
			round = 1
			
			battleCalculator.getInOrderOfSpeed(getAllPokemon()).forEach[ pokemon |
				if (pokemon?.ability?.switchInFunction !== null) {
					pokemon.ability.switchInFunction.apply(this, pokemon)
				}
			]
			
			enableButtons()
		}
	}
	
	private def HpBar getHpBar(Pokemon pokemon) {
		if (pokemon == playerPokemon) {
			return playerHpBar
		} else if (pokemon == opponentPokemon) {
			return opponentHpBar
		} else {
			throw new RuntimeException("Pokemon not on field took damage")
		}
	}
	
	private def BattleSlot getSlot(Pokemon pokemon) {
		if (pokemon == playerPokemon) {
			return BattleSlot.PLAYER_PRIMARY
		} else if (pokemon == opponentPokemon) {
			return BattleSlot.OPPONENT_PRIMARY
		} else {
			throw new RuntimeException("Unknown BattleSlot for pokémon: " + pokemon.label)
		}
	}
	
	private def Pokemon getPokemonBySlot(BattleSlot slot) {
		if (slot == BattleSlot.PLAYER_PRIMARY) {
			return playerPokemon
		} else if (slot == BattleSlot.OPPONENT_PRIMARY) {
			return opponentPokemon
		} else {
			throw new RuntimeException("Unhandled BattleSlot: " + slot.name)
		}
	}
	
	def List<Pokemon> getAllPokemon() {
		return Util.list(playerPokemon, opponentPokemon)
	}
	
	@FXML
	private def onRunButton() {
		if (!opponent.isWild()) {
			addText("You cannot run from a trainer battle!")
		}
		
		escapeAttempts = escapeAttempts + 1
		
		if (battleCalculator.canEscape(playerPokemon, opponentPokemon, escapeAttempts)) {
			addText("%s escapes from the wild %s", player.label, opponentPokemon.label)
			
			c.pokemonService.updatePokedexes(opponent.team.allPokemon, PokedexEntryStatus.SEEN)
			
			Application.setScene(SceneHandle.MAIN_VIEW, [ return new MainViewController ], [])
		} else {
			disableButtons()
			addText("%s cannot escape", playerPokemon.label)
			doBeginningOfRound()
			val opponentMove = chooseOpponentMove(opponent, opponentPokemon)
			val opponentTargets = getTargets(opponentPokemon, opponentMove, playerPokemon)
			useMove(opponentPokemon, opponentMove, opponentTargets, [
				if (!checkForBattleEnd()) {
					doEndOfRound([enableButtons()])
				}
			])
		}
	}
	
	@FXML
	private def onItemButton() {
		disableButtons()
		
		Application.setScene(SceneHandle.BAG_VIEW, [ new BagViewController() ], [])
	}
	
	def void useItem(Item item) {
		if (item === null) {
			enableButtons()
			return
		}
		
		if (item.category == ItemCategory.STANDARD_BALLS) {
			catchPokemon(item)
		}
	}
	
	def catchPokemon(Item pokeball) {
		doBeginningOfRound()
		
		val opponentMove = chooseOpponentMove(opponent, opponentPokemon)
		val opponentTargets = getTargets(opponentPokemon, opponentMove, playerPokemon)
		
		if (!opponent.wild) {
			addText("%s knocks away your %s", opponent.label, pokeball.label)
			addText("You cannot catch another trainer's Pokémon")
			useMove(opponentPokemon, opponentMove, opponentTargets, [
				if (!checkForBattleEnd()) {
					doEndOfRound([enableButtons()])
				}
			])
		} else {
			addText("%s throws %s %s", player.label, Util.getIndefiniteArticle(pokeball.label), pokeball.label)
			
			if (battleCalculator.catchSucceeds(pokeball, opponentPokemon)) {
				DialogUtil.createInfoDialog("%s caught the %s!", player.label, opponentPokemon.label).showAndWait().ifPresent[
					player.addPokemon(opponentPokemon)
					c.pokemonService.updatePokedexes(opponentPokemon, PokedexEntryStatus.CAUGHT)
				]
				Application.setScene(SceneHandle.MAIN_VIEW, [ return new MainViewController ], [c.playerService.saveGame(player)])
			} else {
				addText("%s escapes the %s", opponentPokemon.label, pokeball.label)
				useMove(opponentPokemon, opponentMove, opponentTargets, [
					if (!checkForBattleEnd()) {
						doEndOfRound([enableButtons()])
					}
				])
			}
		}
	}
	
	@FXML
	private def onPokemonButton() {
		Application.setScene(SceneHandle.TEAM_VIEW, [ new TeamViewController() ], [controller |
			val teamViewController = controller as TeamViewController 
			teamViewController.setBattleSlot(BattleSlot.PLAYER_PRIMARY)
			teamViewController.setSwitchCallback[ battleSlot, pokemon | switchPokemon(battleSlot, pokemon) ]
		])
	}
	
	def switchPokemon(BattleSlot slot, Pokemon newPokemon) {
		disableButtons()
		
		doBeginningOfRound()
		
		val opponentMove = chooseOpponentMove(opponent, opponentPokemon)
		val opponentTargets = getTargets(opponentPokemon, opponentMove, playerPokemon)
		
		switchedInThisTurn.add(newPokemon)
		
		if (slot == BattleSlot.PLAYER_PRIMARY) {
			addText("That's enough, %s", playerPokemon.label)
			updatePlayerPokemon(newPokemon)
			newPokemon?.ability?.switchInFunction?.apply(this, newPokemon)
			useMove(opponentPokemon, opponentMove, opponentTargets, [
				if (!checkForBattleEnd()) {
					doEndOfRound([enableButtons()])
				}
			])
		} else if (slot == BattleSlot.OPPONENT_PRIMARY) {
			opponentPokemon = newPokemon
			opponentSprite.image = ImageLoader.loadImage(newPokemon.frontSprite)
			opponentHpBar.pokemon = newPokemon
			moveButtons.opponentPokemon = newPokemon
		}
	}
	
	def updatePlayerPokemon(Pokemon newPokemon) {
		addText("Let's go, %s!", newPokemon.label)
		playerPokemon = newPokemon
		pokemonSprite.image = ImageLoader.loadImage(newPokemon.backSprite)
		playerHpBar.pokemon = newPokemon
		playerHpBar.initialize()
		moveButtons.activePokemon = newPokemon
		moveButtons.initialize()
		hpLabel.textProperty().bind(newPokemon.hpLabelProperty)
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
	
	def selectMove(Move playerMove) {
		escapeAttempts = 0
		
		disableButtons()
		
		doBeginningOfRound()
		
		val opponentMove = chooseOpponentMove(opponent, opponentPokemon)
		val opponentTargets = getTargets(opponentPokemon, opponentMove, playerPokemon)
		
		val playerTargets = getTargets(playerPokemon, playerMove, opponentPokemon)
		
		var playerGoesFirst = 
		if (playerMove.priority !== opponentMove.priority) {
			playerMove.priority > opponentMove.priority
		} else if (battleCalculator.getEffectiveSpeed(opponentPokemon) == battleCalculator.getEffectiveSpeed(playerPokemon)) {
			Util.randomInt(1,2) == 1
		} else {
			battleCalculator.getEffectiveSpeed(playerPokemon) > battleCalculator.getEffectiveSpeed(opponentPokemon)
		}
		
		if (playerGoesFirst) {
			useMove(playerPokemon, playerMove, playerTargets, [
				if (!checkForBattleEnd) {
					if (opponentPokemon.hp > 0) {
						useMove(opponentPokemon, opponentMove, opponentTargets, [
							if (!checkForBattleEnd()) {
								doEndOfRound([enableButtons()])
							}
						])
					} else {
						doEndOfRound([enableButtons()])
					}
				}
			])
		} else {
			useMove(opponentPokemon, opponentMove, opponentTargets, [
				if (!checkForBattleEnd()) {
					if (playerPokemon.hp > 0) {
						useMove(playerPokemon, playerMove, playerTargets, [
							if (!checkForBattleEnd()) {
								doEndOfRound([enableButtons()])
							}
						])
					} else {
						doEndOfRound([enableButtons()])
					}
				}
			])
		}
	}
	
	def doBeginningOfRound() {
		addText("--- Round %d ---", round)
	}
	
	def doEndOfRound(Runnable callback) {
		if (playerPokemon.isFainted()) {
			Application.setScene(SceneHandle.TEAM_VIEW, [ new TeamViewController() ], [controller |
				val teamViewController = controller as TeamViewController 
				teamViewController.setBattleSlot(BattleSlot.PLAYER_PRIMARY)
				teamViewController.setSwitchCallback[ battleSlot, pokemon | updatePlayerPokemon(pokemon) ]
			])
		}
		
		val pokemonInOrder = battleCalculator.getInOrderOfSpeed(getAllPokemon())
		doEndOfRound(pokemonInOrder.remove(0), pokemonInOrder, callback)
	}
	
	def void doEndOfRound(Pokemon pokemon, List<Pokemon> remainingPokemon, Runnable callback) {
		val ailmentsToProcess = new ArrayList(pokemon.volatileAilments.entrySet)
		
		pokemon?.ability?.endOfTurnFunction?.apply(this, pokemon)
		
		if (ailmentsToProcess.empty) {
			if (remainingPokemon.empty) {
				callback.run()
			} else {
				doEndOfRound(remainingPokemon.remove(0), remainingPokemon, callback)
			}
		} else {
			val nextAilmentEntry = ailmentsToProcess.remove(0)
			processAilmentEndOfTurn(pokemon, nextAilmentEntry.key, nextAilmentEntry.value, ailmentsToProcess, callback)
		}
		
		switchedInThisTurn.clear()
	}
	
	def void processAilmentEndOfTurn(Pokemon pokemon, StatusAilment ailment, BattleSlot inflicterSlot, List<Map.Entry<StatusAilment, BattleSlot>> ailmentsToProcess, Runnable callback) {
		if (ailment == StatusAilment.LEECH_SEED) {
			val damage = pokemon.hp / 8
			addText("%s is damaged by Leech Seed", pokemon.label)
			val inflicter = getPokemonBySlot(inflicterSlot)
			pokemon.getHpBar.applyDamage(damage, [
				addText("%s is healed by Leech Seed", inflicter.label)
				inflicter.getHpBar.applyDamage(-damage, [
					if (ailmentsToProcess.empty) {
						callback.run()
					} else {
						val nextAilmentEntry = ailmentsToProcess.remove(0)
						processAilmentEndOfTurn(pokemon, nextAilmentEntry.key, nextAilmentEntry.value, ailmentsToProcess, callback)
					}
				])
			])
		} else {
			throw new RuntimeException("Unhandled end of turn ailment: " + ailment.name)
		}
	}
	
	def chooseOpponentMove(Trainer trainer, Pokemon pokemon) {
		//TODO trainer AI
		return Util.randomChoice(opponentPokemon.moves)
	}
	
	private def boolean checkForBattleEnd() {
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
		player.team.healAllPokemon()
		
		val itemDao = database.getItems(Filters.eq("name", "poke-ball")).first
		val item = Item.fromApi(itemDao, player.languageName)
		player.itemBag.addItems(item, 30)
		
		c.pokemonService.updatePokedexes(opponent.team.allPokemon, PokedexEntryStatus.SEEN)
		
		Application.setScene(SceneHandle.MAIN_VIEW, [ return new MainViewController ], [c.playerService.saveGame(player)])
	}
	
	def loseBattle() {
		val dialog = DialogUtil.createYesNoDialog(String.format("%s has no more Pokémon. Would you like to try again?", player.label))
		dialog.show()
		dialog.resultProperty.addListener[ resultProperty, oldButtonType, buttonType |
			if(buttonType.buttonData == ButtonData.YES) {
				player.team.healAllPokemon()
				opponent.team.healAllPokemon()
				battleTrainer(opponent)
			} else {
				player.team.healAllPokemon()
				
				c.pokemonService.updatePokedexes(opponent.team.allPokemon, PokedexEntryStatus.SEEN)
				
				Application.setScene(SceneHandle.MAIN_VIEW, [ return new MainViewController ], [c.playerService.saveGame(player)])
			}
		]
	}
	
	def useMove(Pokemon user, Move move, List<BattleSlot> slotTargets, Runnable callback) {
		if (user.volatileAilments.remove(StatusAilment.FLINCH) !== null) {
			addText("%s flinched!", user.label)
			callback.run()
			return
		}
		
		addText("%s uses %s", user.label, move.label)
		move.pp = move.pp - 1
		
		for (Pokemon target : slotTargets.map[getPokemonBySlot]) {
			doHit(user, move, target, 0, callback)
		}
	}
	
	def void doHit(Pokemon user, Move move, Pokemon target, int hits, Runnable callback) {
		val minHits = move.minHits ?: 0
		val maxHits = move.maxHits ?: 1
		
		if (hits == maxHits) {
			if (minHits > 1) {
				addText("It hits %d times")
			}
			callback.run
			return
		}
		
		if (minHits > 1 && hits < minHits) {
			applyMove(user, move, target, [
				doHit(user, move, target, hits+1, callback)
			])
		}
		
		if (hits < maxHits) {
			if (!battleCalculator.doesMoveHit(user, move, target, null, null, weather)) {
				if (minHits <= 1) {
					addText("%s avoided the attack", target.label)
				} else {
					addText("It hits %d times", hits)
				}
				callback.run()
				return
			} else {
				applyMove(user, move, target, [
					doHit(user, move, target, hits+1, callback)
				])
			}
		}
		
	}
	
	def applyMove(Pokemon user, Move move, Pokemon target, Runnable callback) {
		if(user.ability?.getDamageModifier(user, move, target) ?: 1.0 != 1.0) {
			showAbility(user, user.ability)
		}
		
		val damage = battleCalculator.getDamage(user, move, target)
		if (damage !== null) {
			val typeModifier = battleCalculator.getTypeModifier(target, move)
			if (typeModifier == 0) {
				addText("It has no effect")
			} else if (typeModifier < 1) {
				addText("It's not very effective")
			} else if (typeModifier > 1) {
				addText("It's super effective!")
			}
			
//			addText("It deals %d damage", damage)
			
			val hpBar = target == playerPokemon ? playerHpBar : opponentHpBar
			hpBar.applyDamage(damage, [
				applyMoveEffects(user, move, target, callback)
			])
		} else {
			applyMoveEffects(user, move, target, callback)
		}
	}
	
	def showAbility(Pokemon pokemon, Ability ability) {
		addText("%s's %s ability activates", pokemon.label, ability.label)
	}
	
	def void applyMoveEffects(Pokemon user, Move move, Pokemon target, Runnable callback) {
		if (target.hp == 0) {
			addText("%s has fainted", target.label)
			if (user == playerPokemon && target == opponentPokemon) {
				c.pokemonService.updatePokedexes(target, PokedexEntryStatus.SEEN)
				assignXp(target, callback)
			} else {
				callback.run()
			}
		} else {
			if (battleCalculator.ailmentApplies(user, move, target)) {
				if (move.ailment.volatile && !target.volatileAilments.containsKey(move.ailment)) {
					addText(move.ailment.getMessage(target, user))
					target.volatileAilments.put(move.ailment, user.getSlot)
				} else if (target.ailment === null) {
					addText(move.ailment.getMessage(target, user))
					target.ailment = move.ailment
				}
			}
			
			if (battleCalculator.flinchApplies(user, move, target)) {
				target.volatileAilments.put(StatusAilment.FLINCH, user.getSlot);
			}
			
			if (battleCalculator.statChangesApply(move)) {
				for (Stat stat : move.statChanges.keySet()) {
					val int oldValue = target.tempStatChanges.getOrDefault(stat, 0)
					val valueChange = move.statChanges.get(stat)
					if (oldValue == 6 && valueChange > 0) {
						addText("%s's %s cannot be raised any further", target.label, stat.label)
					} else if (oldValue == -6 && valueChange < 0) {
						addText("%s's %s cannot be lowered any further", target.label, stat.label)
					}
					var newValue = oldValue + valueChange
					if (newValue > 6) {
						newValue = 6
					} else if (newValue < -6) {
						newValue = -6
					}
					
					val trueChange = newValue - oldValue
					if (trueChange >= 3) {
						addText("%s's %s rose drastically!", target.label, stat.label)
					} else if (trueChange == 2) {
						addText("%s's %s rose sharply!", target.label, stat.label)
					} else if (trueChange == 1) {
						addText("%s's %s rose", target.label, stat.label)
					} else if (trueChange == -1) {
						addText("%s's %s fell", target.label, stat.label)
					} else if (trueChange == -2) {
						addText("%s's %s harshly fell!", target.label, stat.label)
					} else if (trueChange <= -3) {
						addText("%s's %s severely fell!", target.label, stat.label)
					}
					
					target.tempStatChanges.put(stat, newValue)
				}
			}
			callback.run()
		}
	}
	
	def void assignXp(Pokemon faintingPokemon, Runnable callback) {
		val trainerModifier = opponent.wild ? 1.0 : 1.5
		val int xpPool = Math.floor(((faintingPokemon.species.baseExperience * faintingPokemon.level) / 7.0) * trainerModifier) as int
		//TODO exp share, lucky egg
		
		val xpShare = xpPool / battleParticipants.filter[alive].size()
		battleParticipants.remove(playerPokemon)
		
		if (playerPokemon.alive) {
			assignXp(playerPokemon, xpShare, [callback.run])
		} else if (!battleParticipants.filter[alive].isEmpty) {
			assignXp(battleParticipants.remove(0), xpShare, [callback.run])
		} else {
			callback.run()
		}
	}
	
	def void assignXp(Pokemon pokemon, int xpShare, Runnable callback) {
		addText("%s gains %d experience points", pokemon.label, xpShare)
		playerXpBar.addXp(pokemon, xpShare, pokemon == playerPokemon, [
			if (!battleParticipants.isEmpty) {
				assignXp(battleParticipants.remove(0), xpShare, callback)
			} else {
				callback.run()
			}
		])
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
	
	def addText(String text, Object...args) {
		textBox.text = textBox.text + "\n" + String.format(text, args)
	}
	
	def void changeWeather(Weather weather, Integer duration) {
		if (this.weather !== null && this.weather.isPrimordial()) {
			if (weather !== null && !weather.isPrimordial()) {
				return
			}
		}
		
		this.weather = weather
		this.weatherDuration = duration
	}
	
	def changeTerrain(Terrain terrain, Integer duration) {
		this.terrain = terrain
		this.terrainDuration = duration
	}
}
