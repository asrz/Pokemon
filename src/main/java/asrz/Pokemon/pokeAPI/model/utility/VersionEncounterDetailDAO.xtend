package asrz.Pokemon.pokeAPI.model.utility

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.games.VersionDAO
import java.util.List

@MongoPojo
class VersionEncounterDetailDAO {
	NamedApiResource<VersionDAO> version
	int maxChance
	List<EncounterDAO> encounterDetails
}