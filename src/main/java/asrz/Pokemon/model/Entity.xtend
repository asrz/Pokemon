package asrz.Pokemon.model

import asrz.Pokemon.pokeAPI.annotations.MongoPojo
import org.bson.codecs.pojo.annotations.BsonProperty
import org.bson.types.ObjectId

@MongoPojo
abstract class Entity {
	
	
	@BsonProperty("_id")
	ObjectId id = ObjectId.get
	
	
	def String getCollectionName()
}