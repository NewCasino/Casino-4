package classes {
	import classes.event.ThumbListerEvent;
	import com.onebyonedesign.extras.WindowBlur;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;	
	import gs.TweenLite;	
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Gallery extends Sprite	{
		
		public static const BACKGROUND_ALPHA:Number = 0.5;
		public static const BACKGROUND_BLUR:Number = 30;
		
		private const THUMBNAILS_VIEW:int = 0;
		private const IMAGE_VIEW:int = 1;
		
		private var currentView:int = 0;
		
		private var _xmlPath:String;
		private var gXmlLoader:GalleryXMLLoader;
		private var imagesData:Object;
		public var thumbList:ThumbLister;
		public var imageViewer:ImageViewer;
		
		public var rightButton:RotateButton;
		public var leftButton:RotateButton;
		
		//private var leftBack:Sprite;
		private var backgroundImage:Sprite;
		
		private var bottomBack:BluredWindow;		
		private var bluredBack:WindowBlur;
		
		private var titleBack:BluredWindow;		
		private var titleBluredBack:WindowBlur;
		
		private var closeBtn:TextButton;
		private var titleText:TextField;
		
		private var myFont:Font = new Font1();
		
		public function Gallery() {
			super();
			
		}
		
		public function init():void {
			this.addBackground();
		}
		
		public function get xmlPath():String { 
			return _xmlPath; 
		}
		
		private function addBackground():void {
			backgroundImage = new Sprite();
			this.addChild(backgroundImage);			
			var loader:Loader = new Loader();
			backgroundImage.addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, backLoadedHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, backLoadErrorHandler);			
			loader.load(new URLRequest(imagesData.backImageUrl));
		}
		
		private function backLoadedHandler(e:Event):void {
			(e.currentTarget as LoaderInfo).removeEventListener(Event.COMPLETE, backLoadedHandler);
			(e.currentTarget as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, backLoadErrorHandler);
			
			this.createUI();
			this.updatePositions();
		}
		
		private function backLoadErrorHandler(e:IOErrorEvent):void {
			trace ("Background loader: "+e);
			(e.currentTarget as LoaderInfo).removeEventListener(Event.COMPLETE, backLoadedHandler);
			(e.currentTarget as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, backLoadErrorHandler);
		}
		
		
		public function set xmlPath(value:String):void {
			_xmlPath = value;			
			gXmlLoader = new GalleryXMLLoader(value, onDataLoaded);
		}
		
		private function onDataLoaded($imagesData:Object):void {
			this.imagesData = $imagesData;
			this.addBackground();
		}
		
		protected function createUI():void {
			titleBack = new BluredWindow();
			this.addChild(titleBack);
			titleBack.alpha = Gallery.BACKGROUND_ALPHA;
			titleBluredBack = new WindowBlur(backgroundImage, titleBack, Gallery.BACKGROUND_BLUR);
			
			bottomBack = new BluredWindow();
			this.addChild(bottomBack);			
			bottomBack.alpha = Gallery.BACKGROUND_ALPHA;
			bluredBack = new WindowBlur(backgroundImage, bottomBack, Gallery.BACKGROUND_BLUR);
			/*leftBack.filters = backFilters;
			middleBack.filters = backFilters;
			bottomBack.filters = backFilters;*/
			
			thumbList = new ThumbLister();
			thumbList.addEventListener("itemClick", thumbListItemClickHandler, false, 0, true);
			this.addChild(thumbList);
			thumbList.init(this.imagesData, backgroundImage);
			
			imageViewer = new ImageViewer(backgroundImage, imagesData.imageWidth, imagesData.imageHeight);			
			imageViewer.addEventListener("closeClick", imageClickHandler, false, 0, true);
			this.addChild(imageViewer);
			imageViewer.visible = false;
			
			rightButton = new RotateButton();
			rightButton.name = 'rightButton';
			rightButton.orientation = RotateButton.ORIENTATION_RIGHT;
			rightButton.addEventListener(MouseEvent.CLICK, rightButtonClickHandler, false, 0, true);
			this.addChild(rightButton);
			
			leftButton = new RotateButton();			
			leftButton.name = 'leftButton';
			leftButton.orientation = RotateButton.ORIENTATION_LEFT;
			leftButton.addEventListener(MouseEvent.CLICK, leftButtonClickHandler, false, 0, true);						
			this.addChild(leftButton);
			
			titleText = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.font = myFont.fontName;
			tf.size = 20;			
			tf.align = TextFormatAlign.RIGHT;			
			titleText.autoSize = TextFieldAutoSize.RIGHT
			titleText.textColor = 0xffffff;
			titleText.embedFonts = true;			
			titleText.defaultTextFormat = tf;
			titleText.multiline = true;
			titleText.wordWrap = true;
			titleText.selectable = false;
			this.addChild(titleText);			
			titleText.width = 263;
			titleText.height = 50;			
			titleText.text = imagesData.galleryName;
			
			closeBtn = new TextButton();
			this.addChild(closeBtn);
			closeBtn.label = imagesData.closeLabel;
			closeBtn.addEventListener(MouseEvent.CLICK, closeGallery);
		}
		
		private function closeGallery(e:MouseEvent):void {
			navigateToURL(new URLRequest(imagesData.closeUrl), "_self");
		}
		
		private function imageClickHandler(e:Event):void  {			
			this.switchToThumbView();
		}
		
		private function thumbListItemClickHandler(e:ThumbListerEvent):void {			
			this.switchToImageView();
			imageViewer.source = e.data.imageUrl;
			imageViewer.setText(e.data.imageText);
		}
		
		
		
		
		protected function updatePositions():void {
			
			if (currentView == this.THUMBNAILS_VIEW) {
				//thumbList.visible = true;
				//imageViewer.visible = false;
				
				titleBack.width = 268;
				titleBack.height = imagesData.thumbHeight + 50 + imagesData.thumbsGap;
				
				thumbList.x = titleBack.width + imagesData.thumbsGap;
				thumbList.y = (stage.stageHeight - imagesData.thumbHeight) / 2;
				
				titleBack.y = thumbList.y;
			
				bottomBack.width = stage.stageWidth;
				bottomBack.height = 50;
				bottomBack.x = titleBack.width + imagesData.thumbsGap;
				bottomBack.y = thumbList.y + thumbList.height + imagesData.thumbsGap;
				
				leftButton.x = bottomBack.x + imagesData.thumbsGap;
				leftButton.y = bottomBack.y + (bottomBack.height - leftButton.height) / 2;
				
				rightButton.x = leftButton.x + imagesData.thumbWidth - rightButton.width - (imagesData.thumbsGap * 2);
				rightButton.y = bottomBack.y + (bottomBack.height - rightButton.height) / 2;
				
				titleText.x = titleBack.x;
				titleText.y = titleBack.y + 5;
				
				closeBtn.x = titleBack.x + titleBack.width - 5 - closeBtn.width;
				closeBtn.y = titleBack.y + titleBack.height - 5 - closeBtn.height;
				
			} else {					
				imageViewer.x = titleBack.width + imagesData.thumbsGap;
				imageViewer.y = bottomBack.y - imageViewer.height - imagesData.thumbsGap;
				
				
				thumbList.x = titleBack.width + imagesData.thumbsGap + imageViewer.width + imagesData.thumbsGap;				
				thumbList.y = (stage.stageHeight - imagesData.thumbHeight) / 2;
				
			}
			
			/*middleBack.graphics.beginFill(0x000000, 0.5);
			middleBack.graphics.drawRect(0, 0, thumbList.width, thumbList.height);			
			middleBack.graphics.endFill();
			middleBack.y = thumbList.y + imagesData.thumbsGap;
			
			*/
			
			
			
			
		}
		
		private function leftButtonClickHandler(e:MouseEvent):void {
			thumbList.rotateLeft();
			this.loadCurrentImage();
		}
		
		private function rightButtonClickHandler(e:MouseEvent):void {
			thumbList.rotateRight();
			this.loadCurrentImage();
		}
		
		private function loadCurrentImage():void {
			if (currentView == this.IMAGE_VIEW) {
				var tmpThumb:Thumbnail = (thumbList.thumbs[thumbList.currentFirst] as Thumbnail);
				imageViewer.source = tmpThumb.imageVO.imageUrl;
				imageViewer.setText(tmpThumb.imageVO.imageText);
			}			
		}
		
		protected function switchToThumbView():void {
			if (currentView == this.THUMBNAILS_VIEW) {				
				return;
			}
			currentView = 0;
			thumbList.fadeIn();
			imageViewer.fadeOut();
			this.updatePositions();
		}
		
		protected function switchToImageView():void {
			if (currentView == this.IMAGE_VIEW) {				
				return;
			}
			currentView = 1;
			thumbList.fadeOut();
			imageViewer.fadeIn();
			this.updatePositions();
		}
		
	}

}