package cl.agj.core.utils {
	
	public class StringUtil {
		
		/**
		 * @param index		A negative value removes all occurrences of 'pattern'.
		 */
		public static function remove(string:String, pattern:String, index:int = -1):String {
			var start:int = string.indexOf(pattern, Math.max(0, index));
			if (start < 0)
				return string;
			var end:uint = start + pattern.length;
			var result:String = string.substring(0, start) + string.substring(end);
			
			if (index < 0)
				return remove(result, pattern, -1);
			return result;
		}
		
		public static function getSimulatedText(wordCount:uint):String {
			var text:String = "";
			while (wordCount > 0) {
				if (text.length > 0) text += " ";
				text += getSimulatedWord();
				wordCount--;
			}
			
			return text;
		}
		
		public static function getSimulatedWord(wordLength:uint = 0):String {
			if (wordLength == 0)
				wordLength = MathAgj.random(20) + 1;
			
			var text:String = "";
			var letters:String = "abcdefghijklmnopqrstuvwxyz";
			while (wordLength > 0) {
				text += letters.charAt(MathAgj.random(letters.length));
				wordLength--;
			}
			
			return text;
		}
		
	}
}