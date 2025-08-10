package asrz.Pokemon.model.mongo

import asrz.Pokemon.model.Move
import asrz.Pokemon.model.MoveList
import org.bson.BsonReader
import org.bson.BsonType
import org.bson.BsonWriter
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext

class MoveListCodec implements Codec<MoveList> {
	
	Codec<Move> moveCodec
	
	new(Codec<Move> moveCodec) {
		this.moveCodec = moveCodec
	}
	
	override encode(BsonWriter writer, MoveList list, EncoderContext encoderContext) {
		writer.writeStartArray
		
		list.forEach[ value |
			moveCodec.encode(writer, value, encoderContext)
		]
		
		writer.writeEndArray
	}
	
	override getEncoderClass() {
		return MoveList
	}
	
	override decode(BsonReader reader, DecoderContext decoderContext) {
		reader.readStartArray
		
		val MoveList moveList = new MoveList
		
		while (reader.readBsonType() != BsonType.END_OF_DOCUMENT) {
			moveList.add(moveCodec.decode(reader, decoderContext))
		}
		
		reader.readEndArray
		
		return moveList
	}
}