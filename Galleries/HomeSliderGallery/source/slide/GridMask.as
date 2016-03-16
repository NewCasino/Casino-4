package slide
{
	import flash.display.Sprite;
	import flash.utils.Timer;	
	import flash.events.TimerEvent;
	import slide.events.MaskEvent;
	
	/**
	 * ...
	 * @author Kam
	 */
	public class GridMask extends Sprite
	{
		private var _maskWidth:Number;		
		private var _maskHeight:Number;
		private var _gridSize:Number;
		private var _stepInterval:Number;
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		
		private var _gridsArray:Array;		
		private var _stepTimer:Timer;
		
		private var _rowCount:int = 0;
		private var _colCount:int = 0;
		private var _stepCount:int = 0;
		private var _transitionType:int = 0;
		
		public function set maskWidth(__width:Number):void
		{
			_maskWidth = __width;
		}
		public function get maskWidth():Number
		{
			return _maskWidth;
		}
		
		public function set maskHeight(__height:Number):void
		{
			_maskHeight = __height;
		}
		public function get maskHeight():Number
		{
			return _maskHeight;
		}
		
		public function set gridSize(__gridSize:Number):void
		{
			_gridSize = __gridSize;
		}
		public function get gridSize():Number
		{
			return _gridSize;
		}
		
		public function set offsetX(__offsetX:Number):void
		{
			_offsetX = __offsetX;
		}
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function set offsetY(__offsetY:Number):void
		{
			_offsetY = __offsetY;
		}
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		public function set stepInterval(__stepInterval:Number):void
		{
			_stepInterval = __stepInterval;
			if (_stepTimer) _stepTimer.delay = __stepInterval;
		}
		public function get stepInterval():Number
		{
			return _stepInterval;
		}
		
		public function GridMask(__width:Number, __height:Number, __gridSize:Number, __offsetX:Number, __offsetY:Number) 
		{
			maskWidth = __width;
			offsetX = __offsetX;
			offsetY = __offsetY;
			maskHeight = __height;
			gridSize = __gridSize;
			
			_colCount =1+ int(maskWidth / gridSize) + (((maskWidth % gridSize) > 0) ? 1 : 0);
			_rowCount =1+ int(maskHeight / gridSize) + (((maskHeight % gridSize) > 0) ? 1 : 0);
			_gridsArray = new Array();
			for (var i:int = 0; i < _colCount * _rowCount; i++ )
			{
				var newGrid:Grid = new Grid(gridSize, gridSize);
				newGrid.rowId = int(i / _rowCount);
				newGrid.colId = i % _rowCount;
				newGrid.x = newGrid.rowId * gridSize;
				newGrid.y = newGrid.colId * gridSize;
				
				addChild(newGrid);
				_gridsArray.push(newGrid);
				
			}
			stepInterval = 10;
			_stepTimer = new Timer(stepInterval, 0);
			_stepTimer.addEventListener(TimerEvent.TIMER, onStep);
			addEventListener(MaskEvent.GRID_SHRINKED, onGridShrinked);
		}
		
		private function onGridShrinked(e:MaskEvent):void
		{
			var allShrinked:Boolean = true;
			for each(var grid:Grid in _gridsArray)
			{
				if (grid.shrinked == false)
				{
					allShrinked = false;
					break;
				}
			}
			if (allShrinked)
			{
				dispatchEvent(new MaskEvent(MaskEvent.MASK_OUT, true, false));
				_stepTimer.stop();
				//trace("mask out");
			}
		}
		
		private function onStep(e:TimerEvent):void
		{				
		
			if (_transitionType < 100)
			{
				for each(var grid:Grid in _gridsArray)
				{
					if (!grid.shrinked && !grid.shrinking) grid.shrink();
				}
			}			
			else if(_transitionType >= 100 && _transitionType < 500)
			{
				for each(grid in _gridsArray)
				{
					if (!grid.shrinked && !grid.shrinking && grid.rowId + grid.colId == _stepCount) grid.shrink();
				}
				_stepCount++;
				if(_stepCount > _colCount + _rowCount - 2) _stepTimer.stop();
			}
		}
		
		public function stopMask():void
		{
			_stepTimer.stop();
		}
		
		public function playMask():void
		{
			for each(var grid:Grid in _gridsArray)
			{
				grid.reset();
			}
			_stepCount = 0;
			_stepTimer.start();
			
			//five types of transition.
			_transitionType = int(Math.random() * 500);			
			if(_transitionType >= 100 && _transitionType < 200)
			{
				//top_left to bottom_right
				scaleX = 1;
				scaleY = 1;
				x = offsetX;
				y = offsetY;
			}
			else if(_transitionType >= 200 && _transitionType < 300)
			{
				//bottom_right to top_left
				scaleX = -1;
				scaleY = -1;
				x = maskWidth + offsetX;
				y = maskHeight + offsetY;
			}
			else if(_transitionType >= 300 && _transitionType < 400)
			{
				//top_right to bottom_left
				scaleX = -1;				
				x = maskWidth + offsetX;
			}
			else if (_transitionType >= 400 && _transitionType < 500)
			{
				//bottom_left to top_right
				scaleY = -1;
				y = maskHeight + offsetY;				
			}
		}
	}
	
}