package asrz.Pokemon.model.enums;

import asrz.Pokemon.util.Util;

public enum BattleSlot {
	
	PLAYER_PRIMARY,
	PLAYER_SECONDARY,
	OPPONENT_PRIMARY,
	OPPONENT_SECONDARY,
	;
	
	public boolean isPlayer() {
		return Util.in(this, PLAYER_PRIMARY, PLAYER_SECONDARY);
	}
	
	public BattleSlot getAllySlot() {
		switch(this) {
			case OPPONENT_PRIMARY: return OPPONENT_SECONDARY;
			case OPPONENT_SECONDARY: return OPPONENT_PRIMARY;
			case PLAYER_PRIMARY: return PLAYER_SECONDARY;
			case PLAYER_SECONDARY: return PLAYER_PRIMARY;
			default: throw new RuntimeException("Unhandled BattleSlot: " + this);
		}
	}
	
	public BattleSlot getOpponentSlot() {
		switch(this) {
			case OPPONENT_PRIMARY: return PLAYER_PRIMARY;
			case OPPONENT_SECONDARY: return PLAYER_SECONDARY;
			case PLAYER_PRIMARY: return OPPONENT_PRIMARY;
			case PLAYER_SECONDARY: return OPPONENT_SECONDARY;
			default: throw new RuntimeException("Unhandled BattleSlot: " + this);
		}
	}

}
