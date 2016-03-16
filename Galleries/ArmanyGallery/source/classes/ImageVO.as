package classes {
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class ImageVO {
		
		public var thumbUrl:String;
		public var thumbWidth:int;
		public var thumbHeight:int;
		public var imageUrl:String;
		public var imageText:String;
		public var thumbBorder:Boolean;
		public var thumbBorderColor:int
		public var thumbBorderRollOverColor:int
		
		public function ImageVO($dataObject:Object = null) {
			if ($dataObject != null) {
				this.parseData($dataObject);
			}
		}
		
		private function parseData($data:Object):void {
			this.thumbBorder = $data.thumbBorder;
			this.thumbBorderColor = $data.thumbBorderColor;
			this.thumbBorderRollOverColor = $data.thumbBorderRollOverColor;			
			this.imageUrl = $data.imageUrl;
			this.thumbUrl = $data.thumbUrl;
			this.thumbWidth = $data.thumbWidth;
			this.thumbHeight = $data.thumbHeight
			this.imageText = $data.imageText
			
		}
		
	}

}