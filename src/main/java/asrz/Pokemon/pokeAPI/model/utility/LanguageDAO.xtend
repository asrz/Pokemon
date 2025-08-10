package asrz.Pokemon.pokeAPI.model.utility

import java.util.List
import org.bson.codecs.pojo.annotations.BsonProperty
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource

class LanguageDAO extends NamedPokeApiResource {
	@BsonProperty("official")
	boolean official
	String iso639
	String iso3166
	List<NameDAO> names
}