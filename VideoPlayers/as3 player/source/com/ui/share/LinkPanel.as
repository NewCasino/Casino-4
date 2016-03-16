package com.ui.share {
	
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LinkPanel extends MovieClip {
		
		private var dataHolder:DataHolder = DataHolder.getInstance();	
		public var txtLink:TextField;
		public var mcLinkTextBackground:MovieClip;
		public var btnClose:MovieClip;
		public var btnCopyLink:MovieClip;
		public var mcEmailTab:MovieClip;
		public var mcEmbedTab:MovieClip;
		public var mcLinkTab:MovieClip;
		private var owner:ShareVideoWindow;
		
		public function LinkPanel($owner:ShareVideoWindow) {
			super();
			owner = $owner;
			this.updateTexts();			
			this.addListeners();
			mcEmailTab.buttonMode = true;
			mcEmbedTab.buttonMode = true;
			mcLinkTab.buttonMode = true;
			btnClose.buttonMode = true;
			btnCopyLink.buttonMode = true;
			btnCopyLink.txtLabel.mouseEnabled = false;
			mcEmailTab.txtLabel.mouseEnabled = false;
			mcLinkTab.txtLabel.mouseEnabled = false;
			mcEmbedTab.txtLabel.mouseEnabled = false;
			owner.updatePanelPosition();
		}
		
		public function updateTexts():void {
			var $textFormat:TextFormat = new TextFormat("Arial", null, null, true);
			
			mcEmailTab.txtLabel.setTextFormat($textFormat);
			mcEmailTab.txtLabel.text = dataHolder.xMainXml.buttonsname.email.@value;
			
			mcEmbedTab.txtLabel.setTextFormat($textFormat);
			mcEmbedTab.txtLabel.text = dataHolder.xMainXml.buttonsname.embed.@value;
			
			$textFormat.underline = true;
			mcLinkTab.txtLabel.setTextFormat($textFormat);
			mcLinkTab.txtLabel.text = dataHolder.xMainXml.buttonsname.get_link.@value;
			
			btnCopyLink.txtLabel.text = dataHolder.xMainXml.buttonsname.copy_link_btn.@value;
			txtLink.text = dataHolder.xMainXml.link.@value;
			txtLink.setSelection(0, 10);
		}
		
		private function closeWindow($event:MouseEvent):void {			
			this.removeListeners();
			owner.close();
		}
		
		private function copyLinkToClipboard($event:MouseEvent):void {
			System.setClipboard(txtLink.text);
			this.removeListeners();
			owner.close();
		}
		
		private function addListeners():void {
			btnClose.addEventListener(MouseEvent.CLICK, closeWindow);
			btnCopyLink.addEventListener(MouseEvent.CLICK, copyLinkToClipboard);
			mcEmailTab.addEventListener(MouseEvent.CLICK, clickEmailTabHandler);
			mcEmbedTab.addEventListener(MouseEvent.CLICK, clickEmbedTabHandler);
			txtLink.addEventListener(MouseEvent.MOUSE_DOWN, setTextSelection);
		}
		
		private function removeListeners():void {
			btnClose.removeEventListener(MouseEvent.CLICK, closeWindow);
			btnCopyLink.removeEventListener(MouseEvent.CLICK, copyLinkToClipboard);
			mcEmailTab.removeEventListener(MouseEvent.CLICK, clickEmailTabHandler);
			mcEmbedTab.removeEventListener(MouseEvent.CLICK, clickEmbedTabHandler);
			txtLink.removeEventListener(MouseEvent.MOUSE_DOWN, setTextSelection);
		}
		
		private function clickEmailTabHandler($event:MouseEvent):void {
			owner.showPanel(ShareVideoWindow.PANEL_EMAIL);
			this.removeListeners();
		}
		
		private function clickEmbedTabHandler($event:MouseEvent):void {
			owner.showPanel(ShareVideoWindow.PANEL_EMBED);
			this.removeListeners();
		}
		
		private function setTextSelection($event:MouseEvent):void {
			txtLink.setSelection(0, txtLink.length);
		}
	}
	
}