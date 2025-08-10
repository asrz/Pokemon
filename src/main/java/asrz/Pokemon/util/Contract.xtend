package asrz.Pokemon.util

class Contract {
	
	def notNull(Object obj, String label) {
		if (obj === null) {
			throw new RuntimeException(label + " cannot be null")
		}
	}
}