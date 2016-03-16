
/*
com.mbudm.min.minContent.as 
extends com.mbudm.mbContent

Steve Roberts May 2009

Description
The minContent draws the transition animation (the border and backround of the content area) that occurs when a new page is navigated to
It also listens to onResize, which it uses to redraw the transitions and pass on the onResize values to the currently loaded page.
 
*/

import mx.transitions.easing.Regular;


class com.mbudm.min.minContent extends com.mbudm.mbContent{
	/*
	A list of all the private vars in com.mbudm.mbContent that this class has access to:
	
	private var contentXML:XMLNode;
	private var ldr:MovieClip;
	private var index:mbIndex;
	
	private var transition_mc:MovieClip;
	private var content_mc:MovieClip;
	private var theme:mbTheme;
	private var nav:MovieClip;
	
	private var contentReady:Boolean;
	private var transition:Boolean;
	
	private var layout:mbLayout;
	
	private var tController:mbTransitionController;
	
	*/
	
	/* content width and height and x & y values */
	private var cW:Number;
	private var cH:Number;
	private var cX:Number;
	private var cY:Number;
	
	/* the selected nav item that the transition line is drawn from 
	this variable is populated when this class receives a broadcast from the selected nav item identifying itself*/
	private var selectedNav_mc:MovieClip;
	
	/* transition vars */
	private var direction:Boolean; //true is 'creating' the page bg/border, false is 'destroying' it
	private var _interval:Number;
	private var _intervalFrequency:Number = 10;
	
	private var _animDuration:Number = 40;
	private var _animCount:Number = 0; 
	
	/* this class communicates with the transition manager, it stores a list of it's transition requests locally and it creates a unique id for each transition request for easier identification */
	private var transitions:Array;
	private var transitionsIdCounter:Number;
	
	/* the radius of the border rounded rectangle */
	private var radius:Number;
	
	private var rgb:Number;
	private var lrgb:Number;
	private var full_alpha:Number;
	
	private var currNodeName:String;
	private var prevCoord:String;
	
	private var doPhysicalTransition:Boolean;
	
	private var navOffsetSrc:MovieClip;
	
	
	private var isCurrHiddenNavItem:Boolean;
	private var isPrevHiddenNavItem:Boolean;
	
	
	function minContent(){
		
		transitions = new Array();
		transitionsIdCounter = 0;
	}
	
	private function endContent(){
		//trace("endContent");
		content_mc.end();
		onDeletedContent();	
	}
	
	private function startContent(){
		//content_mc._visible = true;
		content_mc.start();
		onAddedContent();
		
		// let the page load itself up
	}
	
	/* called from mbContent when a navigation event has occured */
	private function startTransition(){ 
	
		isPrevHiddenNavItem = isCurrHiddenNavItem;
		var nextItem = index.getItemAt(index.currentIndex);
		isCurrHiddenNavItem = nextItem.attributes.hidden == "1" ? true : false ;
		
		
		// do not transition between media items 
		var nextNodeName = index.getNodeType(index.currentIndex);
		var isMedia = (nextNodeName == "img" || nextNodeName == "video") && (currNodeName == "img" || currNodeName == "video") ? true : false ;
		
		// or if naviagting to the media child eg:
		// img/video at prevCoord = 0,2,3
		// index at contentCoord = 0,2
		if(!isMedia){
			if( (nextNodeName == "img" || nextNodeName == "video" ) &&  prevCoord == contentCoord.substr(0,contentCoord.lastIndexOf(",")) )
				isMedia = true;
		}
			
		// or from a child back to the index page - eg:
		// img/video at prevCoord = 0,2,3
		// index at contentCoord = 0,2
		var isMediaToIndex = false ;
		if( (currNodeName == "img" || currNodeName == "video" ) &&  prevCoord.substr(0,prevCoord.lastIndexOf(",")) == contentCoord )
			isMediaToIndex = true;
		
		//trace("isMedia:"+isMedia+" isMediaToIndex:"+isMediaToIndex+" prevCoord:"+prevCoord+" contentCoord:"+contentCoord+" nextNodeName:"+nextNodeName+" currNodeName:"+currNodeName);
		// set variables for next check
		prevCoord = contentCoord;
		currNodeName = nextNodeName;
		
	
		if(isMedia || isMediaToIndex ){
			// don't do the physical transition amimation, but do follow the process of requesting the transition so that the correct order is followed
			doPhysicalTransition = false
		}else{
			doPhysicalTransition = true
		}
			
		transition = true; // we are in the process of transitioning. this boolean is used and set up in mbContent
	
		//transitions = new Array();
		//cancel all previously requested transitions from the last navigation
		for(var i = 0; i< transitions.length;i++){
			tController.cancelTransition(transitions[i].id);
		}
		transitions = new Array();
		
		
		if(selectedNav_mc == undefined){
			//If no selectedNav_mc then it's the first page so only transition the page creation phase
			direction =  true;
			
			transitionsIdCounter++;
			var tid:String = this._name +"_create_" + transitionsIdCounter+"_"+index.currentIndex +"_"+ getTimer(); //something unique and identifiable
			// request the transition
			transitions.push({id:tid,authorised:false});
			tController.requestTransition(this,"create","onTransitionAuthorised",tid);
			
			
			//and setup the sub mcs
			transition_mc.createEmptyMovieClip("bg",1);
			transition_mc.createEmptyMovieClip("lines",2);
			
			//and store the radius value
			radius = contentXML.attributes.cornerradius ? Number(contentXML.attributes.cornerradius) : 8;
			
			//and the fixed settings like color
			rgb = Number(theme.getStyleColor("._contentBackground","0x"));
			if(isNaN(rgb))
				rgb = theme.compTints[theme.compTints.length - 1];
				
			lrgb = Number(theme.getStyleColor("._contentBorder","0x"));
			if(isNaN(lrgb))
				lrgb = theme.compColor;
			
			full_alpha = contentXML.attributes.bgalpha ? Number(contentXML.attributes.bgalpha) : 80;
	
		}else{
			direction = false; // destroy first
			
			transitionsIdCounter++;
			var tid:String = this._name +"_destroy_" + transitionsIdCounter+"_"+index.currentIndex +"_"+ getTimer(); //something unique and identifiable
			// request the transition
			transitions.push({id:tid,authorised:false});
			tController.requestTransition(this,"destroy","onTransitionAuthorised",tid);
		}
		
		if(!_interval){
			this._interval = setInterval(this,"onInterval",_intervalFrequency);
		}else{
			// in the middle of a transition so if we are destroying then simply continue
			// if we are creating then reverse - end result always set to destroy 
			direction = false;
			//don't need suthorisation as we are in the middle of it
			//tController.requestTransition(this,"destroy");
		}
		//trace("minContent - transitions:"+transitions.length +" [0].id:"+transitions[0].id);
		
		if(direction){
			// get the new selected item because we are creating
			selectedNav_mc = nav.selectedNav;
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
		//trace("minContent onTransitionAuthorised id:"+id);
	}
	
	private function onInterval(){
		//if the current transition is authorised then the actual transition will be done
		if(transitions[0].authorised){
			if(doPhysicalTransition){
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
				//the update transition code is in a seperate function because it is also called from onResize
				// ie when the movie resizes, the border and bg needs to change shape as well
				updateTransition();
			}else{
				// accelerate the transition to the end, so we can trigger the next step
				_animCount = direction ? _animDuration : 0 ;
			}
			if(_animCount == 0 || _animCount == _animDuration){
				
				//it is this classes responsibility to tell the tController when it has finished an authorised transition
				// this allows the tController to then authorise the next transition in it's list.
				// if this (or any class) doesn't do this, then the whole transition sequence will halt
				tController.transitionComplete(transitions[0].id);
				transitions.shift(); //the current transition is removed now it is done with
				
				if(!direction && _animCount == 0 ){
					direction = true; //change direction
					
					//request the authorisation of the create transition
					transitionsIdCounter++;
					var tid:String = this._name +"_create_" + transitionsIdCounter+"_"+index.currentIndex +"_"+ getTimer(); //something unique and identifiable
					transitions.push({id:tid,authorised:false});
					tController.requestTransition(this,"create","onTransitionAuthorised",tid);
					
					// get the new selected item because we are creating
					selectedNav_mc = nav.selectedNav;
			
				}else{
					onTransitionComplete();
					clearInterval(this._interval);
					this._interval = undefined;
				}
			}
		}else{
			//trace(" waiting for authorisation of - transitions:"+transitions.length +" [0].id:"+transitions[0].id);
		}
	}
	
	public function onScrollingStopped(src:MovieClip){
		//trace("onScrollingStopped");
		navOffsetSrc = src;
		updateTransition();
	}
	
	public function onScrollingStarted(){
		//trace("onScrollingStarted");
	}
	
	private function updateTransition(){
		
		// do as much set up as possible before calling the clear()
	
		var factor:Number = Regular.easeIn(_animCount/_animDuration, 0, 1, 1);
		
		//get the start point - from the selected nav item
		var lineStart:Object = selectedNav_mc.anchorPoint;
		if(isNaN(lineStart.x) || isNaN(lineStart.y) ){
			lineStart = selectedNav_mc._parent._parent.anchorPoint;
			selectedNav_mc._parent._parent.localToGlobal(lineStart);
		}else{
			selectedNav_mc.localToGlobal(lineStart);
		}
		
		// add offset values
		lineStart.x -= navOffsetSrc.xoffset ? navOffsetSrc.xoffset : 0 ;
		lineStart.y -= navOffsetSrc.yoffset ? navOffsetSrc.yoffset : 0 ;
		
		var bgAlpha:Number;
		
		var lsy = isNaN(lineStart.y) ? (cY+radius) : lineStart.y ;
		var lineEnd:Object = {x:cX,y:lsy};
		
		transition_mc.lines.clear();
		transition_mc.lines.lineStyle(0.3,lrgb,full_alpha,true);
		
		if(factor > 0.8){
			bgAlpha = ((factor - 0.8)/ 0.2) * full_alpha
			// whole solid rounded rect - if the size hasn't changed then don't redraw it, just change the alpha
			if(cW != transition_mc.bg._width || cH != transition_mc.bg._height){
				drawBackground(radius);
			}
			transition_mc.bg._alpha = bgAlpha;
			transition_mc.bg._x = cX;
			transition_mc.bg._y = cY;
		}else{
			transition_mc.bg._alpha = 0;
		}
		if(factor > 0.3){
			//top half of the rounded rectangle outline
			transition_mc.lines.moveTo(lineEnd.x,lineEnd.y);
			
			var fromPoint:Number = lineEnd.y
			var toPoint:Number = (cY + radius);
			
			if(factor <= 0.4){
				toPoint = getToPoint(toPoint,fromPoint,factor,0.3,0.4)
			}
			transition_mc.lines.lineTo(cX,toPoint);
			if(factor > 0.4){
				fromPoint = (cX + radius);
				toPoint = (cX + cW -radius);
				if(factor <= 0.6){
					
					toPoint = getToPoint(toPoint,fromPoint,factor,0.4,0.6)
				}
				transition_mc.lines.curveTo(cX,cY,fromPoint,cY);	
				transition_mc.lines.lineTo(toPoint,cY);
			}
			if(factor > 0.6){
				fromPoint =  (cY + radius);
				toPoint = (cY+(cH/2));
				if(factor <= 0.8){
					
					toPoint = getToPoint(toPoint,fromPoint,factor,0.6,0.8)
				}
				transition_mc.lines.curveTo(cX + cW,cY,(cX + cW), fromPoint);
				transition_mc.lines.lineTo((cX + cW),toPoint);
			}
			
			
			//bottom half of the rounded rectangle outline
			transition_mc.lines.moveTo(lineEnd.x,lineEnd.y);
			
			fromPoint = lineEnd.y
			toPoint = (cY + cH -radius);
			
			if(factor <= 0.4){
				toPoint = getToPoint(toPoint,fromPoint,factor,0.3,0.4)
			}
			
			transition_mc.lines.lineTo(cX,toPoint);
			if(factor > 0.4){	
				fromPoint = (cX + radius);
				toPoint = (cX + cW -radius);
				if(factor <= 0.6){
					
					toPoint = getToPoint(toPoint,fromPoint,factor,0.4,0.6)
				}
				transition_mc.lines.curveTo(cX,(cY + cH),fromPoint,(cY + cH));	
				transition_mc.lines.lineTo(toPoint,(cY + cH));
			}
			if(factor > 0.6){
				fromPoint =  (cY + cH - radius);
				toPoint = (cY+(cH/2));
				if(factor <= 0.8){
					
					toPoint = getToPoint(toPoint,fromPoint,factor,0.6,0.8)
				}
				transition_mc.lines.curveTo((cX + cW),(cY + cH),(cX + cW),fromPoint);	
				transition_mc.lines.lineTo((cX + cW),toPoint);
			}
		}
		
		fromPoint =  lineStart.x;
		toPoint = lineEnd.x;
		
		// only draw the line if prev/curr is not a hidden item and the direction is fading down/up the non hidden item
		if((!direction && !isPrevHiddenNavItem) || (direction && !isCurrHiddenNavItem) ){
			
			if(factor <= 0.3){
				//calculate the length of  the line to draw
				toPoint = getToPoint(toPoint,fromPoint,factor,0,0.3)
			}
			// line
			transition_mc.lines.moveTo(fromPoint,lineStart.y);
			transition_mc.lines.lineTo(toPoint,lineEnd.y);
			
		}else{
			//trace(" not drawing the line - direction "+direction);
		}
	}
	
	// works out where the line should be drawn to given the factor
	private function getToPoint(tp:Number,fp:Number,factor:Number,fRangeStart:Number,fRangeEnd:Number):Number{
			var toPoint:Number;
			var range:Number = fRangeEnd - fRangeStart;
			var rangePortion:Number = factor - fRangeStart;
			var rangePercent:Number = rangePortion / range;
			var maxLength:Number = tp - fp;
			var actualLength:Number = maxLength * rangePercent;
			toPoint = fp + actualLength;
			
			return toPoint
	}
	
	private function drawBackground(radius:Number){
			transition_mc.bg.clear();
			transition_mc.bg.moveTo(0,(cH - radius));//start from bottom left
			transition_mc.bg.beginFill(rgb,100);
			transition_mc.bg.lineTo(0,(radius));
			transition_mc.bg.curveTo(0,0,(radius),0);
			transition_mc.bg.lineTo((cW -radius),0);
			transition_mc.bg.curveTo((cW),0,(cW), (radius));
			transition_mc.bg.lineTo((cW),(cH - radius));
			transition_mc.bg.curveTo((cW),(cH),(cW -radius),(cH));
			transition_mc.bg.lineTo((radius),(cH));
			transition_mc.bg.curveTo(0,(cH),0,(cH -radius));
			transition_mc.bg.endFill();
	}
	
	private function onTransitionComplete(){ 
		transition = false;
		// mbContent requires the exend class to notify when the transition is complete 
		// and it can go ahead and tell the content_mc to start
		initialiseContent();
	}
	
	public function onResize(){ 
		//listens to layout object
		
		//shortcuts to  props
		var navwidth:Number = layout.getDimension("navwidth");
		var gutter:Number = layout.getDimension("gutter");
		
		// Width
		cW = layout.getDimension("sitewidth") - navwidth - gutter;
		
		// Height
		cH = layout.getDimension("siteheight");

		// Position
		cX = layout.getDimension("marginleft") + gutter + navwidth;
		cY = layout.getDimension("margintop");
		
		
		// Padding
		
		// - order is like css Top, right, bottom , left
		var padding:Array = contentXML.attributes.padding ? contentXML.attributes.padding.split(",") : [10,10,10,10];
		
		// convert padding values to pixels if they are fractions - order is like css Top, right, bottom , left
		var dimension:Number;
		for(var i = 0 ; i < padding.length; i++){
			dimension = i == 0 || i == 2 ? cH : cW ;
			padding[i] = padding[i] > 0 && padding[i] < 1 ? Number(padding[i]) * dimension : Number(padding[i]) ;
		}
	
		var content_mc_w = Math.round(cW - padding[1] - padding[3]);
		var content_mc_h = Math.round(cH - padding[0] - padding[2]);
		var content_mc_x = Math.round(cX + padding[3]);
		var content_mc_y = Math.round(cY + padding[0]);
	
		this.content_mc.setSize(content_mc_w,content_mc_h);
		this.content_mc._x = content_mc_x;
		this.content_mc._y = content_mc_y;
	
		updateTransition();
	}
}