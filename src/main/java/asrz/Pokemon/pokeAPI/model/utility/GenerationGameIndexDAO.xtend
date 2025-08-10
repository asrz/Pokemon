package asrz.Pokemon.pokeAPI.model.utility

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.games.GenerationDAO

@MongoPojo
class GenerationGameIndexDAO {
	int gameIndex
	NamedApiResource<GenerationDAO> generation
}