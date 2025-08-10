package asrz.Pokemon.model

import asrz.Pokemon.model.interfaces.ILabeled
import org.eclipse.xtend.lib.annotations.Accessors
import org.bson.codecs.pojo.annotations.BsonIgnore

@Accessors
class Trainer extends Entity implements ILabeled {
	
	boolean wild = false//this trainer is actually a wild battle
	
	String trainerClass
	String name
	
	PokemonTeam team = new PokemonTeam

	new() {}
	
	new(String trainerClass, String name) {
		this.trainerClass = trainerClass
		this.name = name
	}

	def void addPokemon(Pokemon pokemon) {
		if (team.full) {
			throw new RuntimeException(String.format("Trainer %s %s team full", trainerClass, name))
		}
		
		team.addPokemon(pokemon)
	}
	
	@BsonIgnore
	override String getLabel() {
		return trainerClass ?: "" + " " + name
	}
	
	@BsonIgnore
	override getCollectionName() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}