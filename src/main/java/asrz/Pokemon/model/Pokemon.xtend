package asrz.Pokemon.model

import asrz.Pokemon.model.enums.Gender
import asrz.Pokemon.model.enums.MoveLearnMethod
import asrz.Pokemon.model.enums.Nature
import asrz.Pokemon.model.enums.Stat
import asrz.Pokemon.model.enums.StatusAilment
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.model.interfaces.ILabeled
import asrz.Pokemon.util.Util
import java.util.List
import java.util.Map
import java.util.function.Consumer
import javafx.beans.binding.Bindings
import javafx.beans.binding.DoubleBinding
import javafx.beans.binding.IntegerBinding
import javafx.beans.binding.ObjectBinding
import javafx.beans.binding.StringBinding
import javafx.collections.FXCollections
import javafx.collections.ObservableMap
import javafx.scene.paint.Color
import org.bson.codecs.pojo.annotations.BsonIgnore
import xtendfx.beans.FXBindable

import static asrz.Pokemon.model.enums.Stat.*

import static extension asrz.Pokemon.util.Extensions.*

@FXBindable
class Pokemon extends Entity implements ILabeled {
	
	public static final String COLLECTION_NAME = "pokemon"
	final static int LEVEL_CAP = 100
	
	Integer pokemonDaoId
	String pokemonDaoName
	
	@BsonIgnore
	PokemonSpecies species
	
	int xp = 0
	int level = 1
	
	@BsonIgnore
	int hp
	
	boolean shiny = false
	
	Nature nature
	Gender gender
	
	String nickname
	
	//map properties
	ObservableStatMap individualValues = new ObservableStatMap
	ObservableStatMap effortValues = new ObservableStatMap
	
	@BsonIgnore
	ObservableStatMap tempStatChanges = new ObservableStatMap
	
	TypeList types = new TypeList
	List<Type> formerTypes

	//stat bindings
	@BsonIgnore
	IntegerBinding maxHpProperty
	@BsonIgnore
	IntegerBinding attackProperty
	@BsonIgnore
	IntegerBinding defenseProperty
	@BsonIgnore
	IntegerBinding specialAttackProperty
	@BsonIgnore
	IntegerBinding specialDefenseProperty
	@BsonIgnore
	IntegerBinding speedProperty
	
	//base stat bindings
	@BsonIgnore
	IntegerBinding baseAttackProperty
	
	//hp bindings
	@BsonIgnore
	StringBinding hpLabelProperty
	@BsonIgnore
	DoubleBinding hpPercentageProperty
	@BsonIgnore
	ObjectBinding<Color> hpColorProperty
	
	//xp bindings
	@BsonIgnore
	IntegerBinding xpToNextLevelProperty
	@BsonIgnore
	DoubleBinding xpPercentageProperty 
	
	//other bindings
	@BsonIgnore
	StringBinding levelLabelProperty
	
	@BsonIgnore
	StringBinding tempStatChangesLabelProperty
	
	@BsonIgnore
	StringBinding labelProperty

	MoveList learnedMoves = new MoveList //moves this pokemon has access to at move reminder
	
	Integer move_1DaoId
	@BsonIgnore
	Move move_1
	
	Integer move_2DaoId
	@BsonIgnore
	Move move_2
	
	Integer move_3DaoId
	@BsonIgnore
	Move move_3
	
	Integer move_4DaoId
	@BsonIgnore
	Move move_4
	
	@BsonIgnore
	StatusAilment statusAilment
	@BsonIgnore
	StatusAilmentInfo statusAilmentInfo
	@BsonIgnore
	ObservableMap<StatusAilment, StatusAilmentInfo> volatileStatusAilments = FXCollections.observableHashMap
	
	@BsonIgnore
	Ability ability
	String abilityDaoName
	
	Ability formerAbility
	
	new() {}
	
	def static fromSpeciesAndValues(PokemonSpecies species, Nature nature, Map<Stat, Integer> individualValues, Map<Stat, Integer> effortValues) {
		return Pokemon.fromSpeciesAndValueSetter(species, [
			individualValues.putAll(individualValues)
			effortValues.putAll(effortValues)
			setNature(nature)
		])
	}
	
	def static fromSpeciesWithRandomIVsAndNature(PokemonSpecies species) {
		return Pokemon.fromSpeciesAndValueSetter(species, [
			for (Stat stat : Stat.getPermanentStats) {
				individualValues.put(stat, Util.randomInt(0, 32))
				effortValues.put(stat, 0)
			}
			nature = Util.randomChoice(Nature.list)
		])
	}
	
	def static fromSpeciesWithNoIVsAndRandomNeutralNature(PokemonSpecies species) {
		return Pokemon.fromSpeciesAndValueSetter(species, [
			for (Stat stat : Stat.getPermanentStats) {
				individualValues.put(stat, 0)
				effortValues.put(stat, 0)
			}
			nature = Util.randomChoice(Nature.neutralNatures)
		])
	}
	
	private def static fromSpeciesAndValueSetter(PokemonSpecies species, Consumer<Pokemon> valueSetter) {
		val pokemon = new Pokemon() => [
			pokemonDaoId = species.pokemonDaoId
			pokemonDaoName = species.pokemonDaoName
			setSpecies(species)
			setGender(Gender.randomGender(species.genderRate))
			valueSetter.accept(it)
			
			initializeBindings()
			
			setHp(getMaxHp())
			
			setShiny(Util.randomInt(1, 8192) == 8192)
			
			setAbility(Util.randomChoice(species.abilities))
			
			types = new TypeList
			types.add(species.type_1)
			types.add(species.type_2)
			
			species.pokemonMoves.filter[learnMethod == MoveLearnMethod.LEVEL_UP && levelLearnedAt == 1]
			.map[move]
			.forEach([ move |
				learnedMoves.add(move)
				learnMove(move, null)
			])
		]
		
		return pokemon
	}
	
	def initializeBindings() {
		maxHpProperty = createMaxHpBinding()
		attackProperty = createStatBinding(species.baseAttack, ATTACK)
		defenseProperty = createStatBinding(species.baseDefense, DEFENSE)
		specialAttackProperty = createStatBinding(species.baseSpecialAttack, SPECIAL_ATTACK)
		specialDefenseProperty = createStatBinding(species.baseSpecialDefense, SPECIAL_DEFENSE)
		speedProperty = createStatBinding(species.baseSpeed, SPEED)
		
		hpLabelProperty = createHpLabelBinding()
		hpPercentageProperty = createHpPercentageBinding()
		hpColorProperty = createHpColorBinding()
		
		xpToNextLevelProperty = createXpToNextLevelBinding()
		xpPercentageProperty = createXpPercentageBinding()
		
		levelLabelProperty = createLevelLabelBinding()
		tempStatChangesLabelProperty = createTempStatChangesLabelBinding()
		
		labelProperty = Bindings.createStringBinding([return nickname ?: species.label], speciesProperty, nicknameProperty)
	}
	
	private def createXpToNextLevelBinding() {
		return Bindings.createIntegerBinding([
			return species.growthRate.getXpRequired(level + 1) - xp
		], xpProperty, levelProperty, speciesProperty)
	}
	
	def double calculateXpPercentage(int level, int xp) {
		if (level == LEVEL_CAP) { return 100.0; } //if at level cap show full xp bar
			
		val growthRate = species.growthRate
		val result = (xp - growthRate.getXpRequired(level)) * 100.0 / (growthRate.getXpRequired(level + 1) - growthRate.getXpRequired(level))
		if (result < 0.0 || result > 100.0) {
			throw new RuntimeException("Oops, result of calculateXpPercentage(" + level + ", " + xp + ") was: " + result)
		}
		return result
	}
	
	private def createXpPercentageBinding() {
		return Bindings.createDoubleBinding([
			calculateXpPercentage(level, xp)
		], xpProperty, levelProperty, speciesProperty)
	}
	
	private def createTempStatChangesLabelBinding() {
		return Bindings.createStringBinding([
			return Stat.values().toList
						.filter[stat | tempStatChanges.containsKey(stat) && tempStatChanges.get(stat) != 0]
						.map[ stat | String.format("%s %+d", stat.label, tempStatChanges.get(stat))]
						.join(" ")
		], tempStatChanges)
	}
	
	private def StringBinding createLevelLabelBinding() {
		return Bindings.createStringBinding([
			return 'Lv. ' + level
		], levelProperty())
	}
	
	private def IntegerBinding createStatBinding(int baseStat, Stat stat) {
		return Bindings.createIntegerBinding([
			return Integer.valueOf(Math.floor(((Math.floor((2.0 * baseStat) + individualValues.get(stat) + Math.floor(effortValues.get(stat) / 4.0)) * level / 100.0) as int + 5) * nature.getStatModifier(stat)) as int)
		], speciesProperty(), levelProperty(), individualValuesProperty(), effortValuesProperty(), tempStatChangesProperty())
	}
	
	private def IntegerBinding createMaxHpBinding() {
		return Bindings.createIntegerBinding([
			return Integer.valueOf(Math.floor((((2.0 * species.baseHp) + individualValues.get(HP) + Math.floor(effortValues.get(HP) / 4.0) ) * level) / 100.0) as int + level + 10)
		], speciesProperty(), levelProperty(), individualValuesProperty(), effortValuesProperty())
	}
	
	private def StringBinding createHpLabelBinding() {
		return Bindings.createStringBinding([
			return  hp + "/" + getMaxHp()
		], hpProperty(), speciesProperty(), maxHpProperty(), levelProperty(), individualValuesProperty(), effortValuesProperty());
	}
	
	private def DoubleBinding createHpPercentageBinding() {
		return Bindings.createDoubleBinding([
			return  (hp * 100.0) / getMaxHp;
		], hpProperty(), speciesProperty(), maxHpProperty(), levelProperty(), individualValuesProperty(), effortValuesProperty());
	}
	
	private def ObjectBinding<Color> createHpColorBinding() {
		return Bindings.createObjectBinding([
			hpPercentage >= 50 ? Color.GREEN : hpPercentage >= 20 ? Color.YELLOW : Color.RED
		], hpProperty(), speciesProperty(), maxHpProperty(), levelProperty(), individualValuesProperty(), effortValuesProperty());
	}
	
	def double getTempStatModifier(Stat stat) {
		val changeLevels = tempStatChanges.getOrDefault(stat, 0)
		
		val defaultNumber = 
			if (Util.list(ACCURACY, EVASION).contains(stat)) {
				3.0
			} else if (Util.list(ATTACK, DEFENSE, SPECIAL_ATTACK, SPECIAL_DEFENSE, SPEED).contains(stat)) {
				2.0
			} else {
				throw new RuntimeException("Unhandled temp stat boost: " + stat.label)
			}
		
		if (changeLevels == 0) {
			return 1.0;
		} else if (changeLevels > 0) {
			return (changeLevels + defaultNumber) / defaultNumber
		} else {
			return defaultNumber / (defaultNumber - changeLevels)
		}
	}
	
	def levelUp(Trainer trainer, Consumer<Move> moveCallback) {
		val xpRequired = species.growthRate.getXpRequired(level+1)
		if (xp < xpRequired) {
			xp = xpRequired
		}
		
		val int oldMaxHp = maxHpProperty.get()
		level = level + 1
		if (level > LEVEL_CAP) {
			level = LEVEL_CAP
		}
		val newMaxHp = maxHpProperty.get()
		hp =  hp + (newMaxHp - oldMaxHp)
		
		getLevelUpMoves(9, level).forEach[ move |
			if (!learnedMoves.contains(move)) {
				moveCallback?.accept(move)
				learnMove(move, trainer)
			}
		]
	}
	
	def getLevelUpMoves(int generation, int level) {
		return species.pokemonMoves
			.filter[learnMethod == MoveLearnMethod.LEVEL_UP && levelLearnedAt == level]
			.sortBy[order]
			.map[move]
	}
	
	@BsonIgnore
	def List<Move> getMoves() {
		return Util.list(move_1, move_2, move_3, move_4).filterNull.toList
	}
	
	def void setMoves(List<Move> moves) {
		move_1 = null
		move_2 = null
		move_3 = null
		move_4 = null
		
		if (moves.size() > 0) {
			move_1 = moves.get(0)
			if (moves.size() > 1) {
				move_2 = moves.get(1)
				if (moves.size() > 2) {
					move_3 = moves.get(2)
					if (moves.size() > 3) {
						move_4 = moves.get(3)
					}
				}
			}
		}
		
	}
	
	@BsonIgnore
	def List<Integer> getMoveDaoIds() {
		return Util.list(move_1DaoId, move_2DaoId, move_3DaoId, move_4DaoId).filterNull.toList
	}
	
	def learnMove(Move move, Trainer trainer) {
		learnedMoves.addIfAbsent(move)
		
		if (moves.contains(move)) {
			return
		}
		
		if (move_1 === null) {
			move_1 = move
		} else if (move_2 === null) {
			move_2 = move
		} else if (move_3 === null) {
			move_3 = move
		} else if (move_4 === null) {
			move_4 = move
		} else {
			if (trainer === null/*|| trainer.wild*/) {
				val moveToReplace = moves.sortBy[learnedMoves.indexOf(it)].first
				if (moveToReplace == move_1) {
					move_1 = move
				} else if (moveToReplace == move_2) {
					move_2 = move
				} else if (moveToReplace == move_3) {
					move_3 = move
				} else if (moveToReplace == move_4) {
					move_4 = move
				} else {
					throw new RuntimeException(String.format("Error with %s learning move %s", label, move))
				}
			} else if (trainer instanceof Player) {
				
			} else {
				
			}
		}
	}
	
	@BsonIgnore
	def isFemale() {
		return gender == Gender.FEMALE
	}
	
	@BsonIgnore
	def getFrontSprite() {
		val sprites = species.sprites
		if (shiny && female) {
			return Util.firstNonNull(sprites.frontFemaleShiny, sprites.frontShiny, sprites.frontFemale, sprites.frontDefault) 
		} else if (shiny) {
			return Util.firstNonNull(sprites.frontShiny, sprites.frontDefault)
		} else if (female) {
			return Util.firstNonNull(sprites.frontFemale, sprites.frontDefault)
		} else {
			return sprites.frontDefault
		}
	}
	
	@BsonIgnore
	def getBackSprite() {
		val sprites = species.sprites
		if (shiny && female) {
			return Util.firstNonNull(sprites.backFemaleShiny, sprites.backShiny, sprites.backFemale, sprites.backDefault) 
		} else if (shiny) {
			return Util.firstNonNull(sprites.backShiny, sprites.backDefault)
		} else if (female) {
			return Util.firstNonNull(sprites.backFemale, sprites.backDefault)
		} else {
			return sprites.backDefault
		}
	}
	
	def applyDamage(int damage) {
		if (hp - damage < 0) {
			hp = 0
		} else if (hp - damage > maxHp) {
			hp = maxHp
		} else {
			hp = hp - damage
		}
	}
	
	@BsonIgnore
	def boolean isAlive() {
		return hp > 0
	}
	
	@BsonIgnore
	def boolean isFainted() {
		return !isAlive()
	}
	
	def int getEffectiveStat(int statValue, Stat stat) {
		return getEffectiveStat(statValue, stat, false)
	}
	
	def int getEffectiveStat(int statValue, Stat stat, boolean doesMoveCrit) {
		var tempStatModifier = getTempStatModifier(stat)
		
		if (doesMoveCrit) {
			if (Util.in(stat, ATTACK, SPECIAL_ATTACK) && tempStatModifier < 1) {
				tempStatModifier = 1
			} else if (Util.in(stat, DEFENSE, SPECIAL_DEFENSE) && tempStatModifier > 1) {
				tempStatModifier = 1
			}
		}
		
		return Math.floor(statValue * tempStatModifier) as int
	}
	
	def healHpAndStatuses() {
		hp = maxHp
		statusAilment = null
		volatileStatusAilments.clear()
		tempStatChanges.clear()
		for (move : moves) {
			move.pp = move.maxPP
		}
		types = new TypeList
		types.add(species.type_1)
		types.add(species.type_2)
		
		if (formerAbility !== null) {
			ability = formerAbility
			formerAbility = null
		}
	}
	
	@BsonIgnore
	override getCollectionName() {
		return COLLECTION_NAME
	}
	
	def int getWeight() {
		val weight = species.weight
		
		val weightModifier = ability?.weightModifierFunction?.get() ?: null
		
		if (weightModifier !== null) {
			return Math.floor(weight * weightModifier) as int
		}
		
		return weight
	}
	
}
