package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List
import asrz.Pokemon.pokeAPI.model.NamedApiResource

@MongoPojo
class PokeathlonStat extends NamedPokeApiResource {
	List<NameDAO> names
	NaturePokeathlonStatAffectSetsDAO affectingNatures
}

@MongoPojo
class NaturePokeathlonStatAffectSets {
	List<NaturePokeathlonStatAffect> increase
	List<NaturePokeathlonStatAffect> decrease
}

@MongoPojo
class NaturePokeathlonStatAffect {
	int maxChange
	NamedApiResource<NatureDAO> nature
}