package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.berries.BerryFlavorDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveBattleStyleDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List

@MongoPojo
class NatureDAO extends NamedPokeApiResource {
	NamedApiResource<StatDAO> descreasedStat
	NamedApiResource<StatDAO> increasedStat
	NamedApiResource<BerryFlavorDAO> hatesFlavor
	NamedApiResource<BerryFlavorDAO> likesFlavor
	List<NatureStatChangeDAO> pokeathlonStatChanges
	List<MoveBattleStylePreferenceDAO> moveBattleStylePreference
	List<NameDAO> names
}

@MongoPojo
class NatureStatChangeDAO {
	int maxChange
	NamedApiResource<PokeathlonStatDAO> pokeathlonStat
}

@MongoPojo
class MoveBattleStylePreferenceDAO {
	int lowHpPreference
	int highHpPreference
	NamedApiResource<MoveBattleStyleDAO> moveBattleStyle
}