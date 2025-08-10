package asrz.Pokemon.util

import java.util.Collection
import java.util.List
import java.util.function.Function

class Extensions {
	
	
	def static <K1, K2, V> TwoDimensionalListMap<K1, K2, V> twoDimensionalGroupBy(List<V> list, Function<V, K1> key1Mapper, Function<V, K2> key2Mapper) {
		return twoDimensionalGroupBy(list, key1Mapper, key2Mapper, Function.identity())
	}
	
	def static <T, K1, K2, V> TwoDimensionalListMap<K1, K2, V> twoDimensionalGroupBy(List<T> list, Function<T, K1> key1Mapper, Function<T, K2> key2Mapper, Function<T, V> valueMapper) {
		val result = new TwoDimensionalListMap<K1, K2, V>()
		
		for (T element : list) {
			val key1 = key1Mapper.apply(element)
			val key2 = key2Mapper.apply(element)
			val value = valueMapper.apply(element)
			
			result.add(key1, key2, value)
		}
		
		return result
	}
	
	def static <T> addIfAbsent(Collection<T> collection, T element) {
		if (!collection.contains(element)) {
			collection.add(element)
		}
	}
	
	def static <T> addAllIfAbsent(Collection<T> collection, Collection<T> elements) {
		for (T element : elements) {
			addIfAbsent(collection, element)
		}
	}
}