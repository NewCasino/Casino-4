package com.shurba.CelebGallery {
	import com.greensock.TimelineLite;	
	import com.greensock.TweenLite;
	import com.shurba.events.ImageViewerEvent;
	import com.shurba.CelebGallery.view.Tile;
	import com.shurba.CelebGallery.vo.CelebVO;
	import com.shurba.utils.xml.XMLLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	public class Main extends Sprite {
		
		private const XML_PATH:String = 'data.xml';
		private const TILES_NUM:int = 2;
		private const TIMER_DELAY:int = 3000;
		private const FADE_DELAY:Number= 0.3;
		
		private const MAX_WIDTH:int= 106;
		private const MAX_HEIGHT:int= 115;
		
		private var xmlLoader:XMLLoader;
		
		public var celebsData:Array;
		public var tiles:Array;
		
		protected var tilesLoadedCounter:int;
		protected var counter:int;
		
		private var timer:Timer;
		private var timeline:TimelineLite;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			xmlLoader = new XMLLoader(XML_PATH, parseXML);
			counter = -TILES_NUM;
			timer = new Timer(TIMER_DELAY);
			timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
		}
		
		private function timerHandler(e:TimerEvent):void {			
			timer.stop();
			this.hideTiles();
		}
		
		private function parseXML($xml:XML):void {
			var xList:XMLList = new XMLList();
			xList =  $xml.children();
			
			celebsData = [];
			
			for (var i:int = 0; i < xList.length(); i++) {				
				var tmpCeleb:CelebVO = new CelebVO(xList[i].@name, xList[i].@bday, xList[i].@image);
				celebsData.push(tmpCeleb);
			}
			
			this.createTiles();
			this.loadNextTiles();
		}
		
		protected function createTiles():void {
			tiles = [];
			var tmpTile:Tile;
			for (var i:int = 0; i < TILES_NUM; i++) {
				tmpTile = new Tile(MAX_WIDTH, MAX_HEIGHT);
				this.addChild(tmpTile);
				tmpTile.addEventListener(ImageViewerEvent.IMAGE_LOAD_COMPLETE, tileLoadedHandler, false, 0 , true);
				tmpTile.addEventListener(ImageViewerEvent.IMAGE_LOAD_ERROR, tileLoadErrorHandler, false, 0 , true);
				tiles.push(tmpTile);				
			}
			
		}
		
		private function tileLoadErrorHandler(e:ImageViewerEvent):void {
			this.loadNextTiles();
		}
		
		private function tileLoadedHandler(e:ImageViewerEvent):void {
			tilesLoadedCounter++;
			if (tilesLoadedCounter == TILES_NUM) {
				this.placeTiles();
				this.showTiles();
			}
		}
		
		private function showTiles():void {
			var tmpTile:Tile;
			if (timeline) {
				timeline.kill();
			}
			timeline = new TimelineLite();
			
			var timeline:TimelineLite = new TimelineLite();
			for (var i:int = 0; i < tiles.length; i++) {
				tmpTile = tiles[i] as Tile;
				timeline.append( new TweenLite(tmpTile, FADE_DELAY, {alpha:1}) );
			}
			timeline.vars.onComplete = this.startTimer;
			timeline.play();
		}
		
		private function startTimer():void {
			timer.reset();
			timer.start();
		}
		
		private function hideTiles():void{
			var tmpTile:Tile;
			if (timeline) {
				timeline.kill();
			}
			
			timeline = new TimelineLite();
			
			for (var i:int = 0; i < tiles.length; i++) {
				tmpTile = tiles[i] as Tile;
				timeline.append( new TweenLite(tmpTile, FADE_DELAY, {alpha:0}) );
			}
			
			timeline.vars.onComplete = this.loadNextTiles;
			timeline.play();
		}
		
		protected function loadNextTiles():void {			
			tilesLoadedCounter = 0;
			var tmpTile:Tile;
			counter += TILES_NUM
			trace (counter+" "+celebsData.length);
			if (counter >= celebsData.length) {
				counter = 0;
			}
			
			for (var i:int = 0; i < tiles.length; i++) {
				tmpTile = tiles[i] as Tile;
				tmpTile.alpha = 0;
				tmpTile.source = (celebsData[counter + i] as CelebVO).imageUrl;
				tmpTile.nameText = (celebsData[counter + i] as CelebVO).name.toUpperCase();
				tmpTile.bdayText = (celebsData[counter + i] as CelebVO).bday;
			}
		}
		
		protected function placeTiles():void {
			var tmpTile:Tile;
			for (var i:int = 0; i < tiles.length; i++) {
				tmpTile = tiles[i] as Tile;
				tmpTile.x = (tmpTile.width + 5) * i + 2;
				tmpTile.y = 5;
			}
		}
		
	}
}