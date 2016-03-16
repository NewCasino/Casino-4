package com.data {
	import fl.motion.Color;
	
	public class DataHolder {
		
		public static var dataHolder:DataHolder;
		
		//VIDEO DATA
		public var nVideoDuration:Number;
		public var nOrigVideoWidth:int;
		public var nOrigVideoHeight:int;
		public var nMaxVideoWidth:Number;
		public var nMaxVideoHeight:Number;		
		public var sSDVideoPath:String;
		public var sHDVideoPath:String;
		
		//BOOLEAN DATA
		public var bVideoLoop:Boolean = true;
		public var bAutoPlay:Boolean = false;
		public var bPaused:Boolean = false;
		public var bStoped:Boolean = true;
		public var bSeek:Boolean = false;
		public var bSoundMuted:Boolean = false;
		public var bReplayState:Boolean = false;
		public var bStartState:Boolean = true;
		public var bRotatorOpen:Boolean = false;		
		public var bPrerollDone:Boolean = false;
		public var bVideoDone:Boolean = false;
		public var bPostrollDone:Boolean = false;
		public var bIsHD:Boolean = false;
		
		//DATA FROM FLASH VARS//
		public var sMainXmlUrl:String = 'data.xml';
		public var sXmlAdvUrl:String = 'text_ads.xml';
		
		//public var MAIN_XML_PATH:String = 'data.xml';
		//public var ADS_XML_PATH:String = 'text_ads.xml';
		
		public var sVideoID:String;
		public var sHome:String;
		
		//XML DATA//
		public var xMainXml:XML;
		
		//SIZE DATA
		public var nStageWidth:Number;
		public var nStageHeight:Number;
		
		//STATUS PANEL DATA
		public var sStatus:String = "";
		public var sTitle:String = "";
		public var sDescription:String = "";
		public var iCurStatus:int = 0;
		
		//SHARE WINDOW DATA
		public var iCurrentShareWindow:int = -1;
		public var sCurrentVideo:String = "";
		public static const CURRENT_PLAYING_PREROLL:String = "preroll";
		public static const CURRENT_PLAYING_VIDEO:String = "video";
		public static const CURRENT_PLAYING_POSTROLL:String = "postroll";		
		
		//GUI COLOR DATA
		public var fontColorNormal:uint;
		public var fontColorActive:uint;
		public var aColors:Array;
		public var aAlphas:Array;
		public var aRatios:Array;
		
		//COMPILE DATA
		public const USE_HARDCODED_DATA:Boolean = false;
		
		public const DEFAULT_GRADIENT_COLORS:Array = [0xf7f7f7, 0xf6f6f6, 0x0066cc];
		public const DEFAULT_GRADIENT_ALPHAS:Array = [1, 0.8, 0.5];
		public const DEFAULT_GRADIENT_RATIOS:Array = [0x00, 0x7f, 0xFF];
		
		public const DEFAULT_FONT_COLOR:uint = 0x535252;
		public const DEFAULT_FONT_ACTIVE_COLOR:uint = 0x0066cc;
		
		public function DataHolder() {
			if (dataHolder) {
				throw new Error( "Only one DataHolder instance should be instantiated" );
			}
		}
		
		public static function getInstance():DataHolder {
			if (dataHolder == null) {
				dataHolder = new DataHolder();
			}
			return dataHolder;
		}
		
		public static function addZerro($value:String):String{
			if ($value.length == 1) {
				return '0'+ $value
			} else {
				return $value
			}
		}		
		
		public static function secondsToTime($nSeconds:Number):String {
			var time = $nSeconds;
			if (isNaN(time)) time = 0;
			var min  = Math.floor( time / 60);
			var sec  = Math.floor(time-min * 60);
			sec = addZerro(String(sec));
			min = addZerro(String(min));
			return min+':'+sec
		}
	}
}