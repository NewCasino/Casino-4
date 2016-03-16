package com.shurba.stickermaker {
	import com.shurba.stickermaker.StickerHolderEvent;	
	import com.shurba.stickermaker.vo.ColorVO;
	import com.shurba.stickermaker.vo.FontVO;
	import com.shurba.stickermaker.vo.PaletteItemVO;
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.xml.XMLLoader;
	import fl.controls.CheckBox;
	import fl.controls.ColorPicker;
	import fl.controls.List;
	import fl.controls.NumericStepper;
	import fl.controls.RadioButton;
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.controls.TileList;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import fl.events.ColorPickerEvent;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import com.shurba.stickermaker.ListIconField
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	public class DocumentClass extends Sprite {
		
		private const FONTS_XML_PATH:String = "fonts.xml";
		private const COLORSS_XML_PATH:String = "colors.xml";
		private const FONT_CLASS_NAME:String = "PoliceTexte";
		private const DEFAULT_SEND_URL:String = "http://www.google.com";
		
		public var colorPalette:ColorPalette;
		public var stickerHolder:StickerHolder;
		public var fontList:TileList;
		
		private var xmlLoader:XMLLoader;
		private var fontLoader:Loader = new Loader();
		public var textField:TextField
		public var stickerWidth:TextField;
		public var stickerHeight:TextField;
		public var typedText:TextField;
		public var priceText:TextField;
		private var FontClass:Class;
		
		//public var rbFontBody:RadioButton;
		//public var rbStrict:RadioButton;
		
		public var chbMirrorText:CheckBox;
		public var chbPaintedText:CheckBox;
		
		public var quantity:NumericStepper;
		
		public var send:SimpleButton;
		
		public function DocumentClass() {
			super();
			
			if (stage)
				this.init();
			else 
				this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			new ApplyStandartOptions(this);
			
			stickerHolder.textColor = 0x000000;
			
			//stickerWidth.borderColor = 0xaaaaaa;
			stickerHeight.borderColor = 0xaaaaaa;
			typedText.borderColor = 0xaaaaaa;
			
            fontList.iconField = "iconSource";			
			fontList.addEventListener(Event.CHANGE, listItemChangeHandler, false, 0, true);			
			
			
			fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fontFileLoaded, false, 0, true);
			fontLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fontFileLoadError, false, 0, true);
			
			this.loadFontsXML();
			this.addListeners();
			
			typedText.text = "Input your text here";
			stickerHolder.currentText = typedText.text;
		}
		
		private function addListeners():void {
			//stickerWidth.addEventListener(Event.CHANGE, stickerSizeChangeHandler, false, 0, true);
			stickerHeight.addEventListener(Event.CHANGE, stickerSizeChangeHandler, false, 0, true);
			stickerHolder.addEventListener(StickerHolderEvent.SIZE_CHANGED, stickerChangeHandler, false, 0, true);
			chbMirrorText.addEventListener(Event.CHANGE, mirrorCheckBoxChangeHandler, false, 0, true);
			chbPaintedText.addEventListener(Event.CHANGE, paintedCheckBoxChangeHandler, false, 0, true);
			typedText.addEventListener(Event.CHANGE, typedTextChangeHandler, false, 0, true);
			typedText.addEventListener(MouseEvent.CLICK, focusHandler, false, 0, true);
			
			send.addEventListener(MouseEvent.CLICK, orderSticker, false, 0, true);
			
			//rbFontBody.addEventListener(MouseEvent.CLICK, radioButtonClickHandler, false, 0, true);
			//rbStrict.addEventListener(MouseEvent.CLICK, radioButtonClickHandler, false, 0, true);
			
			quantity.addEventListener(Event.CHANGE, quantityChangeHandler, false, 0, true);
		}
		
		private function orderSticker(e:MouseEvent):void {
			var oParams:Object = LoaderInfo(root.loaderInfo).parameters;
			var sendUrl:String
			if (oParams.http_base_url != undefined && oParams.http_base_url!='') {
				sendUrl = oParams.http_base_url;
			} else {
				sendUrl = DEFAULT_SEND_URL;
			}
			
			var request:URLRequest = new URLRequest(sendUrl);
			var vars:URLVariables = new URLVariables();
			
			vars.text = typedText.text;
			vars.fontname = stickerHolder.stickerText.getTextFormat().font;			
			vars.width = stickerWidth.text;
			vars.height = stickerHeight.text;
			vars.color = colorPalette.selectedColor.hexColor;
			vars.colorName = colorPalette.selectedColor.name;
			vars.quantity = quantity.value;
			vars.mirror = chbMirrorText.selected;
			vars.paintedText = chbPaintedText.selected;
			
			request.method = URLRequestMethod.POST;
			request.data = vars;
			
			navigateToURL(request);
		}
		
		private function focusHandler(e:Event):void {
			typedText.setSelection(0, typedText.text.length);
			typedText.removeEventListener(MouseEvent.CLICK, focusHandler);
		}
		
		private function quantityChangeHandler(e:Event):void {
			this.updatePrice();
		}
		
		private function typedTextChangeHandler(e:Event):void {
			stickerHolder.currentText = typedText.text;
			this.updatePrice();
		}
		
		private function radioButtonClickHandler(e:MouseEvent):void {
			//stickerHolder.strictSize = rbStrict.selected;
		}
		
		private function paintedCheckBoxChangeHandler(e:Event):void {
			stickerHolder.transparentText = (e.currentTarget as CheckBox).selected;
		}
		
		private function mirrorCheckBoxChangeHandler(e:Event):void {			
			stickerHolder.mirrorText = (e.currentTarget as CheckBox).selected;
		}
		
		private function stickerChangeHandler(e:StickerHolderEvent):void {
			this.stickerSizeChangeHandler(null);
		}
		
		private function stickerSizeChangeHandler(e:Event = null):void {
			var textHeight:Number;
			var textWidth:Number;
			
			if (!e) {
				textHeight = Number(stickerHeight.text);
				textWidth = stickerHolder.textWidth / (stickerHolder.textHeight / textHeight);
				stickerWidth.text = this.roundToIndex(textWidth, 1).toString();
				this.updatePrice();
				return;
			}
			
			switch (e.currentTarget) {
				case (stickerWidth) : {
					textWidth = Number(stickerWidth.text);
					textHeight = stickerHolder.textHeight / (stickerHolder.textWidth / textWidth);
					stickerHeight.text = this.roundToIndex(textHeight, 1).toString();					
					break;
				}
				
				case (stickerHeight) : {
					textHeight = Number(stickerHeight.text);
					textWidth = stickerHolder.textWidth / (stickerHolder.textHeight / textHeight);
					stickerWidth.text = this.roundToIndex(textWidth, 1).toString();					
					break;
				}
			}
			
			this.updatePrice();
		}
		
		private function updatePrice():void {
			var w:Number = Number(stickerWidth.text);
			var h:Number = Number(stickerHeight.text);
			var nPrice:Number = this.roundToIndex((w * h * 0.01) * quantity.value, 2);
			var sPrice:String = String(nPrice);
			sPrice = String(nPrice) + "  €";
			priceText.text = sPrice;
		}
		
		private function roundToIndex(number:Number, index:Number):Number {
			var power:Number = Math.pow(10, index);
			number = number * power;
			number = Math.round(number);
			return number / power;
		}
		
		private function fontFileLoadError(e:IOErrorEvent):void {
			
		}
		
		private function fontFileLoaded(e:Event):void {
			FontClass = e.currentTarget.applicationDomain.getDefinition(FONT_CLASS_NAME)  as  Class;			
			stickerHolder.setFontHolderClass(FontClass);
			this.stickerSizeChangeHandler(null);
		}
		
		private function listItemChangeHandler(e:Event):void {			
			var request:URLRequest = new URLRequest((e.currentTarget as TileList).selectedItem.resource);
			fontLoader.load(request);
		}
		
		private function initComponetns():void {
			
		}
		
		private function loadFontsXML():void {
			xmlLoader = new XMLLoader(FONTS_XML_PATH, parseFontsXML);
		}
		
		private function parseFontsXML($xml:XML):void {
			
			var xList:XMLList = $xml.children();
			var fontsVoArray:Array = [];
			for (var i:int = 0; i < xList.length(); i++) {
				var tmpFontObject:FontVO = new FontVO();
				tmpFontObject.name = xList[i].@name;
				tmpFontObject.resource = xList[i].@resource;
				tmpFontObject.source = xList[i].@image;
				fontsVoArray.push(tmpFontObject);
			}
			
			var dp:DataProvider = new DataProvider(fontsVoArray);			
			fontList.direction = ScrollBarDirection.VERTICAL;
			fontList.dataProvider = dp;
			fontList.sortItemsOn("name");
			fontList.columnWidth = 93;
			fontList.rowHeight = 80;
			fontList.columnCount = 1;
			fontList.rowCount = 0;
			
			fontList.horizontalScrollPolicy = ScrollPolicy.OFF;
			fontList.verticalScrollPolicy = ScrollPolicy.ON;
			
			fontList.selectedIndex = 1;
			
			var request:URLRequest = new URLRequest(fontList.selectedItem.resource);
			fontLoader.load(request);
			
			this.loadColorsXML();
		}		
		
		private function loadColorsXML():void {
			xmlLoader = new XMLLoader(COLORSS_XML_PATH, parseColorsXML);
		}
		
		private function parseColorsXML($xml:XML):void {
			var xList:XMLList = $xml.children();			
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
			colorPalette.x = 715;
			colorPalette.y = 40;
			colorPalette.width = 200;
			
			colorPalette.addEventListener(ColorPaletteEvent.PREVIEW_COLOR, previewColorHandler, false, 0, true);
			colorPalette.addEventListener(ColorPaletteEvent.SELECT_COLOR, selectColorHandler, false, 0, true);
		}
		
		private function selectColorHandler(e:ColorPaletteEvent):void {
			stickerHolder.textColor = colorPalette.selectedColor.hexColor;
		}
		
		private function previewColorHandler(e:ColorPaletteEvent):void {
			stickerHolder.textColor = colorPalette.previewColor.hexColor;
		}
		
	}

}