// ActionScript Document

class com.mbudm.min.minLogo extends com.mbudm.mbLogo{
	/* com.mbudm.mbLogo vars
	private var logoInitXML:XMLNode; 
	private var layout:mbLayout;
	private var theme:mbTheme;
	private var ldr:MovieClip;
	
	private var w:Number;
	private var h:Number;
	*/
	
	private var logo_mc:MovieClip;
	private var xoffset:Number;
	private var yoffset:Number;
	private var logowidth:Number;
	private var hitArea:MovieClip;
		
	function minLogo(){
	
	}
	
	//override functions
	
	private function setUpLogo(){
		this._visible = false;
		
		this.createEmptyMovieClip("hitArea",this.getNextHighestDepth());
		
		this.createEmptyMovieClip("logo_mc",this.getNextHighestDepth());
										
		var type = logoInitXML.attributes.url.substr(logoInitXML.attributes.url.lastIndexOf(".")+1);
		//trace("type:"+type);
		var obj:Object = new Object();
		obj.url = logoInitXML.attributes.url;
		obj.label = logoInitXML.attributes.url + " (logo)";
		obj.target = this.logo_mc;
		obj.onLoad = "onLogoLoaded";
		obj.onLoadTarget = this;
		obj.type = type;
		ldr.loadRequest(obj);
		
		xoffset = logoInitXML.attributes.xoffset ? Number(logoInitXML.attributes.xoffset) : 0;
		yoffset = logoInitXML.attributes.yoffset ? Number(logoInitXML.attributes.yoffset) : 0;
		
		logowidth = logoInitXML.attributes.logowidth ? Number(logoInitXML.attributes.logowidth) : 100;

	}
	

		
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number, a:Number) {
		var alpha:Number = a == undefined ? 100 : a ;
		if(mc){
			with(mc){
				clear();
				beginFill(col, alpha);
				moveTo(0, 0);
				lineTo(w, 0);
				lineTo(w, h);
				lineTo(0, h);
				lineTo(0, 0);
				endFill();
			}
		}
	}
	
	
	public function onLogoLoaded(o:Object){
		var themeRequired:Boolean = logoInitXML.attributes.theme == 1 ? true : false ;
		if(themeRequired){
			//primary color and the comp color
			o.target.setTheme(theme.baseColor,theme.compColor);
		}
		o.target._width = logowidth;
		o.target._yscale = o.target._xscale;
		
		setSize();
		
		drawRect(hitArea,logowidth,o.target._height,0xFFFFFF,0);
		this.hitArea.onRelease = function(){
			this._parent.index.currentIndex = 0;
		}
		this._visible = true;
		
	}
	
	public function setSize(){

		this._x = layout.getDimension("marginleft") + xoffset;
		this._y = layout.getDimension("margintop") + yoffset;
		
		//trace("minLogo this._x:"+this._x+" = ml:"+ml+" + xoffset:"+xoffset+" this._y:"+this._y+" = mt:"+mt+" + yoffset:"+yoffset);
		
	}
	
}