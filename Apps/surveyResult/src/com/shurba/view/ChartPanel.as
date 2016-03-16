package com.shurba.view {
	import classes.Chart;
	import classes.HintButton;
	import com.shurba.data.BarVO;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ChartPanel extends Chart {
		
		private var _dataProvider:Vector.<BarVO>;
		public var bars:Vector.<Bar>;
		public var hintButtons:Vector.<HintButton>;
		
		public function ChartPanel() {
			super();
			
		}
		
		protected function addBars():void {
			if (bars && bars.length > 0) removeBars();
			bars = new Vector.<Bar>();
			var tmpBar:Bar;
			for (var i:int = 0; i < _dataProvider.length; i++) {
				tmpBar = new Bar();
				addChild(tmpBar);
				tmpBar.x = 0;
				tmpBar.y = i * tmpBar.height + 28;
				tmpBar.dataProvider = _dataProvider[i];
				bars.push(tmpBar);
			}
		}
		
		protected function addHintButtons():void {
			if (hintButtons && hintButtons.length > 0) removeHintButtons();
			var tmpHintButton:HintButton;
			hintButtons = new Vector.<HintButton>();
			for (var i:int = 0; i < _dataProvider.length; i++) {
				tmpHintButton = new HintButton();
				addChild(tmpHintButton);
				tmpHintButton.x = 180;
				tmpHintButton.y = i * bars[0].height + 31;
				tmpHintButton.addEventListener(MouseEvent.CLICK, showHint, false, 0, true);
				hintButtons.push(tmpHintButton);
			}
		}
		
		public function showHint(e:MouseEvent):void {
			
		}
		
		private function removeHintButtons():void{
			for (var i:int = 0; i < hintButtons.length; i++) {
				removeChild(hintButtons[i]);
				delete hintButtons[i];
			}
		}
		
		private function removeBars():void{
			for (var i:int = 0; i < bars.length; i++) {
				removeChild(bars[i]);
				delete bars[i];
			}
		}
		
		public function get dataProvider():Vector.<BarVO> { return _dataProvider; }
		
		public function set dataProvider(value:Vector.<BarVO>):void {
			_dataProvider = value;
			addBars();
			addHintButtons();
		}
		
	}

}