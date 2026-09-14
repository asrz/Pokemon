package asrz.Pokemon.model.enums;

public enum Terrain {
	ELECTRIC("Electric", Type.ELECTRIC),
	GRASSY("Grassy", Type.GRASS),
	PSYCHIC("Psychic", Type.PSYCHIC),
	MISTY("Misty", Type.FAIRY),
	;
	
	private String label;
	private Type type;
	
	private Terrain(String label, Type type) {
		this.label = label;
		this.type = type;
	}
	
	public String getLabel() { return label; }
	public Type getType() { return type; }
}
