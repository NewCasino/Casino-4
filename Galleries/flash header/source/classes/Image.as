package classes {
	import classes.component.ArrowsBM;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;	
	import flash.text.*;
	
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	public class Image extends Sprite {
		
		private const BORDER_SIZE:int = 0;
		
		private var request:URLRequest;
		private var loader:Loader;
		
		public var imageVO:ImageVO;
		
		private var borderSprite:Sprite;
		
		public var bigTextField:TextField;
		public var smallTextField:TextField;
		private var myFont:Font = new Font1();
		
		private var arrowsBitmap:Bitmap;
		
		
		public function Image() {
			super();
			loader = new Loader();			
			
			this.addListeners();
			this.addChild(loader);			
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderLoadComplete, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderLoadError, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, linkBtnClickHandler);
		}
		
		private function linkBtnClickHandler($event:MouseEvent):void {
			if (imageVO.imageLink == "") return;			
			var $request:URLRequest = new URLRequest(imageVO.imageLink);
			navigateToURL($request, "_self");
		}
		
		private function loaderLoadError(e:IOErrorEvent):void {
			trace (e);
		}
		
		private function loaderLoadComplete(e:Event):void {
			(e.currentTarget.content as Bitmap).smoothing = true;			
			loader.visible = true;
			loader.x = BORDER_SIZE;
			loader.y = BORDER_SIZE;
			loader.width = imageVO.imageWidth - (BORDER_SIZE * 2);
			loader.height = imageVO.imageHeight - (BORDER_SIZE * 2);
			//this.drawBorder();
			this.renderText();
		}
		
		public function init($data:ImageVO):void {
			imageVO = $data;
			this.loadImage();			
		}
		
		protected function loadImage():void {
			request = new URLRequest(imageVO.imageUrl);
			loader.visible = false;			
			loader.load(request);
		}
		
		private function drawBorder():void {
			borderSprite = new Sprite();
			this.addChildAt(borderSprite, 0);
			borderSprite.graphics.clear();
			borderSprite.graphics.beginFill(0xffffff);
			borderSprite.graphics.lineStyle(BORDER_SIZE, 0xffffff);
			borderSprite.graphics.moveTo(0, 0);
			borderSprite.graphics.lineTo(imageVO.imageWidth , 0);
			borderSprite.graphics.lineTo(imageVO.imageWidth , imageVO.imageHeight);
			borderSprite.graphics.lineTo(0, imageVO.imageHeight);
			borderSprite.graphics.lineTo(0, 0);
			borderSprite.graphics.endFill();
		}
		
		private function renderText():void {
			
			
			var tf:TextFormat = new TextFormat();
			tf.font = myFont.fontName;
			tf.size = 20;
			tf.align = TextFormatAlign.RIGHT;
			
			bigTextField = new TextField();
			smallTextField = new TextField();			
			this.addChild(bigTextField);
			this.addChild(smallTextField);
			
			bigTextField.x = 0;
			bigTextField.y = 185;
			bigTextField.mouseEnabled = false;
			bigTextField.width = this.width - 12;
			bigTextField.height = 25;
			bigTextField.autoSize = TextFieldAutoSize.RIGHT;
			bigTextField.textColor = 0xffffff;
			bigTextField.embedFonts = true;			
			bigTextField.defaultTextFormat = tf;
			bigTextField.multiline = true;
			bigTextField.wordWrap = true;
			bigTextField.selectable = false;			
			
			tf.size = 15;
			
			
			if (imageVO.smallText != '') {
				arrowsBitmap = new Bitmap(new ArrowsBM(0, 0));
				this.addChild(arrowsBitmap);				
				smallTextField.x = 0;
				smallTextField.y = 212;
				smallTextField.mouseEnabled = false;
				smallTextField.width = this.width - 18 - arrowsBitmap.width;
				smallTextField.height = 18;
				smallTextField.autoSize = TextFieldAutoSize.RIGHT;
				smallTextField.textColor = 0xffffff;
				smallTextField.embedFonts = true;			
				smallTextField.defaultTextFormat = tf;
				smallTextField.multiline = true;
				smallTextField.wordWrap = true;
				smallTextField.selectable = false;
				arrowsBitmap.y = smallTextField.y + 7;
				arrowsBitmap.x = smallTextField.x + smallTextField.width + 4;
			}
			
			bigTextField.text = imageVO.bigText;
			smallTextField.text = imageVO.smallText;
			
			var shadow:DropShadowFilter = new DropShadowFilter(0, 45, 0x000000, 1, 6, 6, 2, 10);
			bigTextField.filters = [shadow];
			smallTextField.filters = [shadow];
		}
		
	}

}