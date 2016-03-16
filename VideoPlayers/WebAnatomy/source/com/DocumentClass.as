package com {
	
	import com.core.Engine;
	import com.data.DataHolder;
	import com.control.ControlsHolder;
	import com.data.FalshVarsReader;
	import com.ui.Main;
	import com.ui.Preloader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import com.data.MainXmlParser;
	import com.data.FalshVarsReader;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	
	public class DocumentClass extends MovieClip {
		
		private var dataHolder:DataHolder;
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();		
		private var engine:Engine;
		public var mcPreloader:Preloader;
		public var mcMain:Main;
		
		public function DocumentClass() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			this.loaderInfo.addEventListener(Event.INIT, startPreloader);
		}
		
		private function startPreloader($event:Event):void {			
			mcPreloader = new Preloader(onLoadComplete);
			this.addChild(mcPreloader);
			mcPreloader.start();
		}
		
		private function onLoadComplete():void {
			this.removeChild(mcPreloader);
			mcPreloader = null;
			this.initApplication();
			this.loadData();
			//trace (this.currentLabel);
		}
		
		private function initApplication():void {
			dataHolder = DataHolder.getInstance();
			engine = Engine.getInstance();
			controlsHolder._stage = this;
		}
		
		private function loadData():void {
			if (!dataHolder.USE_HARDCODED_DATA) {
				new FalshVarsReader();
			}
			
			new MainXmlParser(onMainXMLLoadComplete);
		}
		
		private function onMainXMLLoadComplete():void {			
			this.gotoAndStop("main");			
			this.changeContextMenu();
			engine.startUp();
		}
		
		public function debug():void {
			//trace(mcMain.videoOutput.getChildByName("videoRenderrer"));
		}
		
		private function changeContextMenu():void {
			var myMenu:ContextMenu = new ContextMenu();
            myMenu.hideBuiltInItems();
            var menu_brand : ContextMenuItem = new ContextMenuItem(dataHolder.xMainXml.brand.@title);
            myMenu.customItems.push(menu_brand);
            this.contextMenu = myMenu;
            menu_brand.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuClickHandler) 
		}
		
		private function menuClickHandler($event:ContextMenuEvent):void {
			var request:URLRequest = new URLRequest(dataHolder.xMainXml.brand.@link);
			navigateToURL(request);
		}
	}
}