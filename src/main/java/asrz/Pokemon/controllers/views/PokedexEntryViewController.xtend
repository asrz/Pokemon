package asrz.Pokemon.controllers.views

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.model.PokemonMove
import asrz.Pokemon.model.PokemonSpecies
import asrz.Pokemon.model.enums.MoveDamageClass
import asrz.Pokemon.model.enums.MoveLearnMethod
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.util.Constants
import asrz.Pokemon.util.ImageLoader
import javafx.collections.FXCollections
import javafx.fxml.FXML
import javafx.geometry.Pos
import javafx.scene.control.TableCell
import javafx.scene.control.TableColumn
import javafx.scene.control.TableView
import javafx.scene.image.ImageView
import xtendfx.beans.FXBindable

import static extension asrz.Pokemon.util.Extensions.addIfAbsent

@FXBindable
class PokedexEntryViewController extends BasicController {
	
	@FXML
	TableView<PokemonMove> moveTableView
	
	@FXML
	ImageView sprite
	
	PokemonSpecies pokemonSpecies
	
	
	new(PokemonSpecies species) {
		this.pokemonSpecies = species
	}
	
	override initialize() {
		if (pokemonSpecies !== null) {
			sprite.image = ImageLoader.loadImage(pokemonSpecies.sprites.frontDefault)
		}
		
		moveTableView.items = FXCollections.observableArrayList(pokemonSpecies.pokemonMoves)
		
		moveTableView.columns.addAll(
			new TableColumn<PokemonMove, String>("Move") => [
				cellValueFactory = [ value.getNameProperty() ]
			],
			new TableColumn<PokemonMove, MoveDamageClass>("Cat") => [
				cellValueFactory = [ value.getCategoryProperty() ]
				cellFactory = [ new CategoryCell() ]
			],
			new TableColumn<PokemonMove, Type>("Type") => [
				cellValueFactory = [ value.getTypeProperty() ]
				cellFactory = [ new TypeCell() ]
			],
			new TableColumn<PokemonMove, Integer>("Power") => [
				cellValueFactory = [ value.getPowerProperty() ]
			],
			new TableColumn<PokemonMove, Integer>("Acc") => [
				cellValueFactory = [ value.getAccuracyProperty() ]
			],
			new TableColumn<PokemonMove, Number>("PP") => [
				cellValueFactory = [ value.getPpProperty() ]
			],
			new TableColumn<PokemonMove, String>("Description") => [
				cellValueFactory = [ value.getDescriptionProperty() ]
			],
			new TableColumn<PokemonMove, MoveLearnMethod>("Method") => [
				cellValueFactory = [ value.learnMethodProperty ]
			],
			new TableColumn<PokemonMove, Integer>("Level") => [
				cellValueFactory = [ value.levelLearnedAtProperty ]
			]
		)
	}
	
	private def getNameProperty(PokemonMove pokemonMove) {
		return pokemonMove.move.nameProperty()
	}
	
	private def getCategoryProperty(PokemonMove pokemonMove) {
		return pokemonMove.move.damageClassProperty
	}
	
	private def getTypeProperty(PokemonMove pokemonMove) {
		return pokemonMove.move.typeProperty
	}
	
	private def getPowerProperty(PokemonMove pokemonMove) {
		return pokemonMove.move.powerProperty
	}
	
	private def getAccuracyProperty(PokemonMove pokemonMove) {
		return pokemonMove.move.accuracyProperty
	}
	
	private def getDescriptionProperty(PokemonMove pokemonMove) {
		return pokemonMove.move.descriptionProperty
	}
	
	private def getPpProperty(PokemonMove pokemonMove) {
		return pokemonMove.move.ppProperty
	}
	
	@FXML
	private def onBackButton() {
		Application.setScene(SceneHandle.MAIN_VIEW, [], [])
	}
	
	static class CategoryCell extends TableCell<PokemonMove, MoveDamageClass> {
		
		override protected updateItem(MoveDamageClass item, boolean empty) {
			super.updateItem(item, empty);
				
			if (empty || item === null) {
				setText(null);
				setGraphic(null);
				styleClass.removeAll(MoveDamageClass.values.map[label])
			} else {
				setText(item.symbol);
				styleClass.removeAll(MoveDamageClass.values.map[label])
				styleClass.add(item.label)
				styleClass.addIfAbsent(Constants.FONT_ESSENTIARUM)
				alignment = Pos.CENTER
			}
		}
	}
	
	static class TypeCell extends TableCell<PokemonMove, Type> {
		
		override protected updateItem(Type item, boolean empty) {
			super.updateItem(item, empty);
				
			if (empty || item === null) {
				setText(null);
				setGraphic(null);
				styleClass.removeAll(Type.values.map[label])
			} else {
				setText(item.label);
				styleClass.removeAll(Type.values.map[label])
				styleClass.add(item.label)
				alignment = Pos.CENTER
			}
		}
	}
}
