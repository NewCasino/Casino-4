/*
com.mbudm.mb.mbTextBox.as 
extends MovieClip

Steve Roberts May 2009

Description
mbTextBox is similar to the textArea component that comes with flash. It extends the textField to incorporate a scrolbar - handling textfield sizing and scroll lage issues as well as applying styles from the them object and relaying internal navigation functions to the index instance.

Flow:
	instantiates a textfield, 
	applies the stylesheet, 
	attaches the scrollbar,
	provides an interface for the asfunctions 
	
*/
import TextField;
import com.mbudm.mbIndex;
import com.mbudm.mbTheme;

import flash.display.BitmapData;
import mx.transitions.easing.Regular;
import flash.filters.BlurFilter;


class com.mbudm.mbTextBox extends MovieClip{
	
	private var index:mbIndex;
	private var theme:mbTheme;
	private var label_mc:MovieClip;
	private var label_array:Array; // the textfields
	private var chapters_arr:Array; // the chapters of content
	private var label_scroller:MovieClip;
	private var copy_mc:MovieClip;
	private var pane_mc:MovieClip;
	private var current_chapter:Number;
	
	private var _sizeChangeEchoCount:Number;
	private var _sizeChangeEchoInterval:Number;
	private var _storedSize:Number
	
	private var __enabled:Boolean;
	
	private var nochapters_mode:Boolean;
	
	private var initSizeSet:Boolean;
	private var contentSet:Boolean;
	private var openRequested:Boolean;
	
	private var callbackObject:Object;
	
	/* transition vars */
	private var direction:Boolean; //true is 'opening' the Item false is 'closing' it
	
	private var _interval:Number;
	private var _intervalFrequency:Number = 20;
	
	private var _animDuration:Number = 10;
	private var _animCount:Number = 0; 
	
	
	private var __isScrolling:Boolean;
	
	private var chapterSet:Boolean;

	private var scrollWidth:Number;
	private var scrollGutter:Number;
	private var chapterSelY:Number;
	
	private var w:Number;
	private var h:Number;
	
	private var textBoxStyle:String;
	private var textBoxStObj:Object;
	
	private var broadcaster:Object;
	
	function mbTextBox(){
		this._visible = false;
		
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
	
	}
	
	public function init(ind:mbIndex,t:mbTheme,sM:String,tbS:String) {
		index = ind;
		theme = t;
		nochapters_mode = sM == "MovieClip" || !sM ? true : false ;
		textBoxStyle = tbS != undefined ? tbS : ".textBox" ;
		
		
		scrollWidth = 10;
		scrollGutter = 8;
		chapterSelY = 30;
		w = 300; // placeholder only - this gets updated
		
		
		this.createEmptyMovieClip("label_mc",this.getNextHighestDepth());
	 	this.label_mc.asfRelay = this.asfRelay;
		
		textBoxStObj  = theme.styles.getStyle(textBoxStyle);
		label_array = [];
	
	
		this.attachMovie("mbScrollerSymbol","label_scroller",this.getNextHighestDepth());
		this.createEmptyMovieClip("pane_mc",this.getNextHighestDepth());
		label_mc.setMask(pane_mc);
	
		//scroller theme
		var sObj:Object = new Object();
		var cols:Object = new Object();
		cols._scrollSlider = Number(theme.getStyleColor("._scrollSlider","0x"));
		if(!cols._scrollSlider)
			cols._scrollSlider = theme.compTints[1];
			
		cols._scrollSliderOver = Number(theme.getStyleColor("._scrollSliderOver","0x"));
		if(!cols._scrollSliderOver)
			cols._scrollSliderOver = theme.compTints[2];
			
		cols._scrollTrack = Number(theme.getStyleColor("._scrollTrack","0x"));
		if(!cols._scrollTrack)
			cols._scrollTrack = theme.compTints[3];
			
		cols._scrollButtons = Number(theme.getStyleColor("._scrollButtons","0x"));
		if(!cols._scrollButtons)
			cols._scrollButtons = theme.compTints[1];
			
		cols._scrollButtonArrow = Number(theme.getStyleColor("._scrollButtonArrow","0x"));
		if(!cols._scrollButtonArrow)
			cols._scrollButtonArrow = theme.compTints[3];
			
		cols._scrollButtonsOver = Number(theme.getStyleColor("._scrollButtonsOver","0x"));
		if(!cols._scrollButtonsOver)
			cols._scrollButtonsOver = theme.compTints[2];
		
		sObj.cols = cols;
		
		sObj.cols.trackalpha = 100;
		sObj.scrollWidth = scrollWidth;
	
		label_scroller.addListener(this);
		
		label_scroller.init(label_mc,this.pane_mc,false,sObj);
		
		
		copy_mc = this.createEmptyMovieClip("copy_mc", this.getNextHighestDepth());
	
	}
	
	public function addListener(obj:Object){
		broadcaster.addListener(obj);
	}
	
	public function moveTo(x:Number,y:Number){
		this._x = x;
		this._y = y;
	}
	
	public function reset(){
		// set scroll position to 0;
		label_mc._y = 0;
		label_scroller.onContentChanged();
	}
	
	
	public function setChapter(i:Number){
		//  tell the scrollbar to scroll to the nominated chapter
		var point = -label_array[i]._y;
		if(!isNaN(point)){
			label_scroller.scrollTo(point);
		}
		chapterSet = true;
	}
	
	public function onScrollingStopped(){
		if(chapterSet){
			chapterSet = false;
		}else{
			
			var selPoint = 0 - label_mc._y;
			var new_current_chapter:Number;
			var best_diff:Number
			
			for(var i = 0; i < label_array.length; i++){
				//chapters_visible
				
				//if this chapter covers the whole screen then it wins
				if(label_array[i]._y < selPoint && (label_array[i]._y + label_array[i]._height) > (selPoint + h) ){
					new_current_chapter = i;
					break;
				}
				
				var diff = label_array[i]._y - selPoint;
				
				if( (best_diff == undefined && diff >= 0) || (diff >= 0 && diff < best_diff) ){
					best_diff = diff;
					new_current_chapter = i;
				}
			}
			
			if(new_current_chapter != current_chapter){
				current_chapter = new_current_chapter;
				broadcaster.broadcastMessage("onChapterSelected",current_chapter);
			}
		}
	}
	
	public function showPopup(p:Array):Void {
		this._parent._parent._parent.addPopup(p[0]);
		//trace ("showPopup function: " + this);
	}
	
	public function setSize(wi:Number,he:Number){
		w = wi;
		h = he;
		
		if((w+h) > 0){
			setTextBoxSize();			
			var cW:Number = label_array[0]._width;
			var cH:Number = label_mc._height
			label_scroller.setSize(scrollWidth,h,cW,cH);
			label_scroller.moveTo(w - scrollWidth, 0);
			drawRect(pane_mc,w - scrollWidth ,h,0x000000,100);
			// textField size change echo... watches for resize after loaded jpgs
			if(!_sizeChangeEchoInterval){
				_storedSize = cH;
				_sizeChangeEchoCount = 20;
				_sizeChangeEchoInterval = setInterval(this,"onSizeChangeEchoInterval",500);
			}
	
			if(initSizeSet == undefined){
				initSizeSet = true;
				onOpen();
			}
		}
	}
	
	// this echo is required because if the textField contains an image or two then this changes the height of the text field.
	private function onSizeChangeEchoInterval(){
		setTextBoxSize();
		
		if(_storedSize != label_mc._height){
			//tell the scroller that it's changed
			label_scroller.setSize(scrollWidth,h,label_mc._width,label_mc._height);
			var removeInt = true;
		}
	
		if(_sizeChangeEchoCount <=0 || removeInt){
			clearInterval(this._sizeChangeEchoInterval);
			this._sizeChangeEchoInterval = undefined;
		}
		
		_sizeChangeEchoCount--;
	}
	
	private function createLabels(){
		if(contentSet == undefined){
			contentSet = true;
			var lvl;
			for(var i = 0; i < chapters_arr.length; i++){
				lvl = this.label_mc.getNextHighestDepth();
				var label = this.label_mc.createTextField("label_txt_"+lvl,lvl,0,0,(w - scrollWidth - scrollGutter),200);
				label.html = true;
				label.wordWrap = true;
				label.autoSize = true;
				label.multiline = true;
				label.condenseWhite = true;
				
				
				//If the font is preceded with __ then it is assumed to be an embedded font
				if(textBoxStObj.fontFamily.substr(0,2) == "__"){
					label.embedFonts = true;
				}
				
				if(!textBoxStObj.color){
					textBoxStObj.color = theme.convertColorToHtmlColor(theme.compShades[theme.compShades.length-1]);
					theme.styles.setStyle(textBoxStyle,textBoxStObj);
				}
				
				label.styleSheet = theme.styles;
				label.htmlText = "<span class=\""+textBoxStyle.substr(1) +"\" >"+chapters_arr[i]+"</span>";
				label_array.push(label);
			}
			setTextBoxSize();
			onScrollingStopped();
			onOpen();
		}else{
			trace("Minor issue: the textbox content for "+this+" is being set again");
		}
	}
	
	private function setTextBoxSize(){
		var ypos = 0;
		for(var i = 0; i < label_array.length; i++){
			if(w != label_array[i]._width){
				label_array[i]._width = w - scrollWidth - scrollGutter;
			}
			label_array[i]._y = ypos;
			ypos+= label_array[i]._height;
		}
	}
	
	public function set htxt(t:String){
		chapters_arr = [t]
		createLabels();
		/*
		label.htmlText = "<span class=\""+textBoxStyle.substr(1) +"\" >"+t+"</span>";
		if(contentSet == undefined){
			contentSet = true;
			onOpen();
		}
		*/
	}
	public function get htxt():String{
		return label_array[0].htmlText;
	}
	public function get txt():String{
		return label_array[0].text;
	}
	
	public function set chapters_htxt(ct:Array){
		chapters_arr = ct;
		createLabels();
	}
	
	//scoped to label_mc - then relayed to the class functions
	private function asfRelay(){
		var args = arguments[0].split(",");
		var method = args[0];
		var params = args.slice(1);
		this._parent[method](params);
	}
	
	public function internalNav(p:Array){
		var coord = p[0].split("|");
		index.currentIndex = coord.toString();
	}
	
	public function internalNavByID(p:Array){
		var id = p[0];
		index.currentID = id;
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
	
	public function open(o:Object){
		callbackObject = o;
		if(openRequested == undefined){
			openRequested = true;
		}
	}
	private function onOpen(){
		if(openRequested && contentSet && initSizeSet){
			//var tf:TextField;
			//var copy:MovieClip;
			//
			for(var i = 0; i < label_array.length; i++){
				var filter:BlurFilter = new BlurFilter(0, 0, 3);
				var filterArray:Array = new Array();
				filterArray.push(filter);
				label_array[i].filters = filterArray;
				label_array[i].cacheAsBitmap = true;
			}
			label_mc._alpha = 0;
			label_scroller._alpha = label_mc._alpha;
			direction = true;
			this._visible = true;
			startInterval();
		}
	}
	
	public function close(o:Object){
		clearInterval(this._sizeChangeEchoInterval);
		callbackObject = o;
		for(var i = 0; i < label_array.length; i++){
			var filter:BlurFilter = new BlurFilter(0, 0, 3);
			var filterArray:Array = new Array();
			filterArray.push(filter);
			label_array[i].filters = filterArray;
			label_array[i].cacheAsBitmap = true;
		}
		direction = false;
		startInterval();
	}
	
	
	private function startInterval(){
		if(this._interval == undefined){
			this._interval = setInterval(this,"onInterval",_intervalFrequency);
		}
	}
	
	private function onInterval(){
					
		switch(direction){
			case true:
				//opening
				_animCount = Math.min((_animCount + 1),_animDuration);
				
			break;
			case false:
				//closing
				_animCount = 0;//Math.max((_animCount -1),0);
			break;
		}
		
		//the update transition code is in a seperate function because it is also called from onResize
		// ie when the movie resizes, the border and bg needs to change shape as well
		updateTransition();
		if(_animCount <= 0 || _animCount >= _animDuration){
			clearInterval(this._interval);
			this._interval = undefined;
			
			if(_animCount == 0){
				this._visible = false;
			}
			for(var i = 0; i < label_array.length; i++){
				label_array[i].cacheAsBitmap = false;
				label_array[i].filters = [];
			}
			
			if(callbackObject != undefined){
				callbackObject.target[callbackObject.onComplete]();
			}
		}
	}
	
	
	private function updateTransition(){
		// set the alpha of the borders and the media
		var factor:Number = Regular.easeIn(_animCount/_animDuration, 0, 1, 1);
		
		label_mc._alpha = factor * 100;
		label_scroller._alpha = label_mc._alpha;
		
	}
	
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number, a:Number) {
		var alpha:Number = a == undefined ? 100 : a ;
		if(mc){
		//	trace("drawRect (mc:"+mc+", w:"+w+", h:"+h+", col:"+col+", a:"+a);
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
	
	public function get isScrolling():Boolean{
		
		return this.label_scroller.enabled;
	}
	
	public function get actualHeight():Number{
		return isScrolling ? h : label_mc._height ;
	}
}