package classes {
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ImageVO {
		
		public var imageWidth:int;
		public var imageHeight:int;
		public var imageUrl:String;
		public var imageLink:String;
		public var smallText:String;
		public var bigText:String;
		
		public function ImageVO($dataObject:Object = null) {
			if ($dataObject != null) {
				this.parseData($dataObject);
			}
		}
		
		private function parseData($data:Object):void {			
			this.imageUrl = $data.imageUrl;			
			this.imageLink = $data.imageLink;			
			this.imageWidth = $data.imageWidth;
			this.imageHeight = $data.imageHeight;
			this.smallText = $data.smallText;
			this.bigText = $data.bigText;
		}
	}
}