package com.ui.share {
	
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import gs.TweenLite;
	
	public class ShareVideoWindow extends MovieClip {
		
		public var mcPanel:MovieClip;
		public var mcBackground:MovieClip;
		
		private var iCurrentPanel:Number = -1;
		
		public var paddingTop:Number = 15;
		public var paddingBottom:Number = 15;
		public var paddingRight:Number = 20;
		public var paddingLeft:Number = 20;
		private var aHeights:Array = new Array(63, 50, 163);
		
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public static const PANEL_NONE:Number = -1;
		public static const PANEL_EMBED:Number = 0;
		public static const PANEL_LINK:Number = 1;
		public static const PANEL_EMAIL:Number = 2;
		
		
		public function ShareVideoWindow($panelID:Number = NaN) {			
			super();
			mcBackground.x = 0;
			mcBackground.y = 0;
			/*
			if (!isNaN($panelID)) {
				this.showPanel($panelID);				
			}
			*/
		}
		
		public function showPanel($panelID:Number):void {
			if (this.alpha != 1) {
				this.alpha = 1;
			}
			
			switch ($panelID) {
				case 0 : {
					if (iCurrentPanel != $panelID) {
						iCurrentPanel = $panelID;						
						while( mcPanel.numChildren) {
						   mcPanel.removeChildAt(0)
						}
						updateBackgroundSize($panelID, addEmbedPanel);
					}
					break;
				}
				
				case 1 : {
					if (iCurrentPanel != $panelID) {
						iCurrentPanel = $panelID;
						while( mcPanel.numChildren) {
						   mcPanel.removeChildAt(0)
						}
						updateBackgroundSize($panelID, addLinkPanel);
					}					
					break;
				}
				
				case 2 : {
					if (iCurrentPanel != $panelID) {
						iCurrentPanel = $panelID;
						while( mcPanel.numChildren) {
						   mcPanel.removeChildAt(0)
						}
						updateBackgroundSize($panelID, addEmailPanel);
					}					
					break;
				}
				
				case -1 : {
					while (mcPanel.numChildren) {
						//mcPanel.getChildAt(0).removeListeners();
						mcPanel.removeChildAt(0);						
					}
					this.close();
					break;
				}
				default:
					iCurrentPanel = -1;
			}
		}
		
		private function addEmailPanel():void {
			var $emailPanel:EmailPanel = new EmailPanel(this);
			mcPanel.addChild($emailPanel);
			updatePanelPosition();
		}
		
		private function addEmbedPanel():void {
			var $embedPanel:EmbedPanel = new EmbedPanel(this);
			mcPanel.addChild($embedPanel);
			updatePanelPosition();
		}
		
		private function addLinkPanel():void {
			var $linkPanel:LinkPanel = new LinkPanel(this);
			mcPanel.addChild($linkPanel);
			updatePanelPosition();
		}
		
		private function updateBackgroundSize($panelID:Number, $fCallBack:Function):void {
			
			var $nNewYPos:Number = (dataHolder.nStageHeight - (aHeights[$panelID] + 30)) / 2;
			var $nNewHeight:Number = aHeights[$panelID] + 30;
			
			TweenLite.to(mcBackground, 0.5, {height:$nNewHeight, onComplete:$fCallBack} );
			TweenLite.to(this, 0.5, { y:$nNewYPos } );
			
			
			//mcBackground.height = paddingTop + mcPanel.height + paddingBottom;
			//mcBackground.width = paddingLeft + mcPanel.width + paddingRight;
			
		}
		
		public function updatePanelPosition():void {
			mcPanel.y = paddingTop;
			mcPanel.x = paddingLeft;
			//trace("update position");
		}
		
		public function close():void {
			TweenLite.to(this, 0.4, {alpha:0, onComplete:clearAndHide});
		}
		
		private function clearAndHide():void {
			while( mcPanel.numChildren) {
			   mcPanel.removeChildAt(0)
			}
			iCurrentPanel = -1;
			dataHolder._stage.hideShareWindow();
		}
		
	}
	
}