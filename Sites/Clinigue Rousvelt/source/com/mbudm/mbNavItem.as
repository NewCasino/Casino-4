/*
com.mbudm.mb.mbNavItem.as 
extends MovieClip

Steve Roberts May 2009

Description
mbNavItem is one part of the navigation system the other is mbNavGroup. An instance of mbNavItem can instantiate mbNavGroup if it has childNodes.

mbNavItem is set up as a broadcaster that is listened to by the mbContent class, as these two classes are likley to need to interact

*/ 

import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import com.mbudm.mbLayout;
import com.mbudm.mbTransitionController;

class com.mbudm.mbNavItem extends MovieClip{
	private var navXML:XMLNode; // the nav xmlNode - layout settings 
	private var xNode:XMLNode; // the index xmlNode
	private var xCoord:String;
	private var childGroup:MovieClip;
	private var navLevel:Number;
	private var __enabled:Boolean;
	private var __selected:String;
	private var __hovered:String;
	private var index:mbIndex;
	private var theme:mbTheme;	
	private var layout:mbLayout;
	private var broadcaster:Object;
	private var tController:mbTransitionController;
	
	function mbNavItem(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init(nX:XMLNode,xN:XMLNode,xC:String,ind:mbIndex,t:mbTheme,lyt:mbLayout,nL:Number,tC:mbTransitionController){
		navXML = nX;
		xNode = xN;
		xCoord =xC;
		index = ind;
		navLevel = nL;
		theme = t;
		
		layout = lyt;
		
		tController = tC;
		
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
		
		
		if(xNode.hasChildNodes()){
			
			createNavItemChildGroup();
		}
		createNavItem();// used by extended class
		
	}
	
	// compulsory on release method for the extending class to call
	private function onNavItemClicked(){
		index.currentIndex = xCoord;
	}
	
	private function createNavItemChildGroup(){
		childGroup = this.attachMovie("mbNavGroupSymbol","childGroup",this.getNextHighestDepth());// the child navGroup of a navItem are at the next navigation level - so +1
		childGroup.init(navXML,xNode,xCoord,index,theme,layout,navLevel+1,tController);
	}
	
	
	// functions to be extended
	
	private function createNavItem(){
	}
	private function onResize(){
		
	}
	
	private function doSelected(){	
		if(__selected ==  xCoord){
			//do selected behavior
		}
	}
	
	private function doHovered(){	
	
	}
	
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
		if(__selected == xCoord){
			this._parent.selectedNav = this;
		}
		if(xNode.hasChildNodes()){
			childGroup.selected = __selected;
		}
		doSelected();
		
	}
	
	public function set selectedNav(mc:MovieClip){
		this._parent.selectedNav = mc;
	}
	
	public function set hovered(h:String) {
		if(__hovered != h){
			__hovered = h;
			if(xNode.hasChildNodes()){
				childGroup.hovered = __hovered;
			}
			this._parent.hovered = __hovered;
			doHovered();
		}
	}
}