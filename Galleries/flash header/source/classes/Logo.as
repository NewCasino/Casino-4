package classes {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	//[Event("loadComplete", type = "Event")]
	
	public class Logo extends Sprite {
		
		public var mcMask:MovieClip;
		public var mcShowRotatorBtn:MovieClip;
		
		private var urlRequest:URLRequest;
		private var logoLoader:Loader;
		
		public var nHPadding:Number = 5;
		public var nVPadding:Number = 5;
		
		public var bReady:Boolean = false;		
		private var sPath:String = "";
		private var sPosition:String = "";
		private var sLink:String = "";
		
		public function Logo($path:String = "",  $link:String = "") {
			super();
			
			sPath = $path;			
			sLink = $link
			
			logoLoader = new Loader();
			this.addListeners();
			this.loadLogo();
		}
		
		private function loadLogo():void {
			var $url:String = sPath;
			urlRequest = new URLRequest($url);
			logoLoader.load(urlRequest);
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		private function addListeners():void {
			logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoLoadCompleteHandler);
			this.addEventListener(MouseEvent.CLICK, linkBtnClickHandler);
		}
		
		private function removeListeners():void {
			logoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, logoLoadCompleteHandler);
			this.removeEventListener(MouseEvent.CLICK, linkBtnClickHandler);
		}
		
		private function linkBtnClickHandler($event:MouseEvent):void {
			this.openCurrentLink();
		}
		
		private function openCurrentLink():void {
			if (sLink == "") return;
			var $url:String = sLink;
			var $request:URLRequest = new URLRequest($url);
			navigateToURL($request, "_self");
		}
		
		private function logoLoadCompleteHandler($event:Event):void {
			this.addChild(logoLoader);
			bReady = true;
			//this.dispatchEvent(new Event("loadComplete"));
		}
	}
}