package com.ui.share {
	
	import com.data.DataHolder;
	import com.ui.components.DialogButton;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[Event("showSuccess", type = "Event")]
	[Event("incompleteData", type = "Event")]
	[Event("close", type = "Event")]
	
	public class EmailPanel extends Sprite {
		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		
		public var txtYourEmailLabel:TextField;
		public var txtFriendEmailLabel:TextField;		
		public var txtYourLogin:TextField;
		public var txtYourDomain:TextField;
		public var txtFriendLogin:TextField;
		public var txtFriendDomain:TextField;
		
		public var btnSendMessage:DialogButton;
		public var btnClose:DialogButton;		
		
		public var mcBackground:Sprite;
		
		private var loader:URLLoader = new URLLoader();
		
		public function EmailPanel() {
			super();
			
			this.updateTexts();
			this.addListeners();
			
			btnClose.mode = DialogButton.CANCEL_MODE;
			btnSendMessage.mode = DialogButton.OK_MODE;
			
		}
		
		public function updateTexts():void {
			btnClose.label = dataHolder.xMainXml.buttonsname.exit_sendmes_btn.@value;
			btnSendMessage.label = dataHolder.xMainXml.buttonsname.send_message_btn.@value;
			
			txtYourEmailLabel.text = dataHolder.xMainXml.buttonsname.your_email_adress.@value;
			txtFriendEmailLabel.text = dataHolder.xMainXml.buttonsname.friends_email_adress.@value;
		}
		
		private function addListeners():void {
			btnClose.addEventListener(MouseEvent.CLICK, closeWindow);			
			btnSendMessage.addEventListener(MouseEvent.CLICK, mailMessage);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, loaderHttpStatusHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}
		
		private function removeListeners():void {
			btnClose.removeEventListener(MouseEvent.CLICK, closeWindow);
			btnSendMessage.removeEventListener(MouseEvent.CLICK, mailMessage);
			loader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, loaderHttpStatusHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}
		
		private function loaderCompleteHandler($event:Event):void {			
			
		}
		
		private function loaderHttpStatusHandler($event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + $event);
        }
		
		private function loaderIOErrorHandler($event:IOErrorEvent):void {
            trace("ioErrorHandler: " + $event);
        }
		
		private function mailMessage($event:MouseEvent):void {
			if (!checkFields()) {
				this.dispatchEvent(new Event("incompleteData"));
				return;
			}
			var $url:String = dataHolder.xMainXml.php_path.@value;
			
			var $request:URLRequest = new URLRequest($url);			
			var $vars:URLVariables = new URLVariables();
			
			$request.method = URLRequestMethod.POST;
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			$vars.name = txtYourLogin.text;
			$vars.your_email = txtYourLogin.text + "@" + txtYourDomain.text;
			$vars.to_email = txtFriendLogin.text + "@" + txtFriendDomain.text;			
			$request.data = $vars;
			
			loader.load($request);
			this.dispatchEvent(new Event("showSuccess"));
		}
		
		private function checkFields():Boolean {
			if (txtYourLogin.text.length < 1 || txtYourDomain.text.length < 1 || txtFriendLogin.text.length < 1 || txtFriendDomain.text.length < 1) {
				return false;
			} else {
				return true;
			}
			
		}
		
		private function closeWindow($event:MouseEvent):void {			
			this.removeListeners();
			this.dispatchEvent(new Event("close"));			
		}		
	}
	
}