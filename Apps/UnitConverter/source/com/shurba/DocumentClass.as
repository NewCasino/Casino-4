package com.shurba {
	import fl.controls.List;
	import fl.data.DataProvider;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class DocumentClass extends Sprite {
		
		public var lstTo:List;
		public var lstFrom:List;
		
		public var txtResult:TextField;
		public var txtQuantity:TextField;
		
		public function DocumentClass() {
			super();
			if (stage)
				this.init();
			else 
				this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.addListeners();
			this.initDataObjects();
		}
		
		private function addListeners():void {
			lstFrom.addEventListener(Event.CHANGE, listChangeHandler, false, 0, true);
			lstTo.addEventListener(Event.CHANGE, listChangeHandler, false, 0, true);
			txtQuantity.addEventListener(Event.CHANGE, listChangeHandler, false, 0, true);
		}
		
		private function listChangeHandler(e:Event):void {
			//trace ((e.currentTarget as List).selectedItem.data);
			if (txtQuantity.text == "" || lstTo.selectedIndex == -1 || lstTo.selectedIndex == -1) {
				return;
			} 
			
			txtResult.text = UnitConverter.convert(txtQuantity.text, lstFrom.selectedItem.data, lstTo.selectedItem.data);
		}
		
		private function initDataObjects():void {
			var dataObject:DataProvider = new DataProvider( [ { label:"inch [international, U.S.", data:"0.0254" },
															{ label:"kilometer", data:"1000" },
															{ label:"mile [Britain, ancient]", data:"1609" } ]);
			
			lstTo.dataProvider = dataObject;
			lstFrom.dataProvider = dataObject;
		}
		
		private function convert():void {
			
		}
	}

}