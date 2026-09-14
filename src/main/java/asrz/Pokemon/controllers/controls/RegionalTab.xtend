package asrz.Pokemon.controllers.controls

import asrz.Pokemon.application.Application
import asrz.Pokemon.application.SceneHandle
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.controllers.views.PokemonEncountersViewController
import asrz.Pokemon.pokeAPI.model.locations.RegionDAO
import javafx.scene.control.Tab

class RegionalTab extends Tab implements IController {
	
	protected def void onClickScoutButton(RegionDAO regionDao, String locationName) {
		Application.setScene(SceneHandle.POKEMON_ENCOUNTERS_VIEW, [new PokemonEncountersViewController()], [ controller |
			(controller as PokemonEncountersViewController).scoutEncounters(regionDao, locationName)
		])
	}
}