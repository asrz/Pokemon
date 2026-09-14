package asrz.Pokemon.util

import asrz.Pokemon.model.Abilities
import asrz.Pokemon.model.Item
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.model.enums.BattleSlot
import java.util.Comparator
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors(PUBLIC_GETTER)
class TurnAction {
	
	Pokemon user
	BattleAction battleAction
	Move move
	Item item
	List<BattleSlot> targets
	Pokemon pokemon
	
	
	def static TurnAction useMove(Pokemon user, Move move, List<BattleSlot> targets) {
		println(String.format("%s uses %s on %s", user.label, move.label, targets))
		return new TurnAction => [
			it.battleAction = BattleAction.USE_MOVE
			it.user = user
			it.move = move
			it.targets = targets
		]
	}
	
	def static TurnAction useItem(Pokemon user, Item item, Pokemon target) {
		return new TurnAction => [
			it.battleAction = BattleAction.USE_ITEM
			it.user = user
			it.item = item
			it.pokemon = target
		]
	}
	
	def static TurnAction switchPokemon(Pokemon user, Pokemon pokemon) {
		return new TurnAction => [
			it.battleAction = BattleAction.SWITCH_POKEMON
			it.user = user
			it.pokemon = pokemon
		]
	}
	
	def static TurnAction runAway(Pokemon user) {
		return new TurnAction => [
			it.battleAction = BattleAction.RUN_AWAY
			it.user = user
		]
	}
	
	enum BattleAction {
		RUN_AWAY,
		SWITCH_POKEMON,
		USE_ITEM,
		USE_MOVE
	}
	
	static class TurnActionOrder implements Comparator<TurnAction> {
		
		BattleCalculator battleCalculator
		
		new (BattleCalculator battleCalculator) {
			this.battleCalculator = battleCalculator
		}
		
		override compare(TurnAction turnAction1, TurnAction turnAction2) {
			var result = turnAction1.battleAction.ordinal - turnAction2.battleAction.ordinal
			if (result != 0) {
				return result
			}
			
			if (turnAction1.battleAction == BattleAction.USE_MOVE) {
				result = turnAction2.move.getPriority(turnAction2.user) - turnAction1.move.getPriority(turnAction1.user) //inverted cause high priority is faster
				if (result != 0) {
					return result
				}
			}
			
			val turnAction1GoesFirst = turnAction1.user.ability.abilityDaoName == Abilities.QUICK_DRAW && turnAction1.user.ability.counter == 1
			val turnAction2GoesFirst = turnAction2.user.ability.abilityDaoName == Abilities.QUICK_DRAW && turnAction2.user.ability.counter == 1
			
			val turnAction1GoesLast = turnAction1.user.ability.abilityDaoName == Abilities.STALL
			val turnAction2GoesLast = turnAction2.user.ability.abilityDaoName == Abilities.STALL
			
			if (turnAction1GoesFirst && !turnAction2GoesFirst) {
				return -1
			} else if (turnAction2GoesFirst && !turnAction1GoesFirst) {
				return 1
			}
			
			if (turnAction1GoesLast && !turnAction2GoesLast) {
				return 1
			} else if (turnAction2GoesLast && !turnAction1GoesLast) {
				return -1
			}
			
			result = battleCalculator.getEffectiveSpeed(turnAction1.user) - battleCalculator.getEffectiveSpeed(turnAction2.user)
			
			if (result == 0) {
				result = Util.randomChoice(-1, 1) //speed ties
			}
			
			return result
		}
		
	}
}