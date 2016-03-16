/*
com.mbudm.mb.mbIndexModule.as 
extends MovieClip

Steve Roberts June 2009

Description
mbIndexModule is a page module that prsents a series of thumbnails according to a specified grid.
The grid can be any number of rows and columns
Custom thumbnails can be position at any grid coordinate and can be any amount of rows or columns in width and height
Automatic thumbnails are made for each item that is a child of this node in the index
- unless the node is already created as a custom thumbnail
- Non functional text thumbnails can aslo be added - these do not hav a coord so do not link to a page.

Standard module tasks, such as handling page layout and relaying load requests to the mbLoader instance are also included in this class.
	
*/
import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import com.mbudm.mbLoader;

class com.mbudm.mbIndexModule extends MovieClip{
	private var indexNode:XMLNode; 
	private var indexCoord:String;
	private var index:mbIndex;
	private var pageXML:XML; 
	private var pageXMLobj:Object;
	private var theme:mbTheme;
	private var ldr:mbLoader;
	
	private var index_container:MovieClip;
	private var index_mc:MovieClip;
	private var pane_mc:MovieClip;
	
	private var thumbItems:Array;
	private var grid_cols:Number;
	private var grid_rows:Number;
	private var gridNodes:Array;
	
	private var gutter:Number;
		
	private var startTrigger:Boolean;
	private var contentReady:Boolean;
	
	private var callbackObject:Object;
	
	private var thumbItemStatus:Array;// when all items are closed or opened then the index module can do the callback to mbContent
	private var reservedThumbs:Array; // list of thumbs that have reserved a spot on the grid, stores a ref to the grid childnode
	
	private var toolTip:MovieClip;
	
	function mbIndexModule(){
		// this class is designed to be extended so the constructur is left empty

	}
	
	public function init(pX:XML,ind:mbIndex,iC:String,t:mbTheme,l:mbLoader,tT:MovieClip) {
		
		pageXMLobj = new Object();
		index = ind;
		indexCoord = iC;
		indexNode = index.getItemAt(indexCoord);
		
		
		// Hijack another index's children using the attribute usecoord or useid
		if(indexNode.attributes.usecoord || indexNode.attributes.useid){
			var newCoord = indexNode.attributes.useid ? index.getCoordForID(indexNode.attributes.useid) : indexNode.attributes.usecoord ;
			var newIndexNode = index.getItemAt(newCoord);
			if(newIndexNode != undefined){
				indexNode = newIndexNode;
				indexCoord = newCoord;
			}
		}
		
		pageXML = pX;
		
		theme = t;
		ldr = l;
		
		toolTip = tT;
		
		thumbItems = new Array();
		
		
		//'objectify' the nodes for easy access  
		for(var i = 0; i < pageXML.firstChild.childNodes.length;i++){
			var nodeName  = pageXML.firstChild.childNodes[i].nodeName;
			pageXMLobj[nodeName] = pageXML.firstChild.childNodes[i];
		}
		
		gutter = pageXMLobj.grid.attributes.gutter != undefined ? Number(pageXMLobj.grid.attributes.gutter) : 10 ;
		
		grid_cols = pageXMLobj.grid.attributes.cols != undefined ? Number(pageXMLobj.grid.attributes.cols) : 4 ;
		grid_rows = pageXMLobj.grid.attributes.rows != undefined ? Number(pageXMLobj.grid.attributes.rows) : 3 ;
		
		gridNodes = new Array();
		
		for(var i = 0; i < grid_rows; i++){
			var arr:Array = new Array(grid_cols);
			gridNodes.push(arr);
		}
		
		
		// index_mc and pane_mc
		index_container = this.createEmptyMovieClip("index_container",this.getNextHighestDepth());// groups the pane and the index so they can be positioned if necessary
		index_mc = index_container.createEmptyMovieClip("index_mc",index_container.getNextHighestDepth()); // the holder of all the thumbnails
		pane_mc = index_container.attachMovie("mbScrollPaneSymbol","pane_mc",index_container.getNextHighestDepth());
		
		
		reservedThumbs =  new Array();
	
		//create shortcuts to thumbnails in the grid XMLNode that have an id "Custom thumbnails"
		var thumbsCustomXML:Object = new Object();
		for(var i = 0; i < pageXMLobj.grid.childNodes.length;i++){
			var coord;
			var node;
			if(pageXMLobj.grid.childNodes[i].attributes.id){
				thumbsCustomXML[pageXMLobj.grid.childNodes[i].attributes.id] = pageXMLobj.grid.childNodes[i];
				coord = index.getCoordForID(pageXMLobj.grid.childNodes[i].attributes.id);
				node = index.getItemAt(coord);
			}
			var lvl = index_mc.getNextHighestDepth();
			var thumb_mc = index_mc.attachMovie("mbThumbnailSymbol","thumb"+lvl,lvl);
			thumb_mc.init(index,theme,ldr,toolTip,pageXMLobj.grid.childNodes[i],gutter,node,coord);
			thumbItems.push(thumb_mc);
			
			//reserve the spaces in gridNodes for the custom thumbnails
			var c = Number(pageXMLobj.grid.childNodes[i].attributes.cols);
			var r = Number(pageXMLobj.grid.childNodes[i].attributes.rows);
			var x = Number(pageXMLobj.grid.childNodes[i].attributes.x);
			var y = Number(pageXMLobj.grid.childNodes[i].attributes.y);
			
			// a grid position object must have columns, rows, x and y
			if((c + r + x + y) > 0){
				for(var row = y; row < (y + r); row++){
					for(var col = x; col < (x + c); col++){
						gridNodes[row][col] = "custom_"+i;
					}
				}
				reservedThumbs.push(pageXMLobj.grid.childNodes[i]);
			}
		}
	
		
		//create thumbs from the remaining site index items
		var coordStr:String;
		var customNode:XMLNode;
		for(var i = 0; i < indexNode.childNodes.length; i++){
			if(thumbsCustomXML[indexNode.childNodes[i].attributes.id] == undefined){
				coordStr = indexCoord.length == 0 ? i : indexCoord + "," + i;
				var lvl = index_mc.getNextHighestDepth();
				var thumb_mc = index_mc.attachMovie("mbThumbnailSymbol","thumb"+lvl,lvl);
				thumb_mc.init(index,theme,ldr,toolTip,undefined,gutter,indexNode.childNodes[i],coordStr);
				thumbItems.push(thumb_mc);
			}
		}
		
		//assign grid location to all thumbs that do not have one set
		
		//first make a list of the available spots - all the grid coordinates that are not occupied (or covered) by a custom thumbnail
		var AvailGridPositions:Array = new Array();
		for(var row = 0; row < grid_rows; row++){
			for(var col = 0; col < grid_cols; col++){
				if(gridNodes[row][col] == undefined){
					var idStr = "auto_"+(AvailGridPositions.length + 1);
					// a grid position object must have columns, rows, x and y
					var obj:Object = new Object({c:1,r:1,x:col,y:row,id:idStr});
					//it's available
					AvailGridPositions.push(obj);
					gridNodes[row][col] = "auto_"+ (AvailGridPositions.length);
				}
			}
			if(AvailGridPositions.length >= thumbItems.length){
				break;
			}
		}
		
		//Have we run out of grid spots - do we need overflow? add more rows (they'll become subsequent 'pages');
		if(AvailGridPositions.length < thumbItems.length){
			var extraItems = thumbItems.length - reservedThumbs.length - AvailGridPositions.length;
			var extraRows = Math.ceil(extraItems/grid_cols);
			for(var i = 0; i < extraRows; i++){
				var arr:Array = new Array(grid_cols);
				gridNodes.push(arr);
				var row = gridNodes.length - 1;
				for(var col = 0; col< grid_cols; col++){
					var idStr = "auto_"+(AvailGridPositions.length + 1);
					// a grid position object must have columns, rows, x and y
					var obj:Object = new Object({c:1,r:1,x:col,y:row,id:idStr});
					AvailGridPositions.push(obj);
					gridNodes[row][col] = "auto_"+ (AvailGridPositions.length);
				}
			}
		}
		
		// array for monitoring opened/closed status of the thumbnails
		thumbItemStatus = new Array(thumbItems.length);
		
		var availID = 0;
		for(var i = 0; i < thumbItems.length;i++){
			if(thumbItems[i].gridPosition == undefined){
				//find next available grid
				thumbItems[i].gridPosition = AvailGridPositions[availID];
				availID++;
			}
		}
	
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
			for(var i = 0; i< thumbItems.length ;i++){
				thumbItems[i].close({target:this,onComplete:"onThumbnailClosed",param:i});
			}
		}
	}
	
	// when a thumbnail closes it is identified and it's status is updated
	public function onThumbnailClosed(i:Number){
		thumbItemStatus[i] = false;
		if(callbackObject != undefined){
			var allFalse:Boolean = true;
			for(var i = 0; i< thumbItems.length ;i++){
				if(thumbItemStatus[i]){
					allFalse = false;
					break;
				}
			}
			if(allFalse){
				doCallBack();
			}
		}
	}
	
	// when a thumbnail opens it is identified and it's status is updated
	public function onThumbnailOpen(i:Number){
		thumbItemStatus[i] = true;
		if(callbackObject != undefined){
			var allTrue:Boolean = true;
			for(var i = 0; i< thumbItems.length ;i++){
				if(!thumbItemStatus[i]){
					allTrue = false;
					break;
				}
			}
			if(allTrue){
				doCallBack();
			}
		}
	}
	
	private function doCallBack(){
		if(callbackObject != undefined){
			callbackObject.target[callbackObject.onComplete](callbackObject.param);
		}
	}
	
	private function startModule(){
		if(startTrigger && contentReady){
			setupPane();
			for(var i = 0; i< thumbItems.length ;i++){
				thumbItems[i].open({target:this,onComplete:"onThumbnailOpen",param:i});
			}
			onModuleStarted();
		}
	}
	
	private function setupPane(){
		pane_mc.init(index_mc,"pagination",theme);	
	}
	
	//override functions
	
	private function onModuleStarted(){
		
	}
	
	public function setSize(w:Number,h:Number){
		
	}
	
	private function setupModule(){
	}
}