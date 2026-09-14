package asrz.Pokemon.util

import asrz.Pokemon.model.Pokemon
import java.util.List

class PokemonUtil {
	
	def static Integer getGenerationFromVersionOrVersionGroup(String versionGroup) {
		if (versionGroup === null) {
			return null
		}
		
		switch(versionGroup) {
			case "red",
			case "blue",
			case "red-blue",
			case "yellow":
				return 1
			case "gold",
			case "silver",
			case "gold-silver",
			case "crystal":
				return 2
			case "ruby",
			case "sapphire",
			case "ruby-sapphire",
			case "emerald",
			case "firered",
			case "leafgreen",
			case "firered-leafgreen",
			case "colosseum",
			case "xd":
				return 3
			case "diamond",
			case "pearl",
			case "diamond-pearl",
			case "platinum",
			case "heartgold",
			case "soulsilver",
			case "heartgold-soulsilver":
				return 4
			case "black",
			case "white",
			case "black-white",
			case "black-2",
			case "white-2",
			case "black-2-white-2":
				return 5
			case "x",
			case "y",
			case "x-y",
			case "omega-ruby",
			case "alpha-sapphire",
			case "omega-ruby-alpha-sapphire":
				return 6
			case "sun",
			case "moon",
			case "sun-moon",
			case "ultra-sun",
			case "ultra-moon",
			case "ultra-sun-ultra-moon",
			case "lets-go-pikachu",
			case "lets-go-eevee",
			case "lets-go-pikachu-lets-go-eevee":
				return 7
			case "sword",
			case "shield",
			case "sword-shield",
			case "the-isle-of-armor",
			case "the-crown-tundra",
			case "brilliant-diamond",
			case "shining-pearl",
			case "brilliant-diamond-and-shining-pearl",
			case "legends-arceus":
				return 8
			case "scarlet",
			case "violet",
			case "scarlet-violet",
			case "the-teal-mask",
			case "the-indigo-disk":
				return 9
			default:
				throw new RuntimeException("Unexpected version/version group: " + versionGroup)
		}
	}
	
	def static String getCanonicalVersionForGeneration(int gen) {
		switch(gen) {
			case 1: return "yellow"
			case 2: return "crystal"
			case 3: return "emerald"
			case 4: return "platinum"
			case 5: return "white-2"
			case 6: return "x"
			case 7: return "ultra-sun"
			case 8: return "sword"
			case 9: return "scarlet"
			default: throw new RuntimeException("Unexpected generation: " + gen)
		}
	}
	
	def static String getLevelUpText(Pokemon pokemon) {
		return String.format("%s has reached level %d", pokemon.label, pokemon.level)
	}
	
	def static int getMaxDexNumberByGeneration(int gen) {
		switch(gen) {
			case 1: return 151
			case 2: return 251
			case 3: return 386
			case 4: return 493
			case 5: return 649
			case 6: return 721
			case 7: return 809
			case 8: return 905
			case 9: return 1025
			default: throw new RuntimeException("Unexpected generation: " + gen)
		}
	}
	
	def static List<String> getGenerationNames(int maxGeneration) {
		val List<String> result = Util.list()
		
		if (maxGeneration >= 1) {
			result.add("generation-i")
		}
		if (maxGeneration >= 2) {
			result.add("generation-ii")
		}
		if (maxGeneration >= 3) {
			result.add("generation-iii")
		}
		if (maxGeneration >= 4) {
			result.add("generation-iv")
		}
		if (maxGeneration >= 5) {
			result.add("generation-v")
		}
		if (maxGeneration >= 6) {
			result.add("generation-vi")
		}
		if (maxGeneration >= 7) {
			result.add("generation-vii")
		}
		if (maxGeneration >= 8) {
			result.add("generation-viii")
		}
		if (maxGeneration >= 9) {
			result.add("generation-ix")
		}
		
		return result
	}
}