package classes {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class PrintMaster extends Sprite {
		
		private var _season:String;
		private var _userName:String;
		private var _company:String;
		private var _area:String;
		private var _matchName:String;
		private var _photo:Bitmap;
		
		public var mcPrint:PrintObject;
		
		public function PrintMaster() {
			//mcPrint = new PrintObject();
		}
		
		/*public function get season():String { return _season; }
		
		public function set season(value:String):void 
		{
			_season = value;
			mcPrint.season.text = value;
		}
		
		public function get company():String { return _company; }
		
		public function set company(value:String):void 
		{
			_company = value;
			mcPrint.company.text = value;
		}
		
		public function get area():String { return _area; }
		
		public function set area(value:String):void 
		{
			_area = value;
			mcPrint.accessArea.text = value;
		}
		
		public function get photo():Bitmap { return _photo; }
		
		public function set photo(value:Bitmap):void 
		{
			_photo = value;
			while (mcPrint.photo.numChildren) {
				mcPrint.photo.removeChildAt(0);
			}
			value.smoothing = true;
			mcPrint.photo.addChild(value);
			mcPrint.photo.width = 481;
			mcPrint.photo.height = 658;
		}
		
		public function get userName():String { return _userName; }
		
		public function set userName(value:String):void 
		{
			_userName = value;
			mcPrint.userName.text = value;
		}
		
		public function get match():String { return _matchName; }
		
		public function set match(value:String):void 
		{
			_matchName = value;
			mcPrint.matchName.text = value;
		}
		
		public function getPrintObject():PrintObject {
			return mcPrint;
		}*/
	}
}