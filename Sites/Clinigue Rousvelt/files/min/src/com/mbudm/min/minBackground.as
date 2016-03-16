/*
com.mbudm.min.minBackground.as 
extends com.mbudm.mbBackground

Steve Roberts May 2009

Description
minBackground manages the loading and transition of background images or SWFs. 

On each navigation update it checks for a background url and if it finds one that is different to the current background, it adds it to the list of backgrounds waiting to be faded. 

Note if a background is set for an ancestor of the current node, and the current node has no background set, then the ancestor background will be used. This means that if you want one background to be the same for each page in a section, you only need to setit once... on the hifhest ancestor node.

It also listens to onResize, which it uses to redraw the background image/swf.
 
*/

import flash.display.*;
import mx.transitions.Tween;
import mx.transitions.easing.*;

class com.mbudm.min.minBackground extends com.mbudm.mbBackground{
	/* com.mbudm.mbBackground vars
	private var indexNode:XMLNode; 
	private var index:mbIndex
	private var theme:mbTheme;
	private var ldr:MovieClip;
	private var backgroundXML:XMLNode;
	private var layout:mbLayout;
	
	private var w:Number;
	private var h:Number;
	*/
	
	private var _interval:Number;
	private var intervalFrequency:Number = 10; // 1/10th of a second
	private var fadeUpQueue:Array;
	private var fading:Boolean;
	private var fadeDuration:Number = 20; // multiples of intervalFrequency
	private var fadeCount:Number = 0;
	
	
	private var transitions:Array;
	private var transitionsIdCounter:Number
	
	private var current_bg_mc:MovieClip;
	private var direction:Boolean; //fading direction 'up' or 'down'
	
	private var currentURL:String;
	private var nextURL:String;
	
	function minBackground(){
	
		this.fadeUpQueue = new Array();
		fading = false;
		
		
		transitions =  new Array();
		transitionsIdCounter = 0;
	
	}

	private function updateBackground(){
		
		//Is there a bg specified for this page (check all ancestors)
		var bgurl:String = findBG(indexNode);
		if(bgurl != undefined){
			if((bgurl != currentURL  && !nextURL) && (bgurl != currentURL && bgurl != nextURL)){
				
				//load the requested bg item
				
				var id:Number = this.getNextHighestDepth()
				this.createEmptyMovieClip("bg"+id,this.getNextHighestDepth());
				
				this["bg"+id]._alpha = 0;  // loaded items are faded up - so the alpha is set to 0
				this["bg"+id]._visible = false;
				
				var obj:Object = new Object();
				obj.url = bgurl;
				obj.label = "Next Background: "+bgurl;
				obj.target = this["bg"+id];
				obj.onLoad = "fade";
				obj.onLoadTarget = this;
				obj.type = "swf";
				ldr.loadRequest(obj);
				
				
			}else{
				// no change so we do nothing
			}
		}else{
			//no url so fade down whatever is current

			fade();
		}
	}
	
	// searches for a bgurl attribute in this node or one of it's ancestors
	private function findBG(n:XMLNode):String{
		var str:String;
		if(n.attributes.bgurl){
			str = n.attributes.bgurl;
		}else if(n.parentNode != null){
			
			str = findBG(n.parentNode);
		}
		return str;
	}

	
	// called from tController, when it is this classes 'turn' to do it's transition, 
	// tController 'authorises' this class to do the transition
	public function onTransitionAuthorised(id:String){
		
		var authorisePos:Number = 0;
		//var removed:String; variable for testing
		for(var i = transitions.length-1; i>=0 ;i--){
			if(transitions[i].id  == id){
				transitions[i].authorised = true;
				authorisePos = i;
				
			}
			
			// if it's not the first in the queue that is being authorised, then there is a backlog of background fade requests
			// this happens when a user navigates  more quickly than the backgrounds can load
			// so it's safe to asume that these old requests are no longer needed as the user has moved on
			// so delete all between 0 and the authorised transition
			if(authorisePos > i){
				tController.cancelTransition(transitions[i].id);
				transitions.splice(i,1);
				fadeUpQueue.splice(i,1);
				//removed = "yes"; variable for testing
			}else{
				//removed = "no"; variable for testing
			}
		}
	

	}
	
	// on load event or 'null' url request.
	// results in an additional fade/transition request being created
	
	private function fade(o:Object){
		transitionsIdCounter++;
		var tid:String = this._name +"__" + transitionsIdCounter+"_"+index.currentIndex; //something unique and identifiable
		
		if(o){
			if(backgroundXML.attributes.smoothing == 1){
				// do bitmap smoothing
				// kudos to this guy: http://www.actionscript.org/forums/showthread.php3?t=89255
				
				var id:Number = this.getNextHighestDepth()
				var oldTarget = o.target;
				o.target = undefined;
				var newTarget = this.createEmptyMovieClip("bgSmoothed"+id,this.getNextHighestDepth());
				var w = oldTarget._width;
				var h = oldTarget._height;
				var bmpData:BitmapData = new BitmapData(w, h, true, 0x000000); 
				bmpData.draw(oldTarget);
				newTarget.attachBitmap(bmpData, 2, "auto", true); 
				
				//replace the loaded mc with the new smoothed copy.
				oldTarget.removeMovieClip();
				o.target = newTarget;
				o.target._alpha = 0;
			}
			
			fadeUpQueue.push(o);
			tid += "_"+o.url;
		}else{
			fadeUpQueue.push({url:""});
			tid += "_none";
		}
		
		transitions.push({id:tid,authorised:false});
		tController.requestTransition(this,"fadeUp","onTransitionAuthorised",tid);
		
		onResize();
		
		fading = true;
		
		if(!this._interval){
			this._interval = setInterval(this,"onInterval",intervalFrequency);
		}
	}
	

	private function onInterval(){
		// Because this component asks for transitions in the order it wants it we can safely wait until 
		// the first transition is authorised before proceeding
		if(transitions[0].authorised){
			if(fading){
				if(this.fadeCount == fadeDuration){
					
					// it is this classes responsibility to tell the tController when it has finished an authorised transition
					// this allows the tController to then authorise the next transition in it's list.
					// if this (or any class) doesn't do this, then the whole transition sequence will halt
					tController.transitionComplete(transitions[0].id);
					transitions.shift();
					
					currentURL = fadeUpQueue[0].url;
					
					//set up the new current_bg_mc
					if(fadeUpQueue[0].url != "" ){
						if(current_bg_mc){
							current_bg_mc._visible = false;
							current_bg_mc.removeMovieClip(); //clean up after ourselves. Next time this bg is loaded it will be cached so its ok to delete the old one
						}
						current_bg_mc = fadeUpQueue[0].target;
					}else{
						current_bg_mc = undefined;
					}
					// next please...
					fadeUpQueue.shift();
					
					//if the fade queue is now empty then we are no longer fading
					if(fadeUpQueue.length == 0){
						fading = false;
						nextURL = "";
					}else{
						nextURL = fadeUpQueue[0].url;
					}
					this.fadeCount = 0;
					
				}else{
					this.fadeCount++;
					direction = fadeUpQueue[0].url == "" ? false : true ;
	
					if(direction){
						//fade up the new item over the current item  - the cross fade
						fadeUpQueue[0].target._alpha = Math.ceil(100 * (this.fadeCount / fadeDuration));
					}else{
						if(current_bg_mc){
							//fade down the current item to nothing
							current_bg_mc._alpha = 100 - Math.ceil(100 * (this.fadeCount / fadeDuration));
						}else{
							//no current mc so we are where we want to be.. no bg
							this.fadeCount = fadeDuration;
						}
					}
				}
			}else{
				clearInterval(this._interval);
				this._interval = undefined;
			}
		}
	}
			
	public function onResize(){
		// set the background to the full Stage w/h but maintain proportion
		var w:Number = layout.getDimension("w");
		var h:Number = layout.getDimension("h");
		
		if((w + h) > 0 && (this._width +this._height) > 0 ){
			
			var wf:Number =  w/this._width;
			var hf:Number = h/this._height;
			
			this._xscale = this._xscale * Math.max(wf,hf);
			this._yscale = this._xscale;
		}
	}
	
}