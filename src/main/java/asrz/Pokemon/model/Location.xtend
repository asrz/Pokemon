package asrz.Pokemon.model

import asrz.Pokemon.model.enums.Badge
import asrz.Pokemon.model.enums.Flag
import asrz.Pokemon.pokeAPI.model.locations.LocationDAO
import asrz.Pokemon.util.Util
import java.util.List
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Location {
	
	String locationDaoName
	String name
	
	List<LocationAccessRequirement> accessRequirements
	List<TrainerClass> trainerClasses
	List<GymId> gyms

	private new() {}
	
	new(String name, LocationAccessRequirement...accessRequirements) {
		this.name = name
		this.accessRequirements = accessRequirements
	}
	
	def static Location fromApi(LocationDAO locationDao, String languageName) {
		return new Location() => [
			locationDaoName = locationDao.name
			name = locationDao.names.findFirst[language == languageName].name
		]
	}
}

class Locations {
	
	public static Map<String, Location> locationsByDaoName = #[
		new Location("celadon-city") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-16"),
				new LocationAccessRequirement("kanto-route-7")
			]
		],
		new Location("cerulean-cave") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-24", Util.list(Badge.SOUL, Badge.KANTO_CHAMPION), Items.HM03)
			]
		],
		new Location("cerulean-city") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-24"),
				new LocationAccessRequirement("kanto-route-4"),
				new LocationAccessRequirement("kanto-route-5"),
				new LocationAccessRequirement("kanto-route-9", Badge.CASCADE, Items.HM01)
			]
		],
		new Location("cinnabar-island") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-sea-route-20", Badge.SOUL, Items.HM03),
				new LocationAccessRequirement("kanto-sea-route-21", Badge.SOUL, Items.HM03)
			]
		],
		new Location("digletts-cave") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-11"),
				new LocationAccessRequirement("kanto-route-2", Badge.CASCADE, Items.HM01)
			]
		],
		new Location("fuchsia-city") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-sea-route-19"),
				new LocationAccessRequirement("kanto-route-18"),
				new LocationAccessRequirement("kanto-route-15")
			]
		],
		new Location("indigo-plateau") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-victory-road-2")
			]
		],
		new Location("lavendar-town") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-8"),
				new LocationAccessRequirement("kanto-route-12"),
				new LocationAccessRequirement("rock-tunnel")
			]
		],
		new Location("mt-moon") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-3")
			]
		],
		new Location("pallet-town") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-sea-route-21", Badge.SOUL, Items.HM03),
				new LocationAccessRequirement("kanto-route-1")
			]
		],
		new Location("pewter-city") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-2", Flag.CLEARED_VIRIDIAN_FOREST),
				new LocationAccessRequirement("kanto-route-3")
			]
			gyms = #[
				GymId.PEWTER_GYM
			]
		],
		new Location("pokemon-mansion") => [
			accessRequirements = #[
				new LocationAccessRequirement("cinnabar-island")
			]
		],
		new Location("pokemon-tower") => [
			accessRequirements = #[
				new LocationAccessRequirement("lavendar-town")
			]
		],
		new Location("power-plant") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-10", Badge.SOUL, Items.HM03)
			]
		],
		new Location("rock-tunnel") => [
			accessRequirements = #[
				new LocationAccessRequirement("lavendar-town", Badge.BOULDER, Items.HM05),
				new LocationAccessRequirement("kanto-route-10", Badge.BOULDER, Items.HM05)
			]
		],
		new Location("saffron-city") => [
			accessRequirements = #[
				new LocationAccessRequirement("route-5", Flag.GAVE_TEA),
				new LocationAccessRequirement("route-6", Flag.GAVE_TEA),
				new LocationAccessRequirement("route-7", Flag.GAVE_TEA),
				new LocationAccessRequirement("route-8", Flag.GAVE_TEA)
			]
		],
		new Location("seafoam-islands") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-sea-route-20")
			]
		],
		new Location("ss-anne") => [
			accessRequirements = #[
				new LocationAccessRequirement("vermillion-city")
			]
		],
		new Location("vermillion-city") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-6"),
				new LocationAccessRequirement("kanto-route-11")
			]
		],
		new Location("viridian-city") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-1"),
				new LocationAccessRequirement("kanto-route-2"),
				new LocationAccessRequirement("kanto-route-22")
			]
		],
		new Location("viridian-forest") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-2")
			]
			trainerClasses = #[
				TrainerClasses.BUG_CATCHER, TrainerClasses.LASS
			]
		],
		new Location("kanto-safari-zone") => [
			accessRequirements = #[
				new LocationAccessRequirement("fuchsia-city")
			]
		],
		new Location("kanto-victory-road-1") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-23"),
				new LocationAccessRequirement("kanto-victory-road-2")
			]
		],
		new Location("kanto-victory-road-2") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-victory-road-1"),
				new LocationAccessRequirement("indigo-plateau")
			]
		],
		new Location("kanto-route-1") => [
			accessRequirements = #[
				new LocationAccessRequirement("pallet-town"),
				new LocationAccessRequirement("viridian-city")
			]
		],
		new Location("kanto-route-2") => [
			accessRequirements = #[
				new LocationAccessRequirement("viridian-city"),
				new LocationAccessRequirement("pewter-city")
			]
		],
		new Location("kanto-route-3") => [
			accessRequirements = #[
				new LocationAccessRequirement("pewter-city", Flag.BEAT_BROCK),
				new LocationAccessRequirement("kanto-route-4")
			]
		],
		new Location("kanto-route-4") => [
			accessRequirements = #[
				new LocationAccessRequirement("mt-moon"),
				new LocationAccessRequirement("cerulean-city")
			]
		],
		new Location("kanto-route-5") => [
			accessRequirements = #[
				new LocationAccessRequirement("cerulean-city"),
				new LocationAccessRequirement("kanto-route-6"),
				new LocationAccessRequirement("saffron-city", Flag.GAVE_TEA)
			]
		],
		new Location("kanto-route-6") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-5"),
				new LocationAccessRequirement("vermillion-city"),
				new LocationAccessRequirement("saffron-city", Flag.GAVE_TEA)
			]
		],
		new Location("kanto-route-7") => [
			accessRequirements = #[
				new LocationAccessRequirement("celadon-city"),
				new LocationAccessRequirement("kanto-route-8"),
				new LocationAccessRequirement("saffron-city", Flag.GAVE_TEA)
			]
		],
		new Location("kanto-route-8") => [
			accessRequirements = #[
				new LocationAccessRequirement("lavendar-city"),
				new LocationAccessRequirement("kanto-route-7"),
				new LocationAccessRequirement("saffron-city", Flag.GAVE_TEA)
			]
		],
		new Location("kanto-route-9") => [
			accessRequirements = #[
				new LocationAccessRequirement("cerulean", Badge.CASCADE, Items.HM01),
				new LocationAccessRequirement("kanto-route-10")
			]
		],
		new Location("kanto-route-10") => [
			accessRequirements = #[
				new LocationAccessRequirement("rock-tunnel"),
				new LocationAccessRequirement("kanto-route-9")
			]
		],
		new Location("kanto-route-11") => [
			accessRequirements = #[
				new LocationAccessRequirement("digletts-cave"),
				new LocationAccessRequirement("kanto-route-12")
			]
		],
		new Location("kanto-route-12") => [
			accessRequirements = #[
				new LocationAccessRequirement("lavendar-town"),
				new LocationAccessRequirement("kanto-route-13")
			]
		],
		new Location("kanto-route-13") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-12"),
				new LocationAccessRequirement("kanto-route-14")
			]
		],
		new Location("kanto-route-14") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-13"),
				new LocationAccessRequirement("kanto-route-15")
			]
		],
		new Location("kanto-route-15") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-14"),
				new LocationAccessRequirement("fuchsia-city")
			]
		],
		new Location("kanto-route-16") => [
			accessRequirements = #[
				new LocationAccessRequirement("celadon-city"),
				new LocationAccessRequirement("kanto-route-17", "poke-flute")
			]
		],
		new Location("kanto-route-17") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-16", "bicycle", "poke-flute"),
				new LocationAccessRequirement("kanto-route-18", "bicycle")
			]
		],
		new Location("kanto-route-18") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-17"),
				new LocationAccessRequirement("fuchsia-city")
			]
		],
		new Location("kanto-sea-route-19") => [
			accessRequirements = #[
				new LocationAccessRequirement("fuchsia-city", Badge.SOUL, Items.HM03),
				new LocationAccessRequirement("kanto-sea-route-20")
			]
		],
		new Location("kanto-sea-route-20") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-sea-route-19"),
				new LocationAccessRequirement("cinnabar-island", Badge.SOUL, Items.HM03)
			]
		],
		new Location("kanto-sea-route-21") => [
			accessRequirements = #[
				new LocationAccessRequirement("cinnabar-island", Badge.SOUL, Items.HM03),
				new LocationAccessRequirement("pallet-town", Badge.SOUL, Items.HM03)
			]
		],
		new Location("kanto-route-22") => [
			accessRequirements = #[
				new LocationAccessRequirement("viridian-city"),
				new LocationAccessRequirement("kanto-route-23", Badge.byGeneration(1))
			]
		],
		new Location("kanto-route-23") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-22", Badge.byGeneration(1))
			]
		],
		new Location("kanto-route-24") => [
			accessRequirements = #[
				new LocationAccessRequirement("cerulean-city"),
				new LocationAccessRequirement("kanto-route-25")
			]
		],
		new Location("kanto-route-25") => [
			accessRequirements = #[
				new LocationAccessRequirement("kanto-route-24")
			]
		]
	].toMap[name]
}