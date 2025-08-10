package asrz.Pokemon.model.mongo

import asrz.Pokemon.model.PokedexEntry
import asrz.Pokemon.model.PokedexEntryList
import org.bson.BsonReader
import org.bson.BsonType
import org.bson.BsonWriter
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext

class PokedexEntryListCodec implements Codec<PokedexEntryList> {
	
	Codec<PokedexEntry> pokedexEntryCodec
	
	new(Codec<PokedexEntry> pokedexEntryCodec) {
		this.pokedexEntryCodec = pokedexEntryCodec
	}
	
	override encode(BsonWriter writer, PokedexEntryList list, EncoderContext encoderContext) {
		writer.writeStartArray
		
		list.forEach[ value |
			pokedexEntryCodec.encode(writer, value, encoderContext)
		]
		
		writer.writeEndArray
	}
	
	override getEncoderClass() {
		return PokedexEntryList
	}
	
	override decode(BsonReader reader, DecoderContext decoderContext) {
		reader.readStartArray
		
		val PokedexEntryList pokedexEntryList = new PokedexEntryList
		
		while (reader.readBsonType() != BsonType.END_OF_DOCUMENT) {
			pokedexEntryList.add(pokedexEntryCodec.decode(reader, decoderContext))
		}
		
		reader.readEndArray
		
		return pokedexEntryList
	}
}