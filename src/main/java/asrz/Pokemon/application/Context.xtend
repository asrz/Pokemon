package asrz.Pokemon.application

import asrz.Pokemon.controllers.views.BattleViewController
import asrz.Pokemon.controllers.views.IController
import asrz.Pokemon.controllers.views.MainViewController
import asrz.Pokemon.model.Player
import asrz.Pokemon.model.Pokedex
import asrz.Pokemon.model.mongo.CustomCodecProvider
import asrz.Pokemon.service.PlayerService
import asrz.Pokemon.service.PokemonService
import asrz.Pokemon.util.Database
import com.mongodb.ConnectionString
import com.mongodb.MongoClientSettings
import com.mongodb.client.MongoClient
import com.mongodb.client.MongoClients
import com.mongodb.client.model.Filters
import javafx.stage.Stage
import org.bson.codecs.configuration.CodecRegistries
import org.bson.codecs.configuration.CodecRegistry
import org.bson.codecs.pojo.PojoCodecProvider

class Context {
	
	MongoClient mongoClient
	
	public Database database
	public Player player
	
	public PokemonService pokemonService
	public PlayerService playerService
	
	public Stage mainStage
	public Stage battleStage
	public Stage otherStage
	
	public MainViewController mainViewController
	public BattleViewController battleViewController
	public IController otherController
	
	new() {
		val ConnectionString connectionString = new ConnectionString("mongodb://localhost:27017/")
		val CodecRegistry pojoRegistry = CodecRegistries.fromProviders(PojoCodecProvider.builder().automatic(true).build())
		val CodecRegistry customRegistry = CodecRegistries.fromProviders(new CustomCodecProvider)
		val CodecRegistry codecRegistry = CodecRegistries.fromRegistries(customRegistry, MongoClientSettings.defaultCodecRegistry, pojoRegistry)
		val MongoClientSettings clientSettings = MongoClientSettings.builder().applyConnectionString(connectionString).codecRegistry(codecRegistry).build()
		mongoClient = MongoClients.create(clientSettings)
		database = new Database(mongoClient.getDatabase("PokeAPI"), mongoClient.getDatabase("Pokemon"))
		pokemonService = new PokemonService(this)
		playerService = new PlayerService(this)
		
		//val kantoPokedexDao = database.getPokedexes(Filters.eq("name", "kanto")).first
		val pokedexes = database.getPokedexes(Filters.empty)
		player = new Player() => [
			it.pokedexes.addAll(pokedexes.map[pokedex | Pokedex.fromApi(pokedex, 'en')])
		]
	}
	
	def closeResources() {
		mongoClient.close
	}
	
	def hideAllStages() {
		if (mainStage !== null) {
			mainStage.hide()
		}
		if (battleStage !== null) {
			battleStage.hide()
		}
		if (otherStage !== null) {
			otherStage.hide()
		}
	}
	
}