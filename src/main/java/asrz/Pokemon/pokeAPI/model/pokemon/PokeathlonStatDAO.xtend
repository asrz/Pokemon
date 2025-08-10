package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

@MongoPojo
class PokeathlonStatDAO extends NamedPokeApiResource {
	List<NameDAO> names
	NaturePokeathlonStatAffectSetsDAO affectingNatures
}

@MongoPojo
class NaturePokeathlonStatAffectSetsDAO {
	NaturePokeathlonStatAffectDAO increase
	NaturePokeathlonStatAffectDAO decrease
}

@MongoPojo
class NaturePokeathlonStatAffectDAO {
	int maxChange
	NamedApiResource<NatureDAO> nature
}

