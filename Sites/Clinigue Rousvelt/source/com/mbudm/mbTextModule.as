/*
com.mbudm.mb.mbTextModule.as 
extends MovieClip

Steve Roberts May 2009

Description
mbTextModule is a page module that instantiates an instance of mbTextBox and if specified, it produces the TOC list data using the mbTableOfContents class.

Standard module tasks, such as handling page layout and relaying load requests to the mbLoader instance are also included in this class.

July 2009 - Updated to check for CDATA content, new private var pageContent

*/
import TextField.StyleSheet;
import com.mbudm.mbTableOfContents;
import com.mbudm.mbIndex;
import com.mbudm.mbTheme;

class com.mbudm.mbTextModule extends MovieClip{
	private var indexNode:XMLNode; 
	private var indexCoord:String;
	private var index:mbIndex;
	private var pageXML:XML; 
	private var pageXMLobj:Object;
	private var txtBox_mc:MovieClip;
	private var toc_enabled:Boolean;
	private var toc:mbTableOfContents;
	private var toc_list:Array;
	private var theme:mbTheme;
	
	private var pageContent:String;
	
	private var startTrigger:Boolean;
	private var contentReady:Boolean;
	
	private var callbackObject:Object;
	
	function mbTextModule(){
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
		
		
		if(pageXMLobj.text.firstChild.nodeType == 1){
			//XHTML content
			pageContent = pageXMLobj.text.toString()
		}else{
			//CDATA or basic text.
			pageContent = pageXMLobj.text.firstChild.nodeValue;
		}
		
		toc_enabled = pageXMLobj.toc.attributes.enabled;
		
		txtBox_mc = this.attachMovie("mbTextBoxSymbol", "txtBox_mc", this.getNextHighestDepth());
		
		if(toc_enabled){
			txtBox_mc.init(index, theme, "TextField");
			createTOC();
		}else{
			txtBox_mc.init(index,theme);
			
			txtBox_mc.htxt = pageContent;
		}
		createHeading();
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
		txtBox_mc.close({target:this,onComplete:"doCallBack"});
	}
	private function doCallBack() {
		//trace ("DO CALLBACK");
		if(callbackObject != undefined){
			callbackObject.target[callbackObject.onComplete](callbackObject.param);
		}
	}
	
	private function startModule() {
		//trace ("START TEXT MODULE");
		if(startTrigger && contentReady){
			//this._visible = true;
			txtBox_mc.open({target:this,onComplete:"doCallBack"});
			onModuleStarted();
		}
	}
	
	private function createTOC(){
		toc = new mbTableOfContents();
		toc.init(pageContent,txtBox_mc,pageXMLobj.toc.attributes.tag,pageXMLobj.toc.attributes.marker);	
		toc.addListener(this);
	}
	
	private function onTOCListReady(){
		toc_list = toc.getTOC();
		createTOCmenu();
	}
	
	//override functions
	private function createHeading(){
	}
	private function createTOCmenu(){
	}
	
	private function onModuleStarted(){
	}
	public function setSize(w:Number,h:Number){
	}
}