/*
com.mbudm.mbLoader.as 
extends MovieClip

Steve Roberts May 2009

Description
mbLoader is more than just a preloader, it's a load management system. All loading of all file types goes through this class.

This allows the loading to be managed in order and for more detailed loading feedback to be given to the user.
		
*/

import TextField.StyleSheet;
import com.mbudm.mbLayout;


class com.mbudm.mbLoader extends MovieClip{
	private var lq:Array; //load queue
	private var lc:Array; //load complete
	private var _interval:Number; // load monitor
	private var mcLoader:MovieClipLoader; //for loading all swf, jpg, png, gif
	
	private var layout:mbLayout;
	private var loadedPause:Boolean;//leaves the loader open for a tick or three after the load is completed
	private var loadedPauseCount:Number;
	
	private var defaultMode:Number;
	
	private var devMode:Boolean;
	private var devStamp:String;
	private var devLabel:TextField;
	
	//private var itemIndex:Number; // a number so that the monitor knows when a new item is being loaded
	
	
	function mbLoader(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init() {
		
		devMode = false;  
		devStamp = "";
		
		lq = new Array();
		lc = new Array();
		
	    mcLoader = new MovieClipLoader();
		mcLoader.addListener(this);
		
		defaultMode = 0;
		
		customInit();
		//itemIndex = 0;
	}
	
	// as the loader is instantiated before anything else, it receives the layout information after init()
	public function setLayout(lyt:mbLayout){
		layout = lyt;
		onLayout();
	}
	
	public function setDevMode(d:Boolean){
		devMode = d;
		if(d){
			var tf:TextFormat = new TextFormat();
			tf.font = "Arial";
			tf.bold = true;
			devLabel = this.createTextField("devLabel",this.getNextHighestDepth(),5,5,100,20);
			devLabel.border = true;
			devLabel.selectable = false;
			devLabel.borderColor = 0xFF0000;
			devLabel.textColor = 0xff0000;
			devLabel.autoSize = true;
			devLabel.text = "DEV MODE";
		}
	}
	
	public function loadRequest(obj:Object){
		if(devMode){
			devStamp = "?cb="+ getTimer();
		}
		/*
		obj
			url (the item to load)
			label ( a string that can be used to id what is being loaded by any loader UI)
			target ( the object making the request )
			onLoad ( the method to be called when the item is loaded )
			onLoadTarget (only needed if the onLoad method is not at target)
			type (txt | xml | swf |jpg | mp3* | flv*) *To be added.
			displayMode 0, 1...n used by the extending class (optional)
		*/
	
		lq.push(obj);
		
		onLoadRequest();
		
		startLoader();
	
		onResize();
	
	}
	
	//the report object is used by the extended class to create the visual representation of load progress
	public function report():Object{
		// updates the loaded and loadtotal for each object in the load queue
		var reportObj:Object = new Object();
		//use the displayMode of the latest item added
		reportObj.displayMode = lq[lq.length-1].displayMode != undefined ? lq[lq.length-1].displayMode : defaultMode;
		reportObj.itemsLoading = 0;
		reportObj.bytesLoaded = 0
		reportObj.bytesTotal = 0
		reportObj.items = new Array();
		if(lq.length > 0){
			for(var i = 0; i < lq.length; i++){
				if(lq[i].loading){
					switch(lq[i].type){
						case "xml":
							lq[i].bytesLoaded = lq[i].loadObj.getBytesLoaded(); 
							lq[i].bytesTotal = lq[i].loadObj.getBytesTotal();
						break;
						case "swf":
						case "jpg":
						case "gif":
						case "png":
							var progress:Object = mcLoader.getProgress(lq[i].target);
							lq[i].bytesLoaded = progress.bytesLoaded ; 
							lq[i].bytesTotal = progress.bytesTotal;
						break;
						case "css":
							//no byte data available from the StyleSheet object, so CSS items get moved to LC by cssItemLaded()
						break;
						case "flv":
							//lq[i].bytesLoaded = lq[i].loadObj.bytesLoaded; 
							//lq[i].bytesTotal = lq[i].loadObj.bytesTotal;
							//trace("flv loadObj: "+typeof(lq[i].loadObj)+" .close: "+typeof(lq[i].loadObj.close)+" lq[i].bytesLoaded:"+lq[i].bytesLoaded+" :"+lq[i].loadObj.bytesTotal);
						break;
					}
					if(!isNaN(lq[i].bytesTotal)){
						reportObj.itemsLoading++;
						reportObj.bytesLoaded += isNaN(lq[i].bytesLoaded) ? 0 : lq[i].bytesLoaded ;
						reportObj.bytesTotal += lq[i].bytesTotal
						reportObj.items.push(lq[i].label);
						reportObj.lqitems.push(i);
					}
				}
			}
		}
		return reportObj;
		
	}
	
	private function startLoader(){
		if(!this._interval && lq.length > 0){
			this._interval = setInterval(this,"onInterval",100);	
		}
		loadItems();
		monitorLoader();
	}
	
	private function onInterval(){
		monitorLoader();
	}
	
	private function loadItems(){
		if(lq.length > 0){
			//find all items to be loaded
			for(var i = 0; i < lq.length; i++){
				if(!lq[i].loading){
					setupItemLoad(i);
				}
			}
		}
	}
	
	private function setupItemLoad(itemToLoad:Number){
		var thisObj = this; // for loaders that need a refernce to the mbLoader class (xml/css ...so far)
		switch(lq[itemToLoad].type){
			case "xml":
				var xmlItem:XML = new XML();
				xmlItem.ignoreWhite = true;
				xmlItem.onLoad = function(success:Boolean) {
					if (success) {
						thisObj.xmlItemLoaded(this);
					}
				}
				var xurl = lq[itemToLoad].url + devStamp;
				xmlItem.load(xurl);
				lq[itemToLoad].loadObj = xmlItem;
			break;
			case "swf":
			case "jpg":
			case "gif":
			case "png":
				var mcurl = lq[itemToLoad].url + devStamp;
				mcLoader.loadClip(mcurl, lq[itemToLoad].target);
				/*
				trace("---swf/jpg load request--");
				for(var p in lq[itemToLoad]){
					trace(p+": "+lq[itemToLoad][p] +" t:"+typeof(lq[itemToLoad][p]));
				}
				*/
			break;
			case "css":
				lq[itemToLoad].target.onLoad = function(success:Boolean):Void {
					if (success) {
						thisObj.cssItemLoaded(this);
					} else {
						trace("Error loading CSS file.");
					}
				};
				var curl = lq[itemToLoad].url + devStamp;
				lq[itemToLoad].target.load(curl);
			break;
			case "txt":
			break;
			case "mp3":
			break;
		}
		lq[itemToLoad].loading = true;
	}
	
	
	private function xmlItemLoaded(x:XML){
		//find the stylesheet in the LQ and move it to LC
		for(var i = 0; i < lq.length; i++){
			if(lq[i].type == "xml"){
				if(lq[i].loadObj == x){
					lq[i].data = x;
					itemLoaded(i);
					break;
				}
			}
		}
	}
	
	private function cssItemLoaded(s:StyleSheet){
		//find the stylesheet in the LQ and move it to LC
		for(var i = 0; i < lq.length; i++){
			if(lq[i].type == "css" && lq[i].target == s){
				itemLoaded(i);	
				break;
			}
		}
	}

	//listener for the mcLoader onLoadInit event 
	private function onLoadInit(mc:MovieClip) {
		//trace("mc item loaded:"+mc);
		//this.itemLoaded();
		//find the mc in the LQ and move it to LC
		for(var i = 0; i < lq.length; i++){
			if(lq[i].target == mc){
				//trace("found mc item:"+i);
				itemLoaded(i);	
				break;
			}
		}
	}
	
	private function itemLoaded(i:Number){
	//	trace("1 itemLoaded:"+lq[i].label+" lq.len:"+lq.length);
		onItemLoaded(i);
		//Move the load queue item into the load complete array
		lc.push(lq[i])
		lq.splice(i,1);
		
		//trace("2 itemLoaded lc[end]:"+lc[lc.length - 1].label+" lq.len:"+lq.length);
		//if(lq.length == 1){
		//	trace("-- single lq item:"+lq[0].label);
		//}
		
		var lci = lc.length - 1;
		
		//Call the onload event using the load request object that now resides in the load complete array
		if(lc[lci].onLoadTarget){
			lc[lci].onLoadTarget[lc[lci].onLoad](lc[lci]);
		}else{
			lc[lci].target[lc[lci].onLoad](lc[lci]);
		}
		
		finishLoading();
	}
	
	private function finishLoading(){
		/*
		trace("finishLoading");
		for(var i = 0; i < lq.length; i++){
			trace(i+" "+lq[i].label);
		}
		*/
		if(lq.length == 0){
			clearInterval(this._interval);
			this._interval = undefined;
			
			monitorLoader();
		}
	}
	
	//Extendables
	
	private function customInit(){
	}
	
	private function onLoadRequest(){
	}
	
	private function onItemLoaded(i:Number){
	}
	
	private function onLayout(){
		//lets the extend class know that the layout settings are available
	}
	
	private function monitorLoader(){
		// this will be overwriten by extensions of this class
		// it allows a graphical loader to show load progress
		// by calling the report() and updating items to reflect the load status
	}
	
	public function onResize(){
		// this will be overwriten by extensions of this class
	}
	
	/*
	public function setRect(rect:Rectangle,target:MovieClip){
		// add the rectangle to the load object
		// the monitor loader will use this to display a loader within this area.
		for(var i = 0; i < lq.length ; i++){
			if(lq[i].target == target){
				lq[i].rect = rect;
			}
		}
	}
	*/
	
	public function setLoaderVisible(b:Boolean){
		//ldr_mc._visible = b;
	}

}