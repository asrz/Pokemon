package asrz.Pokemon.model.enums;

public enum MoveCategory {
	
	DAMAGE("damage"),
	AILMENT("ailment"),
	NET_GOOD_STATS("net-good-stats"),
	HEAL("heal"),
	DAMAGE_AILMENT("damage+ailment"),
	SWAGGER("swagger"),
	DAMAGE_LOWER("damage+lower"),
	DAMAGE_RAISE("damage+raise"),
	DAMAGE_HEAL("damage+heal"),
	OHKO("ohko"),
	WHOLE_FIELD_EFFECT("whole-field-effect"),
	FIELD_EFFECT("field-effect"),
	FORCE_SWITCH("force-switch"),
	UNIQUE("unique"),
	;
	
	private String apiString;
	
	private MoveCategory(String apiString) {
		this.apiString = apiString;
	}
	
	public String getApiString() { return apiString; }
	
	
	public static MoveCategory fromApiString(String apiString) {
		if (apiString == null) {
			return null;
		}
		
		for (MoveCategory category : values()) {
			if (category.apiString.equals(apiString)) {
				return category;
			}
		}
		
		throw new RuntimeException("Unknown MoveCategory apiString: " + apiString);
	}

}
