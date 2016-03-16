package com{
	import flash.display.Sprite;
	import flash.net.URLRequest;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.*;
	class XMLParser extends Sprite{
		private var onComplete:Function;
		private var xml_path:String;
		public static var mainXML:XML;
		public function XMLParser(path, $onComplete)
		{
			xml_path = path;
			onComplete = $onComplete
			load(path)
		}		
		function load(path)
		{
           var initXMLloader:URLLoader = new URLLoader()
           initXMLloader.load(new URLRequest(path))
           initXMLloader.addEventListener(Event.COMPLETE, initXMLparse)
		}
		function initXMLparse(e:Event)
		{
			mainXML = new XML(e.target.data)  
			onComplete()
			mainXML = null;
		}
	}
}