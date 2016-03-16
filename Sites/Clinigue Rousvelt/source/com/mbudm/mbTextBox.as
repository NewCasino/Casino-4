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
	public var label:TextField;
	private var label_scroller:MovieClip;
	private var copy_mc:MovieClip;
	private var pane_mc:MovieClip;
	
	
	private var _sizeChangeEchoCount:Number;
	private var _sizeChangeEchoInterval:Number;
	private var _storedSize:Number
	
	private var __enabled:Boolean;
	
	private var mc_scroll_mode:Boolean;
	
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

	private var scrollWidth:Number;
	private var scrollGutter:Number;
	
	private var w:Number;
	private var h:Number;
	
	private var textBoxStyle:String;
	
	function mbTextBox(){
		this._visible = false;
	
	}
	
	public function init(ind:mbIndex, t:mbTheme, sM:String, tbS:String) {
		//trace ("mbTextBox: " + ind + "  " + t + "  " + sM + "  " + tbS);
		index = ind;
		theme = t;
		mc_scroll_mode = sM == "MovieClip" || !sM ? true : false ;
		//trace ("mc_scroll_mode:  " + mc_scroll_mode);
		textBoxStyle = tbS != undefined ? tbS : ".textBox" ;
		
		
		scrollWidth = 10;
		scrollGutter = 8;
		
		
		this.createEmptyMovieClip("label_mc",this.getNextHighestDepth());
		this.label_mc.createTextField("label_txt",this.label_mc.getNextHighestDepth(),0,0,300,200);
		this.label_mc.asfRelay = this.asfRelay;
		label = this.label_mc.label_txt;
		label.html = true;
		label.wordWrap = true;
		label.autoSize = mc_scroll_mode;
		label.multiline = true;
		label.condenseWhite = true;
		
		
		var textBoxStObj:Object  = theme.styles.getStyle(textBoxStyle)
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(textBoxStObj.fontFamily.substr(0,2) == "__"){
			label.embedFonts = true;
		}
		
		if(!textBoxStObj.color){
			textBoxStObj.color = theme.convertColorToHtmlColor(theme.compShades[theme.compShades.length-1]);
			//trace("textBoxStObj.color:"+textBoxStObj.color);
			theme.styles.setStyle(textBoxStyle,textBoxStObj);
		}
		
		label.styleSheet = theme.styles;
	
			 
		if(mc_scroll_mode){
		
			//this.attachMovie("mbScrollerSymbol","label_scroller",this.getNextHighestDepth());
			this.attachMovie("mbScrollerSymbol","label_scroller",this.getNextHighestDepth());
			this.createEmptyMovieClip("pane_mc",this.getNextHighestDepth());
			label_mc.setMask(pane_mc);
		
		}else{
			this.attachMovie("mbScrollerTextFieldModeSymbol","label_scroller",this.getNextHighestDepth());
		}
		
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
	
		
		if(mc_scroll_mode){
			//label_scroller.init(label_mc,sObj);//);
			label_scroller.init(label_mc,this.pane_mc,false,sObj);
			
		}else{
			label_scroller.init(label,sObj);
		}
		
		
		copy_mc = this.createEmptyMovieClip("copy_mc", this.getNextHighestDepth());
	
	}
	
	public function moveTo(x:Number,y:Number){
		this._x = x;
		this._y = y;
	}
	
	public function reset(){
		// set scroll position to 0;
		if(mc_scroll_mode){
			label_mc._y = 0;
			label_scroller.onContentChanged();
		}else{
			label.scroll = 1;
		}
	}
	
	public function onScrollChange(){
		// currently just used when the TOC links are clicked - the Selection.setFocus call seems to take a while for the textField onScroller event to occur.
		label_scroller.onContentChanged();
	}
	
	public function setSize(wi:Number,he:Number){
		w = wi;
		h = he;
		
		if((w+h) > 0){
			
			label._width = w - scrollWidth - scrollGutter;
			if(!mc_scroll_mode){
				label._height = h;
				var sw = w-scrollWidth;
				_root.tracer.htmlText+="<br/>mbTextBox setSize sw:"+sw +" ... =  w:"+w+" - scrollWidth:"+scrollWidth;
		
				label_scroller.setSize(sw,h);
				
			}else{
				var cW:Number = label._width
				var cH:Number = label._height
				label_scroller.setSize(scrollWidth,h,cW,cH);
				label_scroller.moveTo(w - scrollWidth, 0);
				drawRect(pane_mc,w - scrollWidth ,h,0x000000,100);
				// textField size change echo... watches for resize after loaded jpgs
				if(!_sizeChangeEchoInterval){
					_storedSize = cH;
					_sizeChangeEchoCount = 100;
					_sizeChangeEchoInterval = setInterval(this,"onSizeChangeEchoInterval",500);
				}
			}
			
			if(initSizeSet == undefined){
				initSizeSet = true;
				onOpen();
			}
		}
	}
	
	// this echo is required because if the textField contains an image or two then this changes the height of the text field.
	private function onSizeChangeEchoInterval(){		
		var newH = label._height ; 
		
		if(_storedSize != label._height  && mc_scroll_mode){
			//tell the scroller that it's changed
			label_scroller.setSize(scrollWidth,h,label._width,label._height);
			var removeInt = true;
		}
	
		if(_sizeChangeEchoCount <=0 || removeInt){
			clearInterval(this._sizeChangeEchoInterval);
			this._sizeChangeEchoInterval = undefined;
		}
		
		_sizeChangeEchoCount--;
	}
	
	public function set htxt(t:String){
		
		label.htmlText = "<span class=\""+textBoxStyle.substr(1) +"\" >"+t+"</span>";
		if(contentSet == undefined){
			contentSet = true;
			onOpen();
		}
	}
	public function get htxt():String{
		return label.htmlText;
	}
	public function get txt():String{
		return label.text;
	}
	
	//scoped to label_mc - then relayed to the class functions
	private function asfRelay() {		
		var args = arguments[0].split(",");
		var method = args[0];		
		var params = args.slice(1);
		this._parent[method](params);
	}
	
	public function showPopup(p:Array):Void {
		this._parent._parent._parent.addPopup(p[0]);
		//trace ("showPopup function: " + this);
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
	
	public function open(o:Object) {		
		callbackObject = o;
		//trace("mbTextBox "+this._parent._name +"."+this._name +" htxt:"+this.htxt+" open callbackObject:"+callbackObject);
		if(openRequested == undefined){
			openRequested = true;
		}
	}
	private function onOpen(){
		if(openRequested && contentSet && initSizeSet){
			//var tf:TextField;
			//var copy:MovieClip;
	/*
			var bmp:BitmapData = new BitmapData(label._width, label._height, false);
			bmp.draw(label);
			
			
			copy_mc.attachBitmap(bmp, copy_mc.getNextHighestDepth());
			copy_mc._x = label_mc._x;
			copy_mc._y = label_mc._y;
			label._visible = false;
			copy_mc._alpha = 100;
			*/
			//
			var filter:BlurFilter = new BlurFilter(0, 0, 3);
			var filterArray:Array = new Array();
			filterArray.push(filter);
			label.filters = filterArray;
			label.cacheAsBitmap = true;
			label._alpha = 0;
			label_scroller._alpha = label._alpha;
			direction = true;
			this._visible = true;
			startInterval();
			//trace("mbTextBox open interval started");
		}
	}
	
	public function close(o:Object){
		clearInterval(this._sizeChangeEchoInterval);
		callbackObject = o;
		var filter:BlurFilter = new BlurFilter(0, 0, 3);
		var filterArray:Array = new Array();
		filterArray.push(filter);
		label.filters = filterArray;
		label.cacheAsBitmap = true;
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
			label.cacheAsBitmap = false;
			label.filters = [];
			//trace("mbTextBox onInterval complete callbackObject:"+ callbackObject);
	
			if(callbackObject != undefined){
				
				//trace("mbTextBox interval complete so calling:"+ callbackObject.onComplete);
				callbackObject.target[callbackObject.onComplete]();
			}
		}
	}
	
	
	private function updateTransition(){
		// set the alpha of the borders and the media
		var factor:Number = Regular.easeIn(_animCount/_animDuration, 0, 1, 1);
		
		label._alpha = factor * 100;
		label_scroller._alpha = label._alpha;
		
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
		return isScrolling ? h : label._height ;
	}
}