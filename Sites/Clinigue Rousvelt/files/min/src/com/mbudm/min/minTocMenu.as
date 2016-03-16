
/*
com.mbudm.min.minTocMenu.as 
extends MovieClip

Steve Roberts May 2009

Description
creates the TOC heading, and instantiates a mbTocMenuBtn for each item in the toc_list

*/

import TextField;
import com.mbudm.mbTheme;
import mx.utils.Delegate;

class com.mbudm.min.minTocMenu extends MovieClip{
	private var heading_txt:TextField;
	private var heading_bg:MovieClip;
	private var btns:MovieClip;
	private var mask:MovieClip;
	private var theme:mbTheme;
	private var toc_list:Array;
	private var tocXML:XMLNode;
	private var padding:Number;
	private var headspace:Number;
	private var toc_width:Number;
	
	private var nMovement:Number = 0;
	private var nSpeed:Number = 9;
		
	private var tocHeadingCol:Number;
	private var tocHeadingOverCol:Number;
	
	private var callBackTarget:MovieClip;
	private var callBackMethod:String;
	
	function minTocMenu(){
		this.createEmptyMovieClip("heading_bg",this.getNextHighestDepth());
		this.createEmptyMovieClip("btns",this.getNextHighestDepth());
		
	}
	public function init(tl:Array,tocX:XMLNode,t:mbTheme,cbT:MovieClip,cbM:String){
		theme = t;
		toc_list = tl;
		tocXML = tocX;
		padding = tocXML.attributes.padding ? Number(tocXML.attributes.padding) : 0 ;
		headspace = tocXML.attributes.headspace ? Number(tocXML.attributes.headspace) : 0 ;
		toc_width = tocXML.attributes.width ? Number(tocXML.attributes.width) : 100 ;
		
		callBackTarget = cbT;
		callBackMethod = cbM;
		
		this.createTextField("heading_txt",this.getNextHighestDepth(),0,0,toc_width,0);
		heading_txt.html = true;
		heading_txt.wordWrap = true;
		heading_txt.autoSize = true;
		heading_txt.multiline = true;
		heading_txt.selectable = false;
		heading_txt.condenseWhite = true;	
		
		//heading
		var tocHeadStObj:Object = theme.styles.getStyle(".tocheading")
		
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(tocHeadStObj.fontFamily.substr(0,2) == "__"){
			heading_txt.embedFonts = true;
		}
		
		if(!tocHeadStObj.color){
			var col:String = theme.convertColorToHtmlColor(theme.compShades[3]);
			tocHeadStObj.color = col;
			theme.styles.setStyle(".tocheading",tocHeadStObj);
		}
		heading_txt.styleSheet = theme.styles;
		
		heading_txt.htmlText = "<span class=\"tocheading\">"+tocXML.attributes.heading+"</span>";
		heading_txt._x = 0;
		
		tocHeadingCol = Number(theme.getStyleColor(".tocheading","0x"));
		if(isNaN(tocHeadingCol))
			tocHeadingCol = theme.compTints[1];
	
		tocHeadingOverCol = Number(theme.getStyleColor(".tocheadingover","0x"));
		if(isNaN(tocHeadingOverCol))
			tocHeadingOverCol = theme.compTints[1];
		
		//heading bg
		var bh = heading_txt._height + (padding);
		var bw = heading_txt._width + (2 * padding);
		
		drawRect (heading_bg, bw, bh, 0x000000, 0);
		setButtonEvents(true);
		//buttons
		var ypos:Number = 0;
		for(var i = 0; i< toc_list.length; i++){
			btns.attachMovie("minTocMenuBtnSymbol","btn"+i,btns.getNextHighestDepth());
			btns["btn"+i].init(toc_list[i].chapter,toc_list[i].label,toc_width,padding,theme,callBackTarget,callBackMethod);
			btns["btn"+i]._y = ypos;
			ypos += btns["btn"+i]._height;
		}
		
		btns._y = heading_txt._height + headspace;
		this.createEmptyMovieClip("mask", btns.getNextHighestDepth());
		mask.beginFill(0x777777);
		mask.moveTo(0, 0);
		mask.lineTo(toc_width + 5, 0);
		mask.lineTo(toc_width + 5, 70);
		mask.lineTo(0, 70);
		mask.lineTo(0, 0);
		mask.endFill();
		mask._alpha = 0;
		mask.onMouseMove = Delegate.create(this, onMaskMouseMove);
		btns.setMask(mask);
		mask._y = btns._y - 3;
	}
	
	public function setHeight($height:Number):Void {
		mask._height = $height;
		//trace ($height);
	}
	
	public function setWidth($width:Number):Void {
		mask._width = $width;
	}
	
	private function setButtonEvents(toggle:Boolean){
		
		heading_bg.onRelease = toggle ? this.onBtnRelease : undefined ;
		heading_bg.onRollOver = toggle ? this.onBtnOver : undefined ;
		heading_bg.onRollOut = toggle ? this.onBtnOut : undefined ;
		heading_bg.onReleaseOutside = toggle ? this.onBtnOut : undefined ;
		heading_bg.onPress = toggle ? this.onBtnPress : undefined ;
		
	}
	
	//scoped to heading_bg (button)
	private function onBtnRelease(){
		this._parent.callBackTarget[this._parent.callBackMethod](0);
	}
	private function onBtnOver(){
		this._parent.heading_txt.textColor = this._parent.tocHeadingOverCol;
	}
	private function onBtnOut(){
		this._parent.heading_txt.textColor = this._parent.tocHeadingCol;
	}
	private function onBtnPress(){
		//trace(this+" onBtnPress");
	}
	
	public function get headingHeight():Number{
		//for aligning the "visual top" of the menu items
		return btns._y + Math.round(padding/2);
	}
	
	private function onMaskMouseMove():Void {
		//trace ("MOUSE MOVE" + this);
		if (this._ymouse > mask._y && this._ymouse < mask._height && this._xmouse > mask._x && this._xmouse < mask._width) {
			//trace (this._ymouse +"  "+mask._height);
			nMovement = Math.round(((this._ymouse - (mask._height / 2)) / -(mask._height / 2)) * nSpeed);
		} else {
			nMovement = 0;
		}
		
	}
	
	private function onEnterFrame():Void {
		if (mask._height > btns._height) {
			return
		}
		
		if (nMovement > 0) {
			if (btns._y < heading_txt._height + headspace) {
				btns._y += nMovement;
			} else {
				btns._y = heading_txt._height + headspace;
			}
		} else if (nMovement < 0) {
			if (btns._y > mask._height - btns._height) {
				btns._y += nMovement;
			} else {
				btns._y = mask._height - btns._height;
			}
		}
		
		/*if (nMovement != 0 && mask._height < btns._height) {
			if (btns._y <= heading_txt._height + headspace && btns._y > mask._height - btns._height) {
				trace (btns._y +" || " + (mask._height - btns._height));
				btns._y += nMovement;
				
			}
		}*/
	}
	
	public function setSelected(s:Number){
		for(var i = 0; i< toc_list.length; i++){
			var sel = s == btns["btn"+i].parameter ? true : false;
			btns["btn"+i].selected = sel;
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
}
		