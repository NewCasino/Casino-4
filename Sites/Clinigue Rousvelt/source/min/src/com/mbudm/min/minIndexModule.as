/*
com.mbudm.min.minIndexModule.as 
extends com.mbudm.mbIndexModule

Steve Roberts August 2009 - modified from curIndexModule.as

Description
minIndexModule handles the layout for the indexModule - most of the graphics in this module are in the thumbnails.

*/


class com.mbudm.min.minIndexModule extends com.mbudm.mbIndexModule{
	/* com.mbudm.mbIndexModule vars
	
	private var indexNode:XMLNode; 
	private var indexCoord:String;
	private var index:mbIndex;
	private var pageXML:XML; 
	private var pageXMLobj:Object;
	private var theme:mbTheme;
	private var ldr:mbLoader;
	
	private var index_mc:MovieClip;
	private var pane_mc:MovieClip;
	
	private var thumbItems:Array;
	private var grid_cols:Number;
	private var grid_rows:Number;
	
	private var startTrigger:Boolean;
	private var contentReady:Boolean;
	
	*/
	
	private var heading_txt:TextField;
	private var headingspace:Number = 0; // the vspace between the heading and the media
	
	function minIndexModule(){
		
		
	}
	
	//functions that are extended from mbIndexModule
	
	private function setupModule(){
		index.addListener(this);
		
		
		this.createTextField("heading_txt",this.getNextHighestDepth(),0,0,200,100);
		heading_txt._visible = false;
		heading_txt.html = true;
		heading_txt.wordWrap = true;
		heading_txt.autoSize = true;
		heading_txt.multiline = true;
		heading_txt.condenseWhite = true;
		var headingStObj:Object = theme.styles.getStyle(".pageheading");
		
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(headingStObj.fontFamily.substr(0,2) == "__"){
			heading_txt.embedFonts = true;
		}
		
		if(!headingStObj.color){
		
			var col:String = theme.convertColorToHtmlColor(theme.compTints[0]);
			headingStObj.color = col;
			theme.styles.setStyle(".pageheading",headingStObj);
		}
		heading_txt.styleSheet = theme.styles;
		var str:String;
		if(!pageXMLobj.title.attributes.useParent){
			str = pageXMLobj.title.toString();
		}else{
			str = indexNode.attributes[pageXMLobj.title.attributes.useParent];
		}
		heading_txt.htmlText = "<span class=\"pageheading\">"+str+"</span>";
		
		
		var headingSpaceStObj:Object = theme.styles.getStyle(".pageheadingspace");
		if(!headingSpaceStObj.fontSize){
			headingspace = 10;
		}else{
			headingspace = Number(headingSpaceStObj.fontSize);
		}
		
	
	}
	
	private function onModuleStarted(){
		heading_txt._visible = true;
	}
	
	public function setSize(w:Number,h:Number){
		if(w + h > 0){
			heading_txt._width = w;
			var headH = Math.round(heading_txt._height) + headingspace;
			
			var pH = h - headH
			
			var gridNodeHraw:Number = pH / grid_rows;
			var gridNodeH:Number = Math.round(gridNodeHraw);
			
			var gridNodeWraw:Number = w / grid_cols;
			var gridNodeW:Number = Math.round(gridNodeWraw);
	
			for(var i = 0; i < thumbItems.length; i++){
				thumbItems[i].moveTo(Math.round(thumbItems[i].gridPosition.x * gridNodeWraw),Math.round(thumbItems[i].gridPosition.y * gridNodeHraw));
				thumbItems[i].setSize(Math.round(thumbItems[i].gridPosition.c * gridNodeWraw),Math.round(thumbItems[i].gridPosition.r * gridNodeHraw));
				
			}
			var content_h = Math.round(gridNodes.length * gridNodeHraw);
			var content_w = w;
			
			index_container._y =  headH
			pane_mc.setSize(w,h,content_w,content_h);
			pane_mc._y = gutter/2;
		}
		
	}
	
	public function onIndexRefresh(){
		pane_mc.resetPane();
	}
	
	
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