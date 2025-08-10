package asrz.Pokemon.util

import java.util.Map
import java.util.UUID
import org.bson.BsonDocument
import org.bson.BsonDocumentWriter
import org.bson.BsonReader
import org.bson.BsonWriter
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext
import org.bson.BsonType
import org.bson.json.JsonReader
import java.util.HashMap
import org.bson.codecs.configuration.CodecConfigurationException

class MapCodec<K, T> implements Codec<Map<K, T>> {
	Class<Map<K, T>> encoderClass
	Codec<K> keyCodec
	Codec<T> valueCodec

	new(Class<Map<K, T>> encoderClass, Codec<K> keyCodec, Codec<T> valueCodec) {
		this.encoderClass = encoderClass
		this.keyCodec = keyCodec
		this.valueCodec = valueCodec
	}

	override void encode(BsonWriter writer, Map<K, T> map, EncoderContext encoderContext) {
		try (val dummyWriter = new BsonDocumentWriter(new BsonDocument())) {
			dummyWriter.writeStartDocument()
			writer.writeStartDocument()
			for (Map.Entry<K, T> entry : map.entrySet()) {
				var dummyId = UUID.randomUUID().toString()
				dummyWriter.writeName(dummyId)
				keyCodec.encode(dummyWriter, entry.getKey(), encoderContext)
				//TODO: could it be simpler by something like JsonWriter?
				writer.writeName(dummyWriter.getDocument().asDocument().get(dummyId).asString().getValue())
				valueCodec.encode(writer, entry.getValue(), encoderContext)
			}
			dummyWriter.writeEndDocument()
		}
		writer.writeEndDocument()
	}

	override Map<K, T> decode(BsonReader reader, DecoderContext context) {
		reader.readStartDocument()
		val Map<K, T> map = getInstance()
		while (reader.readBsonType() != BsonType.END_OF_DOCUMENT) {
			//TODO: what if the key is not a String aka not wrapped in double quotes?
			var nameReader = new JsonReader("{\"key:\":\"" + reader.readName() + "\"}")
			nameReader.readStartDocument()
			nameReader.readBsonType()
			if (reader.getCurrentBsonType() == BsonType.NULL) {
				map.put(keyCodec.decode(nameReader, context), null)
				reader.readNull()
			} else {
				map.put(keyCodec.decode(nameReader, context), valueCodec.decode(reader, context))
			}
			nameReader.readEndDocument()
		}
		reader.readEndDocument()
		return map
	}

	override Class<Map<K, T>> getEncoderClass() {
		return encoderClass
	}

	private def Map<K, T> getInstance() {
		if (encoderClass.isInterface()) {
			return new HashMap()
		}
		try {
			return encoderClass.getDeclaredConstructor().newInstance()
		} catch (Exception e) {
			throw new CodecConfigurationException(e.getMessage(), e)
		}
	}
}