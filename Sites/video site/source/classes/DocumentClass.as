package classes {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		public var contactsWin:Contacts;
		public var menu:Menu;
		public var background:Sprite;
		
		public var videoOut:Sprite;
		public var video:Video;
		
		private var videoURL:String = "Video.flv";
        private var connection:NetConnection;
        private var stream:NetStream;
		
		public function DocumentClass() {
			super();
			this.loaderInfo.addEventListener(Event.COMPLETE, initApplication, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, _listenLoading, false, 0, true);// on enter frame to check if it’s loaded  
			
			
		}
		
		private function playVideo():void {
			connection = new NetConnection();
            connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            connection.connect(null);
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void {
			
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Unable to locate video: " + videoURL);
                    break;
            }
		}
		
		private function connectStream():void {
            stream = new NetStream(connection);
            stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);            
            video = new Video();
			video.attachNetStream(stream);
			video.smoothing = true;
            stream.play(videoURL);
            videoOut.addChild(video);
			this.onStageResizeHandler(null);
        }
		
		private function asyncErrorHandler(e:AsyncErrorEvent):void {
			 // ignore AsyncErrorEvent events.
		}
		
		private function _listenLoading($event:Event):void {  
			if (root.loaderInfo.bytesLoaded == root.loaderInfo.bytesTotal) {
				this.initApplication(new Event(""));  
			}  
		}
		
		private function initApplication(e:Event):void {
			
			this.loaderInfo.removeEventListener(Event.COMPLETE, initApplication);			
			this.removeEventListener(Event.ENTER_FRAME, _listenLoading);
			
			menu.addEventListener("contacts", contactsClickHandler);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			root.stage.addEventListener(Event.RESIZE, onStageResizeHandler, false, 0, true);
			
			videoOut = new Sprite();
			this.addChildAt(videoOut, 1);
			
			this.onStageResizeHandler(null);
			
			this.playVideo();
			
		}
		
		private function contactsClickHandler(e:Event):void {
			contactsWin.show();
		}
		
		private function onStageResizeHandler(e:Event):void {
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			contactsWin.x = (stage.stageWidth - contactsWin.width) / 2;
			contactsWin.y = (stage.stageHeight - contactsWin.height) / 2;
			
			menu.x = 30;
			menu.y = stage.stageHeight - menu.height;
			
			videoOut.width = stage.stageWidth;
			videoOut.height = stage.stageHeight;
			//trace (this.height +"  " +menu.height);
		}
		
	}

}