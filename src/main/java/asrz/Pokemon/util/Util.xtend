package asrz.Pokemon.util

import java.util.ArrayList
import java.util.Collection
import java.util.List

class Util {
	
	def static <T> List<T> list(T... elements) {
		val result = new ArrayList(elements.size)
		
		for (T t : elements) {
			result.add(t)
		}
		
		return result
	}
	
	def static isBlank(String str) {
		if (str === null) {
			return true;
		}
		
		return str.length == 0
	}
	
	def static <T> randomChoice(T... choices) {
		return randomChoice(Util.list(choices))
	}
	
	def static <T> randomChoice(Collection<T> choices) {
		if (choices.empty) {
			return null
		}
		
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
	
	def static <T> boolean in(T needle, Collection<T> haystack) {
		return haystack.contains(needle)
	}
	
	def static <T> List<T> difference(Collection<T> collection1, Collection<T> collection2) {
		val result = new ArrayList<T>
		
		for (T t : collection1) {
			if (!collection2.contains(t)) {
				result.add(t)
			}
		}
		
		return result
	}
	
	def static <T> boolean isEmpty(Collection<T> collection) {
		return collection === null || collection.isEmpty()
	}
	
	def static boolean equals(Object o1, Object o2) {
		if (o1 === null || o2 === null) {
			return false
		}
		
		return o1.equals(o2)
	}
}
