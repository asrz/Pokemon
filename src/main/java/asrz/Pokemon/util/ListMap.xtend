package asrz.Pokemon.util

import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map

class ListMap<K, V> {
	
	Map<K, List<V>> innerMap = new HashMap


	new() {}
	
	new(Map<K, List<V>> map) {
		innerMap = map
	}
	
	def clear() {
		innerMap.clear()
	}
	
	def containsKey(K key) {
		return innerMap.containsKey(key)
	}
	
	def containsValue(V value) {
		return flattenedValues().contains(value)
	}
	
	def flattenedValues() {
		return innerMap.values.flatten
	}
	
	def entrySet() {
		return innerMap.entrySet
	}
	
	def get(K key) {
		return innerMap.get(key)
	}
	
	def isEmpty() {
		return innerMap.isEmpty()
	}
	
	def keySet() {
		return innerMap.keySet()
	}
	
	def add(K key, V value) {
		val list = innerMap.getOrDefault(key, new ArrayList)
		list.add(value)
		innerMap.put(key, list)
	}
	
	def addIfAbsent(K key, V value) {
		val list = innerMap.getOrDefault(key, new ArrayList)
		if (!list.contains(value)) {
			list.add(value)
			innerMap.put(key, list)
		}
	}
	
	def addAll(K key, List<V> values) {
		val list = innerMap.getOrDefault(key, new ArrayList)
		list.addAll(values)
		innerMap.put(key, list)
	}
	
	def addAllAbsent(K key, List<V> values) {
		val list = innerMap.getOrDefault(key, new ArrayList)
		for (V value : values) {
			if (!list.contains(value)) {
				list.add(value)
			}
		}
		innerMap.put(key, list)
	}
	
	def remove(K key) {
		innerMap.remove(key)
	}
	
	def remove(K key, V value) {
		val list = innerMap.get(key)
		if (list === null) {
			return false
		}
		
		return list.remove(value)
	}
	
	def values() {
		return innerMap.values()
	}
	
}