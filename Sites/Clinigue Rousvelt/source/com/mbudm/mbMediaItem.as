/*
com.mbudm.mbMediaItem.as 
extends MovieClip

Steve Roberts June 2009

Description
mbMediaItem is a class for loading and displaying images, swfs and video. Most of the work with these items is left to the extending class as by nature
this is a very visual class.

*/


import flash.display.*;
import com.mbudm.mbTheme;

class com.mbudm.mbMediaItem extends MovieClip{

	private var theme:mbTheme;
	private var ldr:MovieClip;
	private var indexNodeXML:XMLNode;
	private var itemURL:String;
	private var overrides:Object;
	
	private var itemType:String;
	private var isVideo:Boolean;
	private var stream:NetStream;

	private var item_mc:MovieClip;//the holder of a series of sub clips (mask, item, video, bg)
	private var mediaItem; //type is not defined because it may be a mc or a video object
	
	private var mediaItemLoadTarget:MovieClip;
	
	private var callbackObject:Object;
	
	
	function mbMediaItem(){
	
	}
	
	public function init(t:mbTheme,l:MovieClip,iX:XMLNode,iU:String,oR:Object){
		
		theme = t;
		ldr = l;
		indexNodeXML = iX;
		
		overrides = oR;

		itemURL = iU != undefined ?  iU : indexNodeXML.attributes.src ;
		
	
		// image & video movieclips
		item_mc = this.createEmptyMovieClip("item_mc",this.getNextHighestDepth());
		item_mc.bg = item_mc.createEmptyMovieClip("bg",item_mc.getNextHighestDepth());
		item_mc.bg_copy = item_mc.createEmptyMovieClip("bg_copy",item_mc.getNextHighestDepth()); // for bitmap copies
		item_mc.item_raw = item_mc.createEmptyMovieClip("item_raw",item_mc.getNextHighestDepth()); // the loaded image goes in here
		item_mc.item = item_mc.createEmptyMovieClip("item",item_mc.getNextHighestDepth()); // the copied bitmap of the image goes in here
		item_mc.vid = item_mc.createEmptyMovieClip("vid",item_mc.getNextHighestDepth());
		item_mc.vidLoader = item_mc.attachMovie("mbLoaderAnimSymbol","vidloader",item_mc.getNextHighestDepth()); // a loader anim can be displayed for when the video is initially buffering
		item_mc.mask = item_mc.createEmptyMovieClip("mask",item_mc.getNextHighestDepth());
		item_mc.mask._visible = false;
		drawRect(item_mc.mask,100,100,0x000000,100);
		item_mc.mask_raw = item_mc.createEmptyMovieClip("mask_raw",item_mc.getNextHighestDepth());
		item_mc.mask_raw._visible = false;
		drawRect(item_mc.mask_raw,100,100,0x000000,100);
				
		item_mc.vidLoader._visible = false;
		
		loadMedia();
	}
	
	private function loadMedia(){
		
		var itemURLarr = itemURL.split(".")
		itemType = itemURLarr[itemURLarr.length - 1].toLowerCase();
		
		var obj:Object = new Object();
		obj.url = itemURL;
		obj.label = indexNodeXML.attributes.title != undefined ? indexNodeXML.attributes.title : itemType ;
		obj.onLoad = "onMediaLoaded";
		obj.onLoadTarget = this;
		obj.type = itemType;
		obj.displayMode = 1;
		
		isVideo = false;
					
		switch(itemType){
			case "swf":
				obj.target = this.item_mc.item ;
			break;
			case "jpg":
			case "gif":
			case "png":
				obj.target = this.item_mc.item_raw ;
			break;
			case "flv":
			case "mpeg":
			case "mp4":
			case "m4v":
			case "m4a":
			case "mov":
			case "3gp":
				isVideo = true;
				// Video is played via an external SWF
				// this SWF contains the video instance
				obj.url = "videoplayer.swf";
				obj.target = this.item_mc.vid;
				obj.type = "swf";
			break;
		}
		if(isVideo && stream != undefined){
			onMediaLoaded();
		}else{
			ldr.loadRequest(obj);	
		}
		
		mediaItemLoadTarget = obj.target;
		
		setupItem();
	}
	
	
	// callback from ldr
	public function onMediaLoaded(o:Object){
		if(isVideo){
			
			
			mediaItem = this.item_mc.vid.video_mc.vid;// this is the path to the video object in the external videoplayer.swf
			mediaItem._alpha = 0;// ensure nothing is seen until everything is ready
			
			var thisObj = this;
			
			if(stream == undefined){
				stream = this.item_mc.vid.stream_ns;
				stream.setBufferTime(5);
				stream.onStatus = function(infoObject:Object) {
					thisObj.onStreamStatus(infoObject);
				};
			}
			
		}else if(o.target == item_mc.item_raw){
			// do bitmap smoothing for the image - in case it is resized
			// kudos to this guy: http://www.actionscript.org/forums/showthread.php3?t=89255
			
			var w = item_mc.item_raw._width;
			var h = item_mc.item_raw._height;
			var bmpData:BitmapData = new BitmapData(w, h, true, 0x000000); 
			bmpData.draw(item_mc.item_raw);
			item_mc.item.attachBitmap(bmpData, 2, "auto", true); 
			
			//replace the loaded mc with the new smoothed copy.
			item_mc.item_raw._alpha = 0; //removeMovieClip();	
			mediaItem = item_mc.item;
			mediaItem._alpha = 0;
		}
		
		//tell the extended class to do the graphical setup
		onMediaLoadedSetup();
	}
	
	// this instance is to be reused with a new image or video
	public function update(iX:XMLNode,iU:String,o:Object){
		
		indexNodeXML = iX;
		itemURL = iU != undefined ?  iU : indexNodeXML.attributes.src ;
		
		callbackObject = o;
		onUpdate();// the extended class will cleanup and then call loadMedia() when it is ready for the update media to be loaded
	}
	
	// open and close methods - do any graphical start or end transitions
	public function open(o:Object){
		callbackObject = o;
		onOpen();
	}
	
	public function close(o:Object){
		callbackObject = o;
		onClose();
	}
	
	// override functions
	
	private function setupItem(){
	
	}
	private function onMediaLoadedSetup(){
		
	}
	
	private function onStreamStatus(infoObject:Object) {
	}
	
	public function moveTo(x:Number,y:Number){
	
	}
	
	private function onOpen(){
	
	}
	
	private function onClose(){
		
	}
	
	private function onUpdate(){
	}
	
	public function setSize(w:Number,h:Number){

	}
	
	
	// used by the mask
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
}