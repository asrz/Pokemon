package asrz.Pokemon.model

import asrz.Pokemon.application.Context
import asrz.Pokemon.model.interfaces.ILabeled
import org.bson.codecs.pojo.annotations.BsonIgnore
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.xbase.lib.Functions.Function1

@Accessors
class Trainer extends Entity implements ILabeled {
	
	TrainerClass trainerClass
	boolean wild = false//this trainer is actually a wild battle
	
	String name
	
	PokemonTeam team = new PokemonTeam
	
	Function1<Context, PokemonTeam> teamFunction

	new() {}
	
	new(TrainerClass trainerClass, String name) {
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
		return (trainerClass?.label ?: "") + " " + name
	}
	
	@BsonIgnore
	override getCollectionName() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}