package asrz.Pokemon.model.enums;

public enum Terrain {
	ELECTRIC("Electric"),
	GRASSY("Grassy"),
	PSYCHIC("Psychic"),
	MISTY("Misty"),
	;
	
	private String label;
	
	private Terrain(String label) {
		this.label = label;
	}
	
	public String getLabel() { return label; }
}
