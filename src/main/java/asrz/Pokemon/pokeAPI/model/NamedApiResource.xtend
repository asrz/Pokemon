package asrz.Pokemon.pokeAPI.model

import asrz.Pokemon.pokeAPI.annotations.MongoPojo

@MongoPojo
class NamedApiResource<T extends NamedPokeApiResource> {
	String name
	String url
}