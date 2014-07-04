package cl.agj.core.net {
	public class ResourceLoaderResult {
		
		public function ResourceLoaderResult(resource:Object, url:String) {
			_resource = resource;
			_url = url;
		}
		
		protected var _resource:Object;
		public function get resource():Object {
			return _resource;
		}
		
		protected var _url:String;
		public function get url():String {
			return _url;
		}
		
	}
}