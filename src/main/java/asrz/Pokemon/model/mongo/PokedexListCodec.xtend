package asrz.Pokemon.model.mongo

import asrz.Pokemon.model.Pokedex
import asrz.Pokemon.model.PokedexList
import org.bson.BsonReader
import org.bson.BsonType
import org.bson.BsonWriter
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext

class PokedexListCodec implements Codec<PokedexList> {
	
	Codec<Pokedex> pokedexCodec
	
	new(Codec<Pokedex> pokedexCodec) {
		this.pokedexCodec = pokedexCodec
	}
	
	override encode(BsonWriter writer, PokedexList list, EncoderContext encoderContext) {
		writer.writeStartArray
		
		list.forEach[ value |
			pokedexCodec.encode(writer, value, encoderContext)
		]
		
		writer.writeEndArray
	}
	
	override getEncoderClass() {
		return PokedexList
	}
	
	override decode(BsonReader reader, DecoderContext decoderContext) {
		reader.readStartArray
		
		val PokedexList pokedexList = new PokedexList
		
		while (reader.readBsonType() != BsonType.END_OF_DOCUMENT) {
			val pokedex = pokedexCodec.decode(reader, decoderContext)
			pokedex.entriesAsList.forEach[ entry |
				pokedex.entries.put(entry.number, entry)
			]
			pokedexList.add(pokedex)
		}
		
		reader.readEndArray
		
		return pokedexList
	}
}