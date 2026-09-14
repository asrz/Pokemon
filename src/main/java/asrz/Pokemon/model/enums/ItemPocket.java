package asrz.Pokemon.model.enums;

import asrz.Pokemon.model.enums.ItemPocket;

public enum ItemPocket {
	MISC("Misc", "misc"),
	MEDICINE("Medicine", "medicine"),
	POKEBALLS("Pokéballs", "pokeballs"),
	MACHINES("Machines", "machines"),
	BERRIES("Berries", "berries"),
	MAIL("Mail", "mail"),
	BATTLE("Battle", "battle"),
	KEY("Key", "key"),
	
	MEGA_STONES("Mega Stones"),
	Z_CRYSTALS("Z-Crystals"),
	GEMS("Gems"),
	PLATES("Plates"),
	TYPE_BOOSTERS("Type Boosters"),
	STAT_CHANGING("Stat Changing"),
	EVOLUTION("Evolution"),
	TM_MATERIALS("TM Materials"),
	MEMORIES("Memories"),
	SPECIES_CANDIES("Species Candies"),
	TERA_SHARDS("Tera Shards"),
	;
	
	String label;
	String apiString;
	
	private ItemPocket(String label) {
		this(label, null);
	}
	
	private ItemPocket(String label, String apiString) {
		this.label = label;
		this.apiString = apiString;
	}
	
	public String getLabel() { return label; }
	public String getApiString() { return apiString; }
	
	public static ItemPocket fromApiString(String apiString) {
		for (ItemPocket itemPocket : values()) {
			if (itemPocket.apiString.equals(apiString)) {
				return itemPocket;
			}
		}
		
		return null;
	}

	public static ItemPocket fromString(String string) {
		for (ItemPocket itemPocket : values()) {
			if (itemPocket.name().equals(string)) {
				return itemPocket;
			}
		}
		
		return null;
	}
}
