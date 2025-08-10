package asrz.Pokemon.model.mongo

import asrz.Pokemon.model.ItemBag
import asrz.Pokemon.model.ItemStack
import asrz.Pokemon.model.Move
import asrz.Pokemon.model.MoveList
import asrz.Pokemon.model.ObservableStatMap
import asrz.Pokemon.model.Pokedex
import asrz.Pokemon.model.PokedexEntry
import asrz.Pokemon.model.PokedexEntryList
import asrz.Pokemon.model.PokedexList
import org.bson.codecs.Codec
import org.bson.codecs.configuration.CodecProvider
import org.bson.codecs.configuration.CodecRegistry

class CustomCodecProvider implements CodecProvider {
	
	override <T> get(Class<T> clazz, CodecRegistry registry) {
		if (clazz == ObservableStatMap) {
			return new ObservableStatMapCodec() as Codec<T>
		} else if (clazz == MoveList) {
			return new MoveListCodec(registry.get(Move)) as Codec<T>
		} else if (clazz == PokedexList) {
			return new PokedexListCodec(registry.get(Pokedex)) as Codec<T>
		} else if (clazz == PokedexEntryList) {
			return new PokedexEntryListCodec(registry.get(PokedexEntry)) as Codec<T>
		} else if (clazz == ItemBag) {
			return new ItemBagCodec(registry.get(ItemStack)) as Codec<T>
		}
	}
}