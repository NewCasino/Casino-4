package com.shurba {	
	import flash.display.MovieClip;
	import flash.utils.*;
	import com.greensock.TweenLite;
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.xml.XMLLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
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
	public class DocumentClass extends MovieClip {
		
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
		
		public var logo:Bitmap;
		
		public function DocumentClass() {
			super();
			this.init();
		}
		
		private function init(e:Event = null):void {
			new ApplyStandartOptions(this);
			this.loadLogo();
		}
		
		private function loadLogo():void {
			logo = new DocumentClass_Logo();
			logo.smoothing = true;
			this.addChild(logo);
			logo.width = 640;
			logo.width = 480;
			logoTimer = new Timer(3000);
			logoTimer.addEventListener(TimerEvent.TIMER, logoTimerHandler, false, 0, true);
			logoTimer.start();
		}
		
		private function logoTimerHandler(e:TimerEvent):void {			
			logoTimer.removeEventListener(TimerEvent.TIMER, logoTimerHandler);
			logoTimer = null;
			this.showGame();
		}
		
		private function killLogo():void {
			this.removeChild(logo);
			logo = null;
		}
		
		private function showGame():void {			
			var mainClass:Class = getDefinitionByName("com.shurba.wrapper.Game") as Class;
			addChild(new mainClass() as DisplayObject);
			TweenLite.to(logoLoader, 0.5, { alpha:0, onComplete:killLogo} );
		}
		
	}

}