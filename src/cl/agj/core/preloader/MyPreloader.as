package cl.agj.core.preloader {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	
	/**
	 * This is a simple but ready-to-use and nice-looking preloader.
	 * @author agj
	 */
	public class MyPreloader extends AbstractPreloader {
		
		protected var _fillColor:uint;
		protected var _voidColor:uint;
		protected var _backColor:uint;
		protected var _lineWidth:Number;
		protected var _rect:Rectangle;
		
		protected var _graphic:Shape;
		protected var _background:Shape;
		
		protected var _lastBytes:int;
		
		public function MyPreloader(mainClassName:String = "Main", rectangle:Rectangle = null) {
			if (rectangle)
				_rect = rectangle;
			else
				_rect = new Rectangle(0, 0, 50, 50);
			
			_fillColor = 0x000000;
			_voidColor = 0xffffff;
			_backColor = 0xf5f5f5;
			_lineWidth = 1;
			
			_background = new Shape;
			addChild(_background);
			_graphic = new Shape;
			addChild(_graphic);
			
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			this.contextMenu = cm;
			
			super();
			_mainClassName = mainClassName;
		}
		
		override protected function init(e:Event = null):void {
			super.init(e);
			
			stage.addEventListener(Event.RESIZE, onResize);
			
			updatePositions();
		}
		
		protected function updatePositions():void {
			_rect.x = Math.floor(stage.stageWidth / 2 - _rect.width / 2);
			_rect.y = Math.floor(stage.stageHeight / 2 - _rect.height / 2);
			
			_background.graphics.clear();
			_background.graphics.beginFill(_backColor);
			_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_background.graphics.endFill();
		}
		
		override protected function onProgress():void {
			drawProgress(_progress);
		}
		
		protected function drawProgress(progress:Number):void {
			var g:Graphics = _graphic.graphics;
			g.clear();
			
			var distance:Number = (_rect.width + _rect.height) * progress;
			
			g.lineStyle(_lineWidth, _fillColor);
			g.beginFill(_voidColor);
			g.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
			g.endFill();
			g.lineStyle();
			
			g.beginFill(_fillColor);
			g.moveTo(_rect.x, _rect.bottom);
			g.lineTo(_rect.x, _rect.bottom - Math.min(distance, _rect.height));
			if (distance > _rect.height) {
				g.lineTo(_rect.x + distance - _rect.height, _rect.y);
			}
			if (distance > _rect.width) {
				g.lineTo(_rect.right, _rect.bottom - (distance - _rect.width));
			}
			g.lineTo(_rect.x + Math.min(distance, _rect.width), _rect.bottom);
			g.lineTo(_rect.x, _rect.bottom);
			g.endFill();
		}
		
		override protected function onLoaded():void {
			stage.removeEventListener(Event.RESIZE, onResize);
			
			_graphic.graphics.clear();
			removeChild(_graphic);
			removeChild(_background);
			
			super.onLoaded();
		}
		
		protected function onResize(e:Event):void {
			updatePositions();
		}
		
	}

}