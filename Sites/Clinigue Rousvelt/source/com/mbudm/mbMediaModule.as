/*
com.mbudm.mb.mbMediaModule.as 
extends MovieClip

Steve Roberts June 2009

Description
mbMediaModule is a page module that sets up an instance of mbMediaItem. 
Further navigation and information objects are determined by the extending class

Standard module tasks, such as listening to page layout and index as well as setting up the references to required objects are handled here
*/
import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import com.mbudm.mbLoader;
import com.mbudm.mbLayout;

class com.mbudm.mbMediaModule extends MovieClip{
	private var indexNode:XMLNode; 
	private var indexCoord:String;
	private var index:mbIndex;
	private var theme:mbTheme;
	private var ldr:mbLoader;
	private var layout:mbLayout;
	private var mediaXML:XMLNode;
	private var media_mc:MovieClip;
	
	private var startTrigger:Boolean;
	private var contentReady:Boolean;
	
	private var callbackObject:Object;
	
	function mbMediaModule(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init(ind:mbIndex,iC:String,t:mbTheme,l:mbLoader,lyt:mbLayout,mXML:XMLNode) {
		
		index = ind;
		indexCoord = iC;
		indexNode = index.getItemAt(indexCoord);
		theme = t;
		ldr = l;
		layout = lyt;
		
		mediaXML = mXML;
		//this._visible = false;
		
		this.attachMovie("mbMediaItemSymbol","media_mc",this.getNextHighestDepth());
		media_mc.init(theme,ldr,indexNode,indexNode.attributes.fullsrc);
		
		setupModule();
		
		
		setSize();
		contentReady = true;
		startModule();
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
	
	// called by mbContent
	public function update(iC:String){
		//callbackObject = undefined; // remove any leftover callback object
		indexCoord = iC;
		indexNode = index.getItemAt(indexCoord);
		media_mc.update(indexNode,indexNode.attributes.fullsrc,{target:this,onComplete:"onMediaUpdated"});
		updateModule();
	}
	
	private function doCallBack(){
		if(callbackObject != undefined){
			callbackObject.target[callbackObject.onComplete](callbackObject.param);
		}
	}
	
	//override functions
	
	private function setupModule(){
	
	}
	
	private function startModule(){
		/*
		if(startTrigger && contentReady){
			media_mc.open();
			this._visible = true;
		}
		*/
	}
	
	private function updateModule(){
	}
	
	private function endModule(){
		/*
		//call onModuleClosed() when done
		media_mc.close({target:this,onComplete:"onMediaClosed"});
		*/
	}
	
	public function onMediaClosed(){
		//onModuleClosed();
	}
	public function onMediaOpened(){
	
	}
	
	public function setSize(w:Number,h:Number){
		//media_mc.setSize(w,h);
	}
}