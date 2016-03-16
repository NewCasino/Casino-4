package com.shurba.lobby {
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;	
	import flash.events.MouseEvent;
	import flash.text.*;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ToggleButton extends Sprite {
		
		[Embed(source = '../../../assets/menu_button.png')]
		public var NormalState:Class;
		
		[Embed(source = '../../../assets/menu_button_hit.png')]
		public var HitState:Class;
		
		[Embed(source = '../../../assets/menu_button_toggle.png')]
		public var ToggleState:Class;
		
		public var label:TextField = new TextField();
		
		public var normalState:Bitmap;
		public var hitState:Bitmap;
		public var toggleState:Bitmap;
		
		private var _toggled:Boolean = false;
		
		public var index:int;
		
		private var tweenTimeline:TimelineLite = new TimelineLite();
		
		public function ToggleButton() {
			super();
			normalState = new NormalState();
			hitState = new HitState();
			toggleState = new ToggleState();
			
			this.addChild(normalState);
			this.addChild(hitState);
			this.addChild(toggleState);
			
			this.addChild(label);
			
			var tf:TextFormat = new TextFormat("Arial", 16, 0xffffff);
			tf.align = TextFormatAlign.CENTER;
			label.defaultTextFormat = tf;
			
			label.multiline = false;
			label.width = this.width;			
			label.y = 10;//(this.height - label.height) / 2;
			label.height = label.textHeight + 26;
			label.mouseEnabled = false;
			
			hitState.alpha = 0;
			toggleState.alpha = 0;
			
			this.buttonMode = true;
			
			this.addListeners();
		}
		
		public function addListeners():void {
			//this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			//this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}
		
		public function removeListeners():void {
			//this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			
		}
		
		private function mouseDownHandler(e:MouseEvent):void {		
			
		}
		
		private function switchToggle():void {
			if (tweenTimeline) {
				tweenTimeline.clear();
			}
			tweenTimeline = new TimelineLite();
			
			if (_toggled) {
				var tweens:Array = [];
				
				tweens.push(new TweenLite(hitState, 0.4, { alpha:1 } ));
				tweens.push(new TweenLite(normalState, 0.1, { alpha:0 } ));
				tweens.push(new TweenLite(toggleState, 0.5, { alpha:1 } ));
				
				tweenTimeline.insertMultiple(tweens, 0, TweenAlign.SEQUENCE, 0);
				tweenTimeline.play();
			} else {
				hitState.alpha = 0;
				normalState.alpha = 1;
				TweenLite.to(toggleState, 0.5, { alpha:0 } );
			}
		}
		
		public function get toggled():Boolean { 
			return _toggled; 
		}
		
		public function set toggled(value:Boolean):void {
			_toggled = value;
			this.switchToggle();
		}
		
	}

}