package asrz.Pokemon.util

import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.model.Item
import asrz.Pokemon.model.Items
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.enums.MoveCategory
import asrz.Pokemon.model.enums.Stat
import asrz.Pokemon.model.enums.StatusAilment
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.model.enums.Weather
import java.util.List

import static asrz.Pokemon.model.enums.Stat.*
import asrz.Pokemon.model.enums.MoveDamageClass

class BattleCalculator {

	BattleViewController battleViewController
	
	new(BattleViewController controller) {
		this.battleViewController = controller
	}
	
	def Integer getDamage(Pokemon user, Move move, Pokemon target) {
		if (move.power === null) {
			return null
		}
		
		val doesMoveCrit = doesMoveCrit(user, move, target)
		
		val level = user.level
		val critModifier = getCritDamageModifier(user, move, target, doesMoveCrit)
		val power = move.power
		val attackStat = getAttackStat(user, move, doesMoveCrit)
		val defenseStat = getDefenseStat(target, move, doesMoveCrit)
		
		val stabModifier = getStabModifier(user, move)
		val typeModifier = getTypeModifier(target, move)
		val abilityModifier = user.ability?.getDamageModifier(user, move, target) ?: 1.0
		val randomModifier = Util.randomInt(85, 100) as double / 100.0
		val targetsModifier = battleViewController.getTargets(user, move, target).size > 1 ? 0.75 : 1.0
		val burnModifier = getBurnModifier(user, move, target)
		val otherModifier = 1.0 //TODO
		val weatherModifier = getWeatherModifier(user, move, target)
		val glaiveRushModifier = 1.0 //TODO
		val zMoveModifier = 1.0 //TODO
		
		val damageD = (((((2 * level) / 5) + 2) * power * (attackStat / defenseStat)) / 50 + 2) * targetsModifier * weatherModifier * glaiveRushModifier * critModifier * stabModifier * typeModifier * abilityModifier * burnModifier * otherModifier * zMoveModifier * randomModifier
		
		val damageDealt = Math.min(Math.floor(damageD), target.hp) as int
		
		val damageTaken = target?.ability?.defensiveDamageFunction?.apply(user, move, target, damageDealt) ?: damageDealt
		
		if (damageDealt != damageTaken) {
			//TODO ability anouncement
		}
		
		return damageDealt
	}
	
	def getWeatherModifier(Pokemon user, Move move, Pokemon target) {
		if (!battleViewController.getAllPokemon().filter[Util.in(it?.ability?.abilityDaoName, "cloud-nine", "air-lock")].empty) {
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
	
	def double getBurnModifier(Pokemon user, Move move, Pokemon target) {
		if (move.moveDaoName == 'facade') {
			return 1.0
		}
		
		if (user.ailment == StatusAilment.BURN && move.damageClass == MoveDamageClass.PHYSICAL && user?.ability?.abilityDaoName != 'guts') {
			return 0.75
		}
		
		return 1.0
	}
	
	def double getTypeModifier(Pokemon pokemon, Move move) {
		var modifier = 1.0
		for (Type type : pokemon.types) {
			if (type.isImmuneTo(move.type)) {
				modifier *= 0
			} else if (type.isResistantTo(move.type)) {
				modifier *= 0.5
			} else if (type.isWeakTo(move.type)) {
				modifier *= 2.0
			}
		}
		
		return modifier
	}
	
	def double getStabModifier(Pokemon pokemon, Move move) {
		if (pokemon.types.contains(move.type)) {
			return 1.5
		}
		
		return 1.0
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
	
	def boolean doesMoveHit(Pokemon user, Move move, Pokemon target, Pokemon userAlly, Pokemon targetAlly, Weather weather) {
		if (move.accuracy === null) {
			return true
		}
		
		val double accuracyModifier = user.getTempStatModifier(ACCURACY)
		val double evasionModifier = 1.0 / target.getTempStatModifier(EVASION)
		
		val accuracy = move.accuracy * accuracyModifier * evasionModifier
		val offensiveAccuracyModifier = user?.ability?.offensiveAccuracyModifierFunction?.apply(user, move, target) ?: 1d
		val defensiveAccuracyModifier = target?.ability?.defensiveAccuracyModifierFunction?.apply(user, move, target, weather) ?: 1d
		val offAllyAccuracyModifier = userAlly?.ability?.spectatorAccuracyModifierFunction?.apply(user, move, target) ?: 1d
		val defAllyAccuracyModifier = targetAlly?.ability?.spectatorAccuracyModifierFunction?.apply(user, move, target) ?: 1d
		
		val totalAccuracy = accuracy * offensiveAccuracyModifier * defensiveAccuracyModifier * offAllyAccuracyModifier * defAllyAccuracyModifier
		
		return Util.randomPercentage <= totalAccuracy
	}
	
	def double getCritDamageModifier(Pokemon user, Move move, Pokemon target, boolean doesMoveCrit) {
		var critModifier = 1.0
		
		if (doesMoveCrit) {
			return 1.5
		}
		
		return critModifier
	}
	
	def boolean doesMoveCrit(Pokemon user, Move move, Pokemon target) {
		var doesCrit = false
		
		val critBoosts = user.tempStatChanges.getOrDefault(Stat.CRIT_RATE, 0)
		if (critBoosts == 0) {
			doesCrit = Util.randomInt(1, 24) == 1
		} else if (critBoosts == 1) {
			doesCrit = Util.randomInt(1, 8) == 1
		} else if (critBoosts == 2) {
			doesCrit = Util.randomInt(1, 2) == 1
		} else if (critBoosts >= 3) {
			doesCrit = true
		}
		
		val offensiveMoveCrits = user?.ability?.offensiveMoveCritFunction?.apply(user, move, target) ?: doesCrit
		val defensiveMoveCrits = user?.ability?.defensiveMoveCritFunction?.apply(user, move, target) ?: doesCrit
		
		doesCrit = doesCrit && offensiveMoveCrits && defensiveMoveCrits
		
		if (doesCrit) {
			battleViewController.addText("It's a critical hit!")
		}
		
		return doesCrit
	}
	
	def ailmentApplies(Pokemon user, Move move, Pokemon target) {
		if (move.ailment === null) {
			return false
		}
		
		for (Type type : target.types) {
			if (type.isImmuneTo(move.ailment) || target.ailment !== null) {
				return false
			}
		}
		
		if (move.category == MoveCategory.AILMENT) {
			return true
		}
		
		return Util.randomPercentage <= move.ailmentChance
	}
	
	def statChangesApply(Move move) {
		if (move.category == MoveCategory.NET_GOOD_STATS) {
			 return true
		}
		return move.statChance !== null && Util.randomPercentage <= move.statChance
	}
	
	def flinchApplies(Pokemon user, Move move, Pokemon target) {
		var flinchChance = move.flinchChance
		
		flinchChance = user?.ability?.flinchChanceFunction?.apply(user, move, target, flinchChance) ?: flinchChance
		
		return Util.randomPercentage <= flinchChance
	}
	
	def List<Pokemon> getInOrderOfSpeed(List<Pokemon> pokemon) {
		return pokemon.sortBy[getEffectiveSpeed]
	}
	
	def getEffectiveAttack(Pokemon pokemon, boolean doesMoveCrit) {
		return pokemon.getEffectiveStat(pokemon.attack, Stat.ATTACK, doesMoveCrit)
	}
	
	def getEffectiveDefense(Pokemon pokemon, boolean doesMoveCrit) {
		return pokemon.getEffectiveStat(pokemon.defense, DEFENSE, doesMoveCrit)
	}
	
	def getEffectiveSpecialAttack(Pokemon pokemon, boolean doesMoveCrit) {
		return pokemon.getEffectiveStat(pokemon.specialAttack, SPECIAL_ATTACK, doesMoveCrit)
	}
	
	def getEffectiveSpecialDefense(Pokemon pokemon, boolean doesMoveCrit) {
		return pokemon.getEffectiveStat(pokemon.specialDefense, SPECIAL_DEFENSE, doesMoveCrit)
	}
	
	def getEffectiveSpeed(Pokemon pokemon) {
		return pokemon.getEffectiveStat(pokemon.speed, SPEED)
	}
	
	def canEscape(Pokemon playerPokemon, Pokemon wildPokemon, int escapeAttempts) {
		val playerSpeed = getEffectiveSpeed(playerPokemon)
		val wildSpeed = getEffectiveSpeed(wildPokemon)
		
		if (playerSpeed > wildSpeed) {
			return true
		}
		
		val odds = Math.floor((playerSpeed * 32) / (wildSpeed/4.0)) + 30 * escapeAttempts
		
		return Util.randomInt(1, 256) <= odds
	}
	
	def boolean catchSucceeds(Item pokeball, Pokemon target) {
		if (pokeball.name == Items.MASTER_BALL) {
			return true
		}
		
		val darkGrassModifier = 1 //TODO
		val modifiedRate = target.species.captureRate
		val ballBonus = getBallBonus(pokeball, target)
		val badgePenalty = 1 //TODO
		val levelBonus = Math.max((36 - 2 * target.level)/10, 1)
		val statusBonus = getCatchStatusBonus(target.ailment)
		
		val long modifiedCatchRate = (Math.floor(((3.0 * target.maxHp - 2 * target.hp)/(3 * target.maxHp)) * 4096 * darkGrassModifier * modifiedRate * ballBonus * badgePenalty) * levelBonus * statusBonus) as long
		val int r = Util.randomInt(1, 255 * 4096)
		
		return r <= modifiedCatchRate
	}
	
	private def double getBallBonus(Item item, Pokemon pokemon) {
		switch(item.itemDaoName) {
			case Items.POKE_BALL: return 1
			case Items.GREAT_BALL: return 1.5
			case Items.ULTRA_BALL: return 2.0
			default: throw new RuntimeException("Unhandled ball type: " + item.name)
		}
	}
	
	private def double getCatchStatusBonus(StatusAilment ailment) {
		if (ailment === null) {
			return 1.0
		} else if (Util.in(ailment, StatusAilment.SLEEP, StatusAilment.FREEZE)) {
			return 2.5
		} else if (Util.in(ailment, StatusAilment.PARALYSIS, StatusAilment.POISON, StatusAilment.BURN)) {
			return 1.5
		} else {
			return 1.0
		}
	}
	
}