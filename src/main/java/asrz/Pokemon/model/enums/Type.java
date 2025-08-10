package asrz.Pokemon.model.enums;

import java.util.List;

import asrz.Pokemon.util.Util;

public enum Type {
	
	//pre-gen 4 physical
	NORMAL("Normal"),
	FIGHTING("Fighting"),
	FLYING("Flying"),
	POISON("Poison"),
	GROUND("Ground"),
	ROCK("Rock"),
	BUG("Bug"),
	GHOST("Ghost"),
	STEEL("Steel"),
	
	//pre-gen 4 special
	FIRE("Fire"),
	WATER("Water"),
	GRASS("Grass"),
	ELECTRIC("Electric"),
	PSYCHIC("Psychic"),
	ICE("Ice"),
	DRAGON("Dragon"),
	DARK("Dark"),
	FAIRY("Fairy"),
	
	//weird types
	UNKNOWN("???"),
	STELLAR("Stellar"),
	SHADOW("Shadow"),
	;
	
	private String label;
	
	
	private Type(String label) {
		this.label = label;
	}
	
	
	public String getLabel() { return label; }
	
	
	public List<Type> standardTypes() {
		List<Type> allTypes = Util.list(values());
		allTypes.remove(UNKNOWN);
		allTypes.remove(STELLAR);
		allTypes.remove(SHADOW);
		
		return allTypes;
	}

	public static Type fromAPI(String typeString) {
		if (typeString == null) {
			return null;
		}
		
		for (Type type : values()) {
			if (type.getLabel().equalsIgnoreCase(typeString)) {
				return type;
			}
		}
		
		return null;
	}
	
	public boolean isImmuneTo(Type other) {
		switch(this) {
			case DARK: return other == PSYCHIC;
			case FAIRY: return other == DRAGON;
			case FLYING: return other == GROUND;
			case GHOST: return other == NORMAL || other == FIGHTING;
			case GROUND: return other == ELECTRIC;
			case NORMAL: return other == GHOST;
			case STEEL: return other == POISON;
			default: return false;
		}
	}
	
	public boolean isResistantTo(Type other) {
		switch(this) {
			case BUG: return Util.list(FIGHTING, GROUND, GRASS).contains(other);
			case DARK: return Util.list(GHOST, DARK).contains(other);
			case DRAGON: return Util.list(FIRE, WATER, GRASS, ELECTRIC).contains(other);
			case ELECTRIC: return Util.list(FLYING, STEEL, ELECTRIC).contains(other);
			case FAIRY: return Util.list(FIGHTING, BUG, DARK).contains(other);
			case FIGHTING: return Util.list(ROCK, BUG, DARK).contains(other);
			case FIRE: return Util.list(BUG, STEEL, FIRE, GRASS, ICE, FAIRY).contains(other);
			case FLYING: return Util.list(FIGHTING, BUG, GRASS).contains(other);
			case GHOST: return Util.list(POISON, BUG).contains(other);
			case GRASS: return Util.list(GROUND, WATER, GRASS, ELECTRIC).contains(other);
			case GROUND: return Util.list(POISON, ROCK).contains(other);
			case ICE: return ICE == other;
			case POISON: return Util.list(FIGHTING, POISON, BUG, GRASS, FAIRY).contains(other);
			case PSYCHIC: return Util.list(FIGHTING, PSYCHIC).contains(other);
			case ROCK: return Util.list(NORMAL, FLYING, POISON, FIRE).contains(other);
			case STEEL: return Util.list(NORMAL, FLYING, ROCK, BUG, STEEL, GRASS, PSYCHIC, ICE, DRAGON, FAIRY).contains(other);
			case WATER: return Util.list(STEEL, FIRE, WATER, ICE).contains(other);
			default: return false;
		}
	}
	
	public boolean isWeakTo(Type other) {
		switch(this) {
			case BUG: return Util.list(FLYING, ROCK, FIRE).contains(other);
			case DARK: return Util.list(FIGHTING, BUG, FAIRY).contains(other);
			case DRAGON: return Util.list(ICE, DRAGON, FAIRY).contains(other);
			case ELECTRIC: return GROUND == other;
			case FAIRY: return Util.list(POISON, STEEL).contains(other);
			case FIGHTING: return Util.list(FLYING, PSYCHIC, FAIRY).contains(other);
			case FIRE: return Util.list(GROUND, ROCK, WATER).contains(other);
			case FLYING: return Util.list(ROCK, ELECTRIC, ICE).contains(other);
			case GHOST: return Util.list(GHOST, DARK).contains(other);
			case GRASS: return Util.list(FLYING, POISON, BUG, FIRE, ICE).contains(other);
			case GROUND: return Util.list(WATER, GRASS, ICE).contains(other);
			case ICE: return Util.list(FIGHTING, ROCK, STEEL, FIRE).contains(other);
			case NORMAL: return FIGHTING == other;
			case POISON: return Util.list(GROUND, PSYCHIC).contains(other); 
			case PSYCHIC: return Util.list(BUG, GHOST, DARK).contains(other);
			case ROCK: return Util.list(FIGHTING, GROUND, STEEL, WATER, GRASS).contains(other);
			case STEEL: return Util.list(FIGHTING, GROUND, FIRE).contains(other);
			case WATER: return Util.list(GRASS, ELECTRIC).contains(other);
			default: return false;
		}
	}
	
	public boolean isImmuneTo(StatusAilment ailment) {
		switch(ailment) {
			case BURN: return this == FIRE;
			case FREEZE: return this == ICE;
			case PARALYSIS: return this == ELECTRIC;
			case POISON: return List.of(STEEL, POISON).contains(this);
			case LEECH_SEED: return this == GRASS;
			default: return false;
		}
	}
}
