package asrz.Pokemon.model

import asrz.Pokemon.model.enums.ItemPocket
import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.util.ObservableListMap
import org.bson.codecs.pojo.annotations.BsonIgnore

@MongoPojo
class ItemBag extends ObservableListMap<ItemPocket, ItemStack> {
	
	new () {
		ItemPocket.values.forEach[ pocket |
			addKey(pocket)
		]
	}
	
	def void addItem(Item item) {
		addItems(item, 1)
	}
	
	def void addItems(Item item, int quantity) {
		val pocket = item.category.pocket
		val id = item.itemDaoId
		val stack = get(pocket).findFirst[itemStack | itemStack.itemDaoId == id]
		if (stack !== null) {
			stack.quantity = stack.quantity + quantity
		} else {
			add(pocket, new ItemStack(item, quantity))
		}
	}
	
	@BsonIgnore
	def getItems(ItemPocket pocket) {
		return get(pocket)
	}
	
	@BsonIgnore
	def getAllItemStacks() {
		return flattenedValues.toList
	}
	
}