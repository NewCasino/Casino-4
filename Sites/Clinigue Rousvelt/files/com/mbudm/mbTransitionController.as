/*
com.mbudm.mb.mbTransitionController.as 
extends MovieClip

Steve Roberts May 2009

Description
This class manages the order of transistions when an onIndexUpdate occurs

Note, this sytem relies on classes that call requestTransition, following this up with a call to either cancelTransition() or TransitionComplete()

*/ 

import com.mbudm.mbIndex;

class com.mbudm.mbTransitionController extends MovieClip{
	private var requests:Array;
	private var idCounter:Number;
	private var processing:Boolean;
	private var events:Array;
	private var eventID:Number;
	private var newEventWindow:Boolean;
	private var _interval:Number;
	private var index:mbIndex;
	
	function mbTransitionController(){
		requests = new Array;
		events = new Array;
		events.push("Startup"); // any transistions that are requested before the first onIndexUpdate are simply let through in the order they come in
		idCounter = 0;
		eventID = 0;
		requests.push([]);
		
	}
	
	public function setIndex(i:mbIndex){
		index = i;
	}
	public function onIndexUpdate(){
		index.enabled = false;
		eventID++;
		events.push("onIndexUpdate");
		requests.push([]);
		
		
		processing = false; // no need to wait for callbacks on old events
		newEventWindow = true;
		if(_interval){
			clearInterval(this._interval);
			this._interval == undefined;
		}
		this._interval = setInterval(this,"onInterval",500);
	}
	private function onInterval(){
		newEventWindow = false;
		clearInterval(this._interval);
		this._interval == undefined;
		processNextRequest();
	}
	
	public function requestTransition(m:MovieClip,t:String,cB:String,tid:String){
		requests[eventID].push({id:tid,mc:m,type:t,callback:cB});
		var i:Number = requests[eventID].length - 1;
		sortRequests();
	}
	
	public function cancelTransition(id:String){
		var cancelled:Boolean = false;
		for(var i = 0; i< requests[eventID].length;i++){
			if(requests[eventID][i].id == id){
				requests[eventID].splice(i,1);
				cancelled = true;
				break;
			}
		}
		if(cancelled){
			sortRequests();
		}
	}
	
	public function transitionComplete(id:String){
		
		cancelTransition(id);
		
	}
	
	private function processNextRequest(){
		if(!newEventWindow){
			if(requests[eventID].length > 0){
				if(!requests[eventID][0].processing){
					requests[eventID][0].processing = true;
					requests[eventID][0].mc[requests[eventID][0].callback](requests[eventID][0].id);
				}
			}else{
				index.enabled = true;
			}
		}
	}
	
	// Override function
	private function sortRequests(){
		// mandatory to include this
		processNextRequest();
	}
	/* original min example - now moved to extended class 
	//potentially an override function as the order may change for different templates
	private function sortRequests(){
	
		//call this at some stage
		//processNextRequest();
		
		switch(events[eventID]){
			case "onIndexUpdate":
			
				//onIndexUpdate rules
				// 1. destroy - called by content items
				// 2. nav - close (deepest first)
				// 3. nav - open (shallowest first)
				// 4. create - called by content item
				// 5. background 
				// 6. unknown items 
				
				// add two properties to each index
				// - typePriority:	 the rule number for the event type
				// - depth:			 length of nav item mc, 0 for anything other than nav items
				var typePriority:Number;
				var depth:Number;
				for(var i = 0; i< requests[eventID].length;i++){
					if(requests[eventID][i].mc._name.substr(0,3) == "nav"){
						depth = requests[eventID][i].mc.toString().length;
					}else{
						depth = 0;
					}
					switch(requests[eventID][i].type){
						case "destroy":
							typePriority = 1;
						break;
						case "create":
							typePriority = 4;
						break;
						case "open":
							typePriority = 3;
						break;
						case "close":
							typePriority = 2;
						break;
						default:
							if(requests[eventID][i].mc._name =="bg"){
								typePriority = 5;
							}else{
								typePriority = 6;
							}
						break;
					}
					requests[eventID][i].typePriority = typePriority;
					requests[eventID][i].depth = depth;
				}
				
				requests[eventID].sortOn(["typePriority", "depth" ]);
				
			break;
			case "Startup":
			default:
				//Startup rules
				// - for now no sorting required
		
			break;
		}
	
		processNextRequest();
	}
	*/
}