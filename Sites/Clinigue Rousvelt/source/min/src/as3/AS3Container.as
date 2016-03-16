package as3 {
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
	import flash.net.LocalConnection;
    import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
    public class AS3Container extends Sprite {
		
        private var url:String = "init.swf";
		
		private var lconnection:LocalConnection;
		private var messageLabel:TextField;
		
		private var mainLoader:Loader = new Loader();
		private var mapLoader:Loader = new Loader();
		private var mapRequest:URLRequest = new URLRequest("swfs/cliniqueMap.swf");
		
		private var mapX:int;
		private var mapY:int;
		private var mapWidth:int;
		private var mapHeight:int;
		
		private var mapLoaded:Boolean = false;
		
		
        public function AS3Container() {			
            configureListeners();
            var request:URLRequest = new URLRequest(url);
            mainLoader.load(request);
            addChild(mainLoader);
			
			lconnection = new LocalConnection();
			lconnection.client = this;
            try {
                lconnection.connect("as3bridgeconnection");
            } catch (error:ArgumentError) {
                trace("Can't connect...the connection name is already being used by another SWF");
            }
			messageLabel = new TextField();
            messageLabel.x = 10;
            messageLabel.y = 10;
            messageLabel.text = "Text to send:";
            messageLabel.autoSize = TextFieldAutoSize.LEFT;
            addChild(messageLabel);
			mapLoader.load(mapRequest);
        }
		
        private function configureListeners():void {
            mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
            mainLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
            mainLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			
			mapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, mapCompleteHandler, false, 0, true);
            mapLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, mapHttpStatusHandler, false, 0, true);
            mapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, mapIoErrorHandler, false, 0, true);
        }
		
		private function mapIoErrorHandler(e:IOErrorEvent):void {
			trace("ioErrorHandler: " + e);
		}
		
		private function mapHttpStatusHandler(e:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + e);
		}
		
		private function mapCompleteHandler(e:Event):void {
			throw new Error("Map loaded");
			this.addChild(mapLoader);
			this.setMapPosition();
			mapLoaded = true;
		}
		
        private function completeHandler(event:Event):void {
            //trace("completeHandler: " + event);
			
        }
		
        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }
        
		private function loadMap():void {
			mapLoader.load(mapRequest);
		}
		
		private function setMapPosition():void {
			if (!mapLoaded) {
				return;
			}
			mapLoader.x = mapX;
			mapLoader.y = mapY;
			mapLoader.width = mapWidth;
			mapLoader.height = mapHeight;
		}
		
		public function unloadMap():void {
			mapLoader.visible = false;
		}
		
		public function showMap():void {
			if (mapLoaded) {
				mapLoader.visible = true;
			} else {
				this.loadMap();
			}
		}
		
		public function updateMapPosition($position:Object):void {
			trace($position.width);
			
			if ($position.x != undefined) {
				mapX = $position.x;	
			}
			if ($position.y != undefined) {
				mapY = $position.y;
			}
			if ($position.width != undefined) {
				mapWidth = $position.width;
			}
			if ($position.height != undefined) {
				mapHeight = $position.height;
			}
			
			this.setMapPosition();
			messageLabel.appendText("x: "+$position.x + ", y: "+$position.y + ", width: "+$position.width + ", height: "+$position.height + "\n");
		}
		
    }
}