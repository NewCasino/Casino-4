package  {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class BtnBold extends BaseButton	{
		
		[Embed(source='../lib/bold_22.png')]
		private var BtnImage:Class;
		private var image:Bitmap;		
		
		public function BtnBold() {
			super();
			
			image = new BtnImage();
			this.addChild(image);
			this.btnImage = image;
			
		}
	}
}