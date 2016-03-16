package com.shurba {	
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.shurba.lobby.Display;
	import com.shurba.lobby.ImageViewer;
	import com.shurba.lobby.ToggleButton;
	import com.shurba.lobby.vo.GameGroupVO;
	import com.shurba.lobby.vo.GameVO;
	import com.shurba.utils.ApplyStandartOptions;
	import com.shurba.utils.xml.XMLLoader;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import com.greensock.easing.*;	
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.*;
	import flash.utils.Timer;
	
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		public const GET_BALANCE_DELAY:int = 1000;
		public const GET_BALANCE_URL:String = "balance.php";
		
		
		private const XML_PATH:String = "games.xml";
		
		public var xmlLoader:XMLLoader;
		
		public var gameGroups:Array = [];
		public var menuButtons:Array = [];
		
		public var gameTiles:Array;
		
		public var currentGroup:int = 0;
		public var currentMenuButton:ToggleButton;
		
		private var tweenTimeline:TimelineLite;
		
		private var tilesToLoad:int;
		
		public var display:Display;
		
		private var balanceLoader:URLLoader;
		
		private var balanceTimer:Timer;
		
		public var maskClip:Sprite;
		
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
			this.mask = maskClip;
			//new ApplyStandartOptions(this);
			
			xmlLoader = new XMLLoader(XML_PATH, xmlLoaded);
			
			balanceTimer = new Timer(GET_BALANCE_DELAY);
			balanceTimer.addEventListener(TimerEvent.TIMER, loadBalance, false, 0, true);
			balanceTimer.start();
		}
		
		private function xmlLoaded($xml:XML):void {
			var xGroups:XMLList = $xml.children();
			gameGroups = [];
			for (var i:int = 0; i < xGroups.length(); i++) {
				var tmpGroup:GameGroupVO = new GameGroupVO();				
				var xGames:XMLList = xGroups[i].children();
				for (var j:int = 0; j < xGames.length(); j++) {
					var tmpGame:GameVO = new GameVO();
					tmpGame.name = xGames[j].@name;
					tmpGame.imagesrc = xGames[j].@imagesrc;
					tmpGame.gameurl = xGames[j].@gameurl;
					tmpGroup.games.push(tmpGame);
				}
				tmpGroup.name = xGroups[i].@name;
				gameGroups.push(tmpGroup);
			}
			
			this.createButtons();
			currentGroup = 0;
			this.showTiles(currentGroup);
			currentMenuButton = menuButtons[currentGroup];
			currentMenuButton.toggled = true;
			
			//display.score.text = "WELCOME  .";
		}
		
		protected function createButtons():void {
			
			//var posY:int = 16;
			
			for (var i:int = 0; i < gameGroups.length; i++) {
				var button:ToggleButton = new ToggleButton();
				this.addChild(button);
				button.x = 590;
				button.y = i * (button.height + 5)+ 16;
				button.label.text = (gameGroups[i] as GameGroupVO).name;
				button.index = i;
				menuButtons.push(button);
				button.addEventListener(MouseEvent.CLICK, menuButtonClickHandler, false, 0, true);
			}
		}
		
		private function menuButtonClickHandler(e:MouseEvent):void {
			currentGroup = (e.currentTarget as ToggleButton).index;
			this.showTiles(currentGroup);
			currentMenuButton.toggled = false;
			currentMenuButton = e.currentTarget as ToggleButton;
			currentMenuButton.toggled = true;
		}
		
		protected function showTiles($group:int = 0):void {
						
			if (gameTiles && gameTiles.length > 0) {
				this.clearTiles();
			}
			
			var group:GameGroupVO = gameGroups[$group];			
			gameTiles = [];
			
			for (var i:int = 0; i < group.games.length; i++) {
				var tile:ImageViewer = new ImageViewer();
				tile.addEventListener(Event.COMPLETE, tileLoadedHandler, false, 0, true);
				tile.addEventListener(MouseEvent.CLICK, tileClickHandler, false, 0, true);
				tile.data = group.games[i] as GameVO;
				tile.source = (group.games[i] as GameVO).imagesrc;
				tile.caption.text = tile.data.name;
				gameTiles.push(tile);
			}
			tilesToLoad = i;
		}
		
		private function tileClickHandler(e:MouseEvent):void {
			var request:URLRequest = new URLRequest((e.currentTarget as ImageViewer).data.gameurl);
			navigateToURL(request, "_self");
		}
		
		private function tileLoadedHandler(e:Event):void {			
			if (tilesToLoad == 1) {
				this.tweenTilesIn();
			} else {
				tilesToLoad--;
			}
		}
		
		protected function tweenTilesIn():void {
			if (tweenTimeline) {
				tweenTimeline.clear();
			}
			
			tweenTimeline = new TimelineLite();
			var tweens:Array = [];
			
			var xPos:Number = 19;
			var yPos:Number = 14;
			var xCounter:Number = 0;
			
			for (var i:int = 0; i < gameTiles.length; i++) {
				var tile:ImageViewer = gameTiles[i]
				this.addChild(tile);
				
				if (xCounter > 3) {
					xCounter = 0;
					xPos = 19;
					yPos += 136;
				}
				tile.x = xPos + 141 * xCounter;
				tile.y = yPos + 500;
				var tween:TweenLite = new TweenLite(tile, 0.5, {y:yPos/*, ease:Bounce.easeOut*/} );
				
				tweens.push(tween);
				xCounter++;
			}
			
			tweenTimeline.insertMultiple(tweens, 0, TweenAlign.START, 0.1);
			tweenTimeline.play();
			
		}
		
		private function clearTiles():void {
			for (var i:int = 0; i < gameTiles.length; i++) {
				this.removeChild(gameTiles[i]);				
			}
		}
		
		private function loadBalance(e:TimerEvent = null):void {
			var oParams:Object = LoaderInfo(root.loaderInfo).parameters;			
			var sendUrl:String
			if (oParams.u != undefined && oParams.u != '') {
				var request:URLRequest = new URLRequest(GET_BALANCE_URL);				
				balanceLoader = new URLLoader();				
				var vars:URLVariables = new URLVariables();
				vars.uid = oParams.u;
				request.data = vars;
				request.method = URLRequestMethod.POST;
				balanceLoader.addEventListener(Event.COMPLETE, balanceLoaded, false, 0, true);				
				balanceLoader.addEventListener(IOErrorEvent.IO_ERROR, balanceLoadError, false, 0, true);				
				balanceLoader.load(request);
			} else {				
				display.score.text = "0.00";
			}
			
		}
		
		private function balanceLoaded(e:Event):void {			
			var re:RegExp = /(?P<prop>[^&=]+)=(?P<val>[^&]*)/g; 
			var result:Object; 
			var response:String = balanceLoader.data; 
			var resultOBJ:Object = { }; 
			do { 
				result = re.exec(response); 
				if (!result) break; 
				resultOBJ[result.prop] = result.val; 
			} 
			while (true); 

			/*for (var p:String in resultOBJ) { 
				trace(p, "=", resultOBJ[p]);
			}*/
			
			/*trace (resultOBJ.ans);
			trace (resultOBJ.amount);*/
			
			if (resultOBJ.ans == "OK") { 
				display.score.text = resultOBJ.amount;				
			} else {
				display.score.text = "0.00";
			}
		}
		
		private function balanceLoadError(e:IOErrorEvent):void {			
			display.score.text = "ERROR IO";
		}
		
	}

}