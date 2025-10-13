package asrz.Pokemon.model

import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.model.enums.MoveCategory
import asrz.Pokemon.model.enums.Stat
import asrz.Pokemon.model.enums.StatusAilment
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.model.enums.Weather
import asrz.Pokemon.model.interfaces.ILabeled
import asrz.Pokemon.pokeAPI.model.pokemon.AbilityDAO
import asrz.Pokemon.util.Util
import java.util.Map
import java.util.function.Function
import org.eclipse.xtext.xbase.lib.Functions.Function3
import org.eclipse.xtext.xbase.lib.Functions.Function4
import org.eclipse.xtext.xbase.lib.Procedures.Procedure2
import org.eclipse.xtext.xbase.lib.Procedures.Procedure3
import xtendfx.beans.FXBindable

import static asrz.Pokemon.model.enums.Type.*

@FXBindable
class Ability implements ILabeled {
	
	String abilityDaoName
	
	String name
	String description
	
	Function3<Pokemon, Move, Pokemon, Double> offensiveAccuracyModifierFunction
	Function4<Pokemon, Move, Pokemon, Weather, Double> defensiveAccuracyModifierFunction
	Function3<Pokemon, Move, Pokemon, Double> spectatorAccuracyModifierFunction
	
	Function3<Pokemon, Move, Pokemon, Double> offensiveDamageModifierFunction
	Function4<Pokemon, Move, Pokemon, Integer, Integer> defensiveDamageFunction
	
	Procedure3<Pokemon, Move, Pokemon> defensiveOnHitFunction
	
	Function4<Pokemon, Move, Pokemon, Integer, Integer> flinchChanceFunction
	Function3<Pokemon, Move, Pokemon, Double> critChanceModifierFunction
	Function3<Pokemon, Move, Pokemon, Boolean> offensiveMoveCritFunction
	Function3<Pokemon, Move, Pokemon, Boolean> defensiveMoveCritFunction
	
	Function<StatusAilment, Boolean> isImmuneToAilmentFunction
	Function<Ability, Boolean> isImmuneToAbilityFunction
	Function<Move, Boolean> isImmuneToMoveFunction
	
	Procedure2<BattleViewController, Pokemon> switchInFunction
	Procedure2<BattleViewController, Pokemon> endOfTurnFunction
	
	new() {}
	
	new(String abilityDaoName) {
		this.abilityDaoName = abilityDaoName
	}
	
	def static fromApi(AbilityDAO abilityDao, String languageName) {
		if (abilityDao === null) {
			return null
		}
		
		val ability = Abilities.abilitiesByAbilityDaoName.get(abilityDao.name)
		
		if (ability === null) {
			return null
		}
		
		return ability => [
			name = abilityDao.names.findFirst[language.name == languageName].name
			description = abilityDao.effectEntries.findFirst[language.name == languageName].effect
		]
	}
	
	def Double getDamageModifier(Pokemon user, Move move, Pokemon target) {
		return offensiveDamageModifierFunction?.apply(user, move, target) ?: 1.0
	}
	
	override getLabel() {
		return name
	}
}

class Abilities {
	
	public static final Map<String, Ability> abilitiesByAbilityDaoName = #[
		new Ability("stench") => [
			flinchChanceFunction = [user, move, target, flinchChance | 
				if (flinchChance > 0) {
					return flinchChance
				} else {
					return 10
				}
			]
		],
		
		new Ability("drizzle") => [
			switchInFunction = [battleViewController, pokemon |
				battleViewController.changeWeather(Weather.RAIN, 5)
			]
		],
		
		new Ability("speed-boost") => [
			endOfTurnFunction = [battleViewController, pokemon |
				if (!battleViewController.switchedInThisTurn.contains(pokemon)) {
					val speedBoosts = pokemon.tempStatChanges.getOrDefault(Stat.SPEED, 0)
					pokemon.tempStatChanges.put(Stat.SPEED, Math.max(speedBoosts+1, 6) as Integer)
				}
			]
		],
		
		new Ability("battle-armor") => [
			defensiveMoveCritFunction = [ user, move, target |
				return false
			]
		],
		
		new Ability("sturdy") => [
			defensiveDamageFunction = [user, move, target, damage |
				if (move.category == MoveCategory.OHKO) {
					return 0
				}
				
				if (target.hp == target.maxHp && damage >= target.maxHp) {
					return target.maxHp - 1
				}
				
				return damage
			]
		],
		
		new Ability("damp") => [
			offensiveAccuracyModifierFunction = [ user, move, target | preventSelfDestruction(user, move, target) ]
			defensiveAccuracyModifierFunction = [ user, move, target, weather | preventSelfDestruction(user, move, target) ]
			spectatorAccuracyModifierFunction = [ user, move, target | preventSelfDestruction(user, move, target) ]
		],
		
		new Ability("limber") => [
			isImmuneToAilmentFunction = [ailment | return ailment == StatusAilment.PARALYSIS ]
		],
		
		new Ability("sand-veil") => [
			defensiveAccuracyModifierFunction = [ user, move, target, weather | 
				if (weather == Weather.SANDSTORM) {
					return 0.8d
				}
				
				return 1d
			]
		],
		
		new Ability("static") => [
			defensiveOnHitFunction = [user, move, target |
				if (move.contact && Util.randomPercentage <= 30) {
					target.applyAilment(StatusAilment.PARALYSIS)
				}
			] 
		],
		
		new Ability("volt-absorb") => [
			defensiveOnHitFunction = [user, move, target |
				if (move.type == Type.ELECTRIC) {
					target.hp = Math.min(target.maxHp, target.maxHp/4 + target.hp)
				}
			]
			defensiveDamageFunction = [ user, move, target, weather |
				if (move.type == Type.ELECTRIC) {
					return 0
				}
				
				return null
			]
		],
		
		new Ability("water-absorb") => [
			defensiveOnHitFunction = [user, move, target |
				if (move.type == Type.WATER) {
					target.hp = Math.min(target.maxHp, target.maxHp/4 + target.hp)
				}
			]
			defensiveDamageFunction = [ user, move, target, weather |
				if (move.type == Type.WATER) {
					return 0
				}
				
				return null
			]
		],
		
		new Ability("oblivious") => [
			isImmuneToAilmentFunction = [ ailment | return ailment == StatusAilment.INFATUATION ]
			isImmuneToAbilityFunction = [ ability | return ability.abilityDaoName == "intimidate" ]
			isImmuneToMoveFunction = [ move | return Util.in(move.moveDaoName, "captivate", "taunt") ]
		],
		
		new Ability("cloud-nine"),
		
		new Ability("overgrow") => [
			offensiveDamageModifierFunction = [user, move, target | getStarterMoveDamageModifier(user, move, GRASS) ]
		],
		
		new Ability("blaze") => [
			offensiveDamageModifierFunction = [user, move, target | getStarterMoveDamageModifier(user, move, FIRE) ]
		],
		
		new Ability("torrent") => [
			offensiveDamageModifierFunction = [user, move, target | getStarterMoveDamageModifier(user, move, WATER) ]
		]
	].toMap[abilityDaoName]
	
	private static def double preventSelfDestruction(Pokemon user, Move move, Pokemon target) {
		if (Util.in(move.name, "self-destruct", "explosion", "mind-blown", "misty-explosion")) {
			return 0d
		}
		
		return 1d
	}
	
	private static def double getStarterMoveDamageModifier(Pokemon user, Move move, Type type) {
		if (move.type == GRASS && user.hpPercentage <= 33) {
			return 1.5
		} else {
			return 1.0
		}
	}
}