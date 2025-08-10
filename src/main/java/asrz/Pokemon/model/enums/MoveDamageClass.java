package asrz.Pokemon.model.enums;

import asrz.Pokemon.model.interfaces.ILabeled;

public enum MoveDamageClass implements ILabeled {

	PHYSICAL("Physical", "physical", "j"),
	SPECIAL("Special", "special", "t"),
	STATUS("Status", "status", "u"),
	;
	
	private String label;
	private String apiLabel;
	private String symbol;
	
	private MoveDamageClass(String label, String apiLabel, String symbol) {
		this.label = label;
		this.apiLabel = apiLabel;
		this.symbol = symbol;
	}
	
	public String getLabel() { return label; }
	public String getApiLabel() { return apiLabel; }
	public String getSymbol() { return symbol; }
	
	
	public static MoveDamageClass fromApiString(String apiString) {
		for (MoveDamageClass moveDamageClass : values()) {
			if (moveDamageClass.apiLabel.equals(apiString)) {
				return moveDamageClass;
			}
		}
		
		return null;
	}
}
