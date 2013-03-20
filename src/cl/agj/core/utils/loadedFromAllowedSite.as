package cl.agj.core.utils {
	import flash.display.Stage;
	
	public static function loadedFromAllowedSite(stage:Stage, allowedURLs:Vector.<String>):Boolean {
		var currUrl:String = stage.loaderInfo.url.toLowerCase();
		
		for each (var url:String in allowedURLs) {
			if (currUrl.indexOf(url) >= 0)
				return true;
		}
		return false;
	}
	
}