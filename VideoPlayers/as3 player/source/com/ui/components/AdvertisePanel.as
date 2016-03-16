package com.ui.components {
	
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.ui.components.AdvertiseRotator;
	import flash.utils.setTimeout;
	import gs.TweenLite;
	
	public class AdvertisePanel extends MovieClip {
		
		public var mcMask:MovieClip;
		public var mcShowRotatorBtn:MovieClip;
		public var advRotator:AdvertiseRotator;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public function AdvertisePanel() {
			super();
			
			mcShowRotatorBtn.useHandCursor = true;
			mcShowRotatorBtn.buttonMode = true;
			mcShowRotatorBtn.alpha = 0;
			advRotator.y = 100;
			advRotator.mask = mcMask;
			this.addListeners();
			advRotator.init(onAdvPanelReady, hideRotator);
		}
		
		private function addListeners():void {
			mcShowRotatorBtn.addEventListener(MouseEvent.CLICK, clickShowRotatorBtnHandler);
		}
		
		private function removeListeners():void {
			mcShowRotatorBtn.addEventListener(MouseEvent.CLICK, clickShowRotatorBtnHandler);
		}
		
		public function hideRotator():void {
			if (!advRotator.bXMLGood) {
				return;
			}
			TweenLite.to(advRotator, 0.5, { y:advRotator.height } );
			TweenLite.to(mcShowRotatorBtn, 0.5, { alpha:1 } );
			dataHolder.bRotatorOpen = false;
		}
		
		public function showRotator():void {
			if (!advRotator.bXMLGood) {
				return;
			}
			TweenLite.to(advRotator, 0.7, { y:0 } );
			TweenLite.to(mcShowRotatorBtn, 0.7, { alpha:0 } );
			startRotator();
			dataHolder.bRotatorOpen = true;			
		}
		
		private function startRotator():void {
			advRotator.startRotate();
		}
		
		private function stopRotator():void {
			advRotator.killRotateTimeout();
		}
		
		private function onAdvPanelReady():void {
			//trace ("ADV READY");
			if (!advRotator.bXMLGood) {
				this.removeListeners();
				this.visible = false;
			}
		}
		
		private function clickShowRotatorBtnHandler($event:MouseEvent):void {
			this.showRotator();
		}
		
		private function getUrlLinkAndLoad():void {
			
		}
		
		public function updateSize():void {
			if (!advRotator.bXMLGood) {
				return;
			}
			mcShowRotatorBtn.x = dataHolder.nStageWidth - 30;
			mcShowRotatorBtn.y = 55;
			this.x = 0;
			this.y = dataHolder.nStageHeight - 41 - 71;
			advRotator.updateSize();
			mcMask.width = advRotator.width;
			mcMask.height = advRotator.height;
		}
	}
	
}