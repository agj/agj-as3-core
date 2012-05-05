package cl.agj.core.debugging {
	import cl.agj.core.TidyListenerRegistrar;
	import cl.agj.graphics.Draw;
	import cl.agj.graphics.DrawStyle;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author agj
	 */
	public class DebugConsole extends TidyListenerRegistrar implements IDebugConsole {
		
		private const _DEFAULT_TEXT:String = "~~ DEBUG CONSOLE ~~";
		
		public var graphic:Sprite;
		protected var _text:TextField;
		protected var stage:Stage;
		
		protected var _maxCharNumber:uint;
		protected var _directionUp:Boolean;
		
		public function DebugConsole(theStage:Stage, keyToggle:Boolean = true, directionUp:Boolean = true, maxCharNumber:uint = 10000) {
			_directionUp = directionUp;
			stage = theStage;
			_maxCharNumber = maxCharNumber;
			
			var format:TextFormat = new TextFormat("sans", 12, 0xffffff);
			format.leading = 10;
			
			_text = new TextField;
			_text.x = _text.y = 5;
			_text.width = theStage.stageWidth - 10;
			_text.height = theStage.stageHeight - 10;
			_text.multiline = true;
			_text.wordWrap = false;
			_text.defaultTextFormat = format;
			_text.text = _DEFAULT_TEXT;
			
			var background:Shape = new Shape;
			Draw.rectangle(background.graphics, new DrawStyle(0x000000, 0.7), new Rectangle(0, 0, theStage.stageWidth, theStage.stageHeight));
			
			graphic = new Sprite;
			graphic.addChild(background);
			graphic.addChild(_text);
			graphic.tabEnabled = false;
			graphic.tabChildren = false;
			
			if (keyToggle) {
				registerListener(theStage, KeyboardEvent.KEY_UP, keyUp);
			}
			
			Logger.logged.add(onLogged);
		}
		
		public function print(... text):void {
			/*var string:String = "";
			
			var len:int = text.length;
			for (var i:int = 0; i < len; i++) {
				string += text[i];
				if (i < len - 1)
					string += " ";
			}*/
			
			var string:String = text.join(" ");
			
			addLine(string);
			
			trace("[CONSOLE] " + string);
		}
		
		public function clear():void {
			_text.text = _DEFAULT_TEXT;
		}
		
		public function set visible(value:Boolean):void {
			if (value) {
				stage.addChild(graphic);
				stage.focus = graphic;
			} else if (graphic.parent) {
				graphic.parent.removeChild(graphic);
				if (stage.focus == graphic)
					stage.focus = null;
			}
		}
		public function get visible():Boolean {
			return (graphic.parent != null);
		}
		
		/////////////////////
		
		protected function addLine(string:String):void {
			if (_directionUp)
				_text.text = string + "\n" + _text.text;
			else {
				_text.appendText("\n" + string);
				_text.scrollV = _text.maxScrollV;
			}
			trim();
		}
		
		protected function trim():void {
			if (_text.length > _maxCharNumber)
				_text.text = _text.text.substr(0, _maxCharNumber);
		}
		
		/////////////////////
		
		protected function keyUp(e:KeyboardEvent):void {
			if (e.keyCode == 220 || e.keyCode == 192)
				visible = !visible;
		}
		
		protected function onLogged(className:String, message:String):void {
			addLine("[" + className + "] " + message);
		}
		
		/////////////////////
		
		override public function destroy():void {
			visible = false;
			stage = null;
			super.destroy();
		}
		
	}
	
}