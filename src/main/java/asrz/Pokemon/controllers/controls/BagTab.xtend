package asrz.Pokemon.controllers.controls

import asrz.Pokemon.application.Application
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.model.Item
import asrz.Pokemon.model.ItemBag
import asrz.Pokemon.model.ItemStack
import asrz.Pokemon.model.enums.ItemPocket
import asrz.Pokemon.model.enums.MenuMode
import asrz.Pokemon.util.ImageLoader
import java.io.IOException
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import javafx.beans.binding.Bindings
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.ContentDisplay
import javafx.scene.control.Label
import javafx.scene.control.ListCell
import javafx.scene.control.ListView
import javafx.scene.control.MenuButton
import javafx.scene.control.MenuItem
import javafx.scene.control.Tab
import javafx.scene.control.TabPane
import javafx.scene.image.ImageView
import javafx.scene.layout.VBox
import xtendfx.beans.FXBindable
import asrz.Pokemon.application.SceneHandle

@FXBindable
class BagTab extends VBox implements IController  {
	
	@FXML
	TabPane tabPane
	
	@FXML
	Label label
	
	Map<ItemPocket, Tab> tabMap = new HashMap
	//Map<ItemPocket, ListView<Item>> pocketMap = new HashMap
	
	ItemBag itemBag
	
	MenuMode menuMode
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/BagTab.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	override initialize() {
		itemBag = player.itemBag
		for (itemPocket : ItemPocket.values()) {
			val listView = new ListView<ItemStack>()
			listView.cellFactory = [ new ItemStackCell(this) ]
			listView.editable = false
			listView.items = itemBag.getItems(itemPocket)
			listView.focusModel.focusedItemProperty.addListener([ observable, oldItemStack, newItemStack |
				if (newItemStack !== null && tabMap.get(newItemStack.item.category.pocket).selected) {
					displayDescription(newItemStack.item)
				}
			])
			
			val tab = new Tab(itemPocket.label, listView)
			tabPane.tabs.add(tab)
			tabMap.put(itemPocket, tab)
		}
		
//		for (ItemDAO itemDao : database.getItems(Filters.empty)) {
//			addItem(Item.fromApi(itemDao))
//		}
	}
	
	def displayDescription(Item item) {
		if (item === null) {
			label.text = ""
		}
		
		label.text = item.description
	}
	
	def void useItem(ItemStack stack) {
		if (menuMode == MenuMode.BATTLE) {
			if (stack.item.consumable) {
				stack.quantity = stack.quantity - 1
				if (stack.quantity == 0) {
					itemBag.remove(stack.item.pocket)
				}
			}
			
			Application.setScene(SceneHandle.BATTLE_VIEW, [], [c.battleViewController.useItem(stack.item)])
		}
	}
	
}

class ItemStackCell extends ListCell<ItemStack> {
	
	BagTab bagTab
	
	new(BagTab bagTab) {
		this.bagTab = bagTab
		this.contentDisplay = ContentDisplay.GRAPHIC_ONLY
	}
	
	override protected updateItem(ItemStack itemStack, boolean empty) {
		super.updateItem(itemStack, empty)
		
		if (empty || itemStack === null) {
			text = null
			graphic = null
		} else {
			val menuButton = new MenuButton(itemStack.fullLabel, new ImageView(ImageLoader.loadImage(itemStack.item.sprite)), getMenuItems())
			menuButton.prefWidthProperty.bind(Bindings.createDoubleBinding([this.width - 20], this.widthProperty))
			graphic = menuButton
			menuButton.onShowing = [
				bagTab.displayDescription(itemStack.item)
			]
		}
	}
	
	private def List<MenuItem> getMenuItems() {
		if (item === null) {
			return null
		}
		
		val result = new ArrayList<MenuItem>
		
		if (item.item.isUsable(bagTab.menuMode)) {
			result.add(new MenuItem("USE") => [
				onAction = [ bagTab.useItem(item) ]
			])
		}
		if (item.item.holdable) {
			result.add(new MenuItem("GIVE"))
		}
		
		result.add(new MenuItem("CANCEL"))
		
		return result
	}
	
}
