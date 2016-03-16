
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
	private var btns:MovieClip;
	private var mask:MovieClip;
	private var theme:mbTheme;
	private var toc_list:Array;
	private var tocXML:XMLNode;
	private var padding:Number;
	private var headspace:Number;
	private var toc_width:Number;
	private var toc_height:Number;
	private var nMovement:Number = 0;
	private var nSpeed:Number = 9;
	
	function minTocMenu(){
		this.createEmptyMovieClip("btns", this.getNextHighestDepth());
		
	}
	public function init(tl:Array,tocX:XMLNode,t:mbTheme,callBackTarget:MovieClip,callBackMethod:String){
		theme = t;
		toc_list = tl;
		tocXML = tocX;
		padding = tocXML.attributes.padding ? Number(tocXML.attributes.padding) : 0 ;
		headspace = tocXML.attributes.headspace ? Number(tocXML.attributes.headspace) : 0 ;
		toc_width = tocXML.attributes.width ? Number(tocXML.attributes.width) : 100 ;
		
		this.createTextField("heading_txt",this.getNextHighestDepth(),0,0,toc_width,0);
		heading_txt.html = true;
		heading_txt.wordWrap = true;
		heading_txt.autoSize = true;
		heading_txt.multiline = true;
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
		
		
		//buttons
		var ypos:Number = 0;
		for(var i = 0; i< toc_list.length; i++){
			btns.attachMovie("minTocMenuBtnSymbol","btn"+i,btns.getNextHighestDepth());
			btns["btn"+i].init(toc_list[i].start,toc_list[i].label,toc_width,padding,theme,callBackTarget,callBackMethod);
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
		//trace (btns._y);
	}
	
	public function setHeight($height:Number):Void {
		mask._height = $height;
		//trace ($height);
	}
	
	public function setWidth($width:Number):Void {
		mask._width = $width;
	}
	
	public function get headingHeight():Number{
		//for aligning the "visual top" of the menu items
		return btns._y + Math.round(padding/2);
	}
	
	private function onMaskMouseMove():Void {	
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
}