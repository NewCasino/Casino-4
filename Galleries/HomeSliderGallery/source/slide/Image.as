package slide
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import slide.events.ImageEvent;
	
	import flash.utils.Timer;
	import flash.net.navigateToURL;
	
	/**
	 * ...
	 * @author Kam
	 */
	public class Image extends Sprite
	{
		private const LOAD_INTERVAL:Number = 3000;
		private const FADE_STEP:Number = .3;		
		
		private var _imageWidth:Number;
		private var _imageHeight:Number;
		
		private var _imageUrl:String;
		private var _link:String;
		private var _target:String;
		
		private var _isFading:Boolean = false;
			
		private var _nextImage:Image;
		private var _prevImage:Image;
		private var _thumbImage:Image=null;
		private var _bigImage:Image=null;

		private var _isImageLoaded:Boolean = false;
		private var _imageLoader:Loader;
		private var _imageLoadTimer:Timer;
		private var _canClick:Boolean = true;
		
		private var _imageContainer:Sprite;
		
		private var _background:Sprite;
		
		private var _toUrl:String = "";
		private var _toFrameName:String = "";
		private var _toFrameNumber:int = -1;
		
		public function set imageWidth(__imageWidth:Number):void
		{				
			_imageWidth = __imageWidth;
		}
		public function get imageWidth():Number
		{
			return _imageWidth;
		}
		
		public function set imageHeight(__imageHeight:Number):void
		{				
			_imageHeight = __imageHeight;
		}
		public function get imageHeight():Number
		{
			return _imageHeight;
		}
		
		public function set toUrl(__url:String):void
		{
			_toUrl = __url;
			_toFrameName = "";
			_toFrameNumber = -1;
		}
		public function get toUrl():String
		{
			return _toUrl;
		}
		
		public function set toFrameName(__frameName:String):void
		{
			_toFrameName = __frameName;
			_toUrl = "";
			_toFrameNumber = -1;
		}
		public function get toFrameName():String
		{
			return _toFrameName;
		}
		
		public function set toFrameNumber(__frameNumber:int):void
		{
			_toFrameNumber = __frameNumber;
			_toFrameName = "";
			_toUrl = "";
		}
		public function get toFrameNumber():int
		{
			return _toFrameNumber;
		}
		
		public function set imageUrl(__imageUrl:String):void
		{
			_imageUrl = __imageUrl;
		}
		public function get imageUrl():String
		{
			return _imageUrl;
		}
		
		public function set link(__link:String):void
		{
			_link = __link;
		}
		public function get link():String
		{
			return _link;
		}
		
		public function set target(__target:String):void
		{
			_target = __target;
		}
		public function get target():String
		{
			return _target;
		}
		
		public function set nextImage(__nextImage:Image):void
		{
			_nextImage = __nextImage;
		}
		public function get nextImage():Image
		{
			return _nextImage;
		}
		
		public function set prevImage(__prevImage:Image):void
		{
			_prevImage = __prevImage;
		}
		public function get prevImage():Image
		{
			return _prevImage;
		}
		
		public function set thumbImage(__thumbImage:Image):void
		{
			_thumbImage = __thumbImage;
		}
		public function get thumbImage():Image
		{
			return _thumbImage;
		}
		
		public function set bigImage(__bigImage:Image):void
		{
			_bigImage = __bigImage;
		}
		public function get bigImage():Image
		{
			return _bigImage;
		}
		
		public function set isImageLoaded(__isImageLoaded:Boolean):void
		{
			_isImageLoaded = __isImageLoaded;
		}
		public function get isImageLoaded():Boolean
		{
			return _isImageLoaded;
		}
				
		public function set canClick(__canClick:Boolean):void
		{
			_canClick = __canClick;
			buttonMode = _canClick;
			//if(_canClick) addEventListener(MouseEvent.CLICK, onClick);
		}
		public function get canClick():Boolean
		{
			return _canClick;
		}
		
		public function set isFading(__isFading:Boolean):void
		{
			_isFading = __isFading;
		}
		public function get isFading():Boolean
		{
			return _isFading;
		}
		
		private function onImageLoaded(e:Event):void
		{			
			_imageContainer.addChild(_imageLoader);
			_imageLoader.x = (_background.width - _imageLoader.width) / 2;
			_imageLoader.y = (_background.height - _imageLoader.height) / 2;
			isImageLoaded = true;
			dispatchEvent(new ImageEvent(ImageEvent.IMAGE_LOADED, true, false, this));			
		}
		
		private function onImageLoadError(e:IOErrorEvent):void
		{
			throw new Error("Image load error. Reload in " + (LOAD_INTERVAL / 1000).toString() + " seconds.");
			if (imageUrl != "")
			{				
				_imageLoadTimer = new Timer(LOAD_INTERVAL, 0);
				_imageLoadTimer.addEventListener(TimerEvent.TIMER, onLoadImageTimer);
				_imageLoadTimer.start();
			}
		}
		
		private function onLoadImageTimer(e:TimerEvent):void
		{
			if (!isImageLoaded) 
			{
				_imageLoader.load(new URLRequest(imageUrl));	
			}
			else
			{
				_imageLoadTimer.stop();
				_imageLoadTimer.removeEventListener(TimerEvent.TIMER, onLoadImageTimer);
			}
		}
		
		private function onFadeIn(e:Event):void
		{
			if (alpha < 1)
			{
				alpha += FADE_STEP;
			}
			else
			{
				alpha = 1;
				isFading = false;
				removeEventListener(Event.ENTER_FRAME, onFadeIn);
				dispatchEvent(new ImageEvent(ImageEvent.FADED_IN, true, false, this));
			}
		}
		
		
		
		private function onFadeOut(e:Event):void
		{
			if (alpha > 0)
			{
				alpha -= FADE_STEP;
			}
			else
			{
				alpha = 0;
				isFading = false;
				removeEventListener(Event.ENTER_FRAME, onFadeOut);
			}
		}
		
		public function Image(_width:Number, _height:Number) 
		{
			imageWidth = _width;
			imageHeight = _height;
			
			_background = new Sprite();
			_background.graphics.beginFill(0x000000, 1);
			_background.graphics.drawRect(0, 0, imageWidth, imageHeight);
			addChild(_background);
			
			isImageLoaded = false;
			buttonMode = false;
			
			_imageContainer = new Sprite();
			addChild(_imageContainer);
			
			mouseChildren = false;
		}
		
		public function loadImage():void
		{
			if (imageUrl != "")
			{
				_imageLoader = new Loader();
				_imageLoader.load(new URLRequest(imageUrl));
				_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				_imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
			}			
		}
		
		public function FadeIn():void
		{
			if (!isFading)
			{
				isFading = true;
				addEventListener(Event.ENTER_FRAME, onFadeIn);			
			}
		}
		
		public function FadeOut():void
		{
			if (!isFading)
			{
				isFading = true;
				addEventListener(Event.ENTER_FRAME, onFadeOut);			
			}			
		}		
	}	
}