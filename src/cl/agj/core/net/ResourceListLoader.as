package cl.agj.core.net {
	
	import cl.agj.core.Destroyable;
	import cl.agj.core.utils.Destroyer;
	
	import flash.events.ErrorEvent;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;
	
	public class ResourceListLoader extends Destroyable {
		
		protected var _finished:DeluxeSignal;
		
		protected var _urls:Vector.<String>;
		protected var _finalURLs:Vector.<String>;
		protected var _retries:uint;
		protected var _resources:Array;
		protected var _done:Vector.<Boolean>;
		
		protected var _success:Boolean;
		protected var _errors:Vector.<ErrorEvent>;
		
		public function ResourceListLoader(urls:Vector.<String> = null, retries:uint = 0) {
			_finished = new DeluxeSignal(this);
			
			super();
			_retries = retries;
			_errors = new Vector.<ErrorEvent>(urls.length);
			setURLs(urls);
			load();
		}
		
		protected function load():void {
			var ext:String, sl:SimpleLoader, sbl:SimpleImageLoader;
			for each (var url:String in _urls) {
				ext = url.substr(-3);
				if (ext == "swf" ||　ext == "jpg" || ext == "gif" || ext == "png") {
					sbl = new SimpleImageLoader(url, _retries);
					sbl.finished.add(onFinished);
				} else {
					sl = new SimpleLoader(url, _retries);
					sl.finished.add(onFinished);
				}
			}
		}
		
		///////
		
		protected function setURLs(list:Vector.<String>):void {
			_urls = list;
			_finalURLs = _urls.concat();
			
			if (!_urls || _urls.length == 0)
				_resources = [];
			else
				_resources = new Array(_urls.length);
			
			_done = new Vector.<Boolean>(_urls.length, true);
		}
		
		protected function checkLoad():void {
			var success:Boolean = true;
			var count:int = 0;
			var len:uint = _urls.length;
			for (var i:int = 0; i < len; i++) {
				if (_done[i])
					count++;
				if (!_resources[i])
					success = false;
			}
			
			if (count === len) {
				_success = success;
				finished.dispatch(new GenericEvent());
				destroy();
			}
		}
		
		///////
		
		/** An array of the loaded objects. */
		public function get resources():Array {
			return _resources;
		}
		
		public function get urls():Vector.<String> {
			return _urls;
		}
		
		public function get finalURLs():Vector.<String> {
			return _finalURLs;
		}
		
		public function get success():Boolean {
			return _success;
		}
		
		public function get errors():Vector.<ErrorEvent> {
			return _errors;
		}
		
		/** Returns: event:GenericEvent */
		public function get finished():DeluxeSignal {
			return _finished;
		}
		
		///////
		
		protected function onFinished(event:GenericEvent):void {
			var loader:AbstractSimpleLoader = AbstractSimpleLoader(event.target);
			var index:int = _urls.indexOf(loader.url);
			
			if (loader.success) {
				if (loader is SimpleLoader) {
					_resources[index] = SimpleLoader(loader).data;
				} else if (loader is SimpleImageLoader) {
					_resources[index] = SimpleImageLoader(loader).image;
					_finalURLs[index] = SimpleImageLoader(loader).finalURL;
				}
			} else {
				_errors[index] = loader.error;
			}
			
			_done[index] = true;
			
			checkLoad();
		}
		
		/////
		
		override public function destroy():void {
			super.destroy();
			Destroyer.destroy([
				_finished
			]);
			_finished = null;
		}
		
	}
}