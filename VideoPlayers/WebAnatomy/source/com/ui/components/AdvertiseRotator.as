package com.ui.components {
	
	/*
	TypeError: Error #1009: Cannot access a property or method of a null object reference.
	at com.ui.components::AdvertiseRotator/newRotateTimeout()
	at Function/http://adobe.com/AS3/2006/builtin::apply()
	at SetIntervalTimer/onTimer()
	at flash.utils::Timer/_timerDispatch()
	at flash.utils::Timer/tick()

	*/
	
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.display.LoaderInfo;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class AdvertiseRotator extends MovieClip {
		
		public var mcBackground:MovieClip;
		public var mcArrowRight:MovieClip;
		public var mcArrowLeft:MovieClip;
		public var mcClose:MovieClip;
		public var mcLinkBtn:MovieClip;
		public var mcTitleBtn:MovieClip;
		public var mcAdsGoogle:MovieClip;
		
		public var txtLink:TextField;
		public var txtDescription:TextField;
		public var txtTitle:TextField;
		public var txtGoogle:TextField;
		
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;		
		private var xAdv:XML;
		private var xAdvList:XMLList = new XMLList();
			
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		private var onXmlLoadCompleteFunction:Function;
		private var onClose:Function;
		
		private var iCurrentAd:Number = 0;
		private var iTimeoutID:uint;
		
		public var bXMLGood:Boolean;
		
		public function AdvertiseRotator() {
			super();
			
			mcArrowRight.useHandCursor = true;
			mcArrowLeft.useHandCursor = true;
			mcArrowRight.buttonMode = true;
			mcArrowLeft.buttonMode = true;
			mcClose.buttonMode = true;
			mcClose.useHandCursor = true;
			mcTitleBtn.buttonMode = true;
			mcLinkBtn.buttonMode = true;
			mcAdsGoogle.buttonMode = true;
			mcAdsGoogle.useHandCursor = true;
		}		
		
		private function addListeners():void {
			mcArrowRight.addEventListener(MouseEvent.CLICK, clickRightArrowHandler);
			mcArrowLeft.addEventListener(MouseEvent.CLICK, clickLeftArrowHandler);
			mcClose.addEventListener(MouseEvent.CLICK, onCloseClickHandler);
			urlLoader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			mcLinkBtn.addEventListener(MouseEvent.CLICK, linkBtnClickHandler);
			mcTitleBtn.addEventListener(MouseEvent.CLICK, titleBtnClickHandler);
			mcAdsGoogle.addEventListener(MouseEvent.CLICK, titleBtnClickHandler);
		}
		
		private function removeListeners():void {
			mcArrowRight.removeEventListener(MouseEvent.MOUSE_DOWN, clickRightArrowHandler);
			mcArrowLeft.removeEventListener(MouseEvent.CLICK, clickLeftArrowHandler);
			mcClose.removeEventListener(MouseEvent.CLICK, onCloseClickHandler);
			urlLoader.removeEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			mcLinkBtn.removeEventListener(MouseEvent.CLICK, linkBtnClickHandler);
			mcTitleBtn.removeEventListener(MouseEvent.CLICK, titleBtnClickHandler);
			mcAdsGoogle.removeEventListener(MouseEvent.CLICK, titleBtnClickHandler);
		}
		
		private function linkBtnClickHandler($event:MouseEvent):void {
			this.openCurrentLink();
		}
		
		private function titleBtnClickHandler($event:MouseEvent):void {
			this.openCurrentLink();
		}
		
		private function openCurrentLink():void {
			var $url:String = xAdvList[iCurrentAd].go_link;
			var $request:URLRequest = new URLRequest($url);
			navigateToURL($request);
		}
		
		private function rotateAds($num:Number = NaN):void {			
			if (isNaN($num)) {
				iCurrentAd++;
				if (iCurrentAd > xAdvList.length() - 1) {
					this.killRotateTimeout();
					this.onClose();
					return;
					//iCurrentAd = 0;
				}
			} else {
				iCurrentAd += $num;
				if (iCurrentAd < 0) {
					iCurrentAd = xAdvList.length() -1;
				}
			}
			this.updateTexts();
			this.updateSize();
		}		
		
		private function rotationChain():void {
			this.rotateAds();
			this.newTimeOut();
		}
		
		private function newTimeOut():void {
			this.killRotateTimeout();
			this.newRotateTimeout();
		}
		
		private function newRotateTimeout():void {
			var $fFunc = this.rotationChain;
			var $nTime:Number;
			if (xAdv.advertisment.@time == undefined || xAdv.advertisment.@time == "") {
				$nTime = 7; // default value
			} else {
				$nTime = Number(xAdv.advertisment.@time);
			}
			iTimeoutID = setTimeout($fFunc, $nTime * 1000);
		}		
		
		public function startRotate():void {
			iCurrentAd = -1;
			this.rotateAds();
			var fFunc = this.newRotateTimeout;
			iTimeoutID = setTimeout(fFunc, 200);
		}
		
		public function killRotateTimeout():void {
			clearTimeout(iTimeoutID);
		}
		
		private function updateTexts():void {
			//trace ("TEXTS UPDATE");
			txtGoogle.autoSize = TextFieldAutoSize.LEFT;
			if (xAdv.advertisment.@title != "") {
				txtGoogle.text = xAdv.advertisment.@title;
			}
			
			
			txtTitle.autoSize = TextFieldAutoSize.LEFT;
			if (xAdvList[iCurrentAd].title != "") {
				txtTitle.text = xAdvList[iCurrentAd].title;
			}
			//trace(iCurrentAd);
			
			//trace ("TEXTS UPDATE  "+xAdvList[iCurrentAd].description);
			
			txtDescription.autoSize = TextFieldAutoSize.LEFT;
			if (xAdvList[iCurrentAd].description != "") {
				txtDescription.text = xAdvList[iCurrentAd].description; 
			}
			
			
			txtLink.autoSize = TextFieldAutoSize.LEFT;
			if (xAdvList[iCurrentAd].text_link != "") {
				txtLink.htmlText = '<u>' + xAdvList[iCurrentAd].text_link + '</u>';
			}
		}
		
		private function xmlLoadCompleteHandler($event:Event):void {
			xAdv = new XML($event.target.data);
			xAdvList = xAdv.advertisment.children();
			
			if (xAdv.advertisment.children().length() > 1) {
				bXMLGood = true;
			} else {
				this.off();
			}			
			onXmlLoadCompleteFunction();
		}
		
		private function ioErrorHandler($event:IOErrorEvent):void {
			this.off();
		}
		
		private function off():void {
			this.removeListeners();
			enabled = false;
		}
		
		private function clickRightArrowHandler($event:MouseEvent):void {
			this.rotateAds();
		}
		
		private function clickLeftArrowHandler($event:MouseEvent):void {
			this.rotateAds(-1);
		}
		
		private function onCloseClickHandler($event:MouseEvent):void {
			this.onClose();
		}
		
		public function init($onXmlLoadComplete:Function, $onClose:Function = null):void {
			onClose = $onClose;
			onXmlLoadCompleteFunction = $onXmlLoadComplete;
			urlLoader = new URLLoader();
			this.addListeners();
			this.loadXML();
		}
		
		private function loadXML():void {
			var $url:String;
			var $oParams:Object = new Object();
			$oParams = (this.root.loaderInfo).parameters;
			if ($oParams.http_base_url != undefined && $oParams.http_base_url!='') {
				$url = $oParams.http_base_url+"mm_ads.php";
			} else {
				$url = dataHolder.sXmlAdvUrl;
			}
			
			//trace($url)
			urlRequest = new URLRequest($url);
			var $vars:URLVariables = new URLVariables();
			if ($oParams.videoid != undefined && $oParams.videoid!='') {
				$vars.videoid = $oParams.videoid;
				urlRequest.data = $vars;
			}
			
			urlLoader.load(urlRequest);			
		}
		
		public function updateSize():void {
			mcLinkBtn.width  = txtLink.textWidth + 5;
			mcTitleBtn.width = txtTitle.textWidth + 5;
			mcAdsGoogle.width = txtGoogle.width;
			
			mcBackground.width = dataHolder.nStageWidth;
			
			txtGoogle.x = dataHolder.nStageWidth - txtGoogle.width - 25;
			mcClose.x = dataHolder.nStageWidth - 21;
			mcAdsGoogle.x = txtGoogle.x;
			
			mcArrowRight.x = dataHolder.nStageWidth - 21;
			mcArrowLeft.x  = dataHolder.nStageWidth - 21 - 4;
		}
	}
}