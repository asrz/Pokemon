package asrz.Pokemon.model.enums;

public enum MoveTarget {
	SPECIFIC_MOVE("specific-move"),
	SELECTED_POKEMON_ME_FIRST("selected-pokemon-me-first"),
	ALLY("ally"),
	USERS_FIELD("users-field"),
	USER_OR_ALLY("user-or-ally"),
	OPPONENTS_FIELD("opponents-field"),
	USER("user"),
	RANDOM_OPPONENT("random-opponent"),
	ALL_OTHER_POKEMON("all-other-pokemon"),
	SELECTED_POKEMON("selected-pokemon"),
	ALL_OPPONENTS("all-opponents"),
	ENTIRE_FIELD("entire-field"),
	USER_AND_ALLIES("user-and-allies"),
	ALL_POKEMON("all-pokemon"),
	ALL_ALLIES("all-allies"),
	FAINTING_POKEMON("fainting-pokemon"),
	;
	
	private String apiLabel;
	
	private MoveTarget(String apiLabel) {
		this.apiLabel = apiLabel;
	}
	
	public String getApiLabel() { return apiLabel; }
	
	
	
	
	public static MoveTarget fromApiString(String apiString) {
		for (MoveTarget moveTarget : values()) {
			if (moveTarget.apiLabel.equals(apiString)) {
				return moveTarget;
			}
		}
		
		return null;
	}
}
