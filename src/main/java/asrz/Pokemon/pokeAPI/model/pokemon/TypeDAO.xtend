package asrz.Pokemon.pokeAPI.model.pokemon

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.games.GenerationDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveDamageClassDAO
import asrz.Pokemon.pokeAPI.model.utility.GenerationGameIndexDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List

@MongoPojo
class TypeDAO extends NamedPokeApiResource {
	TypeRelationsDAO damageRelations
	List<TypeRelationsPastDAO> pastDamageRelations
	List<GenerationGameIndexDAO> gameIndices
	NamedApiResource<GenerationDAO> generation
	NamedApiResource<MoveDamageClassDAO> moveDamageClass
	List<NameDAO> names
	List<TypePokemonDAO> pokemon
	List<NamedApiResource<MoveDAO>> moves
}

@MongoPojo
class TypePokemonDAO {
	int slot
	NamedApiResource<PokemonDAO> pokemon
}

@MongoPojo
class TypeRelationsDAO {
	NamedApiResource<TypeDAO> noDamageTo
	NamedApiResource<TypeDAO> halfDamageTo
	NamedApiResource<TypeDAO> doubleDamageTo
	
	NamedApiResource<TypeDAO> noDamageFrom
	NamedApiResource<TypeDAO> halfDamageFrom
	NamedApiResource<TypeDAO> doubleDamageFrom
}

@MongoPojo
class TypeRelationsPastDAO {
	NamedApiResource<GenerationDAO> generation
	TypeRelationsDAO damageRelations
}