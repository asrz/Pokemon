package asrz.Pokemon.pokeAPI.model.locations

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.pokeAPI.model.NamedApiResource
import asrz.Pokemon.pokeAPI.model.NamedPokeApiResource
import asrz.Pokemon.pokeAPI.model.utility.GenerationGameIndexDAO
import asrz.Pokemon.pokeAPI.model.utility.NameDAO
import java.util.List

@MongoPojo
class LocationDAO extends NamedPokeApiResource {
	NamedApiResource<RegionDAO> region
	List<NameDAO> names
	List<GenerationGameIndexDAO> gameIndices
	List<NamedApiResource<LocationAreaDAO>> areas
	
	@Deprecated
	override getLabel() {
		throw new UnsupportedOperationException("use getLabel(String) instead")
	}
	
	def getLabel(String languageName) {
		names.findFirst[language.name == languageName]?.name ?: name
	}
}