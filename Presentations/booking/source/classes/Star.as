package classes {
	import flash.display.Sprite;
	
	/**
	 * @email mihpavlov@gmail.com
	 * @author Michael Pavlov
	 */
	
	 
	public class Star extends Sprite {
		
		public var mcYellowStar:Sprite;
		public var mcWhiteStar:Sprite;
		private var bgSprite:Sprite;
		
		public function Star() {
			super();
			this.setOff();
			bgSprite = new Sprite;
			this.addChildAt(bgSprite, 0);
			bgSprite.graphics.drawRect(0, 0, 18, 18);
		}
		
		public function setOn():void {
			mcYellowStar.visible = true;
		}
		
		public function setOff():void {
			mcYellowStar.visible = false;
		}
	}
	
}