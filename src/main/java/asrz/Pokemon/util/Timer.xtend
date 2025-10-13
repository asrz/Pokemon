package asrz.Pokemon.util

class Timer {
	
	Long start
	Long lastStep
	String prefix
	
	new() {
		this("")
	}
	
	new(String prefix) {
		this.prefix = prefix
		this.start = System.currentTimeMillis
		this.lastStep = this.start
	}
	
	def void endStep(String message, Object...args) {
		val time = System.currentTimeMillis - lastStep
		println(String.format("%s: %s %d ms", prefix, String.format(message, args), time))
	}
}