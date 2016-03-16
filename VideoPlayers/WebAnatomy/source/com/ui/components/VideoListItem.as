package com.ui.components {
	
	import com.vo.VideoListItemVO;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import gs.TweenLite;
	
	public class VideoListItem extends Sprite {
		
		//public var mcThumb:Sprite;
		
		public var mcThumb:Sprite;
		public var mcBackground:Sprite;
		
		public var txtTitle:TextField;
		public var txtDescription:TextField;
		
		public var data:VideoListItemVO;
		
		private var thumbLoader:Loader = new Loader();
		private var container:Sprite;
		
		public static const HEIGHT:int = 74;
		private var nThumbWidth:Number;
		private var nThumbHeight:Number;
		
		
		public function VideoListItem() {
			mcBackground.alpha = 0.5;
			this.buttonMode = true;
			txtTitle.mouseEnabled = false;
			txtDescription.mouseEnabled = false;
			
			nThumbWidth = mcThumb.width;
			nThumbHeight = mcThumb.height;
			
			//trace (nThumbWidth + "  " + nThumbHeight);
			
			this.addListeners();
			container = new Sprite();
			container.mouseEnabled = false;
			mcThumb.addChild(container);
			container.addChild(thumbLoader);
		}
		
		private function addListeners():void {
			thumbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbLoaderCompleteHandler);
            thumbLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			mcBackground.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			mcBackground.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		private function removeListeners():void {
			thumbLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, thumbLoaderCompleteHandler);
			thumbLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			mcBackground.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			mcBackground.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		private function thumbLoaderCompleteHandler($event:Event):void {
			//var $bitmapHandler:Bitmap = thumbLoader.content as Bitmap;
			//$bitmapHandler.smoothing = true;
			//mcThumb.addChild($bitmapHandler);
			
			
			this.updateThumbSize();
			thumbLoader.mouseEnabled = false;
			//mcThumb.preloader.stop();
			//mcThumb.preloader.visible = false;
		}
		
		private function updateThumbSize():void {			
			var coef:Number =  container.width / container.height;
			
			if (container.width > nThumbWidth) {
				container.width = nThumbWidth;
				container.height = nThumbWidth / coef;
			} 
			if (container.height > nThumbHeight) {
				container.height = nThumbHeight;
				container.width = nThumbHeight * coef;
			}
			
			container.y = (nThumbHeight - container.height) / 2;
			container.x = (nThumbWidth - container.width) / 2;	
		}
		
		private function ioErrorHandler($event:IOErrorEvent):void {
            trace("ioErrorHandler: " + $event.text);
        }
		
		private function rollOverHandler($event:MouseEvent):void {
			TweenLite.to(mcBackground, 0.5, {alpha:1} );
		}
		
		private function rollOutHandler($event:MouseEvent):void {
			TweenLite.to(mcBackground, 0.5, {alpha:0.5} );
		}
		
		public function clear():void {
			this.removeListeners();
		}
		
		public function set dataProvider($data:VideoListItemVO):void {
			data = $data;
			txtTitle.text = $data.title;
			txtDescription.text = $data.description;
			this.loadThumb();
		}
		
		
		private function loadThumb():void {			
			var request:URLRequest;
			request = new URLRequest(data.thumb);
			thumbLoader.load(request);		
		}
		
	}
}