package cl.agj.core.net {
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;
	
	public class SimpleLoader extends AbstractSimpleLoader {
		
		public function SimpleLoader(url:String, retries:uint = 0) {
			super(url, retries);
			load();
		}
		
		override protected function load():void {
			_loader = new URLLoader;
			var request:URLRequest = new URLRequest(_url);
			registerListener(_loader, Event.COMPLETE, onLoaded);
			registerListener(_loader, IOErrorEvent.IO_ERROR, onLoadError);
			registerListener(_loader, SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			_loader.load(request);
		}
		
		///////
		
		protected var _loader:URLLoader;
		
		protected var _data:Object;
		public function get data():Object {
			return _data;
		}
		
		override public function get progress():Number {
			return _data ? 1 : _loader ? _loader.bytesTotal ? _loader.bytesLoaded / _loader.bytesTotal : 0 : 0;
		}
		
		override public function get progressed():DeluxeSignal {
			if (!_progressed && _loader) {
				registerListener(_loader, ProgressEvent.PROGRESS, onProgress);
			}
			return super.progressed;
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
		
		/////
		
		override public function destroy():void {
			_loader = null;
			super.destroy();
		}
		
	}
}