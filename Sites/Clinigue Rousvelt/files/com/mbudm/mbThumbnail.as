/*
com.mbudm.mb.mbThumbnail.as 
extends MovieClip

Steve Roberts June 2009

Description
mbThumbnail is the base class for thumbnails in the mbIndexModule
	
*/

import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import com.mbudm.mbLoader;

class com.mbudm.mbThumbnail extends MovieClip{
	
	private var index:mbIndex;
	private var theme:mbTheme;
	private var ldr:mbLoader;
	
	private var indexNodeXML:XMLNode;
	private var thumbXML:XMLNode;
	
	private var thumbCoord:String;
	
	private var gutter:Number;
	
	private var __enabled:Boolean;
	
	private var __gridPosition:Object;
	
	private var callbackObject:Object;
	
	private var toolTip:MovieClip;
	
	function mbThumbnail(){
	
	}
	
	public function init(ind:mbIndex,t:mbTheme,l:mbLoader,tT:MovieClip,cX:XMLNode,g:Number,tX:XMLNode,tCoord){
		index = ind;
		theme = t;
		ldr = l;
		toolTip = tT;
		
		gutter = g;
		
		indexNodeXML = tX;
		thumbCoord = tCoord;
		thumbXML = cX;
		if(thumbXML != undefined){
			var obj = new Object({c:(Number(thumbXML.attributes.cols)),r:(Number(thumbXML.attributes.rows)),x:(Number(thumbXML.attributes.x)),y:(Number(thumbXML.attributes.y))});
			this.gridPosition = obj;
		}
		
		setupThumbnail();
		
	}
	
	// a grid position object must have columns, rows, x and y
	public function set gridPosition(o:Object){
		if((o.c + o.r + o.x + o.y) > 0){
			__gridPosition = o;
		}
	}
	
	public function get gridPosition():Object{
		return __gridPosition;
	}
	
	// compulsory on release method for the extending class to call
	private function onNavItemClicked(){
		index.currentIndex = thumbCoord;
	}
	
	public function open(o:Object){
		callbackObject = o;
		onOpen();
	}
	
	public function close(o:Object){
		callbackObject = o;
		onClose();
	}

	//override functions
	private function setupThumbnail(){
		
	}
	
	private function onOpen(){
	
	}
	
	private function onClose(){
		
	}
	
	public function setSize(w:Number,h:Number){
		
	}
}