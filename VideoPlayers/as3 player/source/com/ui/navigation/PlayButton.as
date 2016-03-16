package com.ui.navigation {
	
	import com.data.DataHolder;
	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class PlayButton extends MovieClip {
		
		public var mcScrimBtn:MovieClip;
		public var mcPlayBtn:MovieClip;
		public var mcMask:MovieClip;
		public var mcImageContainer:MovieClip;
		private var loader:Loader = new Loader();
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function PlayButton() {
			super();

			mcScrimBtn.addEventListener(MouseEvent.MOUSE_UP, clickHandler);
			mcPlayBtn.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			mcPlayBtn.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			mcPlayBtn.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);			
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			
			mcScrimBtn.buttonMode = true;
			mcPlayBtn.buttonMode = true;
			mcPlayBtn.useHandCursor = true;
			
			mcPlayBtn.label.txtLabel.mouseEnabled = false;			
		}
		
		public function loadImage($url:String):void {
			var request:URLRequest = new URLRequest($url);
			try {
				loader.load(request);				
			} catch (error:ArgumentError) {
				trace("An ArgumentError has occurred.");
			} catch (error:SecurityError) {
				trace("A SecurityError has occurred.");
			}

		}
		
		public function updateTexts():void {
			mcPlayBtn.label.txtLabel.text = dataHolder.xMainXml.buttonsname.play_btn.@value;
		}
		
		public function unloadImage():void {
			loader.unload();
		}
		
		public function updateSize():void {
			var nWidth:Number = stage.stageWidth;
			var nHeight:Number = stage.stageHeight - 41;
			mcMask.width = nWidth;
			mcMask.height = nHeight;
			mcImageContainer.width = nWidth;
			mcImageContainer.height = nHeight
			mcPlayBtn.x = (nWidth - mcPlayBtn.width) / 2;
			mcPlayBtn.y = (nHeight - mcPlayBtn.height) / 2;

			mcScrimBtn.width = nWidth;
			mcScrimBtn.height = nHeight;
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
		}
		
		private function loaderCompleteHandler($event:Event):void {
			//trace("image loading complete");
			mcImageContainer.addChild(loader);
			this.updateSize();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function clickHandler($event:MouseEvent):void {
			mcPlayBtn.gotoAndStop('up');
			dataHolder._stage.selectVideoTrack();			
		}
		
		public function hide():void {
			this.unloadImage();
			this.visible = false;
		}
		
		private function rollOverHandler($event:MouseEvent):void {
			mcPlayBtn.gotoAndStop('over');
		}
		
		private function rollOutHandler($event:MouseEvent):void {
			mcPlayBtn.gotoAndStop('up');			
		}
	}
	
}