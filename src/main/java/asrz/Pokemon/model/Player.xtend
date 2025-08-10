package asrz.Pokemon.model

import org.bson.codecs.pojo.annotations.BsonIgnore
import xtendfx.beans.FXBindable
import asrz.Pokemon.model.enums.Region

@FXBindable
class Player extends Trainer {
	
	public static final String COLLECTION_NAME = "players"
	
	ItemBag itemBag = new ItemBag
	
	int maxGeneration = 1
	
	String languageName = 'en'
	
	PokedexList pokedexes = new PokedexList
	
	PC pc = new PC
	
	
	
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
	
	def getPokedexForRegion(Region region) {
		return pokedexes.findFirst[it.region == region]
	}
	
}