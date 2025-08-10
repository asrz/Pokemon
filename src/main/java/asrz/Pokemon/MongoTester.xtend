package asrz.Pokemon

import asrz.Pokemon.pokeAPI.model.pokemon.PokemonDAO
import com.mongodb.ConnectionString
import com.mongodb.MongoClientSettings
import com.mongodb.client.MongoClient
import com.mongodb.client.MongoClients
import com.mongodb.client.MongoCollection
import com.mongodb.client.MongoDatabase
import org.bson.codecs.configuration.CodecRegistries
import org.bson.codecs.configuration.CodecRegistry
import org.bson.codecs.pojo.PojoCodecProvider

import static com.mongodb.client.model.Filters.eq

class MongoTester {
	
	def static void main(String[] args) {
		val ConnectionString connectionString = new ConnectionString("mongodb://localhost:27017/")
		val CodecRegistry pojoRegistry = CodecRegistries.fromProviders(PojoCodecProvider.builder().automatic(true).build())
		val CodecRegistry codecRegistry = CodecRegistries.fromRegistries(MongoClientSettings.defaultCodecRegistry, pojoRegistry)
		val MongoClientSettings clientSettings = MongoClientSettings.builder().applyConnectionString(connectionString).codecRegistry(codecRegistry).build()
		
		try (val MongoClient mongoClient = MongoClients.create(clientSettings)) {
			val MongoDatabase database = mongoClient.getDatabase("PokeAPI");
			val MongoCollection<PokemonDAO> collection = database.getCollection("pokemon", PokemonDAO)
			
			val bulbasaurDocument = collection.find(eq("id", 1)).first()
			
			bulbasaurDocument.moves
				.filter[versionGroupDetails.findFirst[moveLearnMethod.name == 'level_up' && levelLearnedAt > 0] !== null]
				.sortBy[versionGroupDetails.minBy[levelLearnedAt].levelLearnedAt]
				.forEach[move | println(move.move.name)]
			
		}
	}
}