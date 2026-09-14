package asrz.Pokemon.model.enums;

import java.util.List;

import asrz.Pokemon.util.Util;

public enum Badge {
	BOULDER("Boulder Badge", 1),
	CASCADE("Cascade Badge", 1),
	THUNDER("Thunder Badge", 1),
	RAINBOW("Rainbow Badge", 1),
	SOUL("Soul Badge", 1),
	MARSH("Marsh Badge", 1),
	VOLCANO("Volcano Badge", 1),
	EARTH("Earth Badge", 1),
	
	ZEPHYR("Zephyr Badge", 2),
	HIVE("Hive Badge", 2),
	PLAIN("Plain Badge", 2),
	FOG("Fog Badge", 2),
	STORM("Storm Badge", 2),
	MINERAL("Mineral Badge", 2),
	GLACIER("Glacier Badge", 2),
	RISING("Rising Badge", 2),
	
	STONE("Stone Badge", 3),
	KNUCKLE("Knuckle Badge", 3),
	DYNAMO("Dynamo Badge", 3),
	HEAT("Heat Badge", 3),
	BALANCE("Balance Badge", 3),
	FEATHER("Feather Badge", 3),
	MIND("Mind Badge", 3),
	RAIN("Rain Badge", 3),
	
	COAL("Coal Badge", 4),
	FOREST("Forest Badge", 4),
	COBBLE("Cobble Badge", 4),
	FEN("Fen Badge", 4),
	RELIC("Relic Badge", 4),
	MINE("Mine Badge", 4),
	ICICLE("Icicle Badge", 4),
	BEACON("Beacon Badge", 4),
	
	TRIO("Trio Badge", 5),
	BASIC("Basic Badge", 5),
	INSECT("Insect Badge", 5),
	BOLT("Bolt Badge", 5),
	QUAKE("Quake Badge", 5),
	JET("Jet Badge", 5),
	FREEZE("Freeze Badge", 5),
	LEGEND("Legend Badge", 5),
	TOXIC("Toxic Badge", 5), //black-white-2
	WAVE("Wave Badge", 5), //black-white-2
	
	BUG("Bug Badge", 6),
	CLIFF("Cliff Badge", 6),
	RUMBLE("Rumble Badge", 6),
	PLANT("Plant Badge", 6),
	VOLTAGE("Voltage Badge", 6),
	FAIRY("Fairy Badge", 6),
	PSYCHIC("Psychic Badge", 6),
	ICEBERG("Iceberg Badge", 6),
	
	GRASS("Grass Badge", 8),
	WATER("Water Badge", 8),
	FIRE("Fire Badge", 8),
	FIGHTING("Fighting Badge", 8),
	GHOST("Ghost Badge", 8),
	FAIRY_GALAR("Fairy Badge", 8),
	ROCK("Rock Badge", 8),
	ICE("Ice Badge", 8),
	DARK("Dark Badge", 8),
	DRAGON("Dragon Badge", 8),
	
	KANTO_CHAMPION("Kanto Champion"),
	JOHTO_CHAMPION("Johto Champion"),
	HOENN_CHAMPION("Hoenn Champion"),
	SINNOH_CHAMPION("Sinnoh Champion"),
	UNOVA_CHAMPION("Unova Champion"),
	KALOS_CHAMPION("Kalos Champion"),
	ALOLA_CHAMPION("Alola Champion"),
	GALAR_CHAMPION("Galar Champion"),
	PALDEA_CHAMPION("Paldea Champion")
	;
	
	//TODO paldea
	
	private String label;
	private Integer generation;
	
	private Badge(String label) {
		this.label = label;
	}
	
	private Badge(String label, int generation) {
		this.label = label;
		this.generation = generation;
	}
	
	public String getLabel() { return label; }
	public Integer getGeneration() { return generation; }

	public static List<Badge> byGeneration(Integer generation) {
		List<Badge> result = Util.list();
		
		for (Badge badge : values()) {
			if (Util.equals(badge.generation, generation)) {
				result.add(badge);
			}
		}
		
		return result;
	}
}
