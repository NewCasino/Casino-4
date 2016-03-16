package  {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class BtnItalic extends BaseButton	{
		
		[Embed(source='../lib/italic_22.png')]
		private var BtnImage:Class;
		private var image:Bitmap;		
		
		public function BtnItalic() {
			super();
			
			image = new BtnImage();
			this.addChild(image);
			this.btnImage = image;
			
		}
	}
}