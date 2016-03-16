package com.shurba.shopsite.view.component {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class SoundController extends MovieClip {
		
		private const SOUND_FADE_STEP:int = 5;
		
		public var btn:SimpleButton;		
		private var _soundOn:Boolean = true;
		
		private var soundTween:TweenLite;
		
		public function SoundController() {
			super();
			this.addListeners();
			this.soundOn = false;
		}
		
		private function addListeners():void {
			btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void {
			this.soundOn = !this.soundOn;
		}
		
		public function get soundOn():Boolean { 
			return _soundOn;
		}
		
		public function set soundOn(value:Boolean):void {			
			_soundOn = value;
			var st:SoundTransform = new SoundTransform();
			if (_soundOn) {
				this.gotoAndStop(1);
				soundTween = TweenLite.to(st, 0.5, {volume:1, onUpdate:applySoundTransform, onUpdateParams:[st]});				
			} else {
				this.gotoAndStop(2);
				soundTween = TweenLite.to(st, 0.5, {volume:0, onUpdate:applySoundTransform, onUpdateParams:[st]});
			}			
		}
		
		private function applySoundTransform(s:SoundTransform):void {
			SoundMixer.soundTransform = s;
		}
		
		private function enableSound():void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function disableSound():void {
			
		}
		
		private function enterFrameHandler(e:Event):void {			
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			//SoundMixer.soundTransform
		}
		
		
	}

}