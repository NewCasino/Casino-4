package com.ui.components {
	
	import com.data.DataHolder;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import gs.TweenLite;
	import gs.easing.Bounce;
	
	public class StatusPanel extends Sprite {
		
		public var txtTitle:TextField;
		public var txtDescription:TextField;
		public var txtStatus:TextField;
		public var mcBackground:Sprite;
		
		private const HEGHT:int = 50;
		private const SHOW_DELAY:int = 2000;
		
		public static var STATUS_NONE:int = 0;		
		public static var STATUS_ADVERTISE:int = 1;
		public static var STATUS_SEEKING:int = 2;
		public static var STATUS_BUFFERING:int = 3;
		
		private var trTimer:Timer;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function StatusPanel() {
			this.y = -this.HEGHT;			
			//trTimer = new Timer(this.SHOW_DELAY);
			//this.addListeners();
		}
		
		private function addListeners():void {
			trTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
		}
		
		private function removeListeners():void {
			
		}
		
		private function timerCompleteHandler():void {
			if (dataHolder.iCurStatus == StatusPanel.STATUS_BUFFERING || dataHolder.iCurStatus == StatusPanel.STATUS_SEEKING) {
				this.startCountDown();
			} else {				
				this.hide();
			}
		}
		
		private function startCountDown():void {
			setTimeout(timerCompleteHandler, this.SHOW_DELAY);
		}
		
		public function show():void {
			if (dataHolder.sDescription == "" && dataHolder.sTitle == "") {
				return;
			}
			TweenLite.to(this, 0.5, { y:0, ease:Bounce.easeOut } );
			this.updateText();
			this.startCountDown();
		}
		
		public function hide():void {
			TweenLite.to(this, 0.5, { y: -this.height } );
		}
		
		private function updateText():void {
			txtTitle.text = dataHolder.sTitle;
			txtDescription.text = dataHolder.sDescription;
			txtStatus.text = dataHolder.sStatus;
			//trace ("STATUS PANEL " + (dataHolder.sDescription == "") + "  " + (txtDescription.text == ""));
		}
		
		public function updateSize():void {
			this.x = 0;
			//this.y = 0;
			mcBackground.width = dataHolder.nStageWidth;
			txtStatus.x = dataHolder.nStageWidth - (txtStatus.width + 10);
			//trace (mcBackground.width + "  " + dataHolder.nStageWidth);
			mcBackground.height = this.HEGHT;
		}
	}
	
}