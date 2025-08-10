package asrz.Pokemon.model.mongo

import asrz.Pokemon.model.IntegerList
import org.bson.BsonReader
import org.bson.BsonType
import org.bson.BsonWriter
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext

class IntegerListCodec implements Codec<IntegerList> {
	
	Codec<Integer> integerCodec
	
	new(Codec<Integer> integerCodec) {
		this.integerCodec = integerCodec
	}
	
	override encode(BsonWriter writer, IntegerList list, EncoderContext encoderContext) {
		writer.writeStartArray
		
		list.forEach[ value |
			integerCodec.encode(writer, value, encoderContext)
		]
		
		writer.writeEndArray
	}
	
	override getEncoderClass() {
		return IntegerList
	}
	
	override decode(BsonReader reader, DecoderContext decoderContext) {
		reader.readStartArray
		
		val IntegerList integerList = new IntegerList
		
		while (reader.readBsonType() != BsonType.END_OF_DOCUMENT) {
			integerList.add(integerCodec.decode(reader, decoderContext))
		}
		
		reader.readEndArray
		
		return integerList
	}
}