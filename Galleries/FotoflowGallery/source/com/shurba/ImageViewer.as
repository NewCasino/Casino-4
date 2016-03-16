package com.shurba {	
	import com.greensock.TweenLite;
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
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	//[Event("closeClick", type = "flash.events.Event")]
	[Event("imageLoadComplete", type = "com.shurba.ImageViewerEvent")]
	
	public class ImageViewer extends Sprite	{
		
		private var _source:Object;
		private var loader:Loader;
		private var request:URLRequest;
		public var url:String;
		private var loading:Boolean = false;
		public var loaded:Boolean = false;
		private var _imageWidth:Number;
		private var _imageHeight:Number;
		
		public function ImageViewer($_imageWidth:Number = 0, $_imageHeight:Number = 0) {
			super();
			
			this._imageWidth = $_imageWidth;
			this._imageHeight = $_imageHeight;
			
			loader = new Loader();
			this.addChild(loader);	
			
			this.addListeners();
		}
		
		private function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler, false, 0, true);		
		}
		
		private function closeClickHandler(e:MouseEvent):void {
			//this.dispatchEvent(new Event('closeClick'));
		}
		
		private function loaderErrorHandler(e:IOErrorEvent):void {
			trace ('Image loader: ' + e);
		}
		
		public function fadeIn():void {			
			this.visible = true;
			this.alpha = 0;
			TweenLite.to(this, 0.5, { alpha:1 } );
		}
		
		public function fadeOut():void {			
			var $this:ImageViewer = this;
			this.alpha = 1;
			TweenLite.to(this, 0.5, { alpha:0, onComplete:function() { $this.visible = false } } );
		}
		
		private function loaderCompleteHandler(e:Event):void {
			(e.currentTarget.content as Bitmap).smoothing = true;
			if (this._imageWidth > 0) {
				loader.width = this._imageWidth;
			}
			
			if (this._imageHeight > 0) {
				loader.height = this._imageHeight;
			}
			
			loading = false;
			loaded = true;
			this.dispatchEvent(new ImageViewerEvent(ImageViewerEvent.IMAGE_LOAD_COMPLETE));
			
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