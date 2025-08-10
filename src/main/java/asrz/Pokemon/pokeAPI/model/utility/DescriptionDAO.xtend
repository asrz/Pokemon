package asrz.Pokemon.pokeAPI.model.utility

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource

@MongoPojo
class DescriptionDAO {
	String desciption
	NamedApiResource<LanguageDAO> language
}