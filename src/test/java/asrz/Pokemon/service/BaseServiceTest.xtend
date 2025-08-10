package asrz.Pokemon.service

import asrz.Pokemon.application.Context

class BaseServiceTest {
	
	Context context = new Context
	
	protected def getC() {
		return context
	}
}