package com.shurba.marketadviser {
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.xml.XMLLoader;	
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		private const XML_PATH:String = "market_adviser.xml";
		
		//public var tabBar:TabBar;
		public var xmlLoader:XMLLoader;
		public var linkBuilder:LinkBuilder;
		
		public var selectedTab:String;
		
		public var parsedData:MarketsVO;
		
		public var tabNavigator:TabNavigator;
		private var container:ScrollPane;
		
		public function DocumentClass() {
			super();
			if (stage) {
				this.init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
			new ApplyStandartOptions(this);			
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			selectedTab = MarketsVO.MICEX;
			
			container = new ScrollPane();
			this.addChild(container);
			
			container.x = 30;
			container.y = 49;			
			container.width = 363;
			container.height = 74;
			
			container.verticalScrollPolicy = ScrollPolicy.AUTO;			
			//this.addChild(linkBuilder);
			
			
			xmlLoader = new XMLLoader(XML_PATH, xmlLoaded);
			linkBuilder = new LinkBuilder();
			
			container.source = linkBuilder;
			linkBuilder.x = 5;
			linkBuilder.y = 5;
			linkBuilder.addEventListener(Event.COMPLETE, linkBuilderCompleteHandler, false, 0, true);			
		}
		
		private function linkBuilderCompleteHandler(e:Event):void {
			container.update();
		}
		
		private function tabBarChangeHandler(e:Event = null):void {
			//selectedTab = (tabNavigator.selectedTab as Object).labelName.toLowerCase();
			this.assignData();
		}
		
		private function assignData():void {
			switch (selectedTab) {
				case (MarketsVO.COMMODITIES) : {
					linkBuilder.dataProvider = parsedData.commodities;
					break;
				}
				case (MarketsVO.FOREX) : {
					linkBuilder.dataProvider = parsedData.forex;
					break;
				}
				case (MarketsVO.INDEX) : {
					linkBuilder.dataProvider = parsedData.index;
					break;
				}
				case (MarketsVO.MICEX) : {
					linkBuilder.dataProvider = parsedData.micex;
					break;
				}
			}
			
		}
		
		
		
		private function xmlLoaded($xml:XML):void {			
			var xList:XMLList = $xml.children();
			parsedData = new MarketsVO();
			var tmpXList:XMLList;
			var j:int = 0;
			for (var i:int = 0; i < xList.length(); i++) {
				var marketVO:MarketItemVO;
				switch (xList[i].@name.toLowerCase()) {
					
					case (MarketsVO.COMMODITIES) : {
						tmpXList = xList[i].children();
						for (j = 0; j < tmpXList.length(); j++) {
							marketVO = new MarketItemVO(tmpXList[j]);
							marketVO.marketName = MarketsVO.COMMODITIES;
							parsedData.micex.push(marketVO);
						}
						
						break;
					}
					case (MarketsVO.FOREX) : {
						tmpXList = xList[i].children();
						for (j = 0; j < tmpXList.length(); j++) {
							marketVO = new MarketItemVO(tmpXList[j]);
							marketVO.marketName = MarketsVO.FOREX;
							parsedData.micex.push(marketVO);
						}
						break;
					}
					case (MarketsVO.INDEX) : {
						tmpXList = xList[i].children();
						for (j = 0; j < tmpXList.length(); j++) {
							marketVO = new MarketItemVO(tmpXList[j]);
							marketVO.marketName = MarketsVO.INDEX;
							parsedData.micex.push(marketVO);
						}
						break;
					}
					case (MarketsVO.MICEX) : {
						tmpXList = xList[i].children();
						for (j = 0; j < tmpXList.length(); j++) {
							marketVO = new MarketItemVO(tmpXList[j]);
							marketVO.marketName = MarketsVO.MICEX;
							parsedData.micex.push(marketVO);
						}
						break;
					}
				}
				
			}
			
			this.tabBarChangeHandler();
			//this.assignData();
			
		}
		
		
		
	}
	
	

}