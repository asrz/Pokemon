package asrz.Pokemon.model

import asrz.Pokemon.application.Context
import asrz.Pokemon.model.enums.Badge
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Data

@Data
class Gym {
	String name
	Badge badge
	Item reward
	List<Trainer> trainers
}

enum GymId {
	PEWTER_GYM,
	CERULEAN_GYM,
	VERMILLION_GYM,
	CELADON_GYM,
	FUSCHIA_GYM,
	SAFFRON_GYM,
	CINNABAR_GYM,
	VIRIDIAN_GYM
	;
}

class Gyms {
	public static final Map<GymId, Gym> gymMap = #{
		GymId.PEWTER_GYM -> new Gym("Pewter Gym", Badge.BOULDER, null /*TM Rock Tomb */, #[
			new Trainer(TrainerClasses.CAMPER, "Liam") => [
				teamFunction = [ Context c | 
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("geodude", 10))
						addPokemon(c.pokemonService.buildPokemon("sandshrew", 11))
					]
				]
			],
			new Trainer(TrainerClasses.LEADER, "Brock") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("geodude", 12, "rock-head", #["tackle", "defense-curl"]))
						addPokemon(c.pokemonService.buildPokemon("onix", 14, "rock-head", #["tackle", "harden", "bind", "rock-tomb"]))
					]
				]
			]
		]),
		
		GymId.CERULEAN_GYM -> new Gym("Cerulean Gym", Badge.CASCADE, null, #[
			new Trainer(TrainerClasses.SWIMMER, "Luis") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("horsea", 16))
						addPokemon(c.pokemonService.buildPokemon("shellder", 16))
					]
				]
			],
			new Trainer(TrainerClasses.PICNICKER, "Diana") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("goldeen", 19))
					]
				]
			],
			new Trainer(TrainerClasses.LEADER, "Misty") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("staryu", 18, "natural-cure", #["tackle", "harden", "recover", "water-pulse"]))
						addPokemon(c.pokemonService.buildPokemon("starmie", 21, "natural-cure", #["rapid-spin", "swift", "recover", "water-pulse"]))
					]
				]
			]
		]),
		
		GymId.VERMILLION_GYM -> new Gym("Vermillion Gym", Badge.THUNDER, null, #[
			new Trainer(TrainerClasses.SAILOR, "Dwayne") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("pikachu", 21))
						addPokemon(c.pokemonService.buildPokemon("pikachu", 21))
					]
				]
			],
			new Trainer(TrainerClasses.ENGINEER, "Baily") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("voltorb", 21))
						addPokemon(c.pokemonService.buildPokemon("magnemite", 21))
					]
				]
			],
			new Trainer(TrainerClasses.SAILOR, "Tucker") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("pikachu", 23))
					]
				]
			],
			new Trainer(TrainerClasses.LEADER, "Lt. Surge") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("voltorb", 21, "soundproof", #["shock-wave", "tackle", "screech", "sonic-boom"]))
						addPokemon(c.pokemonService.buildPokemon("pikachu", 18, "static", #["shock-wave", "thunder-wave", "quick-attack", "double-team"]))
						addPokemon(c.pokemonService.buildPokemon("raichu", 24, "static", #["shock-wave", "thunder-wave", "quick-attack", "double-team"]))
					]
				]
			]
		]),
		
		GymId.CELADON_GYM -> new Gym("Celadon Gym", Badge.RAINBOW, null, #[
			new Trainer(TrainerClasses.LASS, "Kay") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("bellsprout", 23))
						addPokemon(c.pokemonService.buildPokemon("weepinbell", 23))
					]
				]
			],
			new Trainer(TrainerClasses.BEAUTY, "Bridget") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("oddish", 21))
						addPokemon(c.pokemonService.buildPokemon("oddish", 21))
						addPokemon(c.pokemonService.buildPokemon("bellsprout", 21))
						addPokemon(c.pokemonService.buildPokemon("bellsprout", 21))
					]
				]
			],
			new Trainer(TrainerClasses.COOLTRAINER, "Mary") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("bellsprout", 22))
						addPokemon(c.pokemonService.buildPokemon("oddish", 22))
						addPokemon(c.pokemonService.buildPokemon("weepinbell", 22))
						addPokemon(c.pokemonService.buildPokemon("gloom", 22))
						addPokemon(c.pokemonService.buildPokemon("ivysaur", 22))
					]
				]
			],
			new Trainer(TrainerClasses.LASS, "Lisa") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("oddish", 23))
						addPokemon(c.pokemonService.buildPokemon("gloom", 23))
					]
				]
			],
			new Trainer(TrainerClasses.PICNICKER, "Tina") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("bulbasaur", 24))
						addPokemon(c.pokemonService.buildPokemon("ivysaur", 24))
					]
				]
			],
			new Trainer(TrainerClasses.BEAUTY, "Lori") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("exeggcute", 24))
					]
				]
			],
			new Trainer(TrainerClasses.BEAUTY, "Tamia") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("bellsprout", 24))
						addPokemon(c.pokemonService.buildPokemon("bellsprout", 24))
					]
				]
			],
			new Trainer(TrainerClasses.LEADER, "Erika") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("victreebel", 29, "chlorophyll", #["stun-spore", "acid", "poison-powder", "giga-drain"]))
						addPokemon(c.pokemonService.buildPokemon("tangela", 24, "chlorophyll", #["poison-powder", "constrict", "ingrain", "giga-drain"]))
						addPokemon(c.pokemonService.buildPokemon("vileplume", 29, "chlorophyll", #["sleep-powder", "acid", "stun-spore", "giga-drain"]))
					]
				]
			]
		]),
		
		GymId.FUSCHIA_GYM -> new Gym("Fuschia Gym", Badge.SOUL, null, #[
			new Trainer(TrainerClasses.JUGGLER, "Nate") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("drowzee", 34))
						addPokemon(c.pokemonService.buildPokemon("kadabra", 34))
					]
				]
			],
			new Trainer(TrainerClasses.JUGGLER, "Kayden") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("hypno", 38))
					]
				]
			],
			new Trainer(TrainerClasses.JUGGLER, "Kirk") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("drowzee", 31))
						addPokemon(c.pokemonService.buildPokemon("drowzee", 31))
						addPokemon(c.pokemonService.buildPokemon("kadabra", 31))
						addPokemon(c.pokemonService.buildPokemon("drowzee", 31))
					]
				]
			],
			new Trainer(TrainerClasses.TAMER, "Edgar") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("arbok", 33))
						addPokemon(c.pokemonService.buildPokemon("arbok", 33))
						addPokemon(c.pokemonService.buildPokemon("sandslash", 33))
					]
				]
			],
			new Trainer(TrainerClasses.TAMER, "Phil") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("sandslash", 34))
						addPokemon(c.pokemonService.buildPokemon("arbok", 34))
					]
				]
			],
			new Trainer(TrainerClasses.JUGGLER, "Shawn") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("drowzee", 34))
						addPokemon(c.pokemonService.buildPokemon("hypno", 34))
					]
				]
			],
			new Trainer(TrainerClasses.LEADER, "KOGA") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("koffing", 37, "levitate", #["self-destruct", "sludge", "smoke-screen", "toxic"]))
						addPokemon(c.pokemonService.buildPokemon("muk", 39, "stick-hold", #["minimize", "sludge", "acid-armor", "toxic"]))
						addPokemon(c.pokemonService.buildPokemon("koffing", 37, "levitate", #["self-destruct", "sludge", "smoke-screen", "toxic"]))
						addPokemon(c.pokemonService.buildPokemon("weezing", 43, "levitate", #["tackle", "sludge", "smoke-screen", "toxic"]))
					]
				]
			]
		]),
		
		GymId.SAFFRON_GYM -> new Gym("Saffron Gym", Badge.MARSH, null, #[
			new Trainer(TrainerClasses.PSYCHIC, "Cameron") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("slowpoke", 33))
						addPokemon(c.pokemonService.buildPokemon("slowpoke", 33))
						addPokemon(c.pokemonService.buildPokemon("slowbro", 33))
					]
				]
			],
			new Trainer(TrainerClasses.PSYCHIC, "Tyron") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("mr-mime", 34))
						addPokemon(c.pokemonService.buildPokemon("kadabra", 34))
					]
				]
			],
			new Trainer(TrainerClasses.CHANNELER, "Stacy") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("haunter", 38))
					]
				]
			],
			new Trainer(TrainerClasses.PSYCHIC, "Preston") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("slowbro", 38))
					]
				]
			],
			new Trainer(TrainerClasses.CHANNELER, "Amanda") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("gastly", 34))
						addPokemon(c.pokemonService.buildPokemon("haunter", 34))
					]
				]
			],
			new Trainer(TrainerClasses.CHANNELER, "Tasha") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("gastly", 33))
						addPokemon(c.pokemonService.buildPokemon("gastly", 33))
						addPokemon(c.pokemonService.buildPokemon("haunter", 33))
					]
				]
			],
			new Trainer(TrainerClasses.PSYCHIC, "Johan") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("kadabra", 31))
						addPokemon(c.pokemonService.buildPokemon("mr-mime", 31))
						addPokemon(c.pokemonService.buildPokemon("slowpoke", 31))
						addPokemon(c.pokemonService.buildPokemon("kadabra", 31))
					]
				]
			],
			new Trainer(TrainerClasses.LEADER, "Sabrina") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("kadabra", 38, "synchronize", #["psybeam", "reflect", "future-sight", "calm-mind"]))
						addPokemon(c.pokemonService.buildPokemon("mr-mime", 37, "soundproof", #["barrier", "psybeam", "baton-pass", "calm-mind"]))
						addPokemon(c.pokemonService.buildPokemon("venomoth", 38, "shield-dust", #["psybeam", "gust", "leech-life", "supersonic"]))
						addPokemon(c.pokemonService.buildPokemon("alakazam", 37, "synchronize", #["psychic", "recover", "future-sight", "calm-mind"]))
					]
				]
			]
		]),
		
		GymId.VIRIDIAN_GYM -> new Gym("Viridian Gym", Badge.EARTH, null, #[
			new Trainer(TrainerClasses.TAMER, "Cole") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("arbok", 39))
						addPokemon(c.pokemonService.buildPokemon("tauros", 39))
					]
				]
			],
			new Trainer(TrainerClasses.BLACK_BELT, "Kiyo") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("machoke", 43)) //TODO black belt
					]
				]
			],
			new Trainer(TrainerClasses.COOLTRAINER, "Samuel") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("sandslash", 37))
						addPokemon(c.pokemonService.buildPokemon("sandslash", 37))
						addPokemon(c.pokemonService.buildPokemon("rhyhorn", 38))
						addPokemon(c.pokemonService.buildPokemon("nidorino", 39))
						addPokemon(c.pokemonService.buildPokemon("nidoking", 39))
					]
				]
			],
			new Trainer(TrainerClasses.COOLTRAINER, "Yuji") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("sandslash", 38))
						addPokemon(c.pokemonService.buildPokemon("graveler", 38))
						addPokemon(c.pokemonService.buildPokemon("onix", 38))
						addPokemon(c.pokemonService.buildPokemon("graveler", 38))
						addPokemon(c.pokemonService.buildPokemon("marowak", 38))
					]
				]
			],
			new Trainer(TrainerClasses.BLACK_BELT, "Atsushi") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("machop", 40)) //TODO black belt
						addPokemon(c.pokemonService.buildPokemon("machoke", 40)) //TODO black belt
					]
				]
			],
			new Trainer(TrainerClasses.TAMER, "Jason") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("rhyhorn", 43))
					]
				]
			],
			new Trainer(TrainerClasses.COOLTRAINER, "Warren") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("marowak", 37))
						addPokemon(c.pokemonService.buildPokemon("marowak", 37))
						addPokemon(c.pokemonService.buildPokemon("rhyhorn", 38))
						addPokemon(c.pokemonService.buildPokemon("nidorina", 39))
						addPokemon(c.pokemonService.buildPokemon("nidoqueen", 39))
					]
				]
			],
			new Trainer(TrainerClasses.BLACK_BELT, "Takashi") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("machoke", 38))
						addPokemon(c.pokemonService.buildPokemon("machop", 38))
						addPokemon(c.pokemonService.buildPokemon("machoke", 38))
					]
				]
			],
			new Trainer(TrainerClasses.LEADER, "Giovanni") => [
				teamFunction = [ Context c |
					return new PokemonTeam() => [
						addPokemon(c.pokemonService.buildPokemon("rhyhorn", 45, "lightning-rod", #["take-down", "rock-blast", "scary-face", "earthquake"]))
						addPokemon(c.pokemonService.buildPokemon("dugtrio", 42, "sand-veil", #["slash", "sand-tomb", "mud-slap", "earthquake"]))
						addPokemon(c.pokemonService.buildPokemon("nidoqueen", 44, "poison-point", #["double-kick", "earthquake", "poison-sting", "body-slam"]))
						addPokemon(c.pokemonService.buildPokemon("nidoking", 45, "poison-point", #["double-kick", "earthquake", "poison-sting", "thrash"]))
						addPokemon(c.pokemonService.buildPokemon("rhyhorn", 50, "lightning-rod", #["take-down", "rock-blast", "scary-face", "earthquake"]))
					]
				]
			]
		])
	}
}