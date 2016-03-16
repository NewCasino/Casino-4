package com.shurba.shopsite.view.component {
	import com.shurba.shopsite.ApplicationFacade;
	import com.shurba.shopsite.view.component.sounds.MenuButtonSound;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	public class MenuButton extends MovieClip {
		
		public var colorLine:MovieClip;
		public var colorGlow:MovieClip;
		public var area:Sprite;
		
		public var label1:ButtonLabel;
		public var label2:ButtonLabel;
		
		public var linkNumber:int;
		private var _itemNumber:int;		
		private var _itemLabel:String;
		
		private var overSound:MenuButtonSound = new MenuButtonSound();
		
		private var facade:ApplicationFacade = ApplicationFacade.getInstance();
		
		public function MenuButton() {
			super();
			this.init();
		}
		
		private function init():void {
			//colorGlow.mouseEnabled = false;
			this.mouseChildren = false;
			this.hitArea = area
			this.buttonMode = true;			
			this.addListeners();
		}
		
		private function addListeners():void {			
			this.addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
		}
		
		private function mouseOutHandler(e:MouseEvent):void {
			if (facade.currentLink == this.linkNumber) {
				return;
			}
			this.gotoAndPlay("s2");
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			if (facade.currentLink == this.linkNumber) {
				return;
			}
			this.gotoAndPlay("s1");
			overSound.play();
		}
		
		public function get itemNumber():int { 
			return _itemNumber; 
		}
		
		public function set itemNumber(value:int):void {
			_itemNumber = value;
			colorGlow.gotoAndStop(_itemNumber);
			colorLine.gotoAndStop(_itemNumber);
		}
		
		public function get itemLabel():String { 
			return _itemLabel; 
		}
		
		public function set itemLabel(value:String):void {
			_itemLabel = value;
			label1.label = _itemLabel;
			label2.label = _itemLabel;
		}
		
		public function setActive():void {
			this.gotoAndPlay("s1");
		}
		
		public function setNonactive():void {
			this.gotoAndPlay("s2");
		}
			
	}

}