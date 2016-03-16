package com.data {
	import com.DocumentClass;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	public class DataHolder {
		
		public static var dataHolder:DataHolder;
		
		public var nVideoDuration:int;
		public var sVideoSource:String = "";
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
		
		public var sVideoID:Number = 1;
		public var sHome:Number = -1;
		public var sXmlUrl:String = 'data.xml';
		public var sXmlAdvUrl:String = 'text_ads.xml';
		public var xMainXml:XML;
		public var _stage:DocumentClass;
		public var eventDispatcher:EventDispatcher = new EventDispatcher();
		public var nMaxVideoWidth:Number;
		public var nMaxVideoHeight:Number;
		public var nOrigVideoWidth:Number;
		public var nOrigVideoHeight:Number;
		
		public var nStageWidth:Number;
		public var nStageHeight:Number;
		
		public var nVolume:Number = 0.75;
		
		public var sCurrentVideo:String;
		public static const CURRENT_PLAYING_PREROLL:String = "preroll";
		public static const CURRENT_PLAYING_VIDEO:String = "video";
		public static const CURRENT_PLAYING_POSTROLL:String = "postroll";
		
		public const VIDEO_SCALE_FIT_WIDTH:String = 'fitWidth';
		public const VIDEO_SCALE_FIT_HEIGHT:String = 'fitHeight';
		public const VIDEO_SCALE_DEFAULT:String = 'default';
		public const VIDEO_SCALE_MANUAL:String = 'manual';
		public var sScaleMode:String;
		
		public var logo:Boolean = false;
		
		public var brand_name:String = "Saish company"
		public var brand_link:String = "http://www.saish.com/"
		
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
			if($value.length==1){
				return '0'+ $value
			} else {
				return $value
			}
		}		
		
		public function secondsToTime($nSeconds:Number):String {
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