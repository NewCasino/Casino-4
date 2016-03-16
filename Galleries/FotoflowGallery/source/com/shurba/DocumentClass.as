package com.shurba {
	import com.greensock.TweenLite;
	import com.pixelfumes.reflect.Reflect;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	import com.flashloaded.as3.*;
	
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		private static const FADE_TWEEN_LENGHT:Number = 0.5;
		private static const IMAGE_RIGHT_MARGIN:Number = 50;
		private static const IMAGE_LEFT_MARGIN:Number = 50;
		private static const IMAGE_TOP_MARGIN:Number = 50;
		private static const IMAGE_BOTTOM_MARGIN:Number = 50;
		
		private var nPrevMouseX:Number;
		private var nPrevMouseY:Number;
		private var oParams:Object;
		
		public var leftBackground:Sprite;
		public var bufferIcon:MovieClip;
		public var mainImage:ImageViewer;
		public var fotoFlow:PhotoFlow;
		
		public var photoTitle:TextField;
		public var photoDescription:TextField;
		public var backLink:TextField;

		private var fotoFlowFadeTimer:Timer = new Timer(2000);		
		private var fotoFlowTween:TweenLite;
		
		private var startPhotoNumber:int = 5;
		
		public var ref1ect:Reflect;
		
		public function DocumentClass() {
			super();
			if (!this.stage) {				
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			} else {
				this.init();
			}
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.init();			
		}
		
		private function galleryResizeHandler(e:Event):void {
			fotoFlow.y = stage.stageHeight - 300;
			fotoFlow.x = (stage.stageWidth - fotoFlow.width) / 2 + 300;
			
			bufferIcon.x = (stage.stageWidth - 300 - bufferIcon.width) / 2 + 300;
			bufferIcon.y = (stage.stageHeight - bufferIcon.height) / 2;
			
			this.centerMainImage();
			
			leftBackground.height = stage.stageHeight;
		}
		
		private function centerMainImage():void {
			if (!mainImage.loaded) {
				return;
			}
			
			if (ref1ect) {
				ref1ect.destroy();
			}
			
			var nMaxImageWidth:Number = stage.stageWidth - 300 - IMAGE_LEFT_MARGIN - IMAGE_RIGHT_MARGIN;
			var nMaxImageHeight:Number = stage.stageHeight - IMAGE_TOP_MARGIN - IMAGE_BOTTOM_MARGIN;
			
			var coef:Number =  mainImage.originalWidth / mainImage.originalHeight;
			mainImage.width = nMaxImageWidth;
			mainImage.height = nMaxImageWidth / coef;
			
			if (mainImage.height > nMaxImageHeight) {
				mainImage.height = nMaxImageHeight;
				mainImage.width = nMaxImageHeight * coef;
			}				
			
			mainImage.x = (stage.stageWidth - 300 - mainImage.width) / 2 + 300;
			mainImage.y = (stage.stageHeight - mainImage.height) / 2;
			
			ref1ect = new Reflect( { mc:mainImage, alpha:50, ratio:50, distance:0, updateTime: -1, reflectionDropoff:1 } );
		}
		
		private function init():void {
			this.initFlashVars();
			
			// Reflection Class and instantiation		
			mainImage = new ImageViewer();
			
			mainImage.x = 353;
			mainImage.y = 36;
			
			this.addChildAt(mainImage, 0);
			
			
			this.addListeners();
			
			// Stage Scale Settings
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// Mouse movement detector
			fotoFlow.addEventListener(PhotoFlowEvent.PHOTOS_LOADED, fotoFlowInitHandler, false, 0, true);
			
			this.galleryResizeHandler(null);
		}
		
		private function fotoFlowInitHandler(e:Event):void {
			fotoFlow.removeEventListener(PhotoFlowEvent.PHOTOS_LOADED, fotoFlowInitHandler);
			fotoFlowFadeTimer.start();
			fotoFlow.setSelection(startPhotoNumber);
			this.galleryResizeHandler(null);
		}
		
		private function initFlashVars():void {
			oParams = LoaderInfo(this.root.loaderInfo).parameters;
			
			var sBackLink:String = '';
			if (oParams.backUrl != undefined && oParams.backUrl != '') {
				sBackLink = '<a href=\"' + oParams.backUrl + '"><![CDATA[';
				//sXmlUrl = oParams.http_base_url;
			} else {
				//backLink.htmlText = "<a href=\"http://yahoo.com\"><![CDATA[<< Go back to Yahoo]]></a>";
			}
			
			if (oParams.backLinkName != undefined && oParams.backLinkName!='') {
				//sXmlAdvUrl = oParams.advxml_path;
			} else {
				sBackLink += oParams.backLinkName + ']]></a>';
			}
			
			if (oParams.startPhotoNumber != undefined && oParams.startPhotoNumber!='') {
				this.startPhotoNumber = int(oParams.startPhotoNumber);
			}
		}
		
		private function addListeners():void {
			this.stage.addEventListener(Event.RESIZE, galleryResizeHandler);
			
			fotoFlowFadeTimer.addEventListener (TimerEvent.TIMER, fOnTimer, false, 0, true);			
			fotoFlow.addEventListener(PhotoFlowEvent.SELECT, thumbClickHandler, false, 0, true);
			
			mainImage.addEventListener(ImageViewerEvent.IMAGE_LOAD_COMPLETE, mainImageLoadCompleteHandler);
		}
		
		private function mainImageLoadCompleteHandler(e:ImageViewerEvent):void {
			this.centerMainImage();
			bufferIcon.visible = false;
			
			ref1ect = new Reflect( { mc:mainImage, alpha:50, ratio:50, distance:0, updateTime: -1, reflectionDropoff:1 } );
		}
		
		private function thumbClickHandler(e:PhotoFlowEvent):void {
			photoTitle.text = e.data.desc.@name;
			photoDescription.text = e.data.desc;
			if (ref1ect) {
				ref1ect.destroy();
			}
			mainImage.source = String(e.data.desc.@imageUrl);
			bufferIcon.visible = true;
		}

		private function fOnTimer (evtTimer:TimerEvent):void {

			// If the mouse has not moved
			if (mouseX == nPrevMouseX && mouseY == nPrevMouseY) {
				hideThumbs ();
				stage.addEventListener (MouseEvent.MOUSE_MOVE, fOnMouseMove, false, 0, true);
				fotoFlowFadeTimer.reset ();
			} else {
				// Capture the mouse's position
				nPrevMouseX = mouseX;
				nPrevMouseY = mouseY;
			}

		}

		private function fOnMouseMove (evtMouseMove:MouseEvent):void {
			showThumbs ();
			// Restart the timer
			fotoFlowFadeTimer.start ();
			// Remove the listener
			stage.removeEventListener (MouseEvent.MOUSE_MOVE, fOnMouseMove);
		}

		private function showThumbs () {
			if (fotoFlowTween) {
				fotoFlowTween.kill();
			}
			fotoFlow.visible = true;
			fotoFlowTween = TweenLite.to(fotoFlow, FADE_TWEEN_LENGHT, { alpha:1 } );			
		}

		private function hideThumbs () {
			if (fotoFlowTween) {
				fotoFlowTween.kill();
			}
			fotoFlowTween = TweenLite.to(fotoFlow, FADE_TWEEN_LENGHT, { alpha:0, onComplete:function() { fotoFlow.visible = false } } );			
		}
		
	}

}