package asrz.Pokemon.util

import org.junit.jupiter.api.Test
import static org.junit.jupiter.api.Assertions.assertTrue

class UtilTest {
	
	@Test
	def test_randomInt() {
		for (var i = 1; i < 10; i++) {
			assertTrue([(1..3).contains(Util.randomInt(1,3))])
		}
	}
}