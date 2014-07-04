package cl.agj.core.net {
	import cl.agj.core.TidyListenerRegistrar;
	
	import com.codecatalyst.promise.Deferred;
	import com.codecatalyst.promise.Promise;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;

	public class ImageLoader extends TidyListenerRegistrar implements ILoader {
		
		/**
		 * @param url	A string or an array of strings (for multiple possible routes to the same image).
		 */
		public function ImageLoader(url:String, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null) {
			_url = url;
			_applicationDomain = applicationDomain;
			_securityDomain = securityDomain;
		}
		
		/////
		
		protected var _url:String;
		protected var _applicationDomain:ApplicationDomain;
		protected var _securityDomain:SecurityDomain;
		
		protected var _loader:Loader = new Loader;
		public function get loader():Loader {
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
					registerListener(_loader.contentLoaderInfo, ProgressEvent.PROGRESS, function (e:ProgressEvent):void {
						_progressed.dispatch(new GenericEvent);
					});
				}
			}
			return _progressed;
		}
		
		public function get progress():Number {
			return _finished ?
				1
				: _loader.contentLoaderInfo && _loader.contentLoaderInfo.bytesLoaded ?
					Math.min(1, _loader.contentLoaderInfo.bytesLoaded / _loader.contentLoaderInfo.bytesTotal)
					: 0
		}
		
		protected var _finished:Boolean;
		public function get finished():Boolean {
			return _finished;
		}
		
		/////
		
		protected function startLoad():void {
			var deferred:Deferred = new Deferred;
			_result = deferred.promise;
			
			registerListenerOnce(_loader.contentLoaderInfo, Event.COMPLETE, function onLoaded(e:Event):void {
				finish();
				var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
				var isDomainRestricted:Boolean = !loaderInfo.childAllowsParent;
				var image:DisplayObject = !isDomainRestricted ? loaderInfo.content : loaderInfo.loader;
				var finalURL:String = loaderInfo.url;
				deferred.resolve( new ImageLoaderResult(image, _url, finalURL, isDomainRestricted) );
			});
			
			registerListenerOnce(_loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, onError);
			registerListenerOnce(_loader.contentLoaderInfo, SecurityErrorEvent.SECURITY_ERROR, onError);
			function onError(e:ErrorEvent):void {
				finish();
				deferred.reject(e);
			}
			
			var request:URLRequest = new URLRequest(_url);
			_loader.load(request, new LoaderContext(true, _applicationDomain, _securityDomain));
		}
		
		protected function finish():void {
			_finished = true;
			unregisterAllListeners();
		}
		
	}
}