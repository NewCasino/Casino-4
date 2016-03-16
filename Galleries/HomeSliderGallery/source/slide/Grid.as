package slide
{
	import slide.events.MaskEvent;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author Kam
	 */
	public class Grid extends Sprite
	{
		private var __gridWidth:Number;
		private var __gridHeight:Number;
		private var __shrinkInterval:Number;
		private var __shrinked:Boolean;
		private var __shrinking:Boolean;
		
		private var __rowId:Number;
		private var __colId:Number;
		
		private var __shrinkTimer:Timer;
		
		public function set rowId(_rowId:Number):void
		{
			__rowId = _rowId;
		}
		public function get rowId():Number
		{
			return __rowId;
		}
		
		public function set colId(_colId:Number):void
		{
			__colId = _colId;
		}
		public function get colId():Number
		{
			return __colId;
		}
		
		public function set gridWidth(_width:Number):void
		{
			__gridWidth = _width;
		}
		public function get gridWidth():Number
		{
			return __gridWidth;
		}
		
		public function set gridHeight(_height:Number):void
		{
			__gridHeight = _height;
		}
		public function get gridHeight():Number
		{
			return __gridHeight;
		}
		
		public function set shrinkInterval(_shrinkInterval:Number):void
		{
			__shrinkInterval = _shrinkInterval;
			if (__shrinkTimer) __shrinkTimer.delay = __shrinkInterval;
		}
		public function get shrinkInterval():Number
		{
			return __shrinkInterval;
		}
		
		public function set shrinked(_shrinked:Boolean):void
		{
			__shrinked = _shrinked;
		}
		public function get shrinked():Boolean
		{
			return __shrinked;
		}
		
		public function set shrinking(_shrinking:Boolean):void
		{
			__shrinking = _shrinking;
		}
		public function get shrinking():Boolean
		{
			return __shrinking;
		}
		
		public function Grid(_width:Number,_height:Number) 
		{
			graphics.beginFill(0xFF0000, 1);
			graphics.drawRect( -_width/2, -height/2, _width, _height);
			
			shrinkInterval = 20;
			__shrinkTimer = new Timer(shrinkInterval);
			__shrinkTimer.repeatCount = 0;
			shrinked = false;
			shrinking = false;
		}
		
		private function onShrinking(e:TimerEvent):void
		{
			scaleX *= .8;
			scaleY *= .8;
			if (width < .5 && height < .5)
			{
				__shrinkTimer.stop();
				__shrinkTimer.removeEventListener(TimerEvent.TIMER, onShrinking);
				//parent.removeChild(this);
				shrinked = true;
				dispatchEvent(new MaskEvent(MaskEvent.GRID_SHRINKED, true, false));
				visible = false;
				shrinking = false;
			}
		}
		
		public function shrink():void
		{			
			if (!shrinking)
			{
				__shrinkTimer.addEventListener(TimerEvent.TIMER, onShrinking);
				__shrinkTimer.start();
				shrinking = true;
			}			
		}
		
		public function reset():void
		{
			visible = true;
			scaleX = 1;
			scaleY = 1;
			shrinked = false;
			shrinking = false;
		}
	}
	
}