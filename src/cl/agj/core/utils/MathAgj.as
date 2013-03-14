package cl.agj.core.utils {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author agj
	 */
	public class MathAgj {
		
		public static function random(maxValue:Number):int {
			return Math.floor(Math.random() * maxValue);
		}
		
		/**
		 * Returns either a 1 or a -1 integer, randomly.
		 */
		public static function randomSign(chance:Number = 0.5):int {
			return (Math.random() < chance) ? 1 : -1;
		}
		
		/**
		 * Returns either true or false, randomly.
		 * 
		 * @param chance	The higher the number, the better the chance that it will return 'true'.
		 */
		public static function tossCoin(chance:Number = 0.5):Boolean {
			return (Math.random() < chance);
		}
		
		public static function abs(a:Number):Number {
			return (a >= 0) ? a : -a;
		}
		
		public static function isEven(num:int):Boolean {
			return (abs(num) % 2 === 0);
		}
		
		/**
		 * Simple linear interpolation between two values.
		 * @param	fraction	Number between 0 and 1 that indicates how close to <pre>endValue</pre> the returned value should be.
		 * @param	startValue	Value if <pre>fraction</pre> is 0.
		 * @param	endValue	Value if <pre>fraction</pre> is 1.
		 * @return
		 */
		public static function interpolate(fraction:Number, startValue:Number, endValue:Number):Number {
			if (isNaN(fraction)) fraction = 0;
			return startValue + fraction * (endValue - startValue);
		}
		
		public static function degToRad(degrees:Number):Number {
			return degrees * Math.PI / 180;
		}
		
		public static function radToDeg(radians:Number):Number {
			return radians * 180 / Math.PI;
		}
		
		public static function zeroPad(num:int, digits:uint):String {
			var numStr:String = num.toString();
			var minus:String = "";
			if (num < 0) {
				minus = "-";
				numStr = numStr.substr(1);
			}
			while (numStr.length < digits) {
				numStr = "0" + numStr;
			}
			return minus + numStr;
		}
		
		/**
		 * Returns a number between 0 and ''peak'' in an exponential curve. Useful for calculating position and scale according to perspective.
		 * ''value'' should identify the distance of the object from the 'camera', and ''gentleness'' is a constant that alters the depth perception.
		 * @param	value			The variable value. The closer it is to 0, the closer to the peak.
		 * @param	gentleness		A number equal to or greater than 1, indicating the gentleness (length) of the curve.
		 * 							The lower this value, the steeper the curve.
		 * @param	peak			Peak of the curve, returned for a ''value'' of 0 (or ''valueSubstract'', if used).
		 * @param	valueSubstract	Substracted from the ''value''. Curve will peak at a ''value'' equal to or lower than this number.
		 * @return					A number between 0 (or ''valueSubstract'') and ''peak''.
		 */
		public static function curve(value:Number, gentleness:Number, peak:Number = 1, valueSubstract:Number = 0):Number {
			if (valueSubstract)
				value = Math.max(value - valueSubstract, 0);
			if (gentleness < 1)
				gentleness = 1;
			return peak / ((value / gentleness) +1);
		}
		
		/**
		 * Returns a curve that allows for scaling
		 */
		public static function fractalCurve(value:Number, gentleness:Number):Number {
			return Math.pow(gentleness, -value);
		}
		
		/**
		 * Sine function.
		 * @param	time		Time (variable).
		 * @param	amplitude	Maximum amplitude of the movement.
		 * @param	frequency	How many oscillations occur in a unit of time (radians per second).
		 * @param	phase		Time start offset (positive values represent a delay).
		 * @return				
		 */
		public static function sine(time:Number, amplitude:Number = 100, frequency:Number = 0.1, phase:Number = 0):Number {
			return amplitude * Math.sin((frequency * time) + phase);
		}
		
		public static function rotatePoint(point:Point, radians:Number = 0, returnNewPoint:Boolean = false):Point {
			if (returnNewPoint)
				point = point.clone();
			
			if (radians === 0)
				return point;
			
			var angle:Number = cartesianToRadians(point.x, point.y); //Math.atan2(pt.y, pt.x);
			if (isNaN(angle))
				angle = 0;
			var rotated:Point = Point.polar(point.length, angle + radians);
			point.x = rotated.x;
			point.y = rotated.y;
			return point;
		}
		
		public static function cartesianToRadians(xOrPoint:Object, y:Number = NaN):Number {
			if (xOrPoint is Point)
				return Math.atan2(xOrPoint.y, xOrPoint.x);
			return Math.atan2(y, Number(xOrPoint));
		}
		
		/** This is geometrically incorrect. */
		public static function polygonCenter(... points):Point {
			if (points.length < 2) {
				if (points.length == 1 && points[0] is Point)
					return points[0];
				else
					return null;
			}
			
			var r:Point = new Point;
			var p:Point, p2:Point;
			var total:uint = points.length;
			var len:uint = total - 1;
			for (var i:int = 0; i < len; i++) {
				p = points[i];
				p2 = points[i+1];
				
				r.x += (p.x + p2.x) * 0.5;
				r.y += (p.y + p2.y) * 0.5;
			}
			r.x /= len;
			r.y /= len;
			
			return r;
		}
		
		public static function triangleCenter(p1:Point, p2:Point, p3:Point):Point {
			var mid:Point = interPoint(p1, p2);
			var r:Point = interPoint(p3, mid, 2/3);
			return r;
		}
		
		/** Isn't this a repeat of Point.interpolate? */
		public static function interPoint(pt1:Point, pt2:Point, fractionFromPt1:Number = 0.5):Point {
			var r:Point = pt1.clone();
			r.x -= pt2.x; r.y -= pt2.y;
			r.normalize(r.length * (1 - fractionFromPt1));
			r.x += pt2.x; r.y += pt2.y;
			return r;
		}
		
		public static function enforceRange(num:Number, min:Number, max:Number):Number {
			if (min > max) {
				var temp:Number = min;
				min = max;
				max = temp;
			}
			if (num < min)
				return min;
			if (num > max)
				return max;
			return num;
		}
		
		public static function getDifference(a:Number, b:Number):Number {
			return (a > b) ? a - b : b - a;
		}
		
		public static function logBase(base:Number, x:Number):Number {
			return Math.log(x) / Math.log(base);
		}
		
		public static function root(n:Number, x:Number):Number {
			return Math.pow(x, 1 / n);
		}
		
		static public const TAU:Number = Math.PI * 2;
		/*
		protected static var _tau:Number;
		public static function get TAU():Number {
			if (!_tau)
				_tau = Math.PI * 2;
			return _tau;
		}
		//*/
		
		protected static var _halfPi:Number;
		public static function get HALF_PI():Number {
			if (!_halfPi)
				_halfPi = Math.PI * 0.5;
			return _halfPi;
		}
		
	}
	
}