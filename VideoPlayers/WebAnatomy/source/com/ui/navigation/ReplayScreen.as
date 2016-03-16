package com.ui.navigation {
	
	import com.ui.components.SimpleButton;
	import com.ui.components.VideoList;
	import com.ui.navigation.ReplayButton;
	import com.data.DataHolder;
	import com.ui.share.ShareVideoWindow;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	import com.control.ControlsHolder;
	
	[Event("close", type = "Event")]
	[Event("replay", type = "Event")]
	
	public class ReplayScreen extends MovieClip {
		
		public var mcTurnDown:Sprite;
		public var mcTurnUp:Sprite;
		public var mcClose:Sprite;
		public var btnReplay:ReplayButton;
		public var videoPlayList:VideoList;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();
		
		public function ReplayScreen() {
			super();
			mcTurnUp.buttonMode = true;
			mcTurnDown.buttonMode = true;
			mcClose.buttonMode = true;
			
			mcTurnUp.alpha = 0.5;
			mcTurnDown.alpha = 0.5;
			mcClose.alpha = 0.5;
			
			videoPlayList = new VideoList();
			this.addChild(videoPlayList);
			controlsHolder.videoPlayList = this.videoPlayList;
			this.addListeners();
			this.updateTexts();
		}
		
		public function updateTexts():void {
			btnReplay.label = dataHolder.xMainXml.buttonsname.replay.@value;			
		}
		
		private function addListeners():void {			
			btnReplay.addEventListener(MouseEvent.CLICK, replay);
			mcTurnUp.addEventListener(MouseEvent.CLICK, turnListUp);
			mcTurnDown.addEventListener(MouseEvent.CLICK, turnListDown);
			mcClose.addEventListener(MouseEvent.CLICK, close);
			mcTurnUp.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			mcTurnDown.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			mcClose.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			mcTurnUp.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			mcTurnDown.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			mcClose.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
		}
		
		private function removeListeners():void {			
			btnReplay.removeEventListener(MouseEvent.CLICK, replay);
			mcTurnUp.removeEventListener(MouseEvent.CLICK, turnListUp);
			mcTurnDown.removeEventListener(MouseEvent.CLICK, turnListDown);
			mcClose.removeEventListener(MouseEvent.CLICK, close);
			mcTurnUp.removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			mcTurnDown.removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			mcClose.removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			mcTurnUp.removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			mcTurnDown.removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			mcClose.removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
		}
		
		private function replay($event:MouseEvent):void {
			this.hide();
			this.dispatchEvent(new Event("replay"));
		}
		
		private function close($event:MouseEvent):void {
			this.hide();
			this.dispatchEvent(new Event("close"));			
		}
		
		function onRollOverHandler($event:MouseEvent):void {			
			TweenLite.to($event.target, 0.25, { alpha:1 } );
		}
		
		function onRollOutHandler($event:MouseEvent):void {			
			TweenLite.to($event.target, 0.25, { alpha:0.75 } );
		}
		
		private function turnListUp($event:MouseEvent):void {
			videoPlayList.turnUp();
		}
		
		private function turnListDown($event:MouseEvent):void {
			videoPlayList.turnDown();
		}
		
		private function btnReplayClickHandler($event:MouseEvent):void {
			trace ("REPLAY BUTTON CLICK");			
			//mcReplayBtn.gotoAndStop('up');
		}
		
		public function hide():void {
			this.visible = false;
		}
		
		public function updateSize():void {
			this.x = (dataHolder.nStageWidth - videoPlayList.width) / 2;
			this.y = (dataHolder.nStageHeight - videoPlayList.height) / 2;
			btnReplay.x = (videoPlayList.width - btnReplay.width) / 2;
			btnReplay.y = videoPlayList.y - (btnReplay.height + 15);
			
			mcTurnDown.x = btnReplay.x - 20;			
			mcTurnDown.y = (btnReplay.height - mcTurnDown.height) / 2 + btnReplay.y;
			
			mcTurnUp.x = btnReplay.x + btnReplay.width + 20;
			mcTurnUp.y = (btnReplay.height - mcTurnDown.height) / 2 + btnReplay.y;
			
			mcClose.x = videoPlayList.x + videoPlayList.width + 15;
			mcClose.y = videoPlayList.y
			
		}
	}
}