package com.ui.components {
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class AdvImageLoader extends MovieClip {
		
		private var loader:Loader = new Loader();
		public var mcHitSpace:MovieClip;
		private var requestAdvLink:URLRequest;
		private var nTimeToShow:Number;
		public var mcImageContainer:MovieClip;
		
		private var uiTimeoutID:uint;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function AdvImageLoader() {
			super();			
			this.visible = false;
			this.addListeners();
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function removeListeners():void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		public function updateSize():void {
			mcHitSpace.width = dataHolder.nMaxVideoWidth;
			mcHitSpace.height = dataHolder.nMaxVideoHeight;
			if (mcImageContainer.width == 0 || mcImageContainer.height == 0) {
				mcImageContainer.width = dataHolder.nMaxVideoWidth/2;
				mcImageContainer.height = dataHolder.nMaxVideoHeight/2;
			}
			loader.scaleX = 0.9;
			loader.scaleY = 0.9;
			mcImageContainer.scaleX = 1;
			mcImageContainer.scaleY = 1;
			var coef:Number =  mcImageContainer.width / mcImageContainer.height;
			
			if (coef > 1) {
				mcImageContainer.width = dataHolder.nMaxVideoWidth;
				mcImageContainer.height = dataHolder.nMaxVideoWidth / coef;
			} else {
				mcImageContainer.height = dataHolder.nMaxVideoHeight;
				mcImageContainer.width = dataHolder.nMaxVideoHeight * coef;
			}
			mcImageContainer.y = (dataHolder.nMaxVideoHeight - mcImageContainer.height) / 2;
			mcImageContainer.x = (dataHolder.nMaxVideoWidth - mcImageContainer.width) / 2;
			//trace ('COEF  ' +mcImageContainer.width+"   "+mcImageContainer.height);
		}
		
		public function loadImage($sType:String):void {
			this.visible = true;
			var $urlLink:String;
			var $urlPath:String;
			var $requestImgPath:URLRequest;
			if ($sType == "preroll") {				
				$urlLink = dataHolder.xMainXml.preroll.image.@link;
				requestAdvLink = new URLRequest($urlLink);
				$urlPath = dataHolder.xMainXml.preroll.image.@path;
				$requestImgPath = new URLRequest($urlPath);
				nTimeToShow = dataHolder.xMainXml.preroll.image.@time;
				
			} else if ($sType == "postroll") {
				$urlLink = dataHolder.xMainXml.postroll.image.@link;
				requestAdvLink = new URLRequest($urlLink);
				$urlPath = dataHolder.xMainXml.postroll.image.@path;
				$requestImgPath = new URLRequest($urlPath);
				nTimeToShow = dataHolder.xMainXml.postroll.image.@time;
				
			} else {
				dataHolder._stage.selectVideoTrack();
				return;
			}
			
			loader.load($requestImgPath);			
		}
		
		public function unloadAndHide():void {
			if (mcHitSpace.hasEventListener(MouseEvent.CLICK)) {
				mcHitSpace.removeEventListener(MouseEvent.CLICK, hitSpaceClickHandler);
			}
			this.requestAdvLink = new URLRequest();
			this.nTimeToShow = 0;
			mcImageContainer.removeChild(loader);
			loader.unload();
			this.visible = false;
			dataHolder._stage.selectVideoTrack();
		}
		
		private function loaderCompleteHandler($event:Event):void {
			//trace("image loading complete");
			
			mcImageContainer.addChild(loader);
			mcHitSpace.addEventListener(MouseEvent.CLICK, hitSpaceClickHandler);
			this.updateSize();
			uiTimeoutID = setTimeout(timeOut, nTimeToShow * 1000);
		}
		
		private function ioErrorHandler($event:IOErrorEvent):void {
			trace("ioErrorHandler: " + $event);
			dataHolder._stage.selectVideoTrack();
		}
		
		private function hitSpaceClickHandler($event:MouseEvent):void {
			navigateToURL(requestAdvLink);
			clearTimeout(uiTimeoutID);
			this.unloadAndHide();
		}
		
		private function timeOut():void {
			unloadAndHide();
		}
	}
}