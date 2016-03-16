/*
com.mbudm.mbInit.as 
extends MovieClip

Steve Roberts May 2009

Description
mbInit initialise the mbudm#001 template. The initialisation process follows this sequence:

mbInit
	- passed mbLoader
		- requests mbLoader load init.xml
		- requests mbLoader load index.xml
		
	- instantiates and initialises mbTheme (passes theme node of init.xml)
	
	- instantiates and initialises mbIndex (passes index.xml)
	
	- instantiates and initialises mbTransitionController
	
	- establishes connection with external objects
		- flurl (deep linking)
	
	- instantiates and initialises all graphical items:
		- mbNavigation 
		- mbLayout
		- mbBackground
		- mbLogo 
		- mbFooter
		
	- determines start coordinate and passes this to instance of mbIndex
		
*/

import flash.display.*;
import fl.controls.*;
import flash.external.*;
import flash.net.*;
import flash.events.*;

import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import com.mbudm.mbLayout;

class com.mbudm.mbInit extends MovieClip{
	
	private var ldr:MovieClip;
	private var initXMLobj:Object;
	
	private var theme:mbTheme;
	private var index:mbIndex;
	private var layout:mbLayout;
	private var nav:MovieClip;
	private var content:MovieClip;
	private var bg:MovieClip;
	private var logo:MovieClip;
	private var footer:MovieClip;
	private var scrollpane:MovieClip;
	private var siblingnav:MovieClip;
	private var toolbar:MovieClip;
	private var toolTip:MovieClip;
	private var popup_mc:MovieClip;
	
	private var transitionController:MovieClip;
	
	private var swfa_mc:MovieClip;
	
	private var broadcaster:Object;
	
	function mbInit(){
		initXMLobj =  new Object();
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
	}
	
		
	public function addListener(obj:Object){
		broadcaster.addListener(obj);
	}
	
	public function init(l:MovieClip,s:MovieClip) {
		
		ldr = l;
		swfa_mc = s;
		
		
		// the initialisation xml is the only data file that is hard coded
		var obj:Object = new Object();
		
		// the only ref to root in the template - allows a custom init file to be passed with the embedded flash object
		obj.url = _root._init ? _root._init : "data/init.xml";
		obj.label = "Init xml";
		obj.target = this;
		obj.onLoad = "initXMLLoaded";
		obj.type = "xml";
		ldr.loadRequest(obj);
	}
	private function initXMLLoaded(o:Object){

		//'objectify' the nodes for easy access  
		for(var i = 0; i < o.data.firstChild.childNodes.length;i++){
			 initXMLobj[o.data.firstChild.childNodes[i].nodeName] = o.data.firstChild.childNodes[i];
		}
		
		// create theme
		theme =  new mbTheme(initXMLobj.theme,ldr);
		theme.addListener(this);
		
		// create layout
		layout =  new mbLayout(initXMLobj.layout);
		
		//pass the layout rules to the loader
		ldr.setLayout(layout);
		
		var devMode = o.data.firstChild.attributes.devmode == "1" ? true : false ;
		ldr.setDevMode(devMode);
		
		
	}
	
	private function onThemeReady(){
		
		// load the index xml
		var url = initXMLobj.index.attributes.url;
		
		var URLarr = url.split(".")
		var type = URLarr[URLarr.length - 1];
	
		var obj:Object = new Object();
		obj.url = url;
		obj.label = "Index xml";
		obj.target = this;
		obj.onLoad = "indexXMLLoaded";
		obj.type = type;
		obj.displayMode= 0;
		ldr.loadRequest(obj);
		
		
	}
	
	// the callback function for browser navigation (deep linking)
	public function onUrlChange()
	{
		
		var url = swfa_mc.getValue();
	
		//var coord = urlToCoord(url)
		
		//_root.tracer.htmlText += "onUrlChange - url:"+url+" coord:"+coord ;
	
		//index.currentIndex = coord;
		
		index.currentURL = url;
		
	}
	
	private function getBrowserTitle():String{
		var currentItem:XMLNode = index.getItemAt(index.currentIndex);
		var title:String;
		if(currentItem != undefined){
			title = index.siteTitle != undefined ? index.siteTitle +" - " : "" ;
			title += currentItem.attributes.longtitle ? currentItem.attributes.longtitle : currentItem.attributes.title;
			//_root.tracer.htmlText += "setBrowserTitle - title:"+title + " coord:"+index.currentIndex;
		}
	
		return title;
	}
	
	// converst the browser # string to a coordinate value
	private function urlToCoord(url:String):String{
		var coord:String = url.split("/").toString();
		return coord.slice(1);
		
	}
	
	//listens to the instance of mbIndex, updates the browser with the latest coordinate
	private function onIndexUpdate(){
		var urlString:String = index.currentURL;
		/*
		if(index.currentIndex != undefined && index.currentIndex != "0"){
			urlString = "/"+index.currentIndex.split(",").join("/");
		}else{
			urlString = "/";
		}
		*/
		
		//_root.tracer.htmlText += "onIndexUpdate - about to pass to SWFAddress setValue:"+urlString;
		
		
		swfa_mc.setValue(urlString);
		
	}
	
	
	private function indexXMLLoaded(o:Object){
		
		
		//setup the index
		index = new mbIndex(o.data);
		
		//instantiate the tController as it gets passed to UI objects
		transitionController =  this.attachMovie("mbTransitionControllerSymbol","transitionController",this.getNextHighestDepth());
		transitionController.setIndex(index);
		
		// UI objects
		bg = this.attachMovie("mbBackgroundSymbol","bg",this.getNextHighestDepth());
		content = this.attachMovie("mbContentSymbol","content",this.getNextHighestDepth());
		nav = this.attachMovie("mbNavGroupSymbol","nav",this.getNextHighestDepth());
		logo = this.attachMovie("mbLogoSymbol","logo",this.getNextHighestDepth());
		footer = this.attachMovie("mbFooterSymbol","footer",this.getNextHighestDepth());
		scrollpane  = this._parent.attachMovie("mbScrollPaneSymbol","scrollpane",this._parent.getNextHighestDepth());	
		siblingnav = this.attachMovie("mbSiblingNavSymbol", "siblingnav",this.getNextHighestDepth());
		toolbar = this.attachMovie("mbToolbarSymbol", "toolbar",this.getNextHighestDepth());
		toolTip = this._parent.attachMovie("mbToolTipSymbol", "toolTip",this._parent.getNextHighestDepth());
		
		popup_mc = this.attachMovie("mbPopupSymbol", "popup_mc", this.getNextHighestDepth());
		popup_mc._visible = false;
		
		Stage.addListener(layout);
		
		//layout is handled by onResize listeners in each main template object
		layout.addListener(bg);
		layout.addListener(nav);
		layout.addListener(logo);
		layout.addListener(footer);
		layout.addListener(ldr);
		layout.addListener(content);
		layout.addListener(scrollpane);
		layout.addListener(siblingnav);
		layout.addListener(toolbar);
		
		layout.addListener(popup_mc);
		
		// UI objects instantiation
		bg.init(index,ldr,theme,transitionController,initXMLobj.background,layout);
		nav.init(initXMLobj.nav,o.data.firstChild,"",index,theme,layout,0,transitionController);
		logo.init(initXMLobj.logo,ldr,theme,layout,index,transitionController);
		footer.init(initXMLobj.footer,ldr,theme,layout,index,transitionController);
		content.init(initXMLobj.content,index,ldr,theme,layout,nav,transitionController,toolTip);
		scrollpane.init(this,"scroll",theme,layout,{spw:"stagewidth",sph:"stageheight",pcw:"w",pch:"h"});
		siblingnav.init(initXMLobj.siblingnav,ldr,theme,layout,index,transitionController);
		toolbar.init(initXMLobj.toolbar,ldr,theme,layout,index,transitionController);
		
		popup_mc.init(theme, layout);
		
		toolTip.init(initXMLobj.tooltip,theme,layout);
		
		// All UI objects that need to react to a navigation change listen to index
		index.addListener(transitionController);
		index.addListener(this);
		index.addListener(bg);
		index.addListener(nav);
		index.addListener(content);
		index.addListener(logo);
		index.addListener(footer);
		index.addListener(siblingnav);
		index.addListener(toolbar);
		
		scrollpane.addListener(toolTip);
		scrollpane.addListener(content);
		
		broadcaster.broadcastMessage("onInitComplete");
	}
	
	public function addPopup($contentUrl:String):Void {
		popup_mc.cleanUp();
		var obj:Object = new Object();
		obj.url = $contentUrl;
		//obj.label = currentItem.attributes.title + " XML";
		obj.target = this;
		obj.onLoad = "onPopupXMLLoaded";
		obj.type = "xml";
		
		ldr.loadRequest(obj);		
	}
	
	private function onPopupXMLLoaded($object:Object):Void {
		popup_mc._visible = true;
		popup_mc.show($object.data);
	}
}