/*
com.mbudm.mb.mbContent.as 
extends MovieClip

Steve Roberts May 2009
Updated August 2009

Description
mbContent essentially loads and unloads the content specified in the current index node. It also tells its' extended class when to start a transition.

on an index update
 - start the transition
 - delete the old page
 - create the new page
  - load the content for the new page (xml and/or swf)
 - when the transition is complete and the new page is loaded, tell the page to start
 
*/

import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import com.mbudm.mbLayout;
import com.mbudm.mbLoader;
import com.mbudm.mbTransitionController;

class com.mbudm.mbContent extends MovieClip{
	
	private var contentXML:XMLNode; // content specific layout settings
	private var contentXMLobj:Object; // content xml can have child nodes that are passed to the module type
	private var ldr:mbLoader;
	private var index:mbIndex;
	
	private var currentItem:XMLNode;
	private var contentCoord:String;
	
	private var transition_mc:MovieClip; // the transition graphics sit behind the content_mc
	private var content_mc:MovieClip;
	private var theme:mbTheme;
	private var nav:MovieClip; // the nav is refernced in case the content wants to interact with the selected nav item
	
	private var contentReady:Boolean; // These two booleans are used to determine if the new page can start
	private var transition:Boolean;
	private var okToLoad:Boolean;
	
	private var layout:mbLayout;
	private var tController:MovieClip;
	private var toolTip;

	private var updating:Boolean; // for media (img/video nodes) where the same module (mediaModule) is reused in content_mc
	

	function mbContent(){
	}
	
	public function init(cX:XMLNode,i:mbIndex,l:mbLoader,t:mbTheme,lyt:mbLayout,n:MovieClip,tC:MovieClip,tT:MovieClip) {
		contentXML = cX;
		ldr = l;
		index = i;
		theme = t;
		nav = n;
		
		layout = lyt;
		tController = tC;
		toolTip = tT;
		
		okToLoad = true;
		updating = false;
		
		this.createEmptyMovieClip("transition_mc",this.getNextHighestDepth());
		
		//'objectify' the nodes for easy access  
		contentXMLobj = new Object();
		for(var i = 0; i < contentXML.childNodes.length;i++){
			 contentXMLobj[contentXML.childNodes[i].nodeName] = contentXML.childNodes[i];
		}
		
	}
	
	// listens to broadcast from the mbIndex instance
	public function onIndexUpdate() {
		
		if (okToLoad) {
			if(contentCoord != index.currentIndex){
				okToLoad = false;
				contentCoord = index.currentIndex;
				contentReady = false;
				onResize();
				var nextNode = index.getNodeType(index.currentIndex);
				if((nextNode == "img" || nextNode == "video") && (currentItem.nodeName  == "img" || currentItem.nodeName  == "video")){	
					updateMedia();
				}else{
					startTransition();
					deleteContent();
				}
			}
		}
	}
	
	private function deleteContent(){
		if(content_mc){
			// let the extending class handle the end transition
			endContent();
		}else {
			onDeletedContent();
		}
	}
	
	// called from extended class if there is a content_mc to be 'ended' then it has been done
	private function onDeletedContent(){
		if(content_mc){
			content_mc.removeMovieClip();
		}
		addContent();
	}
	
	private function updateMedia(){
		content_mc.update(index.currentIndex);
		contentReady = true;
		okToLoad = true;
	}
			
	// determine the module type that is needed and set it up
	private function addContent(){

		currentItem = index.getItemAt(index.currentIndex);
		var obj:Object = new Object();
		var currNodeType = index.getNodeType();
				
		switch(currNodeType){
			
			case "external":
				content_mc = this.attachMovie("mbExternalModuleSymbol","content_mc",this.getNextHighestDepth());
				onContentAttached();
				content_mc.init(index,index.currentIndex,theme,ldr);
				contentReady = true;
				initialiseContent();
			break;
			case "img":
			case "video":
				content_mc = this.attachMovie("mbMediaModuleSymbol","content_mc",this.getNextHighestDepth());
				onContentAttached();
				content_mc.init(index,index.currentIndex,theme,ldr,layout,contentXMLobj.media);
				contentReady = true;
				initialiseContent();
			break;
			default:
				var SymbolName:String;
				var XMLurl:String;
				switch(currNodeType){
					case "text":
						SymbolName = "mbTextModuleSymbol";
					break;
					case "index":
						SymbolName = "mbIndexModuleSymbol";
					break;
					case "form":
						SymbolName = "mbFormModuleSymbol";
					break;
				}
				if(SymbolName != undefined){
					
					content_mc = this.attachMovie(SymbolName,"content_mc",this.getNextHighestDepth());
					onContentAttached();
					obj.url = currentItem.attributes.url;
					obj.label = currentItem.attributes.title + " XML";
					obj.target = this;
					obj.onLoad = "onPageXMLLoaded";
					obj.type = "xml";
					obj.coord = index.currentIndex;
					ldr.loadRequest(obj);
				}else{
					trace("The symbol for:  "+currNodeType+" could not be found in the Library");
					trace("currentItem:"+currentItem);
				}
			break;
		}
		
	}
	
	// the xml for the newly added module is loaded
	private function onPageXMLLoaded(o:Object){
					
		if(o.coord == index.currentIndex){
			content_mc.init(o.data,index,index.currentIndex,theme,ldr,toolTip);
			contentReady = true;	
			initialiseContent();
		}
	}
	
	private function initialiseContent(){
		if(!transition && contentReady){
			// the transistion must be complete and the content ready before the page can start
			startContent(); // let the extending class do a start transition
			onResize();
			okToLoad = true;
		}
	}
	
	// called when the start transition is complete
	private function onAddedContent(){
		
	}
	
	// extendables
	
	private function onContentAttached(){
	}
	
	private function endContent(){
	}
	
	private function startContent(){
	}
	
	private function startTransition(){ 
		//transition = true;
	}
	
	private function onTransitionComplete(){ 
		transition = false;
		//initialiseContent();
	}
	
	public function onResize(){ 
		//listens to stage 
		// this will be overwriten by extensions of this class
	}
}