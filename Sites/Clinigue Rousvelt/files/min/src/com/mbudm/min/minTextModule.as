
/*
com.mbudm.min.minTextModule.as 
extends com.mbudm.mbTextModule

Steve Roberts May 2009

Description
The minTextModule class creates the heading for the page, and instantiates the TOC menu.
It also listens to onResize, which it uses to layout the heading, txtBox_mc and TOC menu.
 
*/

class com.mbudm.min.minTextModule extends com.mbudm.mbTextModule{
	/* com.mbudm.mbTextModule vars
	private var indexNode:XMLNode; 
	private var pageXML:XML; 
	private var pageXMLobj:Object;
	private var txtBox_mc:MovieClip;
	private var toc:mbTableOfContents;
	private var toc_list:Array;
	private var theme:mbTheme;
	private var toc_enabled:Boolean;
	private var pageContent:String
	*/
	private var heading_txt:TextField;
	private var headingspace:Number = 0; // the vspace between the heading and the textBox_mc
	private var toc_mc:MovieClip;
	private var toc_w:Number = 0;
	private var toc_margin:Number = 0;
	
	function minTextModule(){
	}
	
	private function createHeading(){
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
		
	private function createTOCmenu(){
		toc_w = Number(pageXMLobj.toc.attributes.width);
		toc_margin = Number(pageXMLobj.toc.attributes.margin);
		this.attachMovie("minTocMenuSymbol","toc_mc",this.getNextHighestDepth());
		toc_mc._visible = false;
	
		toc_mc.init(toc_list,pageXMLobj.toc,theme,this,"tocLink");
		
	}
	public function tocLink(c:Number){
		var chapter = c;
		txtBox_mc.setChapter(c);
		toc_mc.setSelected(c);
	}
	
	public function onChapterSelected(cS:Number){
		toc_mc.setSelected(cS);
	}
	
	private function onModuleStarted(){
		toc_mc._visible = true;
		heading_txt._visible = true;
	}
	
	public function onIndexRefresh(){
		txtBox_mc.reset();
	}
	
	public function setSize(w:Number,h:Number){
		if(toc_enabled){
			heading_txt._width = w - toc_w - toc_margin;
			var headH = Math.round(heading_txt._height) + headingspace;
			var txtH = Math.round(h - headH);
			txtBox_mc.setSize((w - toc_w - toc_margin),txtH);
			txtBox_mc._y = headH;
			toc_mc.setHeight(txtH);
			switch(pageXMLobj.toc.attributes.halign){
				case "right":
					toc_mc._x = w - toc_w;
					txtBox_mc._x = 0;
					heading_txt._x = 0;
				break;
				default:
					// left is default
					toc_mc._x = 0;
					txtBox_mc._x = toc_w + toc_margin;
					heading_txt._x = toc_w + toc_margin;
				break;
			}
			switch(pageXMLobj.toc.attributes.valign){
				case "middle":
					toc_mc._y = Math.round((h - toc_mc._height)/2);
				break;
				case "bottom":
					toc_mc._y = Math.round(h - toc_mc._height);
				break;
				default:
					// top is default
					toc_mc._y = headH - toc_mc.headingHeight; // 
				break;
			}
		}else{
			heading_txt._width = w;
			var headH = Math.round(heading_txt._height) + headingspace;
			var txtH = Math.round(h - headH);
			txtBox_mc.setSize(w,txtH);
			txtBox_mc._y = headH;
		}
	}
}