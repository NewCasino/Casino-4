package classes {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class PrintObject extends Sprite	{
		
		public var company_txt:TextField;
		public var season_txt:TextField;
		public var accessArea_txt:TextField;
		public var userName_txt:TextField;
		public var matchName_txt:TextField;
		public var photo_mc:Sprite;
		
		private var accessBorder:Sprite;		
		private var _season:String;
		private var _userName:String;
		private var _company:String;
		private var _area:String;
		private var _matchName:String;
		private var _photo:Bitmap;
		
		private var _showBorder:Boolean = true;
		
		public function PrintObject() {
			super();			
			accessArea_txt.border = true;
		}
		
		public function get season():String { return _season; }
		
		public function set season(value:String):void 
		{
			_season = value;
			season_txt.text = value;
		}
		
		public function get company():String { return _company; }
		
		public function set company(value:String):void 
		{
			_company = value;
			company_txt.text = value;
		}
		
		public function get area():String { return _area; }
		
		public function set area(value:String):void 
		{
			_area = value;
			accessArea_txt.text = value;
			accessArea_txt.height = accessArea_txt.textHeight + 7;
			accessArea_txt.border = true;
		}
		
		public function get photo():Bitmap { return _photo; }
		
		public function set photo(value:Bitmap):void 
		{
			if (value == null || !(value is Bitmap)) {
				return;
			}
			_photo = value;
			if (photo_mc) {
				while (photo_mc.numChildren) {
					photo_mc.removeChildAt(0);
				}
			}
			
			photo_mc = new Sprite();
			value.smoothing = true;
			photo_mc.addChild(value);
			this.addChild(photo_mc);
			photo_mc.x = 385;
			photo_mc.y = 911;			
			photo_mc.width = 481;
			photo_mc.height = 658;
			photo_mc.graphics.lineStyle(1, 0x000000);
			photo_mc.graphics.moveTo(-1, -1);
			photo_mc.graphics.lineTo(value.width +1, -1);
			photo_mc.graphics.lineTo( value.width +1, value.height +1);
			photo_mc.graphics.lineTo( -1, value.height +1);
			photo_mc.graphics.lineTo( -1, -1);
		}
		
		public function get userName():String { return _userName; }
		
		public function set userName(value:String):void 
		{
			_userName = value;
			userName_txt.text = value;
			this.adjustTextSize(userName_txt);
		}
		
		private function adjustTextSize(txtField:TextField):void {
			while (userName_txt.textWidth > userName_txt.width) {
				var tf:TextFormat = userName_txt.getTextFormat();
				var size:Number = Number(tf.size);
				tf.size = size - 1;
				userName_txt.setTextFormat(tf);
			}
		}
		
		public function get match():String { return _matchName; }
		
		public function set match(value:String):void 
		{
			_matchName = value;
			matchName_txt.text = value;
			this.adjustTextSize(matchName_txt);
		}
		
		public function get showBorder():Boolean { return _showBorder; }
		
		public function set showBorder(value:Boolean):void 
		{
			_showBorder = value;
			this.redrawBorder();
			
			//accessArea_txt.border = value;
		}
		
		private function redrawBorder():void {			
			if (accessBorder == null) {
				accessBorder = new Sprite();
				this.addChild(accessBorder);
			} else {
				accessBorder.graphics.clear();
			}
			
			if (!_showBorder) {
				accessBorder.visible = false;
				return;
			}
			
			accessBorder.graphics.lineStyle(1, 0x000000);
			accessBorder.graphics.moveTo(-1, -1);
			accessBorder.graphics.lineTo(accessArea_txt.width +1, -1);
			accessBorder.graphics.lineTo( accessArea_txt.width +1, accessArea_txt.height +1);
			accessBorder.graphics.lineTo( -1, accessArea_txt.height +1);
			accessBorder.graphics.lineTo( -1, -1);
			accessBorder.x = accessArea_txt.x;
			accessBorder.y = accessArea_txt.y;
		}
		
	}

}