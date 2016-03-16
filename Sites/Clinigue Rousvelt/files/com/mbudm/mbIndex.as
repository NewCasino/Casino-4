// ActionScript Document

class com.mbudm.mbIndex extends MovieClip{
	private var indexXML:XML;
	private var ids:Object;
	private var currentCoord:String;
	private var currentNode:XMLNode;
	private var broadcaster:Object;
	private var __enabled:Boolean;
	
	function mbIndex(iX:XML) {
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
		
		indexXML = iX;
		ids = new Object();
		createIDs();
		this.enabled = true;
	}
	
	//public methods
	
	//candidate for base class?
	public function addListener(obj:Object){
		broadcaster.addListener(obj);
	}
	public function getItemAt(c:String):XMLNode{
		var coord:String = c.length == 0 ? "0,0" :"0,"+c; //add leading 0 - references the root node
		var cNode:XMLNode;
		if(coord == currentCoord){
			cNode = currentNode;
		}else{
			var cArr = validateCoord(coord);
			if(cArr){
				cNode = findNode(cArr);
			}
		}
		return cNode;
	}
	public function getCoordForID(i:String):String{
		return ids[i];
	}
	
	public function getNodeType(c:String):String{
		var cNode = c != undefined ? getItemAt(c) : currentNode ;
		var nodeType:String;
		if(cNode.nodeName == "page"){
			nodeType = cNode.attributes.type;
		}else{
			nodeType = cNode.nodeName;
		}
		return nodeType;
	}
	

	public function get currentIndex():String{
		var stripRootZero:String = currentCoord.substr(currentCoord.indexOf(",")+1);
		//trace("get currentIndex   currentCoord:"+ currentCoord +" stripRootZero:"+stripRootZero);
		return stripRootZero;
	}
	public function set currentIndex(c:String) {
		if(__enabled){
			var coord:String = c.length == 0 ? "0,0" :"0,"+c; //add leading 0 - references the root node
			//trace("set currentIndex   c:"+ c +" coord:"+coord);
			
			if(coord != currentCoord){
				var newNode = getItemAt(c); //using public function so use the strippedRoot zero coord
				if(newNode){
					if(newNode.attributes.url || newNode.attributes.fullsrc){
						currentCoord = coord;
						currentNode = newNode;
						broadcastIndexUpdate();
					}else if (newNode.hasChildNodes()){
						currentIndex = c + ",0"; //use the firstChild instead.. again using public function so use the strippedRoot zero coord
					}else{
						trace("Nav request failed: the coord requested:"+coord+" has no url and no children.");
					}
				}else{
					trace("Nav request failed: the coord requested:"+coord+" is not valid.");
				}
			}else{
				//broadcast refresh
				broadcastIndexRefresh();
			}
		}
	}
	public function validateID(id:String):Boolean{
		return ids[id] != undefined ? true : false ;
	}
	
	public function set currentID(id:String){
		if(__enabled){
			if(validateID(id)){
				currentIndex = ids[id];
			}else{
				trace("Nav request failed: the id requested:"+id+" could not be found.");
			}
		}
	}
	
	// URLs - combination of coordinates and IDs
	// if the current coord has any ancestors with an id, then the url uses the ancestor ids to creat a path:
	// eg /products/0/1/ is the same as /0/3/0/1 where /0/3 is the coord for the products page.
	// if the current coord has an id then it is used as the path, plus any ancestor coords with ids preceding
	// eg /products/product-name/ where the page product-name is at coord  0/3/0/1 and the page 'products' is at /0/3/ AND the page at /0/3/0 does not have an id attribute
	
	public function get currentURL():String{
		var urlStr:String = "";
		var urlSegments:Array =  new Array();
		var currCoordArr:Array = currentCoord.split(",");
		var ancestor:String;
		
		for(var i = 1; i < currCoordArr.length ; i++){ //start at 1 because internal coords always have the 0 root node preceding
			var arr:Array = currCoordArr.slice(0,(i+1));
			ancestor = findNode(arr).attributes.id;
			
			if(ancestor != undefined){
				urlSegments.push({type:"id",content:"/"+ancestor});
			}else{
				if(urlSegments[urlSegments.length - 1].type != "content"){ //includes case where -1 is undefined - ie the first instance
					urlSegments.push({type:"coords",content:""});
				}
				urlSegments[urlSegments.length - 1].content += "/"+currCoordArr[i];
			}
		}
			
		if(urlSegments.length > 1){
			for(var i = 0; i < urlSegments.length; i++){
				if(urlSegments[i].type == "id" || urlSegments[i+1].type != "id"){
					urlStr += urlSegments[i].content;
				}
			}
		}else{
			urlStr = urlSegments[0].content;
		}
		
		if(urlStr == "/0"){
			urlStr = "";
		}
		
		return urlStr;
	}
	
	public function set currentURL(url:String){
		url = url == "/" ? "/0" : url ;
		var urlArr:Array = url.substr(1,url.length-1).split("/");
		var coord:String = "";
		
		for(var i = 0; i < urlArr.length; i++){
			if(isNaN(urlArr[i])){
				// meant to be an id
				if(validateID(urlArr[i])){
					//the coord for the id overrides anything before it because ids must be unique
					coord = String(ids[urlArr[i]]);
				}else{
					trace("Nav request failed: the url:"+url+" contains an id:"+urlArr[i]+" that could not be found.");
					break;
				}
			}else{
				if(coord.length > 0){
					coord += ","+ urlArr[i];
				}else{
					coord += urlArr[i]; // do not append root node 0 because this will set the public property currentIndex
				}
			}
		}
		currentIndex = coord;
	}
	
	public function get currentID():String{
		return currentNode.attributes.id;
	}
	
	public function set enabled(b:Boolean){
		__enabled = b;
	}
	
	public function get enabled():Boolean{
		return __enabled;
	}
	
	public function doExternalURL(url,window,method){
		
		//trace("index doExternalURL url:"+url+" window:"+window+" method:"+method);
		
		if(url && window && method){
			this.getURL(url,window,method); // sole reason for having index class extend MovieClip - global getURL fails if you try to pass the method parameter - doh!
		}else if(url && window){
			getURL(url,window);
		}else if(url){
			getURL(url);
		}
	}
	
	//private methods
	
	private function broadcastIndexUpdate(){
		if(getNodeType() == "url"){
			doExternalURL(currentNode.attributes.url,currentNode.attributes.window,currentNode.attributes.mode);
		}else{
			broadcaster.broadcastMessage("onIndexUpdate");
		}
	}
	
	private function broadcastIndexRefresh(){
		if(getNodeType() != "url"){
			broadcaster.broadcastMessage("onIndexRefresh");
		}
	}
	
	public function broadcastIndexContentReady(){
		if(getNodeType() != "url"){
			broadcaster.broadcastMessage("onIndexContentReady");
		}
	}
	
	private function createIDs(cNode:XMLNode,coord:String){
		//parse the index once and store any ids with ref to the node coord for easy lookup later
		if(cNode == undefined){
			var cNode:XMLNode = indexXML.firstChild;
			var coord:String = "";
		}
		var id:String;
		var c:String;
		//trace("cNode.childNodes.length:"+cNode.childNodes.length);
		
		for(var i = 0;i<cNode.childNodes.length;i++){
			c = coord.length == 0 ? i :coord +","+i;
			//trace(c + " id: "+cNode.childNodes[i].attributes.id+ " hC:"+cNode.childNodes[i].hasChildNodes());
			if(cNode.childNodes[i].attributes.id){
				id = cNode.childNodes[i].attributes.id
				ids[id] = c;
			}
			//cNode = cNode.childNodes[cArr[i]];
			if(cNode.childNodes[i].hasChildNodes()){
				createIDs(cNode.childNodes[i],c);
			}
		}
		/**/
		
	}
	
	
	private function validateCoord(coord:String):Array{
	//	trace("validateCoord: "+coord);
		var cArr:Array = coord.split(",");
		var isValid = true;
		//check that each array item is a number and greater than 0
		
		for(var i = 0;i<cArr.length;i++){
			if(isNaN(cArr[i]) || cArr[i] < 0){
			//	trace("validateCoord isNaN(cArr["+i+"]): "+isNaN(cArr[i])+" || cArr["+i+"]:"+cArr[i] +"< 0");
				isValid = false;
				break;
			}
		}
		//trace("validateCoord isValid: "+isValid);
		if(isValid){
			return cArr;
		}else{
			return undefined;
		}
	}
	
	private function findNode(cArr:Array):XMLNode{
		var cNode:XMLNode = indexXML;
		
		for(var i = 0;i<cArr.length;i++){
			cNode = cNode.childNodes[cArr[i]];
		}
		/**/
		return cNode;
	}
	
	public function get siteTitle():String{
		
		return indexXML.firstChild.attributes.title;
	}
}