package asrz.Pokemon.model.enums;

import asrz.Pokemon.model.Pokemon;

public enum StatusAilment {

	UNKNOWN("unknown"),
	PARALYSIS("paralysis", false),
	SLEEP("sleep", false),
	FREEZE("freeze", false),
	BURN("burn", false),
	POISON("poison", false),
	CONFUSION("confusion"),
	INFATUATION("infatuation"),
	TRAP("trap"),
	NIGHTMARE("nightmare"),
	TORMENT("torment"),
	DISABLE("disable"),
	YAWN("yawn"),
	HEAL_BLOCK("heal_block"),
	NO_TYPE_IMMUNITY("no-type-immunity"),
	LEECH_SEED("leech-seed"),
	EMBARGO("embargo"),
	PERISH_SONG("perish-song"),
	INGRAIN("ingrain"),
	SILENCE("silence"),
	TAR_SHOT("tar_shot"),
	FLINCH("flinch"),
	;
	
	private String apiLabel;
	private boolean volatileAilment;
	
	private StatusAilment(String apiLabel) {
		this(apiLabel, true);
	}
	private StatusAilment(String apiLabel, boolean volatileAilment) {
		this.apiLabel = apiLabel;
		this.volatileAilment = volatileAilment;
	}
	
	public boolean isVolatile() { return volatileAilment; }
	public String getApiLabel() { return apiLabel; }
	
	
	public static StatusAilment fromApiString(String apiString) {
		if (apiString == null) {
			return null;
		}
		
		for (StatusAilment ailment : values()) {
			if (ailment.apiLabel.equals(apiString)) {
				return ailment;
			}
		}
		
		return null;
	}
	
	public String getMessage(Pokemon pokemon, Pokemon inflicter) {
		switch(this) {
			case SLEEP: return String.format("%s has been put to sleep", pokemon.getLabel());
			case PARALYSIS: return String.format("%s has been paralyzed", pokemon.getLabel());
			case FREEZE: return String.format("%s has been frozen solid", pokemon.getLabel());
			case BURN: return String.format("%s has been burnt", pokemon.getLabel());
			case POISON: return String.format("%s has been poisoned", pokemon.getLabel());
			case CONFUSION: return String.format("%s is now confused", pokemon.getLabel());
			case INFATUATION: return String.format("%s is in love with %s", pokemon.getLabel(), inflicter.getLabel());
			case LEECH_SEED: return String.format("%s has been seeded by %s", pokemon.getLabel(), inflicter.getLabel());
			default: throw new RuntimeException("Unhandled StatusAilment: " + name());
		}
	}
}
