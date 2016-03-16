/*
com.mbudm.min.minThumbnail.as 
extends com.mbudm.mbThumbnail

Steve Roberts August 2009 - modified from curThumbnail.as

Description
minThumbnail sets up the text or media object that the thumbanil will use, plus it handles the interaction and toolTip display.

*/


import flash.display.*;

class com.mbudm.min.minThumbnail extends com.mbudm.mbThumbnail{
	/* com.mbudm.mbThumbnail vars
	
	private var index:mbIndex;
	private var theme:mbTheme;
	private var ldr:mbLoader;
	
	private var indexNodeXML:XMLNode;
	private var thumbXML:XMLNode;
	
	private var thumbCoord:String;
	
	private var __enabled:Boolean;
	
	
	private var callbackObject:Object;

	*/
	
	private var img_mc:MovieClip;
	private var overlay_mc:MovieClip;
	private var txtBox_mc:MovieClip;
	private var btn_mc:MovieClip;
	
	private var frameXML:XMLNode;
	private var resizemode:Number;
	
	private var thumbText:String;
	private var thumbTitle:String;
	
	function minThumbnail(){
	
	}
	
	//functions to be extended
	
	private function setupThumbnail(){
	
		
		//first choice - custom image specified by thumb xml
		var imgSrc:String = thumbXML.attributes.src != undefined ? thumbXML.attributes.src : imgSrc ;
		
		if(imgSrc == undefined){
			//second choice - the src of the index node
			imgSrc= indexNodeXML.attributes.src != undefined ? indexNodeXML.attributes.src : imgSrc ;
		
			if(imgSrc == undefined){
				//third choice - get the first descendant image
				imgSrc = findSrc(indexNodeXML);
			}
		}
		if(imgSrc != undefined){
			
			//overrides
			var obj:Object = new Object();
			obj.frameid = thumbXML.attributes.frameid;
			obj.resizemode = 0; // thumbnails are always in resize mode 0, modes 1 and 2 simply do not look good.
			
			this.attachMovie("mbMediaItemSymbol","img_mc",this.getNextHighestDepth());
			img_mc.addListener(this);
			img_mc.init(theme,ldr,indexNodeXML,imgSrc,obj);
			
			
			
			if(thumbXML.hasChildNodes()){
					
				if(thumbXML.firstChild.firstChild.nodeType == 1){
					//XHTML content
					thumbText = thumbXML.firstChild.toString();
				}else{
					//CDATA or basic text.
					thumbText = thumbXML.firstChild.firstChild.nodeValue;
				}
				
			}else{
				var alt = indexNodeXML.attributes.alt != undefined ? indexNodeXML.attributes.alt : (indexNodeXML.attributes.longtitle != undefined ? indexNodeXML.attributes.longtitle : "" ) ;
				thumbTitle = indexNodeXML.attributes.title;
				thumbText = alt; 
			}
	
			
		}else{
			if(thumbXML.hasChildNodes()){
				//thumbText = thumbXML.firstChild.toString();
				if(thumbXML.firstChild.firstChild.nodeType == 1){
					//XHTML content
					thumbText = thumbXML.firstChild.toString();
				}else{
					//CDATA or basic text.
					thumbText = thumbXML.firstChild.firstChild.nodeValue;
				}
				
				
			}else{
				var longtitle = indexNodeXML.attributes.longtitle != undefined ? indexNodeXML.attributes.longtitle : "" ;
				thumbText = "<span class=\"thumbTitle\">"+indexNodeXML.attributes.title+"</span><br/><span class=\"thumbLongTitle\">"+longtitle+"</span>"; 
			}
			
			// an mbTextBox with title and longtitle or the contents of thumbXML
			txtBox_mc = this.attachMovie("mbTextBoxSymbol","txtBox_mc",this.getNextHighestDepth());
			
			txtBox_mc.init(index,theme,"MovieClip",".thumbTextBox");
			txtBox_mc.htxt = thumbText;
		}
		
		if(thumbCoord != undefined){
			//button
			btn_mc = this.createEmptyMovieClip("btn_mc",this.getNextHighestDepth());
			drawRect(btn_mc,100,100,0x000000,0);
			if(imgSrc == undefined){
				setButtonEvents(true);
			}
		}
	}
	
	private function onMediaItemReady(){
		setButtonEvents(true);
	}
	
	// find an image in the descendant XML
	private function findSrc(iX:XMLNode){
		var src:String;
		for(var i = 0; i < iX.childNodes.length; i++){
			if(iX.childNodes[i].attributes.src){
				src = iX.childNodes[i].attributes.src
			}else{
				src = findSrc(iX.childNodes[i]);
			}
			if(src != undefined){
				break;
			}
		}
		return src;
	}
	
	// relay the open and close calls to the text/media
	private function onOpen(){
		
		if(img_mc){
			img_mc.open({target:this,onComplete:"doCallBack"});
		}else{
			txtBox_mc.open({target:this,onComplete:"doCallBack"});
		}
	}
	
	private function onClose(){
	
		if(img_mc){
			img_mc.close({target:this,onComplete:"doCallBack"});
		}else{
			txtBox_mc.close({target:this,onComplete:"doCallBack"});
		}
	}
	
	public function doCallBack(){
		if(callbackObject != undefined){
			callbackObject.target[callbackObject.onComplete](callbackObject.param);
		}
	}
	
	private function setButtonEvents(toggle:Boolean){
		
		btn_mc.onRelease = toggle ? this.onBtnRelease : undefined ;
		btn_mc.onRollOver = toggle ? this.onBtnOver : undefined ;
		btn_mc.onRollOut = toggle ? this.onBtnOut : undefined ;
		btn_mc.onReleaseOutside = toggle ? this.onBtnOut : undefined ;
		btn_mc.onPress = toggle ? this.onBtnPress : undefined ;
		
	}
	
	//scoped to bg (button)
	private function onBtnRelease(){
		
		this._parent.doToolTip(false,true);
		
		//it is compulsory for minNavItem to call this function in mbThumbnail
		this._parent.onNavItemClicked();
		
	}
	
	private function onBtnOver(){
		this._parent.doToolTip(true);
	}

	private function onBtnOut(){
		
		this._parent.doToolTip(false);
	}
	
	private function onBtnPress(){
		//trace(this+" onBtnPress");
	}
	
	//Show or hide the tooltip
	private function doToolTip(b:Boolean,rapid:Boolean){
		if(img_mc){
			if(b){
				
				var ttPoint:Object = {x:img_mc._x + img_mc.actualX, y:img_mc._y + img_mc.actualY}; // create your generic point object
				this.localToGlobal(ttPoint);
				
				ttPoint.w = img_mc.actualWidth;
				ttPoint.h = img_mc.actualHeight;
				toolTip.displayToolTip(this,thumbTitle,thumbText,ttPoint,rapid);
			}else{
				toolTip.hideToolTip();// = false;
			}
		}
	}
	
	
	public function moveTo(x:Number,y:Number){
		this._x = x;
		this._y = y;
	}
	
	public function setSize(w:Number,h:Number){
		
		//take off the gutter from the available space
		var thumbW = w - gutter;
		var thumbH = h - gutter;
		
		var xpos:Number = Math.round(gutter/2);
		var ypos:Number = Math.round(gutter/2);
		
		if(img_mc){
			img_mc.moveTo(xpos,ypos);
			img_mc.setSize(thumbW,thumbH);
		}else{
			txtBox_mc.setSize(thumbW,thumbH);
			txtBox_mc.moveTo(xpos,ypos);
		}
		
		if(btn_mc){
			var wi = img_mc ? w : w - gutter - 10 ;
			drawRect(btn_mc,wi,h,0x000000,0);
			btn_mc._x = xpos;
			btn_mc._y = ypos;
		}
		
	}
	
	
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number, a:Number) {
		if(mc){
			with(mc){
				clear();
				beginFill(col, a);
				moveTo(0, 0);
				lineTo(w, 0);
				lineTo(w, h);
				lineTo(0, h);
				lineTo(0, 0);
				endFill();
			}
		}
	}
	
	public function get x():Number{
		return this._x;
	}
	
	public function get y():Number{
		return this._y;
	}
}