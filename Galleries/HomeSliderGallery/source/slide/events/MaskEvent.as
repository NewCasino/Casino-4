package slide.events 
{
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author Kam
	 */
	public class MaskEvent extends Event
	{
		public static const GRID_SHRINKED:String = "gridShrinked";
		public static const MASK_OUT:String = "maskOut";
		
		//public var image:Image;
		
		//public function ImageEvent(_type:String, _bubbles:Boolean, _cancelable:Boolean, _image:Image) 
		public function MaskEvent(_type:String, _bubbles:Boolean, _cancelable:Boolean) 
		{
			super(_type, _bubbles, _cancelable);
			//image = _image;
		}
		
	}
	
}