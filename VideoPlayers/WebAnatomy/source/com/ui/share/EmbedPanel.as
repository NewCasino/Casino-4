package com.ui.share {
	
	import com.control.ControlsHolder;
	import com.ui.components.DialogButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	[Event("showSuccess", type = "Event")]
	[Event("close", type = "Event")]
	
	
	public class EmbedPanel extends Sprite {		
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		private var controlsHolder:ControlsHolder = ControlsHolder.getInstance();
		
		public var txtEmbedCode:TextField;
		public var txtEmbedLabel:TextField;
		
		public var btnClose:DialogButton;
		public var btnCopyCode:DialogButton;
		
		public var mcBackground:Sprite;
		
		public function EmbedPanel() {
			super();
			
			this.updateTexts();
			this.addListeners();
			
			btnClose.mode = DialogButton.CANCEL_MODE;
			btnCopyCode.mode = DialogButton.OK_MODE;
		}
		
		public function updateTexts():void {
			//var $textFormat:TextFormat = new TextFormat("Arial", null, null, true);
			txtEmbedLabel.text = dataHolder.xMainXml.buttonsname.embed_box_text.@value;
			btnClose.label = dataHolder.xMainXml.buttonsname.exit_code_btn.@value;
			btnCopyCode.label = dataHolder.xMainXml.buttonsname.copy_code_btn.@value;
			
			txtEmbedCode.text = dataHolder.xMainXml.embed;
			txtEmbedCode.setSelection(0, 10);			
		}
		
		private function closeWindow($event:MouseEvent):void {			
			this.removeListeners();
			this.dispatchEvent(new Event("close"));
		}
		
		private function copyCodeToClipboard($event:MouseEvent):void {
			System.setClipboard(txtEmbedCode.htmlText);
			this.removeListeners();
			this.dispatchEvent(new Event("showSuccess"));
		}
		
		private function addListeners():void {
			btnClose.addEventListener(MouseEvent.CLICK, closeWindow);
			btnCopyCode.addEventListener(MouseEvent.CLICK, copyCodeToClipboard);
			txtEmbedCode.addEventListener(MouseEvent.MOUSE_DOWN, setTextSelection);
		}
		
		private function removeListeners():void {
			btnClose.removeEventListener(MouseEvent.CLICK, closeWindow);
			btnCopyCode.removeEventListener(MouseEvent.CLICK, copyCodeToClipboard);
			txtEmbedCode.removeEventListener(MouseEvent.MOUSE_DOWN, setTextSelection);
		}
		
		private function setTextSelection($event:MouseEvent):void {
			txtEmbedCode.setSelection(0, txtEmbedCode.length);
		}
	}
	
}