package cl.agj.core.net {
	
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.events.GenericEvent;
	
	public class SimpleLoader extends AbstractSimpleLoader {
		
		protected var _data:Object;
		
		public function SimpleLoader(url:String, retries:uint = 0) {
			super(url, retries);
			load();
		}
		
		override protected function load():void {
			var loader:URLLoader = new URLLoader;
			var request:URLRequest = new URLRequest(_url);
			registerListener(loader, Event.COMPLETE, onLoaded);
			registerListener(loader, IOErrorEvent.IO_ERROR, onLoadError);
			registerListener(loader, SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			loader.load(request);
		}
		
		///////
		
		public function get data():Object {
			return _data;
		}
		
		///////
		
		override protected function onLoaded(e:Event):void {
			var loader:URLLoader = e.currentTarget as URLLoader;
			_data = loader.data;
			unregisterAllListeners(loader);
			_success = true;
			_finished.dispatch(new GenericEvent());
			destroy();
		}
		
		override protected function onLoadError(e:ErrorEvent):void {
			unregisterAllListeners(e.currentTarget as URLLoader);
			if (_retries > 0) {
				_retries--;
				load();
			} else {
				_error = e;
				_finished.dispatch(new GenericEvent());
				destroy();
			}
		}
		
	}
}