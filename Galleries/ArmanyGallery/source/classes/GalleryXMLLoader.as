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
			urlLoader.addEventListener(Event.COMPLETE, xmlLoaded, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError, false, 0, true);
			
			try {
                urlLoader.load(request);
            } catch (error:SecurityError) {
                trace("A SecurityError has occurred.");
            }
			
		}
		
		private function xmlLoaded(e:Event):void {			
			var xml:XML = new XML(e.target.data);
			var galleryData:Object = { };
			var imageObjects:Array = new Array();
			
			if (xml.hasOwnProperty("@thumbFolder")) {
				galleryData.thumbFolder = xml.@thumbFolder;
			} else {
				galleryData.thumbFolder = '';
			}
			
			if (xml.hasOwnProperty("@imageFolder")) {
				galleryData.imageFolder = xml.@imageFolder;
			} else {
				galleryData.imageFolder = '';
			}
			
			if (xml.hasOwnProperty("@thumbsGap")) {
				galleryData.thumbsGap = int(xml.@thumbsGap);
			} else {
				galleryData.thumbsGap = 5;
			}
			
			if (xml.hasOwnProperty("@thumbWidth")) {
				galleryData.thumbWidth = int(xml.@thumbWidth);
			} else {
				galleryData.thumbWidth = 200;
			}
			
			if (xml.hasOwnProperty("@thumbHeight")) {
				galleryData.thumbHeight = int(xml.@thumbHeight);				
			} else {
				galleryData.thumbHeight = 300;
			}
			
			if (xml.hasOwnProperty("@imageWidth")) {
				galleryData.imageWidth = int(xml.@imageWidth);
			} else {
				galleryData.imageWidth = 225;
			}
			
			if (xml.hasOwnProperty("@imageHeight")) {
				galleryData.imageHeight = int(xml.@imageHeight);				
			} else {
				galleryData.imageHeight = 338;
			}
			
			if (xml.hasOwnProperty("@thumbBorder")) {
				if (xml.@thumbBorder == 'true') {
					galleryData.thumbBorder = true;
				} else {
					galleryData.thumbBorder = false;
				}
			} else {
				galleryData.thumbBorder = false;
			}
			
			if (xml.hasOwnProperty("@thumbBorderColor")) {
				galleryData.thumbBorderColor = int(xml.@thumbBorderColor);
			} else {
				galleryData.thumbBorderColor = 0x000000;
			}
			
			if (xml.hasOwnProperty("@thumbBorderRollOverColor")) {
				galleryData.thumbBorderRollOverColor = int(xml.@thumbBorderRollOverColor);
			} else {
				galleryData.thumbBorderColor = 0xffffff;
			}
			
			galleryData.backImageUrl = xml.background.@url;
			galleryData.galleryName = xml.title.@name;			
			galleryData.closeLabel = xml.closebutton.@label;
			galleryData.closeUrl = xml.closebutton.@url;
			
			var xList:XMLList = new XMLList();
			xList =  xml.images.children();
			var tmpObj:Object;
			for (var i:int = 0; i < xList.length(); i++) {
				tmpObj = { };
				tmpObj.thumbBorder = galleryData.thumbBorder;
				tmpObj.thumbBorderColor = galleryData.thumbBorderColor;
				tmpObj.thumbBorderRollOverColor = galleryData.thumbBorderRollOverColor;				
				tmpObj.thumbWidth = galleryData.thumbWidth;
				tmpObj.thumbHeight = galleryData.thumbHeight;
				tmpObj.thumbsGap = galleryData.thumbsGap;
				tmpObj.thumbUrl = galleryData.thumbFolder + '/' + xList[i].@thumbUrl;
				tmpObj.imageUrl = galleryData.imageFolder + '/' + xList[i].@imageUrl;	
				tmpObj.imageText = xList[i];				
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