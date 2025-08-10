package asrz.Pokemon.model.interfaces

import org.bson.codecs.pojo.annotations.BsonIgnore

interface ILabeled {
	@BsonIgnore
	def String getLabel()
	
}