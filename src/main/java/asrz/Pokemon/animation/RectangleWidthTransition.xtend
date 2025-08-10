package asrz.Pokemon.animation

import javafx.animation.Transition
import javafx.scene.shape.Rectangle
import javafx.util.Duration
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RectangleWidthTransition extends Transition {
	
	Rectangle rectangle
	Duration duration
	double fromWidth
	double toWidth
	
	new(Duration duration) {
		cycleDuration = duration
	}
	
	override protected interpolate(double frac) {
		rectangle.width = fromWidth - (fromWidth - toWidth) * frac
	}
	
}