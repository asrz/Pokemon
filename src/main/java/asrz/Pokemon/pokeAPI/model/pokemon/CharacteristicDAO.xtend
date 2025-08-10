package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.PokeApiResource
import asrz.Pokemon.pokeAPI.model.utility.DescriptionDAO
import java.util.List

class CharacteristicDAO extends PokeApiResource {
	int geneModulo
	List<Integer> possibleValues
	NamedApiResource<StatDAO> highestStat
	List<DescriptionDAO> description
}