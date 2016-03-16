/*
com.mbudm.min.minMediaItem.as 
extends com.mbudm.mbMediaItem

Steve Roberts August 2009 - modified from curMediaItem.as

Description
minMediaItem extends the mbMediaItem class handling all the visual display of the image or video that has been loaded.
This includes a great deal of code for the video playback and monitoring which is covered in more detail in the video section of this class.

*/

import flash.display.*;
import mx.transitions.easing.Regular;
import mx.transitions.easing.Strong;


class com.mbudm.min.minMediaItem extends com.mbudm.mbMediaItem{
/* vars in com.mbudm.mbMediaItem

	private var theme:mbTheme;
	private var ldr:mbLoader;
	private var indexNodeXML:XMLNode;
	private var itemURL:String;
	private var overrides:Object;
	
	private var itemType:String;
	private var isVideo:Boolean;
	private var stream:NetStream;
	
	private var item_mc:MovieClip;
	private var mediaItem;
	
	private var callbackObject:Object;
	
	*/
	
	private var controller_mc:MovieClip;
	private var controllerheight:Number;
	
	private var frameID:String;
	private var frameXML:XMLNode;
	private var resizemode:Number;
	private var fillout:Number;
	private var medialoaded:Boolean;
	private var setupcomplete:Boolean;
	
	/* transition vars */
	private var direction:Boolean; //true is 'opening' the Item false is 'closing' it
	
	private var _interval:Number;
	private var _intervalFrequency:Number = 20;
	
	private var _animDuration:Number = 30;
	private var _animCount:Number = 0; 
	private var _borderDuration:Number = 15; // the amount of time spent animating the opening and closing of the borders. The remainder of the _animDuration is used to open/close the media
	
	
	private var itemWidth:Number = 0;
	private var itemHeight:Number = 0;
	
	/* frame morph data */
	private var prevBorders:Object;
	private var currBorders:Object;
	private var nextBorders:Object;
	private var bordersID:Number; // a number used to identify each border set created
	
	/* video vars */
	private var vidMetaData:Object;
	private var videoInterval:Number;
	private var isPlaying:Boolean;
	private var hasVideoDimensions:Boolean;
	
	private var seeking:Boolean;
	private var seekSource:MovieClip;
	private var seekInterval:Number;
	private var seekIntervalCount:Number;
	
	private var waitingForSeek:Boolean;
	private var lastSeek:Number;
	private var pendingSeek:Number;
	private var streamOpen:Boolean;
	private var receivedStartedStatus:Boolean;
	private var preloadComplete:Boolean;
	
	private var video_sound:Sound;
	private var mute_volume_level:Number;
	private var adjustingVolume:Boolean;
	
	
	/* dimensions for get methods */
	private var itemX:Number;
	private var itemY:Number;
	private var itemW:Number;
	private var itemH:Number;
	
	
	private var broadcaster:Object;
	private var broadcastedReady:Boolean;
	
	private var updating:Boolean;
	private var updatedMedia:Boolean;
	
	private var loaderRectSet:Boolean;

	
	function minMediaItem(){
		this._visible = false;
		
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
		
		bordersID = 0;
	}
	
	public function addListener(obj:Object){
		broadcaster.addListener(obj);
	}
	
	// this method is part of the initial setup and the update process
	private function setupItem(){
		if(isVideo ){
			//create the controller
			if(controller_mc == undefined){
				controller_mc = this.attachMovie("player_control","controller_mc",this.getNextHighestDepth());
				controller_mc._visible = false;
				setupController();
			}
		}
		
		// setup the 'frame' - also refeered to as the background - the gfx behind the image/video
		if(overrides.useFrame != false){
			frameID = overrides.frameid ? overrides.frameid : findFrame(indexNodeXML);
			
			if(frameID != undefined){
				frameXML = theme.getNode("frame","id",frameID);
			}else{
				frameXML = theme.getNode("frame");
			}
		}else{
			frameID = undefined;
			frameXML = undefined;
		}
		
		// the default resize mode is 1 - scaled proprtionally
		resizemode = overrides.resizemode != undefined ? Number(overrides.resizemode) : ( frameXML.attributes.resizemode != undefined ? Number(frameXML.attributes.resizemode) : 1 ) ;
		// fillout - the broders are drawn to the dge of the available space
		fillout = overrides.fillout != undefined ? Number(overrides.fillout) : ( frameXML.attributes.fillout != undefined ? Number(frameXML.attributes.fillout) : 0 ) ;
		
		if(!isVideo){
			item_mc.item_raw._alpha = 0;
			item_mc.item._alpha = 0;
		}else{
			
		}
		
		// when updating the bg is morphed
		// when not updating the bg is not shown until the initial setSize is complete
		if(!updating){
			item_mc.bg._visible = false;
		}
		
		this._visible = true;
		
		setupcomplete = true;
		setupMask();
		setSize();
	}
	
	private function onMediaLoadedSetup(){
		//Note: order is important
		
		medialoaded = isVideo ? medialoaded : true;
		setupMask();
		if(updating){
			// prepare to conduct a frame morph		
			
			prevBorders = copyBorderObject(currBorders);
	
			onOpen();//this must be called before setSize - otherwise the new borders sizes will be attributed to the old image border sizes
		}
		if(isVideo){
			startMedia(true);
			//controller_mc._visible = true;
			item_mc.vidLoader._visible = true;
		}else{
			
			setSize();
		}
	}
	
	// the mask is used when resizemode == 0 because the longer side of the image will be bigger than the available space
	// unless of course the ratio of the image exactly matches the available space
	private function setupMask(){
		if(medialoaded && setupcomplete){
			if(resizemode == 0){
				item_mc.mask._visible = true;
				if(isVideo){
					item_mc.vid.setMask(item_mc.mask);
				}else{
					item_mc.item_raw.setMask(item_mc.mask_raw);
					item_mc.item.setMask(item_mc.mask);
				}
			}else{
				item_mc.mask._visible = false;
				
				item_mc.item_raw.setMask(null);
				item_mc.item.setMask(null);
				item_mc.vid.setMask(null);
			}
		}
	}
	
	// searches for a frame attribute in this node or one of it's ancestors
	private function findFrame(n:XMLNode):String{
		var str:String;
		if(n.attributes.frameid){
			str = n.attributes.frameid;
		}else if(n.parentNode != null){
			
			str = findFrame(n.parentNode);
		}
		return str;
	}
	
	public function moveTo(x:Number,y:Number){
		this._x = x;
		this._y = y;
	}
	
	// called from mbMediaItem - fade up the image
	public function onOpen(){
		_animCount = 0;
		
		direction = true;
		startInterval();
	}
	
	// called from mbMediaItem - no transition just cancel any loading
	public function onClose(){
		ldr.cancelLoadRequest(mediaItemLoadTarget);
		if(callbackObject != undefined){
			//trace("curMediaItem onClose");
			callbackObject.target[callbackObject.onComplete]();
		}
	}
	
	// called from mbMediaItem - fade down the image but not the frame as this will be morphed
	private function onUpdate(){
		_animCount = _animDuration;
		direction = false;
		updating = true;
		startInterval();
	}
	
	// the image has been faded down so reset all relevant booleans and clear the existing image/video
	// then call loadMedia to re start the image setup process
	private function readyToUpdate(){
		loaderRectSet = false;
		medialoaded  = false;
		setupcomplete = false;
		updatedMedia =  false;
		preloadComplete = false;
	
		var thisObj = this;
		item_mc.item.onUnload = function () {
    		thisObj.updateMedia();
		}
		item_mc.item_raw.onUnload = function () {
    		thisObj.updateMedia();
		}
		item_mc.vid.onUnload = function () {
    		thisObj.updateMedia();
		}
		
		if(isVideo){
			controller_mc._visible = false;
			item_mc.vidLoader._visible = false;
			hasVideoDimensions = false;
			vidMetaData = undefined;
			this.item_mc.vid.metaData = undefined
			startMedia(false);
			stream = undefined;
			this.item_mc.vid.unloadMovie();
		}else{
			item_mc.item_raw.unloadMovie();
			item_mc.item._alpha = 0;
		}
	}
	
	// called from item, item_ra or vid unLoadMovie
	private function updateMedia(){
		if(!updatedMedia){
			updatedMedia = true;
			loadMedia();
		}
	}
	
	
	//
	// Transitions - border & image fading and border 'morphing' during updates
	//
	private function startInterval(){
		if(this._interval == undefined){
			this._interval = setInterval(this,"onInterval",_intervalFrequency);
		}
	}
	
	private function onInterval(){
		if(setupcomplete && medialoaded){	
			switch(direction){
				case true:
					//opening
					if(_animCount == 0 && !updating){
						createCopy(item_mc.bg,item_mc.bg_copy);	
					}
					if(_animCount == _borderDuration && isVideo){
						controller_mc._visible = true;
					}
					_animCount = Math.min((_animCount + 1),_animDuration);
				break;
				case false:
					//closing
					_animCount = Math.max((_animCount -1),0);
					
					if(_animCount == _borderDuration){
						createCopy(item_mc.bg,item_mc.bg_copy);
					}
				break;
			}
			
			//the update transition code is in a seperate function because it is also called from onResize
			updateTransition();
			
			if(updating){
			   if(direction){
				   //the border morph is complete and the new image has faded up  
				   if(_animCount >= _animDuration){
				   		updating = false;
						broadcastReady();
				   }
			   }else{
				   if( _animCount <= _borderDuration){
					   	clearInterval(this._interval);
						this._interval = undefined;
						//the old image has faded down - ready for the new image to be loaded
						readyToUpdate();
				   }
			   }
			}else{
				if(_animCount <= 0 || _animCount >= _animDuration ){
					clearInterval(this._interval);
					this._interval = undefined;
					// an open or close call can pass a callback so call it if exists
					if(callbackObject != undefined){
						callbackObject.target[callbackObject.onComplete]();
					}
				}
			}
		}
	}
	
	//create a copy of the background frames - for better fading up/down
	private function createCopy(from:MovieClip,to:MovieClip){
		var w = from._width;
		var h = from._height;
		var bmpData:BitmapData = new BitmapData(w, h, true, 0x000000); 
		bmpData.draw(from);
		to.attachBitmap(bmpData, 2, "auto", true); 
	
		to._x = from._x;
		to._y = from._y;
	}
	
	private function updateTransition(){
		// set the alpha of the borders and the media
		var factor:Number;
		var stage:Number;
		/* Calculate the current frame borders and draw the borders */
		if(!updating || (updating && !direction)){
			// every situation except when the updating border is being 'morphed'
			if(currBorders.borderID != nextBorders.borderID){
				// they have a different bordersID so make a currBorders into a copy of nextBorders
				currBorders = copyBorderObject(nextBorders);
				drawBorders();
			}
		}
		
		if(_animCount <= _borderDuration){
			if(updating){
				// ease out the frames
				stage = _animCount/_borderDuration;
				factor = direction ? Regular.easeOut(stage, 0, 1, 1) : Strong.easeOut(stage, 0, 1, 1) ;
				if(direction){
					// this is the frame/border 'morphing' transition - it happens when the user moves from one media item to another
					// the frame is redrwan on each interval - tweening width/height/color/alpha/x/y of each border towards 
					// the required borders of the new media item
					
					currBorders = new Object();
					
					// border mc x nd y + borderID
					if(factor == 1){
						//only give it the ID if factor is 1;
						currBorders.bordersID = nextBorders.borderID;
					}else{
						currBorders.bordersID = prevBorders.borderID;
					
					}
					currBorders.bmc_x = prevBorders.bmc_x + (factor * (nextBorders.bmc_x - prevBorders.bmc_x));
					currBorders.bmc_y = prevBorders.bmc_y + (factor * (nextBorders.bmc_y - prevBorders.bmc_y));

					// individual border properties - wi, he, x, y, c (color), a (alpha)
					var len = Math.max(nextBorders.borders.length,prevBorders.borders.length);
					currBorders.borders = new Array(len);
					for(var i = 0; i < len; i++){
						currBorders.borders[i] = new Object();
						
						if(nextBorders.borders[i] == undefined){
							nextBorders.borders[i] = new Object();
							nextBorders.borders[i].wi = nextBorders.borders[i-1].wi;
							nextBorders.borders[i].he = nextBorders.borders[i-1].he;
							nextBorders.borders[i].x = nextBorders.borders[i-1].x;
							nextBorders.borders[i].y = nextBorders.borders[i-1].y;
							nextBorders.borders[i].c = prevBorders.borders[i].c;
							nextBorders.borders[i].a = 0;
						}
						if(prevBorders.borders[i] == undefined){
							prevBorders.borders[i] = new Object();
							prevBorders.borders[i].wi = prevBorders.borders[i-1].wi;
							prevBorders.borders[i].he = prevBorders.borders[i-1].he;
							prevBorders.borders[i].x = prevBorders.borders[i-1].x;
							prevBorders.borders[i].y = prevBorders.borders[i-1].y;
							prevBorders.borders[i].c = nextBorders.borders[i].c;
							prevBorders.borders[i].a = 0;
						}
						
						for(var p in nextBorders.borders[i]){
							switch(p){
								case "c":
									var newC;
									if(prevBorders.borders[i][p] != nextBorders.borders[i][p]){
										//takes the hex number and break into three numbers between 1 and 255
										var nr:Number = (nextBorders.borders[i][p] & 0x00FF0000) >>> 16;
										var ng:Number = (nextBorders.borders[i][p] & 0x0000FF00) >>> 8;
										var nb:Number = nextBorders.borders[i][p] & 0x000000FF;
										
										var pr:Number = (prevBorders.borders[i][p] & 0x00FF0000) >>> 16;
										var pg:Number = (prevBorders.borders[i][p] & 0x0000FF00) >>> 8;
										var pb:Number = prevBorders.borders[i][p] & 0x000000FF;
										
										var cr:Number = pr + (factor * (nr - pr));
										var cg:Number = pg + (factor * (ng- pg));
										var cb:Number = pb + (factor * (nb - pb));
										
										// put the three numbers back together to create a hexadecimal number
										newC = (cr << 16) | (cg << 8) | cb;
									}else{
										newC = nextBorders.borders[i][p]
									}
									currBorders.borders[i][p] = newC;
								break;
								default:
									currBorders.borders[i][p] = prevBorders.borders[i][p] + (factor * (nextBorders.borders[i][p] - prevBorders.borders[i][p]));
								break;
							}
						}
					}
					
					drawBorders();
					item_mc.bg._visible = true;
				
				}else{
					// when updating is true and direction is false the transition stops at _borderCount
					// so this case would never eventuate
				}
			}else{
				// fading up the border (on open)
				// ease in the frames fade up
				stage = _animCount/_borderDuration;
				factor = direction ? Regular.easeIn(stage, 0, 1, 1) : Strong.easeOut(stage, 0, 1, 1) ;
				
				item_mc.bg_copy._alpha = factor * 100;
				item_mc.bg_copy._x = item_mc.bg._x;
				item_mc.bg_copy._y = item_mc.bg._y;		
			}
			if(_animCount == _borderDuration){
				// the point between the border and image transitions
				if(updating){
					item_mc.bg._visible = true;
				}else{
					item_mc.bg._visible = direction ? true : false ;
					item_mc.bg_copy._alpha = direction ? 0 : 100 ;	
				}
			}
		}
		
		if(_animCount > _borderDuration){
			//ease out the image
			stage = (_animCount - _borderDuration) / (_animDuration - _borderDuration);
			factor = direction ? Strong.easeOut(stage, 0, 1, 1) : Regular.easeIn(stage, 0, 1, 1) ;	
			mediaItem._alpha = Math.round(factor * 100);
		}
	}
	
	private function drawBorders(){
		// draw the borders according to the specifications in currBorders
		for(var i = 0; i < currBorders.borders.length; i++){
			item_mc.bg.createEmptyMovieClip(("border"+i),item_mc.bg.getNextHighestDepth());
			drawRect(item_mc.bg["border"+i],currBorders.borders[i].wi,currBorders.borders[i].he,currBorders.borders[i].c,currBorders.borders[i].a);
			item_mc.bg["border"+i]._x = currBorders.borders[i].x;
			item_mc.bg["border"+i]._y = currBorders.borders[i].y;
		}
		item_mc.bg._x = currBorders.bmc_x;
		item_mc.bg._y = currBorders.bmc_y;
		
		itemX = Math.round((itemWidth - item_mc.bg._width) / 2);
		itemY = Math.round((itemHeight - item_mc.bg._height) / 2);
		itemW = item_mc.bg._width;
		itemH = item_mc.bg._height;
	}
	
	// make a copy of all the data in the given borders object
	private function copyBorderObject(o:Object):Object{
		var copy:Object = new Object();
		copy.borders = new Array(o.borders.length);
		for(var i = 0; i < o.borders.length; i++){
			if(typeof(o.borders[i]) == "object"){
				copy.borders[i] = new Object();
				for(var p in o.borders[i]){
					copy.borders[i][p] = o.borders[i][p];
				}
			}else{
				copy.borders[i] = o.borders[i];
			}
		}
		copy.borderID = o.borderID; 
		copy.bmc_x = o.bmc_x;
		copy.bmc_y = o.bmc_y; 
		
		return copy;
	}
	
	//
	// setSize
	//
	// there are three resizemodes
	// 0 - the image is expanded or reduced so that it's shortes dimension equals the available space
	// 1 - the image is expanded or reduced so that it's longest dimension equals the available space
	// 2 - the image is not expanded but is reduced if the image is larger than the available space
	public function setSize(wi:Number,he:Number){
		itemWidth = wi ? wi : itemWidth ;
		itemHeight = he ? he : itemHeight ;
		
		if((itemWidth + itemHeight) > 0 ){
			// tell the ldr where this item is so it can place the loader over it
			if(!loaderRectSet && !isVideo){
				loaderRectSet = true;
				if(itemWidth > 80 && itemHeight > 80){
					var anchorPoint:Object = new Object({x:0, y:0}); 
					this.localToGlobal(anchorPoint);
					var rect:Object = new Object({x:anchorPoint.x,y:anchorPoint.y,width:itemWidth,height:itemHeight})
					ldr.setRect(rect,this);
				}
			}
			if(isVideo && !medialoaded && !updating){
				//roughly position the video loader - a more accurate position will be given when medialoaded is true
				item_mc.vidLoader._x = Math.round((itemWidth - item_mc.vidLoader._width)/2);
				item_mc.vidLoader._y = Math.round((itemHeight - item_mc.vidLoader._height)/2);
			}
				
			if(setupcomplete && medialoaded){
				
				var w = itemWidth;
				var h = itemHeight;
			
				var smallest = Math.min(w,h);
				
				var xpos:Number = 0;
				var ypos:Number = 0;
				
				//work out the border margins 
				var borderMargins:Array = new Array(frameXML.childNodes.length);
				var totalMargins:Object = new Object();
				var sizeAtt:String;
				var filloutSet:Boolean = false;
				for(var i = 0; i < frameXML.childNodes.length;i++){
					sizeAtt = frameXML.childNodes[i].attributes.size;
					borderMargins[i] = getDimensions(sizeAtt,smallest);
					borderMargins[i].fillout = frameXML.childNodes[i].attributes.fillout == "1" ? true : false ;
					if(!filloutSet){
						 filloutSet = borderMargins[i].fillout 
					}
					for(var p in borderMargins[i]){
						totalMargins[p] = totalMargins[p] ? totalMargins[p] + borderMargins[i][p] : borderMargins[i][p] ;
					}
				}
				
				// fillout means that the borders are expanded to  fill the remaining available space
				if(!filloutSet){
					 borderMargins[0].fillout = true;
				}
				
				if(!isVideo){
					// make sure the mediaTem target is the resizeable image. At the end if the image is xscale == 100, then
					// the mediaItem will be changed back to this
					mediaItem = item_mc.item;
					item_mc.item_raw._visible = false;
					item_mc.item._visible = true;
				}
				
				// the border sizes are stored in an object as they may need to be tweened to
				nextBorders = new Object();
				nextBorders.borders = new Array(frameXML.childNodes.length);
				bordersID++;
				nextBorders.borderID = bordersID;
				
				var col:Number;	
				var alpha:Number;
				
				switch(resizemode){
					case 0:
						// borders fill out to the edges of the available area, the image get's the rest
						// the image is sized to fit the space as best it can - the image remains in proportion.
						// fillout has no effect as the frame fills out the whole space by default
						
						nextBorders.bmc_x = xpos;
						nextBorders.bmc_y = ypos;
						
						
						// Each border is a simple rectangle, there sizes and positions are worked out here
						var bxpos = 0;
						var bypos = 0;
						for(var i = 0; i < frameXML.childNodes.length;i++){
							col = Number(frameXML.childNodes[i].attributes.color);
							alpha = Number(frameXML.childNodes[i].attributes.alpha);
							alpha = isNaN(alpha) ? 100 : alpha ;
						
							nextBorders.borders[i] = {wi:w,he:h,x:bxpos,y:bypos,c:col,a:alpha};
							
							w -= borderMargins[i].ml + borderMargins[i].mr;
							h -= borderMargins[i].mt + borderMargins[i].mb;
							
							bxpos += borderMargins[i].ml;
							bypos += borderMargins[i].mt;
						}
						
						//mask
						//drawRect(item_mc.mask,w,h,0x000000,100);
						item_mc.mask._width = w;
						item_mc.mask._height = h;
						item_mc.mask._x = xpos + bxpos;
						item_mc.mask._y = ypos + bypos;
						
						item_mc.mask_raw._width = w;
						item_mc.mask_raw._height = h;
						item_mc.mask_raw._x = xpos + bxpos;
						item_mc.mask_raw._y = ypos + bypos;
						
						//item - make the best fit to the available shape
						setImageSize(w,h,item_mc.mask._x,item_mc.mask._y);
						
						
					break;
					case 1:
					case 2:
						// case 1
						// the image is proprotionally sized to fit the space available (minus the borders)
						
						// case 2
						// the image is not resized unless it is too big for the space
						
						// item is sized first
						// item - make the best fit to the available shape
						var availW = w - totalMargins.ml - totalMargins.mr;
						var availH = h - totalMargins.mt - totalMargins.mb;
						
						// mask is not used
						
						setImageSize(availW,availH);
							
						// the image and borders are positioned centrally
					
						var indent_x:Number = Math.round((w - mediaItem._width - totalMargins.ml - totalMargins.mr) /2)
						var indent_y:Number = Math.round((h - mediaItem._height - totalMargins.mt - totalMargins.mb) /2)
						mediaItem._x = xpos + indent_x  + totalMargins.ml ;
						mediaItem._y = ypos + indent_y  + totalMargins.mt ; 
						
						
						// borders - start with the inner (last xml frame node) as these are cumulative
						// Each border is a simple rectangle, there sizes and positions are worked out here
						var borderW:Number = fillout ? w : mediaItem._width + totalMargins.ml + totalMargins.mr;
						var borderH:Number = fillout ? h : mediaItem._height + + totalMargins.mt + totalMargins.mb;
						
						var bxpos = 0;
						var bypos = 0;
						
						for(var i = 0; i < frameXML.childNodes.length ;i++){
						
							col = Number( frameXML.childNodes[i].attributes.color);
							alpha = Number(frameXML.childNodes[i].attributes.alpha);
							alpha = isNaN(alpha) ? 100 : alpha ;
							
							// add the remaining space if this is the fillout border
							if(fillout && borderMargins[i].fillout){
								borderMargins[i].ml += indent_x ;
								borderMargins[i].mr += indent_x ;
								borderMargins[i].mt += indent_y ;
								borderMargins[i].mb += indent_y ;
							}
							
							nextBorders.borders[i] = {wi:borderW,he:borderH,x:bxpos,y:bypos,c:col,a:alpha};
							
							borderW -= borderMargins[i].ml + borderMargins[i].mr;
							borderH -= borderMargins[i].mt + borderMargins[i].mb;
							
							bxpos += borderMargins[i].ml;
							bypos += borderMargins[i].mt;
				
						}	
						
						nextBorders.bmc_x = fillout ? xpos : xpos + indent_x;
						nextBorders.bmc_y = fillout ? ypos : ypos + indent_y;
					break;
				}
				
				
				if(isVideo){
					
					// position the 'loader' (accurately as opposed to the rough positioning above)
					item_mc.vidLoader._x = mediaItem._x + Math.round((mediaItem._width - item_mc.vidLoader._width)/2);
					item_mc.vidLoader._y = mediaItem._y + Math.round((mediaItem._height - item_mc.vidLoader._height)/2);
					
					//setup/layout the controller
					controller_mc._x = resizemode == 0 ? item_mc.mask._x : mediaItem._x ;
					var baseY =  resizemode == 0 ? item_mc.mask._y + item_mc.mask._height:  mediaItem._y + mediaItem._height ;
					controller_mc._y = baseY + Math.round(( totalMargins.mb - controllerheight )/2);
					
					var baseW =  resizemode == 0 ? item_mc.mask._width:   mediaItem._width ;
					controller_mc.vol_btn._x = baseW - controller_mc.vol_btn._width;
					controller_mc.vol._x = controller_mc.vol_btn._x;
					controller_mc.mute_btn._x = controller_mc.vol_btn._x  - controller_mc.mute_btn._width;
					controller_mc.fwd_btn._x = controller_mc.mute_btn._x  - controller_mc.fwd_btn._width;
					controller_mc.play_btn._x = controller_mc.fwd_btn._x - controller_mc.play_btn._width;
					controller_mc.pause_btn._x = controller_mc.play_btn._x;
					controller_mc.rewind_btn._x = controller_mc.play_btn._x -  controller_mc.rewind_btn._width;
					controller_mc.track_btn._width = controller_mc.rewind_btn._x;
					controller_mc.tracklines.trackbg._width = controller_mc.rewind_btn._x;
					
					// the video interval positions the moving objects of the controller (ie tracker position) so 
					// on size change immediately trigger the interval
					onVideoInterval();
					
				}else{
					// if it's an image and the xscale is 100 then use the raw image instead of the resizeable version (which is smoothed)
					if(mediaItem._xscale == 100){
						mediaItem = item_mc.item_raw;
						item_mc.item_raw._x = item_mc.item._x;
						item_mc.item_raw._y = item_mc.item._y;
						item_mc.item_raw._visible = true;
						item_mc.item._visible = false;
					}
				}
				
				// update the tweenable graphics
				updateTransition();
			
				// the broadcast is done after the border is complete during updating
				if(!updating){
					broadcastReady();
				}
			}
		}
	}
	
	// used by items that want to position themselves relative to the media item
	private function broadcastReady(){
		if(!broadcastedReady){
			broadcastedReady = true;
			broadcaster.broadcastMessage("onMediaItemReady");
		}
	}
	
	//returns an object with mt,mr,mb,ml - dimension is used to work out fractional margins
	private function getDimensions(sizeAtt:String,dimension:Number){
		var sizeArr = sizeAtt.split(",");
		var obj:Object = new Object();
		obj.mt = Number(sizeArr[0]) < 1 ? Number(sizeArr[0]) * dimension : Number(sizeArr[0]) ;
		obj.mr = sizeArr[1] != undefined ? (Number(sizeArr[1]) < 1 ? Number(sizeArr[1]) * dimension : Number(sizeArr[1])) : obj.mt ;
		obj.mb = sizeArr[2] != undefined ? (Number(sizeArr[2]) < 1 ? Number(sizeArr[2]) * dimension : Number(sizeArr[2])) : obj.mt ;
		obj.ml = sizeArr[3] != undefined ? (Number(sizeArr[3]) < 1 ? Number(sizeArr[3]) * dimension : Number(sizeArr[3])) : obj.mt ;
		return obj;
	}
	
	//sets the image proportionally to the available size
	//if fill is true it sizes the image to fill the space, if not it sizes the image so that it fits into the space
	private function setImageSize(w:Number,h:Number,xpos:Number,ypos:Number){	
		if(medialoaded){
			
			// w and h are the dimensions of the space left over after the 
			// borders have been drawn.
				
			var w_ratio:Number = ((mediaItem._width * 100 / mediaItem._xscale) / w);
			var h_ratio:Number = ((mediaItem._height * 100 / mediaItem._yscale) / h);
			
			//scale - video loads into a video object that is 160 x 120 however the video could be any size.
			// scaleBase determines the proprtionate difference that the actual video  has to the video object
			var xscaleBase = 100;
			var yscaleBase = 100;
			if(isVideo && hasVideoDimensions){
				var vidObjW = mediaItem._width * 100 / mediaItem._xscale ;
				var vidObjH = mediaItem._height * 100 / mediaItem._yscale ;
				xscaleBase = vidMetaData.width ? vidMetaData.width / vidObjW * 100 : 100 ;
				yscaleBase = vidMetaData.height ? vidMetaData.height / vidObjH * 100 : 100 ;
				w_ratio = vidMetaData.width ? (vidMetaData.width / w) : w_ratio ;
				h_ratio = vidMetaData.height ? (vidMetaData.height / h) : h_ratio ;
			}
			
			switch(resizemode){
				case 0:
					
					// the task is to fill the space with the image and keep it in proportion
				
					if(w_ratio <= h_ratio){
						mediaItem._width = w;
						mediaItem._yscale = mediaItem._xscale / xscaleBase * yscaleBase;
						mediaItem._x = xpos;
						mediaItem._y = ypos - Math.round((mediaItem._height - h)/2);
					}else{
						mediaItem._height = h;
						mediaItem._xscale = mediaItem._yscale / yscaleBase * xscaleBase;//mediaItem._yscale ;
						mediaItem._x = xpos - Math.round((mediaItem._width - w)/2);
						mediaItem._y = ypos;
					}
				break;
				case 1:
					// the task is to scale up or down the image to make the best fit
					// the difference to 0 is that in this mode the whole image must be shown
					// so it is the opposite - the image is sized to the bigger ratio
					
					if(w_ratio >= h_ratio){
						
						mediaItem._width = w;
						mediaItem._yscale = mediaItem._xscale / xscaleBase * yscaleBase;
					}else{
						mediaItem._height = h;
						mediaItem._xscale = mediaItem._yscale / yscaleBase * xscaleBase;
					}
					
				break;
				case 2:
					// the task is to reduce the image if it won't fit in the available space,
					// otherwise let it be
					// if there are no video dimensions in the metadata then the video is scaled to the space - effectively resizemode 1
					if(w_ratio > 1 || h_ratio> 1 || (isVideo && !hasVideoDimensions)){
						if(w_ratio >= h_ratio){	
							mediaItem._width = w;
							mediaItem._yscale = mediaItem._xscale / xscaleBase * yscaleBase;
						}else{
							mediaItem._height = h;
							mediaItem._xscale = mediaItem._yscale / yscaleBase * xscaleBase;
						}
					}else{
						mediaItem._xscale = xscaleBase;
						mediaItem._yscale = yscaleBase;
					}
				break;
			}
		}
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
	
	//
	// get dimensions
	//
	
	public function get actualWidth():Number{
		return itemW;
	}
	
	public function get actualHeight():Number{
		return itemH;
	}
	
	public function get actualY():Number{
		return itemY;
	}
	
	public function get actualX():Number{
		return itemX;
	}
	
	
	
	/// Video 
	/* 
	Video processes
	
	Process triggered by mediaItem init (not by open - that just triggers the fade up)
	
		1.  mbMediaItem.as loadMedia()
				videoplayer.swf is loaded
				isVideo set to true
		2.	mbMediaItem.as onMediaLoaded()
				stream variable set with the netStream in videoplayer.swf
				stream buffertime of 5secs set
				stream onStatus() - set to call mbMediaItem.as onStreamStatus()
		3.	curMediaItem.as onMediaLoadedSetup()
				mask set up
				startMedia called
				loader displayed
		4.  curMediaItem.as startMedia(true)
				video interval started
				url of video passed to stream with play()
				streamOpen set to true
				audio setup
				playMedia called
		5.	curMediaItem.as playMedia()
				isPlaying set to true
		6.	vidMetaData set (video interval checks to see when the video metaData is set in videoplayer.swf)
				medialoaded is set to true
				if dimensions are present or not then setSize is called
				video is made visible
		7. preloadComplete set to true (when the buffer is reached)
				loader is hidden
		8.	Normal playback mode
			video interval
				Controller items are updated with the latest video data
				Seek requests are captured and initiated
				Volume changes requests are completed
			onStreamStatus
				NetStream.Play.Stop
					Video ends  - startMedia is called
						
				NetStream.Play.Start
					Poss point to display visibility?
					
				NetStream.Seek.Notify
					waitingForSeek is set to false, allowing the pendingSeek to be implemented
		9. curMediaItem.as startMedia(true)
				video set to invisible
				video paused
				stream closed
				Booleans set to false
					waitingForSeek = false;
					streamOpen = false;
					hasVideoDimensions = false;
				video interval cleared
	
	Process triggered by mediaItem close
		1. curMediaItem.as onClose()
				Cancel the current load request
	
	Process triggered by mediaItem open
		1. curMediaItem.as onOpen()
				interval started
		2. on Interval and UpdateTransition
				if medialoaded is true, the the media Item is faded up
	
	Process triggered by mediaItem update
		1. curMediaItem.as onUpdate()
				interval started
		2. on Interval and UpdateTransition
				fade down the old mediaItem
				when done calls readyToUpdate()
		3. curMediaItem.as readyToUpdate()
				Booleans set to false
					loaderRectSet
					medialoaded
					setupcomplete
					updatedMedia
				Border mcs cleared (copy of borders remains - this will crossfade with the new borders)
				controller set to invisible
				updateMedia called
		4. curMediaItem.as updateMedia()
				updatedMedia Boolean set to true
				loadMedia called
				- load process above is repeated
	
	*/
	
	
	
	
	
	private function setupController(){
		// MovieClip items in the controller
		//playhead
		//track_btn
		//tracklines
		//   .trackbg
		//   .trackplayed
		//   .trackbuffered
		//rewind_btn
		//play_btn
		//pause_btn
		//fwd_btn
		
		//mute_btn
		//vol_btn
		//vol
		//   .bg
		//   .level
		//   .mask
		
		var controllerheightStObj:Object = theme.styles.getStyle(".controllerheight");
		if(!controllerheightStObj.fontSize){
			controllerheightStObj = 20;
		}else{
			controllerheightStObj = Number(controllerheightStObj.fontSize);
		}
		
		controllerheight = indexNodeXML.attributes.controllerheight != undefined ? Number(indexNodeXML.attributes.controllerheight) : controllerheight ;
		
		
		//colors of controller buttons and display
		
		controller_mc.cols = new Object();
		//check for the override
		var oc:Number;
		oc = Number(theme.getStyleColor("._controllerBtnUp","0x"));
		controller_mc.cols._controllerBtnUp = oc ? oc : theme.compColor;
		
		oc = Number(theme.getStyleColor("._controllerBtnOver","0x"));
		controller_mc.cols._controllerBtnOver = oc ? oc : theme.baseColor;
		
		oc = Number(theme.getStyleColor("._controllertrackbg","0x"));
		controller_mc.cols._controllertrackbg = oc ? oc : theme.compTints[theme.compTints.length - 2];
		
		oc = Number(theme.getStyleColor("._controllertrackbuffer","0x"));
		controller_mc.cols._controllertrackbuffer = oc ? oc : theme.compColor;
		
		oc = Number(theme.getStyleColor("._controllertrackplayed","0x"));
		controller_mc.cols._controllertrackplayed = oc ? oc : theme.baseColor;
		
		
		for(var p in controller_mc){
			controller_mc.cols[p] =  new Color(controller_mc[p]) ;
			switch(p){
				case "tracklines":
					// the tracklines mc has three line clips in it - bg, buffered and played
					controller_mc[p]._y = (controllerheight - controller_mc[p]._height) / 2;
					// these lines need a sep color object
					for(var q in controller_mc[p]){
						controller_mc.cols[q] =  new Color(controller_mc[p][q]) ;
						controller_mc.cols[q].setRGB(controller_mc.cols["_controller"+ q ]);
					}
				break;
				case "playhead":
					// the playhead is not a button - it is controlled by user interactions with the track_btn - an invisible button that covers the whole area
					controller_mc[p]._height = Math.round(controllerheight * 0.8);
					controller_mc[p]._y = (controllerheight - controller_mc[p]._height) / 2;
					controller_mc[p]._x = 0;
					
					//  color changed with track_btn events
					controller_mc.track_btn.onRollOut();
				break;
				case "vol":
					//vol
					
					controller_mc[p]._height = Math.round(controllerheight * 0.8);
					controller_mc[p]._xscale = controller_mc[p]._yscale;
					controller_mc[p]._y = (controllerheight - controller_mc[p]._height) / 2;
					
					// color chnaged with vol_btn events
					controller_mc.vol_btn.onRollOut();
					
				break;
				default:
					controller_mc[p].onRelease = this.onControllerRelease;
					controller_mc[p].onRollOver = this.onControllerOver ;
					controller_mc[p].onRollOut = this.onControllerOut ;
					controller_mc[p].onReleaseOutside = this.onControllerReleaseOutside ;
					controller_mc[p].onPress = this.onControllerPress ;
			
					//init in Out mode
					controller_mc[p].onRollOut();
					
					controller_mc[p]._height = controllerheight;
					controller_mc[p]._xscale = controller_mc[p]._yscale;
					
				break;
			}
		}
		
	}
	
	// see description of video loading/playback process for info on this method
	private function playMedia(p:Boolean){
		if(!streamOpen){
			if(p)
				startMedia(p);
		}else{
			if(isPlaying && !p){
				//pause
				stream.pause(true);
				isPlaying = false;
			}
			if(!isPlaying && p){
			
				stream.pause(false);
				isPlaying = true;
			}
		}
		
	}
	// see description of video loading/playback process for info on this method
	private function startMedia(s:Boolean){
		if(!streamOpen && s){
			
			startVideoInterval();
			stream.play(itemURL);
			streamOpen = true;
		
			controller_mc.vol.attachAudio(stream);
			video_sound = new Sound(controller_mc.vol);
			setVideoVolume(video_sound.getVolume());
			
			playMedia(true); 
			
		}
		if(streamOpen && !s){
			
			playMedia(false);
			stream.close();	
			waitingForSeek = false;
			streamOpen = false;
			receivedStartedStatus = false;
			clearVideoInterval();
		}
	}
	
	// the 'fast forward/rewind' process - move the playback to a time in the movie
	private function seek(sk:Boolean,src:MovieClip){//timeto:Number){
		if(!streamOpen && sk)
				startMedia(sk);
	
		seekIntervalCount = seeking != sk ? 0 : seekIntervalCount ;
		seeking = sk;
		seekSource = src;

	}
	
	//
	// Volume controls
	//
	private function mute(){
		var newvol;
		if(video_sound.getVolume() > 0){
			mute_volume_level = video_sound.getVolume();
			newvol = 0;
		}else{
			newvol = mute_volume_level > 30 ? mute_volume_level : 30;
		}
		setVideoVolume(newvol);
	}
	
	private function adjustVolume(av:Boolean){
		adjustingVolume = av;
	}
	
	private function setVideoVolume(v:Number){
		v = Math.max(0,Math.min(100,v));
		video_sound.setVolume(v);
		controller_mc.vol.mask._width = v/100 * controller_mc.vol.vol_bg._width;
	}
	
	
	// Receives broadcasts from the stream object
	private function onStreamStatus(infoObject:Object) {
		switch(infoObject.code){
			case "NetStream.Play.Stop":
				startMedia(false); // the end of the movie, the controller UI will react to this
			break;
			case "NetStream.Play.Start":
				receivedStartedStatus = true; // unused but stored just in case

			break;
			case "NetStream.Seek.Notify":
				waitingForSeek = false; // allows the next seek to happen (pendingSeek)
			break;
		}
	}
	private function clearVideoInterval(){
		if(videoInterval != undefined){
			clearInterval(videoInterval);
			videoInterval = undefined;
			
			// //do one final call so that all UI elements can react to the video completed state
			onVideoInterval();
			
		}
	}
	private function startVideoInterval(){
		if(videoInterval == undefined){
			videoInterval = setInterval(this,"onVideoInterval",50);
		}
	}
	private function onVideoInterval(){
		// Stream properties
		//bufferLength:The number of seconds of data currently in the buffer.
		//bufferTime:The number of seconds assigned to the buffer by NetStream.setBufferTime().
		//bytesLoaded:The number of bytes of data that have been loaded into the player.
		//bytesTotal:The total size in bytes of the file being loaded into the player.
		//checkPolicyFile:Specifies whether Flash Player should attempt to download a cross-domain policy file from the loaded FLV file's server before beginning to load the FLV file itself.
		//currentFps:The number of frames per second being displayed.
		//time:The position of the playhead, in seconds.
		
		if(!preloadComplete){
			// 2 tests to see if the video has loaded enough that we can take down the loader and let it play
			// - has it reached 90% of the buffer
			// - has the time reached stream.bufferTime (this is essentially a backup because the interval may sometimes miss the buffer reached state)
			
			if(stream.bufferLength >= (0.9 * stream.bufferTime)){
				preloadComplete = true;
				item_mc.vidLoader._visible = false;
			}
			
			if(stream.time >= stream.bufferTime){
				preloadComplete = true;
				item_mc.vidLoader._visible = false;
			}
			
			
		}
		
		// metadata should contain width and height info - but if it doesn't then 
		// setSize is called anyway - the setSize method will do the best it can with postioning nand sizing the video
		if(vidMetaData == undefined){
			if(this.item_mc.vid.metaData != undefined){
				vidMetaData = this.item_mc.vid.metaData;
				if(vidMetaData.height || vidMetaData.width){
					hasVideoDimensions = true;	
				}
				medialoaded = true;
				setSize();
			}
		}
		
		//
		// controller UI update and Seek management
		//
		if(vidMetaData){
			// move play head
			controller_mc.playhead._x = stream.time  / vidMetaData.duration * controller_mc.track_btn._width - (controller_mc.playhead._width / 2);
			
			// adjust buffer and played tracks
			controller_mc.tracklines.trackbuffered._width = stream.bytesLoaded/stream.bytesTotal * controller_mc.track_btn._width;
			controller_mc.tracklines.trackplayed._width = controller_mc.playhead._x;
			
			// set play/pause button
			controller_mc.play_btn._visible = !isPlaying;
			controller_mc.pause_btn._visible = isPlaying;
			
			
			if(seeking){
				seekIntervalCount++;
				var timeTo:Number;
	
				switch(seekSource._name){
					case "track_btn":
						var mousepos =  seekSource._xmouse * seekSource._xscale / 100 / seekSource._width;
						timeTo = this.vidMetaData.duration * mousepos;
					break;
					case "rewind_btn":
						timeTo = stream.time - Math.min((vidMetaData.duration/10),Math.round(seekIntervalCount / 2));
					break;
					case "fwd_btn":
						timeTo = stream.time + Math.min((vidMetaData.duration/10),Math.round(seekIntervalCount / 2));
					break;
				}
				// only seek within the range of 0 and what has loaded
				var seekableDuration = stream.bytesLoaded / stream.bytesTotal * vidMetaData.duration;
				pendingSeek = Math.max(0,timeTo);
				pendingSeek = Math.min((seekableDuration * 0.99),pendingSeek);
				
			}
			
			if(adjustingVolume){
				var mousepos = controller_mc.vol_btn._xmouse * controller_mc.vol_btn._xscale / 100 / controller_mc.vol_btn._width;
				var newvol = Math.round(mousepos * 100);
				setVideoVolume(newvol);
			}
			
			if(pendingSeek != lastSeek){
				if(!waitingForSeek){
					
					waitingForSeek = true;
					stream.seek(pendingSeek);
					lastSeek = pendingSeek;
				}else{
				}
			}
		}
		
		if(!streamOpen){
			controller_mc.playhead._x = 0;
			// adjust buffer and played tracks
			controller_mc.tracklines.trackbuffered._width = 0;
			controller_mc.tracklines.trackplayed._width = controller_mc.playhead._x;
			
			// set play/pause button
			controller_mc.play_btn._visible = true;
			controller_mc.pause_btn._visible = false;
		}
		
	}
	
	private function onControllerRelease(){
		switch(this._name){
			case "track_btn":
				this._parent._parent.seek(false,this);
			break;
			case "rewind_btn":
				this._parent._parent.seek(false,this);
			break;
			case "play_btn":
				this._parent._parent.playMedia(true);
			break;
			case "pause_btn":
				this._parent._parent.playMedia(false);
			break;
			case "fwd_btn":
				this._parent._parent.seek(false,this);
			break;
			case "mute_btn":
				this._parent._parent.mute();
			break;
			case "vol_btn":
				this._parent._parent.adjustVolume(false);
			break
		}
		this.onRollOut();
	}
	
	private function onControllerOver(){
		switch(this._name){
			case "track_btn":
				this._parent.cols["playhead"].setRGB(this._parent.cols._controllerBtnOver);
			break;
			case "vol_btn":
				this._parent.cols["vol"].setRGB(this._parent.cols._controllerBtnOver);
			break;
			default:
				this._parent.cols[this._name].setRGB(this._parent.cols._controllerBtnOver);
			break;
		}
		
	}
	
	private function onControllerOut(){
		//color behavior
		switch(this._name){
			case "track_btn":
				this._parent.cols["playhead"].setRGB(this._parent.cols._controllerBtnUp);
			break;
			case "vol_btn":
				this._parent.cols["vol"].setRGB(this._parent.cols._controllerBtnUp);
			break;
			default:
				this._parent.cols[this._name].setRGB(this._parent.cols._controllerBtnUp);
			break;
		}
		
		// cancel a seek if out
		switch(this._name){
			case "track_btn":
			case "rewind_btn":
			case "fwd_btn":
				this._parent._parent.seek(false,this);
			break;
		}
	}
	
	private function onControllerReleaseOutside(){
		if(this._name = "vol_btn"){
			this._parent._parent.adjustVolume(false);
		}
		this.onRollOut();
	}
	private function onControllerPress(){
		switch(this._name){
			case "track_btn":
				this._parent._parent.seek(true,this);
			break;
			case "rewind_btn":
				this._parent._parent.seek(true,this);
			break;
			case "play_btn":
				//	trace("play btn pressed ("+getTimer()+" ms)");
			break;
			case "pause_btn":
				//trace("pause_btn pressed  ("+getTimer()+" ms)");
			break;
			case "fwd_btn":
				this._parent._parent.seek(true,this);
			break;
			case "vol_btn":
				this._parent._parent.adjustVolume(true);
			break
		}
	}
}