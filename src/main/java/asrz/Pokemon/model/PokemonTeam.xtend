package asrz.Pokemon.model

import asrz.Pokemon.util.Util
import java.util.List
import org.bson.codecs.pojo.annotations.BsonIgnore
import org.bson.types.ObjectId
import xtendfx.beans.FXBindable

@FXBindable
class PokemonTeam extends Entity {
	
	public static final String COLLECTION_NAME = "teams"
	
	ObjectId pokemon_1Id
	@BsonIgnore
	Pokemon pokemon_1
	
	ObjectId pokemon_2Id
	@BsonIgnore
	Pokemon pokemon_2
	
	ObjectId pokemon_3Id
	@BsonIgnore
	Pokemon pokemon_3
	
	ObjectId pokemon_4Id
	@BsonIgnore
	Pokemon pokemon_4
	
	ObjectId pokemon_5Id
	@BsonIgnore
	Pokemon pokemon_5
	
	ObjectId pokemon_6Id
	@BsonIgnore
	Pokemon pokemon_6
	
	@BsonIgnore
	def List<Pokemon> getAllPokemon() {
		return Util.list(pokemon_1, pokemon_2, pokemon_3, pokemon_4, pokemon_5, pokemon_6).filterNull.toList
	}
	
	def void populatePokemonIds() {
		pokemon_1Id = pokemon_1?.id
		pokemon_2Id = pokemon_2?.id
		pokemon_3Id = pokemon_3?.id
		pokemon_4Id = pokemon_4?.id
		pokemon_5Id = pokemon_5?.id
		pokemon_6Id = pokemon_6?.id
	}
	
	@BsonIgnore
	def List<ObjectId> getAllPokemonIds() {
		return Util.list(pokemon_1Id, pokemon_2Id, pokemon_3Id, pokemon_4Id, pokemon_5Id, pokemon_6Id).filterNull.toList
	}
	
	@BsonIgnore
	def getFirstLivingPokemon() {
		return getAllPokemon().findFirst[hp > 0]
	}
	
	@BsonIgnore
	def isFull() {
		return getAllPokemon.size == 6
	}
	
	def addPokemon(Pokemon pokemon) {
		if (pokemon_1 === null) {
			pokemon_1 = pokemon
		} else if (pokemon_2 === null) {
			pokemon_2 = pokemon
		} else if (pokemon_3 === null) {
			pokemon_3 = pokemon
		} else if (pokemon_4 === null) {
			pokemon_4 = pokemon
		} else if (pokemon_5 === null) {
			pokemon_5 = pokemon
		} else if (pokemon_6 === null) {
			pokemon_6 = pokemon
		} else {
			throw new RuntimeException("TOO MANY POKEMONS!")
		}
	}
	
	def healAllPokemon() {
		for (pokemon : allPokemon) {
			pokemon.healHpAndStatuses()
		}
	}
	
	@BsonIgnore
	override getCollectionName() {
		return COLLECTION_NAME
	}
	
}