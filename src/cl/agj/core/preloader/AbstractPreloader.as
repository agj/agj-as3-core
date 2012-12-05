package cl.agj.core.preloader {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * A class intended to be extended in order to make a preloader with. Has the basic necessary stuff already in place.
	 * @author agj
	 */
	public class AbstractPreloader extends MovieClip {
		
		/**
		 * Keeps track of load progress; 1 equals 100%.
		 */
		protected var _progress:Number;
		/**
		 * Important! Set this variable to the main class name ("Main" by default).
		 */
		protected var _mainClassName:String = "Main";
		
		protected var _lastByteCount:uint;
		
		public function AbstractPreloader() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		protected function onEnterFrame(e:Event):void {
			if (_lastByteCount != root.loaderInfo.bytesLoaded) {
				_lastByteCount = root.loaderInfo.bytesLoaded;
				_progress = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
				onProgress();
			}
			if (framesLoaded == totalFrames) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				stage.removeEventListener(Event.RESIZE, onStageResize);
				onLoaded();
			}
		}
		
		/**
		 * Called every time the progress amount changes.
		 */
		protected function onProgress():void { }
		
		protected function onStageResize(e:Event):void {
			
		}
		
		/**
		 * Called once the SWF has been fully loaded.
		 */
		protected function onLoaded():void {
			if (_mainClassName) {
				var mainClass:Class = Class(getDefinitionByName(_mainClassName));
				if (mainClass)
					addChild((new mainClass) as DisplayObject);
			}
		}
		
	}
}