package com.shurba.lobby {
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	import com.shurba.lobby.vo.GameVO;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;	
	import flash.text.*;	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[Event("complete", type = "flash.events.Event")]	
	
	public class ImageViewer extends Sprite	{
		
		private var _source:Object;
		private var loader:Loader;
		private var request:URLRequest;
		public var url:String;
		protected var loading:Boolean = false;
		public var loaded:Boolean = false;
		private var _imageWidth:Number;
		private var _imageHeight:Number;
		public var backFill:Sprite;
		
		public var data:GameVO;
		
		public var caption:TextField = new TextField();
		
		public function ImageViewer($_imageWidth:Number = 0, $_imageHeight:Number = 0) {
			super();
			
			this._imageWidth = $_imageWidth;
			this._imageHeight = $_imageHeight;
			
			loader = new Loader();
			this.addChild(loader);	
			
			backFill = new Sprite();
			
			this.addChild(caption);
			var tf:TextFormat = new TextFormat("Arial", 12, 0xffffff);
			tf.align = TextFormatAlign.CENTER;
			caption.defaultTextFormat = tf;
			
			caption.multiline = false;
			
			caption.height = caption.textHeight + 26;
			caption.mouseEnabled = false;
			
			this.drawBackFill();
			this.addListeners();
			
			this.buttonMode = true;
			
			TweenPlugin.activate([GlowFilterPlugin]);
		}
		
		protected function drawBackFill():void {
			backFill.graphics.beginFill(0x000000);
			backFill.graphics.moveTo(0, 0);
			backFill.graphics.lineTo(_imageWidth, 0);
			backFill.graphics.lineTo(_imageWidth, _imageHeight);
			backFill.graphics.lineTo(0, _imageHeight);
			backFill.graphics.lineTo(0, 0);
			backFill.alpha = 0;
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);
			//this.addEventListener(MouseEvent.MOUSE_OVER, thisOverHandler, false, 0, true);
			//this.addEventListener(MouseEvent.MOUSE_OUT, thisOutHandler, false, 0, true);
		}
		
		private function thisOutHandler(e:MouseEvent):void {
			TweenLite.to(this, 0.5, { glowFilter:null } );
		}
		
		private function thisOverHandler(e:MouseEvent):void {
			TweenLite.to(this, 0.5, { glowFilter: { color:0xffffff, alpha:1, blurX:3, blurY:3 }} );
		}
		
		private function loaderErrorHandler(e:IOErrorEvent):void {
			//trace ('Image loader: ' + e);
			//this.dispatchEvent(new ImageViewerEvent(ImageViewerEvent.IMAGE_LOAD_ERROR));
		}
		
		public function fadeIn():void {			
			this.visible = true;
			this.alpha = 0;
			TweenLite.to(this, 0.5, { alpha:1 } );
		}
		
		public function fadeOut():void {			
			var $this:ImageViewer = this;
			this.alpha = 1;
			TweenLite.to(this, 0.5, { alpha:0, onComplete:function():void { $this.visible = false } } );
		}
		
		private function loaderCompleteHandler(e:Event):void {
			(e.currentTarget.content as Bitmap).smoothing = true;
			
			loader.scaleX = 1;
			loader.scaleY = 1;
			
			if (this._imageWidth > 0 && this._imageHeight > 0) {
				var coef:Number =  loader.width / loader.height;
				loader.width = _imageWidth;
				loader.height = _imageWidth / coef;
				
				if (loader.height > _imageHeight) {
					loader.height = _imageHeight;
					loader.width = _imageHeight * coef;
				}				
				
				loader.x = (_imageWidth - loader.width) / 2;
				loader.y = (_imageHeight - loader.height) / 2;
			}
			
			loading = false;
			loaded = true;
			
			caption.width = this.width;			
			caption.y = 100;
			
			this.dispatchEvent(new Event(Event.COMPLETE));
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
				loaded = false;
				this.loadImage();
			}
		}
		
		public function get imageWidth():Number { 
			return _imageWidth; 
		}
		
		public function set imageWidth(value:Number):void {
			_imageWidth = value;
			
			if (this._imageWidth > 0) {
				loader.width = this._imageWidth;
			}
		}
		
		public function get imageHeight():Number { 
			return _imageHeight; 
		}
		
		public function set imageHeight(value:Number):void {			
			_imageHeight = value;
			
			if (this._imageHeight > 0) {
				loader.height = this._imageHeight;
			}
		}
		
		public function get originalWidth():Number { 
			return loader.width; 
		}
		
		public function get originalHeight():Number { 
			return loader.height; 
		}
	}

}