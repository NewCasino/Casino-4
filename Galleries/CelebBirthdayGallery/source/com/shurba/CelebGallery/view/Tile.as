package com.shurba.CelebGallery.view {
	import com.shurba.media.ImageViewer;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Tile extends ImageViewer {
		
		public var txtName:TextField;
		public var txtBday:TextField;
		
		private var _name:String;
		private var _bday:String;
		
		public function Tile($_imageWidth:Number = 0, $_imageHeight:Number = 0) {
			super($_imageWidth, $_imageHeight);
		}
		
		public function get nameText():String { 
			return txtName.text; 
		}
		
		public function set nameText(value:String):void {
			txtName.text = value;
		}
		
		public function get bdayText():String {
			return txtBday.text; 
		}
		
		public function set bdayText(value:String):void {
			txtBday.text = value;
		}
		
		override public function fadeIn():void {
			this.visible = true;
			this.alpha = 1;
		}
		
		override public function fadeOut():void {
			this.visible = false;
			
		}
		
	}

}