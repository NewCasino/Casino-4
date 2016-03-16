/*
com.mbudm.min.minSiblingNav.as 
extends com.mbudm.mbSiblingNav

Steve Roberts August 2009 - modified from curSiblingNav.as

Description
minSiblingNav creates the graphical elements that make up the navigation system for the media modules. 
It is called sibling nav because it navigates through the sibling <img> and <video> nodes in the index xml file.

The nav elements that are created are:

- Label: The collection title, counter and home & return to parent links
- ThumbNav: The thumbnail navigation - a list of small images that let the user navigate to a particular sibling
- NextPrevious: The next and previous buttons that let you click through the siblings in sequence

*/

import mx.transitions.easing.Regular;

import mx.transitions.easing.Strong;

class com.mbudm.min.minSiblingNav extends com.mbudm.mbSiblingNav{
	/* com.mbudm.mbSiblingNav vars
	private var siblingnavXML:XMLNode; 
	private var layout:mbLayout;
	private var index:mbIndex;
	private var theme:mbTheme;
	private var ldr:MovieClip;
	*/
	
	private var label:TextField;
	private var thumbnav_mc:MovieClip;
	private var previous_btn:MovieClip;
	private var next_btn:MovieClip;
	private var bg_mc:MovieClip;
	
	private var currentNode:XMLNode;
	private var parentXMLNode:XMLNode;
	private var parentCoord:String;
	private var nodeNum:Number;
	
	private var layoutMode:Number = 0;
	private var medianav:String;
	
	private var direction:Number = 0;
	private var _interval:Number;
	private var _intervalFrequency:Number = 20;
	private var _animDuration:Number = 5;
	private var _animCount:Number = 0; 
	
	private var yPositions:Array;// array index contains _y positions for  layoutModes
	private var btnCols:Object;
	
	private var thumbsize:Number;
	private var thumbgutter:Number;
	private var thumbxoffset:Number;
	private var thumbyoffset:Number;
	private var thumbNails:Array;
	private var selectedThumbnail:MovieClip;
	
	private var npnavwidth:Number;
	private var npnavgutter:Number;
	
	private var labelxoffset:Number;
	private var labelyoffset:Number;
	private var returnlink:String;
	private var homelink:String;
	
	private var bgcolor:Number;
	private var bgalpha:Number;
	private var bgradius:Number;
	
	private var transitions:Array;
	private var transitionsIdCounter:Number
	
	
	
	function minSiblingNav(){
		
		btnCols = new Object();
		
		transitions =  new Array();
		transitionsIdCounter = 0;
	
	}
	
	//override functions
	
	private function setUpSiblingNav(){
		
		
		// init XML attributes
		medianav = layout.getDimension("medianav") ? layout.getDimension("medianav") : "top" ; // left right bottom top  if undefined then top is assumed
		
		thumbsize = siblingnavXML.attributes.thumbsize != undefined ? Number(siblingnavXML.attributes.thumbsize) : labelStyle.fontSize ;
		thumbgutter = siblingnavXML.attributes.thumbgutter != undefined ? Number(siblingnavXML.attributes.thumbgutter) : 2 ;
		thumbxoffset = siblingnavXML.attributes.thumbxoffset != undefined ? Number(siblingnavXML.attributes.thumbxoffset) : 5 ;
		thumbyoffset = siblingnavXML.attributes.thumbyoffset != undefined ? Number(siblingnavXML.attributes.thumbyoffset) : 5 ;
		npnavwidth = siblingnavXML.attributes.npnavwidth != undefined ? Number(siblingnavXML.attributes.npnavwidth) : 30 ;
		npnavgutter = siblingnavXML.attributes.npnavgutter != undefined ? Number(siblingnavXML.attributes.npnavgutter) : 5 ;
		returnlink = siblingnavXML.attributes.returnlink != undefined ? siblingnavXML.attributes.returnlink : "Return to collection" ;
		labelxoffset = siblingnavXML.attributes.labelxoffset != undefined ? Number(siblingnavXML.attributes.labelxoffset) : 5 ;
		labelyoffset = siblingnavXML.attributes.labelyoffset != undefined ? Number(siblingnavXML.attributes.labelyoffset) : 5 ;
		homelink = siblingnavXML.attributes.homelink != undefined ? siblingnavXML.attributes.homelink : undefined ;
		bgalpha = siblingnavXML.attributes.bgalpha != undefined ? siblingnavXML.attributes.bgalpha : 95 ;
		bgradius = siblingnavXML.attributes.bgradius != undefined ? siblingnavXML.attributes.bgradius : 8 ; // ame as content default
		
		bgcolor = Number(theme.getStyleColor("._contentBackground","0x"));
		if(isNaN(bgcolor))
			bgcolor = theme.compTints[theme.compTints.length - 1];
		
		// BG
		bg_mc = this.createEmptyMovieClip("bg_mc",this.getNextHighestDepth());
		
		
		//
		// Label
		//
		//Collection label and links to parent page
		this.createTextField("label",this.getNextHighestDepth(),0,0,200,20);
		label.autoSize = true;
		label.html = true;
		
		var labelStyle = theme.styles.getStyle(".collection");
		
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(labelStyle.fontFamily.substr(0,2) == "__"){
			label.embedFonts = true;
		}
		
		if(!labelStyle.color){
			labelStyle.color = theme.convertColorToHtmlColor(theme.compTints[0]);
			theme.styles.setStyle(".collection",labelStyle);
		}
		
		label.styleSheet = theme.styles;
		
		
		
		//
		// next and previous
		//
		previous_btn = this.attachMovie("arrow_left_btn","previous_btn",this.getNextHighestDepth());
		next_btn = this.attachMovie("arrow_right_btn","next_btn",this.getNextHighestDepth());
		
		btnCols.previous_btn =  new Color(previous_btn) ;
		btnCols.next_btn =  new Color(next_btn) ;
		
		//check for the override
		var np_col = Number(theme.getStyleColor("._medianextprev","0x"));
		if(isNaN(np_col))
			np_col = theme.compTints[theme.compTints.length - 1];
			
		btnCols.previous_btn.setRGB(np_col);
		btnCols.next_btn.setRGB(np_col);
		
		previous_btn._width = npnavwidth;
		previous_btn._yscale = previous_btn._xscale;
		next_btn._width = npnavwidth;
		next_btn._yscale = next_btn._xscale;
		
		setNPbuttons(true);
		previous_btn.onRollOut();
		next_btn.onRollOut();
		
		
		//
		// thumbnav_mc
		//
		thumbnav_mc = this.createEmptyMovieClip("thumbnav_mc",this.getNextHighestDepth());
		thumbnav_mc.thumbs = thumbnav_mc.createEmptyMovieClip("thumbs",thumbnav_mc.getNextHighestDepth());
		thumbnav_mc.thumbs_mask = thumbnav_mc.createEmptyMovieClip("thumbs_mask",thumbnav_mc.getNextHighestDepth());
		thumbnav_mc.thumbs_scroll = thumbnav_mc.attachMovie("mbScrollerSymbol","thumbs_scroll",thumbnav_mc.getNextHighestDepth());
		thumbnav_mc.thumbs.setMask(thumbnav_mc.thumbs_mask);
		
		//thumbnail scroller 
		
		var obj:Object = new Object();
		
		var mcs:Object = new Object();
		
		switch(medianav){
			case "left":
			case "right":
				mcs.scroll_start_btn = "arrow_up_btn";
				mcs.scroll_end_btn = "arrow_down_btn";
			break;
			default:
				// bottom or  top
				mcs.scroll_start_btn =  "arrow_left_btn";
				mcs.scroll_end_btn =  "arrow_right_btn";
			break;
		}
		
		obj.mcs = mcs;
		
		var cols:Object = new Object();
		cols._scrollSlider = Number(theme.getStyleColor("._scrollSlider","0x"));
		if(!isNaN(cols._scrollSlider))
			cols._scrollSlider = theme.compShades[1];
			
		cols._scrollSliderOver = Number(theme.getStyleColor("._scrollSliderOver","0x"));
		if(!isNaN(cols._scrollSliderOver))
			cols._scrollSliderOver = theme.compShades[2];
			
		cols._scrollTrack = Number(theme.getStyleColor("._scrollTrack","0x"));
		if(!isNaN(cols._scrollTrack))
			cols._scrollTrack = theme.compShades[3];
			
		cols._scrollButtons = Number(theme.getStyleColor("._scrollButtons","0x"));
		if(!isNaN(cols._scrollButtons))
			cols._scrollButtons = theme.compShades[1];
			
		cols._scrollButtonArrow = Number(theme.getStyleColor("._scrollButtonArrow","0x"));
		if(!isNaN(cols._scrollButtonArrow))
			cols._scrollButtonArrow = theme.compShades[3];
			
		cols._scrollButtonsOver = Number(theme.getStyleColor("._scrollButtonsOver","0x"));
		if(!isNaN(cols._scrollButtonsOver))
			cols._scrollButtonsOver = theme.compShades[2];
		
		obj.cols = cols;
		
		
		
		obj.scrollWidth = thumbsize;
		
		obj.disabledAlpha = 0;
		
		switch(medianav){
			case "left":
			case "right":
				//vertical scroll
				thumbnav_mc.thumbs_scroll.init(thumbnav_mc.thumbs,thumbnav_mc.thumbs_mask,false,obj);
			break;
			default:
				// bottom or  top
				// horizontal scroll
				thumbnav_mc.thumbs_scroll.init(thumbnav_mc.thumbs,thumbnav_mc.thumbs_mask,true,obj);
			break;
		}
		
		
		updateTransition();
	}
	
	private function updateCollectionText(){
		var colname:String = currentNode.parentNode.attributes.title;
		var counter:String = (nodeNum + 1)+" of "+ currentNode.parentNode.childNodes.length;
		var returnlinklabel:String = returnlink.split("%%").join(colname);
		var homelinkStr = homelink ? "| <a class=\"homelink\" href=\"asfunction:navigate,0\" >"+homelink+"</a> " : "" ;
		label.htmlText = "<span class=\"collection\" ><a class=\"collectionlink\" href=\"asfunction:navigate,"+parentCoord+"\" >"+colname+"</a> | <span class=\"counter\">"+counter+"</span> "+homelinkStr+"| <a class=\"returnlink\" href=\"asfunction:navigate,"+parentCoord+"\" >"+returnlinklabel+"</a></span>";
	}
	
	private function setNPbuttons(b:Boolean){
		previous_btn.onRelease = b ? this.onMediaNavRelease : undefined ;
		previous_btn.onRollOver = b ? this.onMediaNavOver : undefined ;
		previous_btn.onRollOut = b ? this.onMediaNavOut : undefined ;
		previous_btn.onReleaseOutside = b ?  this.onMediaNavOut : undefined ;
		previous_btn.onPress = b ? this.onMediaNavPress : undefined ;
		previous_btn._visible = b;
		
		next_btn.onRelease = b ? this.onMediaNavRelease : undefined ;
		next_btn.onRollOver = b ? this.onMediaNavOver : undefined ;
		next_btn.onRollOut = b ? this.onMediaNavOut : undefined ;
		next_btn.onReleaseOutside = b ? this.onMediaNavOut : undefined ;
		next_btn.onPress = b ? this.onMediaNavPress : undefined ;
		next_btn._visible = b;
	}
	
	
	// Handles navigation from all the sibling navigation elements - including the links in label (inline text links using asfunction)
	private function navigate(){
		
		if(typeof(arguments[0]) == "string" ){
			// It's a call from a text link
			trace ("navigate: " + arguments[0]);
			index.currentIndex = arguments[0];
		}else{
			// it's a call from a button click
			switch(arguments[0]._name){
				case "next_btn":
					var next_index = currentNode.nextSibling != null ? parentCoord +","+(nodeNum+1) : parentCoord +","+0 ;
					index.currentIndex  =next_index;
					setNPbuttons(false);
				break;
				case "previous_btn":
					var prev_index = currentNode.previousSibling != null ? parentCoord +","+(nodeNum-1) : parentCoord +","+ (parentXMLNode.childNodes.length - 1) ;
					index.currentIndex  = prev_index;	
					setNPbuttons(false);
				break;
				default:
					// it's a thumbnail button - the number after the _ is the index
					index.currentIndex = parentCoord + "," + arguments[0]._name.split("_")[1];
				break;
			}
		}
	}
	
	// listener  to broadcast from index
	// the sibling nav will react to this in several ways
	// - hide show itself when a media item is navigated to/from
	// - update selected thumbnail
	// - update counter
	// - update collection name and return links 
	public function onIndexUpdate() {
		currentNode = index.getItemAt(index.currentIndex);
		parentCoord = index.currentIndex.substr(0,index.currentIndex.lastIndexOf(","));
		nodeNum = Number(index.currentIndex.split(",").pop());
		
		var newLayoutMode;
		if(currentNode.nodeName == "img" || currentNode.nodeName == "video"){
			updateCollectionText();
			if(currentNode.parentNode != parentXMLNode){
				parentXMLNode = currentNode.parentNode;
				setupThumbnails();
				onResize();
			}else{
				updateThumbnailNav();
			}
			changeLayout(1);
		}else{
			changeLayout(0);
		}
	}
	
	// the NP buttons are hidden while a navigation change is happening - to avoid overloading the navigation update process.
	public function onIndexContentReady(){
		setNPbuttons(true);
	}
	
	// ensures the right thumbnail nav is selected and if the selected thumbnail is not visible this 
	// method moves the scroll content so that it is
	private function updateThumbnailNav(){
		var prevSel = selectedThumbnail;
		selectedThumbnail = thumbNails[nodeNum];
		prevSel.onRollOut();
		selectedThumbnail.onRollOver();
		// if the item is not visible move the nav so that it is
		if(thumbnav_mc.thumbs.current._width > thumbnav_mc.thumbs_mask._width){
			//is it to the left?
			if(thumbnav_mc.thumbs._x + selectedThumbnail._x < 0){
				//trace("selectedThumbnail._x:"+selectedThumbnail._x+" thumbnav_mc.thumbs.current._x:"+thumbnav_mc.thumbs.current._x+" thumbnav_mc.thumbs._x:"+thumbnav_mc.thumbs._x +" thumbnav_mc.thumbs_mask._width:"+thumbnav_mc.thumbs_mask._width);
				//it's to the left so move thumbnav_mc.thumbs right
				thumbnav_mc.thumbs._x += 0 - (thumbnav_mc.thumbs._x + selectedThumbnail._x);
			}else if(thumbnav_mc.thumbs._x + selectedThumbnail._x  + thumbsize > thumbnav_mc.thumbs_mask._width){
				//it's to the right so move thumbnav_mc.thumbs left
				thumbnav_mc.thumbs._x -= thumbnav_mc.thumbs._x + selectedThumbnail._x  + thumbsize - thumbnav_mc.thumbs_mask._width;
			}
		}
	}
	
	// build the thumbnail navigation - instances of mdMediaItem are used
	private function setupThumbnails(){
		if(thumbnav_mc.thumbs.current){
			thumbnav_mc.thumbs.current.removeMovieClip();
		}
		thumbnav_mc.thumbs.current = thumbnav_mc.thumbs.createEmptyMovieClip("current", thumbnav_mc.thumbs.getNextHighestDepth());
		thumbnav_mc.thumbs.current.navRef = this
		thumbNails = new Array(parentXMLNode.childNodes.length);
		var lvl:Number;
		for(var i = 0; i < parentXMLNode.childNodes.length; i++){
			var nodeType = parentXMLNode.childNodes[i].nodeName != "page" ? parentXMLNode.childNodes[i].nodeName : parentXMLNode.childNodes[i].attributes.type ;
			
			if(nodeType == "img" || nodeType == "video"){
				lvl = thumbnav_mc.thumbs.current.getNextHighestDepth();
				
				thumbNails[i] = thumbnav_mc.thumbs.current.attachMovie("mbMediaItemSymbol","thumb_"+i,lvl);
				thumbNails[i].init(theme,ldr,parentXMLNode.childNodes[i],parentXMLNode.childNodes[i].attributes.src,{resizemode:0,useFrame:false});
				var margin = Math.round(thumbgutter /2);
				thumbNails[i].setSize(thumbsize - margin,thumbsize - margin);
				thumbNails[i].open();
			
				switch(medianav){
					case "left":
					case "right":
						thumbNails[i]._y = (thumbsize) * i ;
					break;
					default:
						// bottom or  top
						thumbNails[i]._x = (thumbsize) * i ;
					break;
				}
				
				thumbNails[i].onRelease = this.onThumbRelease;
				thumbNails[i].onRollOver = this.onThumbOver ;
				thumbNails[i].onRollOut = this.onThumbOut ;
				thumbNails[i].onReleaseOutside = this.onThumbOut ;
				thumbNails[i].onPress = this.onThumbPress ;
				
				
				if(i == nodeNum) 
					selectedThumbnail = thumbNails[i];
				
				//init in Out mode
				thumbNails[i].onRollOut();
			}
		}
	}
	
	
	// scoped to next prev btns
	
	private function onMediaNavRelease(){
		this._alpha = 30;
		this._parent.navigate(this);
	}
	private function onMediaNavOver(){
		this._alpha = 100;
	}
	private function onMediaNavOut(){
		this._alpha = 30;
	}
	private function onMediaNavPress(){
		//this._alpha = 75;
	}
	
	
	//scoped to thumb buttons
	
	private function onThumbRelease(){
		if (this != this._parent.navRef.selectedThumbnail){
	
			this._parent.navRef.navigate(this);
			
		}else{
			this._alpha = 100;
		}
	}
	private function onThumbOut(){
		if (this != this._parent.navRef.selectedThumbnail){
			this._alpha = 30;
		}else{
			this._alpha = 100;
		}
	}
	
	private function onThumbOver(){
		if (this != this._parent.navRef.selectedThumbnail){
			this._alpha = 75;
		}else{
			this._alpha = 100;
		}
	}
	
	private function onThumbPress(){
		if (this != this._parent.navRef.selectedThumbnail){
			
			this._alpha = 100;
		}else{
			this._alpha = 100;
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
	
	
	// 
	// The sibling nav hides or shows itself when a media page is navigated from/to
	//	
	private function changeLayout(n:Number){
		if(n != direction){
			
			direction = n;
			var dirString = direction ? "appear" : "disappear" ;
			transitionsIdCounter++;
			var tid:String = this._name + "_"+ this.toString().length +"_"+dirString+"_" + transitionsIdCounter+"_"+index.currentIndex; //something unique and identifiable
			transitions.push({id:tid,authorised:false});
			tController.requestTransition(this,dirString,"onTransitionAuthorised",transitions[transitions.length - 1].id);
			
			
			if(!_interval){
				_interval = setInterval(this,"onInterval",_intervalFrequency);
			}
		}
	}
	
	private function onInterval(){
		// Because this component asks for transitions in the order it wants it we can safely wait until 
		// the first transition is authorised
		if(transitions[0].authorised){
			
			switch(direction){
				case 1:
					//opening
					_animCount = Math.min((_animCount + 1),_animDuration);
					this._visible = true;
				break;
				case 0:
					//closing
					_animCount = Math.max((_animCount -1),0);
					this._visible = _animCount <= 0 ? false : true;
				break;
			}
			
			//the update transition code is in a seperate function because it is also called from onResize
			updateTransition();
			if(_animCount <= 0 || _animCount >= _animDuration){
				//it is this classes responsibility to tell the tController when it has finished an authorised transition
				// this allows the tController to then authorise the next transition in it's list.
				// if this (or any class) doesn't do this, then the whole transition sequence will halt
				tController.transitionComplete(transitions[0].id);
				transitions.shift();
				clearInterval(this._interval);
				this._interval = undefined;
			}
		}
	
	}
	
	private function updateTransition(){
		// set the alpha of the  nav items
		var stage:Number = _animCount/_animDuration;
		var factor:Number = direction ? Strong.easeIn(stage, 0, 1, 1) : Strong.easeOut(stage, 0, 1, 1) ;
		
		this._alpha = factor * 100;
	}
	
	// listens to layout
	// handles the four layout possibilities (mediaNav)
	// left  - thumbnav vertical on left, label bottom left (prev button indented)
	// right - thumbnav vertical on right, label bottom left (next button indented)
	// top - thumbnail top right, label top left
	// bottom - thumbnail bottom right, label bottom right
	public function onResize(){
		var w:Number = layout.getDimension("w");
		var h:Number = layout.getDimension("h");

		var sw:Number = layout.getDimension("sitewidth") - layout.getDimension("navwidth") - layout.getDimension("gutter") ;
		var sh:Number = layout.getDimension("siteheight");
		
		var xpos:Number = layout.getDimension("marginleft") + layout.getDimension("navwidth") + layout.getDimension("gutter") ;
		var ypos:Number = layout.getDimension("margintop");
		
		var mr = layout.getDimension("marginright");
		
		var scrollSpace:Number;
		var scrollLength = parentXMLNode.childNodes.length * thumbsize;
		
		previous_btn._y = ypos + Math.round((sh - previous_btn._height)/2); // valign center
		next_btn._y = ypos + Math.round((sh - next_btn._height)/2); // valign center
		previous_btn._x = medianav == "left" ? xpos + thumbsize + npnavgutter: xpos + npnavgutter ;
		next_btn._x = medianav == "right" ? w - npnavwidth - npnavgutter - thumbsize - mr : w - npnavwidth - npnavgutter - mr ;
		
		switch(medianav){
			case "left":
			case "right":
				this.label._x = xpos + labelxoffset;
				this.label._y = ypos + h - this.label._height + labelyoffset;
				
				scrollSpace = sh - (thumbsize * 2);
				var actualScrollHeight = Math.min((scrollSpace -  (thumbsize * 2)),scrollLength)
				thumbnav_mc._x = medianav == "right" ?  w - thumbsize - thumbxoffset - mr : xpos + thumbxoffset ;
				thumbnav_mc._y = ypos + Math.round((sh - actualScrollHeight - (thumbsize * 2))/2); // valign center
				
				drawRect(thumbnav_mc.thumbs_mask,thumbsize,actualScrollHeight,0xcc0000,100);
				thumbnav_mc.thumbs_mask._y = thumbsize;
				thumbnav_mc.thumbs.current._y = thumbsize;
				thumbnav_mc.thumbs_scroll.setSize(thumbsize,actualScrollHeight + (thumbsize * 2) ,thumbsize,scrollLength  + (thumbsize*2));
		
			break;
			default:
				// bottom or top
				this.label._x = xpos + labelxoffset;
				this.label._y = medianav == "bottom" ? ypos + sh - this.label._height - labelyoffset : ypos + labelyoffset ;
				
				scrollSpace = sw - label._width - labelxoffset - thumbsize;
				var actualScrollWidth = Math.min((scrollSpace -  (thumbsize * 2)) ,scrollLength)
				
				drawRect(thumbnav_mc.thumbs_mask,actualScrollWidth,thumbsize,0xcc0000,100);
				thumbnav_mc.thumbs_mask._x = thumbsize;
				thumbnav_mc.thumbs.current._x = thumbsize;
				thumbnav_mc.thumbs_scroll.setSize(actualScrollWidth + (thumbsize * 2) ,thumbsize,scrollLength + (thumbsize*2),thumbsize);
				
				thumbnav_mc._x = thumbnav_mc.thumbs_scroll.enabled ? w - actualScrollWidth - (thumbsize * 2) - mr - thumbxoffset : w - actualScrollWidth - thumbsize- mr - thumbxoffset;
				thumbnav_mc._y = medianav == "bottom" ?  ypos + sh - thumbsize - thumbyoffset : ypos + thumbyoffset;
				if(medianav == "top"){
					var bgh = Math.max((thumbsize + thumbxoffset + thumbgutter),(this.label._height + labelyoffset));
					drawBackground((sw-2),(bgh-1));
					bg_mc._x = xpos + 1;
					bg_mc._y = ypos + 1;
				}
			break;
		}
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
	
	private function drawBackground(bgw,bgh){
			bg_mc.clear();
			bg_mc.moveTo(0,bgh);//start from bottom left
			bg_mc.beginFill(bgcolor,bgalpha);
			bg_mc.lineTo(0,bgradius);
			bg_mc.curveTo(0,0,bgradius,0);
			bg_mc.lineTo((bgw - bgradius),0);
			bg_mc.curveTo(bgw,0,bgw, bgradius);
			bg_mc.lineTo(bgw,bgh);
			bg_mc.lineTo(0,bgh);
			bg_mc.endFill();
	}
}