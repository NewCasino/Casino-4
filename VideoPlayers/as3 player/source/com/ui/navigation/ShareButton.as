package com.ui.navigation {
	
	import com.data.DataHolder;
	import com.ui.share.ShareVideoWindow;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ShareButton extends MovieClip {
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function ShareButton() {
			super();
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			this.buttonMode = true;
		}
		
		private function clickHandler($event:MouseEvent):void {
			dataHolder._stage.showShareWindow(ShareVideoWindow.PANEL_EMBED);			
		}
	}
	
}