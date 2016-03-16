package com.shurba.wrapper {	
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Game extends Sprite {
		
		[Embed(source='../../assets/alien-hominid.swf')]		
		public var GameClass:Class;
		
		public function Game() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			game = new Game_GameClass();
			this.addChild(game);
		}
		
	}

}