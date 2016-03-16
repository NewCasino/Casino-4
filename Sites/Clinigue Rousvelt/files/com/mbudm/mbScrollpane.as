/*
com.mbudm.mbScrollpane.as 
extends MovieClip

Steve Roberts June 2009

Description
mbScrollpane provides a means of naviagting a movieclipthat is larger than the available size.
It provides two methods for this - scrolling and pagination.

*/

import com.mbudm.mbTheme;
import com.mbudm.mbLayout;

class com.mbudm.mbScrollpane extends MovieClip{
	private var layout:mbLayout;
	private var theme:mbTheme;
	private var paneContent:MovieClip;
	
	private var paneMask:MovieClip;
	
	private var v_scroller:MovieClip;
	private var h_scroller:MovieClip;
	private var pane_buttons_mc:MovieClip;
	private var pane_buttons:Array;
	
	// store the passed w and h so that this only updates on a real change
	private var w:Number;
	private var h:Number;
	
	
	private var broadcaster:Object;
	
	private var layoutParams:Object;
	//tells which onResize values to use - must be in this format
	/*
	{spw:"stagewidth",sph:"stageheight",pcw:"w",pch:"h"}
	*/
	
	private var paneType:String; // scroll|pagination
	private var btnStyles:Object; // pagination button styles (CSS style refs)
	
	
	
	function mbScrollpane(){
		
	}
	
	public function init(pC:MovieClip,pT:String,t:mbTheme,lyt:mbLayout,lpObj:Object) {
		
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);

		
		layout = lyt;
		paneType = pT != undefined ? pT : "scroll"
		theme = t;
		paneContent = pC;
		paneMask = this.createEmptyMovieClip("paneMask",this.getNextHighestDepth());
		
		paneContent.setMask(paneMask);
		
		layoutParams = lpObj;
		
		if(paneType == "scroll"){
			this.attachMovie("mbScrollerSymbol","v_scroller",this.getNextHighestDepth());
			
			this.attachMovie("mbScrollerSymbol","h_scroller",this.getNextHighestDepth());
			
			//scroller theme
			var obj:Object = new Object();
			var cols:Object = new Object();
			cols._scrollSlider = Number(theme.getStyleColor("._scrollSlider","0x"));
			if(isNaN(cols._scrollSlider))
				cols._scrollSlider = theme.compTints[1];
				
			cols._scrollSliderOver = Number(theme.getStyleColor("._scrollSliderOver","0x"));
			if(isNaN(cols._scrollSliderOver))
				cols._scrollSliderOver = theme.compTints[2];
				
			cols._scrollTrack = Number(theme.getStyleColor("._scrollTrack","0x"));
			if(isNaN(cols._scrollTrack))
				cols._scrollTrack = theme.compTints[3];
				
			cols._scrollButtons = Number(theme.getStyleColor("._scrollButtons","0x"));
			if(isNaN(cols._scrollButtons))
				cols._scrollButtons = theme.compTints[1];
				
			cols._scrollButtonArrow = Number(theme.getStyleColor("._scrollButtonArrow","0x"));
			if(isNaN(cols._scrollButtonArrow))
				cols._scrollButtonArrow = theme.compTints[3];
				
			cols._scrollButtonsOver = Number(theme.getStyleColor("._scrollButtonsOver","0x"));
			if(isNaN(cols._scrollButtonsOver))
				cols._scrollButtonsOver = theme.compTints[2];
			
			obj.cols = cols;
			
			obj.cols.trackalpha = 100;
			obj.scrollWidth = 10;
			v_scroller.init(paneContent,paneMask,false,obj);
			
			h_scroller.init(paneContent,paneMask,true,obj);
			
			v_scroller.addListener(this);
			h_scroller.addListener(this);
			
			
		}else{
			// pagination buttons
			pane_buttons_mc = this.createEmptyMovieClip("pane_buttons_mc",this.getNextHighestDepth());
			pane_buttons = new Array();
			btnStyles =  new Object();
			btnStyles.upStyle = "._paginationButtons";
			btnStyles.overStyle = "._paginationButtonsOver";
			btnStyles.selStyle = "._paginationButtonsSelected";
			btnStyles.bgUpStyle = "._paginationButtonsBg";
			btnStyles.bgOverStyle = "._paginationButtonsBgOver";
			btnStyles.bgSelStyle = "._paginationButtonsBgSelected";
			btnStyles.bgalpha = 100;
			
			addPaneButton();
		}
		onResize();
	}
	
	public function addListener(obj:Object){
		broadcaster.addListener(obj);
	}
	
	// listens to layout
	public function onResize(){
		if(layoutParams != undefined){
			//tells which onResize values to use - must be in this format
			/*
			{spw:"stagewidth",sph:"stageheight",pcw:"w",pch:"h"}
			*/
			//	trace("mbScrollPane onResize");
			setSize(layout.getDimension(layoutParams.spw),layout.getDimension(layoutParams.sph),layout.getDimension(layoutParams.pcw),layout.getDimension(layoutParams.pch));
		}
	}
	
	public function onScrollingStarted(){
		broadcaster.broadcastMessage("onScrollingStarted",this);
	}
	
	public function onScrollingStopped(){
		broadcaster.broadcastMessage("onScrollingStopped",this);
	}
	
	private function setSize(spw:Number,sph:Number,pcw:Number,pch:Number){
		if(w != spw ||  h != sph){
			
			w = spw;
			h = sph;
			
			if(paneType == "scroll"){
				//the scroll pane (mask) dimensions
				var pW = w;
				var pH = h;
				if(h < pch || w < pcw){
					var pW = w - 10;
					var pH = h - 10;
				}
				
				drawRect(paneMask,pW,pH,0x000000,100);
				
				v_scroller.setSize(10,pH,pcw,pch);
				v_scroller.moveTo(w - 10, 0);
			
				h_scroller.setSize(pW,10,pcw,pch);
				h_scroller.moveTo(0, h - 10);
			}else{
				drawRect(paneMask,w,h,0x000000,100);
				
				// pagination buttons 
				pane_buttons_mc._y = sph;
				
				// number of buttons ok?
				var pages =  Math.ceil(pch/h);
				if(pages > pane_buttons.length){
					// make some buttons
					var newBtns = pages - pane_buttons.length;
					for(var i = 0; i < newBtns; i++){
						addPaneButton();
					}
				}
				if(pages < pane_buttons.length){
					// remove some buttons
					for(var i = pane_buttons.length; i >= pages; i--){
						pane_buttons[i-1].removeMovieClip();
						pane_buttons.pop();
					}
				}
				// correct button selected ?
				var selPage = Math.floor(paneContent._y + h / h ) - 1;
				onPaneButtonClicked(selPage);
				
				if(pane_buttons.length <= 1){
					pane_buttons_mc._visible = false;
				}else{
					pane_buttons_mc._visible = true;
				}
			}
		}
	}
	
	
	private function addPaneButton(){
		var lvl =  pane_buttons_mc.getNextHighestDepth();
		var btn =  pane_buttons_mc.attachMovie("mbSimpleButtonSymbol","btn"+lvl,lvl);
		
		btn.init(pane_buttons.length,(pane_buttons.length+1),15,2,theme,this,"onPaneButtonClicked",btnStyles);
		
		btn._x = pane_buttons_mc._width + 2;
		
		pane_buttons.push(btn);
	}
	
	private function onPaneButtonClicked(p:Number){
		// move the paneContent._y to the multiple of h
		paneContent._y =  - h * p;
		for(var i = 0; i < pane_buttons.length; i++){
			pane_buttons[i].selected = (i) == p ? true : false ;
		}
	}
	
	public function resetPane(){
		onPaneButtonClicked(0);
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
	
	public function get xoffset():Number{
		return paneContent._x;
	}
	public function get yoffset():Number{
		return paneContent._y;
	}
	public function get paneButtonsHeight():Number{
		return pane_buttons_mc._height;
	}
}