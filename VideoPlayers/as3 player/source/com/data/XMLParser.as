package com.data {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class XMLParser {
		
		private var dataHolder:DataHolder;
		private var _callBackFunction:Function;
		private var _request:URLRequest;
		public var xXML:XML;
		private var loader:URLLoader;
		
		public function XMLParser($request:URLRequest, $callBackFunction:Function) {
			dataHolder = DataHolder.getInstance();
			_request = $request;
			_callBackFunction = $callBackFunction;
			loadXML();
		}
		
		private function loadXML():void {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, xmlIOError);
			loader.load(_request);
		}
		
		private function xmlLoadCompleteHandler($event:Event):void {
			xXML = new XML($event.target.data);
			dataHolder.xMainXml = xXML;
			loader.removeEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, xmlIOError);
			//dataHolder.sScaleMode = dataHolder.VIDEO_SCALE_FIT_HEIGHT;
			_callBackFunction();
		}
		
		private function xmlIOError($event:Event):void {
			trace ("IO ERROR"+$event);
			/*xXML = new XML($event.target.data);
			dataHolder.xMainXml = xXML;
			//dataHolder.sScaleMode = dataHolder.VIDEO_SCALE_FIT_HEIGHT;
			_callBackFunction();*/
		}
	}
}