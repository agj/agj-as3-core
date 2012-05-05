package cl.agj.core.net {
	
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.TidyEventDispatcher;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.osflash.signals.Signal;
	
	public class SimplePostSender extends TidyEventDispatcher {
		
		protected var _finished:Signal;
		
		protected var _url:String;
		protected var _vars:URLVariables;
		protected var _method:String;
		protected var _dataFormat:String;
		protected var _retries:uint;
		
		protected var _response:Object;
		
		public function SimplePostSender(url:String, urlVariables:URLVariables, retries:uint = 0, method:String = URLRequestMethod.POST, responseDataFormat:String = URLLoaderDataFormat.TEXT) {
			_finished = new Signal(Boolean, SimplePostSender, String);
			
			super();
			_url = url;
			_vars = urlVariables;
			_retries = retries;
			_method = method;
			_dataFormat = responseDataFormat;
			send();
		}
		
		protected function send():void {
			var request:URLRequest = new URLRequest(_url);
			request.data = _vars;
			request.method = _method;
			
			var loader:URLLoader = new URLLoader();
			loader = new URLLoader();
			loader.dataFormat = _dataFormat;
			registerListener(loader, Event.COMPLETE, onLoaded);
			registerListener(loader, IOErrorEvent.IO_ERROR, onLoadError);
			registerListener(loader, SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			
			loader.load(request);
		}
		
		///////
		
		public function get url():String {
			return _url;
		}
		
		public function get urlVariables():Object {
			return _vars;
		}
		
		public function get method():String {
			return _method;
		}
		
		public function responseDataFormat():String {
			return _dataFormat;
		}
		
		public function get response():Object {
			return _response;
		}
		
		/** Returns: success:Boolean, this:SimplePostSender, error:String */
		public function get finished():Signal {
			return _finished;
		}
		
		///////
		
		protected function onLoaded(e:Event):void {
			var loader:URLLoader = e.currentTarget as URLLoader;
			_response = loader.data;
			unregisterAllListeners(loader);
			_finished.dispatch(true, this, undefined);
		}
		
		protected function onLoadError(e:ErrorEvent):void {
			unregisterAllListeners(e.currentTarget as URLLoader);
			if (_retries > 0) {
				_retries--;
				send();
			} else {
				_finished.dispatch(false, this, e.text);
			}
		}
		
		/////
		
		override public function destroy():void {
			Destroyer.destroy([
				_finished
			]);
			_response = null;
			super.destroy();
		}
		
	}
}