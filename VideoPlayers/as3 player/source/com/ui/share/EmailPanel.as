package com.ui.share {
	
	import com.data.DataHolder;
	import flash.display.MovieClip;
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
	
	public class EmailPanel extends MovieClip {
		
		private var dataHolder:DataHolder = DataHolder.getInstance();	
		private var owner:ShareVideoWindow;
		
		
		public var txtMessageLabel:TextField;
		public var txtFriendsEmailLabel:TextField;
		public var txtEmailLabel:TextField;
		public var txtNameLabel:TextField;
		
		public var txtMessageInput:TextField;
		public var txtToEmailInput:TextField;
		public var txtFromEmailInput:TextField;
		public var txtNameInput:TextField;
		
		public var btnSendMessage:MovieClip;
		public var btnClose:MovieClip;
		public var mcEmailTab:MovieClip;
		public var mcEmbedTab:MovieClip;
		public var mcLinkTab:MovieClip;
		
		private var loader:URLLoader = new URLLoader();
		
		public function EmailPanel($owner:ShareVideoWindow) {
			super();
			owner = $owner;
			this.updateTexts();
			this.addListeners();
			mcEmailTab.buttonMode = true;
			mcEmbedTab.buttonMode = true;
			mcLinkTab.buttonMode = true;
			btnClose.buttonMode = true;
			btnSendMessage.buttonMode = true;
			btnSendMessage.label.mouseEnabled = false;
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
			
			btnSendMessage.label.text = dataHolder.xMainXml.buttonsname.send_message_btn.@value;
			txtMessageLabel.text = dataHolder.xMainXml.buttonsname.message.@value;
			txtFriendsEmailLabel.text = dataHolder.xMainXml.buttonsname.friends_email_adresses.@value;
			txtEmailLabel.text = dataHolder.xMainXml.buttonsname.your_email.@value;
			txtNameLabel.text = dataHolder.xMainXml.buttonsname.your_name.@value;
		}
		
		private function addListeners():void {
			btnClose.addEventListener(MouseEvent.CLICK, closeWindow);			
			mcEmbedTab.addEventListener(MouseEvent.CLICK, clickEmbedTabHandler);
			mcLinkTab.addEventListener(MouseEvent.CLICK, clickLinkTabHandler);
			btnSendMessage.addEventListener(MouseEvent.CLICK, mailMessage);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, loaderHttpStatusHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}
		
		private function removeListeners():void {
			btnClose.removeEventListener(MouseEvent.CLICK, closeWindow);			
			mcEmbedTab.removeEventListener(MouseEvent.CLICK, clickEmbedTabHandler);
			mcLinkTab.removeEventListener(MouseEvent.CLICK, clickLinkTabHandler);
			btnSendMessage.removeEventListener(MouseEvent.CLICK, mailMessage);
			loader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, loaderHttpStatusHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}
		
		private function loaderCompleteHandler($event:Event):void {
			trace($event.target.data);
		}
		
		private function loaderHttpStatusHandler($event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + $event);
        }
		
		private function loaderIOErrorHandler($event:IOErrorEvent):void {
            trace("ioErrorHandler: " + $event);
        }
		
		private function mailMessage($event:MouseEvent):void {			
			var $url:String = dataHolder.xMainXml.php_path.@value;
			
			/*if ($url.lastIndexOf("?") != -1) {
				$url += "&";
			} else {
				$url += "?";
			}
			$url += "name=" + txtNameInput.text + "&your_email=" + txtFromEmailInput.text + "&to_email=" + txtToEmailInput.text + "&message=" + txtMessageInput.text;*/
			
			var $request:URLRequest = new URLRequest($url);
			var $vars:URLVariables = new URLVariables();
			$request.method = URLRequestMethod.POST;
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			
			$vars.name = txtNameInput.text;
			$vars.your_email = txtFromEmailInput.text;
			$vars.to_email = txtToEmailInput.text;
			$vars.message = txtMessageInput.text;
			$request.data = $vars;
			loader.load($request);
			this.removeListeners();
			owner.close();
		}
		
		private function closeWindow($event:MouseEvent):void {			
			this.removeListeners();
			owner.close();
		}
		
		private function clickEmbedTabHandler($event:MouseEvent):void {
			owner.showPanel(ShareVideoWindow.PANEL_EMBED);
			this.removeListeners();
		}
		
		private function clickLinkTabHandler($event:MouseEvent):void {
			owner.showPanel(ShareVideoWindow.PANEL_LINK);
			this.removeListeners();
		}
	}
	
}