package cl.agj.core.net {
	import cl.agj.core.TidyListenerRegistrar;
	
	import com.codecatalyst.promise.Deferred;
	import com.codecatalyst.promise.Promise;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;
	
	public class ResourceLoader extends TidyListenerRegistrar implements ILoader {
		
		public function ResourceLoader(url:String) {
			_url = url;
		}
		
		protected var _url:String;
		
		protected var _loader:URLLoader = new URLLoader;
		public function get loader():URLLoader {
			return _loader;
		}
		
		protected var _result:Promise;
		public function get result():Promise {
			if (!_result) startLoad();
			return _result;
		}
		
		protected var _progressed:DeluxeSignal;
		public function get progressed():DeluxeSignal {
			if (!_progressed) {
				_progressed = new DeluxeSignal();
				if (!_finished) {
					registerListener(_loader, ProgressEvent.PROGRESS, function (e:ProgressEvent):void {
						_progressed.dispatch(new GenericEvent);
					});
				}
			}
			return _progressed;
		}
		
		public function get progress():Number {
			return _finished ?
				1
				: _loader.bytesTotal ?
					Math.min(1, _loader.bytesLoaded / _loader.bytesTotal)
					: 0;
		}
		
		protected var _finished:Boolean;
		public function get finished():Boolean {
			return false;
		}
		
		/////
		
		protected function startLoad():void {
			var deferred:Deferred = new Deferred;
			_result = deferred.promise;
			
			registerListenerOnce(_loader, Event.COMPLETE, function onLoaded(e:Event):void {
				finish();
				var resource:Object = _loader.data;
				deferred.resolve( new ResourceLoaderResult(resource, _url) );
			});
			
			registerListenerOnce(_loader, IOErrorEvent.IO_ERROR, onError);
			registerListenerOnce(_loader, SecurityErrorEvent.SECURITY_ERROR, onError);
			function onError(e:ErrorEvent):void {
				finish();
				deferred.reject(e);
			}
			
			var request:URLRequest = new URLRequest(_url);
			_loader.load(request);
		}
		
		protected function finish():void {
			_finished = true;
			unregisterAllListeners();
		}
		
	}
}