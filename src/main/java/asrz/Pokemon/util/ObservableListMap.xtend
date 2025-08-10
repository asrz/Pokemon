package asrz.Pokemon.util

import java.util.HashMap
import java.util.List
import java.util.Map
import javafx.collections.FXCollections
import javafx.collections.ObservableList

class ObservableListMap<K, V> {
	
	Map<K, ObservableList<V>> innerMap = new HashMap


	new() {}
	
	new(Map<K, ObservableList<V>> map) {
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
	
	def addKey(K key) {
		if (!innerMap.containsKey(key)) {
			innerMap.put(key, FXCollections.observableArrayList)
		}
	}
	
	def add(K key, V value) {
		val list = innerMap.getOrDefault(key, FXCollections.observableArrayList)
		list.add(value)
		innerMap.put(key, list)
	}
	
	def addAll(K key, List<V> values) {
		val list = innerMap.getOrDefault(key, FXCollections.observableArrayList)
		list.addAll(values)
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