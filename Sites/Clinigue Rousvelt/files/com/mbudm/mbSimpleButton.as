/*
com.mbudm.mbSimpleButton.as 
extends MovieClip

Steve Roberts June 2009

Description
Simple button class - for simple menu buttons. A generic button class. The button consists of a solid background, and a label.
The bg can have a 0 alpha.

*/

import TextField;
import com.mbudm.mbTheme;

class com.mbudm.mbSimpleButton extends MovieClip{
	private var label:TextField;
	private var bg:MovieClip;
	private var theme:mbTheme;
	private var btnParam:Number;
	private var btnWidth:Number;
	private var btnLabel:String;
	private var upCol:Number;
	private var overCol:Number;
	private var selCol:Number;
	private var bgUpCol:Number;
	private var bgOverCol:Number;
	private var bgSelCol:Number;
	private var padding:Number;
	private var callBackTarget:MovieClip;
	private var callBackMethod:String;
	private var bgCol:Color;
	private var __selected:Boolean;
	private var styleOverrides:Object;
	private var tabIndex:Number;
	private var __hasfocus:Boolean;
	
	function mbSimpleButton(){
		this.createEmptyMovieClip("bg",this.getNextHighestDepth());
	}
	
	public function init(bP:Number,bL:String,bW:Number,p:Number,t:mbTheme,cBTarget:MovieClip,cBMethod:String,sObj:Object,tI:Number){
		btnParam = bP;
		btnLabel = bL;
		btnWidth = bW;
		padding = p;
		theme = t;
		callBackTarget = cBTarget;
		callBackMethod = cBMethod;
		styleOverrides = sObj; //also contains.bgalpha property
		tabIndex = tI;
		
		
		// label colors
		var upStyle = theme.styles.getStyle(styleOverrides.upStyle);
	
		if(!upStyle.color){
			upCol = theme.compColor;
		}else{
			upCol = Number("0x"+upStyle.color.substr(1));
		}
		
		var overStyle  = theme.styles.getStyle(styleOverrides.overStyle)
		if(!overStyle.color){
			overCol = theme.compShades[1];
		}else{
			overCol = Number("0x"+overStyle.color.substr(1));
		}
		
		var selStyle  = theme.styles.getStyle(styleOverrides.selStyle)
		if(!selStyle.color){
			selCol = theme.baseColor;
		}else{
			selCol = Number("0x"+selStyle.color.substr(1));
		}
		
	
		this.createTextField("label",this.getNextHighestDepth(),0,0,btnWidth,20);
		label.html = true;
		label.autoSize = true;
		label.selectable = false;
		label.textColor = upCol;
		
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(upStyle.fontFamily.substr(0,2) == "__"){
			label.embedFonts = true;
		}
		
		label.styleSheet = theme.styles;
		label.htmlText = "<span class=\"" + styleOverrides.upStyle.substr(1) + "\">"+btnLabel+"</span>";
	
	
		label._x = padding;
		label._y = Math.round(padding/2);
		
		//bg - only worry about colors if  the alpha is > 0
		
		if(styleOverrides.bgalpha > 0){
			
			bgUpCol = Number(theme.getStyleColor(styleOverrides.bgUpStyle,"0x"));
			if(!bgUpCol)
				bgUpCol = theme.compShades[theme.compShades.length - 1];
			
			bgOverCol = Number(theme.getStyleColor(styleOverrides.bgOverStyle,"0x"));
			if(!bgOverCol)
				bgOverCol = theme.compShades[theme.compShades.length - 2];
			
			bgSelCol = Number(theme.getStyleColor(styleOverrides.bgSelStyle,"0x"));
			if(!bgSelCol)
				bgSelCol = theme.baseShades[theme.baseShades.length - 2];
			
		}else{
			bgUpCol = 0;
			bgOverCol = 0;
			bgSelCol = 0;
			styleOverrides.bgalpha  = 0; 
		}
		
		
		var bh = label._height + (padding);
		var bw = label._width + (2 * padding);
		
		if(styleOverrides.radius){
			drawRoundedRect (bg, bw, bh, styleOverrides.radius, bgUpCol, styleOverrides.bgalpha);
		}else{
			drawRect (bg, bw, bh, bgUpCol, styleOverrides.bgalpha);
		}
		
		
		bgCol = new Color(bg);
		bgCol.setRGB(bgUpCol);
		
		setButtonEvents(true);

	}
	
	private function setButtonEvents(toggle:Boolean){
		
		if(!isNaN(tabIndex)){
			//trace(this._name+" - tabIndex:"+tabIndex+ " vis:"+bg._visible+ " w:"+bg._width + " h:"+ bg._height);
			this.tabEnabled = false;
			bg.tabEnabled = true;
			bg.tabIndex = toggle ? tabIndex : undefined ;
			bg._focusrect = true;
		}else{
			//bg.tabEnabled = false;
		}
		
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
		if(!this._parent.__selected){
			this._parent.label.textColor = this._parent.overCol;
			this._parent.bgCol.setRGB(this._parent.bgOverCol);
		}
	}
	
	private function onBtnOut(){
		if(!this._parent.__selected){
			this._parent.label.textColor = this._parent.upCol;
			this._parent.bgCol.setRGB(this._parent.bgUpCol);
		}
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
	
	private function drawRoundedRect (mc:MovieClip, w:Number, h:Number, r:Number, col:Number, a:Number) {
		if(mc){
			with(mc){
				clear();
				moveTo(0,(h - r));//start from bottom left
				beginFill(col,a);
				lineTo(0,(r));
				curveTo(0,0,(r),0);
				lineTo((w -r),0);
				curveTo((w),0,(w), (r));
				lineTo((w),(h - r));
				curveTo((w),(h),(w -r),(h));
				lineTo((r),(h));
				curveTo(0,(h),0,(h -r));
				endFill();
			}
		}
	}
	
	public function set selected(s:Boolean){
		if(!s){
			label.textColor = upCol;
			bgCol.setRGB(bgUpCol);
		}else{
			label.textColor = selCol;
			bgCol.setRGB(bgSelCol);
		}
		
		
		__selected = s;
	}
	
	public function get selected():Boolean{
		return __selected;
	}
	
	public function set hasfocus(hf:Boolean){
		__hasfocus = hf;
	}
	
	public function get hasfocus():Boolean{
		return __hasfocus;
	}
	
}	