package classes {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[Event("contacts", type = "flash.events.Event")]
	
	public class Menu extends Sprite {
		
		public var btnContacts:Sprite;
		
		public function Menu() {
			btnContacts.buttonMode = true;
			btnContacts.addEventListener(MouseEvent.CLICK, contactsClickHandler);
		}
		
		private function contactsClickHandler(e:MouseEvent):void {
			this.dispatchEvent(new Event("contacts"));
		}
		
	}

}