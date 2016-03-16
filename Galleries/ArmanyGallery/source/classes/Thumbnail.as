package classes {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import gs.plugins.ColorTransformPlugin;
	import gs.plugins.TweenPlugin;
	import gs.TweenLite;
	import gs.TweenMax;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	public class Thumbnail extends Sprite {
		
		private var request:URLRequest;
		private var loader:Loader;
		
		public var imageVO:ImageVO;
		private var borderSprite:Sprite;
		
		private var _border:Boolean;
		
		public var borderActive:Boolean = false;
		
		public function Thumbnail() {
			super();
			loader = new Loader();			
			borderSprite = new Sprite();
			this.addListeners();
			this.addChild(loader);			
			this.addChild(borderSprite);
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderLoadComplete, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderLoadError, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		}
		
		private function mouseOutHandler(e:MouseEvent):void {
			if (!_border) {
				return;
			}
			
			TweenLite.to(borderSprite, 0.5, { tint:null} );
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			if (!_border || !borderActive) {
				return;
			}			
			TweenLite.to(borderSprite, 0.5, { tint:imageVO.thumbBorderRollOverColor} );			
		}
		
		private function loaderLoadError(e:IOErrorEvent):void {
			trace (e);
		}
		
		private function loaderLoadComplete(e:Event):void {			
			(e.currentTarget.content as Bitmap).smoothing = true;
			loader.width = imageVO.thumbWidth;
			loader.height = imageVO.thumbHeight;
			loader.visible = true;
		}
		
		public function init($data:ImageVO):void {
			imageVO = $data;
			this.loadThumb();
			this.border = imageVO.thumbBorder;
		}
		
		protected function loadThumb():void {
			request = new URLRequest(imageVO.thumbUrl);
			loader.visible = false;			
			loader.load(request);
		}
		
		protected function drawBorder():void {
			borderSprite.graphics.clear();
			if (!imageVO.thumbBorder) {
				return;
			}
			borderSprite.graphics.lineStyle(1, imageVO.thumbBorderColor);
			borderSprite.graphics.moveTo ( 0, 0);
			borderSprite.graphics.lineTo ( imageVO.thumbWidth, 0);			
			borderSprite.graphics.lineTo ( imageVO.thumbWidth, imageVO.thumbHeight);			
			borderSprite.graphics.lineTo ( 0, imageVO.thumbHeight);
			borderSprite.graphics.lineTo ( 0, 0);
		}
		
		public function get border():Boolean { 
			return _border; 
		}
		
		public function set border(value:Boolean):void {
			_border = value;
			if (value) {
				this.drawBorder();
			} else {				
				borderSprite.visible = false;
			}
		}
		
		
		
	}

}