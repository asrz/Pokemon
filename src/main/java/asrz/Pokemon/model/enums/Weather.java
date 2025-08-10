package asrz.Pokemon.model.enums;

import asrz.Pokemon.util.Util;

public enum Weather {
	HARSH_SUNLIGHT("Harsh Sunlight"),
	RAIN("Rain"),
	SNOW("Snow"),
	SANDSTORM("Sandstorm"),
	
	EXTREMELY_HARSH_SUNLIGHT("Extremely Harsh Sunlight"),
	HEAVY_RAIN("Heavy Rain"),
	STRONG_WINDS("Strong Winds"),
	;
	
	private String label;
	
	private Weather(String label) {
		this.label = label;
	}
	
	public String getLabel() { return label; }
	
	public boolean isPrimordial() {
		return Util.in(this, EXTREMELY_HARSH_SUNLIGHT, HEAVY_RAIN, STRONG_WINDS);
	}
}
