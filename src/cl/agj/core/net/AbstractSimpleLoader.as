package cl.agj.core.net {
	
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.TidyListenerRegistrar;
	import cl.agj.extra.events.ChildSignal;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	
	public class AbstractSimpleLoader extends TidyListenerRegistrar {
		
		internal const CLASS_NAME:String = "cl.agj.utils::AbstractSimpleLoader";
		
		protected var _finished:DeluxeSignal;
		
		protected var _url:String;
		protected var _retries:uint;
		protected var _applicationDomain:ApplicationDomain;
		protected var _securityDomain:SecurityDomain;
		
		protected var _success:Boolean;
		protected var _error:ErrorEvent;
		
		public function AbstractSimpleLoader(url:String, retries:uint = 0, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null) {
			_finished = new DeluxeSignal(this);
			
			super();
			if (getQualifiedClassName(this) === CLASS_NAME) {
				throw new Error("This is an abstract class and is not meant for instantiation; it should only be extended.");
			}
			_url = url;
			_retries = retries;
			_applicationDomain = applicationDomain;
			_securityDomain = securityDomain;
		}
		
		protected function load():void {
			
		}
		
		protected function onLoaded(e:Event):void {
			
		}
		
		protected function onLoadError(e:ErrorEvent):void {
			
		}
		
		/////
		
		public function get url():String {
			return _url;
		}
		
		public function get success():Boolean {
			return _success;
		}
		
		public function get error():ErrorEvent {
			return _error;
		}
		
		/** Returns: event:GenericEvent */
		public function get finished():DeluxeSignal {
			return _finished;
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