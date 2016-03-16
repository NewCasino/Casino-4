/*
com.mbudm.min.minTransitionController.as 
extends com.mbudm.mbTransitionController

Steve Roberts August 2009

Description
minTransitionController provides the template specific sorting rules for transitions
 
*/

class com.mbudm.min.minTransitionController extends com.mbudm.mbTransitionController{
	/* com.mbudm.mbTransitionController vars
	private var requests:Array;
	private var idCounter:Number;
	private var processing:Boolean;
	private var events:Array;
	private var eventID:Number;
	private var newEventWindow:Boolean;
	private var _interval:Number;
	
	*/

	
	function minTransitionController(){
	}
	
	private function sortRequests(){
		
		//call this at some stage
		//processNextRequest();
		
		switch(events[eventID]){
			case "onIndexUpdate":
			
				//onIndexUpdate rules
				// 1. disappear - called by sibling nav (or any item that needs to clear out before the content does
				// 2. destroy - called by content items
				// 3. nav - close (deepest first)
				// 4. nav - open (shallowest first)
				// 5. create - called by content item
				// 6. appear - sibling nav (or any item that needs to display after the content is created
				// 7. background 
				// 8. unknown items 
				
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
						case "disappear":
							typePriority = 1;
						break;
						case "appear":
							typePriority = 6;
						break;
						case "destroy":
							typePriority = 2;
						break;
						case "create":
							typePriority = 5;
						break;
						case "open":
							typePriority = 4;
						break;
						case "close":
							typePriority = 3;
						break;
						default:
							if(requests[eventID][i].mc._name =="bg"){
								typePriority = 7;
							}else{
								typePriority = 8;
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
		/*
		for(var i = 0; i < requests.length; i++ ){
			if(i == eventID){
				trace("eventID:"+i+" - "+requests[i]);
				for(var j = 0; j < requests[i].length ; j++ ){
					trace("  - "+j+" "+requests[i][j].id);
				}
			}
		}
		
		*/
		processNextRequest();
	}
}