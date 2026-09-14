package asrz.Pokemon.model.enums;

public enum BattleType {
	SINGLE,
	DOUBLE,
	;
	
	public boolean isSingle() {
		return this == SINGLE;
	}
	
	public boolean isDouble() {
		return this == DOUBLE;
	}
}
