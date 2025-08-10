module asrz.Pokemon {
	requires javafx.controls;
	requires javafx.fxml;
	requires org.eclipse.xtext.xbase.lib;
	requires org.eclipse.xtend.lib;
	requires xtendfx;
	requires org.mongodb.driver.core;
	requires org.mongodb.driver.sync.client;
	requires asrz.Pokemon.annotations
	
	opens asrz.Pokemon.application to javafx.graphics, javafx.fxml;
	opens asrz.Pokemon.model to javafx.fxml;
	opens asrz.Pokemon.views to javafx.fxml;
	opens asrz.Pokemon.controls to javafx.fxml
}
