package asrz.Pokemon.model

import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.model.enums.Gender
import asrz.Pokemon.model.enums.MoveCategory
import asrz.Pokemon.model.enums.MoveDamageClass
import asrz.Pokemon.model.enums.Stat
import asrz.Pokemon.model.enums.StatusAilment
import asrz.Pokemon.model.enums.Terrain
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.model.enums.Weather
import asrz.Pokemon.model.interfaces.ILabeled
import asrz.Pokemon.pokeAPI.model.pokemon.AbilityDAO
import asrz.Pokemon.util.Util
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.function.Function
import java.util.function.Predicate
import java.util.function.Supplier
import org.eclipse.xtext.xbase.lib.Functions.Function2
import org.eclipse.xtext.xbase.lib.Functions.Function3
import org.eclipse.xtext.xbase.lib.Functions.Function4
import org.eclipse.xtext.xbase.lib.Functions.Function5
import org.eclipse.xtext.xbase.lib.Functions.Function6
import org.eclipse.xtext.xbase.lib.Procedures.Procedure2
import org.eclipse.xtext.xbase.lib.Procedures.Procedure3
import org.eclipse.xtext.xbase.lib.Procedures.Procedure4
import org.eclipse.xtext.xbase.lib.Procedures.Procedure5
import xtendfx.beans.FXBindable

import static asrz.Pokemon.model.enums.Stat.ATTACK
import static asrz.Pokemon.model.enums.Stat.EVASION
import static asrz.Pokemon.model.enums.Stat.SPEED

import static extension asrz.Pokemon.util.Util.*

@FXBindable
class Ability implements ILabeled {
	
	Integer counter
	
	String abilityDaoName
	
	String name
	String description
	
	Function2<BattleViewController, Pokemon, Double> speedModifierFunction
	
	Function3<BattleViewController, Pokemon, Move, Boolean> offensiveBeforeMoveFunction
	Procedure4<BattleViewController, Pokemon, Move, Pokemon> defensiveBeforeMoveFunction
	
	Function3<Pokemon, Move, Pokemon, Double> offensiveAccuracyModifierFunction
	Function3<Pokemon, Move, Pokemon, Double> offensiveAllyAccuracyModifierFunction
	Function5<Pokemon, Move, Pokemon, Weather, Boolean, Double> defensiveAccuracyModifierFunction
	
	Function3<BattleViewController, Pokemon, Move, Double> offensiveStabBonusFunction
	
	Function3<BattleViewController, Pokemon, Move, Double> offensiveAttackStatModifierFunction
	Function4<BattleViewController, Pokemon, Move, Boolean, Double> defensiveAttackStatModifierFunction
	Function3<BattleViewController, Pokemon, Move, Double> offensiveAllyAttackStatModifierFunction
	
	Function5<BattleViewController, Pokemon, Move, Pokemon, Boolean, Double> defensiveDefenseStatModifierFunction
	Function5<BattleViewController, Pokemon, Move, Pokemon, Boolean, Double> defensiveAllyDefenseStatModifierFunction
	
	Function5<BattleViewController, Pokemon, Move, Pokemon, Boolean, Double> offensiveDamageModifierFunction
	Function4<BattleViewController, Pokemon, Move, Pokemon, Double> offensiveAllyDamageModifierFunction
	Function4<BattleViewController, Pokemon, Move, Pokemon, Double> globalDamageModifierFunction
	Function6<BattleViewController, Pokemon, Move, Pokemon, Integer, Boolean, Integer> defensiveDamageFunction
	
	Procedure4<BattleViewController, Pokemon, Move, Pokemon> offensiveOnHitFunction
	Procedure5<BattleViewController, Pokemon, Move, Pokemon, Boolean> defensiveOnHitFunction
	
	Procedure4<BattleViewController, Pokemon, Move, Pokemon> defensiveOnCritFunction
	Procedure5<BattleViewController, Pokemon, Move, Pokemon, Boolean> defensiveAfterHitsFunction //called after all hits of a multi-hit move and applying move effects
	
	Procedure4<BattleViewController, Pokemon, Ability, Pokemon> defensiveOnAbilityFunction
	
	Procedure5<BattleViewController, Pokemon, Move, Pokemon, Boolean> defensiveOnDeathFunction
	Procedure4<BattleViewController, Pokemon, Move, Pokemon> offensiveOnKillFunction
	Procedure3<BattleViewController, Pokemon, Pokemon> globalOnFaintFunction
	
	Function4<Pokemon, Move, Pokemon, Integer, Double> offensiveDrainModifierFunction
	
	Function6<BattleViewController, Pokemon, Pokemon, Stat, Integer, Boolean, Integer> defensiveStatChangeModifierFunction
	Function6<BattleViewController, Pokemon, Pokemon, Stat, Integer, Boolean, Integer> defensiveAllyStatChangeModifierFunction
	
	Function3<BattleViewController, Pokemon, StatusAilment, Double> defensiveStatusAilmentDamageModifierFunction
	
	Function4<Pokemon, Move, Pokemon, Integer, Integer> flinchChanceFunction
	Function3<Pokemon, Move, Pokemon, Integer> offensiveCritBoostsFunction
	Function4<Pokemon, Move, Pokemon, Boolean, Boolean> defensiveMoveCritFunction
	Function4<Pokemon, Move, Pokemon, Boolean, Boolean> offensiveMoveCritFunction
	
	Function4<BattleViewController, Pokemon, StatusAilment, Boolean, Boolean> isImmuneToStatusAilmentFunction
	Function4<BattleViewController, Pokemon, StatusAilment, Boolean, Boolean> isAllyImmuneToStatusAilmentFunction
	Function3<BattleViewController, Pokemon, Ability, Boolean> isImmuneToAbilityFunction
	Function5<BattleViewController, Pokemon, Move, Pokemon, Boolean, Boolean> isImmuneToMoveFunction
	Function5<BattleViewController, Pokemon, Move, Pokemon, Boolean, Boolean> isAllyImmuneToMoveFunction
	Function<Weather, Boolean> isImmuneToWeatherDamageFunction
	
	
	Function3<BattleViewController, Pokemon, Pokemon, Boolean> isTrappedFunction
	
	Supplier<Double> weightModifierFunction
	
	Runnable battleStartFunction
	Procedure2<BattleViewController, Pokemon> switchInFunction
	Procedure2<BattleViewController, Pokemon> switchOutFunction
	Procedure2<BattleViewController, Pokemon> onFlinchFunction
	Procedure2<BattleViewController, Pokemon> endOfTurnFunction
	Procedure4<BattleViewController, Pokemon, StatusAilment, Pokemon> onStatusAilmentFunction //called when pokemon is inflicted with a status
	Procedure5<BattleViewController, Pokemon, Pokemon, Stat, Integer> onStatChangeFunction
	Procedure3<BattleViewController, Pokemon, Terrain> onTerrainChangeFunction
	
	boolean isImmuneToForceSwitch = false
	
	new() {}
	
	new(String abilityDaoName) {
		this.abilityDaoName = abilityDaoName
	}
	
	def static fromApi(AbilityDAO abilityDao, String languageName) {
		if (abilityDao === null) {
			return null
		}
		
		val ability = Abilities.abilitiesByAbilityDaoName.get(abilityDao.name)
		
		if (ability === null) {
			return null
		}
		
		return ability => [
			name = abilityDao.names.findFirst[language.name == languageName].name
			description = abilityDao.effectEntries.findFirst[language.name == languageName].effect
		]
	}
	
	override getLabel() {
		return name
	}
	
}

class Abilities {
	
	public static final String AIR_LOCK = 'air-lock'
	public static final String ANALYTIC = 'analytic'
	public static final String AURA_BREAK = 'aura-break'
	public static final String CLOUD_NINE = 'cloud-nine'
	public static final String CORROSION = 'corrosion'
	public static final String DAMP = 'damp'
	public static final String EARLY_BIRD = 'early-bird'
	public static final String EFFECT_SPORE = 'effect-spore'
	public static final String GALE_WINGS = 'gale-wings'
	public static final String GLUTTONY = 'gluttony'
	public static final String GUARD_DOG = 'guard-dog' //TODO prevent switch out
	public static final String GUTS = 'guts'
	public static final String INTIMIDATE = 'intimidate'
	public static final String LEVITATE = 'levitate'
	public static final String LIGHTNING_ROD = 'lightning-rod'
	public static final String LIQUID_OOZE = 'liquid-ooze'
	public static final String LONG_REACH = 'long-reach'
	public static final String MOLD_BREAKER = 'mold-breaker'
	public static final String MYCELIUM_MIGHT = 'mycelium-might'
	public static final String NEUTRALIZING_GAS = 'neutralizing-gas'
	public static final String NO_GUARD = 'no-guard'
	public static final String QUICK_DRAW = 'quick-draw'
	public static final String PRANKSTER = 'prankster'
	public static final String PRESSURE = 'pressure'
	public static final String RUN_AWAY = 'run-away'
	public static final String SCRAPPY = 'scappy'
	public static final String SERENE_GRACE = 'serene-grace'
	public static final String SHEER_FORCE = 'sheer-force'
	public static final String SHIELD_DUST = 'shield-dust'
	public static final String SKILL_LINK = 'skill-link'
	public static final String STALL = 'stall'
	public static final String STICKY_HOLD = 'sticky-hold'
	public static final String STORM_DRAIN = 'storm-drain'
	public static final String TELEPATHY = 'telepathy'
	public static final String TERAVOLT = 'teravolt'
	public static final String TRIAGE = 'triage'
	public static final String TURBOBLAZE = 'turboblaze'
	public static final String UNNERVE = 'unnerve'
	public static final String QUICK_FEET = 'quick-feet'
	public static final String UNAWARE = 'unaware'
	public static final String WONDER_SKIN = 'wonder-skin'
	
	
	static final String[] UNTRACEABLE_ABILITIES = #[
		"as-one-glastrier", "as-one-spectrier", "battle-bond", "comatose", "commander", "disguise", "embody-aspect", "flower-gift", 
		"forecast", "gulp-missile", "hunger-switch", "ice-face", "illusion", "imposter", "multitype", 
		"neutralizing-gas", "poison-puppeteer", "power-construct", "power-of-alchemy", "protosynthesis", 
		"quark-drive", "receiver", "rks-system", "schooling", "shields-down", "stance-change", "teraform-zero", 
		"tera-shell", "tera-shift", "trace", "zen-mode", "zero-to-hero"
	]
	
	static final String[] UNCHANGEABLE_ABILITIES = #[
		"as-one-glastrier", "as-one-spectrier", "battle-bond", "comatose", "commander", "disguise", "gulp-missile", "ice-face", 
		"lingering-aroma", "multitype", "mummy", "power-construct", "rks-system", "schooling", "shields-down", "stance-change", 
		"tera-shift", "zen-mode", "zero-to-hero"
	]
	
	static final String[] UNCOPYABLE_ABILITIES = #[
		"as-one-glastrier", "as-one-spectrier", "battle-bond", "comatose", "commander", "disguise", "flower-gift", "forecast", 
		/* 'gulp-missile', */ "hunger-switch", "ice-face", "illusion", "imposter", "multitype", "power-construct", "power-of-alchemy", 
		"protosynthesis", "quark-drive", "receiver", "rks-system", "schooling", "shields-down", "stance-change", "trace", 
		"wandering-spirit", "wonder-guard", "zen-mode", "zero-to-hero" 
	]
	
	static final String[] UNSUPRESSABLE_ABILITIES = #[
		"as-one-glastrier", "as-one-spectrier", "battle-bond", "comatose", "disguise", "gulp-missile", "ice-face", "multitype", 
		"power-construct", "rks-system", "schooling", "shields-down", "stance-change", "tera-shift", "zen-mode"
	]
	
	public static final String[] PREVENT_REDIRECTION_ABILITIES = #[
		'propeller-tail', 'stalwart'
	]
	
//	static final String[] IGNORABLE_ABILITIES = #[
//		"battle-armor", "clear-body", "damp", "dry-skin", "filter", "flash-fire", "flower-gift", "heatproof", "hyper-cutter",
//		"immunity", "inner-focus", "insomnia", "keen-eye", "leaf-guard", "levitate", "lightning-rod", "limber", "magma-armor",
//		"marvel-scale", "motor-drive", "oblivious", "own-tempo", "sand-veil", "shell-armor", "shield-dust", "simple", "snow-cloak",
//		"solid-rock", "soundproof", "sticky-hold", "storm-drain", "sturdy", "suction-cups", "tangled-feet", "thick-fat", "unaware",
//		"vital-spirit", "volt-absorb", "water-absorb", "water-veil", "white-smoke", "wonder-guard", 
//		"big-pecks", "contrary", "friend-guard", "heavy-metal", "light-metal", "magic-bounce", "multiscale", "sap-sipper",
//		"telepathy", "wonder-skin",
//		"aura-break", "aroma-veil", "bulletproof", "flower-veil", "fur-coat", "overcoat", "sweet-veil",
//		"dazzling", "disguise", "fluffy", "queenly-majesty", "water-bubble",
//		"ice-scales", "ice-face", "mirror-armor", "pastel-veil", "punk-rock",
//		"armor-tail", "earth-eater", "guard-dog", "good-as-gold", "illuminate", "minds-eye", "purifying-salt", "tera-shell",
//		"tablets-of-ruin", "thermal-exchange", "well-baked-body", "vessel-of-ruin", "wind-rider" 
//	]
	
	public static final Map<String, Ability> abilitiesByAbilityDaoName = #[
		new Ability("stench") => [
			flinchChanceFunction = [user, move, target, flinchChance | 
				if (flinchChance > 0) {
					return flinchChance
				} else {
					return 10
				}
			]
		],
		
		//weather abilities
		new Ability("cloud-nine") => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
			]
		],
		
		new Ability("air-lock") => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
			]
		],
		
		new Ability("primordial-sea") => [
			switchInFunction = getWeatherCreateFunction(Weather.HEAVY_RAIN)
		],
		
		new Ability("desolate-land") => [
			switchInFunction = getWeatherCreateFunction(Weather.EXTREMELY_HARSH_SUNLIGHT)
		],
		
		new Ability("delta-stream") => [
			switchInFunction = getWeatherCreateFunction(Weather.STRONG_WINDS)
		],
		
		
		new Ability("drizzle") => [
			switchInFunction = getWeatherCreateFunction(Weather.RAIN)
		],
		
		new Ability("drought") => [
			switchInFunction = getWeatherCreateFunction(Weather.HARSH_SUNLIGHT)
		],
		
		new Ability("sand-stream") => [
			switchInFunction = getWeatherCreateFunction(Weather.SANDSTORM)
		],
		
		new Ability("snow-warning") => [
			switchInFunction = getWeatherCreateFunction(Weather.SNOW)
		],
		
		new Ability("sand-veil") => [
			defensiveAccuracyModifierFunction = getWeatherAccuracyModifierFunction(Weather.SANDSTORM)
			isImmuneToWeatherDamageFunction = [ weather | return weather == Weather.SANDSTORM ]
		],
		
		new Ability("snow-cloak") => [
			defensiveAccuracyModifierFunction = getWeatherAccuracyModifierFunction(Weather.SNOW)
		],
		
		new Ability("swift-swim") => [
			speedModifierFunction = getWeatherSpeedModifierFunction([it.isRain()])
		],
		
		new Ability("chlorophyll") => [
			speedModifierFunction = getWeatherSpeedModifierFunction([it.isHarshSunlight()])
		],
		
		new Ability("slush-rush") => [
			speedModifierFunction = getWeatherSpeedModifierFunction([it == Weather.SNOW])
		],
		
		new Ability("sand-rush") => [
			speedModifierFunction = getWeatherSpeedModifierFunction([it == Weather.SANDSTORM])
			isImmuneToWeatherDamageFunction = [ weather | return weather == Weather.SANDSTORM ]
		],
		
		new Ability("rain-dish") => [
			endOfTurnFunction = [battleViewController, pokemon |
				if (battleViewController.weather !== null && battleViewController.weather.isRain() && pokemon.hp < pokemon.maxHp) {
					battleViewController.showAbility(pokemon, it)
					var int healing = pokemon.maxHp / 16
					val int maxHealing = pokemon.maxHp - pokemon.hp
					
					if (healing > maxHealing) {
						healing = maxHealing
					}
					
					battleViewController.applyDamage(pokemon, -1 * healing, [])
				}
			]
		],
		
		new Ability("hydration") => [
			endOfTurnFunction = [ battleViewController, pokemon |
				val weather = battleViewController.weather
				if (weather !== null && weather.isRain() && pokemon.statusAilment !== null) {
					battleViewController.showAbility(pokemon, it)
					pokemon.statusAilment = null
					pokemon.statusAilmentInfo = null
				}
			]
		],
		
		new Ability("solar-power") => [
			endOfTurnFunction = [ battleViewController, pokemon |
				if (isSunny(battleViewController.weather)) {
					battleViewController.showAbility(pokemon, it)
					val damage = pokemon.maxHp / 8
					battleViewController.applyDamage(pokemon, damage, [])
				}
			]
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (isSunny(battleViewController.weather) && move.special) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("flower-gift") => [
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (isSunny(battleViewController.weather) && move.physical) {
					return 1.5
				}
				
				return 1.0
			]
			defensiveDefenseStatModifierFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return 1.0
				}
				
				if (isSunny(battleViewController.weather) && move.special) {
					return 1.5
				}
				
				return 1.0
			]
			offensiveAllyAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (isSunny(battleViewController.weather) && move.physical) {
					return 1.5
				}
				
				return 1.0
			]
			defensiveAllyDefenseStatModifierFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return 1.0
				}
				
				if (isSunny(battleViewController.weather) && move.special) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("leaf-guard") => [
			isImmuneToStatusAilmentFunction = [ battleViewController, pokemon, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				val weather = battleViewController.weather
				if (weather !== null && weather.isHarshSunlight) {
					if (statusAilment == StatusAilment.YAWN || !statusAilment.isVolatile()) {
						return true
					}
				}
				
				return false
			]
		],
		
		new Ability("ice-body") => [
			endOfTurnFunction = [battleViewController, pokemon |
				if (battleViewController.weather == Weather.SNOW) {
					if (pokemon.hp < pokemon.maxHp) {
						battleViewController.showAbility(pokemon, it)
						val healing = pokemon.maxHp / 16
						battleViewController.applyDamage(pokemon, -healing, [])
					}
				}
			]
			isImmuneToWeatherDamageFunction = [ weather |
				return weather == Weather.SNOW
			]
		],
		
		new Ability("overcoat") => [
			isImmuneToWeatherDamageFunction = [ weather |
				return true
			]
			isImmuneToAbilityFunction = getImmuneToAbilityFunction(Abilities.EFFECT_SPORE)
			isImmuneToMoveFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(move.moveDaoName, Moves.POWDER_MOVES)) {
					return true
				}
				
				return false
			]
		],
		
		new Ability("sand-force") => [
			isImmuneToWeatherDamageFunction = [ weather |
				return weather == Weather.SANDSTORM
			]
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (move.type.in(Type.ROCK, Type.GROUND, Type.STEEL)) {
					
				}
			]
		],
		
		new Ability("sand-spit") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (!move.status) {
					if (battleViewController.weather != Weather.SANDSTORM) {
						battleViewController.showAbility(target, it)
						battleViewController.changeWeather(Weather.SANDSTORM, 5)
						//TODO smooth rock
					}
				}
			]
		],
		
		new Ability("protosynthesis") => [
			//TODO protosynthesis
		],
		
		//terrain abilities
		new Ability("electric-surge") => [
			switchInFunction = getTerrainCreateFunction(Terrain.ELECTRIC)
		],
		
		new Ability("psychic-surge") => [
			switchInFunction = getTerrainCreateFunction(Terrain.PSYCHIC)
		],
		
		new Ability("misty-surge") => [
			switchInFunction = getTerrainCreateFunction(Terrain.MISTY)
		],
		
		new Ability("grassy-surge") => [
			switchInFunction = getTerrainCreateFunction(Terrain.GRASSY)
		],
		
		new Ability("seed-sower") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (!move.status && battleViewController.terrain != Terrain.GRASSY) {
					battleViewController.showAbility(target, it)
					battleViewController.changeTerrain(Terrain.GRASSY, 5)
					//TODO terrain extender
				}
			]
		],
		
		new Ability("grass-pelt") => [
			defensiveDefenseStatModifierFunction = [ battleViewController, pokemon, move, target, ignoreAbilities |
				if (battleViewController.terrain == Terrain.GRASSY && move.physical) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("surge-surfer") => [
			speedModifierFunction = [battleViewController, pokemon |
				if (battleViewController.terrain == Terrain.ELECTRIC) {
					return 2.0
				}
				
				return 1.0
			]
		],
		
		new Ability("mimicry") => [
			switchInFunction = [ battleViewController, pokemon |
				if (battleViewController.terrain !== null) {
					battleViewController.showAbility(pokemon, it)
					pokemon.formerTypes = pokemon.types
					pokemon.types.clear()
					pokemon.types.add(battleViewController.terrain.type)
				}
			]
			onTerrainChangeFunction = [ battleViewController, pokemon, terrain |
				if (terrain === null && !Util.isEmpty(pokemon.formerTypes)) {
					battleViewController.showAbility(pokemon, it)
					pokemon.types.clear()
					pokemon.types.addAll(pokemon.formerTypes)
					pokemon.formerTypes = null
				}
				
				if (terrain !== null) {
					battleViewController.showAbility(pokemon, it)
					pokemon.formerTypes = pokemon.types
					pokemon.types.clear()
					pokemon.types.add(battleViewController.terrain.type)
				}
			]
		],
		
		new Ability("quark-drive") => [
			//TODO quark-drive
		],
		
		//crit abilities
		new Ability("sniper") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (doesCrit) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("super-luck") => [
			offensiveCritBoostsFunction = [ user, move, target |
				return 1
			]
		],
		
		new Ability("merciless") => [
			offensiveMoveCritFunction = [ user, move, target, doesCrit |
				if (target.statusAilment == StatusAilment.POISON) {
					return true
				}
				
				return doesCrit
			]
		],
		
		new Ability("battle-armor") => [
			defensiveMoveCritFunction = [ user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return null
				}
				
				return false
			]
		],
		
		new Ability("shell-armor") => [
			defensiveMoveCritFunction = [ user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return null
				}
				
				return false
			]
		],
		
		new Ability("sturdy") => [
			defensiveDamageFunction = [battleViewController, user, move, target, damage, ignoreAbilities |
				if (ignoreAbilities) {
					return damage
				}
				
				if (move.category == MoveCategory.OHKO) {
					battleViewController.showAbility(target, it)
					return 0
				}
				
				if (target.hp == target.maxHp && damage >= target.maxHp) {
					battleViewController.showAbility(target, it)
					return target.maxHp - 1
				}
				
				return damage
			]
		],
		
		new Ability("damp"),
		
		//offensive on hit abilities
		new Ability("poison-touch") => [
			offensiveOnHitFunction = [ battleViewController, user, move, target |
				if (isContactMove(user, move) && user.ability.abilityDaoName != LONG_REACH && target.statusAilment === null) {
					if (Util.randomPercentage() <= 30) {
						battleViewController.showAbility(user, it)
						battleViewController.applyStatusAilment(user, StatusAilment.POISON, target, null)
					}
				}
			]
		],
		
		//defensive on hit abilities
		new Ability("wind-power") => [
			defensiveAfterHitsFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (Util.in(move.moveDaoName, Moves.WIND_MOVES)) {
					battleViewController.showAbility(target, it)
					battleViewController.addText("Being hit by %s charged %s with power", move.label, battleViewController.getFullLabel(target))
					battleViewController.applyStatusAilment(target, StatusAilment.CHARGE, target, new StatusAilmentInfo())
				}
			]
			//TODO tailwind
		],
		
		new Ability("electromorphosis") => [
			defensiveAfterHitsFunction = [ battleViewController ,user, move, target, ignoreAbilities |
				battleViewController.showAbility(target, it)
				battleViewController.addText("Being hit by %s charged %s with power", move.label, battleViewController.getFullLabel(target))
				battleViewController.applyStatusAilment(target, StatusAilment.CHARGE, target, new StatusAilmentInfo())
			]
		],
		
		new Ability("thermal-exchange") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return
				}
				
				if (move.type == Type.FIRE && !move.status) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.ATTACK, 1, false)
				}
			]
			isImmuneToStatusAilmentFunction = [ battleVieController, pokemon, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (statusAilment == StatusAilment.BURN) {
					return true
				}
				
				return false
			]
			endOfTurnFunction = [ battleViewController, pokemon |
				if (pokemon.statusAilment == StatusAilment.BURN) {
					battleViewController.showAbility(pokemon, it)
					battleViewController.addText("%s was cured of its burn", battleViewController.getFullLabel(pokemon))
					pokemon.statusAilment = null
					pokemon.statusAilmentInfo = null
				}
			]
			switchInFunction = getSwitchInCureAilmentFunction(StatusAilment.BURN)
		],
		
		new Ability("wandering-spirit") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (move.contact) {
					if (!Util.in(user.ability.abilityDaoName, UNCOPYABLE_ABILITIES)) {
						user.formerAbility = user.ability
						target.formerAbility = target.ability
						target.ability = user.ability
						user.ability = it
					}
				}
			]
		],
		
		new Ability("perish-body") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (move.contact) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatusAilment(target, StatusAilment.PERISH_SONG, user, new StatusAilmentInfo => [
						duration = 4
					])
					battleViewController.applyStatusAilment(target, StatusAilment.PERISH_SONG, target, new StatusAilmentInfo => [
						duration = 4
					])
				}
			]
		],
		
		new Ability("steam-engine") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (Util.in(move.type, Type.FIRE, Type.WATER)) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.SPEED, 6, false)
				}
			]
		],
		
		new Ability("cotton-down") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				battleViewController.showAbility(target, it)
				for (pokemon : battleViewController.allActivePokemon) {
					if (pokemon != target) {
						battleViewController.applyStatChange(target, pokemon, Stat.SPEED, -1, false)
					}
				}
			]
		],
		
		new Ability("static") => [
			defensiveOnHitFunction = [battleViewController, user, move, target, ignoreAbilities |
				if (isContactMove(user, move) && Util.randomPercentage <= 30) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatusAilment(target, StatusAilment.PARALYSIS, user, null)
				}
			] 
		],
		
		new Ability("poison-point") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (isContactMove(user, move) && Util.randomPercentage() <= 30) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatusAilment(target, StatusAilment.POISON, user, null)
				}
			]
		],
		
		new Ability("flame-body") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (isContactMove(user, move) && Util.randomPercentage() <= 30) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatusAilment(target, StatusAilment.BURN, user, null)
				}
			]
		],
		
		new Ability("effect-spore") => [
			defensiveOnHitFunction = [battleViewController, user, move, target, ignoreAbilities |
				if (isContactMove(user, move)) {
					if (user.ability?.isImmuneToAbilityFunction?.apply(battleViewController, user, it) ?: false) {
						return
					}
					
					val roll = Util.randomPercentage
					if (roll <= 30) {
						battleViewController.showAbility(target, it)
						if (roll <= 9) {
							battleViewController.applyStatusAilment(target, StatusAilment.POISON, user, null)
						} else if (roll <= 19) {
							battleViewController.applyStatusAilment(target, StatusAilment.PARALYSIS, user, null)
						} else {
							battleViewController.applyStatusAilment(target, StatusAilment.SLEEP, user, null)
						}
					}
				}
			]
		],
		
		new Ability("cute-charm") => [
			defensiveOnHitFunction = [battleViewController, user, move, target, ignoreAbilities |
				if (isContactMove(user, move)) {
					val applies = (user.gender == Gender.MALE && target.gender == Gender.FEMALE) ||
						(user.gender == Gender.FEMALE && target.gender == Gender.MALE)
					if (applies && Util.randomPercentage() <= 30) {
						battleViewController.showAbility(target, it)
						battleViewController.applyStatusAilment(target, StatusAilment.INFATUATION, user, null)
					}
				}
			]
		],
		
		new Ability("rough-skin") => [
			defensiveOnHitFunction = [battleViewController, user, move, target, ignoreAbilities | 
				if (isContactMove(user, move)) {
					battleViewController.showAbility(target, it)
					val damage = user.maxHp / 8
					battleViewController.applyDamage(user, damage, [])
				}
			]
		],
		
		new Ability("iron-barbs") => [
			defensiveOnHitFunction = [battleViewController, user, move, target, ignoreAbilities | 
				if (isContactMove(user, move)) {
					battleViewController.showAbility(target, it)
					val damage = user.maxHp / 8
					battleViewController.applyDamage(user, damage, [])
				}
			]
		],
		
		new Ability("cursed-body") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (!move.status && Util.randomPercentage() <= 30) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatusAilment(target, StatusAilment.DISABLE, user, new StatusAilmentInfo => [
						it.duration = 4
						it.move = move
					])
				}
			]
		],
		
		new Ability("weak-armor") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (move.physical) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.DEFENSE, -1, false)
					battleViewController.applyStatChange(target, target, Stat.SPEED, 2, false)
				}
			]
		],
		
		new Ability("gooey") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (isContactMove(user, move)) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, user, Stat.SPEED, -1, false)
				}
			]
		],
		
		new Ability("tangling-hair") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (isContactMove(user, move)) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, user, Stat.SPEED, -1, false)
				}
			]
		],
		
		new Ability("stamina") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				battleViewController.showAbility(target, it)
				battleViewController.applyStatChange(target, target, Stat.DEFENSE, 1, false)
			]
		],
		
		new Ability("water-compaction") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (move.type == Type.WATER) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.DEFENSE, 2, false)
				}
			]
		],
		
		//on death abilities
		new Ability("aftermath") => [
			defensiveOnDeathFunction = [ battleViewController, user, move, target, damp |
				if (damp) {
					return
				}
				
				if (isContactMove(user, move)) {
					battleViewController.showAbility(target, it)
					val damage = user.maxHp / 4
					battleViewController.applyDamage(user, damage, [])
				}
			]
		],
		
		new Ability("innards-out") => [
			defensiveOnDeathFunction = [ battleViewController, user, move, target, damp |
				battleViewController.showAbility(target, it)
				battleViewController.applyDamage(target, counter, [])
			]
			defensiveBeforeMoveFunction = [ battleViewController, user, move, target |
				counter = target.hp
			]
		],
		
		new Ability("soul-heart") => [
			globalOnFaintFunction = [ battleViewController, pokemon, faintedPokemon |
				battleViewController.showAbility(pokemon, it)
				battleViewController.applyStatChange(pokemon, pokemon, Stat.SPECIAL_ATTACK, 1, false)
			]
		],
		
		//absorb abilities
		new Ability("good-as-gold") => [
			isImmuneToMoveFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (move.status) {
					return true
				}
				
				return false
			]
		],
		
		new Ability("wind-rider") => [
			defensiveDamageFunction = getAbsorbDefensiveDamageFunction([move | Util.in(move.moveDaoName, Moves.WIND_MOVES)])
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return
				}
				
				if (Util.in(move.moveDaoName, Moves.WIND_MOVES)) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.ATTACK, 1, false)
				}
			]
			//TODO tailwind
		],
		
		new Ability("well-baked-body") => [
			defensiveDamageFunction = getAbsorbDefensiveDamageFunction([move | move.type == Type.FIRE])
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if(ignoreAbilities) {
					return
				}
				
				if (move.type == Type.FIRE) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.DEFENSE, 2, false)
				}
			]
		],
		
		new Ability("volt-absorb") => [
			defensiveOnHitFunction = getAbsorbDefensiveOnHitFunction(Type.ELECTRIC, it)
			defensiveDamageFunction = getAbsorbDefensiveDamageFunction([move | move.type == Type.ELECTRIC])
		],
		
		new Ability("water-absorb") => [
			defensiveOnHitFunction = getAbsorbDefensiveOnHitFunction(Type.WATER, it)
			defensiveDamageFunction = getAbsorbDefensiveDamageFunction([move | move.type == Type.WATER])
		],
		
		new Ability("storm-drain") => [
			defensiveAfterHitsFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return
				}
				
				if (move.type == Type.WATER) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(user, target, Stat.SPECIAL_ATTACK, 1, ignoreAbilities)
				}
			]
			defensiveDamageFunction = getAbsorbDefensiveDamageFunction([move | move.type == Type.WATER])
		],
		
		new Ability("lightning-rod") => [
			defensiveAfterHitsFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return 
				}
				
				if (move.type == Type.ELECTRIC) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(user, target, Stat.SPECIAL_ATTACK, 1, ignoreAbilities)
				}
			]
			defensiveDamageFunction = getAbsorbDefensiveDamageFunction([move | move.type == Type.ELECTRIC])
		],
		
		new Ability("motor-drive") => [
			defensiveAfterHitsFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return
				}
				
				if (move.type == Type.ELECTRIC) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(user, target, Stat.SPEED, 1, ignoreAbilities)
				}
			]
			defensiveDamageFunction = getAbsorbDefensiveDamageFunction([ move | move.type == Type.ELECTRIC])
		],
		
		new Ability("flash-fire") => [
			battleStartFunction = [
				counter = 1
			]
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return
				}
				
				if (move.type == Type.FIRE) {
					counter = 0
					battleViewController.showAbility(target, it)
				}
			]
			defensiveDamageFunction = getAbsorbDefensiveDamageFunction([move | move.type == Type.FIRE])
			offensiveDamageModifierFunction = [battleViewController, user, move, target, doesCrit | 
				if (move.type == Type.FIRE && counter == 0) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("dry-skin") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return
				}
				
				if (move.type == Type.WATER) {
					battleViewController.showAbility(target, it)
					var healing = target.maxHp / 4
					battleViewController.applyDamage(target , -healing, [])
				}
			]
			defensiveDamageFunction = [ battleViewController, user, move, target, damage, ignoreAbilities |
				if (ignoreAbilities) {
					return damage
				}
				
				if (move.type == Type.WATER) {
					return 0
				} else if (move.type == Type.FIRE) {
					return Math.floor(damage * 1.25) as int
				} else {
					return damage
				}
			]
			endOfTurnFunction = [ battleViewController, pokemon |
				if (battleViewController.weather !== null) {
					if (battleViewController.weather.isRain()) {
						battleViewController.showAbility(pokemon, it)
						val healing = pokemon.maxHp / 8
						battleViewController.applyDamage(pokemon, -healing, [])
					} else if (battleViewController.weather.isHarshSunlight()) {
						battleViewController.showAbility(pokemon, it)
						val damage = pokemon.maxHp / 8
						battleViewController.applyDamage(pokemon, damage, [])
					}
				}
			]
		],
		
		new Ability("wonder-guard") => [
			isImmuneToMoveFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (!move.type.isSuperEffective(target.types)) {
					return true
				}
				
				return false
			]
		],
		
		new Ability("bulletproof") => [
			isImmuneToMoveFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(move.moveDaoName, Moves.BULLETPROOF_MOVES)) {
					battleViewController.showAbility(target, it)
					return true
				}
				
				return false
			]
		],
		
		new Ability("heatproof") => [
			defensiveAttackStatModifierFunction = [ battleViewController, pokemon, move, ignoreAbilities |
				if (ignoreAbilities) {
					return 1.0
				}
				
				if (move.type == Type.FIRE) {
					battleViewController.showAbility(pokemon, it)
					return 0.5
				}
				
				return 1.0
			]
			defensiveStatusAilmentDamageModifierFunction = [ battleViewController, pokemon, statusAilment |
				if (statusAilment == StatusAilment.BURN) {
					battleViewController.showAbility(pokemon, it)
					return 0.5
				}
				
				return 1.0
			]
		],
		
		new Ability("poison-heal") => [
			defensiveStatusAilmentDamageModifierFunction = [ battleViewController, pokemon, statusAilment |
				if (statusAilment == StatusAilment.POISON) {
					battleViewController.showAbility(pokemon, it)
					val healing = pokemon.maxHp / 8
					battleViewController.applyDamage(pokemon, -healing, [])
					
					return 0.0
				}
				
				return 1.0
			]
		],
		
		//status abilities
		new Ability(CORROSION),
		
		new Ability("comatose") => [
			//TODO comatose
		],
		
		new Ability("purifying-salt") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.POISON, StatusAilment.PARALYSIS, StatusAilment.FREEZE, StatusAilment.BURN, StatusAilment.SLEEP, StatusAilment.YAWN)
			defensiveAttackStatModifierFunction = [ battleViewController, pokemon, move, target |
				if (move.type == Type.GHOST) {
					return 0.5
				}
				
				return 1.0
			]
		],
		
		new Ability("pastel-veil") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.POISON)
			isAllyImmuneToStatusAilmentFunction = [ battleViewController, pokemon, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (statusAilment == StatusAilment.POISON) {
					battleViewController.showAbility(pokemon, it)
					return true
				}
				
				return false
			]
			switchInFunction = [ battleViewController, pokemon |
				if (pokemon.statusAilment == StatusAilment.POISON) {
					battleViewController.showAbility(pokemon, it)
					pokemon.statusAilment = null
					pokemon.statusAilmentInfo = null
				}
				
				val ally = battleViewController.getAlly(pokemon)
				if (ally.statusAilment == StatusAilment.POISON) {
					battleViewController.showAbility(pokemon, it)
					ally.statusAilment = null
					ally.statusAilmentInfo = null
				}
			]
		],
		
		new Ability("oblivious") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.INFATUATION)
			defensiveAfterHitsFunction = getDefensiveAfterHitsCureAilmentFunction(StatusAilment.INFATUATION)
			isImmuneToAbilityFunction = getImmuneToAbilityFunction(INTIMIDATE)
			isImmuneToMoveFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(move.moveDaoName, "captivate", "taunt")) {
					battleViewController.showAbility(target, it)
					return true
				} 
				
				return false
			]
		],
		
		new Ability("soundproof") => [
			isImmuneToMoveFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(move.moveDaoName, Moves.SOUND_BASED_MOVES) && user != target) {
					battleViewController.showAbility(target, it)
					return true
				}
				
				return false
			]
		],
		
		new Ability("limber") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.PARALYSIS)
			defensiveAfterHitsFunction = getDefensiveAfterHitsCureAilmentFunction(StatusAilment.PARALYSIS)
			switchInFunction = getSwitchInCureAilmentFunction(StatusAilment.PARALYSIS)
		],
		
		new Ability("insomnia") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.SLEEP, StatusAilment.YAWN)
			defensiveAfterHitsFunction = getDefensiveAfterHitsCureAilmentFunction(StatusAilment.SLEEP, StatusAilment.YAWN)
			switchInFunction = getSwitchInCureAilmentFunction(StatusAilment.SLEEP, StatusAilment.YAWN)
		],
		
		new Ability("vital-spirit") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.SLEEP, StatusAilment.YAWN)
			defensiveAfterHitsFunction = getDefensiveAfterHitsCureAilmentFunction(StatusAilment.SLEEP, StatusAilment.YAWN)
			switchInFunction = getSwitchInCureAilmentFunction(StatusAilment.SLEEP, StatusAilment.YAWN)
		],
		
		new Ability("immunity") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.POISON)
			defensiveAfterHitsFunction = getDefensiveAfterHitsCureAilmentFunction(StatusAilment.POISON)
			switchInFunction = getSwitchInCureAilmentFunction(StatusAilment.POISON)
		],
		
		new Ability("magma-armor") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.FREEZE)
			defensiveAfterHitsFunction = getDefensiveAfterHitsCureAilmentFunction(StatusAilment.FREEZE)
			switchInFunction = getSwitchInCureAilmentFunction(StatusAilment.FREEZE)
		],
		
		new Ability("water-veil") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.BURN)
			defensiveAfterHitsFunction = getDefensiveAfterHitsCureAilmentFunction(StatusAilment.BURN)
			switchInFunction = getSwitchInCureAilmentFunction(StatusAilment.BURN)
		],
		
		new Ability("own-tempo") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.CONFUSION)
			defensiveAfterHitsFunction = getDefensiveAfterHitsCureAilmentFunction(StatusAilment.CONFUSION)
			isImmuneToAbilityFunction = [ battleViewController, pokemon, ability |
				if (ability.abilityDaoName == INTIMIDATE) {
					battleViewController.showAbility(pokemon, it)
					return true
				}
				return false
			]
		],
		
		new Ability("sweet-veil") => [
			isImmuneToStatusAilmentFunction = getImmuneToStatusesFunction(StatusAilment.SLEEP, StatusAilment.YAWN)
			isAllyImmuneToStatusAilmentFunction = [ battleViewController, target, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(statusAilment, StatusAilment.SLEEP, StatusAilment.YAWN)) {
					return true
				}
				
				return false
			]
		],
		
		new Ability("synchronize") => [
			onStatusAilmentFunction = [battleViewController, user, status, target |
				if (Util.in(status, StatusAilment.BURN, StatusAilment.PARALYSIS, StatusAilment.POISON)) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatusAilment(target, status, user, null)
				}
			]
		],
		
		new Ability("natural-cure") => [
			switchOutFunction = [ battleViewController, pokemon | 
				if (pokemon.statusAilment !== null) {
					battleViewController.showAbility(pokemon, it)
					pokemon.statusAilment = null
				}
			]
		],
		
		new Ability("regenerator") => [
			switchOutFunction = [ battleViewController, pokemon |
				if (pokemon.hp < pokemon.maxHp) {
					battleViewController.showAbility(pokemon, it)
					val healing = pokemon.maxHp / 3
					battleViewController.applyDamage(pokemon, -healing, [])
				}
			]
		],
		
		new Ability("inner-focus") => [
			isImmuneToStatusAilmentFunction = [ battleViewController, pokemon, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (statusAilment == StatusAilment.FLINCH) {
					//battleViewController.showAbility(pokemon, it)
					return true
				}
				
				return false
			]
			isImmuneToAbilityFunction = getImmuneToAbilityFunction(INTIMIDATE)
		],
		
		new Ability("shed-skin") => [
			endOfTurnFunction = [ battleViewController, pokemon |
				if (pokemon.statusAilment !== null) {
					if (Util.randomInt(1,3) == 1) {
						battleViewController.showAbility(pokemon, it)
						pokemon.statusAilment = null
						pokemon.statusAilmentInfo = null
					}
				}
			]
		],
		
		new Ability("healer") => [
			endOfTurnFunction = [ battleViewController, pokemon |
				val ally = battleViewController.getAlly(pokemon)
				if (ally.statusAilment !== null && Util.randomPercentage() <= 30) {
					battleViewController.showAbility(pokemon, it)
					ally.statusAilment = null
				}
			]
		],
		
		new Ability("steadfast") => [
			onFlinchFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
				battleViewController.applyStatChange(pokemon, pokemon, Stat.SPEED, 1, false)
			]
		],
		
		new Ability("bad-dreams") => [
			endOfTurnFunction = [ battleViewController, pokemon |
				val opponents = battleViewController.getActiveOpponents(pokemon)
				var shown = false
				for (opponent : opponents) {
					if (opponent.statusAilment == StatusAilment.SLEEP) {
						if (!shown) {
							battleViewController.showAbility(pokemon, it)
							shown = true
						}
						val damage = opponent.maxHp / 8
						battleViewController.applyDamage(opponent, damage, [])
					}
				}
			]
		],
		
		new Ability("shield-dust"),
		new Ability("serene-grace"),
		
		//accuracy abilities
		new Ability("wonder-skin"),
		
		new Ability("victory-star") => [
			offensiveAccuracyModifierFunction = [ user, move, target |
				if (move.category == MoveCategory.OHKO) {
					return 1.0
				}
				
				return 1.1
			]
			offensiveAllyAccuracyModifierFunction = [ user, move, target |
				if (move.category == MoveCategory.OHKO) {
					return 1.0
				}
				
				return 1.1
			]
		],
		
		new Ability("compound-eyes") => [
			offensiveAccuracyModifierFunction = [user, move, target | 
				if (move.category != MoveCategory.OHKO) {
					return 1.3
				}
				
				return 1.0
			]
		],
		
		new Ability("illuminate") => [
			defensiveStatChangeModifierFunction = getPreventDefensiveStatChangeModifierFunction(Stat.ACCURACY)
			offensiveAccuracyModifierFunction = getAccuracyOffensiveAccuracyModifierFunction()
		],
		
		new Ability("keen-eye") => [
			defensiveStatChangeModifierFunction = getPreventDefensiveStatChangeModifierFunction(Stat.ACCURACY)
			offensiveAccuracyModifierFunction = getAccuracyOffensiveAccuracyModifierFunction()
		],
		
		new Ability("big-pecks") => [
			defensiveStatChangeModifierFunction = getPreventDefensiveStatChangeModifierFunction(Stat.DEFENSE)
		],
		
		new Ability("tangled-feet") => [
			defensiveAccuracyModifierFunction = [ user, move, target, weather, ignoreAbilities |
				if (ignoreAbilities) {
					return 1.0
				}
				
				if (user.volatileStatusAilments.containsKey(StatusAilment.CONFUSION)) {
					return 0.5
				}
				
				return 1.0
			]
		],
		
		//stat stage abilities
		new Ability(UNAWARE),
		
		new Ability(GUARD_DOG) => [
			isImmuneToAbilityFunction = [ battleViewController, pokemon, ability |
				if (ability.abilityDaoName == INTIMIDATE) {
					battleViewController.showAbility(pokemon, it)
					battleViewController.applyStatChange(pokemon, pokemon, Stat.ATTACK, 1, false)
					return true
				}
				
				return false
			]
		],
		
		new Ability("anger-shell") => [
			defensiveBeforeMoveFunction = [battleViewController, user, move, target |
				if (target.hp > (target.maxHp / 2)) {
					counter = 1
				}
			]
			defensiveAfterHitsFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (counter == 1) {
					counter = 0
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.ATTACK, 1, false)
					battleViewController.applyStatChange(target, target, Stat.SPECIAL_ATTACK, 1, false)
					battleViewController.applyStatChange(target, target, Stat.SPEED, 1, false)
					battleViewController.applyStatChange(target, target, Stat.DEFENSE, -1, false)
					battleViewController.applyStatChange(target, target, Stat.SPECIAL_DEFENSE, -1, false)
				}
			]
		],
		
		new Ability("curious-medicine") => [
			switchInFunction = [ battleViewController, pokemon |
				val ally = battleViewController.getAlly(pokemon)
				if (ally !== null && ally.alive && !ally.tempStatChanges.empty) {
					battleViewController.showAbility(pokemon, it)
					ally.tempStatChanges.clear()
				}
			]
		],
		
		new Ability("mirror-armor") => [
			defensiveStatChangeModifierFunction = [ battleViewController, user, target, stat, valueChange, ignoreAbilities |
				if (ignoreAbilities) {
					return valueChange
				}
				
				if (Util.in(user, battleViewController.getActiveOpponents(target)) && valueChange < 0) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, user, stat, valueChange, ignoreAbilities)
					return 0
				}
				
				return valueChange
			]
		],
		
		new Ability("intrepid-sword") => [
			battleStartFunction = [
				counter = 0
			]
			switchInFunction = [ battleViewController, pokemon |
				if (counter == 0) {
					counter = 1
					battleViewController.showAbility(pokemon, it)
					battleViewController.applyStatChange(pokemon, pokemon, Stat.ATTACK, 1, false)
				}
			]
		],
		
		new Ability("dauntless-shield") => [
			counter = 0
			switchInFunction = [ battleViewController, pokemon |
				if (counter == 0) {
					counter = 1
					battleViewController.showAbility(pokemon, it)
					battleViewController.applyStatChange(pokemon, pokemon, Stat.DEFENSE, 1, false)
				}
			]
		],
		
		new Ability("beast-boost") => [
			offensiveOnKillFunction = [ battleViewController, user, move, target |
				var stat = Stat.ATTACK
				var value = user.attack
				if (user.defense > value) {
					stat = Stat.DEFENSE
					value = user.defense
				}
				if (user.specialAttack > value) {
					stat = Stat.SPECIAL_ATTACK
					value = user.specialAttack
				}
				if (user.specialDefense > value) {
					stat = Stat.SPECIAL_DEFENSE
					value = user.specialDefense
				}
				if (user.speed > value) {
					stat = Stat.SPEED
					value = user.speed
				}
				
				battleViewController.showAbility(user, it)
				battleViewController.applyStatChange(user, user, stat, 1, false)
			]
		],
		
		new Ability("competitive") => [
			onStatChangeFunction = [ battleViewController, user, target, stat, value |
				val opponents = battleViewController.getActiveOpponents(target)
				
				if (Util.in(user, opponents) && value < 0) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.SPECIAL_ATTACK, 2, false)
				}
			]
		],
		
		new Ability("flower-veil") => [
			defensiveStatChangeModifierFunction = [ battleViewController, user, target, stat, valueChange, ignoreAbilities |
				if (ignoreAbilities) {
					return valueChange
				}
				
				if (Util.in(Type.GRASS, target.types) && user != target && valueChange < 0) {
					return 0
				}
				
				return valueChange
			]
			defensiveAllyStatChangeModifierFunction = [ battleViewController, user, target, stat, valueChange, ignoreAbilities |
				if (ignoreAbilities) {
					return valueChange
				}
				
				if (Util.in(Type.GRASS, target.types) && user != target && valueChange < 0) {
					return 0
				}
				
				return valueChange
			]
			isImmuneToStatusAilmentFunction = [ battleViewController, target, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(Type.GRASS, target.types) && (Util.in(statusAilment, StatusAilment.nonVolatile) || statusAilment == StatusAilment.YAWN)) {
					return true
				}
				
				return false
			]
			isAllyImmuneToStatusAilmentFunction = [ battleViewController, target, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(Type.GRASS, target.types) && (Util.in(statusAilment, StatusAilment.nonVolatile) || statusAilment == StatusAilment.YAWN)) {
					return true
				}
				
				return false
			]
		],
		
		new Ability("sap-sipper") => [
			isImmuneToMoveFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (move.type == Type.GRASS) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.ATTACK, 1, false)
					return true
				}
				
				return false
			] 
		],
		
		new Ability("moxie") => [
			offensiveOnKillFunction = [ battleViewController, user, move, target |
				if (user.getTempStatModifier(Stat.ATTACK) < 6) {
					battleViewController.showAbility(user, it)
					battleViewController.applyStatChange(user, user, Stat.ATTACK, 1, false)
				}
			]
		],
		
		new Ability("chilling-neigh") => [
			offensiveOnKillFunction = [ battleViewController, user, move, target |
				if (user.getTempStatModifier(Stat.ATTACK) < 6) {
					battleViewController.showAbility(user, it)
					battleViewController.applyStatChange(user, user, Stat.ATTACK, 1, false)
				}
			]
		],
		
		new Ability("grim-neigh") => [
			offensiveOnKillFunction = [ battleViewController, user, move, target |
				if (user.getTempStatModifier(Stat.SPECIAL_ATTACK) < 6) {
					battleViewController.showAbility(user, it)
					battleViewController.applyStatChange(user, user, Stat.SPECIAL_ATTACK, 1, false)
				}
			]
		],
		
		new Ability("justified") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (move.type == Type.DARK) {
					battleViewController.showAbility(user, it)
					battleViewController.applyStatChange(user, user, Stat.ATTACK, 1, false)
				}
			]
		],
		
		new Ability("moody") => [
			endOfTurnFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
				
				val stats = Util.list(Stat.ATTACK, Stat.DEFENSE, Stat.SPECIAL_ATTACK, Stat.SPECIAL_DEFENSE, Stat.SPEED)
				val buff = Util.randomChoice(stats)
				stats.remove(buff)
				val nerf = Util.randomChoice(stats)
				
				battleViewController.applyStatChange(pokemon, pokemon, buff, 2, false)
				battleViewController.applyStatChange(pokemon, pokemon, nerf, -1, false)
			]
		],
		
		new Ability("rattled") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (Util.in(move.type, Type.BUG, Type.DARK, Type.GHOST)) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.SPEED, 1, false)
				}
			]
			defensiveOnAbilityFunction = [ battleViewController, user, ability, target |
				if (ability.abilityDaoName == INTIMIDATE) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.SPEED, 1, false)
				}
			]
		],
		
		new Ability("defiant") => [
			onStatChangeFunction = [ battleViewController, user, target, stat, value |
				val opponents = battleViewController.getActiveOpponents(target)
				if (Util.in(user, opponents)) {
					battleViewController.showAbility(target, it)
					battleViewController.applyStatChange(target, target, Stat.ATTACK, 2, false)
				}
			]
		],
		
		new Ability("download") => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
				
				val opponents = battleViewController.getActiveOpponents(pokemon)
				val totalDefense = opponents.map[opponent | battleViewController.battleCalculator.getEffectiveDefense(opponent, false)].reduce[a, b | a+b]
				val totalSpecialDefense = opponents.map[opponent | battleViewController.battleCalculator.getEffectiveSpecialDefense(opponent, false)].reduce[a, b | a+b]
				
				if (totalDefense > totalSpecialDefense) {
					battleViewController.applyStatChange(pokemon, pokemon, Stat.ATTACK, 1,false)
				} else {
					battleViewController.applyStatChange(pokemon, pokemon, Stat.SPECIAL_ATTACK, 1, false)
				}
			]
		],
		
		new Ability("speed-boost") => [
			endOfTurnFunction = [battleViewController, pokemon |
				if (!battleViewController.switchedInThisTurn.contains(pokemon)) {
					battleViewController.showAbility(pokemon, it)
					battleViewController.applyStatChange(pokemon, pokemon, SPEED, 1, false)
				}
			]
		],
		
		new Ability("intimidate") => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it) 
				for (target : battleViewController.getActiveOpponents(pokemon)) {
					if (!target.ability?.isImmuneToAbilityFunction?.apply(battleViewController, target, it)) {
						battleViewController.applyStatChange(pokemon, target, ATTACK, -1, false)
						target.ability?.defensiveOnAbilityFunction?.apply(battleViewController, pokemon, it, target)
					}
				}
			]
		],
		
		new Ability("clear-body") => [
			defensiveStatChangeModifierFunction = [battleViewController, user, target, stat, value, ignoreAbilities |
				if (ignoreAbilities) {
					return value
				}
				
				if (value < 0 && user != target) {
					battleViewController.showAbility(target, it)
					return 0
				}
				
				return value
			]
		],
		
		new Ability("white-smoke") => [
			defensiveStatChangeModifierFunction = [battleViewController, user, target, stat, value, ignoreAbilities |
				if (ignoreAbilities) {
					return value
				}
				
				if (value < 0 && user != target) {
					battleViewController.showAbility(target, it)
					return 0
				}
				
				return value
			]
		],
		
		new Ability("full-metal-body") => [
			defensiveStatChangeModifierFunction = [battleViewController, user, target, stat, value, ignoreAbilities |
				if (value < 0 && user != target) {
					battleViewController.showAbility(target, it)
					return 0
				}
				
				return value
			]
		],
		
		new Ability("contrary") => [
			defensiveStatChangeModifierFunction = [battleViewController, user, target, stat, value, ignoreAbilities |
				if (ignoreAbilities) {
					return value
				}
				
				battleViewController.showAbility(target, it)
				return -1 * value
			]
		],
		
		new Ability("simple") => [
			defensiveStatChangeModifierFunction = [ battleViewController, user, target, stat, value, ignoreAbilities |
				if (ignoreAbilities) {
					return value
				}
				
				battleViewController.showAbility(target, it)
				return 2 * value
			]
		],
		
		new Ability("anger-point") => [
			defensiveOnCritFunction = [ battleViewController, user, move, target |
				battleViewController.showAbility(user, it)
				battleViewController.applyStatValue(user, user, ATTACK, 6)
			]
		],
		
		//offensive damage abilities
		new Ability("rocky-payload") => [
			offensiveAttackStatModifierFunction = [ battleViewController, user, move |
				if (move.type == Type.ROCK) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("transistor") => [
			offensiveAttackStatModifierFunction = [ battleViewController, user, move |
				if (move.type == Type.ELECTRIC) {
					return 1.3
				}
				
				return 1.0
			]
		],
		
		new Ability("dragons-maw") => [
			offensiveAttackStatModifierFunction = [ battleViewController, user, move |
				if (move.type == Type.DRAGON) {
					return 1.3
				}
				
				return 1.0
			]
		],
		
		new Ability("gorilla-tactics") => [
			offensiveAttackStatModifierFunction = [ battleViewController, user, move |
				if (move.physical) {
					battleViewController.applyStatusAilment(user, StatusAilment.CHOICE, user, new StatusAilmentInfo => [
						it.move = move
					])
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("steely-spirit") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (move.type == Type.STEEL) {
					return 1.5
				}
				
				return 1.0
			]
			offensiveAllyDamageModifierFunction = [ battleViewController, user, move, target |
				if (move.type == Type.STEEL) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("punk-rock") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (Util.in(move.moveDaoName, Moves.SOUND_BASED_MOVES)) {
					return 1.3
				}
				
				return 1.0
			]
			defensiveDamageFunction = [ battleViewController, user, move, target, damage, ignoreAbilities |
				if (ignoreAbilities) {
					return damage
				}
				
				if (Util.in(move.moveDaoName, Moves.SOUND_BASED_MOVES)) {
					return Math.floor(damage * 0.5) as int
				}
				
				return damage
			]
		],
		
		new Ability("neuroforce") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (move.type.isSuperEffective(target.types)) {
					return 1.25
				}
				
				return 1.0
			]
		],
		
		new Ability("battery") => [
			offensiveAllyAttackStatModifierFunction = [ battleViewController, user, move |
				if (move.special) {
					return 1.3
				}
				
				return 1.0
			]
		],
		
		new Ability("power-spot") => [
			offensiveAllyDamageModifierFunction = [ battleViewController, user, move, target |
				return 1.3
			]
		],
		
		new Ability("steelworker") => [
			offensiveAttackStatModifierFunction = [ battleViewController, user, move |
				if (move.type == Type.STEEL) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("dark-aura") => [
			globalDamageModifierFunction = getAuraDamageModifierFunction(Type.DARK)
		],
		
		new Ability("fairy-aura") => [
			globalDamageModifierFunction = getAuraDamageModifierFunction(Type.FAIRY)
		],
		
		new Ability("stakeout") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (battleViewController.switchedInThisTurn.contains(target)) {
					return 2.0
				}
				
				return 1.0
			]
		],
		
		new Ability("water-bubble") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (move.type == Type.WATER) {
					return 2.0
				}
				
				return 1.0
			]
			defensiveDamageFunction = [ battleViewController, user, move, target, damage, ignoreAbilities |
				if (ignoreAbilities) {
					return damage
				}
				
				if (move.type == Type.FIRE) {
					return Math.floor(damage / 2) as int
				}
				
				return damage
			]
			isImmuneToStatusAilmentFunction = [ battleViewController, target, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (statusAilment == StatusAilment.BURN) {
					return true
				}
				
				return false
			]
			switchInFunction = [ battleViewController, pokemon |
				if (pokemon.statusAilment == StatusAilment.BURN) {
					battleViewController.showAbility(pokemon, it)
					pokemon.statusAilment = null
					pokemon.statusAilmentInfo = null
				}
			]
			endOfTurnFunction = [ battleViewController, pokemon |
				if (pokemon.statusAilment == StatusAilment.BURN) {
					battleViewController.showAbility(pokemon, it)
					pokemon.statusAilment = null
					pokemon.statusAilmentInfo = null
				}
			]
		],
		
		new Ability("tough-claws") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (isContactMove(user, move)) {
					return 1.3
				}
				
				return 1.0
			]
		],
		
		new Ability("mega-launcher") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (Util.in(move.moveDaoName, Moves.AURA_PULSE_MOVES)) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("strong-jaw") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (Util.in(move.moveDaoName, Moves.BITING_MOVES)) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability(ANALYTIC) => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (counter > 0) {
					counter = 0
					return 1.3
				}
				
				return 1.0
			]
		],
		
		new Ability("adaptability") => [
			offensiveStabBonusFunction = [ battleViewController, pokemon, move |
				if (Util.in(move.type, pokemon.types)) {
					return 2.0
				}
				
				return 1.0
			]
		],
		
		new Ability("huge-power") => [
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (move.physical) {
					return 2.0
				}
				
				return 1.0
			]
		],
		
		new Ability("pure-power") => [
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (move.physical) {
					return 2.0
				}
				
				return 1.0
			]
		],
		
		new Ability("guts") => [
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move | 
				if (pokemon.statusAilment !== null && move.physical) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("hustle") => [
			offensiveAccuracyModifierFunction = [ user, move, target |
				if (move.damageClass == MoveDamageClass.PHYSICAL) {
					return 0.8
				}
				
				return 1.0
			]
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (move.damageClass == MoveDamageClass.PHYSICAL) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("plus") => [
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move | 
				val partner = battleViewController.getAlly(pokemon)
				if (move.special && partner?.ability?.abilityDaoName == "minus") {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("minus") => [
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move | 
				val partner = battleViewController.getAlly(pokemon)
				if (move.special && partner?.ability?.abilityDaoName == "plus") {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("rivalry") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (user.gender == Gender.MALE) {
					if (target.gender == Gender.MALE) {
						return 1.25
					} else if (target.gender == Gender.FEMALE) {
						return 0.75
					} else {
						return 1.0
					}
				} else if (user.gender == Gender.FEMALE) {
					if (target.gender == Gender.FEMALE) {
						return 1.25
					} else if (target.gender == Gender.MALE) {
						return 0.75
					} else {
						return 1.0
					}
				} else {
					return 1.0
				}
			]
		],
		
		new Ability("iron-fist") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (Util.in(move.moveDaoName, Moves.PUNCHING_MOVES)) {
					return 1.2
				}
				
				return 1.0
			]
		],
		
		new Ability("technician") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				//TODO variable power moves
				if (move.power <= 60) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("tinted-lens") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (move.type.isNotVeryEffective(target.types)) {
					return 2.0
				}
				
				return 1.0
			]
		],
		
		new Ability("slow-start") => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
				counter = 5
			]
			speedModifierFunction = [ pokemon, weather |
				if (counter > 0) {
					return 0.5
				}
				
				return 1.0
			]
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (counter > 0 && move.physical) {
					return 0.5
				}
				
				return 1.0
			]
			endOfTurnFunction = [ battleViewController, pokemon |
				if (counter > 0) {
					counter = counter - 1
				}
			]
		],
		
		new Ability("scrappy") => [
			isImmuneToAbilityFunction = getImmuneToAbilityFunction(Abilities.INTIMIDATE)
		],
		
		new Ability("sheer-force") => [
			//TODO sheer-force: other random effects prevented
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (Util.in(move.moveDaoName, Moves.SHEER_FORCE_MOVES)) {
					return 1.3
				}
				
				return 1.0
			]
		],
		
		new Ability("defeatist") => [
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (pokemon.hp <= (pokemon.maxHp/2)) {
					return 0.5
				}
				
				return 1.0
			]
		],
		
		new Ability("toxic-boost") => [
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (move.physical && pokemon.statusAilment == StatusAilment.POISON) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("flare-boost") => [
			offensiveAttackStatModifierFunction = [ battleViewController, pokemon, move |
				if (move.special && pokemon.statusAilment == StatusAilment.BURN) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		
		//defensive damage abilities
		new Ability("ice-scales") => [
			defensiveDamageFunction = [ battleViewcOntroller, user, move, target, damage, ignoreAbilities |
				if (ignoreAbilities) {
					return damage
				}
				
				if (move.special && !Util.in(move.moveDaoName, Moves.DIRECT_DAMAGE_MOVES)) {
					return Math.floor(damage / 2) as int
				}
				
				return damage
			]
		],
		
		new Ability("fluffy") => [
			defensiveDamageFunction = [ battleViewController, user, move, target, damage, ignoreAbilities |
				if (ignoreAbilities) {
					return damage
				}
				
				var modifier = 1.0
				
				if (isContactMove(user, move)) {
					modifier *= 0.5
				}
				
				if (move.type == Type.FIRE) {
					modifier *= 2.0
				}
				
				return Math.floor(damage * modifier) as int
			]
		],
		
		new Ability("fur-coat") => [
			defensiveDefenseStatModifierFunction = [ battleViewController, pokemon, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return 1.0
				}
				
				if (move.physical) {
					return 2.0
				}
				
				return 1.0
			]
		],
		
		new Ability("thick-fat") => [
			defensiveAttackStatModifierFunction = [ battleViewController, pokemon, move, ignoreAbilities |
				if (ignoreAbilities) {
					return 1.0
				}
				
				if (Util.in(move.type, Type.ICE, Type.FIRE)) {
					battleViewController.showAbility(pokemon, it)
					return 0.5
				}
				
				return 1.0
			]
		],
		
		new Ability("filter") => [
			defensiveDamageFunction = [ battleViewController, user, move, target, damage, ignoreAbilities |
				if (ignoreAbilities) {
					return damage
				}
				
				if (move.type.isSuperEffective(target.types)) {
					return Math.floor(damage * 0.75) as int
				}
				
				return damage
			]
		],
		
		new Ability("solid-rock") => [
			defensiveDamageFunction = [ battleViewController, user, move, target, damage, ignoreAbilities |
				if (ignoreAbilities) {
					return damage
				}
				
				if (move.type.isSuperEffective(target.types)) {
					return Math.floor(damage * 0.75) as int
				}
				
				return damage
			]
		],
		
		new Ability("prism-armor") => [
			defensiveDamageFunction = [ battleViewController, user, move, target, damage, ignoreAbilities |
				if (move.type.isSuperEffective(target.types)) {
					return Math.floor(damage * 0.75) as int
				}
				
				return damage
			]
		],
		
		new Ability("marvel-scale") => [
			defensiveDefenseStatModifierFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return 1.0
				}
				
				if (target.statusAilment !== null && move.physical) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		new Ability("multiscale") => [
			defensiveDamageFunction = [ battleViewController, user, move, target, damage, ignoreAbilities |
				if (ignoreAbilities) {
					return damage
				}
				
				if (target.hp == target.maxHp && !Util.in(move.moveDaoName, Moves.DIRECT_DAMAGE_MOVES)) {
					return Math.floor(damage * 0.5) as int
				}
				
				return damage
			]
		],
		
		new Ability("shadow-shield") => [
			defensiveDamageFunction = [ battleViewController, user, move, target, damage, ignoreAbilities |
				if (target.hp == target.maxHp && !Util.in(move.moveDaoName, Moves.DIRECT_DAMAGE_MOVES)) {
					return Math.floor(damage * 0.5) as int
				}
				
				return damage
			]
		],
		
		new Ability("hyper-cutter") => [
			defensiveStatChangeModifierFunction = [battleViewController, user, target, stat, value, ignoreAbilities |
				if (ignoreAbilities) {
					return value
				}
				
				if (stat == Stat.ATTACK && value < 0 && user != target) {
					battleViewController.showAbility(target, it)
					return 0
				}
				
				return value
			]
		],
		
		
		new Ability("friend-guard") => [
			defensiveAllyDefenseStatModifierFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return 1.0
				}
				
				if (Util.in(move.moveDaoName, Moves.DIRECT_DAMAGE_MOVES)) {
					return 1.0
				}
				
				return 0.75
			]
		],
		
		//type abilities
		new Ability("color-change") => [
			defensiveAfterHitsFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (user.ability?.abilityDaoName == SHEER_FORCE && Util.in(move, Moves.SHEER_FORCE_MOVES)) {
					return
				}
				
				if (!target.types.contains(move) && move.category.isDamage()) {
					battleViewController.showAbility(target, it)
					target.types.clear()
					target.types.add(move.type)
				}
			]
		],
		
		new Ability("protean") => [
			offensiveBeforeMoveFunction = [battleViewController, user, move |
				if (counter > 0 && !user.types.contains(move.type)) {
					battleViewController.showAbility(user, it)
					user.types.clear()
					user.types.add(move.type)
				}
				
				return false //don't skip turn
			]
			switchInFunction = [ battleViewController, pokemon | 
				counter = 1
			]
		],
		
		new Ability("libero") => [
			offensiveBeforeMoveFunction = [battleViewController, user, move |
				if (counter > 0 && !user.types.contains(move.type)) {
					battleViewController.showAbility(user, it)
					user.types.clear()
					user.types.add(move.type)
				}
				
				return false //don't skip turn
			]
			switchInFunction = [ battleViewController, pokemon | 
				counter = 1
			]
		],
		
		new Ability("levitate") => [
			isImmuneToMoveFunction = [battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (move.type == Type.GROUND) {
					battleViewController.showAbility(target, it)
					return true
				}
				
				return false
			]
		],
		
		//switching abilities
		new Ability("suction-cups") => [
			isImmuneToForceSwitch = true
		],
		
		new Ability("shadow-tag") => [
			isTrappedFunction = [ battleViewController, trapper, runner |
				return !runner.types.contains(Type.GHOST) 
			]
		],
		
		new Ability("arena-trap") => [
			isTrappedFunction = [ battleViewController, trapper, runner |
				if (battleViewController.isGrounded(runner) || runner.types.contains(Type.GHOST)) {
					return false
				}
				
				return true
			]
		],
		
		new Ability("magnet-pull") => [
			isTrappedFunction = [ battleViewController, trapper, runner | 
				return runner.types.contains(Type.STEEL) && !runner.types.contains(Type.GHOST)
			]
		],
		
		new Ability("run-away"),
		
		//ability abilities
		new Ability("receiver") => [
			globalOnFaintFunction = [ battleViewController, pokemon, faintedPokemon |
				if (battleViewController.getAlly(pokemon) == faintedPokemon && !Util.in(faintedPokemon.ability, UNCOPYABLE_ABILITIES)) {
					battleViewController.showAbility(pokemon, it)
					pokemon.formerAbility = pokemon.ability
					pokemon.ability = faintedPokemon.ability
				}
			]
		],
		
		new Ability("power-of-alchemy") => [
			globalOnFaintFunction = [ battleViewController, pokemon, faintedPokemon |
				if (battleViewController.getAlly(pokemon) == faintedPokemon && !Util.in(faintedPokemon.ability, UNCOPYABLE_ABILITIES)) {
					battleViewController.showAbility(pokemon, it)
					pokemon.formerAbility = pokemon.ability
					pokemon.ability = faintedPokemon.ability
				}
			]
		],
		
		new Ability("trace") => [
			switchInFunction = [ battleViewController, pokemon |
				val randomChoice = Util.randomChoice(battleViewController.getActiveOpponents(pokemon).filterNull.filter[alive].filter[!Util.in(ability.abilityDaoName, UNTRACEABLE_ABILITIES)].toList)
				if (randomChoice !== null) {
					pokemon.formerAbility = pokemon.ability
					pokemon.ability = randomChoice.ability
					if (pokemon.ability.abilityDaoName != 'trace') {
						pokemon.ability.switchInFunction?.apply(battleViewController, pokemon)
					}
				}
			]
		],
		
		new Ability("lingering-aroma") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (isContactMove(user, move)) {
					if (Util.in(user.ability?.abilityDaoName, UNCHANGEABLE_ABILITIES)) {
						return
					}
					
					battleViewController.showAbility(target, it)
					user.formerAbility = user.ability
					user.ability = it
				}
			]
		],
		
		new Ability("mummy") => [
			defensiveOnHitFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (isContactMove(user, move)) {
					if (Util.in(user.ability?.abilityDaoName, UNCHANGEABLE_ABILITIES)) {
						return
					}
					
					battleViewController.showAbility(target, it)
					user.formerAbility = user.ability
					user.ability = it
				}
			]
		],
		
		new Ability(MOLD_BREAKER) => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
				battleViewController.addText("%s breaks the mold", battleViewController.getFullLabel(pokemon))
			]
		],
		
		new Ability(TERAVOLT) => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
				battleViewController.addText("%s is radiating a bursting aura", battleViewController.getFullLabel(pokemon))
			]
		],
		
		new Ability(TURBOBLAZE) => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
				battleViewController.addText("%s is radiating a blazing aura", battleViewController.getFullLabel(pokemon))
			]
		],
		
		//move abilities
		new Ability("normalize") => [
			//TODO normalize
		],
		
		new Ability("refrigerate"),
		new Ability("pixilate"),
		new Ability("aerilate"),
		new Ability("liquid-voice"),
		new Ability("galvanize"),
		
		
		new Ability("aroma-veil") => [
			isImmuneToStatusAilmentFunction = [ battleViewController, user, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(statusAilment, StatusAilment.TAUNT, StatusAilment.TORMENT, StatusAilment.ENCORE, StatusAilment.DISABLE, StatusAilment.HEAL_BLOCK, StatusAilment.INFATUATION)) {
					return true
				}
				
				return false
			]
			isAllyImmuneToStatusAilmentFunction = [ battleViewController, user, statusAilment, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(statusAilment, StatusAilment.TAUNT, StatusAilment.TORMENT, StatusAilment.ENCORE, StatusAilment.DISABLE, StatusAilment.HEAL_BLOCK, StatusAilment.INFATUATION)) {
					return true
				}
				
				return false
			]
		],
		
		//speed abilities
		new Ability("quick-feet") => [
			speedModifierFunction = [ battleViewController, pokemon |
				if (pokemon.statusAilment !== null) {
					return 1.5
				}
				
				return 1.0
			]
		],
		
		//priority abilties
		new Ability(PRANKSTER),
		new Ability(GALE_WINGS),
		new Ability(TRIAGE),
		
		new Ability(QUICK_DRAW),
		
		//other abilities
		new Ability("unseen-fist"), //TODO
		
		new Ability(NEUTRALIZING_GAS), //TODO
		
		new Ability(NO_GUARD),
		
		new Ability(TELEPATHY),
		
		new Ability("infiltrator"), //TODO infiltrator
		
		new Ability(AURA_BREAK),
		
		new Ability("parental-bond"), //TODO
		
		new Ability("dancer"), //TODO
		
		new Ability("screen-cleaner"), //TODO
		
		new Ability("wimp-out") => [
			defensiveAfterHitsFunction = [battleViewController, user, move, target, ignoreAbilities |
				if (user.ability.abilityDaoName == SHEER_FORCE && Util.in(move.moveDaoName, Moves.SHEER_FORCE_MOVES)) {
					return
				}
				
				if (counter > 0 && user.hp < (user.maxHp / 2)) {
					battleViewController.showAbility(target, it)
					// TODO battleViewController.switchPokemon()
				}
			]
			defensiveBeforeMoveFunction = [battleViewController, user, move, target |
				if (target.hp > (target.maxHp / 2)) {
					counter = 1
				}
			]
		],
		
		new Ability("emergency-exit") => [
			defensiveAfterHitsFunction = [battleViewController, user, move, target, ignoreAbilities |
				if (user.ability.abilityDaoName == SHEER_FORCE && Util.in(move.moveDaoName, Moves.SHEER_FORCE_MOVES)) {
					return
				}
				if (counter > 0 && user.hp < (user.maxHp / 2)) {
					battleViewController.showAbility(target, it)
					// TODO battleViewController.switchPokemon()
				}
			]
			defensiveBeforeMoveFunction = [battleViewController, user, move, target |
				if (target.hp > (target.maxHp / 2)) {
					counter = 1
				}
			]
		],
		
		new Ability("berserk") => [
			defensiveAfterHitsFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (user.ability.abilityDaoName == SHEER_FORCE && Util.in(move.moveDaoName, Moves.SHEER_FORCE_MOVES)) {
					return
				}
				
				if (counter > 0 && user.hp < (user.maxHp / 2)) {
					battleViewController.showAbility(target, it) 
					battleViewController.applyStatChange(target, target, Stat.SPECIAL_ATTACK, 1, false)
				}
			]
			defensiveBeforeMoveFunction = [ battleViewController, user, move, target |
				if (target.hp > (target.maxHp / 2)) {
					counter = 1
				}
			]
		],
		
		new Ability("queenly-majesty") => [
			isImmuneToMoveFunction = getImmuneToPriorityMovesFunction()
			isAllyImmuneToMoveFunction = getImmuneToPriorityMovesFunction()
		],
		
		new Ability("dazzling") => [
			isImmuneToMoveFunction = getImmuneToPriorityMovesFunction()
			isAllyImmuneToMoveFunction = getImmuneToPriorityMovesFunction()
		],
		
		new Ability("magic-bounce") => [
			isImmuneToMoveFunction = [ battleViewController, user, move, target, ignoreAbilities |
				if (ignoreAbilities) {
					return false
				}
				
				if (Util.in(move.moveDaoName, Moves.MAGIC_BOUNCE_MOVES)) {
					battleViewController.showAbility(target, it)
					battleViewController.useMove(target, move, Util.list(battleViewController.getSlot(user)), [])
					return true
				}
				
				return false
			]
		],
		
		new Ability("magic-guard") => [
			defensiveStatusAilmentDamageModifierFunction = [ battleViewController, pokemon, statusAilment |
				return 0d
			]
			isImmuneToWeatherDamageFunction = [ weather | 
				return true
			]
			offensiveDrainModifierFunction = [ user, move, target, drain |
				if (drain < 0) { //recoil
					return 0d
				}
				
				return 1.0
			]
		],
		
		new Ability("skill-link") => [
			//TODO skill-link
		],
		
		new Ability("pressure") => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
			]
		],
		
		new Ability("pickup") => [
			//TODO pickup
		],
		
		new Ability("honey-gather") => [
			//TODO honey gather
		],
		
		new Ability("truant") => [
			switchInFunction = [
				counter = 1
			]
			offensiveBeforeMoveFunction = [ battleViewController, pokemon, move |
				if (counter == 0) {
					battleViewController.addText("%s is loafing around", battleViewController.getFullLabel(pokemon))
					counter = 1
					return true
				} else {
					counter = 0
					return false
				}
			]
		],
		
		new Ability("rock-head") => [
			offensiveDrainModifierFunction = [ user, move, target, drain |
				if (drain < 0) { //recoil
					return 0d
				}
				
				return 1.0
			]
		],
		
		new Ability("reckless") => [
			offensiveDamageModifierFunction = [ battleViewController, user, move, target, doesCrit |
				if (Util.in(move.moveDaoName, Moves.RECKLESS_MOVES)) {
					return 1.2
				}
				
				return 1.0
			]
		],
		
		new Ability("anticipation") => [
			switchInFunction = [ battleViewController, pokemon |
				val opponents = battleViewController.getActiveOpponents(pokemon)
				for (opponent : opponents) {
					for (Move move : opponent.moves) {
						if (!move.status && move.type.isSuperEffective(pokemon.types)) {
							battleViewController.showAbility(pokemon, it)
							battleViewController.addText("%s shudders", battleViewController.getFullLabel(pokemon))
							return
						}
					}
				}
			]
		],
		
		new Ability("forewarn") => [
			switchInFunction = [ battleViewController, pokemon |
				val Map<Integer, List<Pair<Pokemon, Move>>> movesByPower = new HashMap
				
				for (opponent : battleViewController.getActiveOpponents(pokemon)) {
					for (move : opponent.moves) {
						val power = move.power
						//TODO accurate power rankings for variable power moves
						if (!movesByPower.containsKey(power)) {
							movesByPower.put(power, new ArrayList)
						}
						
						movesByPower.get(power).add(opponent -> move)
					}
				}
				val maxPower = movesByPower.keySet.max()
				
				val warnPair = Util.randomChoice(movesByPower.get(maxPower))
				val opponent = warnPair.key
				val move = warnPair.value
				
				battleViewController.showAbility(pokemon, it)
				battleViewController.addText("%s's %s was revealed", battleViewController.getFullLabel(opponent), move.label)
			]
		],
		
		new Ability("heavy-metal") => [
			weightModifierFunction = [
				return 2.0
			]
		],
		
		new Ability("light-metal") => [
			weightModifierFunction = [
				return 0.5
			]
		],
		
		//berry abilities
		new Ability("ripen"),
		
		new Ability("gluttony"),
		
		new Ability("harvest"),
		
		new Ability("cheek-pouch"),
		
		//item abilities
		
		new Ability("symbiosis"),
		
		new Ability("sticky-hold"),
		
		new Ability("magician"),
		
		new Ability("ball-fetch"),
		
		new Ability("unburden") => [
			//TODO unburden
		],
		
		new Ability("klutz") => [
			//TODO klutz
		],
		
		new Ability("frisk") => [
			//TODO frisk
		],
		
		new Ability("pickpocket") => [
			//TODO pickpocket
		],
		
		new Ability(UNNERVE) => [
			//TODO unnerve
		],
		
		//pokemon-specific abilities
		new Ability("as-one-glastrier") => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
				battleViewController.addText("%s has two Abilities", battleViewController.getFullLabel(pokemon))
				battleViewController.showAbility(pokemon, it) //TODO unnerve
				battleViewController.addText(getUnnerveMessage(battleViewController.getSlot(pokemon).isPlayer()))
			]
			offensiveOnKillFunction = [ battleViewController, user, move, target |
				if (user.getTempStatModifier(Stat.ATTACK) < 6) {
					battleViewController.showAbility(user, it) //TODO chilling-neigh
					battleViewController.applyStatChange(user, user, Stat.ATTACK, 1, false)
				}
			]
			//TODO unnerve
		],
		
		new Ability("as-one-spectrier") => [
			switchInFunction = [ battleViewController, pokemon |
				battleViewController.showAbility(pokemon, it)
				battleViewController.addText("%s has two Abilities", battleViewController.getFullLabel(pokemon))
				battleViewController.showAbility(pokemon, it) //TODO unnerve
				battleViewController.addText(getUnnerveMessage(battleViewController.getSlot(pokemon).isPlayer()))
			]
			offensiveOnKillFunction = [ battleViewController, user, move, target |
				if (user.getTempStatModifier(Stat.SPECIAL_ATTACK) < 6) {
					battleViewController.showAbility(user, it) //TODO grim-neigh
					battleViewController.applyStatChange(user, user, Stat.SPECIAL_ATTACK, 1, false)
				}
			]
			//TODO unnerve
		],
		
		new Ability("commander") => [
			//TODO commander (tatsugiri)
		],
		
		new Ability("zero-to-hero") => [
			//TODO zero-to-hero (palafin)
		],
		
		new Ability("hunger-switch") => [
			//TODO hunger-switch (morpeko)
		],
		
		new Ability("ice-face") => [
			//TODO ice-face (eiscue)
		],
		
		new Ability("gulp-missile") => [
			//TODO gulp-missile (cramorant)
		],
		
		new Ability("rks-system") => [
			//TODO rks-system (silvally)
		],
		
		new Ability("forecast") => [
			//TODO forecast (castform)
		],
		
		new Ability("multitype") => [
			//TODO multitype (arceus)
		],
		
		new Ability("illusion") => [
			//TODO illusion (zoroark)
		],
		
		new Ability("imposter") => [
			//TODO imposter (ditto)
		],
		
		new Ability("zen-mode") => [
			//TODO zen-mode (darmanitan)
		],
		
		new Ability("stance-change") => [
			//TODO stance-change (aegislash)
		],
		
		new Ability("shields-down") => [
			//TODO shields-down (minior)
		],
		
		new Ability("schooling") => [
			//TODO schooling (wishiwashi)
		],
		
		new Ability("disguise") => [
			//TODO disguise (mimikyu)
		],
		
		new Ability("battle-bond") => [
			//TODO battle-bond (greninja)
		],
		
		new Ability("power-construct") => [
			//TODO power-construct (zygarde)
		],
		
		//starter abilities
		new Ability("overgrow") => [
			offensiveDamageModifierFunction = getStarterMoveDamageModifierFunction(Type.GRASS)
		],
		
		new Ability("blaze") => [
			offensiveDamageModifierFunction = getStarterMoveDamageModifierFunction(Type.FIRE) 
		],
		
		new Ability("torrent") => [
			offensiveDamageModifierFunction = getStarterMoveDamageModifierFunction(Type.WATER)
		],
		
		new Ability("swarm") => [
			offensiveDamageModifierFunction = getStarterMoveDamageModifierFunction(Type.BUG)
		]
	].toMap[abilityDaoName]
	
	def static Function3<Pokemon, Move, Pokemon, Double> getAccuracyOffensiveAccuracyModifierFunction() {
		return [user, move, target |
				//cancel opponent's evasion boosts
				val tempStatChanges = target.getTempStatModifier(EVASION)
				if (tempStatChanges > 0) {
					return (3 + tempStatChanges) / 3
				}
				
				return 1.0
			]
	}
	
	def static Function6<BattleViewController, Pokemon, Pokemon, Stat, Integer, Boolean, Integer> getPreventDefensiveStatChangeModifierFunction(Ability ability, Stat lockedStat) {
		return [ battleViewController, user, target, stat, value, ignoreAbilities |
			if (ignoreAbilities) {
				return value
			}
			
			if (stat == lockedStat && value > 0 && user != target) {
				battleViewController.showAbility(target, ability)
				return 0
			}
			
			return value
		]
	}
	
	private static def Function5<BattleViewController, Pokemon, Move, Pokemon, Boolean, Double> getStarterMoveDamageModifierFunction(Ability ability, Type type) {
		return [ battleViewController, user, move, target, doesCrit |
			if (move.type == type && user.hpPercentage <= 33) {
				battleViewController.showAbility(user, ability)
				return 1.5
			} else {
				return 1.0
			}
		]
	}
	
	private static def Function5<Pokemon, Move, Pokemon, Weather, Boolean, Double> getWeatherAccuracyModifierFunction(Weather abilityWeather) {
		return [ user, move, target, weather, ignoreAbilities |
			if (ignoreAbilities) {
				return 1.0
			}
			
			if (weather == abilityWeather) {
				return 0.8d
			}
			
			return 1d
		]
	}
	
	private static def Function2<BattleViewController, Pokemon, Double> getWeatherSpeedModifierFunction(Predicate<Weather> weatherPredicate) {
		return [ battleViewController, user |
			if (weatherPredicate.test(battleViewController.weather)) {
				return 2.0
			}
			
			return 1.0
		]
	}
	
	private static def Procedure5<BattleViewController, Pokemon, Move, Pokemon, Boolean> getAbsorbDefensiveOnHitFunction(Type type, Ability ability) {
		return [battleViewController, user, move, target, ignoreAbilities |
			if (ignoreAbilities) {
				return
			}
			
			if (move.type == type) {
				battleViewController.showAbility(target, ability)
				target.hp = Math.min(target.maxHp, target.maxHp/4 + target.hp)
			}
		]
	}
	
	private static def Function6<BattleViewController, Pokemon, Move, Pokemon, Integer, Boolean, Integer> getAbsorbDefensiveDamageFunction(Predicate<Move> movePredicate) {
		return [ battleViewController, user, move, target, damage, ignoreAbilities |
			if (ignoreAbilities) {
				return null
			}
			
			if (movePredicate.test(move)) {
				return 0
			}
			
			return null
		]
	}
	
	private static def Procedure2<BattleViewController, Pokemon> getTerrainCreateFunction(Ability ability, Terrain terrain) {
		return [ battleViewController, pokemon |
			battleViewController.showAbility(pokemon, ability)
			var Integer duration = 5
			
			//terrain extender
			
			battleViewController.changeTerrain(terrain, duration)
		]
	}
	
	private static def Procedure2<BattleViewController, Pokemon> getWeatherCreateFunction(Ability ability, Weather weather) {
		return [battleViewController, pokemon |
			battleViewController.showAbility(pokemon, ability)
			var Integer duration = 5
			if (weather.primordial) {
				duration = null
			}
			//rocks
			
			battleViewController.changeWeather(weather, duration)
		]
	}
	
	private static def Function4<BattleViewController, Pokemon, StatusAilment, Boolean, Boolean> getImmuneToStatusesFunction(Ability ability, StatusAilment...statusAilments) {
		return [battleViewController, pokemon, statusAilment, ignoreAbilities |
			if(ignoreAbilities) {
				return false
			}
			
			if (Util.in(statusAilment, statusAilments)) {
				battleViewController.showAbility(pokemon, ability)
				return true
			}
			
			return false
		]
	}
	
	private static def Procedure2<BattleViewController, Pokemon> getSwitchInCureAilmentFunction(Ability ability, StatusAilment... statusAilments) {
		return [ battleViewController, target |
			if (Util.in(target.statusAilment, statusAilments)) {
				battleViewController.showAbility(target, ability)
				battleViewController.addText("%s was cured of its %s", battleViewController.getFullLabel(target), target.statusAilment.apiLabel)
				target.statusAilment = null
				target.statusAilmentInfo = null
			} else {
				for (StatusAilment statusAilment : statusAilments) {
					if (target.volatileStatusAilments.containsKey(statusAilment)) {
						battleViewController.showAbility(target, ability)
						target.volatileStatusAilments.remove(statusAilment)
					}
				}
			}
		]
	}
	
	private static def Procedure5<BattleViewController, Pokemon, Move, Pokemon, Boolean> getDefensiveAfterHitsCureAilmentFunction(Ability ability, StatusAilment... statusAilments) {
		return [ battleViewController, user, move, target, ignoreAbilities |
			if (Util.in(target.statusAilment, statusAilments)) {
				battleViewController.showAbility(target, ability)
				target.statusAilment = null
				target.statusAilmentInfo = null
			} else {
				for (StatusAilment statusAilment : statusAilments) {
					if (target.volatileStatusAilments.containsKey(statusAilment)) {
						battleViewController.showAbility(target, ability)
						target.volatileStatusAilments.remove(statusAilment)
					}
				}
			}
		]
	}
	
	private static def Function3<BattleViewController, Pokemon, Ability, Boolean> getImmuneToAbilityFunction(Ability abilityToShow, String abilityDaoName) {
		return [ battleViewController, pokemon, ability | 
			if (ability.abilityDaoName == abilityDaoName) {
				battleViewController.showAbility(pokemon, abilityToShow)
				return true
			}
			
			return false
		]
	}
	
	private static def isSunny(Weather weather) {
		return weather !== null && weather.isHarshSunlight()
	}
	
	private static def Function4<BattleViewController, Pokemon, Move, Pokemon, Double> getAuraDamageModifierFunction(Type type) {
		return [ battleViewController, user, move, target |
			if (battleViewController.allActivePokemon.filter[alive].findFirst[pokemon | pokemon.ability.abilityDaoName == AURA_BREAK] !== null) {
				return 0.75
			}
			
			if (move.type == type) {
				return 1.33
			}
			
			return 1.0
		]
	}
	
	private static def Function5<BattleViewController, Pokemon, Move, Pokemon, Boolean, Boolean> getImmuneToPriorityMovesFunction(Ability ability) {
		return [ battleViewController, user, move, target, ignoreAbilities |
			if (ignoreAbilities) {
				return false
			}
			
			if (move.getPriority(user) > 0) {
				battleViewController.showAbility(target, ability)
				return true
			}
			
			return false
		]
	}
	
	private static def boolean isContactMove(Pokemon user, Move move) {
		return move.contact && user.ability.abilityDaoName != LONG_REACH
	}
	
	private static def String getUnnerveMessage(boolean isPlayer) {
		if (isPlayer) {
			return "The opposing team is too nervous to eat Berries"
		} else {
			return "Your team is too nerous to eat Berries"
		}
	}
}