package asrz.Pokemon.model.mongo

import asrz.Pokemon.model.ItemStack
import org.bson.codecs.Codec
import org.bson.BsonWriter
import org.bson.codecs.EncoderContext
import org.bson.BsonReader
import org.bson.codecs.DecoderContext

class ItemStackCodec implements Codec<ItemStack> {
	
	override encode(BsonWriter writer, ItemStack value, EncoderContext encoderContext) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override getEncoderClass() {
		return ItemStack
	}
	
	override decode(BsonReader reader, DecoderContext decoderContext) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}