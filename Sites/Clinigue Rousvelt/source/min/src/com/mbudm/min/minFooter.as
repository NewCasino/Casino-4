// ActionScript Document

class com.mbudm.min.minFooter extends com.mbudm.mbFooter{
	/* com.mbudm.mbFooter vars
	private var footerXML:XMLNode; 
	private var layout:mbLayout;
	
	private var theme:mbTheme;
	private var ldr:MovieClip;
	*/
	
	private var bg:MovieClip;
	private var label:TextField;
	private var aligntocontent:Boolean;
	
	function minFooter(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	//override functions
	
	private function setUpFooter(){
		aligntocontent = footerXML.attributes.aligntocontent == 1 ? true : false;
		
		var bgalpha = footerXML.attributes.bgalpha ? Number(footerXML.attributes.bgalpha) : 80;
		
		this.createEmptyMovieClip("bg",this.getNextHighestDepth());
		
		//check for the override
		var fc = Number(theme.getStyleColor("._footerBackground","0x"));
		if(isNaN(fc))
			fc = theme.compShades[theme.compShades.length - 1];

		drawRect (bg, 200, 20, fc, bgalpha);
		
		this.createTextField("label",this.getNextHighestDepth(),0,0,200,20);
		label.autoSize = false;
		label.html = true;
		
		var labelStyle = theme.styles.getStyle(".footer");
		
		//If the font is preceded with __ then it is assumed to be an embedded font
		if(labelStyle.fontFamily.substr(0,2) == "__"){
			label.embedFonts = true;
		}
		
		//if it is centered then change to left but set the autosize to true;
		if(labelStyle.textAlign == "center"){
			label.autoSize = true;
		}
		
		if(!labelStyle.color){
			labelStyle.color = theme.convertColorToHtmlColor(theme.compTints[theme.compTints.length-1]);
			theme.styles.setStyle(".footer",labelStyle);
		}
		
		label.styleSheet = theme.styles;
		label.htmlText = "<span class=\"footer\" >" + footerXML.toString() + "</span>";
		label.updateMenu = this.updateMenu;
	}
	
	private function updateMenu():Void {
		
	}
	
	public function onResize(){
		var w:Number = layout.getDimension("w");
		var h:Number = layout.getDimension("h");
		
		// - order is like css Top, right, bottom , left
		var padding:Array = footerXML.attributes.padding ? footerXML.attributes.padding.split(",") : [2,20,2,20];
		
		var flW:Number;
		var cIndent:Number;
		if(aligntocontent){
			var cIndent:Number = layout.getDimension("marginleft");
			flW = w - cIndent - layout.getDimension("marginright");
		}else{
			flW = w;
			cIndent = 0;
		}
		
		// convert padding values to pixels if they are fractions - order is like css Top, right, bottom , left
		// also gives us a chance to convert the values from xml into numbers
		var dimension:Number;
		for(var i = 0 ; i < padding.length; i++){
			dimension = i == 0 || i == 2 ? label._height : flW ;
			padding[i] = padding[i] > 0 && padding[i] < 1 ? Number(padding[i]) * dimension : Number(padding[i]) ;
		}
		var fH = label._height + padding[0] + padding[2];
		
		this.bg._width = w;
		
		if(!label.autoSize){
			this.label._width = Math.round(flW - padding[1] - padding[3]);
			this.label._x = Math.round(cIndent + padding[1]);
		}else{
			
			var xOffset = (flW - this.label._width) /2;
			this.label._x = Math.round(cIndent + xOffset);
		}
		
		
		this.bg._height = fH;
		
		this.label._y = Math.round(padding[0]);
		
		this._y = Math.ceil(h - fH);
		
	}
	
	private function drawRect (mc:MovieClip, w:Number, h:Number, col:Number, a:Number) {
		var alpha:Number = a == undefined ? 100 : a ;
		if(mc){
		//	trace("drawRect (mc:"+mc+", w:"+w+", h:"+h+", col:"+col+", a:"+a);
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
	
}