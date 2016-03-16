package com.ui {
	
	import com.data.DataHolder;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class Logo extends MovieClip {
		
		public var mcMask:MovieClip;
		public var mcShowRotatorBtn:MovieClip;
		
		private var urlRequest:URLRequest;
		private var logoLoader:Loader;
		
		public var nHPadding:Number = 5;
		public var nVPadding:Number = 5;
		
		public var bReady:Boolean = false;
		
		private var callBack:Function;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function Logo($callBack:Function = null) {
			super();
			callBack = $callBack;
			logoLoader = new Loader();
			this.addListeners();
			//this.loadLogo();
		}
		
		public function loadLogo():void {
			var $url:String = dataHolder.xMainXml.logo.@path;
			urlRequest = new URLRequest($url);
			logoLoader.load(urlRequest);
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		private function addListeners():void {
			logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoLoadCompleteHandler);
			logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, logoLoadIOError);
			this.addEventListener(MouseEvent.CLICK, linkBtnClickHandler);
		}
		
		private function removeListeners():void {
			logoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, logoLoadCompleteHandler);
			this.removeEventListener(MouseEvent.CLICK, linkBtnClickHandler);
		}
		
		public function updateSize():void {
			if (!this.bReady) {
				return;
			}
			
			switch (dataHolder.xMainXml.logo.@location.toString()) {
				case 'progress_bar': {
					this.y = -15;
					this.x = dataHolder._stage.mcNavigation.mcProgressBar.thisWidth + dataHolder._stage.mcNavigation.mcProgressBar.x + nHPadding;
					
					/*
					if (this.width>0 && logowidth==0){
						logowidth = this.width
					}
					*/
					
					break;
				}
				
				case 'TL': {
					logoLoader.x = nHPadding;
					logoLoader.y = nVPadding;
					break;		
				}
				
				case 'TR': {
					logoLoader.x = dataHolder.nStageWidth - logoLoader.width - nHPadding;
					logoLoader.y = nVPadding;
					break;		
				}
				
				case 'BL': {					
					this.x = nHPadding;
					this.y = dataHolder.nStageHeight - this.height - nHPadding - 41;
					break;		
				}
				
				case 'BR': {					
					this.x = dataHolder.nStageWidth - this.width -nHPadding;
					this.y = dataHolder.nStageHeight - this.height - nVPadding - 41;
					break;		
				}
			}
		}
		
		private function linkBtnClickHandler($event:MouseEvent):void {
			this.openCurrentLink();
		}
		
		private function openCurrentLink():void {
			var $url:String = dataHolder.xMainXml.logo.@link;
			var $request:URLRequest = new URLRequest($url);
			navigateToURL($request);
		}
		
		private function logoLoadCompleteHandler($event:Event):void {
			this.addChild(logoLoader);
			bReady = true;
			callBack();
			
		}
		
		private function logoLoadIOError($event:Event):void {
			trace ("IO_Error "+$event);
		}
	}
}