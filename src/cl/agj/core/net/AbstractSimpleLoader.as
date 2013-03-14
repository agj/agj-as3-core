package cl.agj.core.net {
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.getQualifiedClassName;
	
	import cl.agj.core.TidyListenerRegistrar;
	import cl.agj.core.utils.Destroyer;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.events.GenericEvent;
	
	public class AbstractSimpleLoader extends TidyListenerRegistrar {
		
		internal const CLASS_NAME:String = "cl.agj.utils::AbstractSimpleLoader";
		
		public function AbstractSimpleLoader(url:String, retries:uint = 0, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null) {
			if (getQualifiedClassName(this) === CLASS_NAME) {
				throw new Error("This is an abstract class and is not meant for instantiation; it should only be extended.");
			}
			_url = url;
			_retries = retries;
			_applicationDomain = applicationDomain;
			_securityDomain = securityDomain;
		}
		
		/////
		
		protected var _url:String;
		protected var _retries:uint;
		protected var _applicationDomain:ApplicationDomain;
		protected var _securityDomain:SecurityDomain;
		
		protected var _success:Boolean;
		protected var _error:ErrorEvent;
		
		public function get url():String {
			return _url;
		}
		
		public function get success():Boolean {
			return _success;
		}
		
		public function get error():ErrorEvent {
			return _error;
		}
		
		public function get progress():Number {
			return 0;
		}
		
		protected var _progressed:DeluxeSignal;
		public function get progressed():DeluxeSignal {
			return _progressed || (_progressed = new DeluxeSignal(this));
		}
		
		protected var _finished:DeluxeSignal = new DeluxeSignal(this);
		public function get finished():DeluxeSignal {
			return _finished;
		}
		
		/////
		
		protected function load():void {
			
		}
		
		protected function onProgress(e:ProgressEvent):void {
			if (_progressed)
				_progressed.dispatch(new GenericEvent);
		}
		
		protected function onLoaded(e:Event):void {
			
		}
		
		protected function onLoadError(e:ErrorEvent):void {
			
		}
		
		/////
		
		override public function destroy():void {
			Destroyer.destroy([
				_finished,
				_progressed
			]);
			_finished = null;
			_progressed = null
			super.destroy();
		}
		
	}
}