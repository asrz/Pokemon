package asrz.Pokemon.application

import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.controllers.views.MainViewController
import asrz.Pokemon.controllers.views.SampleController
import java.net.URL
import java.util.function.Consumer
import javafx.fxml.FXMLLoader
import javafx.scene.Parent
import javafx.scene.Scene
import javafx.stage.Stage
import javafx.util.Callback
import xtendfx.FXApp

@FXApp
class Application {
	
	public static Context context
	
	override start(Stage stage) throws Exception {
		val pair = createStage("/fxml/views/Sample.fxml", [new SampleController()])
		context.otherStage = pair.key
		context.otherController = pair.value
		
		context.hideAllStages()
		context.otherStage.show()
	}
	
	def static Pair<Stage, IController> createStage(String fxmlFilepath, Callback<Class<?>, Object> controllerFactory) {
		val URL uri = Application.getResource(fxmlFilepath)
		val FXMLLoader loader = new FXMLLoader(uri)
		loader.controllerFactory = controllerFactory
		val Parent root = loader.load()
		val stylesheet = Application.getResource("/css/style.css").toString
		return new Stage => [
			scene = new Scene(root) => [
				stylesheets.add(stylesheet)
			]
			title = "Pokémon"
		] -> loader.controller
	}
	
	def static setScene(SceneHandle sceneHandle, Callback<Class<?>, Object> controllerFactory, Consumer<IController> callback) {
		context.hideAllStages()
		if (sceneHandle == SceneHandle.MAIN_VIEW) {
			if (context.mainStage === null) {
				val pair = createStage(sceneHandle.fxmlPath, [new MainViewController()])
				context.mainStage = pair.key
				context.mainViewController = pair.value as MainViewController
			}
			context.mainStage.show()
			callback?.accept(context.mainViewController)
		} else if (sceneHandle == SceneHandle.BATTLE_VIEW) {
			if (context.battleStage === null) {
				val pair = createStage(sceneHandle.fxmlPath, [new BattleViewController()])
				context.battleStage = pair.key
				context.battleViewController = pair.value as BattleViewController
			}
			context.battleStage.show()
			callback?.accept(context.battleViewController)
		} else {
			if (context.otherStage === null) {
				val pair = createStage(sceneHandle.fxmlPath, controllerFactory)
				context.otherStage = pair.key
				context.otherController = pair.value
			} else {
				val URL uri = Application.getResource(sceneHandle.fxmlPath)
				val FXMLLoader loader = new FXMLLoader(uri)
				loader.controllerFactory = controllerFactory
				val Parent root = loader.load()
				val stylesheet = Application.getResource("/css/style.css").toString
				context.otherStage.scene = new Scene(root) => [
					stylesheets.add(stylesheet)
				]
				context.otherController = loader.controller
				context.otherStage.show()
				callback?.accept(context.otherController)
			}
		}
	}
	
	override init() throws Exception {
		Application.context = new Context()
	}
	
	override stop() throws Exception {
		context.closeResources()
	}
}
