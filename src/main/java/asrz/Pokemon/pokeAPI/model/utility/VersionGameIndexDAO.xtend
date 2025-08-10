package asrz.Pokemon.pokeAPI.model.utility

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.PokeApiResource
import asrz.Pokemon.pokeAPI.model.games.VersionDAO

@MongoPojo
class VersionGameIndexDAO extends PokeApiResource {
	int gameIndex
	NamedApiResource<VersionDAO> version
}