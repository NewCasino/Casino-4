package com.shurba {
	import com.greensock.easing.Expo;
	import com.greensock.TweenNano;
	import flash.display.MovieClip;
	import flash.display.Sprite;	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		public static const LINK_1:String = 'http://yahoo.com';
		public static const LINK_2:String = 'http://google.com';
		
		public var rotatingPic1Holder_mc:Sprite;
		public var rotatingPic2Holder_mc:Sprite;
		public var rotatingPic3Holder_mc:MovieClip;
		public var content1_mc:Sprite;
		public var content2_mc:Sprite;
		
		public var topSlider_mc:Sprite;
		public var bottomSlider_mc:Sprite;
		
		private var tween1:TweenNano;
		private var tween2:TweenNano;
		
		private var timerOpen:Timer = new Timer(3000);
		private var timerClose:Timer = new Timer(3000);
		
		public function DocumentClass() {
			super();
			this.addListeners();
			content1_mc.mouseChildren = false;
			content1_mc.mouseEnabled = false;
			content2_mc.mouseChildren = false;
			content2_mc.mouseEnabled = false;
			
			rotatingPic1Holder_mc.buttonMode = true;
			rotatingPic2Holder_mc.buttonMode = true;
			
			this.openAdv();
		}
		
		private function addListeners():void {
			timerOpen.addEventListener(TimerEvent.TIMER, timerOpenHandler, false, 0, true);
			timerClose.addEventListener(TimerEvent.TIMER, timerCloseHandler, false, 0, true);
			
			rotatingPic1Holder_mc.addEventListener(MouseEvent.MOUSE_OVER, pic1OverHandler, false, 0, true);			
			rotatingPic2Holder_mc.addEventListener(MouseEvent.MOUSE_OVER, pic2OverHandler, false, 0, true);
			rotatingPic3Holder_mc.addEventListener(MouseEvent.MOUSE_OVER, pic3OverHandler, false, 0, true);
			rotatingPic1Holder_mc.addEventListener(MouseEvent.MOUSE_OUT, pic1OutHandler, false, 0, true);
			rotatingPic2Holder_mc.addEventListener(MouseEvent.MOUSE_OUT, pic2OutHandler, false, 0, true);
			rotatingPic3Holder_mc.addEventListener(MouseEvent.MOUSE_OUT, pic3OutHandler, false, 0, true);
			
			rotatingPic1Holder_mc.addEventListener(MouseEvent.CLICK, pic1ClickHandler, false, 0, true);
			rotatingPic2Holder_mc.addEventListener(MouseEvent.CLICK, pic2ClickHandler, false, 0, true);
		}
		
		private function openAdv():void {
			if (rotatingPic3Holder_mc.currentFrame == rotatingPic3Holder_mc.totalFrames) {
				rotatingPic3Holder_mc.gotoAndStop(1);
			} else {
				rotatingPic3Holder_mc.gotoAndStop(rotatingPic3Holder_mc.currentFrame + 1);
			}
			
			TweenNano.to(topSlider_mc, 1, {y:-topSlider_mc.height, ease:Expo.easeIn } );
			TweenNano.to(bottomSlider_mc, 1, { y:this.height, ease:Expo.easeIn } );
			
			timerClose.reset();
			timerClose.start();
			timerOpen.stop();
		}
		
		private function closeAdv():void {
			TweenNano.to(topSlider_mc, 1, {y:0, ease:Expo.easeIn } );
			TweenNano.to(bottomSlider_mc, 1, { y:149, ease:Expo.easeIn } );
			
			timerOpen.reset();
			timerOpen.start();
			timerClose.stop();
		}
		
		private function timerCloseHandler(e:TimerEvent):void {			
			this.closeAdv();
		}
		
		private function timerOpenHandler(e:TimerEvent):void {			
			this.openAdv();
		}
		
		private function pic2ClickHandler(e:MouseEvent):void {
			navigateToURL(new URLRequest(LINK_2), "_self");
		}
		
		private function pic1ClickHandler(e:MouseEvent):void {
			navigateToURL(new URLRequest(LINK_1), "_self");
		}
		
		private function pic3OutHandler(e:MouseEvent):void {
			
		}
		
		private function pic2OutHandler(e:MouseEvent):void {
			if (tween2) {
				tween2.kill();
			}
			
			tween2 = TweenNano.to(content2_mc, 1, { y:266, ease:Expo.easeOut } );
		}
		
		private function pic1OutHandler(e:MouseEvent):void {
			if (tween1) {
				tween1.kill();
			}
			tween1 = TweenNano.to(content1_mc, 1, { y:266, ease:Expo.easeOut } );
		}
		
		private function pic3OverHandler(e:MouseEvent):void {
			
		}
		
		private function pic2OverHandler(e:MouseEvent):void {
			if (tween2) {
				tween2.kill();
			}
			tween2 = TweenNano.to(content2_mc, 1, { y:26, ease:Expo.easeOut } );
		}
		
		private function pic1OverHandler(e:MouseEvent):void {
			if (tween1) {
				tween1.kill();
			}
			tween1 = TweenNano.to(content1_mc, 1, { y:26, ease:Expo.easeOut } );
		}
		
	}

}