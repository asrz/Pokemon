package asrz.Pokemon.model.enums;

import asrz.Pokemon.util.Util;

public enum EggGroup {
	BUG("bug"),
	DITTO("ditto"),
	DRAGON("dragon"),
	FAIRY("fairy"),
	FLYING("flying"),
	GROUND("ground"),
	HUMAN_SHAPE("human_shape"),
	INDETERMINATE("indeterminate"),
	MINERAL("mineral"),
	MONSTER("monster"),
	PLANT("plant"),
	WATER_1("water1"),
	WATER_2("water2"),
	WATER_3("water3"),
	
	NO_EGGS("no-eggs")
	;
	
	private String apiString;
	
	private EggGroup(String apiString) {
		this.apiString = apiString;
	}
	
	public EggGroup fromApiString(String apiString) {
		for (EggGroup eggGroup : values()) {
			if (Util.equals(eggGroup.apiString, apiString)) {
				return eggGroup;
			}
		}
		
		return null;
	}
}
