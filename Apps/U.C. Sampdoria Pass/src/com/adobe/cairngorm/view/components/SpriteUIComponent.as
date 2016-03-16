package com.adobe.cairngorm.view.components {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import mx.core.IUIComponent;
	import mx.managers.ISystemManager;
	
	
	public class SpriteUIComponent extends Sprite implements IUIComponent {
		
		public function SpriteUIComponent (sprite : Sprite)
		{
			super ();
			
			explicitHeight = sprite.height;
			explicitWidth = sprite.width;
			
			addChild (sprite);
		}
		
		public function get baselinePosition():Number
		{
			return 0;
		}
		
		public function get document():Object
		{
			return null;
		}
		
		public function set document(value:Object):void
		{
		}
		
		public function get enabled():Boolean
		{
			return false;
		}
		
		public function set enabled(value:Boolean):void
		{
		}
		
		public function get explicitHeight():Number
		{
			return 0;
		}
		
		public function set explicitHeight(value:Number):void
		{
		}
		
		public function get explicitMaxHeight():Number
		{
			return 0;
		}
		
		public function get explicitMaxWidth():Number
		{
			return 0;
		}
		
		public function get explicitMinHeight():Number
		{
			return 0;
		}
		
		public function get explicitMinWidth():Number
		{
			return 0;
		}
		
		public function get explicitWidth():Number
		{
			return 0;
		}
		
		public function set explicitWidth(value:Number):void
		{
		}
		
		public function get focusPane():Sprite
		{
			return null;
		}
		
		public function set focusPane(value:Sprite):void
		{
		}
		
		public function get includeInLayout():Boolean
		{
			return false;
		}
		
		public function set includeInLayout(value:Boolean):void
		{
		}
		
		public function get isPopUp():Boolean
		{
			return false;
		}
		
		public function set isPopUp(value:Boolean):void
		{
		}
		
		public function get maxHeight():Number
		{
			return 0;
		}
		
		public function get maxWidth():Number
		{
			return 0;
		}
		
		public function get measuredMinHeight():Number
		{
			return 0;
		}
		
		public function set measuredMinHeight(value:Number):void
		{
		}
		
		public function get measuredMinWidth():Number
		{
			return 0;
		}
		
		public function set measuredMinWidth(value:Number):void
		{
		}
		
		public function get minHeight():Number
		{
			return 0;
		}
		
		public function get minWidth():Number
		{
			return 0;
		}
		
		public function get owner():DisplayObjectContainer
		{
			return null;
		}
		
		public function set owner(value:DisplayObjectContainer):void
		{
		}
		
		public function get percentHeight():Number
		{
			return 0;
		}
		
		public function set percentHeight(value:Number):void
		{
		}
		
		public function get percentWidth():Number
		{
			return 0;
		}
		
		public function set percentWidth(value:Number):void
		{
		}
		
		public function get systemManager():ISystemManager
		{
			return null;
		}
		
		public function set systemManager(value:ISystemManager):void
		{
		}
		
		public function get tweeningProperties():Array
		{
			return null;
		}
		
		public function set tweeningProperties(value:Array):void
		{
		}
		
		public function initialize():void
		{
		}
		
		public function parentChanged(p:DisplayObjectContainer):void
		{
		}
		
		public function getExplicitOrMeasuredWidth():Number
		{
			return 0;
		}
		
		public function getExplicitOrMeasuredHeight():Number
		{
			return 0;
		}
		
		public function setVisible(value:Boolean, noEvent:Boolean=false):void
		{
		}
		
		public function owns(displayObject:DisplayObject):Boolean
		{
			return false;
		}
		
		public function get measuredHeight():Number
		{
			return 0;
		}
		
		public function get measuredWidth():Number
		{
			return 0;
		}
		
		public function move(x:Number, y:Number):void
		{
		}
		
		public function setActualSize(newWidth:Number, newHeight:Number):void
		{
		}
		
	}
}