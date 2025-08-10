package asrz.Pokemon.model.enums;

import asrz.Pokemon.model.interfaces.ILabeled;

public enum MoveLearnMethod implements ILabeled {
	LEVEL_UP("Level Up", "level-up"),
	EGG("Egg Move", "egg"),
	TUTOR("Move Tutor", "tutor"),
	MACHINE("TM/HM", "machine"),
	
	FORM_CHANGE("Form Change", "form-change"),
	
	STADIUM_SURFING_PIKACHU("Stadium Surfing Pikachu", "stadium-surfing-pikachu"),
	LIGHT_BALL_EGG("Light Ball Egg", "light-ball-egg"),
	COLOSSEUM_PURIFICATION("Colosseum Purification", "colosseum-purification"),
	XD_SHADOW("XD Shadow", "xd-shadow"),
	XD_PURIFICATION("XD Purification", "xd-purification"),
	ZYGARDE_CUBE("Zygarde Cube", "zygarde-cube"),
	;
	
	
	private String label;
	private String apiLabel;
	
	private MoveLearnMethod(String label, String apiLabel) {
		this.label = label;
		this.apiLabel = apiLabel;
	}
	
	public String getLabel() { return label; }
	public String getApiLabel() { return apiLabel; }
	
	public static MoveLearnMethod fromApiString(String apiString) {
		for (MoveLearnMethod method : values()) {
			if (method.getApiLabel().equals(apiString)) {
				return method;
			}
		}
		
		return null;
	}
}
