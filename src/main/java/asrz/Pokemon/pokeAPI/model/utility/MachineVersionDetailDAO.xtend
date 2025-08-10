package asrz.Pokemon.pokeAPI.model.utility

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.ApiResource
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO
import asrz.Pokemon.pokeAPI.model.machines.MachineDAO

@MongoPojo
class MachineVersionDetailDAO {
	ApiResource<MachineDAO> machine
	NamedApiResource<VersionGroupDAO> versionGroup
}