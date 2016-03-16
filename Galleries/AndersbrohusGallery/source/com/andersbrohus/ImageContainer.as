package com.andersbrohus {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import com.andersbrohus.Image;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import gs.easing.Back;
	import gs.easing.Bounce;
	import gs.easing.Circ;
	import gs.easing.Elastic;
	import gs.easing.Linear;
	import gs.plugins.ColorTransformPlugin;
	import gs.plugins.TweenPlugin;
	import gs.TweenGroup;
	import gs.TweenLite;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ImageContainer extends Sprite {
		
		private const TINT_ALPHA:Number = 0.3;
		
		public var frame:Sprite;
		public var tintMask:Sprite;
		public var container:Sprite;
		
		private var request:URLRequest;
		private var loader:Loader = new Loader();
		private var callBackFunction:Function;
		
		public var toWidthRes:Number;
		public var toHeightRes:Number;
		public var toXMove:Number;
		public var toYMove:Number;
		
		private var timer:Timer;
		private var timerDone:Boolean = false;
		
		public function ImageContainer() {
			this.visible = false;
			tintMask.visible = false;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);
			this.addChildAt(loader, this.numChildren - 1);
			
			this.showMask();
			frame.mouseEnabled = false;
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);			
			TweenMax.to(this, 0, {dropShadowFilter:{color:0x000000, alpha:1, blurX:12, blurY:12, angle:140, distance:4}});
		}
		
		private function timerHandler(e:TimerEvent):void {
			timerDone = true;		
		}
		
		private function thisMouseOutHandler(e:MouseEvent):void {
			this.setTint();
		}
		
		private function thisMouseOverHandler(e:MouseEvent):void {
			this.removeTint();
		}
		
		private function loaderErrorHandler(e:IOErrorEvent):void {
			trace ("Error loading image " + e);
		}
		
		private function loaderCompleteHandler(e:Event):void {
			this.addBlur();
			var bitmap:Bitmap;
			if (loader.contentLoaderInfo.content is Bitmap) {
				bitmap = loader.contentLoaderInfo.content as Bitmap;
				bitmap.smoothing = true;
			}
			/*if (loader.contentLoaderInfo.content.hasOwnProperty(smoothing)) {
				loader.contentLoaderInfo.content.smoothing = true;
			}*/
			
			if (timerDone) {
				this.resizeAndPlay();
			} else {
				this.resizeAndPlay();
				//setTimeout(resizeAndPlay, Math.ceil(Math.random() * Gallery.MAX_ANIMATION_DELAY));
			}
		}
		
		private function resizeAndPlay():void {
			this.visible = true;
			this.resizeTo(Gallery.MAX_THUMB_WIDTH, Gallery.MAX_THUMB_HEIGHT);
			if (this.callBackFunction != null) {
				var $owner:Image = parent as Image;
				this.callBackFunction($owner);
			}
			
			//$owner.playAnimation();
		}
		
		public function resizeTo($width:int, $height:int, $smooth:Boolean = false, $callBack:Function = null):void {
			var toWidth:Number;
			var toHeight:Number;
			var toX:Number;
			var toY:Number;
			
			var coef:Number =  loader.contentLoaderInfo.width / loader.contentLoaderInfo.height;
			toWidth = $width;
			toHeight = $width / coef;
			
			if (toHeight > $height) {
				toHeight = $height;
				toWidth = $height * coef;
			}
			
			/*toX = ($width - toWidth) / 2 + Gallery.FRAME_SIZE;
			toY = ($height - toHeight) / 2 + Gallery.FRAME_SIZE;*/
			
			toX = -toWidth / 2;
			toY = -toHeight / 2;
			
			if ($smooth) {
				TweenLite.to(loader, 0.25, { width:toWidth, height:toHeight, x:toX, y:toY, onComplete:$callBack } );
				toWidth = toWidth + Gallery.FRAME_SIZE * 2;
				toHeight = toHeight + Gallery.FRAME_SIZE * 2;
				toX = toX - Gallery.FRAME_SIZE;
				toY = toY - Gallery.FRAME_SIZE;
				TweenLite.to(frame, 0.25, { width:toWidth, height:toHeight, x:toX, y:toY } );
				tintMask.width = toWidth;
				tintMask.height = toHeight;
				tintMask.x = toX;
				tintMask.y = toY;
				toWidthRes = toWidth;
				toHeightRes = toHeight;
			} else {
				loader.width = toWidth;
				loader.height = toHeight;
				loader.x = toX;
				loader.y = toY;
				frame.width = loader.width + Gallery.FRAME_SIZE * 2;
				frame.height = loader.height + Gallery.FRAME_SIZE * 2;
				frame.x = loader.x - Gallery.FRAME_SIZE;
				frame.y = loader.y - Gallery.FRAME_SIZE;
				tintMask.width = frame.width;
				tintMask.height = frame.height;
				tintMask.x = frame.x;
				tintMask.y = frame.y;
			}
		}
		
		private function updateFrame():void {
			
			
		}
		
		public function loadImage($path:String, $callBack:Function = null):void {
			this.callBackFunction = $callBack;
			this.visible = false;
			frame.alpha = 0.5;
			request = new URLRequest($path);
			loader.load(request);
			timer.reset();
			timer.start();
			timerDone = false;
			timer.start();
		}
		
		public function moveInAnimation($delay:int = 0):void {
			loader.x = Gallery.ANIMATION_START_X;
			loader.y = Gallery.ANIMATION_START_Y;
			frame.x = Gallery.ANIMATION_START_X;
			frame.y = Gallery.ANIMATION_START_Y;
			//this.hideMask();			
			setTimeout(moveFrame, $delay);
			this.addBlur();
		}
		
		private function moveLoader():void {
			var toX:Number;
			var toY:Number;
			toX = -loader.width / 2;
			toY = -loader.height / 2;
			TweenLite.to(loader, Gallery.IMAGE_FLY_SECONDS, { x:toX, y:toY, ease:Back.easeOut, onComplete:showMask } );
			TweenLite.to(frame, Gallery.FRAME_FLY_SECONDS - 0.6, { alpha:0.8 } );
			setTimeout(removeBlur, 500);
		}
		
		private function moveFrame():void {
			var toX:Number;
			var toY:Number;
			toX = -frame.width / 2;
			toY = -frame.height / 2;
			TweenLite.to(frame, Gallery.FRAME_FLY_SECONDS, { x:toX, y:toY, ease:Linear.easeOut, onComplete:moveLoader } );
		}
		
		public function showMask():void {
			this.setTint();
			//tintMask.visible = false;
			if (this.hasEventListener(MouseEvent.MOUSE_OVER)) {
				return;
			}
			this.addEventListener(MouseEvent.MOUSE_OVER, thisMouseOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisMouseOutHandler, false, 0, true);
		}
		
		public function hideMask():void {
			this.removeTint();
			//tintMask.visible = false;
			if (this.hasEventListener(MouseEvent.MOUSE_OVER)) {
				this.removeEventListener(MouseEvent.MOUSE_OVER, thisMouseOverHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT, thisMouseOutHandler);
			}
			
		}
		
		public function setTint():void {
			var $owner:Image = parent as Image;
			if ($owner.zoomed ) {
				return;
			}
			TweenPlugin.activate([ColorTransformPlugin]);
			TweenMax.to(loader, 0.5, { colorTransform:{tint:0x000000, tintAmount:this.TINT_ALPHA}} );
		}
		
		public function removeTint():void {
			TweenPlugin.activate([ColorTransformPlugin]);
			TweenMax.to(loader, 0.5, { colorTransform:{tint:0x000000, tintAmount:0}} );
		}
		
		public function addBlur():void {
			TweenMax.to(frame, 0.5, { blurFilter: { blurX:15, blurY:0 }} );
		}
		
		public function removeBlur():void {
			TweenMax.to(frame, 0.5, { blurFilter: { blurX:0, blurY:0 }} );
		}
	}
	
}