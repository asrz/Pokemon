package asrz.Pokemon.util

import java.util.HashMap
import java.util.Map

class TwoDimensionalMap<K1, K2, V> {
	Map<K1, Map<K2, V>> innerMap
	
	
	
	def put(K1 key1, K2 key2, V value) {
		val firstDimensionalMap = innerMap.getOrDefault(key1, new HashMap())
		firstDimensionalMap.put(key2, value)
		innerMap.put(key1, firstDimensionalMap)
	}
	
	def firstDimensionalKeySet() {
		return innerMap.keySet()
	}
	
	def secondDimensionalKeySet(K1 key1) {
		return innerMap.get(key1)?.keySet()
	}
}