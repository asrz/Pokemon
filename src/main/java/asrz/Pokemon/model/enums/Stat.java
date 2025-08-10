package asrz.Pokemon.model.enums;

import java.util.List;

import asrz.Pokemon.util.Util;
import asrz.Pokemon.model.enums.Stat;

public enum Stat {
	
	HP("HP", "hp"),
	
	ATTACK("Attack", "attack"),
	DEFENSE("Defense", "defense"),
	SPECIAL_ATTACK("Spc. Att.", "special-attack"),
	SPECIAL_DEFENSE("Spc. Def.", "special-defense"),
	SPEED("Speed", "speed"),
	
	ACCURACY("Accuracy", "accuracy"),
	EVASION("Evasion", "evasion"),
	CRIT_RATE("Critical Hit Rate", null)
	;
	
	String label;
	String apiLabel;
	
	Stat(String label, String apiLabel) {
		this.label = label;
		this.apiLabel = apiLabel;
	}
	
	public String getLabel() { return label; }
	public String getApiLabel() { return apiLabel; }

	public static List<Stat> getGetPermanentStats() {
		return Util.list(HP, ATTACK, DEFENSE, SPECIAL_ATTACK, SPECIAL_DEFENSE, SPEED);
	}
	
	public static Stat fromApiString(String apiString) {
		if (apiString == null) {
			return null;
		}
		
		for (Stat stat : values()) {
			if (apiString.equals(stat.apiLabel)) {
				return stat;
			}
		}
		
		return null;
	}

	public static Stat fromString(String string) {
		for (Stat stat : values()) {
			if (string.equals(stat.name())) {
				return stat;
			}
		}
		
		return null;
	}
}
