package asrz.Pokemon.model

import asrz.Pokemon.model.enums.Badge
import asrz.Pokemon.util.Util
import java.util.List
import asrz.Pokemon.model.enums.Flag

class LocationAccessRequirement {
	
	String locationDaoName
	List<Badge> badges
	List<String> itemDaoNames
	Flag flag
	
	new(String locationDaoName) {
		this.locationDaoName = locationDaoName
	}
	
	new (String locationDaoName, Flag flag, String... itemDaoNames) {
		this.locationDaoName = locationDaoName
		this.flag = flag
		this.itemDaoNames = itemDaoNames
	}
	
	new (String locationDaoName, String... itemDaoNames) {
		this.locationDaoName = locationDaoName
		this.itemDaoNames = itemDaoNames
	}
	
	new (String locationDaoName, Badge badge, String... itemDaoNames) {
		this.locationDaoName = locationDaoName
		this.badges = Util.list(badge)
		this.itemDaoNames = itemDaoNames
	}
	
	new (String locationDaoName, List<Badge> badges, String ... itemDaoNames) {
		this.locationDaoName = locationDaoName
		this.badges = badges
		this.itemDaoNames = itemDaoNames
	}
}