/*
com.mbudm.min.minTocMenuBtn.as 
extends MovieClip

Steve Roberts May 2009

Description
Simple button class - for creating TOC menu buttons. Has potential to become, or be replaced with, a generic button class.

*/

import TextField;
import com.mbudm.mbTheme;

class com.mbudm.min.minTocMenuBtn extends MovieClip{
	private var label:TextField;
	private var bg:MovieClip;
	private var bullet:MovieClip;
	private var theme:mbTheme;
	private var btnParam:Number;
	private var btnWidth:Number;
	private var btnLabel:String;
	private var upCol:Number;
	private var overCol:Number;
	private var padding:Number;
	private var callBackTarget:MovieClip;
	private var callBackMethod:String;
	
	function minTocMenuBtn(){
		this.createEmptyMovieClip("bg",this.getNextHighestDepth());
		
		
	}
	public function init(bP:Number,bL:String,bW:Number,p:Number,t:mbTheme,cBTarget:MovieClip,cBMethod:String){
		theme = t;
		btnParam = bP;
		btnLabel = bL;
		btnWidth = bW;
		padding = p;
		callBackTarget = cBTarget;
		callBackMethod = cBMethod;
	
		this.createTextField("label",this.getNextHighestDepth(),0,0,btnWidth,0);
		label.html = true;
		label.wordWrap = true;
		label.autoSize = true;
		label.multiline = true;
		label.condenseWhite = true;	
		label.selectable = false;
		
		this.createEmptyMovieClip("bullet",this.getNextHighestDepth());
		
		
		var upStyle = theme.styles.getStyle(".toclink");
		
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(upStyle.fontFamily.substr(0,2) == "__"){
			label.embedFonts = true;
		}
		
		if(!upStyle.color){
			upCol = theme.baseColor;
			upStyle.color = theme.convertColorToHtmlColor(theme.baseColor);
			theme.styles.setStyle(".toclink",upStyle);
		}else{
			upCol = Number("0x"+upStyle.color.substr(1));
		}
	
		label.textColor = upStyle.color;
		
		var overStyle  = theme.styles.getStyle(".toclinkover")
		if(!overStyle.color){
			overCol = theme.baseShades[1];
		}else{
			overCol = Number("0x"+overStyle.color.substr(1));
		}
		
		
		label.styleSheet = theme.styles;
		label.htmlText = "<span class=\"toclink\">"+btnLabel+"</span>";
	
		var bh = label._height + (padding);
		var bw = label._width + (2 * padding);
		
		label._x = padding;
		label._y = Math.round(padding/2);
		
		drawRect (bg, bw, bh, 0x000000, 0);
		
		// colors - check for overrides
		var bulletCol = Number(theme.getStyleColor("._tocBullet","0x"));
		if(isNaN(bulletCol))
			bulletCol = theme.compColor;

	
		drawRect (bullet, 2, 2, bulletCol, 100);
		
		var bulletOffset:Number = upStyle.fontSize ? Math.round(Number(upStyle.fontSize) * 0.7) : 8 ;
		bullet._y =  label._y + bulletOffset;
		
		
		setButtonEvents(true);
	}
	private function setButtonEvents(toggle:Boolean){
		
		bg.onRelease = toggle ? this.onBtnRelease : undefined ;
		bg.onRollOver = toggle ? this.onBtnOver : undefined ;
		bg.onRollOut = toggle ? this.onBtnOut : undefined ;
		bg.onReleaseOutside = toggle ? this.onBtnOut : undefined ;
		bg.onPress = toggle ? this.onBtnPress : undefined ;
		
	}

	
	//scoped to bg (button)
	private function onBtnRelease(){

		this._parent.callBackTarget[this._parent.callBackMethod](this._parent.btnParam);
		
	}
	private function onBtnOver(){
		this._parent.label.textColor = this._parent.overCol;
	}
	private function onBtnOut(){
		this._parent.label.textColor = this._parent.upCol;
	}
	private function onBtnPress(){
		//trace(this+" onBtnPress");
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