package classes {
	import classes.event.ThumbListerEvent;
	import com.onebyonedesign.extras.WindowBlur;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gs.TweenGroup;
	import gs.TweenLite;
	import gs.TweenMax;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	 
	 /**
	 * Dispatched when the user clicks on the item.
     *
     * @eventType classes.event.ThumbListerEvent
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event("itemClick", type = "classes.event.ThumbListerEvent")]
	 
	public class ThumbLister extends Sprite	{
		
		private const NUMBER_OF_THUMBNAILS:int = 5;
		
		public var maskSprite:Sprite;
		public var thumbsContainer:Sprite;
		private var background:Sprite;
		private var dataObject:Object;
		
		public var thumbs:Array = new Array();
		public var currentFirst:int = 0;
		public var lastCurrentFirst:int = 0;
		
		private var imagesCoords:Array = new Array();
		private var currentTween:TweenGroup;
		
		private var back:BluredWindow;
		private var bluredBack:WindowBlur;
		
		public function ThumbLister() {
			super();
			thumbsContainer = new Sprite();
			this.addChild(thumbsContainer);
			maskSprite = new Sprite();
			this.addChild(maskSprite);
		}
		
		public function init($dataObject:Object, $backImage:Sprite):void {
			if ($dataObject == null) {
				return;
			}
			background = $backImage;
			dataObject = $dataObject;
			this.drawMask();
			this.createThumbList();
			this.placeTiles();
			this.addBackground();
		}
		
		private function addBackground():void {
			back = new BluredWindow();			
			back.alpha = Gallery.BACKGROUND_ALPHA;
			back.width = this.width;
			back.height = this.height;			
			this.addChildAt(back, 0);
			bluredBack = new WindowBlur(background, back, Gallery.BACKGROUND_BLUR);
		}
		
		protected function drawMask():void {			
			var maskWidth:int = (dataObject.thumbWidth + dataObject.thumbsGap) * 5;
			var maskHeight:int = dataObject.thumbHeight;
			
			maskSprite.graphics.beginFill(0x000000);
			maskSprite.graphics.moveTo( 0, 0);
			maskSprite.graphics.lineTo( maskWidth, 0);
			maskSprite.graphics.lineTo( maskWidth, maskHeight+1);
			maskSprite.graphics.lineTo( 0, maskHeight+1);
			maskSprite.graphics.lineTo( 0, 0);
			//maskSprite.graphics.drawRect(0, 0, maskWidth, maskHeight);
			maskSprite.graphics.endFill();
			
			thumbsContainer.mask = maskSprite;
		}
		
		public function rotateLeft():void {			
			if (imagesCoords[0] >= 0) {
				return;
			}
			//trace (currentFirst + '  ' + thumbs.length);
			lastCurrentFirst = currentFirst;
			currentFirst--;
			
			var counter:int = 0;
			var aTweens:Array = new Array();
			var fullSpace:Number = dataObject.thumbsGap + dataObject.thumbWidth;
			var alphaAmount:Number = 0;
			
			for (var i:int = 0; i < thumbs.length; i++) {
				if (i >= currentFirst && i < currentFirst + 5) {					
					alphaAmount = 1 - counter * 0.25;
					counter++;
				} else {
					alphaAmount = 1;
				}
				
				imagesCoords[i] += fullSpace;
				var tween = TweenLite.to(thumbs[i], 0.5, { x:imagesCoords[i], alpha:alphaAmount } );
				aTweens.push(tween);
			}
			
			this.setCurrentThumbProperties();
			
			if (currentTween) {				
				currentTween.clear(true);
			}
			
			currentTween = new TweenGroup(aTweens)
			currentTween.align = TweenGroup.ALIGN_START;			
		}
		
		public function rotateRight():void {
			//trace ('right');
			if (thumbs.length <= currentFirst +1) {
				return;
			}
			lastCurrentFirst = currentFirst;
			currentFirst++;
			
			var counter:int = 0;
			var aTweens:Array = new Array();
			var fullSpace:Number = dataObject.thumbsGap + dataObject.thumbWidth;
			var alphaAmount:Number = 0;
			
			for (var i:int = 0; i < thumbs.length; i++) {
				if (i >= currentFirst && i < currentFirst + 5) {					
					alphaAmount = 1 - counter * 0.25;
					counter++;
				} else {
					alphaAmount = 1;
				}
				
				imagesCoords[i] -= fullSpace;
				var tween = TweenLite.to(thumbs[i], 0.5, { x:imagesCoords[i], alpha:alphaAmount } );
				aTweens.push(tween);
			}
			
			this.setCurrentThumbProperties();
			
			if (currentTween) {				
				currentTween.clear(true);
			}
			
			currentTween = new TweenGroup(aTweens)
			currentTween.align = TweenGroup.ALIGN_START;
			
		}
		
		private function setCurrentThumbProperties():void {
			if ( currentFirst != lastCurrentFirst) {
				(thumbs[lastCurrentFirst] as Thumbnail).buttonMode = false;
				(thumbs[lastCurrentFirst] as Thumbnail).borderActive = false;
			}
			(thumbs[currentFirst] as Thumbnail).buttonMode = true;
			(thumbs[currentFirst] as Thumbnail).borderActive = true;
		}
		
		protected function createThumbList():void {
			var newThumb:Thumbnail;
			var imageObjects:Array = (dataObject.imageObjects as Array);
			
			for (var i:int = 0; i < imageObjects.length; i++) {
				newThumb = new Thumbnail();
				newThumb.init(imageObjects[i]);
				newThumb.addEventListener(MouseEvent.CLICK, thumbClickHandler, false, 0, true);
				thumbsContainer.addChild(newThumb);
				thumbs.push(newThumb);
			}
			
			this.setCurrentThumbProperties();
		}
		
		public function fadeIn():void {
			//bluredBack = new WindowBlur(DocumentClass.$stage.mcBackground, back, 30);
			this.mouseEnabled = true;
			thumbsContainer.visible = true;
			thumbsContainer.alpha = 0;
			TweenLite.to(thumbsContainer, 0.5, { alpha:1 } );
		}
		
		public function fadeOut():void {
			//bluredBack.kill();
			thumbsContainer:Sprite;
			this.mouseEnabled = false;
			thumbsContainer.alpha = 1;
			TweenLite.to(thumbsContainer, 0.5, { alpha:0, onComplete:function() { thumbsContainer.visible = false } } );
		}
		
		protected function thumbClickHandler(e:MouseEvent):void {
			if (e.currentTarget == thumbs[currentFirst]) {
				var event:ThumbListerEvent = new ThumbListerEvent(ThumbListerEvent.ITEM_CLICK);
				event.data = (e.currentTarget as Thumbnail).imageVO;
				for (var i:int = 0; i < thumbs.length; i++) {
					if (e.currentTarget == thumbs[i]) {
						event.currentPosition = i;
					}
				}
				this.dispatchEvent(event);
			}
		}
		
		private function placeTiles():void {
			var spaceToNext:int = 0;
			var alphaAmount:Number = 0;
			var tmpThumb:Thumbnail;
			var fullSpace:Number = dataObject.thumbsGap + dataObject.thumbWidth;
			imagesCoords = new Array();
			for (var i:int = 0; i < thumbs.length; i++) {
				tmpThumb = (thumbs[i] as Thumbnail);
				tmpThumb.x = fullSpace * i;
				imagesCoords.push(tmpThumb.x);
				alphaAmount = 1 - (i * 0.25);
				alphaAmount = (alphaAmount > 0)?alphaAmount:0;
				TweenLite.to(tmpThumb, 0, { alpha: alphaAmount } );
			}
		}
		
	}

}