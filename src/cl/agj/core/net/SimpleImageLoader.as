package cl.agj.core.net {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.osflash.signals.events.GenericEvent;
	
	public class SimpleImageLoader extends AbstractSimpleLoader {
		
		protected var _image:DisplayObject;
		protected var _finalURL:String;
		protected var _restrictedDomain:Boolean;
		protected var _loader:Loader;
		
		public function SimpleImageLoader(url:String, retries:uint = 0, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null) {
			super(url, retries, applicationDomain, securityDomain);
			load();
		}
		
		override protected function load():void {
			_loader = new Loader;
			var request:URLRequest = new URLRequest(url);
			registerListener(loader.contentLoaderInfo, Event.COMPLETE, onLoaded);
			registerListener(loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, onLoadError);
			registerListener(loader.contentLoaderInfo, SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			_loader.load(request, new LoaderContext(true, _applicationDomain, _securityDomain));
			//loader.load(request, new LoaderContext(true));
		}
		
		///////
		
		public function get loader():Loader {
			return _loader;
		}
		
		public function get finalURL():String {
			return _finalURL;
		}
		
		public function get image():DisplayObject {
			return _image;
		}
		
		public function get restrictedDomain():Boolean {
			return _restrictedDomain;
		}
		
		///////
		
		override protected function onLoaded(e:Event):void {
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			_restrictedDomain = (!loaderInfo.childAllowsParent);
			if (!_restrictedDomain) {
				_image = loaderInfo.content;
			} else {
				_image = loaderInfo.loader;
			}
			_finalURL = loaderInfo.url;
			unregisterAllListeners(loaderInfo.loader);
			_success = true;
			_finished.dispatch(new GenericEvent());
			destroy();
		}
		
		override protected function onLoadError(e:ErrorEvent):void {
			unregisterAllListeners(e.currentTarget.loader);
			if (_retries > 0) {
				_retries--;
				load();
			} else {
				_error = e;
				_finished.dispatch(new GenericEvent);
				destroy();
			}
		}
		
	}
}