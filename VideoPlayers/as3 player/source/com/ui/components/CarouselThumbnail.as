package com.ui.components {
	
	import flash.net.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import com.pixelfumes.reflect.Reflect;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import gs.TweenLite;
	
	public class CarouselThumbnail extends MovieClip {
		
		public var mcReflection:MovieClip;
		public var mcThumb:MovieClip;
		public var mcBorder:MovieClip;
		public var mcPreloader:MovieClip;
		public var mcBackButton:MovieClip;
		
		public var sImageUrl:String;
		public var sLinkUrl:String;
		public var sTitle:String;
		
		private var thumbLoader:Loader;		
		private var nThumbWidth:Number;
		private var nThumbHeight:Number;
		
		private var owner:Carousel;
		
		public function CarouselThumbnail($settings:Object) {
			super();
			
			this.sTitle = $settings.sTitle;
			this.sLinkUrl = $settings.sLinkUrl;
			this.sImageUrl = $settings.sImageUrl;
			this.nThumbWidth = $settings.nThumbWidth;
			this.nThumbHeight = $settings.nThumbHeight;
			this.owner = $settings.owner;
			
			thumbLoader = new Loader();			
			this.addListeners();
			this.loadThumbs();
		}
		
		private function addListeners():void {
			thumbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbLoaderCompleteHandler);
            thumbLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);            
			mcBackButton.addEventListener(MouseEvent.ROLL_OVER, thisRollOverHandler);
			mcBackButton.addEventListener(MouseEvent.MOUSE_OUT, thisRollOutHandler);
			mcBackButton.addEventListener(MouseEvent.CLICK, thisClickHandler);
		}
		
		private function removeListeners():void {
			thumbLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, thumbLoaderCompleteHandler);
			thumbLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			mcBackButton.removeEventListener(MouseEvent.ROLL_OVER, thisRollOverHandler);
			mcBackButton.removeEventListener(MouseEvent.MOUSE_OUT, thisRollOutHandler);
			mcBackButton.removeEventListener(MouseEvent.CLICK, thisClickHandler);
		}
		
		private function thumbLoaderCompleteHandler($event:Event):void {			
			var $bitmapHandler:Bitmap = thumbLoader.content as Bitmap;
			$bitmapHandler.smoothing = true;
			mcThumb.addChild($bitmapHandler);			
			var r1:Reflect =  new Reflect({mc:mcThumb, alpha:37, ratio:100, distance:0, updateTime:-1, reflectionDropoff:0});			
			this.updateThumbSize();
			mcThumb.mouseEnabled = false;
		}
		private function updateThumbSize():void {
			
			mcThumb.width = nThumbWidth;
			mcThumb.height = nThumbHeight * 2;
			
			mcBorder.width = nThumbWidth + 2;
			mcBorder.height = nThumbHeight + 2;
			mcPreloader.visible = false;
			mcBackButton.width = nThumbWidth + nThumbWidth * 0.15;
			mcBackButton.height = nThumbHeight + nThumbHeight * 0.15;
			mcBackButton.x = 0 -(mcBackButton.width - nThumbWidth) / 2;
			mcBackButton.y = 0 -(mcBackButton.height - nThumbHeight) / 2;
			mcBackButton.buttonMode = true;
			mcBackButton.mouseEnabled = true;
			this.scaleX = 1;
			this.scaleY = 1;			
		}
		
		private function loadThumbs():void {
			var request:URLRequest;
			request = new URLRequest(sImageUrl);
			thumbLoader.load(request);			
		}
		
        private function ioErrorHandler($event:IOErrorEvent):void {
            trace("ioErrorHandler: " + $event.text);
        }
		
        private function thisRollOverHandler($event:MouseEvent):void {
			if (owner.bMoveFlag) {
				return;
			}
            mcBorder.alpha = 1;
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.3, {y:4, scaleX:1.15, scaleY:1.15});
        }
		
		private function thisRollOutHandler($event:MouseEvent):void {
			if (owner.bMoveFlag) {
				return;
			}
            mcBorder.alpha = 0;
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.3, {y:0, scaleX:1, scaleY:1});
        }
		
		private function thisClickHandler($event:MouseEvent):void {           
            var request:URLRequest = new URLRequest(sLinkUrl);           
            navigateToURL(request);
        }
	}	
}