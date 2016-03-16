package com.shurba.CelebGallery.vo {
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class CelebVO {
		
		public var name:String;
		public var bday:String;
		public var imageUrl:String;
		
		public function CelebVO($name:String, $bday:String, $imageUrl:String) {
			name = $name;
			bday = $bday;
			imageUrl = $imageUrl;
		}
		
	}

}