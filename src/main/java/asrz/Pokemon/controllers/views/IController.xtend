package asrz.Pokemon.controllers.views

import asrz.Pokemon.application.Application

interface IController {
	
	def void initialize() {}
	
	def getC() {
		return Application.context 
	}
	
	def getDatabase() {
		return c.database
	}
	
	def getPlayer() {
		return c.player
	}
}
