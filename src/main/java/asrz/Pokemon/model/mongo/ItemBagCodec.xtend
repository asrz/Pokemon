package asrz.Pokemon.model.mongo

import asrz.Pokemon.model.ItemBag
import asrz.Pokemon.model.ItemStack
import asrz.Pokemon.model.enums.ItemPocket
import org.bson.BsonReader
import org.bson.BsonType
import org.bson.BsonWriter
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext

class ItemBagCodec implements Codec<ItemBag>{
	
	Codec<ItemStack> itemStackCodec
	
	new(Codec<ItemStack> itemStackCodec) {
		this.itemStackCodec = itemStackCodec
	}
	
	override encode(BsonWriter writer, ItemBag itemBag, EncoderContext encoderContext) {
		writer.writeStartDocument()
		
		for (pocket : itemBag.keySet) {
			writer.writeStartArray(pocket.name)
			
			for (ItemStack itemStack : itemBag.get(pocket)) {
				itemStackCodec.encode(writer, itemStack, encoderContext)
			}
			
			writer.writeEndArray()
		}
		
		writer.writeEndDocument()
	}
	
	override getEncoderClass() {
		return ItemBag
	}
	
	override decode(BsonReader reader, DecoderContext decoderContext) {
		reader.readStartDocument()
		
		val itemBag = new ItemBag
		
		while(reader.readBsonType() != BsonType.END_OF_DOCUMENT) {
			val ItemPocket pocket = ItemPocket.fromString(reader.readName()) 
			reader.readStartArray()
			
			while (reader.readBsonType() != BsonType.END_OF_DOCUMENT) {
				val ItemStack itemStack = itemStackCodec.decode(reader, decoderContext)
				itemBag.add(pocket, itemStack)
			}
			
			reader.readEndArray()
		}
		
		reader.readEndDocument()
		
		return itemBag
	}
	
}