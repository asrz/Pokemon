package asrz.Pokemon.model

import asrz.Pokemon.model.enums.Stat
import java.util.Map
import javafx.beans.InvalidationListener
import javafx.collections.MapChangeListener
import javafx.collections.ObservableMap
import javafx.collections.FXCollections

class ObservableStatMap implements ObservableMap<Stat, Integer> {
	
	ObservableMap<Stat, Integer> innerMap = FXCollections.observableHashMap
	
	override addListener(MapChangeListener<? super Stat, ? super Integer> listener) {
		innerMap.addListener(listener)
	}
	
	override removeListener(MapChangeListener<? super Stat, ? super Integer> listener) {
		innerMap.removeListener(listener)
	}
	
	override clear() {
		innerMap.clear
	}
	
	override containsKey(Object key) {
		innerMap.containsKey(key)
	}
	
	override containsValue(Object value) {
		innerMap.containsValue(value)
	}
	
	override entrySet() {
		innerMap.entrySet
	}
	
	override get(Object key) {
		innerMap.get(key)
	}
	
	override isEmpty() {
		innerMap.isEmpty
	}
	
	override keySet() {
		innerMap.keySet
	}
	
	override put(Stat key, Integer value) {
		innerMap.put(key ,value)
	}
	
	override putAll(Map<? extends Stat, ? extends Integer> m) {
		innerMap.putAll(m)
	}
	
	override remove(Object key) {
		innerMap.remove(key)
	}
	
	override size() {
		innerMap.size()
	}
	
	override values() {
		innerMap.values
	}
	
	override addListener(InvalidationListener listener) {
		innerMap.addListener(listener)
	}
	
	override removeListener(InvalidationListener listener) {
		innerMap.removeListener(listener)
	}
	
	
}