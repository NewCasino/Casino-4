package {
	import com.andersbrohus.Gallery;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	public class  DocumentClass	extends Sprite {
		
		private var galleryXmlPath:String = "gallery.xml";
		private var gallery:Gallery;
		
		public function DocumentClass() {
			var oParams:Object = LoaderInfo(stage.loaderInfo).parameters;
			if (oParams && oParams.hasOwnProperty(galleryXmlPath) && oParams.galleryXmlPath != "") {
				galleryXmlPath = oParams.galleryXmlPath;
			}
			gallery = new Gallery();
			this.addChild(gallery);
			gallery.x = 0;
			gallery.y = 0;
			gallery.init(galleryXmlPath);
			
		}
	}
	
}