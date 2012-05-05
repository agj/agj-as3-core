package cl.agj.core.utils 
{
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author agj
	 */
	public class Sitelock {
		
		public static function isAllowedSite(stageObject:Stage, urls:Vector.<String>):Boolean {
			var currUrl:String = stageObject.loaderInfo.url.toLowerCase();
			var isAllowed:Boolean = false;
			
			for each (var url:String in urls) {
				if (currUrl.indexOf(url) >= 0) isAllowed = true;
			}
			
			return isAllowed;
		}
		
	}
	
}