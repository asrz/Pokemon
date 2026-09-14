package asrz.Pokemon.service

import asrz.Pokemon.application.Context
import asrz.Pokemon.model.Item
import asrz.Pokemon.model.enums.ItemCategory
import asrz.Pokemon.util.Util
import com.mongodb.client.model.Filters
import java.util.List

class ItemService extends BaseService {
	
	new(Context context) {
		super(context)
	}
	
	
	def List<Item> getRealItems() {
		database.getItems(Filters.empty).map[itemDao | 
			Item.fromApi(itemDao, player.languageName)
		].filter[ item | 
			!Util.in(item.category, ItemCategory.excludedCategories)
		].toList
	}
}