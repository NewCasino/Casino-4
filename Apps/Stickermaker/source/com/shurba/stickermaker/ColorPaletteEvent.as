package com.shurba.stickermaker {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ColorPaletteEvent extends Event {
		
		public static const PREVIEW_COLOR:String = "previewColor";
		public static const SELECT_COLOR:String = "selectColor";
		
		public function ColorPaletteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);			
		} 
		
		public override function clone():Event { 
			return new ColorPaletteEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ColorPaletteEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}