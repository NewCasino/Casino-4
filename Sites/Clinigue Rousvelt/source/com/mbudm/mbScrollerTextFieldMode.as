/*
com.mbudm.mb.mbScrollerTextFieldMode.as 
extends MovieClip

Steve Roberts May 2009

Description
mbScrollerTextFieldMode is one of two scrollbar classes in this template. This class uses the more traditional method of scrolling a text field... setting the TextField.scroll property. The other scrollbar scrolls the textField by physically changing the _y property of the text field.

The reason for these two scrollbars is that even though the MovieClip method used by mbScroller provides a better smoother scroll, this method will not work with the Table of contents utility. So when the TOC is enabled (in mbTextModule), this scrollbar is used instead.


Constructor parameters
tF - textfield that the scroller listens to and controls
aD - object with custom clips or colours
	mcs -
		bg
		slider
		top
		bottom
		arrowTop
		arrowBottom
	cols
		_scrollSlider
		_scrollSliderOver
		_scrollTrack
		_scrollButtons
		_scrollButtonArrow
		_scrollButtonsOver
		trackalpha
	scrollWidth
*/
import com.haganeagency.MHC.MouseControl;
import mx.utils.Delegate;
import TextField;

class com.mbudm.mbScrollerTextFieldMode extends MovieClip{
	
	private var spW:Number; // scroll pane width
	private var spH:Number; // scroll pane height
	private var paneContent:TextField;
	private var assetData:Object = new Object();
	private var sliderHeight:Number;
	private var scrollWidth:Number = 16;
	
	private var bg:MovieClip;
	private var slider:MovieClip;
	private var top:MovieClip;
	private var bottom:MovieClip;
	private var arrowTop:MovieClip;
	private var arrowBottom:MovieClip;
	
	private var pane:MovieClip;
	
	private var btnCols:Object = new Object();
	
	private var scrolling:Boolean = false;
	private var scrollingBg:Boolean = false;
	private var scrollingPage:Boolean = false; // new page up /down keys
	private var scrollingUp:Boolean = true;
	private var tweening:Boolean = false;
	private var dragging:Boolean;
	
	private var intervalCount:Number = 0;
	private var _interval:Number;
	private var tweenCount:Number = 0;
	
	private var _scroll_echo:Number;// the scroll echo is a fix to handle the fact that the textField doesn't always report the correct scroll value right away
	private var _scroll_echo_count:Number = 0;
	
	private var __enabled:Boolean;
	
	function mbScrollerTextFieldMode(){
	}
	
	public function init(tf:TextField,aD:Object) {
		paneContent = tf;
		if(aD){
			assetData = aD;
		}
		this.enabled  = false;
		scrollWidth = assetData.scrollWidth ? assetData.scrollWidth : 10 ;
		
		AsBroadcaster.initialize(paneContent);
		paneContent.addListener(this);
		paneContent.onScroller = function (my_txt:TextField) {
			this.broadcastMessage("onScroller");
		};
	
		Key.addListener(this);
	
		createAssets();
		
	}
	
	/* Key event listeners */
	public function onKeyDown(){
		var key = Key.getCode();
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
	public function onKeyUp(){
		var key = Key.getCode();
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
	
	private function incrementScrollKey(dir:Boolean,isScrolling:Boolean,sM:Number){
		if(sM == 5){
			scrolling = isScrolling;
		}else{
			scrollingPage = isScrolling;
		}
		if(isScrolling){
			scrollingUp = dir;
			startInterval();
		}else{

		}
	}
	
	public function onScrollWheel(delta:Number){
		
		this.paneContent.scroll += Math.round(delta * -2);
		updateSliderPosition();
		
	}
	
	
	public function setSize(sw:Number,sh:Number){
		_root.tracer.htmlText += "sw:"+sw;
		spW = sw;
		spH = sh;
	
		this._x = paneContent._x + spW
			
		this._y = paneContent._y;
		positionAssets();
		updateSliderSize()
		updateSliderPosition();
		
		drawRect(this.pane,(spW + scrollWidth),spH,assetData.cols._scrollSlider);
		this.pane._x = - spW;
	}
	
	public function onScrollerEcho(){
		
		if(this._scroll_echo_count <= 10){
			this._scroll_echo_count++;
			onScroller(paneContent);
		}else{
			clearInterval(this._scroll_echo );
			this._scroll_echo = undefined;
			this._scroll_echo_count = 0;
		}
		
	}
	// listens to the TextField. Unfortunately the TextField broadcasts onScroller sometimes 
	// before it has actually worked out the correct scroll value... hence the 'echo'
	public function onScroller(tf:TextField){
		if(this._scroll_echo_count == 0){
			this._scroll_echo = setInterval(this,"onScrollerEcho",100);
		}else if(this._scroll_echo_count == 10){
			onCompletedScrollerEcho();
		}
	}
	// public access to the  - onCompletedScrollerEcho for when an update has definitely occured (currently only when a toc link is clicked
	public function onContentChanged(){
		onCompletedScrollerEcho();
	}
	
	// used internaly  - bypassing onScroller when the user changes the scroll position using any UI items (other than the drag slider) 
	// this means the slider will react more quickly
	private function onCompletedScrollerEcho(){
		
		this.enabled  = paneContent.maxscroll > 1 ? true : false ;
	
		if(this.enabled){
			if(!dragging){
				updateSliderSize();
				updateSliderPosition();
			}
		}
	}
	
	private function calculateSliderHeight(){
		var max =  this.bg._height
		var actual = max * (paneContent.bottomScroll - paneContent.scroll)/(paneContent.maxscroll + paneContent.bottomScroll);
		var min = scrollWidth;
		sliderHeight = Math.max(min,Math.min(actual,max));
		
	}
	
	// if no custom clips are supplied then basic drawing api shapes are used with cols if they are specified b&w if not
	private function createAssets(){
		if(assetData.mcs){
		this.attachMovie(assetData.mcs.bg,"bg",1);
			this.attachMovie(assetData.mcs.slider,"slider",2);
			this.attachMovie(assetData.mcs.top,"top",3);
			this.attachMovie(assetData.mcs.bottom,"bottom",4);
			this.attachMovie(assetData.mcs.arrowTop,"arrowTop",5);
			this.attachMovie(assetData.mcs.arrowBottom,"arrowBottom",6);
		}else{
			this.createEmptyMovieClip("bg",1);
			this.createEmptyMovieClip("slider",2);
			this.createEmptyMovieClip("top",3);
			this.createEmptyMovieClip("bottom",4);
			this.createEmptyMovieClip("arrowTop",5);
			this.createEmptyMovieClip("arrowBottom",6);
			
			if(!assetData.cols){
				assetData.cols._scrollSlider = 0xbbbbbb;
				assetData.cols._scrollSliderOver = 0xcccccc;
				assetData.cols._scrollTrack = 0xdddddd;
				assetData.cols._scrollButtons = 0xbbbbbb;
				assetData.cols._scrollButtonArrow = 0xffffff;
				assetData.cols._scrollButtonsOver = 0xcccccc;
				assetData.cols.trackalpha = 100;
			}
updateSliderSize(); // the slider get's redrawn if the paneContent._height/text.length change so it has it's own function
			//other elemnts don't change so they can be drawn here once only
			drawRect(this.bg,scrollWidth,(paneContent._height - (scrollWidth*2)),assetData.cols._scrollTrack,assetData.cols.trackalpha);
			drawRect(this.top,scrollWidth,scrollWidth,assetData.cols._scrollButtons);
			drawRect(this.bottom,scrollWidth,scrollWidth,assetData.cols._scrollButtons);
			drawTriangle(this.arrowTop,(scrollWidth/2),assetData.cols._scrollButtonArrow);
			drawTriangle(this.arrowBottom,(scrollWidth/2),assetData.cols._scrollButtonArrow,false);	
		}
		
		// the pane is used by the mouseControl - it is the area used to capture mouse wheel events
		this.createEmptyMovieClip("pane",7);
		this._parent.setMask(this.pane);
		
		// the mouse wheel functions if the mouse is over pane MovieClip, so as that has now been 
		//created, now is the right time to setup the MouseControl linkage to this class
		var $class = this
		var mouseControl : MouseControl;
		mouseControl = MouseControl.getInstance();
		mouseControl.addScroll("mc", this.pane, Delegate.create($class, onScrollWheel));
		
		// all the interactive elemnts use the same event handlers
		var btns:Array = [bg,slider,top,bottom];
		var i:Number;
		for(i=0;i<btns.length;i++){
			btns[i].onRelease = this.onBtnOut;
			btns[i].onRollOver = this.onBtnOver;
			btns[i].onRollOut = this.onBtnOut;
			btns[i].onReleaseOutside = this.onBtnOut;
			btns[i].onPress = this.onBtnPress;
			btnCols[btns[i]._name] = new Color(btns[i]);
		}
	
		// these position values will not change so they are set once only here
		this.bg._y = scrollWidth;
		this.arrowTop._x = scrollWidth/4;
		this.arrowTop._y = (scrollWidth - this.arrowTop._height)/2;
		this.arrowBottom._x = this.arrowTop._x;
		
		//other items change position on textField height change so they are in a separate function
		positionAssets();
	
	}
	
	private function updateSliderSize(){
		
		calculateSliderHeight();
		if(assetData.mcs){
			this.slider.setHeight(sliderHeight);
		}else{
			drawRect(this.slider,scrollWidth,sliderHeight,assetData.cols._scrollSlider);
		}
		
		if(dragging){
			// reset the drag params. The bounds of the drag area have changed so if we don't do this, the slider can potentially be dragged outside of the bounds, or not dragged to the edge.
			onDragSlider(false);
			onDragSlider(true);
		}
	}
	
	private function updateSliderPosition(){
		var newY = scrollWidth + ((this.bg._height - this.slider._height) * ((paneContent.scroll-1) / (paneContent.maxscroll - 1)));
		this.slider._y = newY;
	}
	
	private function positionAssets(){
		
		this.bg._height = spH - (scrollWidth*2);
		this.bottom._y = spH - scrollWidth;
		this.arrowBottom._y =  this.bottom._y + this.arrowTop._y;
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
		if(this == this._parent.bottom || this == this._parent.top){
			this._parent.incrementScroll(this,false);
		}
		if(this == this._parent.bg){
			this._parent.incrementScrollBg(this._ymouse ,false);
		}
	}
	private function onBtnPress(){
		
		if(this == this._parent.bottom || this == this._parent.top){
			this._parent.incrementScroll(this,true);
		}
		if(this == this._parent.bg){
			this._parent.incrementScrollBg(this._ymouse ,true);
		}
		if(this == this._parent.slider){
			this._parent.onDragSlider(true);
		}
	}
	
	//scroll activity setup methods
	
	private function onDragSlider(isDragging:Boolean){
		dragging = isDragging;
		if(dragging){
			this.slider.startDrag(false, 0,this.bg._y , 0, this.bg._y + this.bg._height - this.slider._height);
			startInterval();
		}else{
			this.slider.stopDrag();
		}
	}
	
	private function incrementScroll(src:MovieClip,isScrolling:Boolean){
		scrolling = isScrolling;
		if(scrolling){
			scrollingUp = src._name == "top" ? true : false ;
			startInterval();
		}else{
			tweening = true;
			tweenCount = Math.min(Math.round(intervalCount * 0.1),5);
		}
	}
	
	private function incrementScrollBg(ym:Number,isScrolling:Boolean){
		scrollingBg = isScrolling;
		if(scrollingBg){
			var bottomOfSlider = this.slider._y + this.slider._height;
			scrollingUp = this._ymouse <= bottomOfSlider? false : true ;
			startInterval();
		}
	}
	
	//scroll activity  Interval
	
	private function startInterval(){
		//if the interval exists do nothing
		//if not create an interval that fires off onInterval
		if(!this._interval){
			this._interval = setInterval(this,"onInterval",50);
		}
		onInterval(); //fire once for immediate response
	}
	private function onInterval(){
		if(scrolling || dragging || tweening || scrollingBg || scrollingPage){
			var newScroll:Number;
			
			//increment scroll
			if(scrolling) {
				newScroll = scrollingUp ? Math.max(1,this.paneContent.scroll-1): Math.min(this.paneContent.maxscroll,this.paneContent.scroll+1);
				tweening =  false;
			}
			
			// the 'tween' continues the scroll slightly after the user has stopped scrolling, 
			// this gives a slightly more fluid feel to the scroll control
			
			if(tweening && tweenCount > 0){
				tweenCount--;
				newScroll = scrollingUp ? Math.max(1,this.paneContent.scroll-1): Math.min(this.paneContent.maxscroll,this.paneContent.scroll+1);
			}else{
				tweening = false;
				tweenCount = 0;
			}
			
			if(scrollingBg){
				
				var scrollStep = Math.ceil((this.paneContent.bottomScroll - this.paneContent.scroll) /2);
				
				if(scrollingUp && this._ymouse > this.slider._y){
					newScroll = Math.max(1,this.paneContent.scroll + scrollStep);
				}else if(!scrollingUp && this._ymouse < this.slider._y ){
					newScroll = Math.min(this.paneContent.maxscroll,this.paneContent.scroll - scrollStep);
				}
			}
			
			if(scrollingPage){
				var scrollStep = Math.ceil((this.paneContent.bottomScroll - this.paneContent.scroll) /4);
				newScroll = scrollingUp ? Math.max(1,this.paneContent.scroll-scrollStep): Math.min(this.paneContent.maxscroll,this.paneContent.scroll+scrollStep);
				tweening =  false;
			}
			
			if(newScroll){
				setScroll(newScroll);
			}
			
			//increment drag effect
			if(dragging){			
				this.scrollToPoint(this.slider._y - this.scrollWidth);
			}
			intervalCount++;
		}else{
			intervalCount = 0;
			clearInterval(this._interval);
			this._interval = undefined;
		}
	}
	
	//called when dragging
	private function scrollToPoint(yPos:Number){
		var newScroll = calculateScroll(yPos);
		if(newScroll != this.paneContent.scroll){
			setScroll(newScroll);
		}
	}
	
	
	// all changes to the scroll position are funnelled through here
	private function setScroll(s:Number){
		if(s != this.paneContent.scroll ){
			this.paneContent.scroll = s;
			// rather than waiting for the onScroller event to filter through (there is a lag)
			// trigger an onScroller event manually so that the slider updates
			onCompletedScrollerEcho();
		}
	}
	
	//convert a slider y value to the equivalent scroll position
	private function calculateScroll(yPos:Number):Number{
		var availH = (this._height - (scrollWidth*2) - this.slider._height);
		var scrollRatio = yPos / availH;
		var scrollPoint = Math.round(scrollRatio * this.paneContent.maxscroll);
		return scrollPoint;
	}
	
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number, a:Number) {
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
		var h:Number = w/ 2;
		//coordinates array, different if the the triangle is the up or down arrow
		var cds:Array = pointUp == undefined ? [w/2,0,w,h,0,h,w/2,0] : [0,0,w,0,w/2,h,0,0] ;
		if(mc){
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
		this._visible =  __enabled;
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
