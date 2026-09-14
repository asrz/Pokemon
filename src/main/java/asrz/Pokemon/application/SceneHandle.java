package asrz.Pokemon.application;

public enum SceneHandle {

	SAMPLE("/fxml/views/Sample.fxml"),
	STARTER_CHOICE("/fxml/views/StarterChoice.fxml"),
	BATTLE_VIEW("/fxml/views/BattleView.fxml"),
	MAIN_VIEW("/fxml/views/MainView.fxml"),
	BAG_VIEW("/fxml/views/BagView.fxml"),
	TEAM_VIEW("/fxml/views/TeamView.fxml"),
	POKEDEX_ENTRY_VIEW("/fxml/views/PokedexEntryView.fxml"),
	POKEMON_ENCOUNTERS_VIEW("/fxml/views/PokemonEncountersView.fxml"),
	;
	
	private String fxmlPath;
	
	private SceneHandle(String fxmlPath) {
		this.fxmlPath = fxmlPath;
	}
	
	public String getFxmlPath() { return fxmlPath; }
}
