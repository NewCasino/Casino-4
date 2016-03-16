package classes {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gs.plugins.GlowFilterPlugin;
	import gs.plugins.TweenPlugin;	
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class RotateButton extends GalleryButton {
		
		public static const ORIENTATION_LEFT:int = 0;
		public static const ORIENTATION_RIGHT:int = 1;
		
		public var rightSymbol:Sprite;
		public var leftSymbol:Sprite;
		public var hitSpace:Sprite;
		
		private var _orientation:int;
		
		public function RotateButton() {
			super();
		}
		
		public function get orientation():int { 
			return _orientation; 
		}
		
		public function set orientation(value:int):void {
			_orientation = value;
			if (value == RotateButton.ORIENTATION_LEFT) {				
				leftSymbol.visible = true;
				rightSymbol.visible = false;
			} else if (value == RotateButton.ORIENTATION_RIGHT) {				
				rightSymbol.visible = true;
				leftSymbol.visible = false;
			}
		}
		
	}

}