package asrz.Pokemon.util

import asrz.Pokemon.model.Entity
import asrz.Pokemon.model.Player
import asrz.Pokemon.model.Pokemon
import asrz.Pokemon.pokeAPI.model.PokeApiResource
import asrz.Pokemon.pokeAPI.model.berries.BerryDAO
import asrz.Pokemon.pokeAPI.model.berries.BerryFirmnessDAO
import asrz.Pokemon.pokeAPI.model.berries.BerryFlavorDAO
import asrz.Pokemon.pokeAPI.model.contests.ContestEffectDAO
import asrz.Pokemon.pokeAPI.model.contests.ContestTypeDAO
import asrz.Pokemon.pokeAPI.model.contests.SuperContestEffectDAO
import asrz.Pokemon.pokeAPI.model.encounters.EncounterConditionDAO
import asrz.Pokemon.pokeAPI.model.encounters.EncounterConditionValueDAO
import asrz.Pokemon.pokeAPI.model.encounters.EncounterMethodDAO
import asrz.Pokemon.pokeAPI.model.evolution.EvolutionChainDAO
import asrz.Pokemon.pokeAPI.model.evolution.EvolutionTriggerDAO
import asrz.Pokemon.pokeAPI.model.games.GenerationDAO
import asrz.Pokemon.pokeAPI.model.games.PokedexDAO
import asrz.Pokemon.pokeAPI.model.games.VersionDAO
import asrz.Pokemon.pokeAPI.model.games.VersionGroupDAO
import asrz.Pokemon.pokeAPI.model.items.ItemAttributeDAO
import asrz.Pokemon.pokeAPI.model.items.ItemCategoryDAO
import asrz.Pokemon.pokeAPI.model.items.ItemDAO
import asrz.Pokemon.pokeAPI.model.items.ItemFlingEffectDAO
import asrz.Pokemon.pokeAPI.model.items.ItemPocketDAO
import asrz.Pokemon.pokeAPI.model.locations.LocationAreaDAO
import asrz.Pokemon.pokeAPI.model.locations.LocationDAO
import asrz.Pokemon.pokeAPI.model.locations.PalParkAreaDAO
import asrz.Pokemon.pokeAPI.model.locations.RegionDAO
import asrz.Pokemon.pokeAPI.model.machines.MachineDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveAilmentDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveBattleStyleDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveCategoryDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveDamageClassDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveLearnMethodDAO
import asrz.Pokemon.pokeAPI.model.moves.MoveTargetDAO
import asrz.Pokemon.pokeAPI.model.pokemon.AbilityDAO
import asrz.Pokemon.pokeAPI.model.pokemon.CharacteristicDAO
import asrz.Pokemon.pokeAPI.model.pokemon.EggGroupDAO
import asrz.Pokemon.pokeAPI.model.pokemon.GenderDAO
import asrz.Pokemon.pokeAPI.model.pokemon.GrowthRateDAO
import asrz.Pokemon.pokeAPI.model.pokemon.LocationAreaEncounterDAO
import asrz.Pokemon.pokeAPI.model.pokemon.NatureDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokeathlonStatDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonColorDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonFormDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonHabitatDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonShapeDAO
import asrz.Pokemon.pokeAPI.model.pokemon.PokemonSpeciesDAO
import asrz.Pokemon.pokeAPI.model.pokemon.StatDAO
import asrz.Pokemon.pokeAPI.model.pokemon.TypeDAO
import com.mongodb.client.MongoCollection
import com.mongodb.client.MongoDatabase
import com.mongodb.client.model.Filters
import com.mongodb.client.model.ReplaceOptions
import java.util.List
import org.bson.conversions.Bson
import org.bson.types.ObjectId

class Database {
	
	MongoDatabase apiDatabase
	MongoDatabase localDatabase
	
	new(MongoDatabase apiDatabase, MongoDatabase localDatabase) {
		this.apiDatabase = apiDatabase
		this.localDatabase = localDatabase
	}
	
	
	private def <T extends PokeApiResource> getApiCollection(String name, Class<T> clazz) {
		return apiDatabase.getCollection(name, clazz)
	}
	
	private def <T extends Entity> MongoCollection<T> getLocalCollection(String name, Class<T> clazz) {
		return localDatabase.getCollection(name, clazz)
	}
	
	private def <T extends Entity> MongoCollection<T> getLocalCollection(T entity, Class<T> clazz) {
		return localDatabase.getCollection(entity.collectionName, clazz)
	}
	
	
	def List<BerryDAO> getBerries(Bson filter) {
		return getApiCollection("berries", BerryDAO).find(filter).toList
	}
	
	def List<BerryFirmnessDAO> getBerryFirmnesses(Bson filter) {
		return getApiCollection("berry_firmnesses", BerryFirmnessDAO).find(filter).toList
	}
	
	def List<BerryFlavorDAO> getBerryFlavors(Bson filter) {
		return getApiCollection("berry_flavors", BerryFlavorDAO).find(filter).toList
	}
	
	def List<ContestTypeDAO> getContestTypes(Bson filter) {
		return getApiCollection("contest_types", ContestTypeDAO).find(filter).toList
	}
	
	def List<ContestEffectDAO> getContestEffects(Bson filter) {
		return getApiCollection("contest_effects", ContestEffectDAO).find(filter).toList
	}
	
	def List<SuperContestEffectDAO> getSuperContestEffects(Bson filter) {
		return getApiCollection("super_contest_effects", SuperContestEffectDAO).find(filter).toList
	}
	
	def List<EncounterMethodDAO> getEncounterMethods(Bson filter) {
		return getApiCollection("encounter_methods", EncounterMethodDAO).find(filter).toList
	}
	
	def List<EncounterConditionDAO> getEncounterConditions(Bson filter) {
		return getApiCollection("encounter_conditions", EncounterConditionDAO).find(filter).toList
	}
	
	def List<EncounterConditionValueDAO> getEncounterConditionValues(Bson filter) {
		return getApiCollection("encounter_condition_values", EncounterConditionValueDAO).find(filter).toList
	}
	
	def List<EvolutionChainDAO> getEvolutionChains(Bson filter) {
		return getApiCollection("evolution_chains", EvolutionChainDAO).find(filter).toList
	}
	
	def getEvolutionTriggers(Bson filter) {
		return getApiCollection("evolution_triggers", EvolutionTriggerDAO).find(filter).toList
	}
	
	def getGenerations(Bson filter) {
		return getApiCollection("generations", GenerationDAO).find(filter).toList
	}
	
	def getPokedexes(Bson filter) {
		return getApiCollection("pokedexes", PokedexDAO).find(filter).toList
	}
	
	def getVersions(Bson filter) {
		return getApiCollection("versions", VersionDAO).find(filter).toList
	}
	
	def getVersionGroups(Bson filter) {
		return getApiCollection("version_groups", VersionGroupDAO).find(filter).toList
	}
	
	def getItems(Bson filter) {
		return getApiCollection("items", ItemDAO).find(filter).toList
	}
	
	def getItemAttributes(Bson filter) {
		return getApiCollection("item_attributes", ItemAttributeDAO).find(filter).toList
	}
	
	def getItemCategories(Bson filter) {
		return getApiCollection("item_categories", ItemCategoryDAO).find(filter).toList
	}
	
	def getItemFlingEffects(Bson filter) {
		return getApiCollection("item_fling_effects", ItemFlingEffectDAO).find(filter).toList
	}
	
	def getItemPockets(Bson filter) {
		return getApiCollection("item_pockets", ItemPocketDAO).find(filter).toList
	}
	
	def getLocations(Bson filter) {
		return getApiCollection("locations", LocationDAO).find(filter).toList
	}
	
	def getLocationAreas(Bson filter) {
		return getApiCollection("location_areas", LocationAreaDAO).find(filter).toList
	}
	
	def getPalParkAreas(Bson filter) {
		return getApiCollection("pal_park_areas", PalParkAreaDAO).find(filter).toList
	}
	
	def getRegions(Bson filter) {
		return getApiCollection("regions", RegionDAO).find(filter).toList
	}
	
	def getMachines(Bson filter) {
		return getApiCollection("machines", MachineDAO).find(filter).toList
	}
	
	def getMoves(Bson filter) {
		return getApiCollection("moves", MoveDAO).find(filter).toList
	}
	
	def getMoveAilments(Bson filter) {
		return getApiCollection("move_ailments", MoveAilmentDAO).find(filter).toList
	}
	
	def getMoveBattleStyles(Bson filter) {
		return getApiCollection("move_battle_styles", MoveBattleStyleDAO).find(filter).toList
	}
	
	def getMoveCategories(Bson filter) {
		return getApiCollection("move_categories", MoveCategoryDAO).find(filter).toList
	}
	
	def getMoveDamageClasses(Bson filter) {
		return getApiCollection("move_damage_classes", MoveDamageClassDAO).find(filter).toList
	}
	
	def getMoveLearnMethods(Bson filter) {
		return getApiCollection("move_learn_methods", MoveLearnMethodDAO).find(filter).toList
	}
	
	def getMoveTargets(Bson filter) {
		return getApiCollection("move_targets", MoveTargetDAO).find(filter).toList
	}
	
	def getAbilities(Bson filter) {
		return getApiCollection("abilities", AbilityDAO).find(filter).toList
	}
	
	def getCharacteristics(Bson filter) {
		return getApiCollection("characteristics", CharacteristicDAO).find(filter).toList
	}
	
	def getEggGroups(Bson filter) {
		return getApiCollection("egg_groups", EggGroupDAO).find(filter).toList
	}
	
	def getGenders(Bson filter) {
		return getApiCollection("genders", GenderDAO).find(filter).toList
	}
	
	def getGrowthRates(Bson filter) {
		return getApiCollection("growth_rates", GrowthRateDAO).find(filter).toList
	}
	
	def getNatures(Bson filter) {
		return getApiCollection("natures", NatureDAO).find(filter).toList
	}
	
	def getPokeathlonStats(Bson filter) {
		return getApiCollection("pokeathlon_stats", PokeathlonStatDAO).find(filter).toList
	}
	
	def getPokemon(Bson filter) {
		return getApiCollection("pokemon", PokemonDAO).find(filter).toList
	}
	
	def getLocationAreaEncounters(Bson filter) {
		return getApiCollection("pokemon_location_areas", LocationAreaEncounterDAO).find(filter).toList
	}
	
	def getPokemonColors(Bson filter) {
		return getApiCollection("pokemon_colors", PokemonColorDAO).find(filter).toList
	}
	
	def getPokemonForms(Bson filter) {
		return getApiCollection("pokemon_forms", PokemonFormDAO).find(filter).toList
	}
	
	def getPokemonHabitats(Bson filter) {
		return getApiCollection("pokemon_habitats", PokemonHabitatDAO).find(filter).toList
	}
	
	def getPokemonShapes(Bson filter) {
		return getApiCollection("pokemon_shapes", PokemonShapeDAO).find(filter).toList
	}
	
	def getPokemonSpecies(Bson filter) {
		return getApiCollection("pokemon_species", PokemonSpeciesDAO).find(filter).toList
	}
	
	def getStats(Bson filter) {
		return getApiCollection("stats", StatDAO).find(filter).toList
	}
	
	def getTypes(Bson filter) {
		return getApiCollection("types", TypeDAO).find(filter).toList
	}
	
	//local collection gets
	def Player getPlayer(Bson filter) {
		return getLocalCollection(Player.COLLECTION_NAME, Player).find(filter).first
	}
	
	def getPlayers(Bson filter) {
		return getLocalCollection(Player.COLLECTION_NAME, Player).find(filter).toList
	}
	
	def List<Pokemon> getLocalPokemon(Bson filter) {
		return getLocalCollection(Pokemon.COLLECTION_NAME, Pokemon).find(filter).toList
	}
	
	//local collection saves
	def <T extends Entity> ObjectId saveEntity(T entity, Class<T> clazz) {
		return getLocalCollection(entity, clazz).replaceOne(Filters.eq("_id", entity.id), entity, getReplaceOptions()).upsertedId?.asObjectId?.value
	}
	
	private def ReplaceOptions getReplaceOptions() {
		return new ReplaceOptions().upsert(true)
	}
	
	//deletes
	def deletePlayers(Bson filter) {
		return getLocalCollection(Player.COLLECTION_NAME, Player).deleteMany(filter)
	}
	
	def deletePokemon(Bson filter) {
		return getLocalCollection(Pokemon.COLLECTION_NAME, Pokemon).deleteMany(filter)
	}
	
}
