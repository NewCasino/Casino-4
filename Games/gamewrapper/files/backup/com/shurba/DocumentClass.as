package com.shurba {	
	import com.greensock.TweenLite;
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.xml.XMLLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		private const XML_PATH:String = "config.xml";		
		public var xmlLoader:XMLLoader;
		
		public var gamePath:String;
		public var logoPath:String;
		public var logoDuration:Number;
		
		public var logoTimer:Timer;
		public var logoLoader:Loader;
		public var gameLoader:Loader = new Loader();
		
		public var gameWidth:Number;
		public var gameHeight:Number;
		
		public var gameMask:Shape;
		
		private var logoBitmap:Boolean = true;
		private var gameLoaded:Boolean = false;
		
		[Embed(source='../../assets/30n7k3n.jpg')]
		public var Logo:Class;
		
		[Embed(source='../../assets/alien-hominid.swf')]		
		public var Game:Class;
		
		
		public function DocumentClass() {
			super();
			
			if (stage) {
				this.init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
			
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);			
			new ApplyStandartOptions(this);			
			xmlLoader = new XMLLoader(XML_PATH, xmlLoaded);
			
		}
		
		private function detectLogoBitmap():void {
			if (logoPath.indexOf(".swf") || logoPath.indexOf(".SWF")) {
				logoBitmap = false;
			}
		}
		
		private function xmlLoaded($xml:XML):void {
			var xList:XMLList = $xml.children();
			logoPath = $xml.adv.@src.toString();
			gamePath = $xml.game.@src.toString();
			logoDuration = Number($xml.adv.@duration);
			gameWidth = Number($xml.game.@width);
			gameHeight = Number($xml.game.@height);
			
			//this.detectLogoBitmap();
			this.loadLogo();
			this.drawGameMask();
		}
		
		private function loadLogo():void {
			logoLoader = new Loader();
			logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoLoadCompleteHandler, false, 0, true);
			logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, logoLoadErrorHandler, false, 0, true);
			
			var request:URLRequest = new URLRequest(logoPath);
			logoLoader.load(request);
		}
		
		private function logoLoadErrorHandler(e:IOErrorEvent):void {
			
		}
		
		private function logoLoadCompleteHandler(e:Event):void {			
			logoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, logoLoadCompleteHandler);
			logoLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, logoLoadErrorHandler);
			
			if (logoLoader.contentLoaderInfo.content is Bitmap) {
				(logoLoader.contentLoaderInfo.content as Bitmap).smoothing = true;
			}
			
			this.addChild(logoLoader);
			
			logoLoader.width = gameWidth;
			logoLoader.height = gameHeight;
			
			logoTimer = new Timer(logoDuration * 1000);
			logoTimer.addEventListener(TimerEvent.TIMER, logoTimerHandler, false, 0, true);
			logoTimer.start();
			//this.loadGame();
		}
		
		private function logoTimerHandler(e:TimerEvent):void {			
			logoTimer.removeEventListener(TimerEvent.TIMER, logoTimerHandler);
			logoTimer = null;
			this.showGame();
			
		}
		
		private function killLogo():void {
			this.removeChild(logoLoader);
			logoLoader = null;
		}
		
		private function drawGameMask():void {
			gameMask = new Shape();
			gameMask.graphics.beginFill(0x000000, 1);			
			gameMask.graphics.drawRect(0, 0, gameWidth, gameHeight);
			gameMask.graphics.endFill();
			this.addChild(gameMask);			
			gameLoader.mask = gameMask;
		}
		
		private function loadGame():void {
			//var buyteArray:ByteArray = new ByteArray();
			//buyteArray.
			gameLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, gameLoadCompleteHandler, false, 0, true);
			gameLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, gameLoadErrorHandler, false, 0, true);
			
			var request:URLRequest = new URLRequest(gamePath);
			gameLoader.load(request);			
		}
		
		private function gameLoadErrorHandler(e:IOErrorEvent):void {
			
		}
		
		private function showGame():void {			
			var game:DocumentClass_Game = new DocumentClass_Game();
			this.addChildAt(game, 0);
			TweenLite.to(logoLoader, 0.5, { alpha:0, onComplete:killLogo} );
		}
		
		private function gameLoadCompleteHandler(e:Event):void {
			this.showGame();
			gameLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, gameLoadCompleteHandler);
			gameLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, gameLoadErrorHandler);
		}
		
	}

}