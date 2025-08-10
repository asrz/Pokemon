package asrz.Pokemon.service

import asrz.Pokemon.application.Context

abstract class BaseService {
	
	Context context
	
	new(Context context) {
		this.context = context
	}
	
	
	protected def getC() {
		return context 
	}
	
	protected def getDatabase() {
		return context.database
	}
	
	protected def getPlayer() {
		return context.player
	}
	
}