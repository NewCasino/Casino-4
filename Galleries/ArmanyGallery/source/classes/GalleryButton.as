package classes {
	import flash.display.Sprite;	
	import flash.events.MouseEvent;
	import gs.plugins.GlowFilterPlugin;
	import gs.plugins.TweenPlugin;	
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class GalleryButton extends Sprite {
		
		public function GalleryButton() {
			super();
			this.buttonMode = true;
			this.addListeners();
		}
		
		private function addListeners():void {
			this.addEventListener(MouseEvent.MOUSE_OVER, buttonOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, buttonOutHandler, false, 0, true);
		}
		
		private function buttonOutHandler(e:MouseEvent):void {			
			TweenPlugin.activate([GlowFilterPlugin]);
			TweenLite.to(this, 0.5, {glowFilter:{color:0x000000, blurX:5, blurY:5, strength:1, strength:1, alpha:0}});
		}
		
		private function buttonOverHandler(e:MouseEvent):void {
			TweenPlugin.activate([GlowFilterPlugin]);
			TweenLite.to(this, 0.25, {glowFilter:{color:0xffffff, blurX:5, blurY:5, strength:1, strength:1, alpha:1}});
		}
		
	}

}