package asrz.Pokemon.util

import java.util.Collection
import java.util.List

class Util {
	
	def static <T> List<T> list(T... elements) {
		return elements.toList
	}
	
	def static isBlank(String str) {
		if (str === null) {
			return true;
		}
		
		return str.length == 0
	}
	
	def static <T> randomChoice(Collection<T> choices) {
		val index = Math.floor(Math.random * choices.size()) as int
		return choices.get(index)
	}
	
	/*
	 * generates a random int between lower and upper (both inclusive)
	 */
	def static randomInt(int lower, int upper) {
		return Math.floor(Math.random * (upper + 1 - lower) + lower) as int
	}
	
	def static randomPercentage() {
		return randomInt(1, 100)
	}
	
	def static <T> T firstNonNull(T... objects) {
		for (T object : objects) {
			if (object !== null) {
				return object
			}
		}
		
		return null
	}
	
	//hyphen-case to Title Case
	def static hyphenCaseToTitleCase(String text) {
		return text.split("-").map[toFirstUpper].join(" ")
	}
	
	def static String getIndefiniteArticle(String string) {
		if (string === null) {
			return null
		}
		
		val vowels = Util.list("a", "e", "i", "o", "u")
		
		val c0 = string.toLowerCase.charAt(0)
		if (vowels.contains(c0)) {
			return "an"
		}
//		if (c0 == 'h') {
//			if (vowels.contains(string.toLowerCase.charAt(1))) {
//				return "an"
//			}
//		}
		
		return "a"
	}
	
	def static <T> boolean in(T needle, T...haystack) {
		return haystack.contains(needle)
	}
	
}
