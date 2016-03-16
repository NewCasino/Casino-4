package com.ui.share {
	
	import com.data.DataHolder;
	import com.ui.components.DialogButton;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.events.Event;
	
	
	[Event("showSuccess", type = "Event")]
	[Event("close", type = "Event")]
	
	public class LinkPanel extends MovieClip {
		
		private var dataHolder:DataHolder = DataHolder.getInstance();	
		public var txtLink:TextField;
		public var txtHeader:TextField;
		public var mcLinkTextBackground:Sprite;
		public var btnClose:DialogButton;
		public var btnCopyLink:DialogButton;
		
		public function LinkPanel() {
			super();
			this.updateTexts();			
			this.addListeners();			
			btnClose.mode = DialogButton.CANCEL_MODE;
			btnCopyLink.mode = DialogButton.OK_MODE;
		}
		
		public function updateTexts():void {
			btnCopyLink.label = dataHolder.xMainXml.buttonsname.copy_link_btn.@value;
			btnClose.label = dataHolder.xMainXml.buttonsname.exit_link_btn.@value;
			
			txtHeader.text = dataHolder.xMainXml.buttonsname.copylink_box_text.@value;
			txtLink.text = dataHolder.xMainXml.link.@value;
			txtLink.setSelection(0, 10);
		}
		
		private function closeWindow($event:MouseEvent):void {			
			this.removeListeners();
			this.dispatchEvent(new Event("close"));
		}
		
		private function copyLinkToClipboard($event:MouseEvent):void {
			System.setClipboard(txtLink.text);
			this.removeListeners();
			this.dispatchEvent(new Event("showSuccess"));
		}
		
		private function addListeners():void {
			btnClose.addEventListener(MouseEvent.CLICK, closeWindow);
			btnCopyLink.addEventListener(MouseEvent.CLICK, copyLinkToClipboard);			
			txtLink.addEventListener(MouseEvent.MOUSE_DOWN, setTextSelection);
		}
		
		private function removeListeners():void {
			btnClose.removeEventListener(MouseEvent.CLICK, closeWindow);
			btnCopyLink.removeEventListener(MouseEvent.CLICK, copyLinkToClipboard);			
			txtLink.removeEventListener(MouseEvent.MOUSE_DOWN, setTextSelection);
		}
		
		private function setTextSelection($event:MouseEvent):void {
			txtLink.setSelection(0, txtLink.length);
		}
	}
	
}