package cl.agj.core.media {
	
	import cl.agj.core.utils.Destroyer;
	import cl.agj.core.TidyListenerRegistrar;
	
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SFX extends TidyListenerRegistrar {
		
		/** Default: false */
		public var multiplay:Boolean;
		
		protected var _sound:Sound;
		protected var _channel:SoundChannel;
		protected var _transform:SoundTransform;
		
		protected var _volume:Number;
		
		protected var _tween:TweenLite;
		
		public function SFX(sound:Object) {
			super();
			
			if (!sound || (!(sound is Sound) && !(sound is Class)))
				throw new Error("SFX: sound parameter must be non null, and must be of type Sound or Class.");
			
			if (sound is Sound) {
				_sound = Sound(sound);
			} else if (sound is Class) {
				_sound = new sound;
			}
			
			_volume = 1;
		}
		
		/////
		
		public function play(start:uint = 0):void {
			if (_sound) {
				stop();
				_channel = _sound.play(start, 0, _transform);
				if (_channel) {
					registerListenerOnce(_channel, Event.COMPLETE, onChannelComplete);
				}
			}
		}
		
		public function stop():void {
			if (_channel) {
				unregisterListener(_channel, Event.COMPLETE, onChannelComplete);
				if (!multiplay)
					_channel.stop();
				if (_tween)
					_tween.complete();
			}
		}
		
		public function fade(time:Number = 1, targetVolume:Number = 0):void {
			if (_tween)
				_tween.complete();
			_tween = new TweenLite(this, time, { volume: targetVolume, onComplete: onTweenComplete, onCompleteParams: [_volume] } );
		}
		
		/////
		
		public function get volume():Number {
			return _volume;
		}
		public function set volume(value:Number):void {
			if (isNaN(value))
				_volume = 0;
			else {
				_volume = Math.max(value, 0);
			}
			
			if (!_transform)
				_transform = new SoundTransform();
			_transform.volume = _volume;
			if (!multiplay && _channel)
				_channel.soundTransform = _transform;
		}
		
		public function get length():Number {
			return _sound.length;
		}
		
		public function get position():Number {
			if (_channel)
				return _channel.position;
			else
				return 0;
		}
		
		public function get playing():Boolean {
			return (_channel != null);
		}
		
		/////
		
		protected function onChannelComplete(e:Event):void {
			_channel = null;
		}
		
		protected function onTweenComplete(originalVolume:Number):void {
			stop();
			_tween = null;
			volume = originalVolume;
		}
		
		/////
		
		override public function destroy():void {
			stop();
			_sound = null;
			_channel = null;
			_transform = null;
			_tween = null;
			super.destroy();
		}
		
	}
}