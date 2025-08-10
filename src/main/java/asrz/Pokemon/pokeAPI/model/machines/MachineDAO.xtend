package asrz.Pokemon.pokeAPI.model.machines

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.PokeApiResource
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO
import asrz.Pokemon.pokeAPI.model.items.ItemDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO

@MongoPojo
class MachineDAO extends PokeApiResource {
	NamedApiResource<ItemDAO> item
	NamedApiResource<MoveDAO> move
	NamedApiResource<VersionGroupDAO> versionGroup
}