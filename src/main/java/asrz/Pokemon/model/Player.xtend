package asrz.Pokemon.model

import asrz.Pokemon.model.enums.Region
import org.bson.codecs.pojo.annotations.BsonIgnore
import xtendfx.beans.FXBindable

@FXBindable
class Player extends Trainer {
	
	public static final String COLLECTION_NAME = "players"
	
	ItemBag itemBag = new ItemBag
	
	int maxGeneration = 1
	
	String languageName = 'en'
	
	PokedexList pokedexes = new PokedexList
	
	PC pc = new PC
	
	GymId currentGymId = null
	Integer currentGymProgress = 0
	
	
	override addPokemon(Pokemon pokemon) {
		if (pc.unlockedPokemonDaoIds.contains(pokemon.pokemonDaoId)) {
			
		} else {
			pc.addPokemon(pokemon)
			if (!team.full) {
				team.addPokemon(pokemon)
			}
		}
	}
	
	@BsonIgnore
	override String getCollectionName() {
		return COLLECTION_NAME
	}
	
	@BsonIgnore
	def getPokedexForRegion(Region region) {
		return pokedexes.findFirst[it.region == region]
	}
	
	@BsonIgnore
	def getCurrentGym() {
		return Gyms.gymMap.get(currentGymId)
	}
	
}