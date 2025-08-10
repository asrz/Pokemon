package asrz.Pokemon.util

import java.util.HashMap
import java.util.HashSet
import java.util.Map

class TwoDimensionalListMap<K1, K2, V> {
	
	Map<K1, ListMap<K2, V>> innerMap = new HashMap
	
	
	def add(K1 key1, K2 key2, V value) {
		val firstDimensionalMap = innerMap.getOrDefault(key1, new ListMap())
		firstDimensionalMap.add(key2, value)
		innerMap.put(key1, firstDimensionalMap)
	}
	
	def firstDimensionalKeySet() {
		return innerMap.keySet()
	}
	
	def secondDimensionalKeySet(K1 key1) {
		return innerMap.get(key1)?.keySet() ?: new HashSet
	}
	
	def get(K1 key1, K2 key2) {
		return innerMap.get(key1)?.get(key2)
	}
	
	
}