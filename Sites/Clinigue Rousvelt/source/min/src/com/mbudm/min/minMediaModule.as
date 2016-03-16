/*
com.mbudm.min.minMediaModule.as 
extends com.mbudm.mbMediaModule

Steve Roberts August 2009 - modified from curMediaModule.as

Description
minMediaModule handles position and sizing of the mbMediaItem instance, it also creates and handles sizing of the 'info mc'

Note - navigation for the media pages is all handled in mbSiblingNav - it is not part of the mbMediaModule

*/
import flash.display.*;
import mx.transitions.easing.Regular;

class com.mbudm.min.minMediaModule extends com.mbudm.mbMediaModule{
	/* com.mbudm.mbMediaModule vars
	
	private var indexNode:XMLNode; 
	private var indexCoord:String;
	private var media_mc:MovieClip;
	
	private var startTrigger:Boolean;
	private var contentReady:Boolean;
	
	private var callbackObject:Object;
	
	*/
	
	
	private var info_mc:MovieClip;
	private var info_btn:MovieClip;
	private var info_copy_mc:MovieClip;
	private var infocol:Number;
	private var label_txt:TextField;
	private var title_txt:TextField;
	private var infoalpha:Number;
	private var w:Number;
	private var h:Number;
	private var mw:Number;
	private var mh:Number;
	private var gutter:Number;
	private var half_gutter:Number;
	private var infobottomindent:Number;
	private var inforightindent:Number;
	private var infoleftindent:Number;
	private var infotopindent:Number;
	private var infoPos:String; // right, bottom, left
	private var infoPosDefault:String; //right, bottom, left
	private var infominbotwidth:Number;
	private var infominsidewidth:Number;
	private var infoText:String;
	private var mediaYOffset:Number;
	private var currentMediaYOffset:Number;
	
	/* transition vars */
	private var direction:Boolean; //true is fading up the info box false is fading down
	
	private var _interval:Number;
	private var _intervalFrequency:Number = 20;
	
	private var _animDuration:Number = 10;
	private var _animCount:Number = 0; 
	
	private var updating:Boolean;
	private var mediaMove:Boolean;
	private var	mediaMoveFrom:Number;
	
	
	private var labelOpen:Boolean;
	private var autoOpenLabels:Boolean;
	
	private var longdesc:XML;
	
	private var padding:Array;
	
	
	private var titleBoxStObj:Object;
	private var textBoxStObj:Object;
	
	function minMediaModule(){
		
		this.createEmptyMovieClip("info_mc",this.getNextHighestDepth());
		info_mc.createEmptyMovieClip("bg",info_mc.getNextHighestDepth());
		info_mc.createEmptyMovieClip("content",info_mc.getNextHighestDepth());
		info_mc.attachMovie("close_x","close_x_mc",info_mc.getNextHighestDepth());
		info_mc.createEmptyMovieClip("mask_mc",info_mc.getNextHighestDepth());
		info_mc.attachMovie("mbScrollerSymbol","scroller",info_mc.getNextHighestDepth());
		info_mc.createEmptyMovieClip("btn",info_mc.getNextHighestDepth());
		
		this.createEmptyMovieClip("info_copy_mc",this.getNextHighestDepth());
		
		this.createEmptyMovieClip("info_btn",this.getNextHighestDepth());
		info_btn.createEmptyMovieClip("bg",info_btn.getNextHighestDepth());
		info_btn.attachMovie("info_i","info_i_mc",info_btn.getNextHighestDepth());
		
		info_mc.btn.onRelease = onToggleLabel;
		//info_copy_mc.onRelease = onToggleLabel;
		info_btn.onRelease = onToggleLabel;
		
		info_mc._visible = false;
		info_btn._visible = false;
		info_btn._alpha = 0;
		info_copy_mc._alpha = 0;
		
	}
	
	//functions to be extended
	private function setupModule(){
		
		// these are also set up on update
		setupLongdesc();
		setupInfoPosDefault();
		
		gutter = mediaXML.attributes.gutter != undefined ? Number(mediaXML.attributes.gutter) : 10;
		infoalpha = mediaXML.attributes.infoalpha != undefined ? Number(mediaXML.attributes.infoalpha) : 50;
		inforightindent = mediaXML.attributes.inforightindent != undefined ? Number(mediaXML.attributes.inforightindent) : gutter;
		infobottomindent = mediaXML.attributes.infobottomindent != undefined ? Number(mediaXML.attributes.infobottomindent) : gutter;
		infoleftindent = mediaXML.attributes.infoleftindent != undefined ? Number(mediaXML.attributes.infoleftindent) : gutter;
		infotopindent = mediaXML.attributes.infotopindent != undefined ? Number(mediaXML.attributes.infotopindent) : gutter;
		infominbotwidth = mediaXML.attributes.infominbotwidth != undefined ? Number(mediaXML.attributes.infominbotwidth) : 200;
		infominsidewidth = mediaXML.attributes.infominsidewidth != undefined ? Number(mediaXML.attributes.infominsidewidth) : 150;
		
		currentMediaYOffset = 0;
		
		half_gutter = Math.round(gutter/2);
		
		autoOpenLabels = mediaXML.attributes.infolabels == "auto" ? true : false ;
	
		// bg color
		infocol = Number(theme.getStyleColor("._mediaInfoBackground","0x"));
		if(isNaN(infocol))
			infocol = theme.compShades[theme.compShades.length - 1];
		
	
		title_txt = info_mc.content.createTextField("title_txt",info_mc.content.getNextHighestDepth(),0,0,100,20);
		title_txt.html = true;
		title_txt.wordWrap = true;
		title_txt.multiline = true;
		title_txt.autoSize = true;
		title_txt.condenseWhite = true;
		title_txt.selectable = true;
		
		titleBoxStObj  = theme.styles.getStyle(".mediaInfoTitle")
		//If the font is preceded with __ then it is assumed to be an embedded font

		if(titleBoxStObj.fontFamily.substr(0,2) == "__"){
			title_txt.embedFonts = true;
		}
		
		if(!titleBoxStObj.color){
			titleBoxStObj.color = theme.convertColorToHtmlColor(theme.compShades[theme.compShades.length-1]);
			theme.styles.setStyle(".mediaInfoTitle",titleBoxStObj);
		}
		
		title_txt.styleSheet = theme.styles;
		
		
	
		label_txt = info_mc.content.createTextField("label_txt",info_mc.content.getNextHighestDepth(),0,0,100,20);
		label_txt.html = true;
		label_txt.wordWrap = true;
		label_txt.multiline = true;
		label_txt.autoSize = true;
		label_txt.condenseWhite = true;
		label_txt.selectable = true;
		
		
		textBoxStObj  = theme.styles.getStyle(".mediaInfoAlt")
		//If the font is preceded with __ then it is assumed to be an embedded font

		if(textBoxStObj.fontFamily.substr(0,2) == "__"){
			label_txt.embedFonts = true;
		}
		
		if(!textBoxStObj.color){
			textBoxStObj.color = theme.convertColorToHtmlColor(theme.compShades[theme.compShades.length-1]);
			theme.styles.setStyle(".mediaInfoAlt",textBoxStObj);
		}
		
		label_txt.styleSheet = theme.styles;
		

		title_txt._x = half_gutter;
		title_txt._y = half_gutter;
		
		label_txt._x = half_gutter;
		
		setInfoText();
		
		// info btn
		drawRect(info_btn.bg,2 * gutter,2 * gutter,infocol,infoalpha);
		info_btn.info_i_mc._height = gutter;
		info_btn.info_i_mc._xscale = info_btn.info_i_mc._yscale;
		info_btn.info_i_mc._x = Math.round(((gutter * 2) - info_btn.info_i_mc._width ) /2 )
		info_btn.info_i_mc._y = half_gutter
		
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
		
		sObj.cols.trackalpha = 0;
		sObj.scrollWidth = 10;
	
		info_mc.scroller.init(info_mc.content,info_mc.mask_mc,false,sObj);
	}
	
	private function setupLongdesc(){
		if(indexNode.attributes.longdesc){
				var obj = new Object();
				obj.url = indexNode.attributes.longdesc;
				obj.label = "longdesc XML";
				obj.target = this;
				obj.onLoad = "onLongdescXMLLoaded";
				obj.type = "xml";
				ldr.loadRequest(obj);
		}else{
			longdesc = undefined;
		}
	}
	
	private function setupInfoPosDefault(){
		// is there a default position request for the site or for this node?
		
		if(indexNode.attributes.infopos){
			infoPosDefault = indexNode.attributes.infopos;
		}else if(mediaXML.attributes.infopos){
			infoPosDefault = mediaXML.attributes.infopos;
		}else{
			infoPosDefault = undefined;
		}
	}
	
	private function onLongdescXMLLoaded(o:Object){
		longdesc  = o.data;
		setInfoText();
	}
	
	private function setInfoText(){
		title_txt.htmlText = "<span class=\"mediaInfoTitle\">"+indexNode.attributes.title+"</span>";
		if(longdesc == undefined){
			var alt = indexNode.attributes.alt != undefined ? indexNode.attributes.alt : "" ;
			label_txt.htmlText = "<span class=\"mediaInfoAlt\">"+alt+"</span>"; 
		}else{
			var longdescContent
			if(longdesc.firstChild.nodeType == 1){
				//XHTML content
				longdescContent = longdesc.toString()
			}else{
				//CDATA or basic text.
				longdescContent = longdesc.firstChild.nodeValue;
			}
			label_txt.htmlText = "<span class=\"mediaInfoAlt\">"+longdescContent+"</span>"; 
			setInfoSize();
		}
		
	}
	
	//scoped to info_mc and info_btn
	private function onToggleLabel(){
		//trace("onToggleLabel "+ this);
		if(this._name == "info_btn"){
			this._parent.toggleLabel(true);
		}else{
			this._parent._parent.toggleLabel(false);
		}
		
	}
	
	private function toggleLabel(t:Boolean){
		labelOpen = t;
		
		setInfoSize();
		
		info_btn._visible = !labelOpen;
		//info_copy_mc._visible = labelOpen;
		setInfoLabelVisibility();
		
		if(currentMediaYOffset != mediaYOffset){
			_animCount = 0;
			startInterval();
		}
			
	}
		
	private function startModule(){
		if(startTrigger && contentReady){
			media_mc.open({target:this,onComplete:"onMediaOpened"});
		}
	}
	
	private function updateModule(){
		direction = false;
		startInterval();
	}
	
	
	private function endModule(){
		//call onModuleClosed() when done
		media_mc.close({target:this,onComplete:"onMediaClosed"});
	}

	
	//  - notify (via the index object) any elements that need to know that the page is visually ready
	public function onMediaUpdated(){
		setupLongdesc();
		setupInfoPosDefault();
		
		setInfoText();
		setInfoSize();
		direction = true;
		startInterval();
		doCallBack();
		
		index.broadcastIndexContentReady();
	}
	
	//  - notify (via the index object) any elements that need to know that the page is visually ready
	public function onMediaOpened(){
		toggleLabel(autoOpenLabels);
		direction = true;
		startInterval();
		
		doCallBack();
		
		index.broadcastIndexContentReady();
	}
	
	public function onMediaClosed(){
		doCallBack();
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
				//opening or just moving to a new y offset
				if(_animCount == 0){
					if(currentMediaYOffset != mediaYOffset){
						mediaMoveFrom = currentMediaYOffset;
					}
				}
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
		
		
		if(direction != undefined){
			info_copy_mc._alpha = factor * 100;
			info_btn._alpha = info_copy_mc._alpha;
		}
	
		if(direction != false && currentMediaYOffset != mediaYOffset){
			var dist = factor * (mediaYOffset - mediaMoveFrom );
			currentMediaYOffset = mediaMoveFrom + dist;	
		}
		setMediaPosition();
		
		setInfoLabelVisibility();
	}
	
	private function setInfoLabelVisibility(){
		if(labelOpen){
			
			info_copy_mc._visible = _animCount < _animDuration ? true : false;
			info_mc._visible = _animCount == _animDuration ? true : false;
		}else{
			info_copy_mc._visible = false;
			info_mc._visible = false;
		}
	}
	
	public function setSize(wi:Number,he:Number){
		w = wi;
		h = he;
		
		// - order is like css Top, right, bottom , left
		padding = mediaXML.attributes.padding ? mediaXML.attributes.padding.split(",") : [0,0,0,0];
		
		// convert padding values to pixels if they are fractions - order is like css Top, right, bottom , left
		var dimension:Number;
		for(var i = 0 ; i < padding.length; i++){
			dimension = i == 0 || i == 2 ? h : w ;
			padding[i] = padding[i] > 0 && padding[i] < 1 ? Number(padding[i]) * dimension : Number(padding[i]) ;
		}
		
		//media sizes
		mw = w - padding[1] - padding[3];
		mh = h - padding[0] - padding[2];
		
		media_mc.setSize(mw,mh);
		setMediaPosition();
		setInfoSize();
		
		if(currentMediaYOffset != mediaYOffset){
			_animCount = 0;
			startInterval();
		}
		
	}
	
	private function setMediaPosition(){
		media_mc._x = padding[3];
		media_mc._y = padding[0] + currentMediaYOffset;
		
	}
	
	// work out the best position for the info item - either to the right or to the bottom of the media item
	// wherever there is the most space.
	// This can be overriddedn by infoPosDefault
	// - A scrollbar is displayed if the maximum height is reached
	// - if there is a long description then the bottom position increases it's wit=dth to 3/4 of the image rather than 1/2
	private function setInfoSize(){
		var right = Math.round((w - media_mc.actualWidth)/2);
		var left = right;
		var bottom = Math.round((h - media_mc.actualHeight)/2);
		/*
		var outsideright = right + layout.getDimension("marginright") - inforightindent;
		var outsideleft = left + layout.getDimension("marginleft") - infoleftindent;
		var outsidebottom = bottom + layout.getDimension("marginbottom") - infobottomindent;
		*/
		
		var outsideright = right - inforightindent;
		var outsideleft = left - infoleftindent;
		var outsidebottom = bottom - infobottomindent;
		
		
		var maxHeight;
		var textWidth;
		var infoW;
		var infoH;
		
		if(infoPosDefault == undefined){
			// better auto positioning - poss move to curMediaModule
			var mediaWratio = media_mc.actualWidth / media_mc.actualHeight;
			var screenWratio = mw / mh;
			if( mediaWratio > screenWratio){
				infoPos = "bottom";
			}else{
				infoPos = "right";
			}
		}else{
			infoPos = infoPosDefault;
		}
		
		
		var minInfoW = infoPos == "bottom" ? infominbotwidth : infominsidewidth ; // minimum for readability
		// at least enough height to show the title and label first line - handled below only neede in bottom mode.
		var minInfoH;
		var labelMinSize = !isNaN(textBoxStObj.fontSize) ? Math.round(Number(textBoxStObj.fontSize) * 1.6) : 18 ;
		
		if(!labelOpen){
			switch(infoPos){
				case "right":
					info_btn._x = padding[3] + media_mc.actualX + media_mc.actualWidth + gutter;
					info_btn._y = padding[0] + media_mc.actualY + media_mc.actualHeight - info_btn._height;
				break;
				case "bottom":
					info_btn._x = padding[3] + media_mc.actualX + media_mc.actualWidth - info_btn._width;
					info_btn._y = padding[0] + media_mc.actualY + media_mc.actualHeight + gutter;
				break;
				case "left":
					info_btn._x = padding[3] + media_mc.actualX - gutter - info_btn._width;
					info_btn._y = padding[0] + media_mc.actualY + media_mc.actualHeight - info_btn._height;
				break;
			}
			mediaYOffset = 0;
		}else{
			switch(infoPos){
				case "right":
					maxHeight = Math.round(media_mc.actualHeight*0.4);
					textWidth = Math.max(outsideright,minInfoW) - gutter;
					title_txt._width = textWidth ;
					label_txt._width = textWidth ;
					
					label_txt._y = Math.round(title_txt._y + title_txt._height);
					
					infoH = label_txt._y + label_txt._height + gutter;
					infoW = textWidth + gutter;
					
					mediaYOffset = 0;
					
					var heightToUse = Math.min(infoH,maxHeight);
					
					info_mc._x = Math.round(padding[3] + media_mc.actualX + media_mc.actualWidth + gutter);
					info_mc._y = Math.round(padding[0] + media_mc.actualY + media_mc.actualHeight - heightToUse);
				
				break;
				case "bottom":
					
					maxHeight = layout.getDimension("siteheight") - media_mc.actualHeight - infobottomindent - infotopindent - gutter; 
					
					media_mc.actualHeight - gutter;
					if(longdesc == undefined){
						textWidth = Math.max(Math.round(media_mc.actualWidth/2), minInfoW) - gutter;
					}else{
						textWidth =  Math.max(Math.round(media_mc.actualWidth * 3/4), minInfoW) - gutter;
					}
					title_txt._width = textWidth
					label_txt._width = textWidth;
					
					label_txt._y = Math.round(title_txt._y + title_txt._height);
					
					minInfoH = label_txt.text.length > 0 ? label_txt._y  + Math.min(label_txt._height,labelMinSize)  + gutter : label_txt._y + gutter;
					
					
					infoH = label_txt._y + label_txt._height + gutter;
					infoW = textWidth + gutter;
					
					var heightToUse = Math.min(infoH,maxHeight) < minInfoH ? minInfoH : Math.min(infoH,maxHeight) ; 
					
					maxHeight = heightToUse;
					mediaYOffset = outsidebottom - (heightToUse) - gutter;
					mediaYOffset = Math.min(0,mediaYOffset);
					
					
					info_mc._x = Math.round(padding[3] + media_mc.actualX + media_mc.actualWidth - infoW);
					info_mc._y = Math.round(padding[0] + media_mc.actualY + media_mc.actualHeight + gutter + mediaYOffset);
				break;
				case "left":
					
					maxHeight = Math.round(media_mc.actualHeight*0.4);
					textWidth = Math.max(outsideleft,minInfoW) - gutter;
					title_txt._width = textWidth ;
					label_txt._width = textWidth ;
					
					label_txt._y = Math.round(title_txt._y + title_txt._height);
					
					infoH = label_txt._y + label_txt._height + gutter;
					infoW = textWidth + gutter;
					
					mediaYOffset = 0;
					var heightToUse = Math.min(infoH,maxHeight);
					
					info_mc._x = Math.round(padding[3] + media_mc.actualX - gutter - infoW);
					info_mc._y = Math.round(padding[0] + media_mc.actualY + media_mc.actualHeight - heightToUse);
				
				break;
			}
			
			
			// scrollbar needed?
			if(infoH > maxHeight){
				var scrollH = maxHeight - gutter;
				info_mc.scroller.setSize(gutter,scrollH,infoW,(infoH-gutter));
				drawRect(info_mc.mask_mc,infoW,maxHeight - gutter,0x000000,100);
				info_mc.content.setMask(info_mc.mask_mc);
				info_mc.mask_mc._x = half_gutter;
				info_mc.mask_mc._y = half_gutter;
				info_mc.scroller.moveTo(half_gutter, half_gutter); 
				title_txt._width = textWidth - gutter - half_gutter ;
				label_txt._width = textWidth - gutter - half_gutter ;
				title_txt._x = gutter * 2;
				label_txt._x = gutter * 2;
					
				info_mc.mask_mc._visible = true;
				info_mc.scroller._visible = true;
				
				drawRect(info_mc.bg,infoW,maxHeight,infocol,infoalpha);
				drawRect(info_mc.btn,(infoW - (gutter * 2)),maxHeight,0x00ff00,0);
				info_mc.btn._x = (gutter * 2);
			}else{
				info_mc.content.setMask(null);
				info_mc.mask_mc._visible = false;
				info_mc.scroller._visible = false;
				drawRect(info_mc.bg,infoW,infoH,infocol,infoalpha);
				drawRect(info_mc.btn,infoW,infoH,0xff0000,0);
				info_mc.btn._x = 0;
				title_txt._x = half_gutter;
				label_txt._x = half_gutter;
			}
			
			// if there has beenan update and the label was scrolled then this will have moved
			info_mc.content._y = 0;
				
			info_mc.close_x_mc._x = infoW - info_mc.close_x_mc._width - half_gutter;
			info_mc.close_x_mc._y = half_gutter;
		
			
			info_copy_mc._x = info_mc._x;
			info_copy_mc._y = info_mc._y;
			
			var iw = info_mc.bg._width;
			var ih = info_mc.bg._height;
			var bmpData:BitmapData = new BitmapData(iw, ih, true, 0x000000); 
			bmpData.draw(info_mc);
			info_copy_mc.attachBitmap(bmpData, 2, "auto", true); 
			
		}
	}
	
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number, a:Number) {
		var radius = 3;
		if(mc){
			with(mc){
				clear();
				moveTo(0,(h - radius));//start from bottom left
				beginFill(col,a);
				lineTo(0,(radius));
				curveTo(0,0,(radius),0);
				lineTo((w -radius),0);
				curveTo((w),0,(w), (radius));
				lineTo((w),(h - radius));
				curveTo((w),(h),(w -radius),(h));
				lineTo((radius),(h));
				curveTo(0,(h),0,(h -radius));
				endFill();
			}
		}
	}
}