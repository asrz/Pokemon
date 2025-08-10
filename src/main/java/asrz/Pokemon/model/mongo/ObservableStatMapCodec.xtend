package asrz.Pokemon.model.mongo

import asrz.Pokemon.model.ObservableStatMap
import asrz.Pokemon.model.enums.Stat
import org.bson.BsonReader
import org.bson.BsonType
import org.bson.BsonWriter
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext

class ObservableStatMapCodec implements Codec<ObservableStatMap> {
	
	override encode(BsonWriter writer, ObservableStatMap map, EncoderContext encoderContext) {
		writer.writeStartDocument()
		
		map.forEach[key, value|
			writer.writeInt32(key.name, value)
		]
		
		writer.writeEndDocument()
	}
	
	override getEncoderClass() {
		return ObservableStatMap
	}
	
	override decode(BsonReader reader, DecoderContext decoderContext) {
		val result = new ObservableStatMap
		
		reader.readStartDocument()
		
		while(reader.readBsonType() != BsonType.END_OF_DOCUMENT) {
			val Stat stat = Stat.fromString(reader.readName())
			val Integer value = reader.readInt32
			result.put(stat, value)
		}
		
		reader.readEndDocument()
		
		return result
	}
}
