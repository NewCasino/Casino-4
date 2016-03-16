package com.shurba.view {
	import classes.BMPBackground;
	import classes.MainView;
	import com.shurba.data.DataHolder;
	import flash.display.*;
	import flash.display.Sprite;
	import flash.filters.*;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class MainPanel extends MainView {
		
		public var dataHolder:DataHolder = DataHolder.getInstance();
		
		public var background:Bitmap;		
		
		public function MainPanel() {
			super();
			drawInterface();
		}
		
		protected function drawInterface():void {
			var bmData:BMPBackground = new BMPBackground();
			background = new Bitmap(bmData);
			this.addChildAt(background, 0);
			var filters:Array = [new DropShadowFilter(3, 90, 0x000000, 1, 5, 5, 0.60, BitmapFilterQuality.HIGH)];			
			background.filters = filters;
			background.x = 4;
			background.y = 24;
			
			
			chart.dataProvider = dataHolder.barsData;
		}
		
	}

}