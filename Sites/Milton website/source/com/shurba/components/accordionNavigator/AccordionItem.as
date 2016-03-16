package com.shurba.components.accordionNavigator{
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Michael Pavlov
	 */
	
	[Event (name="buttonClick", type="com.shurba.components.accordionNavigator.AccordionComponentEvent")]
	[Event (name="resizeStart", type="com.shurba.components.accordionNavigator.AccordionItemResizeEvent")]
	[Event (name="resizeComplete", type="com.shurba.components.accordionNavigator.AccordionItemResizeEvent")]
	[Event (name="resizeProgress", type="com.shurba.components.accordionNavigator.AccordionItemResizeEvent")]
	 
	public class AccordionItem extends Sprite {
		
		protected const EXPANDED_WIDTH:int = 297;		
		protected const COLAPSED_WIDTH:int = 300;		
		protected const BACK_ROUND_RADIUS:int = 5;
		protected const TWEEN_DELAY:Number = 0.5;
		protected const BUTTON_CONTENT_GAP:int = 10;
		protected const CONTENT_PADDING:int = 10;
		
		protected var expandedHeight:int = 300;
		protected var colapsedHeight:int = 26;
		
		public var button:MenuButton;
		public var contentMask:Shape;
		public var background:Shape;
		public var content:Sprite;
		
		public var number:int = -1;
		
		public var expanded:Boolean = false;
		
		public function AccordionItem() {
			super();
			this.init();
		}
		
		protected function init():void {
			this.addBack();
			this.addButton();
			this.addContent();
			this.addMask();
		}
		
		private function addContent():void {
			content = new Sprite();
			this.addChild(content);
			content.graphics.beginFill(0xffffff * Math.random());
            content.graphics.lineStyle();
			var h:int = Math.round(Math.random() * expandedHeight);
            content.graphics.drawRoundRect(0, 0, EXPANDED_WIDTH - 20, h, BACK_ROUND_RADIUS, BACK_ROUND_RADIUS);
            content.graphics.endFill();		
			var grid:Rectangle = new Rectangle(20, 20, 60, 60);
			//content.scale9Grid = grid;
			content.x = 10;
			content.y = button.y + button.height + 10;
			content.addEventListener(MouseEvent.CLICK, contentClickHandler);
			this.updateSize();
		}
		
		private function contentClickHandler(e:MouseEvent):void {
			content.height = Math.round(Math.random() * 300);
			this.updateSize();
		}
		
		private function updateSize():void {
			expandedHeight = button.x + button.height + BUTTON_CONTENT_GAP + content.height + (CONTENT_PADDING*2);
			background.height = expandedHeight;
			if (expanded) {
				this.expand();
			}
		}
		
		private function addBack():void {
			background = new Shape();
			this.addChild(background);
			background.graphics.beginFill(0xD8D7D3);
            background.graphics.lineStyle();
            background.graphics.drawRect(0, 0, EXPANDED_WIDTH, expandedHeight);
            background.graphics.endFill();		
			var grid:Rectangle = new Rectangle(20, 20, 60, 60);
			background.scale9Grid = grid ;			
			
		}
		
		private function addMask():void {
			contentMask = new Shape();
			this.addChild(contentMask);
			contentMask.graphics.beginFill(0x000000);
            contentMask.graphics.lineStyle();
            contentMask.graphics.drawRect(-5.25, 0, COLAPSED_WIDTH + 8, colapsedHeight);
            contentMask.graphics.endFill();
			this.mask = contentMask;
		}
		
		protected function addButton():void {
			button = new MenuButton();
			button.addEventListener(MouseEvent.CLICK, buttonClickHandler, false, 0, true);
			this.addChild(button);
			button.y = 10;
			colapsedHeight = button.y + button.height + 9;
		}
		
		private function buttonClickHandler(e:MouseEvent):void {
			this.dispatchEvent(new AccordionComponentEvent(AccordionComponentEvent.BUTTON_CLICK));
		}
		
		public function colapse():void {
			expanded = false;
			button.selected = false;
			this.dispatchEvent(new AccordionItemResizeEvent(AccordionItemResizeEvent.RESIZE_START, AccordionItemResizeEvent.RESIZE_TYPE_COLAPSE));
			TweenLite.to(contentMask, TWEEN_DELAY, { height:colapsedHeight, onUpdate:resizeProgress, onComplete:colapseComplete } );
		}
		
		public function expand():void {
			expanded = true;
			button.selected = true;
			this.dispatchEvent(new AccordionItemResizeEvent(AccordionItemResizeEvent.RESIZE_START, AccordionItemResizeEvent.RESIZE_TYPE_EXPAND));
			TweenLite.to(contentMask, TWEEN_DELAY, { height:expandedHeight+2, onUpdate:resizeProgress, onComplete:expandComplete } );
		}
		
		public override function get width():Number	{
			return contentMask.width;
		}
		
		public override function get height():Number {
			return contentMask.height;
		}
		
		protected function resizeProgress():void {			
			this.dispatchEvent( new AccordionItemResizeEvent(AccordionItemResizeEvent.RESIZE_PROGRESS));
		}
		
		protected function colapseComplete():void {
			this.dispatchEvent( new AccordionItemResizeEvent(AccordionItemResizeEvent.RESIZE_COMPLETE, AccordionItemResizeEvent.RESIZE_TYPE_COLAPSE));
		}
		
		protected function expandComplete():void {
			this.dispatchEvent( new AccordionItemResizeEvent(AccordionItemResizeEvent.RESIZE_COMPLETE, AccordionItemResizeEvent.RESIZE_TYPE_EXPAND));
		}
		
	}

}