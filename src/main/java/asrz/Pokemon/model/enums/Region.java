package asrz.Pokemon.model.enums;

import asrz.Pokemon.model.interfaces.ILabeled;

public enum Region implements ILabeled {
	KANTO("Kanto", "kanto", 1),
	JOHTO("Johto", "johto", 2),
	HOENN("Hoenn", "hoenn", 3),
	SINNOH("Sinnoh", "sinnoh", 4),
	UNOVA("Unova", "unova", 5),
	KALOS("Kalos", "kalos", 6),
	ALOLA("Alola", "alola", 7),
	GALAR("Galar", "galar", 8),
	PALDEA("Paldea", "paldea", 9),
	
	ORRE("Orre", "orre"),
	HISUI("Hisui", "hisui"),
	;
	
	private String label;
	private String apiLabel;
	private Integer generation;
	
	private Region(String label, String apiLabel, Integer generation) {
		this.label = label;
		this.apiLabel = apiLabel;
		this.generation = generation;
	}
		
	
	private Region(String label, String apiLabel) {
		this(label, apiLabel, null);
	}
	
	public String getLabel() { return label; }
	public String getApiLabel() { return apiLabel; }
	public Integer getGeneration() { return generation; }
	
	
	public static Region fromApiString(String apiString) {
		for (Region region : values()) {
			if (region.apiLabel.equals(apiString)) {
				return region;
			}
		}
		
		return null;
	}

	public static Region fromLabel(String label) {
		for (Region region : values()) {
			if (region.label.equals(label)) {
				return region;
			}
		}
		
		return null;
	}
}
