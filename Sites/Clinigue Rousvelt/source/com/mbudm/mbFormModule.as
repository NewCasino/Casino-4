/*
com.mbudm.mb.mbFormModule.as 
extends MovieClip

Steve Roberts August 2009

Description
mbFormModule is a page module that renders a form and a textfield.
Tasks
 - instantiate <text> block - mbTextField
 - create form mc
 	- create form elements
		- mbInputText
		- mbSimpleButton
			- help messages handled separately? or in mbInputText?
	 - wire up to listeners
- apply theme
- layout page items (text block left top right bottom) width/height form in scrollpane in case space is too small. page margins and gutter
- layout form items
- killfocus listener - receives  a ref to the item that killed focus, checks any <help> rules, tells the item to display the message
- getfocus listener - receives  a ref to the item that got focus, checks any <help> rules, tells the item to display the message
- on submit listener - checks any <help> rules, tells all item to display their submit messages
- tab order & keyboard listeners
	
Standard module tasks, such as handling page layout and relaying load requests to the mbLoader instance are also included in this class.
	
*/
import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import flash.display.*;
import mx.transitions.easing.Regular;

class com.mbudm.mbFormModule extends MovieClip{
	private var indexNode:XMLNode; 
	private var indexCoord:String;
	private var index:mbIndex;
	private var pageXML:XML; 
	private var pageXMLobj:Object;
	private var theme:mbTheme;
	
	private var startTrigger:Boolean;
	private var contentReady:Boolean;
	
	private var callbackObject:Object;
	
	private var text_mc:MovieClip;
	private var form_mc:MovieClip;
	private var formItems:Object;
	private var pane_mc:MovieClip;
	
	private var result_mc:MovieClip;
	private var result_txt:TextField;
	
	private var textPos:String;
	private var msgPos:String;
	
	private var gutter:Number;
	private var labelwidth:Number;
	
	private var heading_txt:TextField;
	private var headingspace:Number; // the vspace between the heading and the text_mc/form_mc
	
	
	
	private var w:Number;
	private var h:Number;
	
	/* transition vars */
	private var direction:Boolean; //true is fading up the info box false is fading down
	
	private var _interval:Number;
	private var _intervalFrequency:Number = 20;
	
	private var _animDuration:Number = 10;
	private var _animCount:Number;
	
	
	private var setFocusMessages:Array;
	private var killFocusMessages:Array;
	private var submitMessages:Array;
	
	private var maxwidth:Number;
	
	
	function mbFormModule(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init(pX:XML,ind:mbIndex,iC:String,t:mbTheme) {
		
		pageXMLobj = new Object();
		index = ind;
		indexCoord = iC;
		indexNode = index.getItemAt(indexCoord);
		pageXML = pX;
		theme = t;
		
		
		//'objectify' the nodes for easy access  
		for(var i = 0; i < pageXML.firstChild.childNodes.length;i++){
			var nodeName  = pageXML.firstChild.childNodes[i].nodeName
			pageXMLobj[nodeName] = pageXML.firstChild.childNodes[i];
		}
		
		gutter = pageXML.firstChild.attributes.gutter ? Number(pageXML.firstChild.attributes.gutter) : 20 ;
		var half_gutter = Math.round(gutter / 2);
		
		labelwidth = pageXMLobj.form.attributes.labelwidth ? Number(pageXMLobj.form.attributes.labelwidth) : 150 ;
		
		maxwidth = !isNaN(Number(pageXMLobj.form.attributes.maxwidth)) ? Number(pageXMLobj.form.attributes.maxwidth) : undefined ;
		
		textPos = pageXMLobj.text.attributes.position ? pageXMLobj.text.attributes.position : "top";
		msgPos = pageXMLobj.help.attributes.msgpos ? pageXMLobj.help.attributes.msgpos : "right";
		
		// help messages
		setFocusMessages = new Array();
		killFocusMessages  = new Array();
		submitMessages = new Array();
		
		for(var j = 0 ; j < pageXMLobj.help.childNodes.length; j++ ){
			switch(pageXMLobj.help.childNodes[j].nodeName){
				case "onSetFocus":
					setFocusMessages.push(pageXMLobj.help.childNodes[j]);
				break;
				case "onKillFocus":
				case "onSubmit":
					if(pageXMLobj.help.childNodes[j].nodeName == "onKillFocus")
						killFocusMessages.push(pageXMLobj.help.childNodes[j]);	
					// on submit also process killfocus rules
					submitMessages.push(pageXMLobj.help.childNodes[j]);
				break;
			}
		}
		
		
		// heading 
		
		this.createTextField("heading_txt",this.getNextHighestDepth(),0,0,200,100);
		heading_txt._visible = false;
		
		heading_txt.html = true;
		heading_txt.wordWrap = true;
		heading_txt.autoSize = true;
		heading_txt.multiline = true;
		heading_txt.condenseWhite = true;
		var headingStObj:Object = theme.styles.getStyle(".pageheading");
		
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(headingStObj.fontFamily.substr(0,2) == "__"){
			heading_txt.embedFonts = true;
		}
		if(!headingStObj.color){
			var col:String = theme.convertColorToHtmlColor(theme.compTints[0]);
			headingStObj.color = col;
			theme.styles.setStyle(".pageheading",headingStObj);
		}
		heading_txt.styleSheet = theme.styles;
		var str:String;
		if(!pageXMLobj.title.attributes.useParent){
			str = pageXMLobj.title.toString();
		}else{
			str = indexNode.attributes[pageXMLobj.title.attributes.useParent];
		}
		heading_txt.htmlText = "<span class=\"pageheading\">"+str+"</span>";
		
		
		var headingSpaceStObj:Object = theme.styles.getStyle(".pageheadingspace");
		if(!headingSpaceStObj.fontSize){
			headingspace = 10;
		}else{
			headingspace = Number(headingSpaceStObj.fontSize);
		}
		
		
		
		
		// text box
		
		this.attachMovie("mbTextBoxSymbol", "text_mc", this.getNextHighestDepth());
		text_mc.init(index,theme);
		var pageContent;
		if(pageXMLobj.text.firstChild.nodeType == 1){
			//XHTML content
			pageContent = pageXMLobj.text.toString()
		}else{
			//CDATA or basic text.
			pageContent = pageXMLobj.text.firstChild.nodeValue;
		}
		
		text_mc.htxt = pageContent;
		
		
		// form
		
		//label style
		var flabelStObj:Object = theme.styles.getStyle(".formlabel")
		if(!flabelStObj.color){
			var col:String = theme.convertColorToHtmlColor(theme.baseColor);
			flabelStObj.color = col;
			theme.styles.setStyle(".formlabel",flabelStObj);
		}
		
		this.createEmptyMovieClip("form_mc", this.getNextHighestDepth());
		form_mc.createEmptyMovieClip("content",form_mc.getNextHighestDepth());
		pane_mc = this.attachMovie("mbScrollPaneSymbol","pane_mc",this.getNextHighestDepth());
		
		
		formItems = new Object();
		
		var ypos = 0;
		for(var i = 0; i < pageXMLobj.form.childNodes.length;i++){
			var ftype = undefined;
			var fnode = undefined;
			var lnode = undefined;
			for(var j = 0; j < pageXMLobj.form.childNodes[i].childNodes.length; j++){
				switch(pageXMLobj.form.childNodes[i].childNodes[j].nodeName){
					case "input":
						ftype = pageXMLobj.form.childNodes[i].childNodes[j].attributes.type;
						fnode = pageXMLobj.form.childNodes[i].childNodes[j];
					break;
					case "textarea":
						ftype = pageXMLobj.form.childNodes[i].childNodes[j].nodeName;
						fnode = pageXMLobj.form.childNodes[i].childNodes[j];
					break;
					case "label":
						lnode = pageXMLobj.form.childNodes[i].childNodes[j];
					break;
				}
			}
			if(fnode && ftype){
				var form_item_mc;
				switch(ftype){
					case "text":
					case "textarea":
						form_item_mc = form_mc.content.attachMovie("mbInputSymbol","item"+i,form_mc.content.getNextHighestDepth());
						form_item_mc.init(fnode,theme,(i+1),this,fnode.attributes.name,msgPos);
					break;
					case "submit":
						form_item_mc = form_mc.content.attachMovie("mbSimpleButtonSymbol","submit",form_mc.content.getNextHighestDepth());
						var btnStyles =  new Object();
						btnStyles.upStyle = "._submitButton";
						btnStyles.overStyle = "._submitButtonOver";
						btnStyles.selStyle = "._submitButtonSelected";
						btnStyles.bgUpStyle = "._submitButtonBg";
						btnStyles.bgOverStyle = "._submitButtonBgOver";
						btnStyles.bgSelStyle = "._submitButtonBgSelected";
						btnStyles.bgalpha = 100;
						btnStyles.radius = 4;
						form_item_mc.init(form_item_mc,fnode.attributes.value,fnode.attributes.width,6,theme,this,"onSubmit",btnStyles,(i+1));
						//trace("submit node value:"+fnode.attributes.value+" w:"+fnode.attributes.width);
					break;
				}
				form_item_mc._x = labelwidth;
				form_item_mc._y = ypos;
				if(lnode){
					var label_txt = form_mc.content.createTextField("label"+i,form_mc.content.getNextHighestDepth(),0,0,labelwidth,20);
					label_txt.html = true;
					label_txt.wordWrap = true;
					label_txt.autoSize = true;
					label_txt.multiline = true;
					label_txt.condenseWhite = true;	
					
					
					//If the font is preceded with __ then it is assumed to be an embedded font
					if(flabelStObj.fontFamily.substr(0,2) == "__"){
						label_txt.embedFonts = true;
					}
					
				
					label_txt.styleSheet = theme.styles;
					
					// straight node text or cdata is ok
					var label_str = lnode.firstChild.nodeType == 1 ? lnode.toString() : lnode.firstChild.nodeValue;
					label_txt.htmlText = "<span class=\"formlabel\">"+label_str+"</span>";
					label_txt._y = ypos;
				}
				formItems[fnode.attributes.name] = {itemnode:fnode,type:ftype,labelnode:lnode,fmc:form_item_mc,lmc:label_txt}
				
				ypos += half_gutter + Math.max(label_txt._height,form_item_mc._height);
			}
		}
		
		pane_mc.init(form_mc.content,"scroll",theme);	
	
		//result mc
		
		this.createEmptyMovieClip("result_mc", this.getNextHighestDepth());
		result_mc._visible = false;
		result_txt = result_mc.createTextField("label",result_mc.getNextHighestDepth(),0,0,200,100);
		result_txt.html = true;
		result_txt.wordWrap = true;
		result_txt.autoSize = true;
		result_txt.multiline = true;
		result_txt.condenseWhite = true;
		var resultStObj:Object = theme.styles.getStyle(".formResult");
		
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(resultStObj.fontFamily.substr(0,2) == "__"){
			result_txt.embedFonts = true;
		}
		
		if(!resultStObj.color){
		
			var col:String = theme.convertColorToHtmlColor(theme.compTints[0]);
			resultStObj.color = col;
			theme.styles.setStyle(".formResult",resultStObj);
		}
		result_txt.styleSheet = theme.styles;
		result_txt.htmlText = " ";
		
		result_mc.attachMovie("mbSimpleButtonSymbol","close_btn",result_mc.getNextHighestDepth());
		result_mc.close_btn.init(result_mc.close_btn,"Send another message",100,6,theme,this,"onResetForm",btnStyles);
		
		
	
		setSize();
		contentReady = true;
		startModule();
	}
	
	
	// form callbacks
	
	public function onChanged(nName:String){
		//trace("onChanged:"+i);
	}
	public function onSetFocus(nName:String){
		// tell message to display any onSetFocus messages for this item
		//var nName = formItems[i].itemnode.attributes.name;
		//trace("onSetFocus:"+i+" nName:"+nName);
		for(var j = 0 ; j < setFocusMessages.length; j++ ){
			//trace("setFocusMessages["+j+"].attributes.name:"+setFocusMessages[j].attributes.name);
			if(setFocusMessages[j].attributes.name == nName ){
				//trace("onSetFocus - message sending: "+setFocusMessages[j] +" nName:"+nName);
				formItems[nName].fmc.setMessage(0,setFocusMessages[j].attributes.message);
				break;
			}
		}			
	}
	public function onKillFocus(nName:String){
		//trace("onKillFocus:"+i);
		// tell message to display any onKillFocus messages for this item
		//var nName = formItems[i].itemnode.attributes.name;
		var msgSent:Boolean = false;
		for(var j = 0 ; j < killFocusMessages.length; j++ ){
			if(killFocusMessages[j].attributes.name == nName ){
				var bool = checkRule(killFocusMessages[j].attributes.rule,formItems[nName].fmc.data,formItems[nName].itemnode)
				if(!bool){	
					formItems[nName].fmc.setMessage(1,killFocusMessages[j].attributes.message);
					msgSent = true;
					break;
				}
			}
		}
		if(!msgSent){
			formItems[nName].fmc.setMessage(0,"");
		}
		
		
	}
	public function onSubmit(mc:MovieClip){
		//trace("onSubmit:"+mc);
		// tell message to display any onSubmit messages for all items
		var allClear = true;
		var msgSent = new Object();
		for(var j = 0 ; j < submitMessages.length; j++ ){
			var nName = submitMessages[j].attributes.name;
			var bool = checkRule(submitMessages[j].attributes.rule,formItems[nName].fmc.data,formItems[nName].itemnode)
			if(!bool){	
				formItems[nName].fmc.setMessage(1,submitMessages[j].attributes.message);
				msgSent[nName] = true;
			trace("onSubmit - sending error msg to: "+ nName+" msg:"+submitMessages[j].attributes.message);
				allClear = false;
			}
		}
		for(var p in formItems){
			if(!msgSent[p]){
				formItems[p].fmc.setMessage(0,"");
				trace("onSubmit - sending non-error msg to: "+ p+" msgSent[p]:"+msgSent[p]);
			}
		}
		if(allClear){
			// do submit
			var result_lv:LoadVars = new LoadVars();
			var send_lv:LoadVars = new LoadVars();
			// copy the values of the form into send_lv.
			for(var p in formItems){
				send_lv[p] = formItems[p].fmc.data;
				//trace("send_lv["+p+"]:"+send_lv[p]);
			}
			/* send the variables in the send_lv instance to the server-side script 
			   using the POST method (send as Form variables rather than along the URL)
			   and place the results returned in the result_lv instance. */
			   /**/
			form_mc._visible = false;
			pane_mc._visible = false;
			// When the results are received from the server...
			var thisObj = this;
			result_lv.onLoad = function(success:Boolean) {
				_root.tracer.htmlText+="result_lv.onLoad success:"+success+" this.returnMessage:"+this.returnMessage;
				if(success && this.returnMessage != undefined ){
					thisObj.setResult(true,this.returnMessage);
				}else{
					thisObj.setResult(true,"There was an error submitting your form");
				}
			}
			
			send_lv.onHTTPStatus = function(httpStatus:Number) {
				_root.tracer.htmlText+="HTTP status is: " + httpStatus;
			};
			send_lv.sendAndLoad(pageXMLobj.form.attributes.action, result_lv, "POST");
			
		}
	}
	
	private function setResult(e:Boolean,msg:String){
		//_root.tracer.htmlText+="setResult e:"+e+" msg:"+msg;
				
		result_txt.htmlText = "<span class=\"formResult\">"+msg+"</span>";
		setSize();
		result_mc._visible = e;
		form_mc._visible = !e;
		pane_mc._visible = !e;
	}
	
	private function onResetForm(mc:MovieClip){
		setResult(false,"");
	}
		
	private function checkRule(rule:String,str:String,node:XMLNode):Boolean{
		var passed:Boolean = false;
		switch(rule){
			case "email":
				var parts = str.split("@");
				var domain = parts[1].split(".");
				if((parts[0].length > 0) && (domain.length > 1) && (domain[0].length > 1) && (domain[1].length > 0) ){
					passed = true;
				}
			break;
			case "minlength":
				var len = Number(node.attributes.minlength);
				passed = str.length >= len ? true : false ;
			break;
			case "maxlength":
				var len = Number(node.attributes.maxlength);
				passed = str.length <= len ? true : false ;
			break;
		}
		return passed;
	}
	
	
	// called by mbContent
	public function start(o:Object){
		callbackObject = o;
		startTrigger = true;
		startModule();
	}
	
	// called by mbContent
	public function end(o:Object){
		callbackObject = o;
		if(startTrigger && contentReady){
			endModule();
		}
	}
	
	private function doCallBack(){
		if(callbackObject != undefined){
			callbackObject.target[callbackObject.onComplete](callbackObject.param);
		}
	}
	
	// functions that used to be in extended class - but as this is proving quite geneic have been moved 
	// back in to the common class. For this module no real need to extend.
	
	private function startModule(){
		
		if(startTrigger && contentReady){
			//this._visible = true;
			text_mc.open({target:this,onComplete:"doCallBack"});
			heading_txt._visible = true;
		}
		
	}

	private function endModule(){
		text_mc.close({target:this,onComplete:"doCallBack"});
	}
	
	private function startInterval(){
		if(this._interval == undefined){
			this._interval = setInterval(this,"onInterval",_intervalFrequency);
		}
	}
	
	private function onInterval(){
		switch(direction){
			case false:
				//closing
				_animCount = Math.max((_animCount -1),0);
			
			break;
			default:
	
				_animCount = Math.min((_animCount + 1),_animDuration);
			break;
			
		}
		
		updateTransition();
		
		if(_animCount <= 0 || _animCount >= _animDuration ){
			
			clearInterval(this._interval);
			this._interval = undefined;
			direction = undefined;
		}
	}
	
	
	// fade up the info item, and move it if necesary
	private function updateTransition(){
		var stage = _animCount/_animDuration;
		var factor = direction ? Regular.easeIn(stage, 0, 1, 1) : Regular.easeOut(stage, 0, 1, 1) ;
		
	
	}
	
	
	public function setSize(wi:Number,he:Number){
		w = isNaN(wi) ? w : wi ;
		h = isNaN(he) ? h : he ;
		
		//margins
	
		// - order is like css Top, right, bottom , left
		var margins:Array = pageXML.firstChild.attributes.margins ? pageXML.firstChild.attributes.margins.split(",") : [0,0,0,0];
		
		// convert margins values to pixels if they are fractions - order is like css Top, right, bottom , left
		var dimension:Number;
		for(var i = 0 ; i < margins.length; i++){
			dimension = i == 0 || i == 2 ? h : w ;
			margins[i] = margins[i] > 0 && margins[i] < 1 ? Number(margins[i]) * dimension : Number(margins[i]) ;
		}
		
		var pW = w - margins[1] - margins[3];
		var pH = h - margins[0] - margins[2];
		
		heading_txt._width = pW;
		heading_txt._x = margins[3];
		heading_txt._y = margins[0];
		var headH = heading_txt._height;
		pH -= headH + headingspace;
				
		var textW;
		var textH;
		var textX;
		var textY;
		var paneW;
		var paneH;
		switch(textPos){
			case "top":
			case "bottom":
				textW = pW;
				
				if(pageXMLobj.text.attributes.height){
					textH = pageXMLobj.text.attributes.height > 0 && pageXMLobj.text.attributes.height < 1 ? Number(pageXMLobj.text.attributes.height) * (pH - gutter) : Number(pageXMLobj.text.attributes.height)  ;
				}else{
					textH = Math.max((pH - gutter - form_mc._height), Math.round((pH - gutter) * 0.5));
				}
				
				text_mc.setSize(textW,textH);
				textX = margins[3];
				textY = textPos == "top" ? margins[0] + headH + headingspace : pH - text_mc.actualHeight ;
				text_mc.moveTo(textX,textY);
				
				form_mc._x = margins[3];
				pane_mc._x = margins[3];
				form_mc._y = textPos == "bottom" ? margins[0] + headH + headingspace : textY + text_mc.actualHeight + gutter ;
				pane_mc._y = form_mc._y;
				paneW = pW;
				paneH = (pH - text_mc.actualHeight - gutter);
				//trace("paneH:"+paneH+" pH:"+pH+" h:"+h+" text_mc.actualHeight:"+text_mc.actualHeight+" headH:"+headH+" headingspace:"+headingspace );
			break;
			case "left":
			case "right":
				textH = pH - headH - headingspace;
				if(pageXMLobj.text.attributes.width){
					textW = pageXMLobj.text.attributes.width > 0 && pageXMLobj.text.attributes.width < 1 ? Number(pageXMLobj.text.attributes.width) * (pW - gutter) : Number(pageXMLobj.text.attributes.width)  ;
				}else{
					textW = Math.round((pW - gutter) / 2);
				}
				text_mc.setSize(textW,textH);
				textX = textPos == "left" ? margins[3] : pW - textW ;
				textY = margins[0] + headH + headingspace;
				text_mc.moveTo(textX,textY);
				
				form_mc._x = textPos == "right" ? margins[3] : textX + textW + gutter ;
				pane_mc._x = form_mc._x 
				form_mc._y = margins[0] + headH + headingspace;
				pane_mc._y = form_mc._y;
				paneW = (pW - textW - gutter);
				paneH = pH;
			break;
		}
		
		// result and help/error messages
		if(maxwidth){
			paneW = Math.min(maxwidth,paneW);
		}
		
		result_mc._x = form_mc._x;
		result_mc._y = form_mc._y;
		result_txt._width = paneW ;
		result_txt._x = 0;
		result_txt._y = 0;
		result_mc.close_btn._x = Math.round((paneW - result_mc.close_btn._width) / 2);
		result_mc.close_btn._y = result_txt._height + gutter;
		
		if(msgPos == "right"){
			var msgw = paneW - labelwidth - gutter;
			for(var p in formItems){
				if(formItems[p].type != "submit"){
					formItems[p].fmc.setMessageSize(msgw);
				}
			}
		}
		
		//called after everything so that the correct content w and h is passed to the scrollpane
		pane_mc.setSize(paneW,paneH,form_mc._width,form_mc._height);		
	}
}