package {
	import vo.ColorVO;
	import vo.PaletteItemVO;
	import com.shurba.utils.ApplyStandartOptions;
	import fl.controls.UIScrollBar;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.net.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[SWF(width="465", height="285", frameRate="31", backgroundColor="#FFFFFF")]
	
	public class Main extends Sprite {		
		
		public var REFRESH_TIME:int = 3000;
		public var AD_TIME:int = 15000;
		public var AD_NUM:int = 4;
		public const XML_PATH:String = "http://leghe.fantagazzetta.com/Receiver.ashx";
		public const AD_PATH:String = "http://leghe.fantagazzetta.com/adchat.xml";
		public var COLORS_PATH:String = "colors.xml";
		public const NOT_LOGGED_TEXT:String = "Esegui il log-in per utilizzare la chat della tua lega";
		
		public var messageList:TextField;
		public var messageBox:TextField;		
		public var btnSend:BtnSend;
		public var btnBold:BtnBold;
		public var btnItalic:BtnItalic;
		public var textToSend:String = "";
		
		public var xmlLoader:URLLoader;
		
		public var filePath:String = "/videos/ironman2/";
		public var nick:String = "";
		
		public var getDataTimer:Timer;
		
		public var background:Sprite;
		public var scrollBar:UIScrollBar = new UIScrollBar();
		public var colorPalette:ColorPalette;
		public var lastXMLText:Object;
		public var adXML:XML;
		public var colorsXML:XML;
		private var onPosting:Boolean = false;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			new ApplyStandartOptions(this);
			this.readFlashVars();
			getDataTimer = new Timer(REFRESH_TIME);
			this.updateAD();
			this.drawInterface();			
			this.addListeners();
			
			getDataTimer.start();
		}
		
		private function readFlashVars():void {
			var oParams:Object = LoaderInfo(root.loaderInfo).parameters;
			var sendUrl:String;
			if (oParams.nickname != undefined && oParams.nickname != '') {				
				nick = oParams.nickname;
			}
			if (oParams.relativepath != undefined && oParams.relativepath != '') {
				filePath = oParams.relativepath;
			}
			if (oParams.refreshtime != undefined && oParams.refreshtime != '') {				
				REFRESH_TIME = oParams.refreshtime;
			}	
			if (oParams.admessagenum != undefined && oParams.admessagenum != '') {				
				AD_NUM = oParams.admessagenum;
			}	
			if (oParams.colorspath != undefined && oParams.colorspath != '') {				
				COLORS_PATH = oParams.colorspath;
			}	
		}
		
		private function addListeners():void {
			getDataTimer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
			btnBold.addEventListener(MouseEvent.CLICK, setBoldHandler, false, 0, true);
			btnItalic.addEventListener(MouseEvent.CLICK, setItalicHandler, false, 0, true);
		}
		
		private function setItalicHandler(e:MouseEvent):void {
			if (messageBox.selectionBeginIndex == messageBox.selectionEndIndex) {
				return;
			}
			var tf:TextFormat = messageBox.getTextFormat(messageBox.selectionBeginIndex, messageBox.selectionEndIndex);
			tf.italic = btnItalic.toggle;
			messageBox.setTextFormat(tf, messageBox.selectionBeginIndex, messageBox.selectionEndIndex);			
		}
		
		private function setBoldHandler(e:MouseEvent):void {
			if (messageBox.selectionBeginIndex == messageBox.selectionEndIndex) {
				return;
			}
			var tf:TextFormat = messageBox.getTextFormat(messageBox.selectionBeginIndex, messageBox.selectionEndIndex);
			tf.bold = btnBold.toggle;			
			messageBox.setTextFormat(tf, messageBox.selectionBeginIndex, messageBox.selectionEndIndex);
		}
		
		private function onEnterHandler(e:KeyboardEvent):void {		
			if (e.keyCode == Keyboard.ENTER) {
				textToSend = messageBox.htmlText;
				messageBox.text = "";
				btnBold.toggle = false;
				btnItalic.toggle = false;
				this.updateChatTalks();
			}
		}
		
		private function sendBtnClickHandler(e:MouseEvent):void {
			textToSend = messageBox.htmlText;
			messageBox.text = "";
			btnBold.toggle = false;
			btnItalic.toggle = false;
			this.updateChatTalks();
		}
		
		private function timerHandler(e:TimerEvent):void {
			this.updateChatTalks();
		}
		
		private function removeListeners():void {
			
		}		
		
		private function drawInterface():void {
			background = new Sprite();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(stage.stageWidth, stage.stageHeight, (Math.PI/180)*90, 0, 00);			
			background.graphics.beginGradientFill(GradientType.LINEAR, [0xf4f4f4, 0xe1e1e1], [1, 1], [0x00, 0xFF], matrix, SpreadMethod.PAD);        
			background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			/*background.graphics.lineStyle(1, 0xa1a1a1);
			background.graphics.moveTo(5, 236);
			background.graphics.lineTo(365, 236);
			background.graphics.moveTo(5, 206);
			background.graphics.lineTo(365, 206);*/
			addChild(background);
		
			messageList = new TextField();
			this.addChild(messageList);			
			messageList.width = 465;
			messageList.height = 200;
			messageList.condenseWhite = true;
			messageList.multiline = true;
			messageList.wordWrap = true;
			
			var tf:TextFormat = new TextFormat();			
			messageList.embedFonts = false;
			tf.font = "Verdana";
			tf.size = 12;
			messageList.defaultTextFormat = tf;
			tf.font = "Arial";
			messageBox = new TextField();
			this.addChild(messageBox);
			messageBox.x = 5;
			messageBox.y = 240;
			messageBox.width = 360;
			messageBox.height = 40;
			//messageBox.multiline = true;
			//messageBox.wordWrap = true;
			messageBox.defaultTextFormat = tf;
			messageBox.embedFonts = false;
			
			if (nick != "") {				
				messageBox.type = TextFieldType.INPUT;
				messageBox.background = true;
				messageBox.backgroundColor = 0xffffff;
				messageBox.border = true;
				messageBox.borderColor = 0xaaaaaa;
				messageBox.addEventListener(KeyboardEvent.KEY_DOWN, onEnterHandler, false, 0, true);
				messageBox.addEventListener(MouseEvent.MOUSE_UP, checkSelectedText, false, 0, true);
				
				btnSend = new BtnSend();
				this.addChild(btnSend);
				btnSend.x = 380;
				btnSend.y = 245;
				btnSend.addEventListener(MouseEvent.CLICK, sendBtnClickHandler, false, 0, true);
			} else {
				messageBox.type = TextFieldType.DYNAMIC;
				messageBox.selectable = false;
				messageBox.text = NOT_LOGGED_TEXT;
			}
			
			
			scrollBar.scrollTarget = messageList;
			scrollBar.height = messageList.height;			
			scrollBar.move(messageList.x + messageList.width - 20, messageList.y);			
			this.addChild(scrollBar);
			
			btnBold = new BtnBold();
			this.addChild(btnBold);
			btnBold.x = 310;
			btnBold.y = 210;
			
			btnItalic = new BtnItalic();
			this.addChild(btnItalic);
			btnItalic.x = 280;
			btnItalic.y = 210;
		}
		
		private function checkSelectedText(e:MouseEvent):void {			
			if (messageBox.selectionBeginIndex == messageBox.selectionEndIndex) {
				btnBold.toggle = false;
				btnItalic.toggle = false;
			} else {
				var tf:TextFormat = messageBox.getTextFormat(messageBox.selectionBeginIndex, messageBox.selectionEndIndex);
				btnBold.toggle = tf.bold;
				btnItalic.toggle = tf.italic;
				colorPalette.openButton.color = tf.color as uint;
			}
			
		}
		
		public function updateScrollBar():void{
			scrollBar.update();
			if (scrollBar.enabled == false) {
				scrollBar.alpha = 0; 
			} else { 
				scrollBar.alpha = 100; 
			}
		}
		
		public function updateAD():void {
			var request:URLRequest = new URLRequest(AD_PATH);
			xmlLoader = new URLLoader();			
			xmlLoader.addEventListener(Event.COMPLETE, adXMLLoadedHandler, false, 0, true);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, adLoadErrorHandler, false, 0, true);
			xmlLoader.load(request);
		}
		
		private function adLoadErrorHandler(e:IOErrorEvent):void {	
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, adLoadErrorHandler);
			xmlLoader.removeEventListener(Event.COMPLETE, adXMLLoadedHandler);
		}
		
		private function adXMLLoadedHandler(e:Event):void {
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, adLoadErrorHandler);
			xmlLoader.removeEventListener(Event.COMPLETE, adXMLLoadedHandler);
			adXML = new XML(e.currentTarget.data);
			this.loadColors();
		}
		
		private function loadColors():void {
			var request:URLRequest = new URLRequest(COLORS_PATH);
			xmlLoader = new URLLoader();			
			xmlLoader.addEventListener(Event.COMPLETE, colorsLoadedHandler, false, 0, true);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, colorsNotLoadedHandler, false, 0, true);
			xmlLoader.load(request);
		}
		
		private function colorsLoadedHandler(e:Event):void {			
			xmlLoader.removeEventListener(Event.COMPLETE, colorsLoadedHandler);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, colorsNotLoadedHandler);
			
			colorsXML = new XML(e.currentTarget.data)
			var xList:XMLList = colorsXML.children();			
			var palletesData:Array = [];
			for (var i:int = 0; i < xList.length(); i++) {
				var tmpPalette:PaletteItemVO = new PaletteItemVO();
				tmpPalette.colors = [];
				tmpPalette.name = xList[i].@title;
				var colorsList:XMLList = xList[i].children();
				for (var j:int = 0; j < colorsList.length(); j++) {
					var tmpColor:ColorVO = new ColorVO();
					tmpColor.hexColor = colorsList[j].@hexValue;
					tmpColor.name = colorsList[j].@title;					
					tmpPalette.colors.push(tmpColor);
				}
				
				palletesData.push(tmpPalette);				
			}
			
			colorPalette = new ColorPalette();
			
			colorPalette.dataProvider = palletesData;
			this.addChild(colorPalette);
			colorPalette.x = 340;
			colorPalette.y = 210;
			colorPalette.width = 200;
			
			//colorPalette.addEventListener(ColorPaletteEvent.PREVIEW_COLOR, previewColorHandler, false, 0, true);
			colorPalette.addEventListener(ColorPaletteEvent.SELECT_COLOR, selectColorHandler, false, 0, true);
			this.updateChatTalks();
		}
		
		private function selectColorHandler(e:ColorPaletteEvent):void {
			if (messageBox.selectionBeginIndex == messageBox.selectionEndIndex) {
				return;
			}
			var tf:TextFormat = messageBox.getTextFormat(messageBox.selectionBeginIndex, messageBox.selectionEndIndex);
			tf.color = colorPalette.selectedColor.hexColor;			
			messageBox.setTextFormat(tf, messageBox.selectionBeginIndex, messageBox.selectionEndIndex);	
		}
		
		private function colorsNotLoadedHandler(e:IOErrorEvent):void {
			xmlLoader.removeEventListener(Event.COMPLETE, colorsLoadedHandler);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, colorsNotLoadedHandler);
		}
		
		private function updateChatTalks():void {
			var request:URLRequest = new URLRequest(XML_PATH);
			request.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables();
			variables.path = filePath;
			if (textToSend != "") {
				variables.message = textToSend;
				textToSend = "";
			}			
			variables.nickname = nick;
			request.data = variables;
			xmlLoader = new URLLoader();			
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoadedHandler);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadErrorHandler);
			xmlLoader.load(request);
		}
		
		private function xmlLoadErrorHandler(e:IOErrorEvent):void {
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlLoadErrorHandler);
			xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadedHandler);
		}
		
		private function xmlLoadedHandler(e:Event):void {
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlLoadErrorHandler);
			xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadedHandler);
			if (lastXMLText != e.currentTarget.data) {
				lastXMLText = e.currentTarget.data;
				this.parseAndShowData(new XMLList(e.currentTarget.data));
			}
		}
		
		public function parseAndShowData(xList:XMLList):void {			
			messageList.text = "";
			for (var i:int = 0; i < xList.length(); i++) {							
				messageList.appendText(xList[i].date + " : " + xList[i].nickname + " : " + xList[i].msg);
				//advertise function will be on the server
				/*if (AD_NUM == i) {
					messageList.appendText(adXML.date + " : "+ adXML.nick+" : "+adXML.msg+"<br/>");
				}*/
			}
			messageList.htmlText = messageList.text;
			messageList.scrollV = messageList.maxScrollV;
			this.updateScrollBar();
		}
	}	
}