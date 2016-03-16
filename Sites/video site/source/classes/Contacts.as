package classes {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class Contacts extends Sprite {
		
		public var btnClose:Sprite;
		
		public function Contacts() {
			this.visible = false;
			btnClose.addEventListener(MouseEvent.CLICK, closeClickHandler);
			btnClose.buttonMode = true;
		}
		
		private function closeClickHandler(e:MouseEvent):void {
			this.hide();
		}
		
		public function show():void {
			this.visible = true;
			this.alpha = 0;
			TweenLite.to(this, 0.5, { alpha:1 } );
		}
		
		
		
		public function hide():void {			
			TweenLite.to(this, 0.5, { alpha:0, onComplete:function() { this.visible = false } } );
		}
		
	}

}