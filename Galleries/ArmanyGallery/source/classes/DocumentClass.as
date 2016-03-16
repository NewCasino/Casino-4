package classes {
	import com.onebyonedesign.extras.WindowBlur;
	import flash.display.Sprite;	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;	
	import flash.net.URLRequest;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite	{
		
		public static var $stage:DocumentClass;
		
		public var mcBackground:Sprite;
		//public var leftBack:Sprite;
		
		private static const XML_URL:String = 'gallery.xml';
		private var gallery:Gallery;
		
		private var leftBlurBack:WindowBlur;
		
		public function DocumentClass() {
			$stage = this;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			gallery = new Gallery();			
			this.addChild(gallery);
			gallery.xmlPath = XML_URL;
			
			//leftBlurBack = new WindowBlur(mcBackground, leftBack, 20);
		}
	}

}