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
import javafx.beans.binding.Bindings
import javafx.beans.binding.StringBinding
import org.bson.codecs.pojo.annotations.BsonIgnore
import xtendfx.beans.FXBindable

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
	StatusAilment ailment
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
	boolean contact
	
	@BsonIgnore
	StringBinding ppLabelProperty
	
	static final String[] CONTACT_MOVES = #[
			"Accelerock", "Acrobatics", "Aerial Ace", "Anchor Shot", "Aqua Jet", 
			"Aqua Step", "Aqua Tail", "Arm Thrust", "Assurance", "Astonish", "Avalanche", "Axe Kick", 
			"Behemoth Bash", "Behemoth Blade", "Bide", "Bind", "Bite", "Bitter Blade", "Blaze Kick", "Body Press", 
			"Body Slam", "Bolt Beak", "Bolt Strike", "Bounce", "Branch Poke", "Brave Bird", "Breaking Swipe", "Brick Break", 
			"Brutal Swing", "Bug Bite", "Bullet Punch", "Catastropika", "Ceaseless Edge", "Chip Away", "Circle Throw", 
			"Clamp", "Close Combat", "Collision Course", "Comet Punch", "Comeuppance", "Constrict", "Counter", "Covet", 
			"Crabhammer", "Cross Chop", "Cross Poison", "Crunch", "Crush Claw", "Crush Grip", "Cut", "Darkest Lariat", 
			"Dig", "Dire Claw", "Dive", "Dizzy Punch", "Double Hit", "Double Iron Bash", "Double Kick", "Double Shock", 
			"Double Slap", "Double-Edge", "Dragon Ascent", "Dragon Claw", "Dragon Hammer", "Dragon Rush", "Dragon Tail", 
			"Drain Punch", "Draining Kiss", "Drill Peck", "Drill Run", "Dual Chop", "Dual Wingbeat", "Dynamic Punch", 
			"Electro Drift", "Endeavor", "Extreme Speed", "Facade", "Fake Out", "False Surrender", "False Swipe", 
			"Feint Attack", "Fell Stinger", "Fire Fang", "Fire Lash", "Fire Punch", "First Impression", "Fishious Rend", 
			"Flail", "Flame Charge", "Flame Wheel", "Flare Blitz", "Flip Turn", "Floaty Fall", "Fly", "Flying Press", 
			"Focus Punch", "Force Palm", "Foul Play", "Frustration", "Fury Attack", "Fury Cutter", "Fury Swipes", "Gear Grind", 
			"Giga Impact", "Glaive Rush", "Grass Knot", "Grassy Glide", "Guillotine", "Gyro Ball", "Hammer Arm", "Hard Press", 
			"Head Charge", "Head Smash", "Headbutt", "Headlong Rush", "Heart Stamp", "Heat Crash", "Heavy Slam", 
			"High Horsepower", "High Jump Kick", "Hold Back", "Horn Attack", "Horn Drill", "Horn Leech", "Hyper Drill", 
			"Hyper Fang", "Ice Ball", "Ice Fang", "Ice Hammer", "Ice Punch", "Ice Spinner", "Infestation", "Iron Head", 
			"Iron Tail", "Jaw Lock", "Jet Punch", "Jump Kick", "Karate Chop", "Knock Off", "Kowtow Cleave", "Lash Out", 
			"Last Resort", "Leaf Blade", "Leech Life", "Let's Snuggle Forever", "Lick", "Liquidation", "Low Kick", "Low Sweep", 
			"Lunge", "Mach Punch", "Malicious Moonsault", "Mega Kick", "Mega Punch", "Megahorn", "Metal Claw", "Meteor Mash", 
			"Mighty Cleave", "Mortal Spin", "Multi-Attack", "Needle Arm", "Night Slash", "Nuzzle", "Outrage", "Payback", "Peck", 
			"Petal Dance", "Phantom Force", "Plasma Fists", "Play Rough", "Pluck", "Poison Fang", "Poison Jab", "Poison Tail", 
			"Population Bomb", "Pounce", "Pound", "Power Trip", "Power Whip", "Power-Up Punch", "Psyblade", "Psychic Fangs", 
			"Psyshield Bash", "Pulverizing Pancake", "Punishment", "Pursuit", "Quick Attack", "Rage", "Rage Fist", 
			"Raging Bull", "Rapid Spin", "Razor Shell", "Retaliate", "Return", "Revenge", "Reversal", "Rock Climb", 
			"Rock Smash", "Rolling Kick", "Rollout", "Sacred Sword", "Scratch", "Searing Sunraze Smash", "Seismic Toss", 
			"Shadow Claw", "Shadow Force", "Shadow Punch", "Shadow Sneak", "Sizzly Slide", "Skitter Smack", "Skull Bash", 
			"Sky Drop", "Sky Uppercut", "Slam", "Slash", "Smart Strike", "Smelling Salts", "Snap Trap", "Solar Blade", 
			"Soul-Stealing 7-Star Strike", "Spark", "Spectral Thief", "Spin Out", "Spirit Break", "Steamroller", "Steel Roller", 
			"Steel Wing", "Stomp", "Stomping Tantrum", "Stone Axe", "Storm Throw", "Strength", "Struggle", "Submission", 
			"Sucker Punch", "Sunsteel Strike", "Super Fang", "Supercell Slam", "Superpower", "Surging Strikes", "Tackle", 
			"Tail Slap", "Take Down", "Temper Flare", "Thief", "Thrash", "Throat Chop", "Thunder Fang", "Thunder Punch", 
			"Thunderous Kick", "Trailblaze", "Triple Axel", "Triple Dive", "Triple Kick", "Trop Kick", "Trump Card", "U-turn", 
			"Upper Hand", "V-create", "Veevee Volley", "Vine Whip", "Vise Grip", "Vital Throw", "Volt Tackle", "Wake-Up Slap", 
			"Waterfall", "Wave Crash", "Wicked Blow", "Wild Charge", "Wing Attack", "Wood Hammer", "Wrap", "Wring Out", 
			"X-Scissor", "Zen Headbutt", "Zing Zap", "Zippy Zap", "Shadow Blitz", "Shadow Break", "Shadow End", "Shadow Rush"
		]
	
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
			
			contact = CONTACT_MOVES.contains(moveDAO.names.findFirst[language.name == 'en'].name)
			
			power = moveDAO.power
			maxPP = moveDAO.pp
			pp = maxPP
			accuracy = moveDAO.accuracy
			effectChance = moveDAO.effectChance
			priority = moveDAO.priority
			moveEffect = moveDAO.effectEntries.findFirst[language == languageName]
			statChanges.putAll(moveDAO.statChanges.toMap([Stat.fromApiString(stat.name)], [change]))
			
			ailment = StatusAilment.fromApiString(moveDAO.meta?.ailment?.name)
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
	override getLabel() {
		return name
	}
	
}