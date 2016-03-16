package com.data {
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import fl.motion.Color;
	
	import com.data.DataHolder;
	
	
	public class MainXmlParser {
		
		private var dataHolder:DataHolder;
		private var _callBackFunction:Function;
		private var _request:URLRequest;
		public var xXML:XML;
		
		public function MainXmlParser($callBackFunction:Function) {
			dataHolder = DataHolder.getInstance();			
			_callBackFunction = $callBackFunction;
			this.generateRequest();
			this.loadXML();
		}
		
		private function generateRequest():void {
			if (dataHolder.sVideoID != '' && dataHolder.sVideoID != null) {
			//if (dataHolder.sMainXmlUrl != 'data.xml') {
				//trace ("MainXmlParser: flash vars detected");
				var $vars:URLVariables = new URLVariables();
				_request = new URLRequest(dataHolder.sMainXmlUrl+"mm_player.php");
				$vars.VIDEOID = dataHolder.sVideoID;
				$vars.home = dataHolder.sHome;
				_request.data = $vars;				
			} else {
				_request = new URLRequest(dataHolder.sMainXmlUrl);
			}
			//trace ("dataHolder.sVideoID   " + dataHolder.sVideoID == '');
			//_request = new URLRequest(dataHolder.sMainXmlUrl);
		}
		
		private function loadXML():void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			loader.load(_request);
		}
		
		private function xmlLoadCompleteHandler($event:Event):void {
			xXML = new XML($event.target.data);
			dataHolder.xMainXml = xXML;
			var atts:XMLList;
			var uiNum:uint;
			
			var nNum:Number;			
			var item:XML;
			
			trace("xXML.playerGUI.gradients " + xXML.playerGUI.hasOwnProperty("@fontColor"));
			
			dataHolder.aColors = new Array();
			dataHolder.aAlphas = new Array();
			dataHolder.aRatios = new Array();
			
			if (xXML.playerGUI.hasOwnProperty("@fontColor")) {
				dataHolder.fontColorNormal = uint(xXML.playerGUI.@fontColor);
			} else {
				dataHolder.fontColorNormal = dataHolder.DEFAULT_FONT_COLOR;
			}
			
			if (xXML.playerGUI.hasOwnProperty("@fontActive")) {
				dataHolder.fontColorActive = uint(xXML.playerGUI.@fontActive);
			} else {
				dataHolder.fontColorActive = dataHolder.DEFAULT_FONT_ACTIVE_COLOR;
			}
			
			if (xXML.playerGUI.hasOwnProperty("gradients")) {
				atts = xXML.playerGUI.gradients.attributes();
				for each (item in atts) {
					uiNum = uint(item)
					dataHolder.aColors.push(uiNum);
				}
				
				atts = xXML.playerGUI.opacity.attributes();
				for each (item in atts) {					
					nNum = Number(item);
					dataHolder.aAlphas.push(nNum);					
				}
				
				atts = xXML.playerGUI.ratios.attributes();				
				for each (item in atts) {
					uiNum = uint(item);
					dataHolder.aRatios.push(uiNum);
				}
				
			} else {
				dataHolder.aColors = dataHolder.DEFAULT_GRADIENT_COLORS;
				dataHolder.aAlphas = dataHolder.DEFAULT_GRADIENT_ALPHAS;
				dataHolder.aRatios = dataHolder.DEFAULT_GRADIENT_RATIOS;
			}
			
			_callBackFunction();
		}
	}
}