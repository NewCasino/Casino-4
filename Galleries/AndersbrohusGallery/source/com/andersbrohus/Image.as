package com.andersbrohus {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import com.andersbrohus.ImageContainer;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	public class Image extends MovieClip {
		
		public var containerClip:ImageContainer;
		public var lastDepth:int;
		public var lastWidth:int;
		public var lastHeight:int;
		public var lastX:int;
		public var lastY:int;
		public var zoomed:Boolean = false;
		
		public function Image() {
			//this.gotoAndStop(1);			
		}
		
		public function get container():ImageContainer {
			return containerClip;
		}
		
		public function playAnimation():void {
			this.visible = true;
			containerClip.visible = true;
		}
		
		public function savePositions():void {
			this.lastHeight = this.height;
			this.lastWidth = this.width;
			this.lastY = this.y;
			this.lastX = this.x;			
		}
		
		public function enableReactionOnMouse():void {
			if (!this.hasEventListener(Event.ENTER_FRAME)) {
				this.addEventListener(Event.ENTER_FRAME, move, false, 0, true);
			}
		}
		
		public function disableReactionOnMouse():void {
			this.removeEventListener(Event.ENTER_FRAME, move);
		}
		
		private function move(e:Event):void {
			var nXX:Number;
			var nYY:Number;
			
			var toX:Number;
			var toY:Number;
			
			var nDist:Number;
			nXX = this.lastX - mouseX;
			nYY = this.lastY - mouseY;
			toX = this.lastX + (nXX * .07);
			toY = this.lastY + (nYY * .07);			
			nXX = this.x - toX;
			nYY = this.y - toY;
			
			if (Math.abs(nXX) > 2 || Math.abs(nYY) > 2) {
				this.x -= nXX / 10;
				this.y  -= nYY / 10;
			}
		}
	}
	
}