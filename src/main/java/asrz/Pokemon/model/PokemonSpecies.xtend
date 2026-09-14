package asrz.Pokemon.model

import asrz.Pokemon.model.enums.GrowthRate
import asrz.Pokemon.model.enums.Stat
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.model.interfaces.ILabeled
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.pokemon.AbilityDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonFormDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpeciesDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpritesDAO
import asrz.Pokemon.util.Util
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class PokemonSpecies implements ILabeled {
	
	public static final String[] ULTRA_BEASTS = #[
		"nihilego", "buzzwole", "pheromosa", "xurkitree", "celesteela", "kartana", "guzzlord", "poipole", "naganadel", "stakataka", "blacephalon"
	]
	
	Integer pokemonDaoId
	String pokemonDaoName
	Integer pokemonSpeciesDaoId
	String pokemonSpeciesDaoName
	
	String name
	Type type_1
	Type type_2
	
	int nationalDexNumber
	
	GrowthRate growthRate
	int genderRate
	
	int baseHp
	int baseAttack
	int baseDefense
	int baseSpecialAttack
	int baseSpecialDefense
	int baseSpeed
	
	PokemonSpritesDAO sprites
	
	int baseExperience //the amount of xp awarded for defeating this pokemon
	int captureRate
	
	List<PokemonMove> pokemonMoves
	List<Ability> abilities
	Ability hiddenAbility
	
	int weight //in hectograms
	
	new() {}
	
	new(
		PokemonSpeciesDAO pokemonSpeciesDAO, 
		PokemonFormDAO pokemonFormDAO, 
		PokemonDAO pokemonDAO, 
		List<MoveDAO> moveDAOs, 
		List<AbilityDAO> abilityDAOs,
		AbilityDAO hiddenAbilityDAO,
		String languageName
	) {
		pokemonDaoId = pokemonDAO.id
		pokemonDaoName = pokemonDAO.name
		pokemonSpeciesDaoId = pokemonSpeciesDAO.id
		pokemonSpeciesDaoName = pokemonSpeciesDAO.name
		name = pokemonSpeciesDAO.names.findFirst[language.name == languageName]?.name ?: name
		genderRate = pokemonSpeciesDAO.genderRate
		growthRate = GrowthRate.fromPokeApiLabel(pokemonSpeciesDAO.growthRate.name)
		nationalDexNumber = pokemonSpeciesDAO.pokedexNumbers.findFirst[pokedex.name == 'national'].entryNumber
		
		type_1 = Type.fromAPI(pokemonFormDAO.types.findFirst[slot == 1]?.type?.name)
		type_2 = Type.fromAPI(pokemonFormDAO.types.findFirst[slot == 2]?.type?.name)
		
		abilities = abilityDAOs.map[dao | Ability.fromApi(dao, languageName)].toList
		hiddenAbility = Ability.fromApi(hiddenAbilityDAO, languageName)
		
		pokemonDAO.stats.forEach[setBaseStat(Stat.fromApiString(stat.name), baseStat)]
		
		sprites = pokemonDAO.sprites
		
		baseExperience = pokemonDAO.baseExperience
		captureRate = pokemonSpeciesDAO.captureRate
		
		weight = pokemonDAO.weight
		
		val moveDAOsByName = moveDAOs.toMap[it.name]
		pokemonMoves = pokemonDAO.moves.flatMap[pokemonMoveDAO |
			val moveDAO = moveDAOsByName.get(pokemonMoveDAO.move.name)
			if (moveDAO === null) {
				throw new RuntimeException("Missing move: " + pokemonMoveDAO.move.name)
			}
			PokemonMove.fromApi(pokemonMoveDAO, moveDAO, languageName)
		].toList
	}
	
	def setBaseStat(Stat stat, int baseStat) {
		switch(stat) {
			case HP: baseHp = baseStat
			case ATTACK: baseAttack = baseStat
			case DEFENSE: baseDefense = baseStat
			case SPECIAL_ATTACK: baseSpecialAttack = baseStat
			case SPECIAL_DEFENSE: baseSpecialDefense = baseStat
			case SPEED: baseSpeed = baseStat
			default:
				throw new RuntimeException("Unexpected base stat: " + stat)
		}
	}
	
	def List<Type> getTypes() {
		return Util.list(type_1, type_2).filterNull.toList
	}
	
	override String getLabel() {
		return name.toFirstUpper
	}
}
