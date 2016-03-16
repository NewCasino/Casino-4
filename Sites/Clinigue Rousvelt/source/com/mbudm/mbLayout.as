/*
com.mbudm.mbLayout.as 
extends MovieClip

Steve Roberts June 2009

Description
The mbLayout class:
	- mbInit instantiates mbLayout (passes layout node of init.xml)
	- listens to the onResize event from stage
	- calculates layout dimensions on each resize
	- accessed by visual classes that need to know the layout dimensions
	- core dimensions (those referenced by name in ths class)
		Required:
			marginleft
			marginright
			margintop
			marginbottom
		Optional:
			fixedwidth
			fixedheight
			minwidth
			maxwidth
			minheight
			maxheight
	
	- custom dimensions are simply passed through (converted to number if they are a number) and so are stil accessible to other classes via getDimension()
*/

class com.mbudm.mbLayout extends Object{
	private var layoutXML:XMLNode;
	private var broadcaster:Object;
	private var dim:Object; // dimensions
	private var la:Object;  //shortcut to attributes
	
	function mbLayout(lX:XML) {
		broadcaster = new Object();
		AsBroadcaster.initialize(broadcaster);
		
		dim = new Object({indentleft:0,indentright:0,indenttop:0,indentbottom:0});
		
		layoutXML = lX;	
		/* Eg of layout node
		 <layout marginleft="0.05" marginright="0.05" margintop="30" marginbottom="50" fixedwidth="800" navpos="l"  gutter="20" navwidth="160"  />
		 */
		
		//shortcut to atributes
		la = layoutXML.attributes;
		
		//fail safe  -ensure required params exist - and put in a default if not
		la.marginleft = la.marginleft ? la.marginleft : 0.1 ;
		la.marginright = la.marginright ? la.marginright : 0.1 ;
		la.margintop = la.margintop ? la.margintop : 0.1 ;
		la.marginbottom = la.marginbottom ? la.marginbottom : 0.1 ;
		
		onResize();
	}
	public function addListener(obj:Object){
		broadcaster.addListener(obj);
	}
	private function calculateDim(w:Number,h:Number){
		dim.w = w;
		dim.h = h;
		
		var aData:String; // XML attributes are always strings
		var aNum:Number; //shortcut for aData converted to Number
		
		var fixedWidth:Number = Number(la.fixedwidth);
		var fixedHeight:Number = Number(la.fixedheight);
		
		var minWidth:Number = la.minwidth ? Number(la.minwidth) : 0 ;
		var minHeight:Number = la.minheight ? Number(la.minheight) : 0 ;
		
		var maxWidth:Number = Number(la.maxwidth);
		var maxHeight:Number = Number(la.maxheight);
		
		for(var a in la){
			aData = la[a];
			switch(a){
				case "marginleft":
				case "marginright":
				case "margintop":
				case "marginbottom":
					// convert to number
					aNum = Number(aData);
					switch(a){
						case "marginleft":
						case "marginright":
							if(isNaN(fixedWidth)){
								var aNumIdeal = convertToValue(aNum,dim.w);
								var aNumMin = convertToValue(aNum,minWidth);
								aNum = Math.max(aNumIdeal,aNumMin);
							}else{
								var aNumIdeal = Math.floor((dim.w - fixedWidth) / 2);
								var aNumMin = convertToValue(aNum,fixedWidth);
								aNum =  Math.max(aNumIdeal,aNumMin);
							}		
						break;
						case "margintop":
						case "marginbottom":
							if(isNaN(fixedHeight)){
								var aNumIdeal = convertToValue(aNum,dim.h);
								var aNumMin = convertToValue(aNum,minHeight);
								aNum = Math.max(aNumIdeal,aNumMin);
							}else{
								var aNumIdeal = Math.floor((dim.h - fixedHeight) / 2);
								var aNumMin = convertToValue(aNum,fixedHeight);
								aNum =  Math.max(aNumIdeal,aNumMin);
							}
						break;
					}
					aNum = Math.max(aNum,0);
					dim[a] = aNum;
				break;
				default:
					// convert to number if poss otherwise leave as a String
					dim[a] = isNaN(Number(aData)) ? aData : Number(aData) ;
				break;
			}
		}
		
		dim.sitewidth = isNaN(fixedWidth) ? dim.w - dim.marginleft - dim.marginright : fixedWidth ;
		dim.siteheight = isNaN(fixedHeight) ? dim.h - dim.margintop - dim.marginbottom : fixedHeight ;
		
		
		//width
		if(isNaN(fixedWidth)){
			if(!isNaN(dim.minwidth)){
				if(dim.sitewidth < dim.minwidth){
					dim.sitewidth = dim.minwidth;
					dim.w = dim.sitewidth + dim.marginleft + dim.marginright;
			
				}
			}
			if(!isNaN(dim.maxwidth)){
				if(dim.sitewidth > dim.maxwidth){
					var hdiff = dim.sitewidth - dim.maxwidth;
					dim.sitewidth = dim.maxwidth;
					//add extra space to the margins
					dim.marginleft = dim.marginleft + Math.floor(hdiff/2);
					dim.marginright = dim.marginright + Math.ceil(hdiff/2);
				}
			}
		}else{
			dim.w = dim.sitewidth + dim.marginleft + dim.marginright;
		}
		
		//height
		if(isNaN(fixedHeight)){
			if(!isNaN(dim.minheight)){
				if(dim.siteheight < dim.minheight){
					dim.siteheight = dim.minheight;
					dim.h = dim.siteheight + dim.margintop + dim.marginbottom;
				}
			}
			if(!isNaN(dim.maxwidth)){
				if(dim.siteheight > dim.maxheight){
					var vdiff = dim.siteheight - dim.maxheight;
					dim.siteheight = dim.maxheight;
					//add extra space to the margins
					dim.margintop = dim.margintop + Math.floor(vdiff/2);
					dim.marginbottom = dim.marginbottom + Math.ceil(vdiff/2);
				}
			}
		}else{
			dim.h = dim.siteheight + dim.margintop + dim.marginbottom;
		}
		
		//round numbers for all
		for(var p in dim){
			if(!isNaN(dim[p])){
				dim[p] = Math.round(dim[p]);
			}
		}
		
		//trace("mbL w:"+dim.w+" h:"+dim.h+" stGw:"+dim.stagewidth+" stGh:"+dim.stageheight+" mt:"+dim.margintop+" mb:"+dim.marginbottom+" ml:"+dim.marginleft+" mr:"+dim.marginright+" sitew:"+dim.sitewidth+" siteh:"+dim.siteheight+" ib:"+dim.indentbottom+" ir:"+dim.indentright);
		
	}
	
	private function convertToValue(part:Number,whole:Number):Number{
		return part > 0 && part < 1 ? part * whole : part ;
	}
	
	//listens to Stage
	public function onResize(){
		dim.stagewidth = Stage.width;
		dim.stageheight = Stage.height;
		calculateDim(dim.stagewidth,dim.stageheight);
		broadcaster.broadcastMessage("onResize");
	}
	
	//listens to Stage
	public function onFullScreen(){
		broadcaster.broadcastMessage("onFullScreen");
	}
	
	public function setDimensions(obj:Object){
		for(var p in dim){
			if(!isNaN(obj[p])){
				dim[p] = obj[p];
			}
		}
		onResize();
	}
	
	//return value can be a string or a number depending on what the dimension is
	public function getDimension(dimension:String){
		return dim[dimension];
	}
}