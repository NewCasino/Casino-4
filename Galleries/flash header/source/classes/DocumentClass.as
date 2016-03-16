package classes {	
	import classes.component.ControlBar;
	import classes.GalleryXMLLoader;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite	{
		
		public var border:Sprite
		
		public static var $stage:DocumentClass;	
		private const TIMER_DELAY:int = 3500;
		
		private static const XML_URL:String = 'data.xml';		
		public var images:Array = new Array();
		
		private var imagesData:Object;		
		public var logo:Logo;
		
		private var timer:Timer;
		
		private var currentImageNum:int = 0;
		private var numImages:int;
		
		public var controlBar:ControlBar;
		
		private var mouseOver:Boolean = false;
		private var timerDone:Boolean = false;
		
		public function DocumentClass() {
			$stage = this;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			var xmlLoader:GalleryXMLLoader = new GalleryXMLLoader(XML_URL, onDataLoaded);
			this.buttonMode = true;
			timer = new Timer(TIMER_DELAY);
			this.addListeners();
		}
		
		
		private function addListeners():void {
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, thisOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, thisOutHandler, false, 0, true);
		}
		
		private function thisOutHandler(e:MouseEvent):void {
			mouseOver = false;			
			if (timerDone) {
				this.timerHandler(null);
			}
		}
		
		private function thisOverHandler(e:MouseEvent):void {
			mouseOver = true;
		}
		
		private function timerHandler(e:TimerEvent):void {
			if (mouseOver) {
				timerDone = true;
				return;
			}
			
			var nextImageNum:int
			if (currentImageNum == numImages -1) {
				nextImageNum = 0;
			} else {
				nextImageNum = currentImageNum + 1;
			}			
			
			var currentImage:Image = images[currentImageNum] as Image;
			var nextImage:Image = images[nextImageNum] as Image;
			nextImage.visible = true;
			nextImage.y = - nextImage.height;
			TweenLite.to(nextImage, 0.75, { y:0 } );
			TweenLite.to(currentImage, 0.75, { y:currentImage.height, onComplete:function(){currentImage.visible = false} } );
			timer.reset();
			timer.start();
			timerDone = false;
			currentImageNum = nextImageNum;
			controlBar.currentItemNumber = currentImageNum;
		}
		
		private function onDataLoaded($data:Object):void {
			imagesData = $data;
			this.loadImages();
			this.loadLogo();
			(images[currentImageNum] as Image).visible = true;
			this.addControlBar();
			this.removeChild(border);
			this.addChild(border)
			timer.start();
			timerDone = false;
		}
		
		private function addControlBar():void {
			controlBar = new ControlBar();
			controlBar.numItems = images.length;
			this.addChild(controlBar);
			controlBar.x = 12;
			controlBar.y = 222;
			controlBar.currentItemNumber = 0;
			controlBar.addEventListener(MouseEvent.CLICK, controlBarItemClickHandler, false, 0, true);
			
		}
		
		private function controlBarItemClickHandler(e:Event):void {
			timer.stop();
			this.timerHandler(null);
			
			var nextImageNum:int
			if (currentImageNum == numImages -1) {
				nextImageNum = 0;
			} else {
				nextImageNum = currentImageNum + 1;
			}			
			
			var currentImage:Image = images[currentImageNum] as Image;
			var nextImage:Image = images[nextImageNum] as Image;
			nextImage.visible = true;
			nextImage.y = - nextImage.height;
			TweenLite.to(nextImage, 0.75, { y:0 } );
			TweenLite.to(currentImage, 0.75, { y:currentImage.height, onComplete:function(){currentImage.visible = false} } );
			timer.reset();
			timer.start();
			timerDone = false;
			currentImageNum = nextImageNum;
			controlBar.currentItemNumber = currentImageNum;
			
			/*
			var nextImageNum:int
			nextImageNum = (e.currentTarget as ControlBar).currentItemNumber;
			var currentImage:Image = images[currentImageNum] as Image;
			var nextImage:Image = images[nextImageNum] as Image;
			nextImage.visible = true;
			nextImage.y = - nextImage.height;
			TweenLite.to(nextImage, 0.5, { y:0 } );
			TweenLite.to(currentImage, 0.5, { y:currentImage.height, onComplete:function(){currentImage.visible = false} } );
			timer.reset();
			timer.start();
			currentImageNum = nextImageNum;*/
		}
		
		private function loadImages():void {
			var tmpArray:Array = imagesData.imageObjects as Array			
			for (var i:int = 0; i < tmpArray.length; i++) {
				var tmpImage:Image = new Image();
				tmpImage.init(tmpArray[i] as ImageVO);
				images.push(tmpImage);
				tmpImage.visible = false;
				this.addChild(tmpImage);
			}
			numImages = images.length;
		}
		
		private function setAllInvisible():void {
			
		}
		
		private function loadLogo():void {
			logo = new Logo(imagesData.logoUrl, imagesData.logoLink);
			this.addChild(logo);
			logo.x = 12;
			logo.y = 12;
		}
		
	}

}