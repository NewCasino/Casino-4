package com.andersbrohus {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.andersbrohus.Image;
	import flash.utils.setTimeout;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class  Gallery extends Sprite {
		
		private const ITEMS_PER_PAGE:int = 8;
		private const ITEMS_START_X:int = 487;
		private const ITEMS_START_Y:int = 175;
		private const ITEMS_X_OFFSET:int = -50;
		private const ITEMS_Y_SHIFT:int = 15;
		private const ITEMS_ROW_OFFSET:int = 20;
		private const RANDOM_COEF:int = 50;
		
		
		
		public static const MAX_THUMB_WIDTH:int = 150;
		public static const MAX_THUMB_HEIGHT:int = 150;
		
		public static const MAX_IMAGE_HEIGHT:int = 400;
		public static const MAX_IMAGE_WIDTH:int = 550;
		
		public static const GALLERY_WIDTH:int = 716;
		public static const GALLERY_HEIGHT:int = 471;
		
		public static const FRAME_SIZE:int = 5;
		
		public static const MAX_ANIMATION_DELAY:int = 1500; //milliseconds
		
		public static const ANIMATION_START_X:int = -800;
		public static const ANIMATION_START_Y:int = 0;
		
		public static var ANIMATION_DELAY:Number = 450;
		public static var FRAME_FLY_SECONDS:Number = 0.5;
		public static var IMAGE_FLY_SECONDS:Number= 1.2;
		
		
		
		private var currentItems:Array;
		private var imageContainers:Array;
		
		public var btnBack:Sprite;
		public var btnNext:Sprite;
		public var preloader:Sprite;
		public var mcBackground:Sprite;
		
		private var currentPagingOffset:int = 0;
		private var imagesLoadedCounter:int = 0;
		private var imagesNumber:int = 0;
		
		private var oneOfImageZoomed:Boolean;
		private var switched:Boolean = false;
		
		private var bgLoader:Loader = new Loader();
		
		public function Gallery() {
			btnBack.buttonMode = true;
			btnNext.buttonMode = true;
			btnBack.visible = false;
			btnBack.addEventListener(MouseEvent.CLICK, btnBackClickHander, false, 0, true);
			btnNext.addEventListener(MouseEvent.CLICK, btnNextClickHander, false, 0, true);
			//this.addEventListener(MouseEvent.CLICK, zoomOutAll, false, 0, true);
			this.generateImageContainers();
		}
		
		private function zoomOutAll():void {
			var container:Image;
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				if (imageContainers[i].zoomed) {
					//trace("ZOOMED");
					this.zoomOutImage(imageContainers[i]);
				}
			}
		}
		
		private function generateImageContainers():void {
			imageContainers = new Array();
			var container:Image;
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				container = new Image();				
				imageContainers.push(container);
				this.addChild(container);
				container.lastDepth = this.getChildIndex(container);
				//container.filters.push(new DropShadowFilter());
			}
			
			var lastDepthSprite:Sprite = new Sprite();
			this.addChild(lastDepthSprite);
		}
		
		private function imageMouseOutHandler(e:MouseEvent):void {
			if (this.checkZoomedImage()) {
				return;
			}
			var container:Image = e.currentTarget as Image;
			this.zoomOutImage(container);
			//container.containerClip.addBlur();
		}
		
		private function imageMouseOverHandler(e:MouseEvent):void {
			if (this.checkZoomedImage()) {
				return;
			}
			var container:Image = e.currentTarget as Image;
			this.setChildIndex(container, this.numChildren - 1);
			container.containerClip.resizeTo(Math.ceil(container.lastWidth * 1.2), Math.ceil(container.lastHeight * 1.2), true);
			//this.disableMoving();
			//container.containerClip.removeBlur();
		}
		
		private function imageClickHandler(e:MouseEvent):void {
			var container:Image = e.currentTarget as Image;
			//container.zoomed = !container.zoomed;
			if (container.zoomed) {
				this.zoomOutImage(container);
			} else {				
				this.zoomInImage(container);
			}
			
		}
		
		private function checkZoomedImage():Boolean {
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				if (imageContainers[i].zoomed) {
					return true;
				}
			}
			return false;
		}
		
		
		private function zoomInImage($image:Image):void {
			var toX:Number;
			var toY:Number;
			if (this.checkZoomedImage()) {
				//trace ("SOMETHING ZOOMED");
				return;
			}
			this.disableMoving();
			this.zoomOutAll();
			$image.zoomed = true;
			this.updateDepths();
			this.setChildIndex($image, this.numChildren - 1);
			$image.containerClip.resizeTo(MAX_IMAGE_WIDTH, MAX_IMAGE_HEIGHT, true);
			toY = Gallery.GALLERY_HEIGHT / 2;
			toX = Gallery.GALLERY_WIDTH / 2;
			TweenLite.to($image, 0.25, { x:toX, y:toY } );
			$image.containerClip.hideMask();
			
		}
		
		private function zoomOutImage($image:Image):void {
			
			$image.mouseEnabled = false;
			$image.containerClip.resizeTo(Gallery.MAX_THUMB_WIDTH, Gallery.MAX_THUMB_HEIGHT, true, function() { setChildIndex($image, $image.lastDepth);
																												$image.mouseEnabled = true;
																												$image.zoomed = false;
																												$image.containerClip.showMask();} );
			TweenLite.to($image, 0.25, { x:$image.lastX, y:$image.lastY } );
			//$image.containerClip.tintMask.visible = true;
			this.enableMoving();
		}
		
		private function reposition():void {
			var container:Image;
			var containerCursor1:Number = this.ITEMS_START_X;
			var containerCursor2:Number = this.ITEMS_START_X;
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {				
				if (i < 4) {					
					imageContainers[i].x = containerCursor1;
					imageContainers[i].y = this.ITEMS_START_Y - this.ITEMS_Y_SHIFT * i;
					containerCursor1 = containerCursor1 - imageContainers[i].width - this.ITEMS_X_OFFSET;					
				} else {
					imageContainers[i].x = containerCursor2;
					imageContainers[i].y = this.ITEMS_START_Y + MAX_THUMB_HEIGHT - (this.ITEMS_Y_SHIFT * (i - 4));
					containerCursor2 = containerCursor2 - imageContainers[i].width - this.ITEMS_X_OFFSET;					
				}
				
				this.setChildIndex(imageContainers[i], imageContainers[i].lastDepth);
				imageContainers[i].lastDepth = this.getChildIndex(imageContainers[i]);
				imageContainers[i].savePositions();				
			}
			
			var tmpArray:Array = new Array();
			var j:int = this.numChildren -2;
			
			var step:int = 0;
			var n:int = 4;
			
			/*for (var i:int = n * step; i > n * (step - 1) -1; i--) {
				
			}*/
			
			for (i = 0; i < this.ITEMS_PER_PAGE; i++) {
				//trace (imageContainers[i].x + "   " + imageContainers[i].y);
				this.setChildIndex(imageContainers[i], j);
				imageContainers[i].lastDepth = this.getChildIndex(imageContainers[i]);
				j--;
			}
			/*
			for (i = 3; i > -1 ; i--) {
				tmpArray.push(imageContainers[i]);
				this.setChildIndex(imageContainers[i], j);
				imageContainers[i].lastDepth = this.getChildIndex(imageContainers[i]);
				j--;
			}
			for (i = this.ITEMS_PER_PAGE - 1; i > 3; i--) {
				tmpArray.push(imageContainers[i]);
				this.setChildIndex(imageContainers[i], j);
				imageContainers[i].lastDepth = this.getChildIndex(imageContainers[i]);
				j--;
			}*/
			//imageContainers = tmpArray;
			/*for (i = this.ITEMS_PER_PAGE - 1; i > -1; i--) {
				imageContainers[i].lastDepth = this.getChildIndex(imageContainers[i]);
				j--;
			}*/
		}
		
		private function updateDepths():void {
			/*if (this.checkZoomedImage()) {
				return;
			}*/
			for (var i:int = 0; i > this.ITEMS_PER_PAGE; i++) {
				this.setChildIndex(imageContainers[i], imageContainers[i].lastDepth);
			}
		}
		
		private function enableMoving():void {
			//trace("ENABLE MOVING!!");
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				imageContainers[i].enableReactionOnMouse();
			}
		}
		
		private function disableMoving():void {			
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				imageContainers[i].disableReactionOnMouse();
			}
			
		}
		
		private function disableMouse():void {
			//trace("MOUSE DISABLED");
			var container:Image;
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				container = imageContainers[i] as Image;
				if (container.hasEventListener(MouseEvent.CLICK)) {
					container.removeEventListener(MouseEvent.CLICK, imageClickHandler);
					container.removeEventListener(MouseEvent.ROLL_OVER, imageMouseOverHandler);
					container.removeEventListener(MouseEvent.ROLL_OUT, imageMouseOutHandler);
				}
			}
		}
		
		private function enableMouse():void {
			//trace("MOUSE ENABLED");
			var container:Image;
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				container = imageContainers[i] as Image;
				if (!imageContainers[i].hasEventListener(MouseEvent.CLICK)) {
					container.addEventListener(MouseEvent.CLICK, imageClickHandler, false, 0, true);
					container.addEventListener(MouseEvent.ROLL_OVER, imageMouseOverHandler, false, 0, true);
					container.addEventListener(MouseEvent.ROLL_OUT, imageMouseOutHandler, false, 0, true);
				}
			}
		}
		
		private function btnNextClickHander(e:MouseEvent):void {
			currentPagingOffset++;
			this.fadeAndUpdate();
		}
		
		private function btnBackClickHander(e:MouseEvent):void {
			currentPagingOffset--;
			this.fadeAndUpdate();
		}
		
		private function fadeAndUpdate():void {
			var container:Image;
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				container = imageContainers[i] as Image;
				TweenLite.to(container, 0.5, { alpha:0} );
			}
			setTimeout(updateImages, 600);
		}
		
		public function init(xmlPath:String):void {
			if (xmlPath == "") {
				throw new Error("Gallery component: not valid XML path.");
				return;
			}			
			var request:URLRequest = new URLRequest(xmlPath);
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
            urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			
			try {
                urlLoader.load(request);
            } catch (error:SecurityError) {
                trace("A SecurityError has occurred.");
            }
			
			
		}
		
		private function loaderCompleteHandler(e:Event):void {
			currentItems = new Array();
			var xList:XMLList = new XMLList();
			var xml:XML = new XML(e.target.data);
			xList =  xml.children();
			for (var i:int = 0; i < xList.length(); i++) {
				currentItems.push(xml.@folder + "/" + xList[i].@source);
			}
			
			if (xml.hasOwnProperty("@frameFlySeconds")) {
				Gallery.FRAME_FLY_SECONDS = Number(xml.@frameFlySeconds);
			}
			
			if (xml.hasOwnProperty("@frameFlySeconds")) {
				Gallery.IMAGE_FLY_SECONDS = Number(xml.@imageFlySeconds);
			}
			
			if  (xml.hasOwnProperty("@background") && xml.@background != "") {
				//trace ("	HAS PROPERTY			");
				var request:URLRequest = new URLRequest(xml.@background);
				
				bgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bgLoadError, false, 0, true);
				bgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bgLoadComplete, false, 0, true);
				bgLoader.load(request);
				try {
					
				} catch (error:SecurityError) {
					trace("A SecurityError has occurred.");
				}
				
			} else {
				this.updateImages();
			}
			
		}
		
		private function bgLoadComplete(e:Event):void {
			//trace ("bgLoader.width = GALLERY_WIDTH");
			var bitmap:Bitmap;
			if (bgLoader.contentLoaderInfo.content is Bitmap) {
				bitmap = bgLoader.contentLoaderInfo.content as Bitmap;
				bitmap.smoothing = true;
			}
			mcBackground.addChild(bgLoader);
			bgLoader.width = GALLERY_WIDTH;
			bgLoader.height = GALLERY_HEIGHT;
			this.updateImages();
		}
		
		private function bgLoadError(e:IOErrorEvent):void {
			trace ("BG LOAD ERROR  " + e);
			this.updateImages();
		}
		
		
		private function loadBackground():void {
			
		}
		
		private function errorHandler(e:Event):void {
			trace("XML load error " + e);
		}
		
		private function onImageLoaded($image:Image):void {
			imagesLoadedCounter++;
			$image.visible = true;
			//trace (currentItems.length +"  " + imagesLoadedCounter);
			if (imagesLoadedCounter == imagesNumber) {
				this.reposition();
				//this.enableMoving();
				this.startAnimation();
				preloader.visible = false;
			}
		}
		
		private function startAnimation():void {
			this.disableMoving();
			this.disableMouse();
			var itemNum:int = 0;
			var container:Image;
			imagesLoadedCounter = 0;
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				itemNum = i + currentPagingOffset * this.ITEMS_PER_PAGE;
				container = imageContainers[i] as Image;				
				if (currentItems[itemNum]) {
					container.alpha = 1;
					container.containerClip.moveInAnimation(ANIMATION_DELAY * i);
				}
			}
			//trace (ANIMATION_DELAY * i + 500);
			setTimeout(enableMouse, ANIMATION_DELAY * i + 1500);
			setTimeout(enableMoving, ANIMATION_DELAY * i + 750);
			/*while (i > -1 && j > this.ITEMS_PER_PAGE / 2 -1) {
				container = imageContainers[i] as Image;
				container.containerClip.moveInAnimation();
				i--;
				j--;
			}*/
		}
		
		private function updateImages():void {
			preloader.visible = true;
			this.disableMouse();
			this.disableMoving();
			this.zoomOutAll();
			var itemNum:int = 0;
			var container:Image;
			imagesLoadedCounter = 0;
			imagesNumber = 0;
			for (var i:int = 0; i < this.ITEMS_PER_PAGE; i++) {
				itemNum = i + currentPagingOffset * this.ITEMS_PER_PAGE;
				container = imageContainers[i] as Image;
				container.alpha = 0;
				if (!currentItems[itemNum]) {					
					container.visible = false;
				} else {
					imagesNumber++;
					container.visible = true;
					container.containerClip.loadImage(currentItems[itemNum], onImageLoaded);
				}
				
			}
			
			var numPages:int = Math.ceil(currentItems.length / ITEMS_PER_PAGE);
            var curPage:int = currentPagingOffset + 1;
            //trace ("numPages  " + numPages + "  " + "  curPage " + curPage);
			if (curPage <= 1) {
                btnBack.visible = false;
			} else {
                btnBack.visible = true;
            } if (curPage >= numPages) {
                btnNext.visible = false;
            } else {
                btnNext.visible = true;
            }
		}
		
		
	}
	
}