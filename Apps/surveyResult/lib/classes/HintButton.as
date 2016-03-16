package classes {
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class HintButton extends SimpleButton{
		
		public function HintButton(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) {
			super(upState, overState, downState, hitTestState);
			
		}
		
	}

}