package classes {
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class PreloaderAnimationBlack extends Sprite {
		
		public var totalBytes:int;
		public var loadedText:TextField;

		
		public function PreloaderAnimationBlack() {
			super();
		}
		
		public function set bytesLoaded($bytesLoaded:int):void {
			var textToShow:String = 'Загрузка ' + (Math.round(($bytesLoaded/totalBytes)*100)).toString()+'%';
			loadedText.text = textToShow;
		}
				
	}
	
}