package asrz.Pokemon.model

import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.model.enums.Gender
import asrz.Pokemon.model.enums.ItemAttribute
import asrz.Pokemon.model.enums.ItemCategory
import asrz.Pokemon.model.enums.ItemPocket
import asrz.Pokemon.model.enums.MenuMode
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.model.interfaces.ILabeled
import asrz.Pokemon.pokeAPI.model.items.ItemDAO
import asrz.Pokemon.util.Util
import java.util.List
import org.bson.codecs.pojo.annotations.BsonIgnore
import org.eclipse.xtext.xbase.lib.Functions.Function3
import xtendfx.beans.FXBindable
import asrz.Pokemon.model.enums.StatusAilment

@FXBindable
class Item implements ILabeled {

	Integer itemDaoId

	@BsonIgnore
	String itemDaoName

	@BsonIgnore
	Integer cost
	@BsonIgnore
	List<ItemAttribute> attributes
	@BsonIgnore
	ItemCategory category
	@BsonIgnore
	String name
	@BsonIgnore
	String sprite
	@BsonIgnore
	String flavorText
	@BsonIgnore
	String description

	new(String itemDaoName) {
		this.itemDaoName = itemDaoName
	}
	
	def static Item fromApi(ItemDAO dao, String languageName) {
		new Item(dao.name) => [
			itemDaoId = dao.id
			itemDaoName = dao.name
			cost = dao.cost
			attributes = dao.attributes.map[attr|ItemAttribute.fromApiString(attr.name)]
			category = ItemCategory.fromApiString(dao.category.name)

			val nameDao = dao.names.findFirst[language.name == languageName]
			name = nameDao?.name ?: Util.hyphenCaseToTitleCase(dao.name)

			sprite = dao.sprites.defaultSprite
			flavorText = dao.flavorTextEntries.findLast[language.name == languageName]?.text

			val effectEntry = dao.effectEntries.findFirst[language.name == languageName]
			if (effectEntry !== null) {
				description = effectEntry?.shortEffect
			} else {
				description = flavorText
			}
		]
	}

	def isCountable() {
		return attributes.contains(ItemAttribute.COUNTABLE)
	}

	def isUsableBattle() {
		return attributes.contains(ItemAttribute.USABLE_BATTLE)
	}

	def isUsableOverworld() {
		return attributes.contains(ItemAttribute.USABLE_OVERWORLD)
	}

	def isUsable(MenuMode menuMode) {
		if (menuMode == MenuMode.OVERWORLD) {
			return isUsableOverworld()
		} else if (menuMode == MenuMode.BATTLE) {
			return isUsableBattle()
		} else {
			throw new RuntimeException("Unexpected MenuMode: " + menuMode)
		}
	}

	def isHoldable() {
		return attributes.contains(ItemAttribute.HOLDABLE) || attributes.contains(ItemAttribute.HOLDABLE_ACTIVE)
	}

	def isConsumable() {
		return attributes.contains(ItemAttribute.CONSUMABLE)
	}

	def ItemPocket getPocket() {
		return category.pocket
	}

	override getLabel() {
		return name
	}

	def getFullLabel() {
		return name
	}

	override toString() {
		return getLabel()
	}

	def boolean requiresTarget() {
		if (itemDaoName == 'sacred-ash') {
			return false
		} else {
			return true
		}
	}
}

class Pokeball extends Item {

	new(String itemDaoName) {
		super(itemDaoName)
	}

	public Function3<BattleViewController, Pokemon, Pokemon, Double> catchRateModifierFunction
	public Function3<BattleViewController, Pokemon, Pokemon, Integer> catchRateAdditiveFunction
}

class Berry extends Item {
	
	new(String itemDaoName) {
		super(itemDaoName)
	}
	
}

class Items {
	public static final String MASTER_BALL = "master-ball"
	public static final String BEAST_BALL = "beast-ball"
	
	public static final String HM01 = "hm01"
	public static final String HM02 = "hm02"
	public static final String HM03 = "hm03"
	public static final String HM04 = "hm04"
	public static final String HM05 = "hm05"
	public static final String HM06 = "hm06"
	public static final String HM07 = "hm07"
	
	public static final List<Item>  itemsByItemDaoName = #[
		new Pokeball("poke-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target | return 1.0 ]
		],
		
		new Pokeball("great-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target | return 1.5 ]
		],
		
		new Pokeball("ultra-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target | return 2.0 ]
		],
		
		new Pokeball(MASTER_BALL),
		
		new Pokeball("safari-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target | return 1.5 ]
		],
		
		new Pokeball("net-ball") => [ 
			catchRateModifierFunction = [ battleViewController, user, target |
				if (Util.in(Type.WATER, target.types) || Util.in(Type.BUG, target.types)) {
					return 3.5
				}
				
				return 1.0
			]
		],
		
		new Pokeball("dive-ball") => [
			//TODO dive-ball
		],
		
		new Pokeball("nest-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target |
				if (target.level < 30) {
					return (41d - target.level) / 10d
				}
				
				return 1.0
			]
		],
		
		new Pokeball("repeat-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target |
				//TODO repeat-ball
			]
		],
		
		new Pokeball("timer-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target |
				if (battleViewController.round > 9) {
					return 4.0
				} else {
					return (battleViewController.round * 0.3) + 1.0
				}
			]
		],
		
		new Pokeball("luxury-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target | return 1.0 ]
		],
		
		new Pokeball("premier-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target | return 1.0 ]
		],
		
		new Pokeball("heal-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target | return 1.0 ]
			//TODO heal-ball
		],
		
		new Pokeball("quick-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target | 
				if (battleViewController.round == 1) {
					return 5.0
				}
				
				return 1.0
			]
		],
		
		new Pokeball("cherish-ball") => [
			//TODO cherish-ball
		],
		
		new Pokeball("fast-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target |
				if (target.species.baseSpeed >= 100) {
					return 4.0
				}
				
				return 1.0
			]
		],
		
		new Pokeball("level-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target |
				if (user.level >= target.level * 4) {
					return 8.0
				} else if (user.level >= target.level * 2) {
					return 4.0
				} else if (user.level > target.level) {
					return 2.0
				} else {
					return 1.0
				}
			]
		],
		
		new Pokeball("lure-ball") => [
			//TODO lure-ball
		],
		
		new Pokeball("heavy-ball") => [
			catchRateAdditiveFunction = [ battleViewController, user, target |
				if (target.weight > 3000) {
					return 30
				} else if (target.weight > 2000) {
					return 20
				} else if (target.weight > 1000) {
					return 0
				} else {
					return -20
				}
			]
		],
		
		new Pokeball("love-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target |
				val sameSpecies = user.species.pokemonSpeciesDaoId == target.species.pokemonSpeciesDaoId
				val oppositeGender = user.gender == Gender.MALE && target.gender == Gender .FEMALE ||
									user.gender == Gender.FEMALE && target.gender == Gender.MALE
				
				if (sameSpecies && oppositeGender) {
					return 8.0
				}
				
				return 1.0
				
			]
		],
		
		new Pokeball("friend-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target |
				return 1.0
			]
		],
		
		new Pokeball("moon-ball") => [
			//TODO moon-ball
		],
		
		new Pokeball("sport-ball") => [
			//TODO sport-ball
		],
		
		new Pokeball("park-ball") => [
			//TODO park-ball
		],
		
		new Pokeball("dream-ball") => [
			catchRateModifierFunction = [ battleViewController, user, target |
				if (target.statusAilment == StatusAilment.SLEEP || target.volatileStatusAilments.containsKey(StatusAilment.YAWN)) {
					return 4.0
				}
				
				return 1.0
			]
		],
		
		new Pokeball(BEAST_BALL) => [
			catchRateModifierFunction = [ battleViewController, user, target |
				if (Util.in(target.species.name, PokemonSpecies.ULTRA_BEASTS)) {
					return 5.0
				} else {
					return 0.1
				}
			]
		],
		
		
		
		new Item("focus-sash") => [
			
		]
	]
	
	
	
}
