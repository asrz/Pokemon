package asrz.Pokemon.pokeAPI.model.utility

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.encounters.EncounterConditionValueDAO
import asrz.Pokemon.pokeAPI.model.encounters.EncounterMethodDAO
import java.util.List

@MongoPojo
class EncounterDAO {
	int minLevel
	int maxLevel
	List<NamedApiResource<EncounterConditionValueDAO>> conditionValues
	int chance
	NamedApiResource<EncounterMethodDAO> method
}

