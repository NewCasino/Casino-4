package classes {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class GalleryXMLLoader {
		
		
		private var callBack:Function;
		//private 
		
		public function GalleryXMLLoader($xmlURL:String, $callBack:Function) {			
			if ($xmlURL == '') {
				throw new Error('GalleryXMLLoader: not valid XML path.');
			} 
			if ($callBack == null) {
				throw new Error('GalleryXMLLoader: not valid callback function.');
			}
			callBack = $callBack;
			this.loadXML($xmlURL);
		}
		
		private function loadXML($url):void	{
			var request:URLRequest = new URLRequest($url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			
			try {
                urlLoader.load(request);
            } catch (error:SecurityError) {
                trace("A SecurityError has occurred.");
            }
			
		}
		
		private function xmlLoaded(e:Event):void {
			(e.currentTarget as URLLoader).removeEventListener(Event.COMPLETE, xmlLoaded);
			(e.currentTarget as URLLoader).removeEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			
			var xml:XML = new XML(e.target.data);
			var galleryData:Object = { };
			var imageObjects:Array = new Array();
			
			if (xml.hasOwnProperty("@imageWidth")) {
				galleryData.imageWidth = int(xml.@imageWidth);
			} else {
				galleryData.imageWidth = 733;
			}
			
			if (xml.hasOwnProperty("@imageHeight")) {
				galleryData.imageHeight = int(xml.@imageHeight);				
			} else {
				galleryData.imageHeight = 255;
			}
			
			galleryData.logoUrl = xml.logo.@url;
			galleryData.logoLink = xml.logo.@link;
			
			var xList:XMLList = new XMLList();
			xList =  xml.images.children();
			var tmpObj:Object;
			for (var i:int = 0; i < xList.length(); i++) {
				tmpObj = { };
				tmpObj.imageWidth = galleryData.imageWidth;
				tmpObj.imageHeight = galleryData.imageHeight;				
				tmpObj.smallText = xList[i].@smallText;				
				tmpObj.bigText = xList[i].@bigText;				
				tmpObj.imageUrl = xml.@folderUrl + '/' + xList[i].@imageUrl;					
				tmpObj.imageLink = xList[i].@link;				
				imageObjects.push(new ImageVO(tmpObj));
			}
			
			galleryData.imageObjects = imageObjects;
			
			this.callBack(galleryData);
		}
		
		private function xmlLoadError(e:IOErrorEvent):void {
			trace (e);
		}
		
	}

}