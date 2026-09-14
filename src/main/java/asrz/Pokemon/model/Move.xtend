package asrz.Pokemon.model

import asrz.Pokemon.model.enums.MoveCategory
import asrz.Pokemon.model.enums.MoveDamageClass
import asrz.Pokemon.model.enums.MoveTarget
import asrz.Pokemon.model.enums.Stat
import asrz.Pokemon.model.enums.StatusAilment
import asrz.Pokemon.model.enums.Type
import asrz.Pokemon.model.interfaces.ILabeled
import asrz.Pokemon.pokeAPI.model.moves.MoveDAO
import asrz.Pokemon.pokeAPI.model.utility.VerboseEffectDAO
import java.util.Map
import javafx.beans.binding.Bindings
import javafx.beans.binding.StringBinding
import org.bson.codecs.pojo.annotations.BsonIgnore
import xtendfx.beans.FXBindable
import asrz.Pokemon.util.Util

@FXBindable
class Move implements ILabeled {

	Integer moveDaoId
	@BsonIgnore
	String moveDaoName

	@BsonIgnore
	String name
	@BsonIgnore
	String description
	
	@BsonIgnore
	Type type
	@BsonIgnore
	MoveCategory category
	@BsonIgnore
	MoveTarget target
	@BsonIgnore
	MoveDamageClass damageClass
	@BsonIgnore
	Integer power
	@BsonIgnore
	Integer accuracy
	@BsonIgnore
	int maxPP
	@BsonIgnore
	int pp
	
	@BsonIgnore
	Integer effectChance
	@BsonIgnore
	int priority
	@BsonIgnore
	VerboseEffectDAO moveEffect
	@BsonIgnore
	ObservableStatMap statChanges = new ObservableStatMap
	
	@BsonIgnore
	StatusAilment statusAilment
	@BsonIgnore
	Integer minHits
	@BsonIgnore
	Integer maxHits
	@BsonIgnore
	Integer minTurns
	@BsonIgnore
	Integer maxTurns
	@BsonIgnore
	Integer drain //drain if positive, recoil damage if negative (% of damage done)
	@BsonIgnore
	Integer healing //% of maximum hp
	@BsonIgnore
	Integer critRateBonus
	@BsonIgnore
	Integer ailmentChance
	@BsonIgnore
	Integer flinchChance
	@BsonIgnore
	Integer statChance
	
	@BsonIgnore
	StringBinding ppLabelProperty
	
	
	
	new() {}
	
	def static fromApi(MoveDAO moveDAO, String languageName) {
		return new Move() => [
			moveDaoId = moveDAO.id
			moveDaoName = moveDAO.name
			name = moveDAO.names.findFirst[language.name == languageName].name
			description = moveDAO.flavorTextEntries.filter[language.name == languageName].reject[flavorText.startsWith("This move can't be used")].lastOrNull?.flavorText
			type = Type.fromAPI(moveDAO.type.name)
			target = MoveTarget.fromApiString(moveDAO.target.name)
			damageClass = MoveDamageClass.fromApiString(moveDAO.damageClass.name)
			category = MoveCategory.fromApiString(moveDAO.meta?.category?.name)
			
			power = moveDAO.power
			maxPP = moveDAO.pp
			pp = maxPP
			accuracy = moveDAO.accuracy
			effectChance = moveDAO.effectChance
			priority = moveDAO.priority
			moveEffect = moveDAO.effectEntries.findFirst[language == languageName]
			statChanges.putAll(moveDAO.statChanges.toMap([Stat.fromApiString(stat.name)], [change]))
			
			statusAilment = StatusAilment.fromApiString(moveDAO.meta?.ailment?.name)
			minHits = moveDAO.meta?.minHits
			maxHits = moveDAO.meta?.maxHits
			minTurns = moveDAO.meta?.minTurns
			maxTurns = moveDAO.meta?.maxTurns
			drain = moveDAO.meta?.drain
			healing = moveDAO.meta?.healing
			critRateBonus = moveDAO.meta?.critRate
			ailmentChance = moveDAO.meta?.ailmentChance
			flinchChance = moveDAO.meta?.flinchChance
			statChance = moveDAO.meta?.statChance
			
			ppLabelProperty = createPpLabel()
		]
	}
	
	def createPpLabel() {
		return Bindings.createStringBinding([
			return  pp + "/" + getMaxPP()
		], ppProperty(), maxPPProperty());
	}
	
	override equals(Object obj) {
		if (!(obj instanceof Move)) {
			return false
		}
		
		return name.equals((obj as Move).name)
	}
	
	@BsonIgnore
	override String getLabel() {
		return name
	}
	
	@BsonIgnore
	def boolean isPhysical() {
		return damageClass == MoveDamageClass.PHYSICAL
	}
	
	@BsonIgnore
	def boolean isSpecial() {
		return damageClass == MoveDamageClass.SPECIAL
	}
	
	@BsonIgnore
	def boolean isStatus() {
		return damageClass == MoveDamageClass.STATUS
	}
	
	def getPriority(Pokemon user) {
		if (user.ability.abilityDaoName == Abilities.PRANKSTER && status) {
			return priority + 1
		} else if (user.ability.abilityDaoName == Abilities.GALE_WINGS && type == Type.FLYING && user.hp == user.maxHp) {
			return priority + 1
		} else if (user.ability.abilityDaoName == Abilities.TRIAGE && Util.in(moveDaoName, Moves.TRIAGE_MOVES)) {
			return  priority + 3
		}
		
		return priority
	}
	
	def boolean isContact() {
		return Util.in(moveDaoName, Moves.CONTACT_MOVES)
	}
}

class Moves {
	public static final String STRUGGLE = "struggle"
	
	public static final String[] CONTACT_MOVES = #[
		"accelerock", "acrobatics", "aerial-ace", "anchor-shot", "aqua-jet", "aqua-step", "aqua-tail", "arm-thrust", "assurance", 
		"astonish", "avalanche", "axe-kick", "behemoth-bash", "behemoth-blade", "bide", "bind", "bite", "bitter-blade", "blaze-kick", 
		"body-press", "body-slam", "bolt-beak", "bolt-strike", "bounce", "branch-poke", "brave-bird", "breaking-swipe", "brick-break", 
		"brutal-swing", "bug-bite", "bullet-punch", "catastropika", "ceaseless-edge", "chip-away", "circle-throw", "clamp", "close-combat", 
		"collision-course", "comet-punch", "comeuppance", "constrict", "counter", "covet", "crabhammer", "cross-chop", "cross-poison", "crunch", 
		"crush-claw", "crush-grip", "cut", "darkest-lariat", "dig", "dire-claw", "dive", "dizzy-punch", "double-edge", "double-hit", 
		"double-iron-bash", "double-kick", "double-shock", "double-slap", "dragon-ascent", "dragon-claw", "dragon-hammer", "dragon-rush", 
		"dragon-tail", "drain-punch", "draining-kiss", "drill-peck", "drill-run", "dual-chop", "dual-wingbeat", "dynamic-punch", "electro-drift", 
		"endeavor", "extreme-speed", "facade", "fake-out", "false-surrender", "false-swipe", "feint-attack", "fell-stinger", "fire-fang", 
		"fire-lash", "fire-punch", "first-impression", "fishious-rend", "flail", "flame-charge", "flame-wheel", "flare-blitz", "flip-turn", 
		"floaty-fall", "fly", "flying-press", "focus-punch", "force-palm", "foul-play", "frustration", "fury-attack", "fury-cutter", "fury-swipes", 
		"gear-grind", "giga-impact", "glaive-rush", "grass-knot", "grassy-glide", "guillotine", "gyro-ball", "hammer-arm", "hard-press", 
		"head-charge", "head-smash", "headbutt", "headlong-rush", "heart-stamp", "heat-crash", "heavy-slam", "high-horsepower", "high-jump-kick", 
		"hold-back", "horn-attack", "horn-drill", "horn-leech", "hyper-drill", "hyper-fang", "ice-ball", "ice-fang", "ice-hammer", "ice-punch", 
		"ice-spinner", "infestation", "iron-head", "iron-tail", "jaw-lock", "jet-punch", "jump-kick", "karate-chop", "knock-off", "kowtow-cleave", 
		"lash-out", "last-resort", "leaf-blade", "leech-life", "let's-snuggle-forever", "lick", "liquidation", "low-kick", "low-sweep", "lunge", 
		"mach-punch", "malicious-moonsault", "mega-kick", "mega-punch", "megahorn", "metal-claw", "meteor-mash", "mighty-cleave", "mortal-spin", 
		"multi-attack", "needle-arm", "night-slash", "nuzzle", "outrage", "payback", "peck", "petal-dance", "phantom-force", "plasma-fists", 
		"play-rough", "pluck", "poison-fang", "poison-jab", "poison-tail", "population-bomb", "pounce", "pound", "power-trip", "power-up-punch", 
		"power-whip", "psyblade", "psychic-fangs", "psyshield-bash", "pulverizing-pancake", "punishment", "pursuit", "quick-attack", "rage", 
		"rage-fist", "raging-bull", "rapid-spin", "razor-shell", "retaliate", "return", "revenge", "reversal", "rock-climb", "rock-smash", 
		"rolling-kick", "rollout", "sacred-sword", "scratch", "searing-sunraze-smash", "seismic-toss", "shadow-blitz", "shadow-break", "shadow-claw", 
		"shadow-end", "shadow-force", "shadow-punch", "shadow-rush", "shadow-sneak", "sizzly-slide", "skitter-smack", "skull-bash", "sky-drop", 
		"sky-uppercut", "slam", "slash", "smart-strike", "smelling-salts", "snap-trap", "solar-blade", "soul-stealing-7-star-strike", "spark", 
		"spectral-thief", "spin-out", "spirit-break", "steamroller", "steel-roller", "steel-wing", "stomp", "stomping-tantrum", "stone-axe", 
		"storm-throw", "strength", "struggle", "submission", "sucker-punch", "sunsteel-strike", "super-fang", "supercell-slam", "superpower", 
		"surging-strikes", "tackle", "tail-slap", "take-down", "temper-flare", "thief", "thrash", "throat-chop", "thunder-fang", "thunder-punch", 
		"thunderous-kick", "trailblaze", "triple-axel", "triple-dive", "triple-kick", "trop-kick", "trump-card", "u-turn", "upper-hand", "v-create", 
		"veevee-volley", "vine-whip", "vise-grip", "vital-throw", "volt-tackle", "wake-up-slap", "waterfall", "wave-crash", "wicked-blow", 
		"wild-charge", "wing-attack", "wood-hammer", "wrap", "wring-out", "x-scissor", "zen-headbutt", "zing-zap", "zippy-zap"
	]
		
	public static final String[] SOUND_BASED_MOVES = #[
		"alluring-voice", "boomburst", "bug-buzz", "chatter", "clanging-scales", "clangorous-soul", "clangorous-soulblaze", "confide", 
		"disarming-voice", "echoed-voice", "eerie-spell", "grass-whistle", "growl", "heal-bell", "howl", "hyper-voice", "metal-sound", 
		"noble-roar", "overdrive", "parting-shot", "perish-song", "psychic-noise", "relic-song", "roar", "round", "screech", "shadow-panic", 
		"sing", "snarl", "snore", "sparkling-aria", "supersonic", "torch-song", "uproar"
	]
	
	public static final String[] PUNCHING_MOVES = #[
		"bullet-punch", "comet-punch", "dizzy-punch", "double-iron-bash", "drain-punch", "dynamic-punch", "fire-punch", "focus-punch", 
		"hammer-arm", "ice-hammer", "ice-punch", "mach-punch", "mega-punch", "power-up-punch", "shadow-punch", "sky-uppercut", "thunder-punch", 
		"headlong-rush", "jet-punch", "meteor-mash", "plasma-fists", "rage-fist", "surging-strikes", "wicked-blow"
	]
	
	public static final String[] MULTISTRIKE_MOVES = #[
		"arm-thrust", "bullet-seed", "double-slap", "fury-attack", "fury-swipes", "icicle-spear", "pin-missle", "rock-blast", "spike-cannon", 
		"tail-slap", "triple-axel", "barrage", "bone-rush", "comet-punch", "population-bomb", "scale-shot", "triple-kick", "water-shuriken"
	]
	
	public static final String[] IGNORE_ABILITIES = #[
		"sunsteel-strike", "moongeist-beam", "photon-geyser", 
		"searing-sunraze-smash", "menacing-moonraze-maelstrom", "light-that-burns-the-sky",
		"g-max-drum-solo", "g-max-fireball", "g-max-hydrosnipe" //not in pokeapi?
	]
	
	public static final String[] RECKLESS_MOVES = #[
		"axe-kick", "brave-bird", "double-edge", "flare-blitz", "head-charge", "head-smash", "high-jump-kick", "jump-kick",
		"submission", "supercell-slam", "take-down", "wave-crash", "wild-charge", "light-of-ruin", "volt-tackle", "wood-hammer"
	]
	
	public static final String[] SHEER_FORCE_MOVES = #[
		"acid", "acid-spray", "air-slash", "alluring-voice", "anchor-shot", "ancient-power", "apple-acid", "aqua-step", "astonish", 
		"aura-wheel", "aurora-beam", "axe-kick", "barb-barrage", "bite", "bitter-malice", "blaze-kick", "blazing-torque", 
		"bleakwind-storm", "blizzard", "blue-flare", "body-slam", "bolt-strike", "bone-club", "bounce", "breaking-swipe", "bubble", 
		"bubble-beam", "bug-buzz", "bulldoze", "burning-jealousy", "buzzy-buzz", "ceaseless-edge", "charge-beam", "chatter", 
		"chilling-water", "clangorous-soulblaze", "combat-torque", "confusion", "constrict", "cross-poison", "crunch", "crush-claw", 
		"dark-pulse", "diamond-storm", "dire-claw", "discharge", "dizzy-punch", "double-iron-bash", "dragon-breath", "dragon-rush", 
		"drum-beating", "dynamic-punch", "earth-power", "eerie-spell", "electro-shot", "electroweb", "ember", "energy-ball", "esper-wing", 
		"extrasensory", "fake-out", "fiery-dance", "fiery-wrath", "fire-blast", "fire-fang", "fire-lash", "fire-punch", "flame-charge", 
		"flame-wheel", "flamethrower", "flare-blitz", "flash-cannon", "floaty-fall", "focus-blast", "force-palm", "freeze-shock", 
		"freeze-dry", "freezing-glare", "genesis-supernova", "glaciate", "grav-apple", "gunk-shot", "headbutt", "heart-stamp", "heat-wave", 
		"hurricane", "hyper-fang", "ice-beam", "ice-burn", "ice-fang", "ice-punch", "icicle-crash", "icy-wind", "infernal-parade", 
		"inferno", "iron-head", "iron-tail", "lava-plume", "leaf-tornado", "lick", "liquidation", "low-sweep", "lumina-crash", "lunge", 
		"luster-purge", "magical-torque", "malignant-chain", "matcha-gotcha", "metal-claw", "meteor-mash", "mirror-shot", "mist-ball", 
		"moonblast", "mortal-spin", "mountain-gale", "mud-bomb", "mud-shot", "mud-slap", "muddy-water", "mystical-fire", "mystical-power", 
		"needle-arm", "night-daze", "noxious-torque", "nuzzle", "octazooka", "ominous-wind", "order-up", "play-rough", "poison-fang", 
		"poison-jab", "poison-sting", "poison-tail", "pounce", "powder-snow", "power-up-punch", "psybeam", "psychic", "psychic-noise",
		 "psyshield-bash", "pyro-ball", "rapid-spin", "razor-shell", "relic-song", "rock-climb", "rock-slide", "rock-smash", "rock-tomb", 
		 "rolling-kick", "sacred-fire", "salt-cure", "sandsear-storm", "scald", "scorching-sands", "searing-shot", "secret-power", 
		 "seed-flare", "shadow-ball", "shadow-bone", "shell-side-arm", "signal-beam", "silver-wind", "sizzly-slide", "skitter-smack", 
		 "sky-attack", "sludge", "sludge-bomb", "sludge-wave", "smog", "snarl", "snore", "spark", "sparkling-aria", "spirit-break", 
		 "spirit-shackle", "splishy-splash", "springtide-storm", "steam-eruption", "steamroller", "steel-wing", "stoked-sparksurfer", 
		 "stomp", "stone-axe", "strange-steam", "struggle-bug", "syrup-bomb", "throat-chop", "thunder", "thunder-fang", "thunder-punch", 
		 "thunder-shock", "thunderbolt", "thunderous-kick", "torch-song", "trailblaze", "tri-attack", "triple-arrows", "trop-kick", 
		 "twineedle", "twister", "upper-hand", "volt-tackle", "water-pulse", "waterfall", "wicked-torque", "wildbolt-storm", "zap-cannon", 
		 "zen-headbutt", "zing-zap"
	]
	
	public static final String[] DIRECT_DAMAGE_MOVES = #[
		"bide", "comuppance", "counter", "dragon-rage", "endeavor", "final-gambit", "guardian-of-alola", "metal-burst", "mirror-coat",
		"natures-madness", "night-shade", "psywave", "ruination", "seismic-toss", "shadow-half", "sonic-boom", "super-fang",
		"fissure", "guillotine", "horn-drill", "sheer-cold"
	]
	
	public static final String[] POWDER_MOVES = #[
		"poison-powder", "stun-spore", "sleep-powder", "spore", "cotton-spore", "rage-powder", "powder", "magic-powder"
	]
	
	public static final String[] MAGIC_BOUNCE_MOVES = #[
		"attract", "baby-doll-eyes", "block", "captivate", "charm", "confide", "confuse-ray", "corrosive-gas", "cotton-spore", 
		"dark-void", "defog", "disable", "eerie-impulse", "embargo", "encore", "entrainment", "fake-tears", "feather-dance", "flash", 
		"flatter", "floral-healing", "foresight", "forest's-curse", "gastro-acid", "glare", "grass-whistle", "growl", "heal-block", 
		"heal-pulse", "hypnosis", "kinesis", "leech-seed", "leer", "lovely-kiss", "magic-powder", "mean-look", "metal-sound", 
		"miracle-eye", "noble-roar", "odor-sleuth", "parting-shot", "play-nice", "poison-gas", "poison-powder", "powder", "purify", 
		"roar", "sand-attack", "scary-face", "screech", "simple-beam", "sing", "sleep-powder", "smokescreen", "soak", "spicy-extract",
		"spider-web", "spikes", "spite", "spore", "spotlight", "stealth-rock", "sticky-web", "strength-sap", "string-shot", "stun-spore", 
		"supersonic", "swagger", "sweet-kiss", "sweet-scent", "tail-whip", "tar-shot", "taunt", "tearful-look", "telekinesis", "thunder-wave", 
		"tickle", "topsy-turvy", "torment", "toxic", "toxic-spikes", "toxic-thread", "trick-or-treat", "venom-drench", "whirlwind", 
		"will-o-wisp", "worry-seed", "yawn"
	]
	
	public static final String[] BULLETPROOF_MOVES = #[
		"acid-spray", "aura-sphere", "barrage", "beak-blast", "bullet-seed", "egg-bomb", "electro-ball", "energy-ball", "focus-blast", 
		"gyro-ball", "ice-ball", "magnet-bomb", "mist-ball", "mud-bomb", "octazooka", "pollen-puff", "pyro-ball", "rock-blast", "rock-wrecker", 
		"searing-shot", "seed-bomb", "syrup-bomb", "shadow-ball", "sludge-bomb", "weather-ball", "zap-cannon"
	]
	
	public static final String[] BITING_MOVES = #[
		"bite", "crunch", "fire-fang", "fishious-rend", "hyper-fang", "ice-fang", "jaw-lock", "poison-fang", "psychic-fangs", "thunder-fang"
	]
	
	public static final String[] AURA_PULSE_MOVES = #[
		"water-pulse", "aura-sphere", "dark-pulse", "dragon-pulse", "heal-pulse", "origin-pulse", "terrain-pulse"
	]
	
	public static final String[] TRIAGE_MOVES = #[
		"absorb", "bitter-blade", "drain-punch", "draining-kiss", "dream-eater", "floral-healing", "giga-drain", "heal-order", "heal-pulse", 
		"healing-wish", "horn-leech", "leech-life", "lunar-blessing", "lunar-dance", "matcha-gotcha", "mega-drain", "milk-drink", "moonlight", 
		"morning-sun", "oblivion-wing", "parabolic-charge", "purify", "recover", "rest", "revival-blessing", "roost", "shore-up", "slack-off", 
		"soft-boiled", "strength-sap", "swallow", "synthesis", "wish"
	]
	
	public static final String[] DANCER_MOVES = #[
		"aqua-step", "clangorous-soul", "dragon-dance", "feather-dance", "fiery-dance", "lunar-dance", "petal-dance", "revelation-dance",
		"quiver-dance", "swords-dance", "teeter-dance", "victory-dance"
	]
	
	public static final String[] WIND_MOVES = #[
		"aeroblast", "air-cutter", "bleakwind-storm", "blizzard", "fairy-wind", "gust", "heat-wave", "hurricane", "icy-wind", "petal-blizzard", 
		"sandspear-storm", "sandstorm", "springtide-storm", "tailwind", "twister", "whirlwind", "wildbolt-storm"
	]

	public static final Map<String, Move> movesByMoveDaoName = #[
		new Move()
	].toMap[moveDaoName]
}