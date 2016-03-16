package com.ui.share {
	
	import flash.system.System;
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class EmbedPanel extends MovieClip {		
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		public var txtEmbedCode:TextField;
		public var txtEmbedLabel:TextField;
		public var btnClose:MovieClip;
		public var btnCopyCode:MovieClip;
		public var mcEmailTab:MovieClip;
		public var mcEmbedTab:MovieClip;
		public var mcLinkTab:MovieClip;
		public var mcUseCodeLabel:MovieClip;
		private var owner:ShareVideoWindow;
		
		
		public function EmbedPanel($owner:ShareVideoWindow) {
			super();
			owner = $owner;
			this.updateTexts();
			this.addListeners();
			mcEmailTab.buttonMode = true;
			mcEmbedTab.buttonMode = true;
			mcLinkTab.buttonMode = true;
			btnClose.buttonMode = true;
			btnCopyCode.buttonMode = true;
			btnCopyCode.txtLabel.mouseEnabled = false;
			mcEmailTab.txtLabel.mouseEnabled = false;
			mcLinkTab.txtLabel.mouseEnabled = false;
			mcEmbedTab.txtLabel.mouseEnabled = false;
			owner.updatePanelPosition();
		}
		
		public function updateTexts():void {
			var $textFormat:TextFormat = new TextFormat("Arial", null, null, true);
			
			mcEmailTab.txtLabel.setTextFormat($textFormat);
			mcEmailTab.txtLabel.text = dataHolder.xMainXml.buttonsname.email.@value;
			
			mcLinkTab.txtLabel.setTextFormat($textFormat);
			mcLinkTab.txtLabel.text = dataHolder.xMainXml.buttonsname.get_link.@value;
			
			$textFormat.underline = true;
			mcEmbedTab.txtLabel.setTextFormat($textFormat);
			mcEmbedTab.txtLabel.text = dataHolder.xMainXml.buttonsname.embed.@value;
			
			mcUseCodeLabel.txtEmbedLabel.text = dataHolder.xMainXml.buttonsname.embed_box_text.@value;
			
			btnCopyCode.txtLabel.text = dataHolder.xMainXml.buttonsname.copy_code_btn.@value;
			txtEmbedCode.text = dataHolder.xMainXml.embed;
			txtEmbedCode.setSelection(0, 10);			
		}
		
		private function closeWindow($event:MouseEvent):void {			
			this.removeListeners();
			owner.close();
		}
		
		private function copyCodeToClipboard($event:MouseEvent):void {
			System.setClipboard(txtEmbedCode.htmlText);
			this.removeListeners();
			owner.close();
		}
		
		private function addListeners():void {
			btnClose.addEventListener(MouseEvent.CLICK, closeWindow);
			btnCopyCode.addEventListener(MouseEvent.CLICK, copyCodeToClipboard);
			txtEmbedCode.addEventListener(MouseEvent.MOUSE_DOWN, setTextSelection);
			mcEmailTab.addEventListener(MouseEvent.CLICK, clickEmailTabHandler);
			mcLinkTab.addEventListener(MouseEvent.CLICK, clickLinkTabHandler);
		}
		
		private function removeListeners():void {
			btnClose.removeEventListener(MouseEvent.CLICK, closeWindow);
			btnCopyCode.removeEventListener(MouseEvent.CLICK, copyCodeToClipboard);
			txtEmbedCode.removeEventListener(MouseEvent.MOUSE_DOWN, setTextSelection);
			mcEmailTab.removeEventListener(MouseEvent.CLICK, clickEmailTabHandler);
			mcLinkTab.removeEventListener(MouseEvent.CLICK, clickLinkTabHandler);
		}
		
		private function clickEmailTabHandler($event:MouseEvent):void {
			owner.showPanel(ShareVideoWindow.PANEL_EMAIL);
			this.removeListeners();
		}
		
		private function clickLinkTabHandler($event:MouseEvent):void {
			owner.showPanel(ShareVideoWindow.PANEL_LINK);
			this.removeListeners();
		}
		
		private function setTextSelection($event:MouseEvent):void {
			txtEmbedCode.setSelection(0, txtEmbedCode.length);
		}
	}
	
}