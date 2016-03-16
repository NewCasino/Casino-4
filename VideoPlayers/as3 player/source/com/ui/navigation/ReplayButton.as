package com.ui.navigation {
	import com.data.DataHolder;
	import com.ui.share.ShareVideoWindow;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ReplayButton extends MovieClip {
		
		
		public var mcEmbedButtons:MovieClip;
		public var mcReplayBtn:MovieClip;
		public var mcScrimBtn:MovieClip;
		public var mcCenter:MovieClip;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function ReplayButton() {
			super();			
			addListeners();
			mcReplayBtn.buttonMode = true;
			mcEmbedButtons.btnGetLink.buttonMode = true;
			mcEmbedButtons.btnGetEmbedCode.buttonMode = true;
			mcReplayBtn.mcLabel.txtLabel.mouseEnabled = false;
		}
		
		public function updateTexts():void {
			mcReplayBtn.mcLabel.txtLabel.text = dataHolder.xMainXml.buttonsname.replay.@value;
			mcEmbedButtons.txtLink.text = dataHolder.xMainXml.buttonsname.get_link.@value;
			mcEmbedButtons.txtEmbed.text = dataHolder.xMainXml.buttonsname.embed.@value;
		}
		
		private function addListeners():void {
			mcEmbedButtons.btnGetLink.addEventListener(MouseEvent.CLICK, getLinkClickHandler);
			mcEmbedButtons.btnGetEmbedCode.addEventListener(MouseEvent.CLICK, getEmbedCodeClickHandler);
			
			mcScrimBtn.addEventListener(MouseEvent.MOUSE_UP, btnReplayClickHandler);
			mcReplayBtn.addEventListener(MouseEvent.ROLL_OVER, btnReplayRollOverHandler);
			mcReplayBtn.addEventListener(MouseEvent.ROLL_OUT, btnReplayRollOutHandler);
			mcReplayBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnReplayMouseDownHandler);
		}
		
		private function removeListeners():void {
			mcEmbedButtons.btnGetLink.removeEventListener(MouseEvent.CLICK, getLinkClickHandler);
			mcEmbedButtons.btnGetEmbedCode.removeEventListener(MouseEvent.CLICK, getEmbedCodeClickHandler);
			
			mcScrimBtn.removeEventListener(MouseEvent.MOUSE_UP, btnReplayClickHandler);
			mcReplayBtn.removeEventListener(MouseEvent.ROLL_OVER, btnReplayRollOverHandler);
			mcReplayBtn.removeEventListener(MouseEvent.ROLL_OUT, btnReplayRollOutHandler);
			mcReplayBtn.removeEventListener(MouseEvent.MOUSE_DOWN, btnReplayMouseDownHandler);
		}
		
		private function getLinkClickHandler($event:MouseEvent):void {
			dataHolder._stage.showShareWindow(ShareVideoWindow.PANEL_LINK);
		}
		
		private function getEmbedCodeClickHandler($event:MouseEvent):void {
			dataHolder._stage.showShareWindow(ShareVideoWindow.PANEL_EMBED);
		}
		
		private function btnReplayClickHandler($event:MouseEvent):void {			
			mcReplayBtn.gotoAndStop('up');
					
		}
		
		private function btnReplayRollOverHandler($event:MouseEvent):void {
			mcReplayBtn.gotoAndStop('over');
		}
		
		private function btnReplayRollOutHandler($event:MouseEvent):void {
			mcReplayBtn.gotoAndStop('up');			
		}
		
		private function btnReplayMouseDownHandler($event:MouseEvent):void {
			mcReplayBtn.gotoAndStop('down');
			dataHolder._stage.hideReplayWindowAndStart();
		}
	}
}