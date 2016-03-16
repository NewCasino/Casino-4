package classes.event {
	import classes.ImageVO;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ThumbListerEvent extends Event	{
		
		public static var ITEM_CLICK:String = "itemClick";
		
		public var data:ImageVO;
		public var currentPosition:int;
		
		public function ThumbListerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);			
		}
		
		override public function clone():Event {
			return new ThumbListerEvent(type, bubbles, cancelable);
		}
		
	}

}