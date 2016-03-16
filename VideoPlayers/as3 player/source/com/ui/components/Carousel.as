package com.ui.components {
	
	import com.data.DataHolder;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gs.TweenLite;
	
	public class Carousel extends MovieClip {
		
		public var txtDescription:TextField;
		public var mcMask:MovieClip;
		public var mcBackground:MovieClip;
		public var mcThumbContainer:MovieClip;
		public var mcLeftArrow:MovieClip;
		public var mcRightArrow:MovieClip;
		public var nSeparation:Number;	
		public var nSpace:Number;
		public var nThumbWidth:Number;	
		public var nThumbHeight:Number;		
		public var nSpeed:Number;	
		public var nMovement:Number;	
		public var nItemsNum:Number;
		public var nChainWidth:Number;
		
		public var nMaxWidth:Number;	
		public var nMaxHeight:Number;
		public var paddingRight:Number;	
		public var paddingLeft:Number;
		
		private var aThumbs:Array;		
		private var dataHolder:DataHolder = DataHolder.getInstance();
		public var bMoveFlag:Boolean;
		
		public function Carousel() {
			super();
			this.setVariables();
			this.setPositions();
			this.addListeners();			
			this.updateSize();
			this.attachThumbs();			
		}
		
		private function addListeners():void {
			mcRightArrow.addEventListener(MouseEvent.CLICK, rightArrowClickHandler);
			mcLeftArrow.addEventListener(MouseEvent.CLICK, leftArrowClickHandler);			
			this.addEventListener(MouseEvent.MOUSE_MOVE, moveCarousel);
			this.addEventListener(MouseEvent.MOUSE_OUT, stopMoveCarousel);
			this.addEventListener(Event.ENTER_FRAME, thisEnterFrameHandler);
		}
		
		private function removeListeners():void {
			mcRightArrow.removeEventListener(MouseEvent.CLICK, rightArrowClickHandler);
			mcLeftArrow.removeEventListener(MouseEvent.CLICK, leftArrowClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, moveCarousel);
			this.removeEventListener(MouseEvent.MOUSE_OUT, stopMoveCarousel);
			this.removeEventListener(Event.ENTER_FRAME, thisEnterFrameHandler);
		}
		
		private function rightArrowClickHandler($event:MouseEvent):void {
			if (bMoveFlag) {
				return;
			}
			bMoveFlag = true;
			var $oTmp:Object
			for (var i:int = 0; i < aThumbs.length; i++ ) {
				if (i+1 == aThumbs.length) {
					$oTmp = { x:aThumbs[i].x - (nThumbWidth + 30) * 2, onComplete:onFinishMove};
				} else {
					$oTmp = { x:aThumbs[i].x - (nThumbWidth + 30) * 2 };					
				}
				
				TweenLite.to(aThumbs[i] as CarouselThumbnail, 0.8, $oTmp);				
			}			
		}
		
		private function onFinishMove():void {
			bMoveFlag = false;
		}
		
		private function leftArrowClickHandler($event:MouseEvent):void {
			if (bMoveFlag) {
				return;
			}
			bMoveFlag = true;
			var $oTmp:Object
			for (var i:int = 0; i < aThumbs.length; i++ ) {
				if (i+1 == aThumbs.length) {
					$oTmp = { x:aThumbs[i].x + (nThumbWidth + 30) * 2, onComplete:onFinishMove};
				} else {
					$oTmp = { x:aThumbs[i].x + (nThumbWidth + 30) * 2 };					
				}
				
				TweenLite.to(aThumbs[i] as CarouselThumbnail, 0.8, $oTmp);				
			}
		}
		
		private function setVariables():void {
			nMaxWidth = 624;//stage.stageWidth;
			nMaxHeight = 432;//stage.stageHeight;
			nSpeed = 10;
			nMovement = 0;
			paddingRight = 20;
			paddingLeft = 20;
			nSeparation = 15;
			nThumbWidth = 75;
			nThumbHeight = 42;
			nSpace = nThumbWidth + nSeparation;
		}
		
		function setPositions():void {
			mcRightArrow.x = nMaxWidth - 4;
			mcLeftArrow.x = 4;
			mcRightArrow.y = mcLeftArrow.y = 30;
		}
		
		public function updateSize():void {
			mcBackground.width = nMaxWidth;
			mcMask.x = paddingLeft;
			mcMask.width = nMaxWidth - (paddingLeft + paddingRight);
			txtDescription.width = nMaxWidth-20;
			txtDescription.x = 10;
		}
		
		private function attachThumbs():void {
			aThumbs = new Array();
			var $xList:XMLList = new XMLList();
			$xList = dataHolder.xMainXml.related_videos.children();
			
			for (var i:int = 0; i < $xList.length(); i++ ) {
				var oSettings:Object = new Object();
				
				oSettings.sTitle = $xList[i].@title;
				oSettings.sLinkUrl = $xList[i].@link;
				oSettings.sImageUrl = $xList[i].@thumb;
				oSettings.nThumbWidth = this.nThumbWidth;
				oSettings.nThumbHeight = this.nThumbHeight;
				oSettings.owner = this;
				aThumbs[i] = new CarouselThumbnail(oSettings);
				mcThumbContainer.addChild(aThumbs[i]);
				aThumbs[i].x = (nSpace * i) + nSeparation;
				aThumbs[i].addEventListener(MouseEvent.ROLL_OVER, thumbRollOverHandler);
				aThumbs[i].addEventListener(MouseEvent.ROLL_OUT, thumbRollOutHandler);
			}
			nItemsNum = $xList.length();
			nChainWidth = nItemsNum * nSpace;
		}
		
		private function detachThumbs():void {
			for (var i:int = 0; i < dataHolder.xMainXml.related_videos.lenght(); i++ ) {
				
			}
		}
		
		private function moveCarousel($event:MouseEvent):void {
			
			if (this.mouseX >= mcMask.x && this.mouseX-paddingLeft <= mcMask.width && this.mouseY >= mcMask.y && this.mouseY <= mcMask.height) {
				nMovement = int(((this.mouseX - (mcMask.width / 2)) / -(mcMask.width / 2)) * nSpeed);				
			} else {
				nMovement = 0
			}
		}
		
		private function stopMoveCarousel($event:MouseEvent):void {
			nMovement = 0;
		}
		
		private function thumbRollOverHandler($event:MouseEvent):void {			
			txtDescription.text = $event.target.sTitle;
			
			mcThumbContainer.setChildIndex($event.target as CarouselThumbnail, mcThumbContainer.numChildren - 1);
		}
		
		private function thumbRollOutHandler($event:MouseEvent):void {
			txtDescription.text = "";
		}
		
		private function thisEnterFrameHandler($event:Event):void {
			//trace (mcMask.width + "  " + dataHolder.nStageWidth);
			if (bMoveFlag) {
				return;
			}
			for (var i:int = 0; i < aThumbs.length; i++ ) {
				aThumbs[i].x += nMovement;
				if (aThumbs[i].x > nChainWidth - nSpace) {
					aThumbs[i].x -= nChainWidth;
				} else if (aThumbs[i].x < -nThumbWidth) {
					aThumbs[i].x += nChainWidth;
				}
			}
			
			if (this.mouseX >= mcMask.x && this.mouseX-paddingLeft <= mcMask.width && this.mouseY >= mcMask.y && this.mouseY <= mcMask.height) {
				nMovement = int(((this.mouseX - (mcMask.width/ 2)) / -(mcMask.width / 2)) * nSpeed);
			} else {
				nMovement = 0
			}			
			if (nMovement == 0) {
				return;
			}
			
		}
		
	}
	
}