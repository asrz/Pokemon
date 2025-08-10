package asrz.Pokemon.pokeAPI.model

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import org.bson.codecs.pojo.annotations.BsonProperty

@MongoPojo
abstract class PokeApiResource {
	@BsonProperty("id")
	Integer id
}