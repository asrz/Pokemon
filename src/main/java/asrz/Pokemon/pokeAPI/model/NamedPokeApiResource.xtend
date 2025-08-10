package asrz.Pokemon.pokeAPI.model

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import asrz.Pokemon.model.interfaces.ILabeled

@MongoPojo
abstract class NamedPokeApiResource extends PokeApiResource implements ILabeled {
	String name
	
	override String getLabel() {
		return name.toFirstUpper
	}
}
