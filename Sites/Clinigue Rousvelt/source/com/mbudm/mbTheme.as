/*
com.mbudm.mbTheme.as 
extends MovieClip

Steve Roberts May 2009

Description
The mbTheme class:
	- mbInit instantiates mbTheme (passes theme node of init.xml)
	- creates a theme from a base colour (initXML.attributes.basecol) and creates a number (initXML.attributes.numcols) of tints/shades of the primary and composite colour - so 4 x the number specified in initXML.attributes.numcols
		- these can be used by the override class to specify colour of styles
		- these are stored in mbTheme for use anywhere in the template that has access to the instance of mbTheme
	- loads a css file into a StyleSheet object that will be applied to all TextFields
	
*/
import TextField.StyleSheet;
import MovieClip;

class com.mbudm.mbTheme extends Object{
	private var initXML:XMLNode;
	private var themeStyles:StyleSheet;
	private var ldr:MovieClip;
	private var basecol:Number; 
	private var numcols:Number; 
	private var tints:Array;
	private var shades:Array;
	private var compcol:Number;
	private var comptints:Array;
	private var compshades:Array;
	private var broadcaster:Object;
	
	
	function mbTheme(xD:XML,l:MovieClip) {
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
		
		initXML = xD;	
		ldr = l;
		
		themeStyles = new StyleSheet();
		if(initXML.attributes.basecol && initXML.attributes.numcols){
			createTheme();
		}
		if(initXML.attributes.url){
			var obj:Object = new Object();
			obj.url = initXML.attributes.url;
			obj.label = "Site CSS";
			obj.target = themeStyles;
			obj.onLoad = "onCSSLoaded";
			obj.onLoadTarget = this;
			obj.type = "css";
			obj.displayMode= 0;
			ldr.loadRequest(obj);
		}else{
			onCSSLoaded();
		}
	}
	public function addListener(obj:Object){
		broadcaster.addListener(obj);
	}
	private function createTheme(){
	
		basecol = Number(initXML.attributes.basecol);
		numcols = Number(initXML.attributes.numcols);
		compcol = Number(initXML.attributes.compcol);
		
		var invert:Boolean = initXML.attributes.invert == 1 ? true : false ;
		
		tints = new Array();
		shades = new Array();
			
		comptints = new Array();
		compshades = new Array();
	
		var tintType = invert ? "shade" : "tint" ;
		var shadeType = invert ? "tint" : "shade" ;
		
		for( var i = 0;i<numcols;i++){
			tints.push(makeCol(tintType,basecol,i));
			shades.push(makeCol(shadeType,basecol,i));
			
			comptints.push(makeCol(tintType,compcol,i));
			compshades.push(makeCol(shadeType,compcol,i));
			
		}
	}
	public function onCSSLoaded(){
	
		broadcaster.broadcastMessage("onThemeReady");
	}

	private function makeCol(colType:String,bC:Number,index:Number){
		var base:Array = convertHexToRGB(bC);
		var newCol:Array = new Array(base.length);
		index++;
		switch(colType){
			case "tint":
				for(var i=1;i<base.length;i++){
					newCol[i] = base[i] + ((255 - base[i])*index/numcols);
				}
			break;
			case "shade":
				for(var i=1;i<base.length;i++){
					newCol[i] = base[i] - ((base[i])*index/numcols);
				}
			break;
		}
		return convertRGBtoHex(newCol);
	}

	//takes an array of three numbers between 1 and 255 and returns them as the hex number
	private function convertRGBtoHex(argb_array:Array)
	{
		var argb = (argb_array[0] << 24) | (argb_array[1] << 16) | (argb_array[2] << 8) | argb_array[3];
		return argb;
	}

	//takes the hex number and returns an array of three numbers between 1 and 255
	private function convertHexToRGB(argb:Number)
	{
	
		var a:Number = (argb & 0xFF000000) >>> 24;
		var r:Number = (argb & 0x00FF0000) >>> 16;
		var g:Number = (argb & 0x0000FF00) >>> 8;
		var b:Number = argb & 0x000000FF;
		var	argb_array:Array = [a,r,g,b];
		return argb_array;
	}
	
	public function convertColorToHtmlColor(col:Number):String{
		var hcol:String = col.toString(16);
		while (hcol.length < 6){
			hcol = "0" + hcol;
		}
		hcol = "#" + hcol;
		return hcol;
	}
	
	public function getStyleColor(styleName:String,returnType:String):String{
		//returnType can be either "0x" or "#". "#" is assumed if no parameter is passed
		var returnStr:String;
		var stObj:Object  = styles.getStyle(styleName);
		if(stObj.color){
			if(returnType == "0x"){
				returnStr = "0x" + stObj.color.substr(1);
			}else{
				returnStr = stObj.color;
			}
		}
		//trace("getStyleColor styleName:"+styleName+ " stObj.color:"+stObj.color+" returnStr:"+returnStr);
		return returnStr
	}
	
	public function getNode(name:String,attname:String,attdata:String):XMLNode{
		var xNode:XMLNode;
		if(name != undefined){
			if(attname != undefined && attdata != undefined ){
				xNode = findNode(initXML,name,attname,attdata);
			}
			if(xNode== undefined){
				xNode = findNode(initXML,name);
			}
		}
		//if none found return undefined	
		return xNode;
	}
	
	// recursive node search
	private function findNode(n:XMLNode,name:String,attname:String,attdata:String):XMLNode{
		var xNode:XMLNode;
		if(n.hasChildNodes()){
			for(var i = 0; i < n.childNodes.length; i++){
				if(n.childNodes[i].nodeName == name){
					if(attname != undefined && attdata != undefined ){
						if(n.childNodes[i].attributes[attname] == attdata){
							
							xNode = n.childNodes[i];
						}
					}else{
						xNode = n.childNodes[i];
					}
				}
				if(xNode != undefined){
					break;
				}else if(n.childNodes[i].hasChildNodes()){
					xNode = findNode(n.childNodes[i],name,attname,attdata);
				}
			}
		}
		return xNode;
	}
	
	public function set styles(s:StyleSheet){
		themeStyles = s;
	}
	public function get styles():StyleSheet{
		return themeStyles;
	}
	
	public function get baseColor():Number{
		return basecol;
	}
	public function get compColor():Number{
		return compcol;
	}
	public function get baseTints():Array{
		return tints;
	}
	public function get baseShades():Array{
		return shades;
	}
	public function get compTints():Array{
		return comptints;
	}
	public function get compShades():Array{
		return compshades;
	}
}