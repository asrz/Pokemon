package asrz.Pokemon.model.enums;

import static asrz.Pokemon.model.enums.ItemPocket.*;

public enum ItemCategory {
	
	STAT_BOOSTS("stat-boosts", BATTLE),
	EFFORT_DROP("effort-drop", BERRIES),
	MEDICINE("medicine", BERRIES),
	OTHER("other", BERRIES),
	IN_A_PINCH("in-a-pinch", BERRIES),
	PICKY_HEALING("picky-healing", BERRIES),
	TYPE_PROTECTION("type-protection", BERRIES),
	BAKING_ONLY("baking-only", BERRIES),
	COLLECTIBLES("collectibles", MISC),
	EVOLUTION("evolution", MISC),
	SPELUNKING("spelunking", MISC),
	HELD_ITEMS("held-items", MISC),
	CHOICE("choice", MISC),
	EFFORT_TRAINING("effort-training", MISC),
	BAD_HELD_ITEMS("bad-held-items", MISC),
	TRAINING("training", MISC),
	PLATES("plates", MISC),
	SPECIES_SPECIFIC("species-specific", MISC),
	TYPE_ENHANCEMENT("type-enhancement", MISC),
	EVENT_ITEMS("event-items", KEY),
	GAMEPLAY("gameplay", KEY),
	PLOT_ADVANCEMENT("plot-advancement", KEY),
	UNUSED("unused", KEY),
	LOOT("loot", MISC),
	ALL_MAIL("all-mail", MAIL),
	VITAMINS("vitamins", ItemPocket.MEDICINE),
	HEALING("healing", ItemPocket.MEDICINE),
	PP_RECOVERY("pp-recovery", ItemPocket.MEDICINE),
	REVIVAL("revival", ItemPocket.MEDICINE),
	STATUS_CURES("status-cures", ItemPocket.MEDICINE),
	MULCH("mulch", MISC),
	SPECIAL_BALLS("special-balls", POKEBALLS),
	STANDARD_BALLS("standard-balls", POKEBALLS),
	DEX_COMPLETION("dex-completion", MISC),
	SCARVES("scarves", MISC),
	ALL_MACHINES("all-machines", MACHINES),
	FLUTES("flutes", BATTLE),
	APRICORN_BALLS("apricorn-balls", POKEBALLS),
	APRICORN_BOX("apricorn-box", KEY),
	DATA_CARDS("data-cards", KEY),
	JEWELS("jewels", MISC),
	MIRACLE_SHOOTER("miracle-shooter", BATTLE),
	MEGA_STONES("mega-stones", MISC),
	MEMORIES("memories", MISC),
	Z_CRYSTALS("z-crystals", KEY),
	SPECIES_CANDIES("species-candies", MISC),
	CATCHING_BONUS("catching-bonus", BERRIES),
	DYNAMAX_CRYSTALS("dynamax-crystals", MISC),
	NATURE_MINTS("nature-mints", ItemPocket.MEDICINE),
	CURRY_INGREDIENTS("curry-ingredients", MISC),
	TERA_SHARD("tera-shard", MISC),
	SANDWICH_INGREDIENTS("sandwich-ingredients", MISC),
	TM_MATERIALS("tm-materials", MISC),
	PICNIC("picnic", MISC),
	;
	
	String apiString;
	ItemPocket pocket;
	
	private ItemCategory(String apiString, ItemPocket pocket) {
		this.apiString = apiString;
		this.pocket = pocket;
	}
	
	public ItemPocket getPocket() { return pocket; }
	
	public static ItemCategory fromApiString(String apiString) {
		for (ItemCategory itemCategory : values()) {
			if (itemCategory.apiString.equals(apiString)) {
				return itemCategory;
			}
		}
		
		throw new RuntimeException("Unexpected ItemCategory: " + apiString);
	}
}
