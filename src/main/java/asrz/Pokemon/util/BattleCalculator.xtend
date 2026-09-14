package asrz.Pokemon.util

import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.model.Abilities
import asrz.Pokemon.model.Items
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.Moves
import asrz.Pokemon.model.Pokeball
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.enums.BattleSlot
import asrz.Pokemon.model.enums.MoveCategory
import asrz.Pokemon.model.enums.MoveDamageClass
import asrz.Pokemon.model.enums.Stat
import asrz.Pokemon.model.enums.StatusAilment
import asrz.Pokemon.model.enums.Terrain
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.model.enums.Weather
import java.util.Comparator
import java.util.Map.Entry

import static asrz.Pokemon.model.enums.Stat.*
import asrz.Pokemon.model.PokemonSpecies

class BattleCalculator {

	BattleViewController battleViewController
	
	new(BattleViewController controller) {
		this.battleViewController = controller
	}
	
	def Integer getDamage(Pokemon user, Move move, Pokemon target, boolean ignoreAbilities) {
		if (move.power === null) {
			return null
		}
		
		val offensiveAlly = battleViewController.getAlly(user)
		val defensiveAlly = battleViewController.getAlly(target)
		
		val doesMoveCrit = doesMoveCrit(user, move, target, ignoreAbilities)
		
		val level = user.level
		val critModifier = getCritDamageModifier(user, move, target, doesMoveCrit)
		val power = move.power
		var attackStat = getAttackStat(user, move, doesMoveCrit)
		
		if (target.ability?.abilityDaoName == Abilities.UNAWARE) {
			if (move.physical) {
				attackStat = user.attack //ignore stat changes
			} else if (move.special) {
				attackStat = user.specialAttack
			}
		}
		
		attackStat = Math.floor(
			attackStat * 
			(user.ability?.offensiveAttackStatModifierFunction?.apply(battleViewController, user, move) ?: 1.0) *  //e.g. huge power
			(target.ability?.defensiveAttackStatModifierFunction?.apply(battleViewController, target, move, ignoreAbilities) ?: 1.0) * //e.g. thick fat
			(offensiveAlly?.ability?.offensiveAllyAttackStatModifierFunction?.apply(battleViewController, user, move) ?: 1.0)
		) as int
		var defenseStat = getDefenseStat(target, move, doesMoveCrit)
		
		if (user.ability?.abilityDaoName == Abilities.UNAWARE) {
			if (move.physical) {
				defenseStat = target.defense
			} else if (move.special) {
				defenseStat = target.specialDefense
			}
		}
		
		val defenseWeatherModifier = 
		if (battleViewController.weather == Weather.SANDSTORM && Util.in(Type.ROCK, target.types) && move.special) {
			1.5
		} else if (battleViewController.weather == Weather.SNOW && Util.in(Type.ICE, target.types) && move.physical) {
			1.5
		} else {
			1.0
		}
		
		defenseStat = Math.floor(
			defenseStat *
			defenseWeatherModifier *
			(target.ability?.defensiveDefenseStatModifierFunction?.apply(battleViewController, user, move, target, ignoreAbilities) ?: 1.0) * //e.g. marvel scale
			(defensiveAlly?.ability?.defensiveAllyDefenseStatModifierFunction?.apply(battleViewController, user, move, target, ignoreAbilities) ?: 1.0)
		) as int
		
		val stabModifier = getStabModifier(user, move)
		var typeModifier = Type.getDamageModifier(move.type, target.types)
		
		if (user.ability?.abilityDaoName == Abilities.SCRAPPY && typeModifier == 0 && Util.in(move.type, Type.NORMAL, Type.FIGHTING) && target.types.contains(Type.GHOST)) {
			val effectiveTypes = target.types.filter[type | type != Type.GHOST].toList
			typeModifier = Type.getDamageModifier(move.type, effectiveTypes)
		}
		
		val abilityModifier = user.ability?.offensiveDamageModifierFunction?.apply(battleViewController, user, move, target, doesMoveCrit) ?: 1.0
		val randomModifier = Util.randomInt(85, 100) as double / 100.0
		val targetsModifier = battleViewController.getTargets(user, move, target).size > 1 ? 0.75 : 1.0
		val burnModifier = getBurnModifier(user, move, target)
		val otherModifier = 1.0 //TODO
		val weatherModifier = getWeatherModifier(user, move, target)
		val terrainModifier = getTerrainModifier(user, move, target)
		val glaiveRushModifier = 1.0 //TODO
		val zMoveModifier = 1.0 //TODO
		val chargeModifier = getChargeModifier(user, move, target)
		
		var damageD = (((((2 * level) / 5) + 2) * power * (attackStat / defenseStat)) / 50 + 2) * targetsModifier * weatherModifier * terrainModifier * glaiveRushModifier * critModifier * stabModifier * typeModifier * abilityModifier * burnModifier * otherModifier * zMoveModifier * randomModifier * chargeModifier
		
		for (pokemon : battleViewController.allActivePokemon.filter[alive].filter[pokemon | pokemon.ability.globalDamageModifierFunction !== null]) {
			damageD *= pokemon.ability.globalDamageModifierFunction?.apply(battleViewController, user, move, target)
		}
		
		val damageDealt = Math.min(Math.floor(damageD), target.hp) as int
		
		val damageTaken = target?.ability?.defensiveDamageFunction?.apply(battleViewController, user, move, target, damageDealt, ignoreAbilities) ?: damageDealt
		
		return damageTaken
	}
	
	def double getChargeModifier(Pokemon user, Move move, Pokemon target) {
		if (move.type == Type.ELECTRIC && user.volatileStatusAilments.remove(StatusAilment.CHARGE) !== null) {
			return 2.0
		}
		
		return 1.0
	}
	
	def getWeatherModifier(Pokemon user, Move move, Pokemon target) {
		if (battleViewController.weatherDisabled) {
			return 1.0
		}
		
		if (battleViewController.weather == Weather.RAIN) {
			if (move.type == Type.WATER) {
				return 1.5
			} else if (move.type == Type.FIRE) {
				return 0.5
			}
		} else if (battleViewController.weather == Weather.HARSH_SUNLIGHT) {
			if (move.type == Type.FIRE || move.moveDaoName == 'hydro-steam') {
				return 1.5
			} else if (move.type == Type.WATER) {
				return 0.5
			}
		}
		
		return 1.0
	}
	
	def getTerrainModifier(Pokemon user, Move move, Pokemon target) {
		if (battleViewController.terrain === null) {
			return 1.0
		}
		
		if (battleViewController.terrain == Terrain.GRASSY && move.type == Type.GRASS && battleViewController.isGrounded(user)) {
			return 1.3
		} else if (battleViewController.terrain == Terrain.ELECTRIC && move.type == Type.ELECTRIC && battleViewController.isGrounded(user)) {
			return 1.3
		} else if (battleViewController.terrain == Terrain.MISTY && move.type == Type.DRAGON && battleViewController.isGrounded(target)) {
			return 0.5
		} else if (battleViewController.terrain == Terrain.PSYCHIC && move.type == Type.PSYCHIC && battleViewController.isGrounded(user)) {
			return 1.3
		}
		
		return 1.0
	}
	
	def double getBurnModifier(Pokemon user, Move move, Pokemon target) {
		if (move.moveDaoName == 'facade') {
			return 1.0
		}
		
		if (user.statusAilment == StatusAilment.BURN && move.damageClass == MoveDamageClass.PHYSICAL && user?.ability?.abilityDaoName != Abilities.GUTS) {
			return 0.5
		}
		
		return 1.0
	}
	
	def double getStabModifier(Pokemon pokemon, Move move) {
		var stabModifier = 1.0
		if (pokemon.types.contains(move.type)) {
			stabModifier = 1.5
		}
		
		stabModifier = pokemon.ability?.offensiveStabBonusFunction?.apply(battleViewController, pokemon, move) ?: stabModifier
		
		return stabModifier
	}
	
	def getDefenseStat(Pokemon pokemon, Move move, boolean doesMoveCrit) {
		switch(move.damageClass) {
			case PHYSICAL: return pokemon.getEffectiveDefense(doesMoveCrit)
			case SPECIAL: return pokemon.getEffectiveSpecialDefense(doesMoveCrit)
			case STATUS: return null
		}
	}
	
	def getAttackStat(Pokemon pokemon, Move move, boolean doesMoveCrit) {
		switch(move.damageClass) {
			case PHYSICAL: return pokemon.getEffectiveAttack(doesMoveCrit)
			case SPECIAL: return pokemon.getEffectiveSpecialAttack(doesMoveCrit)
			case STATUS: return null
		}
	}
	
	def boolean doesMoveHit(Pokemon user, Move move, Pokemon target, Pokemon userAlly, Pokemon targetAlly, Weather weather, boolean ignoreAbilities) {
		if (!ignoreAbilities && Util.in(move.moveDaoName, 'self-destruct', 'explosion', 'mind-blown', 'misty-explosion')) {
			for (pokemon : Util.list(user, target, userAlly, targetAlly)) {
				if (pokemon?.ability?.abilityDaoName == Abilities.DAMP) {
					battleViewController.showAbility(pokemon, pokemon.ability)
					return false
				}
			}
		}
		
		if (target.ability.isImmuneToMoveFunction?.apply(battleViewController, user, move, target, ignoreAbilities) ?: false) {
			return false
		} else if (userAlly?.ability?.isAllyImmuneToMoveFunction?.apply(battleViewController, user, move, target, ignoreAbilities) ?: false) {
			return false
		}
		
		if (user.ability.abilityDaoName == Abilities.PRANKSTER && move.status && Util.in(Type.DARK, target.types)) {
			return false //DARK types immune to prankster moves
		}
		
		if (Util.in(move.moveDaoName, Moves.POWDER_MOVES) && Util.in(Type.GRASS, target.types)) {
			return false //GRASS types immune to powder moves
		} 
		
		if (target.ability?.abilityDaoName == Abilities.TELEPATHY && battleViewController.getAlly(user) == target) {
			battleViewController.showAbility(target, target.ability)
			return false
		}
		
		if (user.ability?.abilityDaoName == Abilities.NO_GUARD || target.ability?.abilityDaoName == Abilities.NO_GUARD) {
			return true
		}
		
		if (move.accuracy === null) {
			//swift, etc.
			return true
		}
		
		var accuracy = move.accuracy
		
		if (target.ability?.abilityDaoName == Abilities.WONDER_SKIN && move.status) {
			accuracy = 50
		}
		
		var double accuracyModifier = user.getTempStatModifier(ACCURACY)
		var double evasionModifier = 1.0 / target.getTempStatModifier(EVASION)
		
		if (target.ability?.abilityDaoName == Abilities.UNAWARE) {
			accuracyModifier = 1.0
		}
		if (user.ability?.abilityDaoName == Abilities.UNAWARE) {
			evasionModifier = 1.0
		}
		
		val accuracy2 = accuracy * accuracyModifier * evasionModifier
		val offensiveAccuracyModifier = user?.ability?.offensiveAccuracyModifierFunction?.apply(user, move, target) ?: 1d
		val defensiveAccuracyModifier = target?.ability?.defensiveAccuracyModifierFunction?.apply(user, move, target, weather, ignoreAbilities) ?: 1d
		val offAllyAccuracyModifier = userAlly?.ability?.offensiveAllyAccuracyModifierFunction?.apply(user, move, target) ?: 1d
		
		val totalAccuracy = accuracy2 * offensiveAccuracyModifier * defensiveAccuracyModifier * offAllyAccuracyModifier
		
		return Util.randomPercentage <= totalAccuracy
	}
	
	def double getCritDamageModifier(Pokemon user, Move move, Pokemon target, boolean doesMoveCrit) {
		var critModifier = 1.0
		
		if (doesMoveCrit) {
			return 1.5
		}
		
		return critModifier
	}
	
	def boolean doesMoveCrit(Pokemon user, Move move, Pokemon target, Boolean ignoreAbilities) {
		var doesCrit = false
		
		val critBoosts = user.tempStatChanges.getOrDefault(Stat.CRIT_RATE, 0) + (user.ability.offensiveCritBoostsFunction?.apply(user, move, target) ?: 0)
		if (critBoosts == 0) {
			doesCrit = Util.randomInt(1, 24) == 1
		} else if (critBoosts == 1) {
			doesCrit = Util.randomInt(1, 8) == 1
		} else if (critBoosts == 2) {
			doesCrit = Util.randomInt(1, 2) == 1
		} else if (critBoosts >= 3) {
			doesCrit = true
		}
		
		val offensiveMoveCrits = user?.ability?.offensiveMoveCritFunction?.apply(user, move, target, doesCrit) ?: doesCrit
		val defensiveMoveCrits = user?.ability?.defensiveMoveCritFunction?.apply(user, move, target, ignoreAbilities) ?: doesCrit
		
		
		doesCrit = offensiveMoveCrits && defensiveMoveCrits
		
		if (doesCrit) {
			battleViewController.addText("It's a critical hit!")
		}
		
		return doesCrit
	}
	
	def ailmentApplies(Pokemon user, Move move, Pokemon target, boolean ignoreAbilities) {
		if (move.statusAilment === null) {
			return false
		}
		
		for (Type type : target.types) {
			if (type !== null && type.isImmuneTo(move.statusAilment)) {
				if (move.statusAilment == StatusAilment.POISON && user.ability.abilityDaoName == Abilities.CORROSION) {
					return true
				}
				return false
			}
		}
		
		if (!move.statusAilment.volatile && target.statusAilment !== null) {
			return false
		}
		
		if (target.ability.isImmuneToStatusAilmentFunction?.apply(battleViewController, target, move.statusAilment, ignoreAbilities) ?: false) {
			return false
		}
		
		val ally = battleViewController.getAlly(target)
		if (ally?.ability?.isAllyImmuneToStatusAilmentFunction?.apply(battleViewController, target, move.statusAilment, ignoreAbilities) ?: false) {
			return false
		}
		
		if (user.ability.abilityDaoName == Abilities.SHEER_FORCE && Util.in(move.moveDaoName, Moves.SHEER_FORCE_MOVES)) {
			return false
		}
		
		if (move.category == MoveCategory.AILMENT) {
			return true
		}
		
		if (target.ability.abilityDaoName == Abilities.SHIELD_DUST) {
			return false
		}
		if (user.ability.abilityDaoName == Abilities.SERENE_GRACE) {
			return Util.randomPercentage <= (move.ailmentChance * 2)
		}
		
		return Util.randomPercentage <= move.ailmentChance
	}
	
	def statChangesApply(Pokemon user, Move move, Pokemon target) {
		if (user.ability?.abilityDaoName == Abilities.SHEER_FORCE && Util.in(move.moveDaoName, Moves.SHEER_FORCE_MOVES)) {
			return false
		}
		
		if (move.category == MoveCategory.NET_GOOD_STATS) {
			return true
		}
		
		if (target.ability.abilityDaoName == Abilities.SHIELD_DUST) {
			return false
		}
		
		if (user.ability.abilityDaoName == Abilities.SERENE_GRACE) {
			return Util.randomPercentage <= (move.statChance * 2)
		}
		
		return move.statChance !== null && Util.randomPercentage <= move.statChance
	}
	
	def flinchApplies(Pokemon user, Move move, Pokemon target, boolean ignoreAbilities) {
		if (user.ability.abilityDaoName == Abilities.SHEER_FORCE && Util.in(move.moveDaoName, Moves.SHEER_FORCE_MOVES)) {
			return false
		}
		
		var flinchChance = move.flinchChance
		
		flinchChance = user.ability.flinchChanceFunction?.apply(user, move, target, flinchChance) ?: flinchChance
		
		if (target.ability.isImmuneToStatusAilmentFunction?.apply(battleViewController, target, StatusAilment.FLINCH, ignoreAbilities) ?: false) {
			return false
		}
		
		if (flinchChance < 100 && target.ability.abilityDaoName == Abilities.SHIELD_DUST) {
			return false
		}
		if (user.ability.abilityDaoName == Abilities.SERENE_GRACE) {
			return Util.randomPercentage <= (flinchChance * 2)
		}
		
		return Util.randomPercentage <= flinchChance
	}
	
	def getInOrderOfSpeed(Iterable<Entry<BattleSlot, Pokemon>> pokemon) {
		return pokemon.sortWith(Comparator.comparingInt[value.getEffectiveSpeed])
	}
	
	def int getEffectiveAttack(Pokemon pokemon, boolean doesMoveCrit) {
		return pokemon.getEffectiveStat(pokemon.attack, Stat.ATTACK, doesMoveCrit)
	}
	
	def int getEffectiveDefense(Pokemon pokemon, boolean doesMoveCrit) {
		return pokemon.getEffectiveStat(pokemon.defense, DEFENSE, doesMoveCrit)
	}
	
	def int getEffectiveSpecialAttack(Pokemon pokemon, boolean doesMoveCrit) {
		return pokemon.getEffectiveStat(pokemon.specialAttack, SPECIAL_ATTACK, doesMoveCrit)
	}
	
	def int getEffectiveSpecialDefense(Pokemon pokemon, boolean doesMoveCrit) {
		return pokemon.getEffectiveStat(pokemon.specialDefense, SPECIAL_DEFENSE, doesMoveCrit)
	}
	
	def int getEffectiveSpeed(Pokemon pokemon) {
		var speed = pokemon.getEffectiveStat(pokemon.speed, SPEED)
		
		if (pokemon.statusAilment == StatusAilment.PARALYSIS && pokemon.ability.abilityDaoName != Abilities.QUICK_FEET) {
			speed = speed / 2
		}
		
		speed = Math.floor(speed * (pokemon.ability?.speedModifierFunction?.apply(battleViewController, pokemon) ?: 1.0)) as int
		
		return speed
	}
	
	def canEscape(Pokemon playerPokemon, Pokemon wildPokemon, int escapeAttempts) {
		val isTrapped = wildPokemon.ability?.isTrappedFunction?.apply(battleViewController, wildPokemon, playerPokemon) ?: false
		
		if (isTrapped) {
			battleViewController.showAbility(wildPokemon, wildPokemon.ability)
			return false
		}
		
		val playerSpeed = getEffectiveSpeed(playerPokemon)
		val wildSpeed = getEffectiveSpeed(wildPokemon)
		
		if (playerSpeed > wildSpeed) {
			return true
		}
		
		val odds = Math.floor((playerSpeed * 32) / (wildSpeed/4.0)) + 30 * escapeAttempts
		
		return Util.randomInt(1, 256) <= odds
	}
	
	def boolean catchSucceeds(Pokeball pokeball, Pokemon user, Pokemon target) {
		if (pokeball.name == Items.MASTER_BALL) {
			return true
		}
		
		val darkGrassModifier = 1 //TODO
		var modifiedRate = target.species.captureRate + (pokeball.catchRateAdditiveFunction?.apply(battleViewController, user, target) ?: 0)
		if (modifiedRate < 0) {
			modifiedRate = 1
		} else if (modifiedRate > 255) {
			modifiedRate = 255
		}
		var ballBonus = pokeball.catchRateModifierFunction?.apply(battleViewController, user, target) ?: 1.0
		if (Util.in(target.species.pokemonSpeciesDaoName, PokemonSpecies.ULTRA_BEASTS) && pokeball.itemDaoName !== Items.BEAST_BALL) {
			ballBonus = 0.1
		}
		
		val badgePenalty = 1 //TODO
		val levelBonus = Math.max((36 - 2 * target.level)/10, 1)
		val statusBonus = getCatchStatusBonus(target.statusAilment)
		
		val long modifiedCatchRate = (Math.floor(((3.0 * target.maxHp - 2 * target.hp)/(3 * target.maxHp)) * 4096 * darkGrassModifier * modifiedRate * ballBonus * badgePenalty) * levelBonus * statusBonus) as long
		val int r = Util.randomInt(1, 255 * 4096)
		
		return r <= modifiedCatchRate
	}
	
	private def double getCatchStatusBonus(StatusAilment statusAilment) {
		if (statusAilment === null) {
			return 1.0
		} else if (Util.in(statusAilment, StatusAilment.SLEEP, StatusAilment.FREEZE)) {
			return 2.5
		} else if (Util.in(statusAilment, StatusAilment.PARALYSIS, StatusAilment.POISON, StatusAilment.BURN)) {
			return 1.5
		} else {
			return 1.0
		}
	}
	
	// negative drain is recoil
	def Integer getDrain(Pokemon user, Move move, Pokemon target, Integer damage) {
		if (move.drain === null) {
			return null
		}
		
		var drain = Math.floor(damage * (move.drain / 100.0)) as int
		
		if (drain > 0 && target.ability?.abilityDaoName == Abilities.LIQUID_OOZE) {
			drain = -drain
		}
		
		if (drain > 0 && drain + user.hp > user.maxHp) {
			drain = user.maxHp - user.hp
		} else if (drain < 0 && user.hp + drain < 0) {
			drain = -user.hp
		}
		
		val drainModifier = user.ability?.offensiveDrainModifierFunction?.apply(user, move, target, drain) ?: 1.0
		
		if (move.moveDaoName != Moves.STRUGGLE) {
			drain = Math.floor(drain * drainModifier) as int
		}
		
		return drain
	}
	
	def Integer getHealing(Pokemon user, Move move, Pokemon target) {
		if (move.healing === null) {
			return null
		}
		
		var healing = Math.floor(user.maxHp * (move.healing / 100.0)) as int
		
		if (healing + user.hp > user.maxHp) {
			healing = user.maxHp - user.hp
		}
		
		return healing
	}
	
}