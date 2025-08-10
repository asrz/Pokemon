package asrz.Pokemon.model.enums;

import asrz.Pokemon.model.enums.Gender;
import asrz.Pokemon.util.Util;

public enum Gender {
	MALE("Male", "♂"),
	FEMALE("Female", "♀"),
	GENDERLESS("Genderless", ""),
	;
	
	private String label;
	private String symbol;
	
	private Gender(String label, String symbol) {
		this.label = label;
		this.symbol = symbol;
	}
	
	public String getLabel() { return label; }
	public String getSymbol() { return symbol; }

	
	public static Gender randomGender(int genderRate) {
		if (genderRate < 0) {
			return GENDERLESS;
		} else if (genderRate == 0) {
			return MALE;
		} else if (genderRate == 8) {
			return FEMALE;
		}
		
		
		return Util.randomInt(1, 8) <= genderRate ? FEMALE : MALE;
	}
}
