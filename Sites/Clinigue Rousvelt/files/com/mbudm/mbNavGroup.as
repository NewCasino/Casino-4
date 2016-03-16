/*
com.mbudm.mb.mbNavGroup.as 
extends MovieClip

Steve Roberts May 2009

Description
mbNavGroup is one part of the navigation system the other is mbNavItem. An instance of mbNavGroup can instantiate as many mbNavItems as it needs. The root of the navigation is an instance of mbNavGroup.

The root instance of mbNavGroup, listens to onIndexUpdate and onResize and passes these events to its child mbNavItems.

*/

import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import com.mbudm.mbLayout;
import com.mbudm.mbTransitionController;

class com.mbudm.mbNavGroup extends MovieClip{
	private var navXML:XMLNode; // the nav xmlNode - layout settings 
	private var xNode:XMLNode; // the index xmlNode
	private var navItems:Array;
	private var xCoord:String;
	private var navLevel:Number; // the index in the nav hierarchy where this instance is - 0 is the root.
	private var __enabled:Boolean;
	private var __selected:String;
	private var __hovered:String;
	private var index:mbIndex;
	private var theme:mbTheme;
	private var layout:mbLayout;
	private var selectedNav_mc:MovieClip;
	private var hoveredNav_mc:MovieClip;
	private var tController:mbTransitionController;
	
	function mbNavGroup(){
		// this class is designed to be extended so the constructur is left empty
	}
	public function init(nX:XMLNode,xN:XMLNode,xC:String,ind:mbIndex,t:mbTheme,lyt:mbLayout,nL:Number,tC:mbTransitionController){
		navXML = nX;
		xNode = xN;
		xCoord = xC;
		navLevel =  nL;
		index = ind;
		navItems = new Array(xNode.childNodes.length);
		theme = t;
		layout = lyt;
		tController = tC;
		
		
		// instantiate mbNavItem for each child 
		for(var i = 0;i<xNode.childNodes.length;i++){
			var coordStr:String = xCoord.length == 0 ? i : xCoord + "," + i;
			navItems[i] = this.attachMovie("mbNavItemSymbol","nav"+i,this.getNextHighestDepth());
			navItems[i].init(navXML,xNode.childNodes[i],coordStr,index,theme,layout,navLevel,tController);// the children of a navGroup are at the level of that navGroup
		}
		setup();
	}
	
	public function onIndexUpdate(){
		selected = index.currentIndex;
		onIndexUpdateExtra();
	}
	
	
	//functions to be extended
	public function setup(){ 
		// called after the navItems have been created  - in case the extend class wants to setup items/functionality 
	
		// layout code
		// layut code can go here too - it is up to the template to decide how this is laid out
		// nb if relies on resize then layout code should also be called from there
	}
	public function onResize(){ 
		//listens to stage if this is the base/root nav or called by the parent navitem otherwise
		// this will be overwriten by extensions of this class
	}
	
	private function onIndexUpdateExtra(){
	}
	
	private function doSelected(){	
	
	}
	
	private function doHovered(){	
	
	}
	
	//override
	private function doEnabled(){
		//this._visible =  __enabled;
	}
	
	public function get enabled():Boolean{
		return __enabled;
	}
	public function set enabled(e:Boolean) {
		if(e != __enabled){
			__enabled = e;
			doEnabled();
		}
	}
	
	public function set selected(s:String) {
		__selected = s;
		
		doSelected();
		for(var i = 0;i<navItems.length;i++){
			//pass the new selected item down to the children of this mbNavGroup
			navItems[i].selected = __selected;
		}	
		
	}
	
	public function get selectedNav():MovieClip {
		return selectedNav_mc;
	}
	
	public function set selectedNav(mc:MovieClip){
		selectedNav_mc = mc;
		if(navLevel > 0){
			this._parent.selectedNav = mc;
		}
	}
	
	public function set hovered(h:String) {
		if(__hovered != h){
			__hovered = h;
			for(var i = 0;i<navItems.length;i++){
				//pass the new hovered item down to the children of this mbNavGroup
				navItems[i].hovered = __hovered;
			}	
			this._parent.hovered = __hovered;
			doHovered();
		}
	}
}