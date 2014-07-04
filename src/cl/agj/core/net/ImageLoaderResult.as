package cl.agj.core.net {
	import flash.display.DisplayObject;
	
	public class ImageLoaderResult {
		
		public function ImageLoaderResult(image:DisplayObject, url:String, finalURL:String, isDomainRestricted:Boolean) {
			_image = image;
			_url = url;
			_finalURL = finalURL;
			_isDomainRestricted = isDomainRestricted;
		}
		
		protected var _image:DisplayObject;
		public function get image():DisplayObject {
			return _image;
		}
		
		protected var _url:String;
		public function get url():String{
			return _url;
		}
		
		protected var _finalURL:String;
		public function get finalURL():String {
			return _finalURL;
		}
		
		protected var _isDomainRestricted:Boolean;
		public function get isDomainRestricted():Boolean {
			return _isDomainRestricted;
		}
		
	}
}