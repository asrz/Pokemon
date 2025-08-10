package asrz.Pokemon.model

import org.bson.codecs.pojo.annotations.BsonIgnore
import xtendfx.beans.FXBindable

@FXBindable
class ItemStack {
	
	int quantity = 1
	
	@BsonIgnore
	Item item
	
	Integer itemDaoId
	
	new () {}
	
	new(Item item, int quantity) {
		this.item = item
		this.itemDaoId = item.itemDaoId
		this.quantity = quantity
	}
	
	@BsonIgnore
	def getFullLabel() {
		if (item.countable) {
			return String.format("%d x %s", quantity, item.label)
		}
		
		return item.label
	}
	
}