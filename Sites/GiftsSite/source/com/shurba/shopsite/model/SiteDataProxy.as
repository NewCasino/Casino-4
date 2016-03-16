package com.shurba.shopsite.model {
	import com.greensock.dataTransfer.XMLManager;
	import com.shurba.shopsite.ApplicationFacade;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class SiteDataProxy extends Proxy implements IProxy {
		
		public static const NAME:String = "SiteDataProxy";
		public static const DATA_URL:String = "data/tfile_main.xml";
		
		//XML parameters constants
		public static const READ_MORE:String = "readmore";
		public static const PRIVACY_POLICY:String = "privacyPolicy";
		
		public function SiteDataProxy() {
			super(NAME, new Object() );
			
			var loader:URLLoader = new URLLoader();
            loader.addEventListener( Event.COMPLETE, onDataLoaded );
            
            try {
                loader.load( new URLRequest( DATA_URL ));
            } catch ( error:Error ) {
                trace( "Unable to load requested document." );
            }			
		}
		
		private function onDataLoaded( $event:Event ):void {
			var dataXML:XML = new XML( $event.target.data );			
			var $data:Object = XMLManager.XMLToObject(dataXML);
			this.setData($data);
			/**
			 * When SiteDataProxy is done loading and parsing data, it 
			 * sends an INITIALIZE_SITE notification back to the framework.
			 */
			sendNotification( ApplicationFacade.INITIALIZE_SITE );
		}
		
		private function getXmlSectionNumber(itemName:String,  sectionName:String):int {
			var i:int = 0;
			while (data[itemName][i]) {
				if (data[itemName][i].name == sectionName) {					
					return (i);					
				}
				i++;
			}
			return -1;
		}
		
		public function getMenuLink (linkNum:int):String {
			var sectionNum:int = getXmlSectionNumber("section",  "menu");			
			return data["section"][sectionNum].link[linkNum].nodeValue;			
		}
		
		public function getCopyright():String {
			return getSettingsValue("copyright", "item");			
		}
		
		public function getSlogan():String {
			return getSettingsValue("slogan", "item");			
		}
		
		public function getCompanyName ():String {			
			return getSettingsValue("companyName", "item");			
		}
		
		public function getSettingsValue (itemName:String,  itemType:String) {
			var sectionNum:int = getXmlSectionNumber("section",  "settings");
			var i:int = 0;
			while (data["section"][sectionNum][itemType][i]) {
				if (data["section"][sectionNum][itemType][i].name == itemName) {
					return (data.section[sectionNum][itemType][i].nodeValue);
				}
				i++;
			}
		}
		
		public function getCurrentText(textNumber:int):String {
			var sectionNum:int = getXmlSectionNumber("section", "pages");
			var currentPage:int = (facade as ApplicationFacade).currentLink - (facade as ApplicationFacade).firstPage;
			return data["section"][sectionNum]["page"][currentPage]["texts"][0]["pageText"][textNumber].nodeValue;
		}
		
		public function getMenuSystemOrder (linkNum:int):int {
			var sectionNum:int = getXmlSectionNumber("section", "menu");
			return (data["section"][sectionNum].link[linkNum].systemOrder);
			
		}

	}

}