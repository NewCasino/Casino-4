/**
 * @email mihpavlov@gmail.com
 * @author Michael Pavlov
 */

import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import com.mbudm.mbLoader;
import com.mbudm.mbLayout;

class com.mbudm.min.minPopup extends MovieClip {
	
	private var txtBox_mc:MovieClip;
	private var content_mc:MovieClip;
	private var close_mc:MovieClip;
	private var close_txt:TextField
	
	private var label_scroller:MovieClip;
	private var scrollBox:MovieClip;
	private var content_txt:TextField;
	private var pageContent:String;
	private var theme:mbTheme;
	private var layout:mbLayout;
	
	private var textBoxStyle:String = ".textBox" ;
	
	private var scrollWidth:Number;
	private var scrollGutter:Number;
	
	private var thisWidth:Number = 800;
	private var thisHeight:Number = 600;
	
	public function minPopup() {
		
	}
	
	public function init($theme:mbTheme, lyt:mbLayout):Void {
		theme = $theme;
		layout = lyt;
		scrollWidth = 10;
		scrollGutter = 8;
		
		this.createBG();
		this.createCloseBtn();
		
		/*var pageXMLobj:Object = new Object();
		
		//'objectify' the nodes for easy access  
		for(var i = 0; i < $content.firstChild.childNodes.length;i++){
			var nodeName  = $content.firstChild.childNodes[i].nodeName
			pageXMLobj[nodeName] = $content.firstChild.childNodes[i];
		}
		
		
		if(pageXMLobj.text.firstChild.nodeType == 1){
			//XHTML content
			pageContent = pageXMLobj.text.toString()
		}else{
			//CDATA or basic text.
			pageContent = pageXMLobj.text.firstChild.nodeValue;
		}
		
		
		
		txtBox_mc = this.attachMovie("mbTextBoxSymbol", "txtBox_mc", this.getNextHighestDepth());
		this.createTextField("content_txt", this.getNextHighestDepth(), 10, 10, 800, 600);
		content_txt.html = true;
		this.htmlText = pageContent;
		content_txt.htmlText = pageContent;
		content_txt.html = true;
		content_txt.wordWrap = true;
		//content_txt.autoSize = true;;
		content_txt.multiline = true;
		content_txt.condenseWhite = true;
		content_txt.selectable = true;
		
		var textBoxStObj:Object  = $theme.styles.getStyle(textBoxStyle)
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(textBoxStObj.fontFamily.substr(0,2) == "__"){
			content_txt.embedFonts = true;
		}
		
		if(!textBoxStObj.color){
			textBoxStObj.color = $theme.convertColorToHtmlColor($theme.compShades[$theme.compShades.length - 1]);
			$theme.styles.setStyle(textBoxStyle, textBoxStObj);
		}
		
		content_txt.styleSheet = $theme.styles;*/
		
		/*
		txtBox_mc.init(null, $theme);
		txtBox_mc.htxt = pageContent;
		txtBox_mc.enabled = true;
		txtBox_mc.open({target:this,onComplete:"doCallBack"});
		trace ("POPUP: " + pageContent);
		//trace ("POPUP: " + this._parent._height);
		*/
		//this.createScroll();
		
		
		
		
	}
	
	private function createBG():Void {
		var radius:Number = 3;
		//this.clear();
		var back_mc1:MovieClip =  this.createEmptyMovieClip("back_mc1", -2);
		var back_mc2:MovieClip =  this.createEmptyMovieClip("back_mc2", -1);
		back_mc2._x = 1;
		back_mc2._y = 1;
		this.drawRect(back_mc1, thisWidth, thisHeight, 0x112244, 100);
		this.drawRect(back_mc2, thisWidth - 2, thisHeight - 2, 0xffffff, 100);
		
		
		/*
		back_mc.beginFill(0xFFFFFF);
		back_mc.moveTo(0, 0);
		back_mc.lineTo(thisWidth, 0);
		back_mc.lineTo(thisWidth, thisHeight);
		back_mc.lineTo(0, thisHeight);
		back_mc.lineTo(0, 0);
		back_mc.endFill();*/
		
		
		back_mc2.onRelease = function() { };
		back_mc2.useHandCursor = false;
	}
	
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number, $alpha:Number) {
		var radius = 3;
		if(mc){
			with(mc){
				clear();
				moveTo(0,(h - radius));//start from bottom left
				beginFill(col,$alpha);
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
	
	private function createCloseBtn():Void {
		close_mc = this.createEmptyMovieClip("close_mc", this.getNextHighestDepth());
		/*close_mc.beginFill(0x000000);
		close_mc.moveTo(0, 0);
		close_mc.lineTo(100, 0);
		close_mc.lineTo(100, 25);
		close_mc.lineTo(0, 25);
		close_mc.lineTo(0, 0);
		close_mc.endFill();*/
		close_txt = close_mc.createTextField("close_txt", close_mc.getNextHighestDepth(), 0, 0, 240, 15);
		close_txt.autoSize = true;
		close_txt.multiline = false;
		close_txt.html = true;
		close_txt.htmlText = '<font face="Arial" color="black" size="15">Fermer la fenêtre</font>';
		
		
		
		close_mc.onRelease = function() {
			_parent._visible = false;
		}
	}
	
	private function createScroll():Void {
		this.createEmptyMovieClip("scrollBox", this.getNextHighestDepth());
		this.attachMovie("mbScrollerTextFieldModeSymbol", "label_scroller", this.getNextHighestDepth());
		
		//scroller theme
		var sObj:Object = new Object();
		var cols:Object = new Object();
		cols._scrollSlider = Number(theme.getStyleColor("._scrollSlider","0x"));
		if(!cols._scrollSlider)
			cols._scrollSlider = theme.compTints[1];
			
		cols._scrollSliderOver = Number(theme.getStyleColor("._scrollSliderOver", "0x"));
		if(!cols._scrollSliderOver)
			cols._scrollSliderOver = theme.compTints[2];
			
		cols._scrollTrack = Number(theme.getStyleColor("._scrollTrack", "0x"));
		if(!cols._scrollTrack)
			cols._scrollTrack = theme.compTints[3];
			
		cols._scrollButtons = Number(theme.getStyleColor("._scrollButtons", "0x"));
		if(!cols._scrollButtons)
			cols._scrollButtons = theme.compTints[1];
			
		cols._scrollButtonArrow = Number(theme.getStyleColor("._scrollButtonArrow", "0x"));
		if(!cols._scrollButtonArrow)
			cols._scrollButtonArrow = theme.compTints[3];
			
		cols._scrollButtonsOver = Number(theme.getStyleColor("._scrollButtonsOver", "0x"));
		if(!cols._scrollButtonsOver)
			cols._scrollButtonsOver = theme.compTints[2];
		
		sObj.cols = cols;
		
		sObj.cols.trackalpha = 100;
		sObj.scrollWidth = scrollWidth;
	
		label_scroller.init(content_txt, sObj);
		label_scroller._x = content_txt._width;
	}
	
	/*private function onPress():Void {
		this.startDrag();
	}
	
	private function onRelease():Void {
		this.stopDrag();
		trace ("txtBox_mc._visible: " + txtBox_mc._visible);
		txtBox_mc._visible = true;
	}*/
	
	public function set htmlText($text:String):Void {
		content_txt.htmlText = "<span class=\""+textBoxStyle.substr(1) +"\" >"+$text+"</span>";
	}
	
	public function cleanUp():Void {
		
	}
	
	public function show($content:XML):Void {
		content_mc.removeMovieClip();
		content_mc = this.attachMovie("mbTextModuleSymbol", "content_mc", this.getNextHighestDepth());
		content_mc.init($content, null, NaN, theme);
		content_mc.start(null);
		content_mc.setSize(750	, 520);
		content_mc._x = 25;
		content_mc._y = 25;
		this._x = (Stage.width - thisWidth) / 2;
		this._y = (Stage.height - thisHeight) / 2;
		
		close_mc.swapDepths(this.getNextHighestDepth());
		close_mc._x = 650;
		close_mc._y = 565;
	}
	
	public function onResize():Void {
		this._x = (Stage.width - thisWidth) / 2;
		this._y = (Stage.height - thisHeight) / 2;
		
		//trace ("POPUP W H: " + this._width + "  " + this._height);
		//trace ("POPUP W H: " + layout.getDimension("sitewidth") + "  " + layout.getDimension("siteheight"));
	}
}