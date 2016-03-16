package {	
	import com.littlefilms.*;
	import com.stimuli.loading.*;
	import flash.display.*;
	import flash.events.*;
	import gs.*;
	import gs.easing.*;

	public class Main extends MovieClip {
		private var _logo:LittleFilmsLogo;
		private var _bgManager:BGManager;
		private var _footer:FooterUI;
		private var _reelLink:ReelLink;
		private var _testPane:ContentPane;
		private var _activated:Boolean = false;
		private var _stageWidth:uint;
		private var _stageHeight:uint;
		private var _headerHeight:Number;
		private var _footerHeight:Number;
		private var _allNavHeight:Number;
		public var contentManager:ContentManager;
		public var paneManager:PaneManager;
		public var sequencer:Sequencer;
		private var _introMessaging:IntroMessaging;
		private static const LOGO_FOOTER_WIDTH:uint = 70;
		private static const FOOTER_NAV_BUFFER:uint = 30;
		private static const REEL_LINK_Y_BUFFER:uint = 110;
		
		public var colors:ColorScheme;
		//debug
		//public var _introMessaging:IntroMessaging;

		public function Main():void {
			//addFrameScript(0, frame1);
			trace("Main::Main()");
			
			if (stage) {
				preInit();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, preInit, false, 0, true);
			}
		}
		
		private function preInit(event:Event = null):void {
			//debug code from preloader
			/*_XMLLoader = new BulkLoader("XMLLoader");
			_XMLLoader.logLevel = BulkLoader.DEFAULT_LOG_LEVEL;
			_XMLLoader.addEventListener(BulkLoader.COMPLETE, XMLLoaded);
			_XMLLoader.add("assets/xml/content.xml", {id:"content", maxTries:10, priority:20});
			_XMLLoader.add("assets/xml/images.xml", {id:"images", maxTries:10, priority:20});
			_XMLLoader.add("assets/xml/work.xml", {id:"work", maxTries:10, priority:20});
			_XMLLoader.add("assets/xml/messaging.xml", {id:"messaging", maxTries:10, priority:20});            
			_XMLLoader.add("assets/xml/color_scheme.xml", {id:"colors", maxTries:10, priority:20});            
			_XMLLoader.start();*/
		}

		private function init(event:Event = null):void {
			trace("Main::init()");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			sequencer = new Sequencer();
			sequencer.registerMain(this);
			_bgManager = BGManager.getInstance(this);
			_bgManager.name = "bgManager";
			addChild(_bgManager);
			_reelLink = new ReelLink();
			_reelLink.registerMain(this);
			if (contentManager != null) {
				_reelLink.init(contentManager.contentXML.homeReel[0]);
			}
			addChild(_reelLink);
			paneManager = new PaneManager();
			paneManager.registerMain(this);
			addChild(paneManager);
			_footer = FooterUI.getInstance(this);
			addChild(_footer);
			_logo = new LittleFilmsLogo();
			_logo.buttonMode = true;
			_logo.mouseEnabled = true;
			_logo.mouseChildren = false;
			_logo.name = "_logo";
			_logo.width = LOGO_FOOTER_WIDTH;
			_logo.scaleY = _logo.scaleX;
			_logo.addEventListener(MouseEvent.MOUSE_OVER, logoOverHandler, false, 0, true);
			_logo.addEventListener(MouseEvent.MOUSE_OUT, logoOutHandler, false, 0, true);
			_logo.addEventListener(MouseEvent.CLICK, logoClickHandler, false, 0, true);
			addChild(_logo);
			_footerHeight = _footer.height;
			_allNavHeight = _headerHeight + _footerHeight;
		}

		private function XMLLoaded(e:Event):void {
			_contentXML = _XMLLoader.getXML("content");
			_imagesXML = _XMLLoader.getXML("images");
			_workXML = _XMLLoader.getXML("work");
			_messagingXML = _XMLLoader.getXML("messaging");
			_colors = _XMLLoader.getXML("colors");
			prepContent(_colors, _contentXML, _imagesXML, _workXML, new BulkLoader("AssetLoader"));
			resize(stage.stageWidth, stage.stageHeight);
			
			//debug
			/*if (contentManager != null) {
				_reelLink.init(contentManager.contentXML.homeReel[0]);
			}*/
			//////////
			
			_introMessaging = new IntroMessaging(_messagingXML);
			_introMessaging.name = "introMessaging";
			_introMessaging.init();
			addChild(_introMessaging);
			
			_introMessaging.setSize(stage.stageWidth, stage.stageHeight);
			_introMessaging.registerMain(this);
			//revealInterface();
		}

		public function prepContent(colorsXML:XML, contentXML:XML, imagesXML:XML, workXML:XML, assetLoader:BulkLoader):void {			
			ColorScheme.parseColors(colorsXML);
			TextFormatter.setTextFormats();
			init();
			contentManager = new ContentManager(contentXML, imagesXML, workXML, assetLoader);
			contentManager.name = "contentManager";
			contentManager.registerMain(this);
			addChild(contentManager);			
		}

		public function revealInterface():void {
			_activated = true;
			var _loc_1:int = _stageHeight - _footerHeight + 1;
			var _loc_2:int = _stageHeight - _footer.bg.height / 2 - _logo.height / 2;
			var _loc_3:int = _stageWidth;
			_reelLink.y = _loc_1 - REEL_LINK_Y_BUFFER;
			TweenMax.to(_footer, 0.5, {y:_loc_1, ease:Expo.easeInOut});
			TweenMax.to(_logo, 0.5, {y:_loc_2, ease:Expo.easeInOut});
			TweenMax.to(_reelLink, 0.5, {x:_loc_3, ease:Expo.easeInOut});
			_bgManager.init();
			//_bgManager.addChildAt(getChildByName("introMessaging"), 1);
			
			//debug
			//_bgManager.addChildAt(_introMessaging, 1);
			//////////
			_bgManager.addChildAt(_reelLink, 1);
		}

		public function resize(toWidth:Number, toHeight:Number):void {
			_stageWidth = toWidth;
			_stageHeight = toHeight;
			_bgManager.setSize(toWidth, toHeight);
			_footer.setSize(toWidth, 0);
			paneManager.setSize(toWidth, toHeight);
			_logo.x = FOOTER_NAV_BUFFER;
			if (_activated) {
				_footer.y = toHeight - _footerHeight + 1;
				_logo.y = toHeight - _footer.bg.height / 2 - _logo.height / 2;
				_reelLink.x = toWidth;
				_reelLink.y = _footer.y - REEL_LINK_Y_BUFFER;
			} else {
				_footer.y = toHeight;
				_logo.y = toHeight - _footer.bg.height / 2 - _logo.height / 2 + _footerHeight;
				_reelLink.x = toWidth + 22;
				_reelLink.y = _footer.y - REEL_LINK_Y_BUFFER;
			}
		}

		protected function logoOverHandler(event:MouseEvent):void {
			TweenMax.to(event.target, 0.2, {tint:16777215, ease:Expo.easeInOut});
		}

		protected function logoOutHandler(event:MouseEvent):void {
			TweenMax.to(event.target, 0.2, {removeTint:true, ease:Expo.easeInOut});
		}

		protected function logoClickHandler(event:MouseEvent):void {
			sequencer.changeSection("none", "");
			footer.swapNav(null);
		}
		
		public function hideMessaging():void {
			TweenMax.to(_introMessaging, 0.2, { alpha:0 } );
		}
		
		public function showMessaging():void {
			TweenMax.to(_introMessaging, 0.2, { alpha:1 } );
		}

		public function get bgManager():BGManager {
			return _bgManager;
		}

		public function set bgManager(param1:BGManager):void {
			if (param1 !== _bgManager) {
				_bgManager = param1;
			}
		}

		public function get footer():FooterUI {
			return _footer;
		}

		public function set footer(param1:FooterUI):void {
			if (param1 !== _footer) {
				_footer = param1;
			}
		}

		public function get logo():LittleFilmsLogo {
			return _logo;
		}

		public function set logo(param1:LittleFilmsLogo):void {
			if (param1 !== _logo) {
				_logo = param1;
			}
		}

		public function get stageWidth():uint {
			return _stageWidth;
		}

		public function set stageWidth(param1:uint):void {
			if (param1 !== _stageWidth) {
				_stageWidth = param1;
			}
		}

		public function get stageHeight():uint {
			return _stageHeight;
		}

		public function set stageHeight(param1:uint):void {
			if (param1 !== _stageHeight) {
				_stageHeight = param1;
			}
		}

		public function get footerHeight():Number {
			return _footerHeight;
		}

		public function set footerHeight(param1:Number):void {
			if (param1 !== _footerHeight) {
				_footerHeight = param1;
			}
		}

		public function get activated():Boolean {
			return _activated;
		}

		public function set activated(param1:Boolean):void {
			if (param1 !== _activated) {
				_activated = param1;
			}
		}
		
		public function get introMessaging():IntroMessaging { return _introMessaging; }
		
		public function set introMessaging(value:IntroMessaging):void {
			_introMessaging = value;
			this.addChild(_introMessaging);
		}
	}
}