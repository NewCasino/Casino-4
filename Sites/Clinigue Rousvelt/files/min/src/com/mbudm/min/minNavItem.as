/*
com.mbudm.min.minNavItem.as 
extends com.mbudm.mbNavItem

Steve Roberts May 2009

Description
minNavItem creates the graphical elements that make up the navigation system.

minNavItem broadcasts to minContent when it is the selected item and it has moved, this allows the animtion handled by minContent to relate to the minNavItem

*/

import TextField;

class com.mbudm.min.minNavItem extends com.mbudm.mbNavItem{
	/* com.mbudm.mbNavItem vars
	
	private var navXML:XMLNode; // the nav xmlNode - layout settings 
	private var xNode:XMLNode; // the index xmlNode
	private var xCoord:String;
	private var childGroup:MovieClip;
	private var navLevel:Number;
	private var __enabled:Boolean;
	private var __selected:String;
	private var index:mbIndex;
	private var theme:mbTheme;
	private var layout:mbLayout;
	private var broadcaster:Object;
	private var tController:mbTransitionController;
	
	*/
	
	private var bg:MovieClip; // effectively the hit Area as _alpha is 0
	private var label:TextField;
	private var navspace:Number = 0;
	
	private var _nav_col:Number;
	private var _nav_over_col:Number;
	private var _nav_selected_col:Number;
	
	
	function minNavItem(){
		
	}
	
	private function createNavItem(){
		if(xNode.attributes.hidden == "1"){
			//trace(xCoord+" disabled")
			enabled = false;
		}else{
			var nType = index.getNodeType(xCoord) 
			if(nType !="img" && nType !="video" ){
				setupNavItem();
			}else{
				enabled = false;
			}
		}
	}
	//functions to be extended
	private function setupNavItem(){
		// nav items are a fixed size, so some measurements are stored once
		var navwidth:Number = layout.getDimension("navwidth");
		var navspaceStr:String = navXML.attributes.navspace;
		
		var navBtnSymbolArray:Array = navXML.attributes.navbtns ? navXML.attributes.navbtns.split(",") : undefined ;
		var navBtnSymbol = navBtnSymbolArray[navLevel] ? navBtnSymbolArray[navLevel] : navBtnSymbolArray[navBtnSymbolArray.length -1] ;
		var navButtonSet:Boolean = navBtnSymbol == undefined ? false : true ;
		// navspace is dependent on the nav item's location in the hierarchy
		// lower in the hierarchy = more indent and a different (usually smaller) padding
		var navSpaceArray = new Array();
		if(navspaceStr.split(",") ==  undefined){
			navSpaceArray.push(navspaceStr);
		}else{
			navSpaceArray = navspaceStr.split(",");
		}
		
		var cumnavspace:Number = 0;
		for(var i = 0; i< navLevel; i++){
			cumnavspace+=Number(navSpaceArray[i]);
		}
	
		navspace = Number(navSpaceArray[navLevel]) ;
		
		
		var bw = navwidth - cumnavspace;
		
		var indent:Number = Math.round(navspace/2);
		
		// colors - check for overrides
		_nav_col = Number(theme.getStyleColor("._nav"+navLevel,"0x"));
		if(isNaN(_nav_col))
			_nav_col = Number(theme.getStyleColor("._nav","0x"));
		if(isNaN(_nav_col))
			_nav_col = theme.compColor;

		_nav_over_col = Number(theme.getStyleColor("._nav"+navLevel+"over","0x"));
		if(isNaN(_nav_over_col))
			_nav_over_col = Number(theme.getStyleColor("._navover","0x"));
		if(isNaN(_nav_over_col))
			_nav_over_col = theme.compShades[1];
			
		_nav_selected_col = Number(theme.getStyleColor("._nav"+navLevel+"selected","0x"));
		if(isNaN(_nav_selected_col))
			_nav_selected_col = Number(theme.getStyleColor("._navselected","0x"));
		if(isNaN(_nav_selected_col))
			_nav_selected_col = theme.baseColor;
	
		if(navButtonSet){
			this.attachMovie(navBtnSymbol,"bg",this.getNextHighestDepth());
		}else{
			this.createEmptyMovieClip("bg",this.getNextHighestDepth());
		}
	
		this.createTextField("label",this.getNextHighestDepth(),indent,indent,bw - (navspace),0);
		label.selectable = false;
		label.autoSize = "left";
		label.html = true;
		label.textColor = _nav_col;
		
		
		// two styles - general nav style and level specific style.
		// check if either of these require an embedded font 
		
		var navStObj:Object  = theme.styles.getStyle(".nav")
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(navStObj.fontFamily.substr(0,2) == "__"){
			label.embedFonts = true;
		}
		
		var navLevelStObj:Object  = theme.styles.getStyle(".nav"+navLevel)
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(navLevelStObj.fontFamily.substr(0,2) == "__"){
			label.embedFonts = true;
		}
		
		label.styleSheet = theme.styles;
		
		label.htmlText = "<span class=\"nav\"><span class=\"nav"+navLevel+"\">"+xNode.attributes.title+"</span></span>";
	
		//draw the bg (hitArea)
		var bh; 
		
		if(navButtonSet){
			bh = bg._height;
			label._y = Math.round((bh - label._height)/2);
		}else{
			
			bh = label._height + navspace;
			with (this.bg) {
				beginFill(this._parent.theme.compTints[this._parent.theme.compTints.length - 1], 100);
				moveTo(0, 0);
				lineTo(bw, 0);
				lineTo(bw, bh);
				lineTo(0, bh);
				lineTo(0, 0);
				endFill();
			}
			bg._alpha = 0;
			
		}
		
		//enable the button
		setButtonEvents(true);
		
		//position the sub suction
		if(childGroup){
			var navspace_child:Number = Number(navSpaceArray[navLevel+1]) ; 
	
			childGroup._x = navspace;
			childGroup._y = bh;
		}
	}
	private function setButtonEvents(toggle:Boolean){
		
		bg.onRelease = toggle ? this.onBtnRelease : undefined ;
		bg.onRollOver = toggle ? this.onBtnOver : undefined ;
		bg.onRollOut = toggle ? this.onBtnOut : undefined ;
		bg.onReleaseOutside = toggle ? this.onBtnOut : undefined ;
		bg.onPress = toggle ? this.onBtnPress : undefined ;
		
	}
	
	private function onResize(){
		//minNavItem always has a parent minNavGroup
		this._parent.onResize();
	}
	
	public function moveNavItem(x:Number,y:Number){
		//if this item moves it broadcasts to any listeners -  currently just minContent (only if this item is selected)
		if( x != this._x || y != this._y ){
			if(broadcaster._listeners.length > 0){
				broadcaster.broadcastMessage("onMoved");
			}
			this._x = x;
			this._y = y;
		}
	}
	
	//scoped to bg (button)
	private function onBtnRelease(){
		//it is compulsory for minNavItem to call this function in mbNavItem
		this._parent.onNavItemClicked();
	}
	
	private function onBtnOver(){
		if(this._parent.__selected !=  this._parent.xCoord){
			this._parent.label.textColor = this._parent._nav_over_col;
		}
	}
	
	private function onBtnOut(){
		if(this._parent.__selected !=  this._parent.xCoord){
			this._parent.label.textColor = this._parent._nav_col;
		}
	}
	
	private function onBtnPress(){
		//trace(this+" onBtnPress");
	}

	private function doEnabled(){
		setButtonEvents(__enabled);
	}
	
	
	private function doSelected(){	
		if(__selected ==  xCoord){
			setButtonEvents(false);
			label.textColor = _nav_selected_col;
		
		}else{
			setButtonEvents(true);
			bg.onRollOut();
		
		}
		
		if(hasChildren){
			//am I an ancestor of the selected item?
			var ancestorCoord:String = __selected.substr(0,xCoord.toString().length); 
			if(ancestorCoord == xCoord){
				childGroup.open();	
			}else{
				childGroup.close();
			}
		}else{
			
		}
	}
	
	public function get hasChildren():Boolean{
		var bool:Boolean = childGroup ? true : false ;
		return bool;
	}
	
	public function get isOpen():Boolean{
		return childGroup.isOpen;
	}
	
	public function get actualHeight():Number{
		var h:Number = hasChildren ? this.bg._height + childGroup.actualHeight : this.bg._height ;
		
		h = isNaN(h) ? 0 : h ;
		
		return h;
		
	}
	
	public function get actualChildrenHeight():Number{
		var h:Number = hasChildren ? childGroup.actualHeight : 0 ;
		return h;
		
	}
	
	// used by recipients of the onMoved broadcast -  currently just minContent
	public function get anchorPoint():Object{
		var anchor:Object = new Object();
		anchor.x = label._width + navspace;
		anchor.y = this.bg._height/2;
		return anchor
	}
	

}