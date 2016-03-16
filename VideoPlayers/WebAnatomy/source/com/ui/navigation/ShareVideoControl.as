package com.ui.navigation {
	
	import com.control.ControlsHolder;
	import com.events.ShareControlEvent;
	import com.ui.share.ShareVideoWindow;
	import fl.motion.Color;
	import flash.events.Event;
	//import com.ui.components.EmbedButton;
	import com.data.DataHolder;	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	
	[Event("shareControlClick", type = "com.events.ShareControlEvent")]
	
	public class ShareVideoControl extends MovieClip {
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();
		
		private var bOpened:Boolean = false;
		
		
		public var mcClip:MovieClip;
		public var mcEnvelope:MovieClip;
		public var mcEmbedCode:MovieClip;
		
		private var uiColorActive:uint;
		private var uiColorNormal:uint;
		
		public function ShareVideoControl() {
			super();
			
			mcClip.mouseEnabled = true;
			mcEnvelope.mouseEnabled = true;
			mcEmbedCode.mouseEnabled = true;
			
			mcClip.buttonMode = true;
			mcEnvelope.buttonMode = true;
			mcEmbedCode.buttonMode = true;
			
			this.mouseEnabled = false;
			
			mcClip.addEventListener(MouseEvent.MOUSE_OVER, onBtnOver);
			mcEnvelope.addEventListener(MouseEvent.MOUSE_OVER, onBtnOver);
			mcEmbedCode.addEventListener(MouseEvent.MOUSE_OVER, onBtnOver);
			
			mcClip.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			mcEnvelope.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			mcEmbedCode.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			
			mcClip.addEventListener(MouseEvent.CLICK, mcClipClickHandler);
			mcEnvelope.addEventListener(MouseEvent.CLICK, mcEnvelopeClickHandler);
			mcEmbedCode.addEventListener(MouseEvent.CLICK, mcEmbedCodeClickHandler);
		}
		
		/*
		private function clickHandler($event:MouseEvent):void {
			trace ("CLICK"+ $event.target.name);
			switch ($event.target) {
				case mcClip: {
					trace ("mcClip");
					break;
				}
				
				case mcEnvelope: {
					trace ("mcEnvelope");
					break;
				}
				
				case mcEmbedCode: {
					trace ("mcEmbedCode");
					break;
				}
			}
			//dataHolder._stage.showShareWindow(ShareVideoWindow.PANEL_EMBED);			
		}
		*/
		
		private function mcClipClickHandler($event:MouseEvent):void {
			var $shareControlEvent:ShareControlEvent = new ShareControlEvent(ShareControlEvent.SHARE_CONTROL_CLICK);
			$shareControlEvent.panelID = ShareVideoWindow.PANEL_LINK;
			this.dispatchEvent($shareControlEvent);
		}
		
		private function mcEnvelopeClickHandler($event:MouseEvent):void {
			var $shareControlEvent:ShareControlEvent = new ShareControlEvent(ShareControlEvent.SHARE_CONTROL_CLICK);
			$shareControlEvent.panelID = ShareVideoWindow.PANEL_EMAIL;
			this.dispatchEvent($shareControlEvent);
		}
		
		private function mcEmbedCodeClickHandler($event:MouseEvent):void {
			var $shareControlEvent:ShareControlEvent = new ShareControlEvent(ShareControlEvent.SHARE_CONTROL_CLICK);
			$shareControlEvent.panelID = ShareVideoWindow.PANEL_EMBED;
			this.dispatchEvent($shareControlEvent);
		}
		
		private function onBtnOver($event:MouseEvent):void {
			var mc:MovieClip = $event.currentTarget as MovieClip;
			TweenLite.to(mc, 0.5, { tint:uiColorActive } );
			
			var data:Object = new Object();			
			data.stageWidth = dataHolder.nStageWidth;
			data.x = $event.currentTarget.x + this.x;
			data.y = $event.currentTarget.y;
		
			switch ($event.currentTarget) {
				case mcClip : {					
					data.message = dataHolder.xMainXml.tooltips.link;
					controlsHolder.navigation.showToolTip(data);
					break;
				}
				
				case mcEnvelope : {					
					data.message = dataHolder.xMainXml.tooltips.email;
					controlsHolder.navigation.showToolTip(data);
					break;
				}
				
				case mcEmbedCode : {					
					data.message = dataHolder.xMainXml.tooltips.embed;
					controlsHolder.navigation.showToolTip(data);
					break;
				}
			}
			
		}
		
		private function onBtnOut($event:MouseEvent):void {
			var mc:MovieClip = $event.target as MovieClip;
			TweenLite.to(mc, 0.5, { tint:uiColorNormal } );
			controlsHolder.navigation.hideToolTip();
		}
		
		public function set normalColor($color:uint):void {
			uiColorNormal = $color;
			this.updateSkin();
		}
		
		public function set activeColor($color:uint):void {
			uiColorActive = $color;
		}
		
		public function updateSkin():void {
			var $skinColor:Color = new Color();
			$skinColor.setTint(uiColorNormal, 1);
			mcClip.transform.colorTransform = $skinColor;
			mcEnvelope.transform.colorTransform = $skinColor;
			mcEmbedCode.transform.colorTransform = $skinColor;
		}
	}
	
}