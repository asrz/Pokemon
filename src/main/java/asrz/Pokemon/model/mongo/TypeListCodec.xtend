package asrz.Pokemon.model.mongo

import asrz.Pokemon.model.TypeList
import org.bson.BsonReader
import org.bson.BsonType
import org.bson.BsonWriter
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext
import asrz.Pokemon.model.enums.Type

class TypeListCodec implements Codec<TypeList> {
	
	Codec<Type> typeCodec
	
	new(Codec<Type> typeCodec) {
		this.typeCodec = typeCodec
	}
	
	override encode(BsonWriter writer, TypeList list, EncoderContext encoderContext) {
		writer.writeStartArray
		
		list.forEach[ value |
			typeCodec.encode(writer, value, encoderContext)
		]
		
		writer.writeEndArray
	}
	
	override getEncoderClass() {
		return TypeList
	}
	
	override decode(BsonReader reader, DecoderContext decoderContext) {
		reader.readStartArray
		
		val TypeList typeList = new TypeList
		
		while (reader.readBsonType() != BsonType.END_OF_DOCUMENT) {
			typeList.add(typeCodec.decode(reader, decoderContext))
		}
		
		reader.readEndArray
		
		return typeList
	}
}