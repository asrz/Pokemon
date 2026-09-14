package asrz.Pokemon.model.enums;

import static asrz.Pokemon.model.enums.ItemPocket.*;

import java.util.List;

import asrz.Pokemon.util.Util;

public enum ItemCategory {
	
	STAT_BOOSTS("stat-boosts", BATTLE),
	MIRACLE_SHOOTER("miracle-shooter", BATTLE),
	FLUTES("flutes", BATTLE),
	
	EFFORT_DROP("effort-drop", BERRIES),
	MEDICINE("medicine", BERRIES),
	OTHER("other", BERRIES),
	IN_A_PINCH("in-a-pinch", BERRIES),
	PICKY_HEALING("picky-healing", BERRIES),
	TYPE_PROTECTION("type-protection", BERRIES),
	BAKING_ONLY("baking-only", BERRIES),
	CATCHING_BONUS("catching-bonus", BERRIES),
	
	EVOLUTION("evolution", ItemPocket.EVOLUTION),
	
	EVENT_ITEMS("event-items", KEY),
	GAMEPLAY("gameplay", KEY),
	PLOT_ADVANCEMENT("plot-advancement", KEY),
	UNUSED("unused", KEY),
	
	ALL_MAIL("all-mail", MAIL),
	
	NATURE_MINTS("nature-mints", ItemPocket.STAT_CHANGING),
	VITAMINS("vitamins", ItemPocket.STAT_CHANGING),
	EFFORT_TRAINING("effort-training", STAT_CHANGING),
	
	HEALING("healing", ItemPocket.MEDICINE),
	PP_RECOVERY("pp-recovery", ItemPocket.MEDICINE),
	REVIVAL("revival", ItemPocket.MEDICINE),
	STATUS_CURES("status-cures", ItemPocket.MEDICINE),
	
	STANDARD_BALLS("standard-balls", POKEBALLS),
	SPECIAL_BALLS("special-balls", POKEBALLS),
	APRICORN_BALLS("apricorn-balls", POKEBALLS),
	
	COLLECTIBLES("collectibles", MISC),
	SPELUNKING("spelunking", MISC),
	HELD_ITEMS("held-items", MISC),
	CHOICE("choice", MISC),
	BAD_HELD_ITEMS("bad-held-items", MISC),
	TRAINING("training", MISC),
	SPECIES_SPECIFIC("species-specific", MISC),
	LOOT("loot", MISC),
	MULCH("mulch", MISC),
	DEX_COMPLETION("dex-completion", MISC),
	SCARVES("scarves", MISC),
	CURRY_INGREDIENTS("curry-ingredients", MISC),
	SANDWICH_INGREDIENTS("sandwich-ingredients", MISC),
	PICNIC("picnic", MISC),
	DYNAMAX_CRYSTALS("dynamax-crystals", MISC), //event distributions
	
	ALL_MACHINES("all-machines", MACHINES),
	
	APRICORN_BOX("apricorn-box", KEY),
	DATA_CARDS("data-cards", KEY),
	
	TYPE_ENHANCEMENT("type-enhancement", TYPE_BOOSTERS),
	PLATES("plates", ItemPocket.PLATES),
	JEWELS("jewels", GEMS),
	MEGA_STONES("mega-stones", ItemPocket.MEGA_STONES),
	Z_CRYSTALS("z-crystals", ItemPocket.Z_CRYSTALS),
	TERA_SHARD("tera-shard", ItemPocket.TERA_SHARDS),
	TM_MATERIALS("tm-materials", ItemPocket.TM_MATERIALS),
	SPECIES_CANDIES("species-candies", ItemPocket.SPECIES_CANDIES),
	MEMORIES("memories", ItemPocket.MEMORIES),
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
	
	public static List<ItemCategory> getExcludedCategories() {
		return Util.list(DYNAMAX_CRYSTALS, DATA_CARDS, MIRACLE_SHOOTER, UNUSED, CATCHING_BONUS, CURRY_INGREDIENTS, SANDWICH_INGREDIENTS, PICNIC);
	}
}
