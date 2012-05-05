package cl.agj.core.preloader {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	
	/**
	 * Example implementation of the AbstractPreloader class. Extend and define certain protected
	 * variables in the constructor (before calling super()) in order to customize dimensions and colors.
	 * 
	 * @author agj
	 */
	public class BarPreloader extends AbstractPreloader {
		
		/** Color of the filled bar and its outline. */
		protected var _color:uint = 0x999999;
		/** Color of the empty bar. */
		protected var _backColor:uint = 0x000000;
		/** Width of the bar. */
		protected var _barWidth:Number = 100;
		/** Tallness of the bar. */
		protected var _barHeight:Number = 10;
		/** Thickness of the outline of the bar. */
		protected var _lineThickness:Number = 2;
		
		protected var _rect:Rectangle;
		protected var _back:Shape;
		protected var _bar:Shape;
		
		public function BarPreloader() {
			super();
		}
		
		override protected function init(e:Event=null):void {
			_back = new Shape;
			addChild(_back);
			drawBackground();
			
			_bar = new Shape;
			addChild(_bar);
			
			_rect = new Rectangle;
			_rect.width = _barWidth;
			_rect.height = _barHeight;
			resizeRectangle();
			
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			this.contextMenu = cm;
			
			super.init(e);
		}
		
		override protected function onProgress():void {
			drawProgress(_progress);
		}
		
		protected function drawProgress(progress:Number):void {
			var g:Graphics = _bar.graphics;
			g.clear();
			
			var distance:Number = _rect.width * 2 * progress;
			
			g.beginFill(_color);
			g.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
			g.drawRect(_rect.x - _lineThickness, _rect.y - _lineThickness, _rect.width + _lineThickness * 2, _rect.height + _lineThickness * 2);
			g.endFill();
			
			g.beginFill(_color);
			g.drawRect(_rect.x, _rect.y, _rect.width * progress, _rect.height);
			g.endFill();
		}
		
		override protected function onStageResize(e:Event):void {
			resizeRectangle();
			drawBackground();
			drawProgress(_progress);
		}
		
		override protected function onLoaded():void {
			removeChild(_back);
			removeChild(_bar);
			super.onLoaded();
		}
		
		/////
		
		protected function drawBackground():void {
			_back.graphics.clear();
			_back.graphics.beginFill(_backColor);
			_back.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_back.graphics.endFill();
		}
		
		protected function resizeRectangle():void {
			_rect.x = uint(stage.stageWidth / 2 - _rect.width / 2);
			_rect.y = uint(stage.stageHeight / 2 - _rect.height / 2);
		}
		
	}
}