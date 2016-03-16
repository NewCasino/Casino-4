package com.shurba.marketadviser {
	import com.greensock.plugins.*;
	import com.greensock.TweenLite;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.*;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Link extends Sprite {
		
		private const BUY_COLOR:uint = 0x58A81E;
		private const HOLD_COLOR:uint = 0x4A92F7;
		private const SELL_COLOR:uint = 0xE14933;
		
		public static const URL_TO_NAVIGATE:String = "http://www.webpia.i-tt.ru/signal.html?";
		
		private var _dataProvider:MarketItemVO;
		
		public var link:TextField;
		public var arrow:MovieClip;
		public function Link(data:MarketItemVO = null) {
			super();
			TweenPlugin.activate([TintPlugin]);
			
			//link = new TextField();
			link.mouseEnabled = false;
			
			link.multiline = false;
			
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.LEFT;
			
			tf.bold = false;
			link.defaultTextFormat = tf;
			link.embedFonts = true;
			this.addChild(link);
			this.buttonMode = true;
			this.addListeners();
			if (data)
				this.dataProvider = data;
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		}
		
		private function removeListeners():void {
			this.removeEventListener(MouseEvent.CLICK, clickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function mouseOutHandler(e:MouseEvent):void {
			
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			
		}
		
		private function drawColor():void {
			var startIndex:int;
			var endIndex:int;
			var tf:TextFormat;
			switch (dataProvider.signal.toLowerCase()) {
				case Signal.BUY : {					
					startIndex = link.text.search(dataProvider.signal.toUpperCase());
					endIndex = startIndex + dataProvider.signal.length;
					tf = link.getTextFormat();
					tf.bold = true;
					tf.color = BUY_COLOR;			
					link.setTextFormat(tf, startIndex, endIndex);
					
					break;
				}
				
				case Signal.HOLD : {
					startIndex = link.text.search(dataProvider.signal.toUpperCase());
					endIndex = startIndex + dataProvider.signal.length;
					tf = link.getTextFormat();
					tf.color = HOLD_COLOR;
					tf.bold = true;
					link.setTextFormat(tf, startIndex, endIndex);
					//TweenLite.to(this, 0, { tint:HOLD_COLOR } );					
					break;
				}
				
				case Signal.SELL : {
					startIndex = link.text.search(dataProvider.signal.toUpperCase());
					endIndex = startIndex + dataProvider.signal.length;
					tf = link.getTextFormat();
					tf.color = SELL_COLOR;
					tf.bold = true;
					link.setTextFormat(tf, startIndex, endIndex);
					//TweenLite.to(this, 0, { tint:SELL_COLOR } );					
					break;
				}
			}
			
			/*var 	*/
		}
		
		function placeArrow():void {
			arrow.x = link.textWidth + 13;
			
			switch (dataProvider.trend.toLowerCase()) {
				case 'long' : {
					arrow.gotoAndStop(1);
					break;
				}
				
				case 'consolidation' : {
					arrow.gotoAndStop(2);
					break;
				}
				
				case 'short' : {
					arrow.gotoAndStop(3);
					break;
				}
				default : { 
					arrow.visible = false;
					break;
				}
				
			}
			
		}
		
		public function clear():void {
			this.removeListeners();
		}
		
		private function clickHandler(e:MouseEvent):void {
			navigateToURL(new URLRequest(URL_TO_NAVIGATE + _dataProvider.code));
		}
		
		public function get dataProvider():MarketItemVO { 
			return _dataProvider; 
		}
		
		public function set dataProvider(value:MarketItemVO):void {
			_dataProvider = value;
			
			link.text = value.marketName.toUpperCase() + " "+'\t'+" " + value.name + " "+'\t'+" " + value.signal + " "+'\t'+" "+ value.trend+" ";
			trace (link.text);
			link.width = link.textWidth + 7;
			trace (link.textWidth)
			link.height = link.textHeight + 3;	
			this.drawColor();
			placeArrow();
		}
		
		/*function trimWhitespace($string:String):String {
			if ($string == null) {
				return "";
			}
			return $string.replace(/^\s+|\s+$/g, "");
		}*/
		
		public function drawLine(width:Number):void {
			this.graphics.moveTo(0, link.height-3);
			this.graphics.lineStyle(1, 0x0000ff);
			this.graphics.lineTo(340/*width*/, link.height-3);
		}
		
	}

}