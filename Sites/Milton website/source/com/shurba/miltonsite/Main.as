package com.shurba.miltonsite {
	import com.shurba.components.accordionNavigator.AccordionNavigator;
	import com.shurba.miltonsite.model.DataManager;
	import com.shurba.miltonsite.view.NewsList;
	import com.shurba.miltonsite.view.SiteHeader;
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.xml.XMLLoader;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Main extends Sprite {
		
		private const SECTIONS_XML_PATH:String = 'data/sections.xml';
		private const NEWS_XML_PATH:String = 'data/news.xml';
		
		public var siteHeader:SiteHeader;
		public var homeBillet:Sprite;
		public var mainBackground:Sprite;
		public var accordionNavigator:AccordionNavigator;
		public var txtContactInformation:TextField;
		
		
		private var xmlLoader:XMLLoader;
		private var dataManager:DataManager = DataManager.getInstance();
		
		public function Main() {
			super();
			if (stage) this.init();
				else this.addEventListener(Event.ADDED_TO_STAGE, this.init);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			new ApplyStandartOptions(this as InteractiveObject);
			
			this.loadSectionsXML();
		}
		
		protected function drawComponents():void {
			siteHeader = new SiteHeader();
			this.addChild(siteHeader);
			
			accordionNavigator = new AccordionNavigator();
			this.addChild(accordionNavigator);
			accordionNavigator.init();
			
			this.addListeners();
			this.stageResizeHandler(null);
			
			
			//temp
			var news:NewsList = new NewsList();
			news.dataProvider = dataManager.newsData;
			this.addChild(news);
		}
		
		protected function addListeners():void {
			this.stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
			
		}
		
		private function stageResizeHandler(e:Event):void {
			siteHeader.x = (stage.stageWidth - siteHeader.visualWidth) / 2;
			siteHeader.y = 0;
			
			accordionNavigator.x = (stage.stageWidth - accordionNavigator.width) / 2 + 5;			
			accordionNavigator.y = siteHeader.height - 10;
			txtContactInformation.x = siteHeader.x + siteHeader.width - 20;
			txtContactInformation.y = 50;
			
			mainBackground.width = stage.stageWidth;
			mainBackground.height = stage.stageHeight;
		}
		
		protected function loadSectionsXML():void {			
			xmlLoader = new XMLLoader(SECTIONS_XML_PATH, sectionsLoaded);
		}
		
		protected function loadNewsData():void {
			xmlLoader = new XMLLoader(NEWS_XML_PATH, newsDataLoaded);
		}
		
		protected function newsDataLoaded($xml:XML):void {			
			dataManager.parseNewsXML($xml);
			this.drawComponents();
		}
		
		
		protected function sectionsLoaded($xml:XML):void {			
			dataManager.parseSectionsXML($xml);
			this.loadNewsData();
		}
		
		
	}

}