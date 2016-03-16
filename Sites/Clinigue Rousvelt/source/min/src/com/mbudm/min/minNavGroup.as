
/*
com.mbudm.min.minNavGroup.as 
extends com.mbudm.mbNavGroup

Steve Roberts May 2009

Description
minNavGroup handles the 'animation' and layout of the navItems. The animation is actually just a mask that resizes to 'open' and 'close' the nav group.

minNavGroup like all classes that do transitions on an indexUpdate event, communicates with the transition Controller to get it's transitions authorised before proceeding

*/

import mx.transitions.easing.Regular;

class com.mbudm.min.minNavGroup extends com.mbudm.mbNavGroup {
	/* com.mbudm.mbNavGroup vars
	private var navXML:XMLNode; // the nav xmlNode - layout settings 
	private var xNode:XMLNode; // the index xmlNode
	private var navItems:Array;
	private var xCoord:String;
	private var navLevel:Number; // the index in the nav hierarchy where this instance is - 0 is the root.
	private var __enabled:Boolean;
	private var __selected:String;
	private var index:mbIndex;
	private var theme:mbTheme;
	private var layout:mbLayout;
	private var selectedNav_mc:MovieClip;
	private var tController:mbTransitionController;
	
	*/
	
	private var navSpaceArray:Array;
	private var mask_mc:MovieClip;
	private var navwidth:Number;
	private var navheight:Number;
	
	private var animating:Boolean;
	private var direction:Boolean; //true for opening, false for closing
	private var _interval:Number;
	private var _intervalFrequency:Number = 10;
	
	private var _animDuration:Number;
	private var _animCount:Number = 0; // 0 is closed animDuration is open
	
	private var transitions:Array;
	private var transitionsIdCounter:Number;
	
	
	
	function minNavGroup(){
		// this class is designed to be extended so the constructur is left empty
		this._visible = false;
		transitions =  new Array();
		transitionsIdCounter = 0;
	}
	
	private function doEnabled(){
		
		for(var i = 0; i < navItems.length;i++){
			navItems[i].enabled = __enabled;
		}
		
		if(navLevel > 0){
			this._parent.enabled = __enabled
		}
	}
	
	private function doSelected(){
		//cancel all previously requested transitions
		if(navLevel > 0){
			for(var i = 1; i< transitions.length;i++){
				tController.cancelTransition(transitions[i].id);
			}
			transitions = new Array();
		}
	}
	private function setup(){ 
		// the anim is twice as long as there are items... so all navgroup animations go at the same speed
		_animDuration = navItems.length * 2;
		
		this.createEmptyMovieClip("mask_mc",this.getNextHighestDepth());
		this.setMask(this.mask_mc);
		
		if(navXML.attributes.navspace.split(",") ==  undefined){
			navSpaceArray = new Array()
			navSpaceArray.push(navXML.attributes.navspace);
		}else{
			navSpaceArray = navXML.attributes.navspace.split(",");
		}
		
		
		if(navLevel == 0){
			open();
		}
		this._visible = true;
		
		onResize();
		
	}
	
	public function onResize(){ 
		if(this._visible){
	
			//listens to layout object if this is the base nav (navLevel = 0) or called by the parent navitem otherwise
		
			// item layout
			navheight  = 0;
			var	navSpace:Number = Number(navSpaceArray[navLevel]);
			var prev:Number;
			var yPos:Number;
			
			for(var i = 0; i < navItems.length;i++){
				if(i>0){
					prev = i - 1;
					yPos = navItems[prev]._y + navItems[prev].actualHeight;
					if(navItems[prev].hasChildren && navItems[prev].isOpen && navItems[prev].actualChildrenHeight > 0){
						yPos += Math.round(navSpace/2);
					}
					navItems[i].moveNavItem(navItems[i]._x,yPos);
				}
				
				navheight += navItems[i].actualHeight;
			}
			
			
			navwidth = layout.getDimension("navwidth"); //also used by mask_mc so it's a class declared variable
			setMaskHeight();
			
			// positioning
			switch(navLevel){
				case 0:
					//the root nav group handles it's own layout as well
					//sub nav group position is controlled by the parent navItem
					
					var navX:Number;
					var navY:Number;
					
					var navxoffset:Number = navXML.attributes.navxoffset ? Number(navXML.attributes.navxoffset) : 0 ;
					var navyoffset:Number = navXML.attributes.navyoffset ? Number(navXML.attributes.navyoffset) : 0 ;
				
					navX = layout.getDimension("marginleft");
					navY = layout.getDimension("margintop") + layout.getDimension("gutter");
					
					this._x = navX + navxoffset;
					this._y = navY + navyoffset;
					
				break
				default:
					// navLevel > = 1 
					//sub nav group position is controlled by the parent navItem
				break;
			}
			
			if(navLevel > 0){	
				this._parent.onResize();
			}
		}
	}
	
	// called from tController, when it is this classes 'turn' to do it's transition, 
	// tController 'authorises' this class to do the transition
	public function onTransitionAuthorised(id:String){
		for(var i = 0; i<transitions.length ;i++){
			if(transitions[i].id  == id){
				transitions[i].authorised = true;
			}
		}
	}
	
	//animating methods
	private function open(){
		if(_animCount < _animDuration){
			this.enabled = false;
			
			transitionsIdCounter++;
			var tid:String = this._name + "_"+ this.toString().length +"_open_" + transitionsIdCounter+"_"+index.currentIndex; //something unique and identifiable
			transitions.push({id:tid,authorised:false});
			tController.requestTransition(this,"open","onTransitionAuthorised",transitions[transitions.length - 1].id);
			
			direction = true;
			startInterval();
		}
	}
	
	private function close(){
		if(_animCount > 0){
			this.enabled = false;
			transitionsIdCounter++;
			var tid:String = this._name + "_"+ this.toString().length +"_open_" + transitionsIdCounter+"_"+index.currentIndex; //something unique and identifiable
			transitions.push({id:tid,authorised:false});
			tController.requestTransition(this,"close","onTransitionAuthorised",transitions[transitions.length - 1].id);
			
			direction = false;
			startInterval();
		}
	}
	
	private function startInterval(){
		if(!_interval){
			this._interval = setInterval(this,"onInterval",_intervalFrequency);
		}
		animating = true;
	}
	
	private function onInterval(){
		// Because this component asks for transitions in the order it wants it we can safely wait until 
		// the first transition is authorised
		if(transitions[0].authorised){
			
			switch(direction){
				case true:
					//opening
					_animCount = Math.min((_animCount + 1),_animDuration);
					
				break;
				case false:
					//closing
					_animCount = Math.max((_animCount -1),0);
				break;
			}
			
			setMaskHeight();
				
			if(navLevel > 0){	
				this._parent.onResize();
			}
			
			if(_animCount == 0 || _animCount == _animDuration){
				//it is this classes responsibility to tell the tController when it has finished an authorised transition
				// this allows the tController to then authorise the next transition in it's list.
				// if this (or any class) doesn't do this, then the whole transition sequence will halt
				tController.transitionComplete(transitions[0].id);
				transitions.shift();
				clearInterval(this._interval);
				this._interval = undefined;
				this.enabled = true;
				animating = false;
			}
		}
	}
	
	private function setMaskHeight(){
		var factor = Regular.easeIn(_animCount/_animDuration, 0, 1, 1);
		
		var h = navheight * factor;
		drawRect(mask_mc,navwidth,h);
	}

	public function get isOpen():Boolean{
		var bool:Boolean = _animCount == _animDuration ? true : false ;
		return bool;
	}
	
	public function get actualHeight():Number{
		var h:Number = mask_mc._height;
		
		return h;
	}
	
	public function get isAnimating():Boolean{
		var bool:Boolean = _animCount == _animDuration ? true : false ;
		return bool;
	}
	
	private function drawRect (mc:MovieClip, w:Number, h:Number) {
		if(mc){
			with(mc){
				clear();
				beginFill(0x000000, 100);
				moveTo(0, 0);
				lineTo(w, 0);
				lineTo(w, h);
				lineTo(0, h);
				lineTo(0, 0);
				endFill();
			}
		}
	}
}