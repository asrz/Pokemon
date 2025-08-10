package asrz.Pokemon.model

import java.util.Collection
import javafx.beans.InvalidationListener
import javafx.collections.FXCollections
import javafx.collections.ListChangeListener
import javafx.collections.ObservableList

class CustomObservableList<T> implements ObservableList<T>, Iterable<T> {
	
	ObservableList<T> innerList = FXCollections.observableArrayList
	
	override addAll(T... elements) {
		innerList.addAll(elements)
	}
	
	override addListener(ListChangeListener<? super T> listener) {
		innerList.addListener(listener)
	}
	
	override remove(int from, int to) {
		innerList.remove(from, to)
	}
	
	override removeAll(T... elements) {
		innerList.removeAll(elements)
	}
	
	override removeListener(ListChangeListener<? super T> listener) {
		innerList.removeListener(listener)
	}
	
	override retainAll(T... elements) {
		innerList.retainAll(elements)
	}
	
	override setAll(T... elements) {
		innerList.setAll(elements)
	}
	
	override setAll(Collection<? extends T> col) {
		innerList.setAll(col)
	}
	
	override add(T e) {
		innerList.add(e)
	}
	
	override add(int index, T element) {
		innerList.add(index, element)
	}
	
	override addAll(Collection<? extends T> c) {
		innerList.addAll(c)
	}
	
	override addAll(int index, Collection<? extends T> c) {
		innerList.addAll(index, c)
	}
	
	override clear() {
		innerList.clear()
	}
	
	override contains(Object o) {
		innerList.contains(o)
	}
	
	override containsAll(Collection<?> c) {
		innerList.containsAll(c)
	}
	
	override get(int index) {
		innerList.get(index)
	}
	
	override indexOf(Object o) {
		innerList.indexOf(o)
	}
	
	override isEmpty() {
		innerList.isEmpty
	}
	
	override iterator() {
		innerList.iterator()
	}
	
	override lastIndexOf(Object o) {
		innerList.lastIndexOf(o)
	}
	
	override listIterator() {
		innerList.listIterator()
	}
	
	override listIterator(int index) {
		innerList.listIterator(index)
	}
	
	override remove(Object o) {
		innerList.remove(o)
	}
	
	override remove(int index) {
		innerList.remove(index)
	}
	
	override removeAll(Collection<?> c) {
		innerList.removeAll(c)
	}
	
	override retainAll(Collection<?> c) {
		innerList.retainAll(c)
	}
	
	override set(int index, T element) {
		innerList.set(index, element)
	}
	
	override size() {
		innerList.size()
	}
	
	override subList(int fromIndex, int toIndex) {
		innerList.subList(fromIndex, toIndex)
	}
	
	override toArray() {
		innerList.toArray
	}
	
	override <T> toArray(T[] a) {
		innerList.toArray(a)
	}
	
	override addListener(InvalidationListener listener) {
		innerList.addListener(listener)
	}
	
	override removeListener(InvalidationListener listener) {
		innerList.removeListener(listener)
	}
	
}

class MoveList extends CustomObservableList<Move> {}
class PokedexList extends CustomObservableList<Pokedex> {}
class PokedexEntryList extends CustomObservableList<PokedexEntry> {}
class IntegerList extends CustomObservableList<Integer> {}