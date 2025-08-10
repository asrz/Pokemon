package asrz.Pokemon.pokeAPI.model

import asrz.Pokemon.pokeAPI.annotations.MongoPojo

@MongoPojo
class ApiResource<T extends PokeApiResource> {
	String url
}