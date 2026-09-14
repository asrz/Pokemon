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
	
	public boolean isRain() {
		return Util.in(RAIN, HEAVY_RAIN);
	}
	
	public boolean isHarshSunlight() {
		return Util.in(HARSH_SUNLIGHT, EXTREMELY_HARSH_SUNLIGHT);
	}
	
	public String getCreationMessage() {
		switch(this) {
			case EXTREMELY_HARSH_SUNLIGHT: return "The sunlight turned extremely harsh";
			case HARSH_SUNLIGHT: return "The sunlight turned harsh";
			case HEAVY_RAIN: return "A heavy rain began to fall";
			case RAIN: return "It started to rain";
			case SANDSTORM: return "A sandstorm kicked up";
			case SNOW: return "It started to snow";
			case STRONG_WINDS: return "Mysterious strong winds are protecting Flying-type Pokémon";
			default: throw new RuntimeException("Unknown weather: " + name());
		}
	}
	
	public String getEndingMessage() {
		switch(this) {
			case EXTREMELY_HARSH_SUNLIGHT:
			case HARSH_SUNLIGHT: return "The harsh sunlight faded";
			case HEAVY_RAIN: return "The heavy rain has lifted";
			case RAIN: return "The rain stopped";
			case SANDSTORM: return "The standstorm subsided";
			case SNOW: return "The snow stopped";
			case STRONG_WINDS: return "The mysterious strong winds have dissipated";
			default: throw new RuntimeException("Unknown weather: " + name());
		}
	}
}
