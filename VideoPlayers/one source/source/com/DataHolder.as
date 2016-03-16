package com {
	
	public class DataHolder {
		
		public static var dataHolder:DataHolder;
		
		
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
			return min + ':' + sec;
		}
		
		
	}
}