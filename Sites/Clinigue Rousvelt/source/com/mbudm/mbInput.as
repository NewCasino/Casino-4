/*
com.mbudm.mbInput.as 
extends MovieClip

Steve Roberts August 2009

Description
mbInput is a form control - like <input type="text" and <textarea> in html. It has in built error and hinting.
*/

import com.mbudm.mbTheme;

class com.mbudm.mbInput extends MovieClip{
	private var inputXML:XMLNode; 
	private var theme:mbTheme;
	private var bg_mc:MovieClip;
	private var label_mc:MovieClip;
	private var label_txt:TextField;
	private var scroller:MovieClip;
	
	private var msg_mc:MovieClip;
	private var msg_txt:TextField;
	private var msgPos:String; //right|top
	private var msgRect:Object;
	private var msgBgCol:Number;
	private var msgBgColError:Number;
	
	private var defaultValue:String;
	
	private var gutter:Number;
	private var half_gutter:Number;
	private var w:Number;
	private var h:Number;
	
	private var bgCol:Number;
	private var bgColActive:Number;
	private var bgColError:Number;
	
	private var borderCol:Number;
	private var borderColActive:Number;
	private var borderColError:Number;
	
	private var errorTextColor:Number
	
	private var label_fmt:TextFormat;
	private var label_default_fmt:TextFormat;
	
	private var callBackTarget:MovieClip;
	private var callBackParam;

	private var _mode:Number; // 0 inactive, 1 active, 2 error
	
	function mbInput(){
		
	}
	
	public function init(ix:XMLNode,t:mbTheme,tabI:Number,cbTarget:MovieClip,cbParam,mPos:String) {
		inputXML = ix;
		theme = t;
		callBackTarget = cbTarget;
		callBackParam = cbParam;
		msgPos = mPos == "top" ? "top" : "right" ;
		
		
		defaultValue = inputXML.nodeName == "textarea" ? inputXML.firstChild.nodeValue : inputXML.attributes.value ;
		defaultValue = defaultValue == undefined || defaultValue == "" ? " " : defaultValue ;
		
		w = Number(inputXML.attributes.width );
		
		//label style
		var flabelStObj:Object = theme.styles.getStyle(".inputText")
		var flabelDefaultStObj:Object = theme.styles.getStyle(".inputDefaultText")
		
		gutter = flabelStObj.fontSize ? Math.round(Number(flabelStObj.fontSize) / 3) : 6;
		half_gutter = Math.round(gutter/2);
		
		h = inputXML.attributes.height ? Number(inputXML.attributes.height) : Number(flabelStObj.fontSize) + (gutter * 2.5) ;
		
		var scrollWidth = 10;
		var tw = inputXML.nodeName == "textarea" ? w - scrollWidth - (2* gutter) : w - (2* gutter)
		var th = inputXML.nodeName == "textarea" ? h - gutter: h - half_gutter;
		
		this.createEmptyMovieClip("bg_mc",this.getNextHighestDepth());
		this.createEmptyMovieClip("label_mc",this.getNextHighestDepth());
		label_txt = label_mc.createTextField("label_txt",label_mc.getNextHighestDepth(),half_gutter,half_gutter,tw,th);
		label_txt.html = true;
		label_txt.wordWrap = true;
		if(inputXML.nodeName == "textarea"){
			label_txt.multiline = true; // fixed - will have a scrollbar
		}
		label_txt.condenseWhite = true;	
		label_txt.type = "input"
		
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(flabelStObj.fontFamily.substr(0,2) == "__" || flabelDefaultStObj.fontFamily.substr(0,2) == "__"){
			label_txt.embedFonts = true;
		}
	
		// convert style to textFormat
	 	label_fmt = new TextFormat();
		label_fmt.font = flabelStObj.fontFamily ? flabelStObj.fontFamily : label_fmt.font  ;
		label_fmt.bold = flabelStObj.fontWeight ? ( flabelStObj.fontWeight == "bold" ? true : false ) : label_fmt.bold  ; 
		label_fmt.color = flabelStObj.color ? "0x" + flabelStObj.color.substr(1) : theme.compShades[3]  ;
		label_fmt.leading = flabelStObj.leading ? flabelStObj.leading  : label_fmt.leading  ;
		label_fmt.kerning = flabelStObj.kerning ? flabelStObj.kerning  : label_fmt.kerning  ;
		label_fmt.align = flabelStObj.textAlign ? flabelStObj.textAlign  : label_fmt.align  ;
		label_fmt.italic = flabelStObj.fontStyle == "italic" ? true : label_fmt.italic  ;
		label_fmt.size = flabelStObj.fontSize ? flabelStObj.fontSize : label_fmt.size ;
		
		label_default_fmt = new TextFormat();
		label_default_fmt.font = flabelDefaultStObj.fontFamily ? flabelDefaultStObj.fontFamily : label_default_fmt.font  ;
		label_default_fmt.bold = flabelDefaultStObj.fontWeight ? ( flabelDefaultStObj.fontWeight == "bold" ? true : false ) : label_default_fmt.bold  ; 
		label_default_fmt.color = flabelDefaultStObj.color ? "0x" + flabelDefaultStObj.color.substr(1) : theme.compShades[3]  ;
		label_default_fmt.leading = flabelDefaultStObj.leading ? flabelDefaultStObj.leading  : label_default_fmt.leading  ;
		label_default_fmt.kerning = flabelDefaultStObj.kerning ? flabelDefaultStObj.kerning  : label_default_fmt.kerning  ;
		label_default_fmt.align = flabelDefaultStObj.textAlign ? flabelDefaultStObj.textAlign  : label_default_fmt.align  ;
		label_default_fmt.italic = flabelDefaultStObj.fontStyle == "italic" ? true : label_default_fmt.italic  ;
		label_default_fmt.size = flabelDefaultStObj.fontSize ? flabelDefaultStObj.fontSize : label_default_fmt.size ;
		
		label_txt.htmlText =  defaultValue;
		label_txt.setTextFormat(label_default_fmt);
		
		
		var thisObj = this;
		label_txt.onChanged = function(){
			thisObj.onChanged();
		}
		label_txt.onSetFocus= function(){
			thisObj.onSetFocus();
		}
		label_txt.onKillFocus= function(){
			thisObj.onKillFocus();
		}
		
		if(tabI){
			label_txt.tabIndex = tabI
		}else{
			label_txt.tabEnabled = false
		}
		
		//bg
		bgCol = Number(theme.getStyleColor("._inputbg","0x"));
		if(isNaN(bgCol))
			bgCol = theme.compTints[theme.compTints.length - 2];
			
		bgColActive = Number(theme.getStyleColor("._inputbgactive","0x"));
		if(isNaN(bgColActive))
			bgColActive = theme.compTints[theme.compTints.length - 1];
			
		bgColError = Number(theme.getStyleColor("._inputbgerror","0x"));
		if(isNaN(bgColError))
			bgColError = theme.baseTints[theme.baseTints.length - 2];
			
		borderCol = Number(theme.getStyleColor("._inputborder","0x"));
		if(isNaN(borderCol))
			borderCol = theme.compTints[theme.compTints.length - 2];
			
		borderColActive = Number(theme.getStyleColor("._inputborderactive","0x"));
		if(isNaN(borderColActive))
			borderColActive = theme.compTints[theme.compTints.length - 2];
			
		borderColError = Number(theme.getStyleColor("._inputbordererror","0x"));
		if(isNaN(borderColError))
			borderColError = theme.baseShades[1];
			
		errorTextColor = Number(theme.getStyleColor("._inputerror","0x"));
		if(isNaN(errorTextColor))
			errorTextColor = borderColError;
			
		
		
		//scrollbar
		
		if(inputXML.nodeName == "textarea"){
			scroller = label_mc.attachMovie("mbScrollerTextFieldModeSymbol","scroller",label_mc.getNextHighestDepth());
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
		
		scroller.init(label_txt,sObj);
		scroller.setSize(w - scrollWidth - gutter,th);
		
		
		// messages
		
		//message style
		var fmsgStObj:Object = theme.styles.getStyle(".formMessage");
		if(!fmsgStObj.color){
			var col:String = theme.convertColorToHtmlColor(theme.compShades[1]);
			fmsgStObj.color = col;
			theme.styles.setStyle(".formMessage",fmsgStObj);
		}
		var fmsgErrStObj:Object = theme.styles.getStyle(".formMessageError");
		if(!fmsgErrStObj.color){
			var col:String = theme.convertColorToHtmlColor(theme.baseShades[1]);
			fmsgErrStObj.color = col;
			theme.styles.setStyle(".formMessageError",fmsgErrStObj);
		}
		
		this.createEmptyMovieClip("msg_mc",this.getNextHighestDepth());
		msg_mc._visible = false;
		msg_mc.createEmptyMovieClip("bg",msg_mc.getNextHighestDepth());
		msg_txt = msg_mc.createTextField("label",msg_mc.getNextHighestDepth(),half_gutter,half_gutter,150,20);
			
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(fmsgStObj.fontFamily.substr(0,2) == "__" || fmsgErrStObj.fontFamily.substr(0,2) == "__" ){
			msg_txt.embedFonts = true;
		}
		msg_txt.html = true;
		msg_txt.wordWrap = true;
		msg_txt.autoSize = true;
		msg_txt.multiline = true;
		msg_txt.condenseWhite = true;	
		msg_txt.styleSheet = theme.styles;
		
		msgBgCol = Number(theme.getStyleColor("._msgbg","0x"));
		if(isNaN(msgBgCol))
			msgBgCol = theme.compTints[theme.compTints.length - 2];
		
		msgBgColError = Number(theme.getStyleColor("._msgbgerror","0x"));
		if(isNaN(msgBgColError))
			msgBgColError = theme.baseTints[theme.baseTints.length - 2];
		
		mode = 0;
		
		
	}
	
	private function onChanged(){
		//trace("onChanged");
		callBackTarget.onChanged(callBackParam);
	}
	
	private function onSetFocus(){
		//trace("onSetFocus label_txt.htmlText:"+label_txt.htmlText+" defaultValue:"+defaultValue);
		if(label_txt.text == defaultValue){
			label_txt.htmlText = "";
			label_txt.setNewTextFormat(label_fmt);	
		}
		mode = 1;
		callBackTarget.onSetFocus(callBackParam);
	}
	
	private function onKillFocus(){
		//trace("onKillFocus");
		if(label_txt.text == ""){
			label_txt.htmlText = defaultValue;
			label_txt.setTextFormat(label_default_fmt);
		}
		mode = 0;
		msg_mc._visible = false;
		callBackTarget.onKillFocus(callBackParam);
	}
	
	public function setMessage(isErr:Boolean,msg:String){
		mode = isErr ? 2 : mode;
		if(msg.length){
			var cssClass = isErr ? "formMessageError" : "formMessage" ;
			msg_txt.htmlText = "<span class=\""+cssClass+"\" >"+msg+"</span>";
			updateMessage();
			msg_mc._visible = true;
		}else{
			msg_mc._visible = false;
		}
	}
	private function updateMessage(){
		msg_txt._width = msgRect.w - gutter;
		msgRect.h = msg_txt._height + gutter;
		msgRect.y = msgPos == "right" ? Math.round((h - msgRect.h) /2) : 0 - msgRect.h - half_gutter ;
		
		msg_mc._x = msgRect.x; 
		msg_mc._y = msgRect.y;
		//trace(this._name+" updateMessage mode:"+mode+" x:"+msgRect.x+" y:"+msgRect.y+" w:"+msgRect.w+" h:"+msgRect.h);
		var col = mode == 2 ? msgBgColError : msgBgCol ;
		drawRoundedRect(msg_mc.bg,msgRect.w,msgRect.h,half_gutter,col,100,0,col);
		
	}
	
	public function setMessageSize(maxW:Number){
		if(!msgRect){
			msgRect = {}
			// dimensions - some will be ignored - eg height will depend on the amount of msg text
			msgRect.h = h;
			msgRect.x = msgPos == "right" ? w + gutter : 0 ;
			msgRect.y = msgPos == "right" ? 0 : 0 ;
		}
		msgRect.w = msgPos == "right" ? maxW - w - gutter : w ;
		
		updateMessage();
	}

	public function set mode(m:Number){
		_mode = m;
		var col = _mode == 0 ? bgCol : (_mode == 1 ? bgColActive : bgColError) ;
		var lcol = _mode == 0 ? borderCol : (_mode == 1 ? borderColActive : borderColError) ;
		var lw = col == lcol ? 0 : 0.1 ;
		drawRoundedRect(bg_mc,w,h,half_gutter,col,100,lw,lcol);
		
		label_txt.textColor = mode == 2 ? errorTextColor : (mode == 1 ? label_fmt.color : label_default_fmt.color ) ;
	}
	
	public function get mode():Number{
		return _mode;
	}
	
	public function get data():String{
		return label_txt.text == defaultValue ? "" : label_txt.text ;
	}
	
	private function drawRoundedRect (mc:MovieClip, w:Number, h:Number, r:Number, col:Number, a:Number,lw:Number,lcol:Number) {
		if(mc){
			with(mc){
				clear();
				lineStyle(lw,lcol,100,true);
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
}