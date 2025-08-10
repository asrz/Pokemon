package asrz.Pokemon.service

import org.junit.jupiter.api.Test

class PokemonServiceTest extends BaseServiceTest {
	
	@Test
	def test_buildPokemon() {
		val pikachu = c.pokemonService.buildPokemon("pikachu", 2)
	}
}