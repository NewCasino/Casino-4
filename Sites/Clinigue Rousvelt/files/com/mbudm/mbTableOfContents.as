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
	private var t_toc_chapters:Array;
	private var startpos:Number;
	private var strsearch:Boolean;
	private var broadcaster:Object;
	private var TOCListReady:Boolean;

	/* Constructor, this method takes 2 parameters, 
		txt  -  the html formatted text that the table of contents list is required for
		tag - the tag that is being used to denote which bits of the text are headings
	*/
	
	function mbTableOfContents(){
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
				
	}
	
	function init(txt:String,tag:String) {
		// setup vars and objects
		t_txt = txt;
		//t_txtBox = txtBox;
		t_tag = tag;
		//t_marker = marker;
		t_toc_list =[];
		t_toc_chapters = [];
		TOCListReady = false;
		
		//start the process
		createTOC();
	}
	
	public function getTOC():Array{
		return t_toc_list;
	}
	
	public function getChapters():Array{
		return t_toc_chapters;
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
		var chapterStart = 0;
		var chapterEnd = 0;
		var chapter_str:String;
		var strsearch:Boolean = true;
		// first run to get the labels
		// any text surrounded by a start and end tag is stored for tabel of contents use
		while(strsearch){
			var itemStart = t_txt.indexOf("<"+t_tag+">",startpos);
			var itemEnd = t_txt.indexOf("</"+t_tag+">",itemStart);
			var itemLabel = t_txt.substring((itemStart+(t_tag.length+2)),itemEnd);
		
			if(itemStart == -1 || itemEnd == -1){
				//store last chapter
				chapterEnd = t_txt.length - 1;
				if(chapterEnd > chapterStart){
					chapter_str = t_txt.substring(chapterStart,chapterEnd);
					t_toc_chapters.push(chapter_str);
				}
				// there are no more possible headings so end the while loop
				strsearch = false;
			}else{
				//t_txt = str1 + str2+ t_marker + str2;
				//chapter
				//if(t_toc_list.length == 0 && itemStart > chapterStart){
				// first chapter - content before the first heading
				chapterEnd = itemStart;
				if(chapterEnd > chapterStart){
					chapter_str = t_txt.substring(chapterStart,chapterEnd);
					//trace("chapter_str.length:"+chapter_str.length);
					if(!allWhitespace(chapter_str)){
						t_toc_chapters.push(chapter_str);
						chapterStart = chapterEnd;
						chapterEnd = chapterStart;
					}
				}
				//}
				// a heading has been found so it is added to the list
				t_toc_list.push({chapter:t_toc_chapters.length,label:itemLabel});
				var str1 = t_txt.slice(0,itemStart);
				var str2 = t_txt.slice(itemStart);
				
				
			}
			startpos = itemEnd;
			
		}
	
		TOCListReady = true;
		broadcastTOCListReady();
	}
	
	private function allWhitespace(str:String):Boolean{
		var allWhite = true;
		for(var i = 0; i < str.length; i++){
			if(str.charCodeAt(i) > 20){
				allWhite = false;
			}
		}
		return allWhite;
	}
}