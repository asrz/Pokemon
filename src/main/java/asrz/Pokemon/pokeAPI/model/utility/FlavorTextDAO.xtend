package asrz.Pokemon.pokeAPI.model.utility

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.games.VersionDAO

@MongoPojo
class FlavorTextDAO {
	String flavorText
	NamedApiResource<LanguageDAO> language
	NamedApiResource<VersionDAO> version
}