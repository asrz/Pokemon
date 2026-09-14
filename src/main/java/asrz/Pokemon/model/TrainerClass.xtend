package asrz.Pokemon.model

import asrz.Pokemon.model.interfaces.ILabeled
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import asrz.Pokemon.util.Util
import java.util.function.Predicate
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.xbase.lib.Functions.Function1

@Accessors
class TrainerClass implements ILabeled {
	
	String name
	String sprite
	Function1<PokemonDAO, Boolean> pokemonPredicate
	
	new () {}
	
	new(String name, Predicate<PokemonDAO> pokemonPredicate) {
		this.name = name
		this.pokemonPredicate = pokemonPredicate
	}
	
	override getLabel() {
		return name
	}
	
}

class TrainerClasses {
	//gen 1
	public static final TrainerClass ACE_TRAINER = new TrainerClass("Ace Trainer", [ pokemonDAO |
		return false //TODO
	])
	
	public static final TrainerClass BEAUTY = new TrainerClass("Beauty", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "bellsprout", "weepinbel", "victreebel", "oddish", "gloom", "vileplume", "exeggcute", 
			"exeggutor", "vulpix", "ninetales", "clefairy", "cleafable", "jigglypuff", "wigglytuff"
		)
	])
	
	public static final TrainerClass BIKER = new TrainerClass("Biker", [ pokemonDAO |
		Util.in(pokemonDAO.name, "koffing", "weezing", "grimer", "muk")
	])
	
	public static final TrainerClass BIRD_KEEPER = new TrainerClass("Bird Keeper", [ pokemonDAO |
		Util.in(pokemonDAO.name, "spearow", "fearow", "pidgey", "pidgeotto", "pidgeot", "doduo", "dodrio", "farfetchd")
	])
	
	public static final TrainerClass BLACK_BELT = new TrainerClass("Black Belt", [ pokemonDAO |
		pokemonDAO.types.map[name].contains("fighting")
	])
	
	public static final TrainerClass BURGLAR = new TrainerClass("Burglar", [ pokemonDAO |
		pokemonDAO.types.map[name].contains("fire") || Util.in(pokemonDAO.name, "koffing", "weezing", "grimer", "muk")
	])
	
	public static final TrainerClass BUG_CATCHER = new TrainerClass("Bug Catcher", [ pokemonDAO |
		return pokemonDAO.types.map[name].contains("bug")
	])
	
	public static final TrainerClass CAMPER = new TrainerClass("Camper", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "sandshrew", "sandslash", "rattata", "raticate", "ekans", "arbok", "nidoran-m", 
			"squirtle", "charmander", "bulbasaur"
		)
	])
	
	public static final TrainerClass CHANNELER = new TrainerClass("Channeler", [ pokemonDAO |
		return pokemonDAO.types.map[name].contains("ghost")
	])
	
	public static final TrainerClass COOLTRAINER = new TrainerClass("Cooltrainer", null)
	
	public static final TrainerClass ENGINEER = new TrainerClass("Engineer", [ pokemonDAO |
		return pokemonDAO.types.map[name].contains("electric")
	])
	
	public static final TrainerClass FISHER = new TrainerClass("Fisher", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "magikarp", "goldeen", "seaking", "tentacool", "tentacruel", "staryu", "starmie", 
			"poliwag", "poliwhirl", "poliwrath", "shellder", "cloyster", "horsea", "seadra"
		)
	])
	
	//public static final TrainerClass PI //gambler/gamer OHKO moves
	
	public static final TrainerClass GENTLEMEN = new TrainerClass("Gentlemen", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "growlithe", "pikachu", "nidoran-m", "nidoran-f", "ponyta")
	])
	
	public static final TrainerClass HIKER = new TrainerClass("Hiker", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "geodude", "graveler", "golem", "onix", "machop", "machoke", "machamp", "diglett", 
			"dugtrio", "sandshrew", "sandslash"
		)
	])
	
	public static final TrainerClass JUGGLER = new TrainerClass("Juggler", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "mr-mime", "kadabra", "drowzee", "hypno", "voltorb", "electrode")
	])
	
	public static final TrainerClass LASS = new TrainerClass("Lass", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "nidoran-m", "nidoran-f", "pidget", "rattata", "jigglypuff", "clefairy", "oddish", 
			"bellsprout", "pikachu", "meowth", "paras"
		)
	])
	
	public static final TrainerClass LEADER = new TrainerClass("Leader", null)
	
	public static final TrainerClass POKEMANIAC = new TrainerClass("Pokémaniac", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "cubone", "marowak", "slowpoke", "slowbro", "rhyhorn", "rhydon", "lickitung", 
			"lapras", "nidoran-m", "nidoran-f", "nidorino", "nidorina", "nidoqueen", "nidoking", "kangaskhan"
		)
	])
	
	public static final TrainerClass PICNICKER = new TrainerClass("Picnicker", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "pikachu", "raichu", "clefairy", "clefable", "jigglypuff", "wigglytuff", "pidgey", 
			"bellsprout", "oddish", "gloom", "goldeen", "seaking", "meowth", "tangela", "poliwag", "horsea"
		)
	])
	
	public static final TrainerClass PSYCHIC = new TrainerClass("Psychic", [ pokemonDAO |
		return pokemonDAO.types.map[name].contains("psychic")
	])
	
	public static final TrainerClass ROCKER = new TrainerClass("Rocker", [ pokemonDAO |
		return pokemonDAO.types.map[name].contains("electric")
	])
	
	public static final TrainerClass ROCKET_GRUNT = new TrainerClass("Team Rocket Grunt", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "rattata", "raticate", "zubat", "golbat", "ekans", "arbok", "meowth", "koffing", 
			"weezing", "machop", "machoke", "drowzee", "hypno", "grimer", "muk", "sandshrew", "sandslash"
		)
	])
	
	public static final TrainerClass ROUGHNECK = new TrainerClass("Roughneck", [ pokemonDAO |
		val typeNames = pokemonDAO.types.map[name]
		return typeNames.contains("fighting") || typeNames.contains("dark")
	])
	
	public static final TrainerClass SAILOR = new TrainerClass("Sailor", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "poliwag", "poliwhirl", "poliwrath", "krabby", "kingler", "psyduck", "golduck")
	])
	
	public static final TrainerClass SCIENTIST = new TrainerClass("Scientist", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "magnemite", "magneton", "voltorb", "electrode", "grimer", "muk", "koffing", 
			"weezing", "porygon", "ditto"
		)
	])
	
	public static final TrainerClass SUPER_NERD = new TrainerClass("Super Nerd", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "magnemite", "magneton", "voltorb", "electrode", "grimer", "muk", "koffing", 
			"weezing", "porygon", "ditto"
		)
	])
	
	public static final TrainerClass SWIMMER = new TrainerClass("Swimmer", [ pokemonDAO |
		return pokemonDAO.types.map[name].contains("water")
	])
	
	public static final TrainerClass TAMER = new TrainerClass("Tamer", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "arbok", "tauros", "sandslash", "rhyhorn", "persian", "golduck", "lickitung")
	])
	
	public static final TrainerClass YOUNGSTER = new TrainerClass("Youngster", [ pokemonDAO |
		return Util.in(pokemonDAO.name, "rattata", "raticate", "ekans", "arbok", "spearow", "fearow", "zubat", "golbat", 
			"slowpoke", "slowbro", "sandshrew", "sandslash", "nidoran-m", "nidorino", "nidoking", "nidoran-f", "nidorina", "nidoqueen"
		)
	])
}