package com.ui.components {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import gs.TweenLite;
	
	
	public class TooltipBaloon extends Sprite {
		
		public var mcPointer:Sprite;
		public var mcBaloon:Sprite;
		public var txtMessage:TextField;
		
		private var nObjectX:Number;
		private var nObjectY:Number;
		private var nStageWidth:Number;
		
		//private var grid:Rectangle = new Rectangle(20, 20, 60, 60);
		
		public function TooltipBaloon():void {
			this.alpha = 0;
			this.mouseEnabled = false;
			
			//mcBaloon.scale9Grid = grid;
			//mcBaloon(square);
		}
		
		public function show($object:Object):void {
			this.alpha = 0;
			nObjectX = $object.x;
			nObjectY = $object.y;
			nStageWidth = $object.stageWidth;
			this.label = $object.message;
			this.updateSize();
			TweenLite.to(this, 0.5, { alpha:1 } );
		}
		
		public function hide():void {
			TweenLite.killTweensOf(this);
			this.alpha = 0;
		}
		
		private function updateSize():void {
			this.x = nObjectX - 7;
			this.y = 2 - this.height;
			mcBaloon.x = 0;
			txtMessage.x = 0;
			mcBaloon.width = txtMessage.width;
			var nDistance:int = Math.round(this.x + this.width + 15);
			//trace ("TOOLTIP WIDTH:  " + nDistance + "  STAGEWIDTH: " + nStageWidth);
			
			if (nDistance > nStageWidth) {				
				mcBaloon.x = nStageWidth - nDistance;
				txtMessage.x = mcBaloon.x;
			}			
		}
		
		public function set label ($text:String):void {
			txtMessage.text = $text;
			txtMessage.width = txtMessage.textWidth + 16;			
		}
		
		public function get label ():String { 
			return txtMessage.text;
		}
		
	}
}
