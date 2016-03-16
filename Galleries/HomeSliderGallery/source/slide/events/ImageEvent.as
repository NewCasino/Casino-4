package slide.events 
{
	import flash.events.Event;
	import slide.Image;
	/**
	 * ...
	 * @author Kam
	 */
	public class ImageEvent extends Event
	{
		public static const IMAGE_LOADED:String = "imageLoaded";
		public static const FADED_IN:String = "fadedIn";
		//public static const MASK_OUT:String = "maskOut";
		public var image:Image;
		
		public function ImageEvent(_type:String, _bubbles:Boolean, _cancelable:Boolean, _image:Image) 
		{
			super(_type, _bubbles, _cancelable);
			image = _image;
		}
		
	}
	
}