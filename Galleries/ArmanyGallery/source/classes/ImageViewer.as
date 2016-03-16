package classes {
	import com.onebyonedesign.extras.WindowBlur;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;	
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import gs.TweenLite;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[Event("closeClick", type = "flash.events.Event")]
	
	public class ImageViewer extends Sprite	{
		
		private var back1:BluredWindow;
		private var back2:BluredWindow;
		private var bluredBack1:WindowBlur;
		private var bluredBack2:WindowBlur;
		private var _source:Object;
		private var loader:Loader;
		private var request:URLRequest;
		public var url:String;
		private var loading:Boolean = false;
		private var imageWidth:Number;
		private var imageHeight:Number;
		
		private var textField:TextField;		
		private var _background:Sprite;
		private var closeBtn:TextButton;
		
		private var myFont:Font = new Font1();
		
		public function ImageViewer($background:Sprite, $imageWidth:Number, $imageHeight:Number) {
			super();
			
			this.imageWidth = $imageWidth;
			this.imageHeight = $imageHeight;
			this._background = $background;
			back1 = new BluredWindow();	
			back1.alpha = 0.5;
			back1.width = 125;
			back1.height = this.imageHeight;
			this.addChildAt(back1, 0);
			
			back2 = new BluredWindow();			
			back2.alpha = 0.5;
			back2.width = this.imageWidth;
			back2.height = this.imageHeight;
			this.addChildAt(back2, 0);
			
			loader = new Loader();
			this.addChild(loader);	
			
			loader.x = back1.x + back1.width + 5;
			back2.x = back1.x + back1.width + 5;
			
			var tf:TextFormat = new TextFormat();
			tf.font = myFont.fontName;
			tf.size = 15;
			//tf
			textField = new TextField();
			this.addChild(textField);
			textField.x = 5;
			textField.y = 5;
			textField.width = back1.width - 10;
			textField.height = back1.height - 10;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.textColor = 0xffffff;
			textField.embedFonts = true;			
			textField.defaultTextFormat = tf;
			textField.multiline = true;
			textField.wordWrap = true;
			textField.selectable = false;
			
			closeBtn = new TextButton();
			this.addChild(closeBtn);
			closeBtn.label = 'Close';
			closeBtn.x = back1.x + back1.width - 5 - closeBtn.width;
			closeBtn.y = back1.y + back1.height - 5 - closeBtn.height;
			trace (back1.y + back1.height - 5 - back1.height);
			this.addListeners();
		}
		
		private function addBackground():void {
			bluredBack1 = new WindowBlur(_background, back1, 30);
			bluredBack2 = new WindowBlur(_background, back2, 30);
		}
		
		private function removeBackground():void {
			bluredBack1.kill();
			bluredBack2.kill();
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);
			closeBtn.addEventListener(MouseEvent.CLICK, closeClickHandler, false, 0, true);
		}
		
		private function closeClickHandler(e:MouseEvent):void {
			this.dispatchEvent(new Event('closeClick'));
		}
		
		private function loaderErrorHandler(e:IOErrorEvent):void {
			trace ('Image loader: ' + e);
		}
		
		public function fadeIn():void {
			this.addBackground();
			this.visible = true;
			this.alpha = 0;
			TweenLite.to(this, 0.5, { alpha:1 } );
		}
		
		public function fadeOut():void {
			this.removeBackground();
			var $this:ImageViewer = this;
			this.alpha = 1;
			TweenLite.to(this, 0.5, { alpha:0, onComplete:function() { $this.visible = false } } );
		}
		
		private function loaderCompleteHandler(e:Event):void {
			(e.currentTarget.content as Bitmap).smoothing = true;
			loader.width = this.imageWidth;
			loader.height = this.imageHeight;
			loading = false;
			loader.alpha = 0;
			TweenLite.to(loader, 0.5, { alpha:1 } );
		}
		
		private function loadImage():void {
			request = new URLRequest(url);
			loading = true;
			loader.load(request);
		}
		
		private function startLoading():void {
			TweenLite.to(loader, 0.5, { alpha:0, onComplete:loadImage } );
		}
		
		public function get source():Object { 
			return url;
		}
		
		public function set source(value:Object):void  {
			if (value is String && value != '' && _source != value) {				
				_source = value;
				url = value as String;				
				this.loadImage();
			}
		}
		
		public function setText($text:String):void {
			textField.text = $text;
		}
		
	}

}