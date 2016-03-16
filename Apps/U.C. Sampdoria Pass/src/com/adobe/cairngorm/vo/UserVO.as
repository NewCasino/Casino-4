package com.adobe.cairngorm.vo {
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	public class UserVO implements IValueObject	{
		
		public var name:String;
		public var lastname:String;
		public var borndate:Date
		public var companyID:int;
		public var deleted:int;
		public var image:Bitmap;
		public var imageBytes:ByteArray;
		
		
		public function UserVO($data:Object = null) {
			if ($data != null) {
				fill($data);
			}
		}
		
		private function fill($data:Object):void {
			this.name = $data.name;
			this.lastname = $data.lastname;
			this.borndate = $data.borndate;
			this.companyID = $data.company_id;
			this.deleted = $data.deleted;
			this.imageBytes = $data.image;
		}
	}
}