package asrz.Pokemon.controllers.controls

import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.util.ImageLoader
import asrz.Pokemon.util.Timer
import asrz.Pokemon.util.Util
import com.mongodb.client.model.Filters
import java.io.IOException
import javafx.fxml.FXML
import javafx.fxml.FXMLLoader
import javafx.scene.control.Button
import javafx.scene.image.ImageView
import xtendfx.beans.FXBindable

@FXBindable
class KantoTab extends RegionalTab implements IController  {
	
	@FXML
	ImageView kantoImageView
	
	@FXML
	Button palletTownButton
	
	@FXML
	Button pewterCityButton
	
	@FXML
	Button viridianCityButton
	
	@FXML
	Button viridianForestButton
	
	@FXML
	Button mtMoonButton
	
	@FXML
	Button ceruleanCityButton
	
	@FXML
	Button ceruleanCaveButton
	
	@FXML
	Button saffronCityButton
	
	@FXML
	Button vermillionCityButton
	
	@FXML
	Button ssAnneButton
	
	@FXML
	Button lavendarTownButton
	
	@FXML
	Button celadonCityButton
	
	@FXML
	Button fuchsiaCityButton
	
	@FXML
	Button seafoamIslandsButton
	
	@FXML
	Button cinnabarIslandButton
	
	@FXML
	Button victoryRoadButton
	
	@FXML
	Button indigoPlateauButton
	
	@FXML
	Button safariZoneButton
	
	@FXML
	Button diglettsCaveButton
	
	@FXML
	Button powerPlantButton
	
	@FXML
	Button rockTunnelButton
	
	@FXML
	Button kantoRoute1Button
	@FXML
	Button kantoRoute2Button
	@FXML
	Button kantoRoute3Button
	@FXML
	Button kantoRoute4Button
	@FXML
	Button kantoRoute4Button2
	@FXML
	Button kantoRoute5Button
	@FXML
	Button kantoRoute6Button
	@FXML
	Button kantoRoute7Button
	@FXML
	Button kantoRoute8Button
	@FXML
	Button kantoRoute9Button
	@FXML
	Button kantoRoute10Button
	@FXML
	Button kantoRoute11Button
	@FXML
	Button kantoRoute12Button
	@FXML
	Button kantoRoute13Button
	@FXML
	Button kantoRoute14Button
	@FXML
	Button kantoRoute15Button
	@FXML
	Button kantoRoute16Button
	@FXML
	Button kantoRoute17Button
	@FXML
	Button kantoRoute18Button
	@FXML
	Button kantoRoute19Button
	@FXML
	Button kantoRoute20Button
	@FXML
	Button kantoRoute20Button2
	@FXML
	Button kantoRoute21Button
	@FXML
	Button kantoRoute22Button
	@FXML
	Button kantoRoute23Button
	@FXML
	Button kantoRoute24Button
	@FXML
	Button kantoRoute25Button
	
	new() {
		val FXMLLoader fxmlLoader = new FXMLLoader(class.getResource("/fxml/controls/KantoTab.fxml"))
		fxmlLoader.setRoot(this)
		fxmlLoader.setController(this)
		try {
			fxmlLoader.load()
		} catch(IOException exception) {
			throw new RuntimeException(exception)
		}
	}
	
	override initialize() {
		val timer = new Timer()
		
		val kanto = database.getRegions(Filters.eq("name", "kanto")).head()
		text = kanto.names.findFirst[language.name == player.languageName].name
		
		val region = database.getRegions(Filters.eq("name", "kanto")).head()
		kantoRoute1Button.onAction = [onClickScoutButton(region, "kanto-route-1")]
		kantoRoute2Button.onAction = [onClickScoutButton(region, "kanto-route-2")]
		kantoRoute3Button.onAction = [onClickScoutButton(region, "kanto-route-3")]
		kantoRoute4Button.onAction = [onClickScoutButton(region, "kanto-route-4")]
		kantoRoute4Button2.onAction = [onClickScoutButton(region, "kanto-route-4")]
		kantoRoute5Button.onAction = [onClickScoutButton(region, "kanto-route-5")]
		kantoRoute6Button.onAction = [onClickScoutButton(region, "kanto-route-6")]
		kantoRoute7Button.onAction = [onClickScoutButton(region, "kanto-route-7")]
		kantoRoute8Button.onAction = [onClickScoutButton(region, "kanto-route-8")]
		kantoRoute9Button.onAction = [onClickScoutButton(region, "kanto-route-9")]
		kantoRoute10Button.onAction = [onClickScoutButton(region, "kanto-route-10")]
		kantoRoute11Button.onAction = [onClickScoutButton(region, "kanto-route-11")]
		kantoRoute12Button.onAction = [onClickScoutButton(region, "kanto-route-12")]
		kantoRoute13Button.onAction = [onClickScoutButton(region, "kanto-route-13")]
		kantoRoute14Button.onAction = [onClickScoutButton(region, "kanto-route-14")]
		kantoRoute15Button.onAction = [onClickScoutButton(region, "kanto-route-15")]
		kantoRoute16Button.onAction = [onClickScoutButton(region, "kanto-route-16")]
		kantoRoute17Button.onAction = [onClickScoutButton(region, "kanto-route-17")]
		kantoRoute18Button.onAction = [onClickScoutButton(region, "kanto-route-18")]
		kantoRoute19Button.onAction = [onClickScoutButton(region, "kanto-sea-route-19")]
		kantoRoute20Button.onAction = [onClickScoutButton(region, "kanto-sea-route-20")]
		kantoRoute20Button2.onAction = [onClickScoutButton(region, "kanto-sea-route-20")]
		kantoRoute21Button.onAction = [onClickScoutButton(region, "kanto-sea-route-21")]
		kantoRoute22Button.onAction = [onClickScoutButton(region, "kanto-route-22")]
		kantoRoute23Button.onAction = [onClickScoutButton(region, "kanto-route-23")]
		kantoRoute24Button.onAction = [onClickScoutButton(region, "kanto-route-24")]
		kantoRoute25Button.onAction = [onClickScoutButton(region, "kanto-route-25")]
		
		palletTownButton.onAction = [onClickScoutButton(region, "pallet-town")]
		viridianCityButton.onAction = [onClickScoutButton(region, "viridian-city")]
		viridianForestButton.onAction = [onClickScoutButton(region, "viridian-forest")]
		pewterCityButton.onAction = [onClickScoutButton(region, "pewter-city")]
		ceruleanCityButton.onAction = [onClickScoutButton(region, "cerulean-city")]
		saffronCityButton.onAction = [onClickScoutButton(region, "saffron-city")]
		vermillionCityButton.onAction = [onClickScoutButton(region, "vermillion-city")]
		lavendarTownButton.onAction = [onClickScoutButton(region, "lavendar-town")]
		celadonCityButton.onAction = [onClickScoutButton(region, "celadon-city")]
		fuchsiaCityButton.onAction = [onClickScoutButton(region, "fuchsia-city")]
		cinnabarIslandButton.onAction = [onClickScoutButton(region, "cinnabar-island")]
		
		
		val url = Util.list("regions", "Kanto.png").join("/")
		kantoImageView.image = ImageLoader.loadLocalImage(url)
		timer.endStep("regions")
	}
	
}
