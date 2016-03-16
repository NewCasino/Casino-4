package com.ui.share {
	
	import com.ui.components.DialogButton;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;	
	
	public class SuccessPanel extends Sprite {
		
		public var txtMessage:TextField;		
		public var btnOk:DialogButton;		
		public var mcBackground:Sprite;
		
		private var _fCallBack:Function;
		
		public function SuccessPanel($message:String, $buttonName:String, $callBackFunction) {
			super();
			_fCallBack = $callBackFunction;
			txtMessage.text = $message;
			btnOk.txtLabel.text = $buttonName;
			
			this.addListeners();
			
			btnOk.mode = DialogButton.OK_MODE;
		}
		
		private function closeWindow($event:MouseEvent):void {			
			this.removeListeners();
			this._fCallBack();
		}
		
		private function addListeners():void {
			btnOk.addEventListener(MouseEvent.CLICK, closeWindow);
		}
		
		private function removeListeners():void {
			btnOk.removeEventListener(MouseEvent.CLICK, closeWindow);
		}
		
	}
	
}