package asrz.Pokemon.pokeAPI.model.utility

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO

@MongoPojo
class VersionGroupFlavorTextDAO {
	String text
	NamedApiResource<LanguageDAO> language
	NamedApiResource<VersionGroupDAO> versionGroup
}