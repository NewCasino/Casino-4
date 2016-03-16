/*
com.mbudm.mb.mbExternalModule.as 
extends MovieClip

Steve Roberts May 2009

Description
mbExternalModule loads the specified external SWF file and if the parameters dictate, calls a custom 
initialise function and an on resize method in the external SWF.

It uses a mask to hide any parts of the external SWf that go beyond the bounds of the alootted space for this page
 
*/

import com.mbudm.mbIndex;
import com.mbudm.mbTheme;

class com.mbudm.mbExternalModule extends MovieClip{
	private var indexNode:XMLNode; 
	private var indexCoord:String;
	private var index:mbIndex
	private var pageXML:XML; 
	private var pageXMLobj:Object;
	private var txtBox_mc:MovieClip;
	private var theme:mbTheme; // not used but if required the theme could be passed to the external SWF
	private var external_mc:MovieClip;
	private var mask_mc:MovieClip;
	private var ldr:MovieClip;
	private var startTrigger:Boolean;
	private var contentReady:Boolean;
	private var callbackObject:Object;
	
	private var w:Number;
	private var h:Number;
	
	
	function mbExternalModule(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init(ind:mbIndex,iC:String,t:mbTheme,l:MovieClip) {
		
		this._visible = false;
		
		index = ind;
		indexCoord = iC;
		indexNode = index.getItemAt(indexCoord);

		theme = t;
		ldr = l;
	
		this.createEmptyMovieClip("external_mc",10);
		
		var obj:Object = new Object();
		obj.url = indexNode.attributes.url;
		obj.label = indexNode.attributes.title;
		obj.target = this.external_mc;
		obj.onLoad = "onExternalSWFLoaded";
		obj.onLoadTarget = this;
		obj.type = "swf";
		ldr.loadRequest(obj);
		
		this.createEmptyMovieClip("mask_mc",20);
	
		this.setMask(this.mask_mc);
	}
	
	public function onExternalSWFLoaded(o:Object){
		this.external_mc.setMask(this.mask_mc);		
		// if set to do so, tell the external SWF to initialise and pass the specified parameter
		if(indexNode.attributes.onload){
			this.external_mc[indexNode.attributes.onload](indexNode.attributes.onloadparams);
		}
		setExternalResize();
		contentReady = true;
		startModule();
	}
	
	// called by mbContent
	public function start(o:Object){
		callbackObject = o;
		startTrigger = true;
		startModule();
	}
	
	private function startModule(){
		if(startTrigger && contentReady){
			this._visible = true;
			doCallBack();
		}
	}
	
	// called by mbContent
	public function end(o:Object){
		callbackObject = o;
		if(startTrigger && contentReady){
			this.external_mc.removeMovieClip();
		}
		doCallBack();
	}
	
	private function doCallBack(){
		if(callbackObject != undefined){
			callbackObject.target[callbackObject.onComplete](callbackObject.param);
		}
	}
	
	// if set to do so, tell the external SWF to resize
	private function setExternalResize(){
		if(indexNode.attributes.onresize){
			this.external_mc[indexNode.attributes.onresize](w, h);
		}
	}
	
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number) {
		if(mc){
			with(mc){
				clear();
				beginFill(col, 100);
				moveTo(0, 0);
				lineTo(w, 0);
				lineTo(w, h);
				lineTo(0, h);
				lineTo(0, 0);
				endFill();
			}
		}
	}
	public function setSize(wi:Number,he:Number){
		this.w = wi;
		this.h = he;
		drawRect (mask_mc, w, h, theme.baseColor);
		onResize();
		setExternalResize();
	}
	
	//override functions
	private function onResize(){
	}
	
	private function onExternalSWFReady(){
	}
	
	
}