package asrz.Pokemon.model

import asrz.Pokemon.model.enums.MoveLearnMethod
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonMoveDAO
import asrz.Pokemon.util.PokemonUtil
import java.util.ArrayList
import java.util.List
import xtendfx.beans.FXBindable

import static extension asrz.Pokemon.util.Extensions.*

@FXBindable
class PokemonMove extends Entity {
	
	public static final String COLLECTION_NAME = "pokemon_moves"
	
	//pokemonId, moveId?
	Move move
	MoveLearnMethod learnMethod
	Integer levelLearnedAt
	Integer order
	
	new () {}
	
	
	
	def static List<PokemonMove> fromApi(PokemonMoveDAO pokemonMoveDAO, MoveDAO moveDAO, String languageName) {
		val moveDetailsByGenerationAndLearnMethod = pokemonMoveDAO.versionGroupDetails.twoDimensionalGroupBy([PokemonUtil.getGenerationFromVersionOrVersionGroup(versionGroup.name)], [MoveLearnMethod.fromApiString(moveLearnMethod.name)])
		
		val List<PokemonMove> result = new ArrayList
		
		
		val maxGeneration = moveDetailsByGenerationAndLearnMethod.firstDimensionalKeySet.max
		val generation = 1 //TODO player.maxGeneration
		
		for (MoveLearnMethod learnMethod : moveDetailsByGenerationAndLearnMethod.secondDimensionalKeySet(generation)) {
			
			val canonicalMoveDetails = if (learnMethod == MoveLearnMethod.LEVEL_UP) {
				moveDetailsByGenerationAndLearnMethod.get(generation, learnMethod).filter[levelLearnedAt > 0].minBy[levelLearnedAt]
			} else {
				moveDetailsByGenerationAndLearnMethod.get(generation, learnMethod).lastOrNull
			}
			
			if (canonicalMoveDetails !== null && moveDetailsByGenerationAndLearnMethod.get(maxGeneration, learnMethod) !== null) {
				result.add(new PokemonMove() => [
					move = Move.fromApi(moveDAO, languageName)
					it.learnMethod = learnMethod
					levelLearnedAt = canonicalMoveDetails.levelLearnedAt
					order = canonicalMoveDetails.order
				])
			}
		}
		
		return result;
	}
	
	override getCollectionName() {
		return COLLECTION_NAME
	}
	
}