
/*
com.mbudm.min.minLoader.as 
extends com.mbudm.mbLoader

Steve Roberts May 2009

Description
The minLoader draws the loader, and displays the label of the currently loadin item.
If no load activity is occuring, the loader hides itself.
It also listens to onResize, which it uses to reposition the loader.
 
*/

import TextField;
import TextField.StyleSheet;

class com.mbudm.min.minLoader extends com.mbudm.mbLoader{
	/*
	com.mbudm.mbLoader vars:
	
	private var lq:Array; //load queue
	private var lc:Array; //load complete
	private var _interval:Number; // load monitor
	private var mcLoader:MovieClipLoader; //for loading all swf, jpg, png, gif
	
	private var layout:mbLayout;
	private var loadedPause:Boolean;//leaves the loader open for a tick or three after the load is completed
	private var loadedPauseCount:Number;
	
	private var itemIndex:Number; // a number so that the monitor knows when a new item is being loaded
	
	*/
	private var ldr_mc:MovieClip;
	private var bg:MovieClip;
	private var tf:TextField;
	private var tfw:Number;
	private var tfh:Number;
	private var margin:Number
	private var mode:Number; //0, centered on movie, 1 centered on content , 2 above right of content (unused)
	private var ldrColor:Number;
	
	private var currentItem:Number;
	
	function minLoader(){
		this._visible = false;
		tfw = 200;
		tfh = 5;
		
		// set manually as the loader is set up before the theme object is available
		ldrColor = 0x88aacc;

		this.createEmptyMovieClip("ldr_mc",this.getNextHighestDepth());
		this.ldr_mc._visible = false;
			
		this.ldr_mc.createEmptyMovieClip("border",this.ldr_mc.getNextHighestDepth());
		this.ldr_mc.createEmptyMovieClip("bar",this.ldr_mc.getNextHighestDepth());
		
		
		drawRect(this.ldr_mc.border,tfw,tfh,ldrColor,0,1,100);
		
		this.ldr_mc.createTextField("tf",this.ldr_mc.getNextHighestDepth(),0,0,tfw,tfh);
		ldr_mc.tf.autoSize = true;
		ldr_mc.tf.wordWrap = true;
		ldr_mc.tf.html = true;
		
		
		
		
		//  set manually as the loader is set up before the theme object is available
		var ldrStyle:TextField.StyleSheet = new TextField.StyleSheet();
		ldrStyle.setStyle(".loaderLabel", 
			{fontFamily: 'Arial', 
			fontSize: '9',
			color:'#88aacc'}
		);
		ldr_mc.tf.styleSheet = ldrStyle;
		ldr_mc.tf.htmlText =" ";
		
		onResize();
		
		this._visible = true;
	}
	
	private function customInit(){
		defaultMode = 1;
	}
	
	private function onLayout(){

	}
	
	private function monitorLoader(){
		// called when load activity is occuring
		
		var ro = report();
		/*trace("---monitorLoader--");
		for(var p in ro){
		trace(p+": "+ro[p]);
		}
		
		
		reportObj.displayMode
		reportObj.itemsLoading = 0;
		reportObj.bytesLoaded = 0
		reportObj.bytesTotal = 0
		reportObj.items
		*/
		
		// change layout if a new mode is being requested
		var newMode = layout != undefined ? ro.displayMode : defaultMode ;
		if(newMode != mode){
			mode = newMode;
			onResize();
		}
		
		if(ro.itemsLoading > 0){
	
			// draw the loader bar to the correct length
			//if(ro.index == currentItem){
				var percent = ro.bytesLoaded / ro.bytesTotal;
				percent = isNaN(percent) ? 0 : Math.round(percent * 100);
				var barLength = tfw / 100 * percent ;
				
				drawRect(ldr_mc.bar,barLength,tfh,ldrColor,100);
		//	}else{
			//	currentItem = ro.index;
			//	drawRect(ldr_mc.bar,0,tfh,ldrColor,100);
			//}
			
			//display the label of the current item
			ldr_mc.tf.htmlText = "<span class=\"loaderLabel\">"+ro.items+"</span>";
			ldr_mc.tf._y =0 - 1 - ldr_mc.tf._height;
	
			this.ldr_mc._visible = true;
			
		}else{
			this.ldr_mc._visible = false;
			//reset the bar and the label for next load
			drawRect(ldr_mc.bar,0,tfh,ldrColor,100);
			ldr_mc.tf.htmlText =" ";
		}
		
	}
	
	public function onResize(){
		var xPos:Number;
		var yPos:Number;
	
		//shortcuts to margin props
		var ml:Number = layout.getDimension("marginleft");
		var mr:Number = layout.getDimension("marginright");
		var mt:Number = layout.getDimension("margintop");

		var w = layout.getDimension("w") != undefined ? layout.getDimension("w") : Stage.width;
		var h = layout.getDimension("h") != undefined ? layout.getDimension("h") : Stage.height;

		switch(mode){
			case 1:
				
				//align over content
				var cW = layout.getDimension("sitewidth") - layout.getDimension("navwidth") - layout.getDimension("gutter");
				var cH = layout.getDimension("siteheight") ;
				xPos = ml + layout.getDimension("navwidth") + layout.getDimension("gutter") + ((cW - this.ldr_mc._width)/2);
				yPos = mt + ((cH - this.ldr_mc._height)/2);
				
			break;
			case 2:
				//align to top right of content
				xPos = w - mr - this.ldr_mc._width;
				yPos = mt - this.ldr_mc._height;
			break;
			default:
				xPos = (w - this.ldr_mc._width)/2;
				yPos = (h - this.ldr_mc._height)/2;
			break;
		}
		ldr_mc._x = xPos;
		ldr_mc._y = yPos;

	}
	
	//drawing api methods
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number, a:Number,lW:Number,lA:Number) {
		var alpha:Number = a == undefined ? 100 : a ;
		var lineAlpha:Number = lA;
		var lineWidth:Number = lW;
		mc.clear();	
		if(lineWidth >= 0){
			mc.lineStyle(lineWidth,col,lineAlpha);
		}
		if(mc){
			with(mc){
				beginFill(col, alpha);
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