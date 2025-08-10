package asrz.Pokemon.model.enums;

public enum ItemAttribute {
	
	COUNTABLE("countable"),
	CONSUMABLE("consumable"),
	USABLE_OVERWORLD("usable-overworld"),
	USABLE_BATTLE("usable-in-battle"),
	HOLDABLE("holdable"),
	//HOLDABLE_PASSIVE("holdable-passive"),
	HOLDABLE_ACTIVE("holdable-active"),
	UNDERGROUND("underground"),
	;
	
	String apiString;
	
	private ItemAttribute(String apiString) {
		this.apiString = apiString;
	}
	
	public static ItemAttribute fromApiString(String apiString) {
		for (ItemAttribute itemAttribute : values()) {
			if (itemAttribute.apiString.equals(apiString)) {
				return itemAttribute;
			}
		}
		
		return null;
	}
}
