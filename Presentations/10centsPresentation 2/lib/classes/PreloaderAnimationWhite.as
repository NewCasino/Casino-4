package classes {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class PreloaderAnimationWhite extends MovieClip {
		
		public var totalBytes:int;
		public var loadedText:TextField;

		
		public function PreloaderAnimationWhite() {
			super();
		}
		
		public function set bytesLoaded($bytesLoaded:int):void {
			var textToShow:String = 'Загрузка ' + (Math.round(($bytesLoaded/totalBytes)*100)).toString()+'%';
			loadedText.text = textToShow;
		}
				
	}
	
}