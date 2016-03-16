package classes {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	 
	public class DocumentClass extends Sprite {
		
		private const IMAGE_AUTO_TRANSITION_TIME:int = 3000;
		private const TEXT_AUTO_TRANSITION_TIME:int = 250;
		
		private const TRANSITION_TIME:Number = 0.75;
		private const MIN_ALPHA:Number = 0;
		private const MAX_ALPHA:Number = 1;
		
		private var images:Array;
		private var texts:Array;
		
		public var btnLeft:Sprite;
		public var btnRight:Sprite;
		public var image0:Sprite;
		public var image1:Sprite;
		public var image2:Sprite;
		public var image3:Sprite;
		public var image4:Sprite;
		public var image5:Sprite;
		public var image6:Sprite;
		public var image7:Sprite;
		public var text0:Sprite;
		public var text1:Sprite;
		public var text2:Sprite;
		public var text3:Sprite;
		public var text4:Sprite;
		public var text5:Sprite;
		public var text6:Sprite;
		
		private var currentImage:Sprite;
		private var nextImage:Sprite;
		
		private var currentNum:int = 0;
		private var currentTextNum:int = 0;
		
		private var imageTimer:Timer;
		private var textTimer:Timer;
		
		public function DocumentClass() {
			this.createImagesArray();
			this.createTextsArray();
			currentNum = 0;
			this.hideAllExcept(currentNum);
			this.hideText();
			btnLeft.buttonMode = true;
			btnRight.buttonMode = true;
			btnLeft.visible = false;
			
			btnLeft.addEventListener(MouseEvent.CLICK, btnLeftClickHandler, false, 0, true);
			btnRight.addEventListener(MouseEvent.CLICK, btnRightClickHandler, false, 0, true);
			
			imageTimer = new Timer(IMAGE_AUTO_TRANSITION_TIME);
			imageTimer.addEventListener(TimerEvent.TIMER, imageTmerIntervalHandler, false, 0, true);
			
			textTimer = new Timer(TEXT_AUTO_TRANSITION_TIME);
			textTimer.addEventListener(TimerEvent.TIMER, textTimerIntervalHandler, false, 0, true);
			
			this.resetAndStartTimer();
			
		}
		
		private function textTimerIntervalHandler(e:TimerEvent):void {
			textTimer.stop();			
			TweenLite.to(texts[currentNum], 1.5, { alpha:MAX_ALPHA } );
		}
		
		private function imageTmerIntervalHandler(e:TimerEvent):void {
			if (currentNum == images.length) {
				return;
			}
			
			imageTimer.stop();
			this.btnRightClickHandler(null);
		}
		
		private function resetAndStartTimer():void {
			textTimer.reset();
			textTimer.start();
			imageTimer.reset();
			imageTimer.start();
		}
		
		private function createImagesArray():void {
			images = new Array();
			var name:String;
			for (var i:int = 0; i < 8; i++) {
				name = "image" + i.toString();
				images.push(this[name]);
			}
		}
		
		private function createTextsArray():void {
			texts = new Array();
			var name:String;
			for (var i:int = 0; i < 7; i++) {
				name = "text" + i.toString();
				texts.push(this[name]);
			}			
		}
		
		private function hideAllExcept($imageNum:int):void {
			for (var i:int = 0; i < images.length; i++) {
				if (i == $imageNum) {
					continue;
				}
				images[i].alpha = 0;
			}
		}
		
		private function hideText():void {
			for (var i:int = 0; i < texts.length; i++) {
				TweenLite.killTweensOf(texts[i]);
				texts[i].alpha = 0;				
			}
		}
		
		private function btnRightClickHandler(e:MouseEvent):void {
			if (currentNum == images.length) {
				return;
			}
			
			imageTimer.stop();
			textTimer.stop();
			
			currentImage = images[currentNum];
			
			if (images[currentNum + 1] == null) {
				return;
			}
			
			nextImage = images[currentNum + 1];
			nextImage.alpha = 0;
				
			currentNum++;
			
			btnLeft.visible = true;
			if (images[currentNum + 1] == null) {
				btnRight.visible = false;
				btnLeft.visible = false;
			} else {
				btnRight.visible = true;
			}
			
			this.hideText();
			tweenCurrent();
			
		}
		
		private function btnLeftClickHandler(e:MouseEvent):void {
			if (currentNum < 1) {
				return;
			}
			
			imageTimer.stop();
			textTimer.stop();
			
			currentImage = images[currentNum];
			
			if (images[currentNum - 1] == null) {
				return;
			}
			
			nextImage = images[currentNum - 1];
			nextImage.alpha = 0;
			
			currentNum--;
			
			btnRight.visible = true;
			if (images[currentNum - 1] == null) {
				btnLeft.visible = false;				
			} else {
				btnLeft.visible = true;
			}
			
			this.hideText();
			tweenCurrent();
			
		}
		
		private function tweenCurrent():void {
			TweenLite.to(currentImage, TRANSITION_TIME, { alpha:MIN_ALPHA } );
			if (nextImage == null) {
				return;
			}			
			TweenLite.to(nextImage, TRANSITION_TIME - 0.5, { alpha:MAX_ALPHA, onComplete:resetAndStartTimer} );
		}
		
		private function tweenNext():void {
			
		}
		
	}
	
}