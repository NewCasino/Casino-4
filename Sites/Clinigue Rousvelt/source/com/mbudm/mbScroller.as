/*
com.mbudm.mb.mbScroller.as 
extends MovieClip

Steve Roberts May 2009

Description
mbScroller is one of two scrollbar classes in this template. This class scrolls the textField by physically changing the _y property of the text field which is the child of a MovieClip. The MovieClip (the 'pane content') is masked so that we only see the area that is teh current scroll position. The other scrollbar, mbScrollerTextFieldMode, uses the more traditional method of scrolling a text field... setting the TextField.scroll property. 

The reason for these two scrollbars is that even though the MovieClip method used by mbScroller provides a better smoother scroll, this method will not work with the Table of contents utility. So when the TOC is enabled (in mbTextModule), mbScrollerTextFieldMode is used instead.


Constructor parameters
tF - textfield that the scroller listens to and controls
aD - object with custom clips or colours
	mcs -
		bg
		slider
		scroll_start_btn
		scroll_end_btn
		arrowStart
		arrowEnd
	cols
		_scrollSlider
		_scrollSliderOver
		_scrollTrack
		_scrollButtons
		_scrollButtonArrow
		_scrollButtonsOver
		trackalpha
	scrollThickness
*/
import com.haganeagency.MHC.MouseControl;
import mx.utils.Delegate;
import TextField;

class com.mbudm.mbScroller extends MovieClip{
	
	
	private var paneContent; //MovieClip or layout data object
	
	private var spD:Number; // scroll pane dimension
	private var pcD:Number; // pane content dimension
	private var initialised:Boolean = false;
	private var basePos:Number; // the pane content original x or y position
	private var minPos:Number;  // the minimum x or y position that the scroll content can be placed at
	
	private var scrollHorizontal:Boolean;
	
	private var scrollPosProp:String;
	private var scrollDimProp:String;
	private var scrollMouseProp:String;
	
	private var nonScrollPosProp:String;
	private var nonScrollDimProp:String;
	
	private var assetData:Object = new Object();
	private var sliderLength:Number;
	private var scrollThickness:Number;
	
	private var bg:MovieClip;
	private var slider:MovieClip;
	private var scroll_start_btn:MovieClip;
	private var scroll_end_btn:MovieClip;
	private var arrowStart:MovieClip;
	private var arrowEnd:MovieClip;
	
	private var pane:MovieClip;
	
	private var btnCols:Object;
	
	private var scrolling:Boolean;
	private var scrollingMode:Number;
	
	private var scrollCount:Number = 0;
	
	private var scrollingBg:Boolean = false;
	private var scrollingToStart:Boolean = true;
	
	private var tweening:Boolean = false;
	private var tweenCount:Number = 0;
	private var tweenTo:Number;
	private var dragging:Boolean;
	
	private var intervalCount:Number = 0;
	private var _interval:Number;
	
	private var __enabled:Boolean;
	
	private var broadcaster:Object;
	
	function mbScroller(){
		
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
		
		btnCols = new Object();
	}
	
	public function init(pc,pm,horizontal:Boolean,aD:Object) {
		paneContent = pc;
		pane = pm;
		
		scrollHorizontal = horizontal ? true : false ;
		
		scrollPosProp = scrollHorizontal ? "_x" : "_y" ;
		scrollDimProp = scrollHorizontal ? "_width" : "_height" ;
		scrollMouseProp = scrollHorizontal ? "_xmouse" : "_ymouse" ;
		
		nonScrollPosProp = scrollHorizontal ? "_y" : "_x" ;
		nonScrollDimProp = scrollHorizontal ? "_height" : "_width" ;
		
		
		
		basePos = paneContent[scrollPosProp];
		if(aD){
			assetData = aD;
		}
		scrollThickness = assetData.scrollWidth ? assetData.scrollWidth : 10 ;
		this.enabled  = false;
		
		Key.addListener(this);
				
		//Full initialisation occurs when the scrollPane dimensions are provided in setSize()
	}
	
	public function addListener(obj:Object){
		broadcaster.addListener(obj);
	}
	
	/* Key event listeners */
	public function onKeyDown(){
		var key = Key.getCode();
		if(scrollHorizontal){
			switch(key){
				case 37:
					// left arrow
					incrementScrollKey(true,true,5);
				break;
				case 39:
					//right arrow
					incrementScrollKey(false,true,5);
				break;
			}
		}else{
			switch(key){
				case 33:
					//page up
					incrementScrollKey(true,true,6);
				break;
				case 34:
					//page down
					incrementScrollKey(false,true,6);
				break;
				case 38:
					// up arrow
					incrementScrollKey(true,true,5);
				break;
				case 40:
					// down arrow
					incrementScrollKey(false,true,5);
				break;
			}
		}
	}
	public function onKeyUp(){
		var key = Key.getCode();
		if(scrollHorizontal){
			switch(key){
				case 37:
					// left arrow
					incrementScrollKey(true,false,5);
				break;
				case 39:
					//right arrow
					incrementScrollKey(false,false,5);
				break;
			}
		}else{
			switch(key){
				case 33:
					//page up
					incrementScrollKey(true,false,6);
				break;
				case 34:
					//page down
					incrementScrollKey(false,false,6);
				break;
				case 38:
					// up arrow
					incrementScrollKey(true,false,5);
				break;
				case 40:
					// down arrow
					incrementScrollKey(false,false,5);
				break;
			}
		}
	}
	
	private function incrementScrollKey(dir:Boolean,isScrolling:Boolean,sM:Number){
		scrolling = isScrolling;
		if(scrolling){
			scrollCount = 0;
			scrollingToStart = dir;
			scrollingMode = sM;
			startInterval();
		}else{

		}
	}
	
	public function onScrollWheel(delta:Number){
		var scrollPos:Number = paneContent[scrollPosProp];
		var newPos:Number;
		var scrollStep:Number;
		if(delta > 0 ){
			scrollingToStart = true;
			scrollStep = (basePos - this.paneContent[scrollPosProp]) * (delta / 5);
			
		}else{
			scrollingToStart = false;
			scrollStep = (this.paneContent[scrollPosProp] - minPos) * (-delta / 5);
		}
		scrollingMode = 4;
		
		newPos = scrollingToStart ? Math.min(basePos,this.paneContent[scrollPosProp] + scrollStep) : Math.max(minPos,this.paneContent[scrollPosProp] - scrollStep);
		
		scrollToPoint(newPos);
		
		startInterval();
	}
	
	// if no custom clips are supplied then basic drawing api shapes are used with cols if they are specified b&w if not
	private function createAssets(){
		
		if(!assetData.cols){
			assetData.cols._scrollSlider = 0xbbbbbb;
			assetData.cols._scrollSliderOver = 0xcccccc;
			assetData.cols._scrollTrack = 0xdddddd;
			assetData.cols._scrollButtons = 0xbbbbbb;
			assetData.cols._scrollButtonArrow = 0xffffff;
			assetData.cols._scrollButtonsOver = 0xcccccc;
			assetData.cols.trackalpha = 100;
		}
		if(assetData.mcs){
			if(assetData.mcs.bg) this.attachMovie(assetData.mcs.bg,"bg",this.getNextHighestDepth());
			if(assetData.mcs.slider) this.attachMovie(assetData.mcs.slider,"slider",this.getNextHighestDepth());
			if(assetData.mcs.scroll_start_btn) this.attachMovie(assetData.mcs.scroll_start_btn,"scroll_start_btn",this.getNextHighestDepth());
			if(assetData.mcs.scroll_end_btn) this.attachMovie(assetData.mcs.scroll_end_btn,"scroll_end_btn",this.getNextHighestDepth());
			
			
			setButtons(true);
		
			if(bg){
				bg[nonScrollDimProp] = scrollThickness;
				btnCols["bg"].setRGB(assetData.cols._scrollButtons);
			}
			if(slider){
				slider[nonScrollDimProp]  = scrollThickness;
				slider.setRGB(assetData.cols._scrollButtons);
				btnCols["slider"].setRGB(assetData.cols._scrollButtons);
			}
			if(scroll_start_btn){
				scroll_start_btn._width = scrollThickness;
				scroll_start_btn._yscale = scroll_start_btn._xscale ;
				btnCols["scroll_start_btn"].setRGB(assetData.cols._scrollButtons);
			}
			if(scroll_end_btn){
				scroll_end_btn._width = scrollThickness;
				scroll_end_btn._yscale = scroll_start_btn._xscale ;
				btnCols["scroll_end_btn"].setRGB(assetData.cols._scrollButtons);
			
			}
			//trace(assetData.mcs.scroll_start_btn+" scroll_start_btn w:"+scroll_start_btn._width + " h:"+scroll_start_btn._height + " x:"+scroll_start_btn._x + " y:"+scroll_start_btn._y);
		}else{
			this.createEmptyMovieClip("bg",1);
			this.createEmptyMovieClip("slider",2);
			this.createEmptyMovieClip("scroll_start_btn",3);
			this.createEmptyMovieClip("scroll_end_btn",4);
			this.createEmptyMovieClip("arrowStart",5);
			this.createEmptyMovieClip("arrowEnd",6);
			

			//other elemnts don't change so they can be drawn here once only
			drawRect(this.bg,scrollThickness,(paneContent[scrollDimProp] - (scrollThickness*2)),assetData.cols._scrollTrack,assetData.cols.trackalpha);
			drawRect(this.scroll_start_btn,scrollThickness,scrollThickness,assetData.cols._scrollButtons);
			drawRect(this.scroll_end_btn,scrollThickness,scrollThickness,assetData.cols._scrollButtons);
			drawTriangle(this.arrowStart,(scrollThickness/2),assetData.cols._scrollButtonArrow);
			drawTriangle(this.arrowEnd,(scrollThickness/2),assetData.cols._scrollButtonArrow,false);
			
			
			setButtons(true);
		}
		
		// the pane masks the pane_content
		// the pane is also used by the mouseControl - it is the area used to capture mouse wheel events
		//this.createEmptyMovieClip("pane",7);
		//this._parent.setMask(this.pane);
		
		// the mouse wheel functions if the mouse is over pane MovieClip, so as that has now been 
		//created, now is the right time to setup the MouseControl linkage to this class
		var $class = this
		var mouseControl : MouseControl;
		mouseControl = MouseControl.getInstance();
		mouseControl.addScroll("mc", this.pane, Delegate.create($class, onScrollWheel));
		
	
		// these position values will not change so they are set once only here
		if(bg) this.bg[scrollPosProp] = scrollThickness;
		
		if(!assetData.mcs){
			this.arrowStart[nonScrollPosProp] = scrollThickness/4;
			this.arrowStart[scrollPosProp] = (scrollThickness - this.arrowStart[scrollDimProp])/2;
			this.arrowEnd[nonScrollPosProp] = this.arrowStart[nonScrollPosProp];
		}
		//other items change position on textField height change so they are 
		//in a separate function called by the on Resize method below
	
	}
	
	private function setButtons(b:Boolean){
		// all the interactive elemnts use the same event handlers
		var btns:Array = [bg,slider,scroll_start_btn,scroll_end_btn];
		var i:Number;
		for(i=0;i<btns.length;i++){
			if(btns[i]){
				btns[i].onRelease = b ? this.onBtnOut : undefined ;
				btns[i].onRollOver =  b ? this.onBtnOver : undefined ;
				btns[i].onRollOut =  b ? this.onBtnOut : undefined ;
				btns[i].onReleaseOutside =  b ? this.onBtnOut : undefined ;
				btns[i].onPress =  b ? this.onBtnPress : undefined ;
				btns[i].enabled = b;
				// once only
				if(btnCols[btns[i]._name] == undefined){
					btnCols[btns[i]._name] =  new Color(btns[i]) ;
					//trace(this + " - "+ btns[i]._name +" col object "+btnCols[btns[i]._name]);
					
				}
			}
		}
	}
	

	private function setPaneContentDimensions(){
		
		this.enabled  = pcD > spD ? true : false ;
		if(this.enabled){
			if(paneContent[scrollPosProp] <= minPos){
				paneContent[scrollPosProp] = minPos;
			}else if(paneContent[scrollPosProp] >= basePos){
				paneContent[scrollPosProp] = basePos;
			}
		}else{
			paneContent[scrollPosProp] = basePos;
		}
	}
	

	public function setSize(sw:Number,sh:Number,pcw:Number,pch:Number){
	//	trace(this._name+" sw:"+sw+",sh:"+sh+",pcw:"+pcw+",pch:"+pch);
		spD = scrollHorizontal ? sw : sh ;
		
		pcD = scrollHorizontal ? pcw : pch ;
		minPos = basePos + spD - pcD;
		
		setPaneContentDimensions();
		
		if(!initialised && sw && sh){
			initialised = true;			
			createAssets();
		}
			
		if(initialised){	
			positionAssets();
			updateSliderSize()
			updateSliderPosition()
		}
		
	}
	
	// manual notify of content position changing
	public function onContentChanged(){
		if(initialised){	
			positionAssets();
			updateSliderSize()
			updateSliderPosition()
		}
	}
	
	public function moveTo(x:Number,y:Number){
		this._x = x;
		this._y = y;
	}
	
	private function calculateSliderHeight(){
		if(slider){
			var max =  spD - (2*scrollThickness);//this.bg[scrollDimProp]
			var actual = max * (spD/pcD);
			var min = scrollThickness;
			sliderLength = Math.round(Math.max(min,Math.min(actual,max)));
		}
	}

	private function updateSliderSize(){
		if(slider){
			calculateSliderHeight();
		
			if(assetData.mcs){
				slider[scrollDimProp] = sliderLength;
			}else{
				drawRect(this.slider,scrollThickness,sliderLength,assetData.cols._scrollSlider);
			}
		}
	}
	
	private function updateSliderPosition(){
		if(slider){
			if(scrollingMode == 3 && (scrolling  || tweening)){
				// don't update now as the slider is being dragged or the tween is catching up to the last drag point
			}else{
				var newPos = Math.round(scrollThickness + ((this.bg[scrollDimProp] - this.slider[scrollDimProp]) * ((basePos - paneContent[scrollPosProp]) / (basePos - minPos))));
				//snap to end?
				var start = scrollThickness;
				var end = (scrollThickness + bg[scrollDimProp] - slider[scrollDimProp]);
				newPos = snapToEnd(newPos,start,end,2);
				this.slider[scrollPosProp] = newPos;
			}
		}
	}
	
	private function positionAssets(){
		if(bg) this.bg[scrollDimProp] = spD - (scrollThickness*2);
		if(scroll_end_btn) this.scroll_end_btn[scrollPosProp] = spD - scrollThickness;
		if(!assetData.mcs) this.arrowEnd[scrollPosProp] =  this.scroll_end_btn[scrollPosProp] + this.arrowStart[scrollPosProp];
		
		updateSliderSize(); // the slider get's redrawn if the paneContent[scrollDimProp]/text.length change so it has it's own function
	}
	
	// scoped to buttons
	// all interactive elements use the ame methods, so they contain different functionality depending on the movieclip being interacted with
	private function onBtnOver(){
		if(this != this._parent.bg){
			if(this == this._parent.slider){
				this._parent.btnCols[this._name].setRGB(this._parent.assetData.cols._scrollSliderOver);
			}else{
				this._parent.btnCols[this._name].setRGB(this._parent.assetData.cols._scrollButtonsOver);
			}
		}
	}
	private function onBtnOut(){
		if(this != this._parent.bg){
			if(this == this._parent.slider){
				this._parent.btnCols[this._name].setRGB(this._parent.assetData.cols._scrollSlider);
			}else{
				this._parent.btnCols[this._name].setRGB(this._parent.assetData.cols._scrollButtons);
			}
		}
		if(this == this._parent.slider){
			this._parent.onDragSlider(false);
		}
		if(this == this._parent.scroll_end_btn || this == this._parent.scroll_start_btn){
			this._parent.incrementScroll(this,false);
		}
		if(this == this._parent.bg){
			this._parent.incrementScrollBg(this[scrollMouseProp] ,false);
		}
	}
	private function onBtnPress(){
		
		if(this == this._parent.scroll_end_btn || this == this._parent.scroll_start_btn){
			this._parent.incrementScroll(this,true);
		}
		if(this == this._parent.bg){
			this._parent.incrementScrollBg(this[scrollMouseProp] ,true);
		}
		if(this == this._parent.slider){
			this._parent.onDragSlider(true);
		}
	}
	
	
	// ---- Scrolling activity methods ----
	
	//scroll activity setup methods
		
	private function onDragSlider(isDragging:Boolean){
		scrolling = isDragging;
		if(scrolling){
			var dragBounds:Array = new Array(4);
			if(scrollHorizontal){
				dragBounds[0] = this.bg._x;
				dragBounds[1] = 0;
				dragBounds[2] = this.bg._x + this.bg._width - this.slider._width;
				dragBounds[3] = 0;
			}else{
				dragBounds[0] = 0;  //left
				dragBounds[1] = this.bg._y;  //top
				dragBounds[2] = 0;  //right
				dragBounds[3] = this.bg._y + this.bg._height - this.slider._height; //bottom
			}
			this.slider.startDrag(false, dragBounds[0],dragBounds[1],dragBounds[2],dragBounds[3]);
			scrollingMode = 3;
			startInterval();
		}else{
			this.slider.stopDrag();
		}
	}
	private function incrementScroll(src:MovieClip,isScrolling:Boolean){
		scrolling = isScrolling;
		if(scrolling){
			scrollCount = 0;
			scrollingToStart = src._name == "scroll_start_btn" ? true : false ;
			scrollingMode = 1;
			startInterval();
		}else{

		}
	}
	private function incrementScrollBg(ym:Number,isScrolling:Boolean){
		scrolling = isScrolling;
		if(scrolling){
			var endOfSlider = this.slider[scrollPosProp] + this.slider[scrollDimProp];
			scrollingToStart = this[scrollMouseProp] <= endOfSlider? true : false  ;
			scrollingMode = 2;
			startInterval();
		}else{
	
		}
	}

	//scroll activity  Interval
	
	private function startInterval(){
		//if the interval exists do nothing
		//if not create an interval that fires off onInterval
		if(!this._interval){
			this._interval = setInterval(this,"onInterval",50);
			
			broadcaster.broadcastMessage("onScrollingStarted");
		}
		onInterval(); //fire once for immediate response
	}
	
	private function onInterval(){
		if(scrolling || tweening){
			//increment scroll
			var scrollStep:Number;
			var newPos:Number = paneContent[scrollPosProp];
			if(scrolling){
				switch(scrollingMode){
					case 1:
					case 5:
						//1 - scroll_end_btn or scroll_start_btn 
						//5 - up or down arrow keys
						scrollCount++;
						//scrollstep increases the longer the interval is
						scrollStep = Math.max((scrollCount * 5),(scrollThickness*2));
						newPos = scrollingToStart ? Math.min(basePos,this.paneContent[scrollPosProp] + scrollStep) : Math.max(minPos,this.paneContent[scrollPosProp] - scrollStep);
						scrollToPoint(newPos);
					break;
					case 2:
						// bg 'scrolltrack'
						var scrollFactor:Number = 0.3;
						var sliderDistance:Number;
						if(!scrollingToStart && this[scrollMouseProp] > (this.slider[scrollPosProp] + this.slider[scrollDimProp])){
							sliderDistance = this[scrollMouseProp] - (this.slider[scrollPosProp] + this.slider[scrollDimProp]);
							scrollStep = Math.min((spD*0.8),(scrollFactor * sliderDistance));
							//extrapolate to pane._content[scrollPosProp]
							scrollStep = sliderDistance * (pcD/spD);
							newPos = Math.max(minPos,(this.paneContent[scrollPosProp] - scrollStep));
					
						}else if(scrollingToStart && this[scrollMouseProp] < (this.slider[scrollPosProp] ) ){
							sliderDistance = this.slider[scrollPosProp] - this[scrollMouseProp];
							//extrapolate to pane._content[scrollPosProp]
							scrollStep = sliderDistance * (pcD/spD);
							newPos = Math.min(basePos,(this.paneContent[scrollPosProp] + scrollStep));
						}
						scrollToPoint(newPos);
					break;
					case 3:
						// slider - being dragged
						var sliderRatio = (this.slider[scrollPosProp] - this.scrollThickness) / (this.bg[scrollDimProp] - this.slider[scrollDimProp])
						newPos = basePos - (sliderRatio * (basePos - minPos));
						scrollToPoint(newPos);
					break;
					case 4:
						// mouse scroll wheel
					break;
					
					case 6:
						// page up or down keys
						scrollCount++;
						//scrollstep increases the longer the interval is
						scrollStep = Math.round(Math.min((scrollCount * spD / 8),(spD)));
						newPos = scrollingToStart ? Math.min(basePos,this.paneContent[scrollPosProp] + scrollStep) : Math.max(minPos,this.paneContent[scrollPosProp] - scrollStep);
						scrollToPoint(newPos);
					break;
				}
			}
			
			// the 'tween' gradually implements the scroll requested by any of the UI items, 
			// this gives a slightly more fluid feel to the scroll control
			if(tweening && tweenCount > 0){
				
				//scrollstep decreases as the 'tween' draws to a close
				//scrollStep = tweenCount * 2;
				
				scrollStep = (Math.max(this.paneContent[scrollPosProp],tweenTo) - Math.min(this.paneContent[scrollPosProp],tweenTo)) / 2;
				
				if(paneContent[scrollPosProp] > tweenTo){
					newPos = Math.max(minPos,this.paneContent[scrollPosProp] - scrollStep);
				}else{
					newPos = Math.min(basePos,this.paneContent[scrollPosProp] + scrollStep);
				}
					
				setScrollPoint(newPos);
				
				if(newPos == tweenTo){
					tweening = false;
					tweenCount = 0;
				}else{
					tweenCount--;
				}
				
			}else{
				tweening = false;
				tweenCount = 0;
			}
		}else{
			clearInterval(this._interval);
			this._interval = undefined;
			
			broadcaster.broadcastMessage("onScrollingStopped");
		}
	}
	
	private function scrollToPoint(scrollPos:Number){
		var dif = Math.abs(this.paneContent[scrollPosProp] - scrollPos);
		if(dif>=5){
			//snap to end?
			scrollPos = snapToEnd(scrollPos,basePos,minPos,10);
			//trace("dif:"+dif+" scrollPos:"+scrollPos);
		
			tweenTo = scrollPos;
			tweening = true;
			tweenCount = 5;
		}
	}
	
	private function setScrollPoint(scrollPos:Number){
		this.paneContent[scrollPosProp] = Math.round(scrollPos);
		updateSliderPosition();
	}
	
	private function snapToEnd(scrollPos:Number,start:Number,end:Number,min:Number):Number{
		var difToTop = Math.max(start, scrollPos) -  Math.min(start, scrollPos);
		var difToBot = Math.max(end, scrollPos) -  Math.min(end, scrollPos);
		if(difToTop == min || difToBot == min){
			scrollPos = scrollPos;
		}else if(difToTop <=min){
			scrollPos = start;
		}else if(difToBot <=min){
			scrollPos = end;
		}
		return scrollPos;
	}	
	
	// Drawing api methods
	
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number, a:Number) {
		//flip w and h if it's horizontal
		if(scrollHorizontal){
			var storedW:Number = w;
			w = h;
			h = storedW;
		}
		var alpha:Number = a == undefined ? 100 : a ;
		if(mc){
			with(mc){
				clear();
				beginFill(col, alpha);
				moveTo(0, 0);
				lineTo(w, 0);
				lineTo(w, h);
				lineTo(0, h);
				lineTo(0, 0);
				endFill();
			}
		}
	}
	
	private function drawTriangle(mc:MovieClip, w:Number, col:Number,pointUp:Boolean){
		//flip w and h if it's horizontal
		if(scrollHorizontal){
			/*
			var storedW:Number = w;
			w = h;
			h = storedW;
			*/
			var h = w;
			var w:Number = h/ 2;
			
			//coordinates array, different if the the triangle is the up or down arrow
			
			// wirh horizontal 'up' means right
			
			var cds:Array = pointUp == undefined ? [0,h/2,w,0,w,h,0,h/2] : [0,0,w,0,w,h/2,0,0] ;
			
			with (mc) {
				beginFill(col, 100);
				moveTo(cds[0],cds[1]);
				lineTo(cds[2],cds[3]);
				lineTo(cds[4],cds[5]);
				lineTo(cds[6],cds[7]);
				endFill();
			}
			//trace("horizontal triangle:"+cds);
		}else{
		
			var h:Number = w/ 2;
			
			//coordinates array, different if the the triangle is the up or down arrow
			var cds:Array = pointUp == undefined ? [w/2,0,w,h,0,h,w/2,0] : [0,0,w,0,w/2,h,0,0] ;
			
			with (mc) {
				beginFill(col, 100);
				moveTo(cds[0],cds[1]);
				lineTo(cds[2],cds[3]);
				lineTo(cds[4],cds[5]);
				lineTo(cds[6],cds[7]);
				endFill();
			}
		}
	}
	
	private function doEnabled(){
		if(!isNaN(assetData.disabledAlpha)){
			this._visible =  true;
			this._alpha = __enabled ? 100 : assetData.disabledAlpha ;
			setButtons(__enabled);
		}else{
			this._visible =  __enabled;
		}
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
}