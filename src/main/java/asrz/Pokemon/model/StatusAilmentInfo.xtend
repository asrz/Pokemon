package asrz.Pokemon.model

import asrz.Pokemon.model.enums.BattleSlot

class StatusAilmentInfo {
	
	public int duration
	public int strength
	public BattleSlot inflicter //used for LEECH_SEED
	public Move move //used for DISABLE
}