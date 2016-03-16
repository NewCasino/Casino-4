/*

mbTableOfContents - Actionscript 2

v1.0 created by Steve Roberts March 2009
v1.1 May 2009 fixed bug related to very long strings. Need to cater for additional accumulated html added by flash
v1.2 May 2009 renamed class to be included in mbudm template structure, changed t_txtField property to use the t_txtBox instance of the mbTextBox class, as well as using htxt property over htmlText.


Description
This class scans a given string of html text for marked up headings and produces an array of objects that contain the string of the heading text as well as it's start point and end point in the string. This information can then be used to create a Table of Contents list of buttons that when clicked will use the in built AS2 Selection class to jump to the relevant point in the text.

For more information see the inline notes below.

*/

class com.mbudm.mbTableOfContents extends Object{

	private var t_txt:String;
	private var t_txtBox:MovieClip;
	private var t_tag:String;
	private var t_marker:String;
	private var t_toc_list:Array;
	private var startpos:Number;
	private var strsearch:Boolean;
	private var broadcaster:Object;
	private var TOCListReady:Boolean;

	/* Constructor, this method takes 4 parameters, 
		txt  -  the html formatted text that the table of contents list is required for
	    txtField - the textField that will hold the html formatted text
		tag - the tag that is being used to denote which bits of the text are headings
		marker - a string of characters that is used to mark the location of each heading
	*/
	
	function mbTableOfContents(){
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
				
	}
	
	function init(txt:String,txtBox:MovieClip,tag:String,marker:String) {
		// setup vars and objects
		t_txt = txt;
		t_txtBox = txtBox;
		t_tag = tag;
		t_marker = marker;
		t_toc_list =[];
		TOCListReady = false;
		
		//start the process
		createTOC();
	}
	
	public function getTOC():Array{
		return t_toc_list;
	}
	
	public function addListener(obj:Object){
		broadcaster.addListener(obj);
		if(TOCListReady){
			broadcastTOCListReady();
		}
	}
	
	private function broadcastTOCListReady(){
		broadcaster.broadcastMessage("onTOCListReady");
	}
	
	private function createTOC(){
		var startpos:Number = 0;
		var strsearch:Boolean = true;
		// first run to get the labels
		// any text surrounded by a start and end tag is stored for tabel of contents use
		while(strsearch){
			var itemStart = t_txt.indexOf("<"+t_tag+">",startpos);
			var itemEnd = t_txt.indexOf("</"+t_tag+">",itemStart);
			var itemLabel = t_txt.substring((itemStart+(t_tag.length+2)),itemEnd);
		
			if(itemStart == -1 || itemEnd == -1){
				// there are no more possible headings so end the while loop
				strsearch = false;
			}else{
				// a heading has been found so it is added to the list
				t_toc_list.push({start:itemStart,end:itemEnd,label:itemLabel});
				var str1 = t_txt.slice(0,itemStart);
				var str2 = t_txt.slice(itemStart);
				t_txt = str1 + t_marker + str2;
				
			}
			startpos = itemEnd + t_marker.length;
			
		}
	
		t_txtBox.htxt = t_txt;
	
		// second run
		// we have to cycle through again as htmlText adds extra html formatting code
		// so the position of the strings change
		// however because we have 'marked' the points in the text we can find the strings again 
		// without mistakenly findng a string which is not a heading
		
		t_txt = t_txtBox.txt;
		
		startpos = 0;
		var html_startpos:Number = 0;
		var itemStart:Number;
		var itemEnd:Number;
		var htmlStart:Number;
		var htmlEnd:Number;
		var str1:Number;
		var str2:Number;
		for(var i = 0;i< t_toc_list.length;i++){
			itemStart = t_txt.indexOf(t_marker,startpos) - (i * t_marker.length);
			itemEnd = itemStart + t_toc_list[i].label.length;
			
			t_toc_list[i].start = itemStart;
			t_toc_list[i].end = itemEnd;
			
			startpos = itemEnd + (i * 3); // padding to cater for extra html flash junk..long story
			
			//remove the t_marker from the textField
			
			htmlStart = t_txtBox.htxt.indexOf(t_marker,html_startpos);
			htmlEnd = htmlStart + t_marker.length;
			str1 = t_txtBox.htxt.slice(0, htmlStart);
			str2 = t_txtBox.htxt.slice(htmlEnd);
	
			// the string before and after the t_marker is put back into the textField
			t_txtBox.htxt = str1 + str2;
		}
		
		TOCListReady = true;
		broadcastTOCListReady();
	}
}