package classes {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DocumentClass extends Sprite {
		
		public var mc100, mc101, mc102, mc103, mc104, mc105, mc106, mc107, mc108, mc109, mc110, mc111, mc112, mc113, mc200, mc201, mc202, mc203, mc204, mc205, mc206, mc207, mc208, mc209, mc300, mc301, mc302, mc303, mc304, mc305, mc306, mc307, mc308, mc309, mc310, mc400, mc401, mc402, mc403, mc404, mc405, mc406, mc407, mc408, mc409, mc500, mc501, mc502, mc503, mc504, mc505, mc506, mc507, mc508, mc509, mc510, mc511 : MovieClip;
		
		private var arrRooms:Array;
		private const XML_DATA_PATH:String = "rooms.txt";
		
		private var request:URLRequest;
		private var loader:URLLoader = new URLLoader();
		
		public function DocumentClass() {
			arrRooms = [mc100, mc101, mc102, mc103, mc104, mc105, mc106, mc107, mc108, mc109, mc110, mc111, mc112, mc113, mc200, mc201, mc202, mc203, mc204, mc205, mc206, mc207, mc208, mc209, mc300, mc301, mc302, mc303, mc304, mc305, mc306, mc307, mc308, mc309, mc310, mc400, mc401, mc402, mc403, mc404, mc405, mc406, mc407, mc408, mc409, mc500, mc501, mc502, mc503, mc504, mc505, mc506, mc507, mc508, mc509, mc510, mc511];
			/*for (var i:int = 0; i < arrRooms.length; i++) {
				if (arrRooms[i]) {
					arrRooms[i].alpha = 0;
				}
				
			}*/
			
			request = new URLRequest(XML_DATA_PATH);
			this.loadData();
		}
		
		private function loadData():void {
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(request);
		}
		
		private function loaderCompleteHandler(e:Event):void {
			/*var array:Array = new Array();
			var tmpString:String = e.target.data;
			array = tmpString.split("\n");
			
			//trace (array);
			//trace ();
			this.cleanArray(array);*/
			
			var array:Array = new Array();
			var tmpString:String = e.target.data;
			var re:RegExp =  /\r\n|\r|\n/g;
			var sReplase:String = tmpString.replace(re, ",");
			
			array = sReplase.split(",");
			for (var i:int = 0; i < array.length; i++) {
				var name:String = "mc" + array[i];
				if (this[name]) {
					this[name].gotoAndStop(2);
				}
			}
			/*for (i = 0; i < arrRooms.length; i++) {
				if (arrRooms[i]) {
					TweenLite.to(arrRooms[i], 0.75, { alpha:1 } );
				}
				
				//arrRooms[i].alpha = 0;
			}*/
		}
		
		/*private function cleanArray($arr:Array):void {
			var tmpString:String = "";
			var name:String;
			for (var i:int = 0; i < $arr.length; i++) {
				tmpString = $arr[i];
				tmpString = tmpString.substr(0, 3);
				$arr[i] = tmpString;
				name = "mc" + $arr[i];
				if (this[name]) {
					this[name].gotoAndStop(2);
					//trace (this[name]);
				}
				
			}
			//trace ($arr);
		}*/
		
		private function loaderErrorHandler(e:IOErrorEvent):void {
			trace ("loader error " + e);
		}
		
		
		
	}
	
}