package asrz.Pokemon.model

import asrz.Pokemon.model.enums.ItemAttribute
import asrz.Pokemon.model.enums.ItemCategory
import asrz.Pokemon.model.enums.ItemPocket
import asrz.Pokemon.model.enums.MenuMode
import asrz.Pokemon.model.interfaces.ILabeled
import asrz.Pokemon.pokeAPI.model.items.ItemDAO
import asrz.Pokemon.util.Util
import java.util.List
import org.bson.codecs.pojo.annotations.BsonIgnore
import xtendfx.beans.FXBindable

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
	
	def static Item fromApi(ItemDAO dao, String languageName) {
		new Item() => [
			itemDaoId = dao.id
			itemDaoName = dao.name
			cost = dao.cost
			attributes = dao.attributes.map[attr | ItemAttribute.fromApiString(attr.name)]
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
	
}