package com.ui.share {
	
	import com.ui.share.EmailPanel;
	import com.ui.share.LinkPanel;
	import com.ui.share.EmbedPanel;
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	
	[Event("close", type = "Event")]
	
	public class ShareVideoWindow extends Sprite {
		
		public var mcPanel:Sprite;
		//public var mcBackground:MovieClip;
		
		private var iCurrentPanel:Number = -1;
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public static const PANEL_NONE:Number = -1;
		public static const PANEL_EMBED:Number = 0;
		public static const PANEL_LINK:Number = 1;
		public static const PANEL_EMAIL:Number = 2;
		
		//private var bSuccessShow:Boolean = false;
		
		public function ShareVideoWindow() {			
			super();
		}
		
		public function showPanel($panelID:Number):void {
			if (this.alpha != 1) {
				this.alpha = 1;
			}
			
			switch ($panelID) {
				case 0 : {
					if (iCurrentPanel != $panelID) {
						iCurrentPanel = $panelID;
						this.removePanels();
						this.addEmbedPanel();
					}
					break;
				}
				
				case 1 : {
					if (iCurrentPanel != $panelID) {
						iCurrentPanel = $panelID;
						this.removePanels();
						this.addLinkPanel();
					}
					break;
				}
				
				case 2 : {
					if (iCurrentPanel != $panelID) {
						iCurrentPanel = $panelID;
						this.removePanels();
						this.addEmailPanel();
					}					
					break;
				}
				
				case -1 : {
					
					this.close();
					break;
				}
				default:
					iCurrentPanel = -1;
			}
		}
		
		private function showSucces($event:Event):void {			
			this.removePanels();
			var $embedPanel:SuccessPanel = new SuccessPanel(dataHolder.xMainXml.buttonsname.success_text.@value, dataHolder.xMainXml.buttonsname.success_btn.@value, close);
			mcPanel.addChild($embedPanel);
			this.updatePosition();
		}
		
		private function showSendSucces($event:Event):void {
			this.removePanels();
			var $embedPanel:SuccessPanel = new SuccessPanel(dataHolder.xMainXml.buttonsname.email_success_text.@value, dataHolder.xMainXml.buttonsname.success_btn.@value, close);
			mcPanel.addChild($embedPanel);
			this.updatePosition();
		}
		
		private function showIncompleteData($event:Event):void {			
			this.removePanels();
			var $embedPanel:SuccessPanel = new SuccessPanel(dataHolder.xMainXml.buttonsname.email_incomplete_text.@value, dataHolder.xMainXml.buttonsname.success_btn.@value, close);
			mcPanel.addChild($embedPanel);
			this.updatePosition();
		}

		
		private function addEmailPanel():void {
			var $emailPanel:EmailPanel = new EmailPanel();
			$emailPanel.addEventListener("close", onPanelExit);
			$emailPanel.addEventListener("incompleteData", showIncompleteData);
			$emailPanel.addEventListener("showSuccess", showSendSucces);
			mcPanel.addChild($emailPanel);
			this.updatePosition();
		}
		
		private function addEmbedPanel():void {
			var $embedPanel:EmbedPanel = new EmbedPanel();
			$embedPanel.addEventListener("close", onPanelExit);
			$embedPanel.addEventListener("showSuccess", showSucces);
			mcPanel.addChild($embedPanel);
			this.updatePosition();
		}
		
		private function addLinkPanel():void {
			var $linkPanel:LinkPanel = new LinkPanel();
			$linkPanel.addEventListener("close", onPanelExit);
			$linkPanel.addEventListener("showSuccess", showSucces);
			mcPanel.addChild($linkPanel);
			this.updatePosition();
		}
		
		private function onPanelExit($event:Event):void {			
			this.removePanels();
			this.close();
		}
		
		private function removePanels():void {
			while (mcPanel.numChildren) {
				mcPanel.getChildAt(0).removeEventListener("close", removePanels);
				mcPanel.getChildAt(0).removeEventListener("showSuccess", removePanels);
				mcPanel.getChildAt(0).removeEventListener("close", onPanelExit);
				mcPanel.getChildAt(0).removeEventListener("incompleteData", showIncompleteData);
				mcPanel.getChildAt(0).removeEventListener("showSuccess", showSendSucces);
				mcPanel.removeChildAt(0);
			}
		}
		
		public function updatePosition():void {
			this.x = Math.round((dataHolder.nStageWidth - this.width) / 2);
			this.y = Math.round((dataHolder.nStageHeight - this.height) / 2);
		}
		
		public function close():void {
			this.clearAndHide();
			//TweenLite.to(this, 0.4, {alpha:0, onComplete:clearAndHide});
		}
		
		private function clearAndHide():void {
			this.removePanels();
			iCurrentPanel = -1;
			this.dispatchEvent(new Event("close"));
		}
		
	}
	
}