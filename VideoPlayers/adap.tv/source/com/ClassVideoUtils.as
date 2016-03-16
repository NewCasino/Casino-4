package com{

	public class ClassVideoUtils{
		
		function ClassVideoUtils(){
		}
		
		public static function addZerro(value:String):String{
			if(value.length==1){
				return '0'+ value
			}else return value
		}
		public static function maketime(timevalue:Number):String{
			var time = timevalue
			if(isNaN(time))time = 0
			var min  = Math.floor( time / 60)
			var sec  = Math.floor(time-min*60)
			sec = addZerro(String(sec))
			min = addZerro(String(min))			
			
			return min+':'+sec
		}	
	}
	
}
