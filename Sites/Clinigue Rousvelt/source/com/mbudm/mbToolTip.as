/*
com.mbudm.mbToolTip.as 
extends MovieClip

Steve Roberts July 2009

Description
Tool tip class  creates tooltips as requested by any element that wants one. 
The element tells the class where to draw the tooltip and at what size.

*/

import TextField;
import com.mbudm.mbTheme;
import com.mbudm.mbLayout;

import flash.display.*;
import flash.filters.DropShadowFilter;
import flash.filters.BlurFilter;

import mx.transitions.easing.Strong;

import mx.transitions.easing.Regular;

class com.mbudm.mbToolTip extends MovieClip{

	private var theme:mbTheme;
	private var layout:mbLayout;
	
	private var toolTips:Array;
	
	private var __enabled:Boolean;
	private var bgCol:Number;
	private var gutter:Number;
	private var w:Number;
	private var h:Number;
	private var bgalpha:Number;
	private var shadowalpha:Number;
	private var shadowblur:Number;
	private var ttalpha:Number;
	private var ttblur:Number;
	private var arrowHead:Number;
	private var arrowLength:Number;
	private var arrowIndent:Number;
	
	private var trackInterval:Number;
	private var changeDuration:Number = 15;
	
	private var label_embedFonts:Boolean;
	private var title_embedFonts:Boolean;
	
	private var toolTipXML:XMLNode;
	
	function mbToolTip(){
	
		// array to store all the tooltips that are created
		toolTips = new Array();
			
	}
	
	public function init(Tx:XMLNode,t:mbTheme,lyt:mbLayout){
		toolTipXML = Tx;
		theme = t;
		layout = lyt;
		w = toolTipXML.attributes.width ? Number(toolTipXML.attributes.width) : 150;
		h = toolTipXML.attributes.height ? Number(toolTipXML.attributes.height) : 50;
		gutter = toolTipXML.attributes.gutter ? Number(toolTipXML.attributes.gutter) : 10 ;
		arrowHead = toolTipXML.attributes.arrowhead ? Number(toolTipXML.attributes.arrowhead) : 10;
		arrowLength = toolTipXML.attributes.arrowlength ? Number(toolTipXML.attributes.arrowlength) :  10;
		arrowIndent = toolTipXML.attributes.arrowindent ? Number(toolTipXML.attributes.arrowindent) :  15
		bgalpha = toolTipXML.attributes.bgalpha ? Number(toolTipXML.attributes.bgalpha) : 100 ;
		shadowalpha = toolTipXML.attributes.shadowalpha ? Number(toolTipXML.attributes.shadowalpha) : 0.4 ;
		shadowblur = toolTipXML.attributes.shadowblur ? Number(toolTipXML.attributes.shadowblur) : 50 ;
		ttalpha  = toolTipXML.attributes.ttalpha ? Number(toolTipXML.attributes.ttalpha) : 1 ;
		ttblur  = toolTipXML.attributes.ttblur ? Number(toolTipXML.attributes.ttblur) : 25 ;
		
		
		// bg color
		bgCol = Number(theme.getStyleColor("._toolTipBackground","0x"));
			if(isNaN(bgCol))
				bgCol = theme.compTints[theme.compTints.length - 1];
	
				
		var textBoxStObj:Object  = theme.styles.getStyle(".toolTipText")
		//If the font is preceded with __ then it is assumed to be an embedded font
		
		label_embedFonts = textBoxStObj.fontFamily.substr(0,2) == "__" ? true : false ;
		
		
		if(!textBoxStObj.color){
			textBoxStObj.color = theme.convertColorToHtmlColor(theme.compShades[theme.compShades.length-1]);
			//trace("textBoxStObj.color:"+textBoxStObj.color);
			theme.styles.setStyle(".toolTipText",textBoxStObj);
		}
		
		
		
		var titleBoxStObj:Object  = theme.styles.getStyle(".toolTipTitle")
		//If the font is preceded with __ then it is assumed to be an embedded font
		
		title_embedFonts = titleBoxStObj.fontFamily.substr(0,2) == "__" ? true : false ;
		
		
		if(!titleBoxStObj.color){
			titleBoxStObj.color = theme.convertColorToHtmlColor(theme.compShades[theme.compShades.length-1]);
			//trace("textBoxStObj.color:"+textBoxStObj.color);
			theme.styles.setStyle(".toolTipTitle",titleBoxStObj);
		}
		
		this.enabled = true;
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
	
	private function drawArrow (mc:MovieClip, arrowPoints:Array, col:Number, a:Number) {
		var alpha:Number = a == undefined ? 100 : a ;
		if(mc){
			with(mc){
				clear();
				beginFill(col, alpha);
				moveTo(arrowPoints[0].x, arrowPoints[0].y);
				lineTo(arrowPoints[1].x, arrowPoints[1].y);
				lineTo(arrowPoints[2].x, arrowPoints[2].y);
				lineTo(arrowPoints[0].x, arrowPoints[0].y);
				endFill();
			}
		}
	}
	
	// the tooltip is requested by another element - it must pass a refrence to itself -  string(s) (1 is okay) and a 
	// rectangle with the dimensions of where the tooltip will be drawn
	public function displayToolTip(ttTarg:MovieClip,t:String,l:String,re:Object,rapid:Boolean){

		if(__enabled){
			var lvl = this.getNextHighestDepth();
			var shader = this.createEmptyMovieClip("shader"+lvl,lvl);
			lvl = this.getNextHighestDepth();
			var tt = this.createEmptyMovieClip("tt"+lvl,lvl);
			
			shader.createEmptyMovieClip("shader",shader.getNextHighestDepth());
			shader.createEmptyMovieClip("shader_copy",shader.getNextHighestDepth());
			shader.createEmptyMovieClip("shader_mask",shader.getNextHighestDepth());
			
			tt.createEmptyMovieClip("bg",tt.getNextHighestDepth());
			tt.createEmptyMovieClip("arrow",tt.getNextHighestDepth());
			
			var double_gutter = gutter * 2;
			
			if(l != undefined && l != ""){
				var label_txt = tt.createTextField("label_txt",tt.getNextHighestDepth(),0,0,w - double_gutter,h - double_gutter);
				label_txt.html = true;
				label_txt.wordWrap = true;
				label_txt.autoSize = true;
				label_txt.multiline = true;
				label_txt.condenseWhite = true;
				label_txt.selectable = false;
				label_txt.embedFonts = label_embedFonts
				label_txt.styleSheet = theme.styles;
				
				label_txt.htmlText = "<span class=\"toolTipText\" >"+l+"</span>";
			}
			
			if(t != undefined && t != ""){
				var title_txt = tt.createTextField("title_txt",tt.getNextHighestDepth(),0,0,w - double_gutter,h - double_gutter);
				title_txt.html = true;
				title_txt.wordWrap = true;
				title_txt.autoSize = true;
				title_txt.multiline = true;
				title_txt.condenseWhite = true;
				title_txt.selectable = false;
				title_txt.embedFonts = title_embedFonts
				title_txt.styleSheet = theme.styles;
				
				title_txt.htmlText = "<span class=\"toolTipTitle\" >"+t+"</span>";
			}
			
			var txtH;
			if(title_txt && label_txt){
				txtH = title_txt._height + gutter + label_txt._height;
			}else if(!title_txt){
				txtH = label_txt._height;
			}else{
				txtH = title_txt._height;
			}
			
			// determine whether the label goes left or right
			var arrowCoords:Array;
			
			var bgh = (txtH + double_gutter);
			
			var spaceRight = layout.getDimension("w") - re.x  - re.w;
			if(re.x > spaceRight ){
				//more space to the left
				arrowCoords = [{x:arrowLength,y:arrowHead/2},{x:0,y:0},{x:0,y:arrowHead}];
				
				tt.bg._x = 0;
				tt.bg._y = 0;
				tt.arrow._x = w;
				tt.arrow._y = Math.round((bgh - arrowHead ) /2);
				
				tt._x = Math.round(re.x + arrowIndent - arrowLength - w);
				tt._y = Math.round(re.y + (re.h - bgh ) / 2);
				
			}else{
				//more space to the right
				arrowCoords = [{x:0,y:arrowHead/2},{x:arrowLength,y:0},{x:arrowLength,y:arrowHead}];
				
				tt.bg._x = arrowLength;
				tt.bg._y = 0;
				tt.arrow._x = 0;
				tt.arrow._y = Math.round((bgh - arrowHead ) /2);
				
				tt._x = Math.round(re.x + re.w  - arrowIndent);
				tt._y = Math.round(re.y + (re.h - bgh ) / 2);
			
			}
			
			
			// the tooltip shape
			
			drawRect(tt.bg,w,bgh,bgCol,bgalpha);
			
			drawArrow(tt.arrow,arrowCoords,bgCol,bgalpha);
			
			//tt.bg._y =20;
			if(title_txt){
				title_txt._x = tt.bg._x + gutter;
				title_txt._y = tt.bg._y + gutter;
				
				label_txt._x = title_txt._x;
				label_txt._y = Math.round(title_txt._y + title_txt._height);
			}else{
				label_txt._x = tt.bg._x + gutter;
				label_txt._y = tt.bg._y + gutter;
			}
			
			
			//
			// the dropshadow that surrounds the target rectangle
			//
		
			
			drawRect(shader.shader,re.w,re.h,0x000000,100);
			var shaderFilter:DropShadowFilter = new DropShadowFilter(0, 0, 0x000000,shadowalpha, shadowblur, shadowblur, 2, 3, false, true, true);
			var shaderFilterArray:Array = new Array();
			shaderFilterArray.push(shaderFilter);
			shader.shader.filters = shaderFilterArray;
			
			var ttFilter:DropShadowFilter = new DropShadowFilter(0, 0, 0x000000,ttalpha, ttblur, ttblur, 1, 3, false, false, false);
			var ttFilterArray:Array = new Array();
			ttFilterArray.push(ttFilter);
			tt.filters = ttFilterArray;
		
			//
			// Positioning
			//
			shader._x = re.x;
			shader._y = re.y;
		
			
			tt._alpha = 0;
			shader._alpha = 0;
				
			//get local to global
			var ttPoint:Object = {x:ttTarg._x, y:ttTarg._y}; // create your generic point object
			ttTarg.localToGlobal(ttPoint);
		
			var toolTipObject = new Object({ttTarget:ttTarg,tt_mc:tt,shader_mc:shader,status:0,counter:0,rapid:rapid});
			
			// add it to the array for display on interval
			toolTips.push(toolTipObject);
		}
	}
	
	public function hideToolTip(rapid:Boolean){
		for(var i = 0; i< toolTips.length;i++){
			if(toolTips[i].status <= 1){
				toolTips[i].status = 2;
				toolTips[i].rapid = rapid;
			}
		}
	}
	
	// the tooltip listens to the main screen scroller and hides itself until scrolling is stopped
	public function onScrollingStarted(){
		hideToolTip(true);
		this.enabled = false;
	}
	
	public function onScrollingStopped(){
		this.enabled = true;
	}
	
	// it is the responsibility of the element that requesta a tooltip to also request it's removal
	private function removeToolTip(i:Number){
		toolTips[i].shader_mc.removeMovieClip();
		toolTips[i].tt_mc.removeMovieClip();
	
	}
	
	private function onInterval(){
		
		for(var i = 0; i< toolTips.length;i++){
			var stage;
			var ttfactor;
			var shadefactor;
			
			switch(toolTips[i].status){
				case 0:
					//opening
					toolTips[i].counter++;
					
					stage = toolTips[i].counter/changeDuration;
					shadefactor = Strong.easeOut(stage, 0, 1, 1);
					ttfactor = Strong.easeIn(stage, 0, 1, 1);
					//alpha = factor * 100;
					if(toolTips[i].counter >= changeDuration){
						toolTips[i].status = 1;
					}
				break;
				case 1:
					//open
					shadefactor =1;
					ttfactor = 1;
				break;
				case 2:
					//closing
					
					toolTips[i].counter = toolTips[i].rapid ? toolTips[i].counter - 1 : toolTips[i].counter - 3;
					
					stage = toolTips[i].counter/changeDuration;
					
					shadefactor = toolTips[i].rapid ? 0 : Strong.easeIn(stage, 0, 1, 1);
					ttfactor = Strong.easeIn(stage, 0, 1, 1);
					
					if(toolTips[i].counter <= 0){
						toolTips[i].status = 3;
						removeToolTip(i);
					}
				break;
				case 3:
					toolTips[i] = undefined;
				break;
			}
			
			toolTips[i].tt_mc._alpha = 100 * ttfactor;
			toolTips[i].shader_mc._alpha = 100 * shadefactor;
		}
		
	}
	
	public function set enabled(e:Boolean){
		__enabled = e;

		if(!e){
			
		}else{
			if(trackInterval == undefined){
				trackInterval = setInterval(this,"onInterval",20);
			}
		}
	}
	
	public function get enabled():Boolean{
		return __enabled;
	}
}	