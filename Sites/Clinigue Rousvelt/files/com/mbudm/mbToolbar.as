/*
com.mbudm.mb.mbToolbar.as 
extends MovieClip

Steve Roberts August 2009

Description
mbToolbar is a holder for various buttons

	
*/
import com.mbudm.mbTheme;
import com.mbudm.mbIndex;
import com.mbudm.mbLayout;

class com.mbudm.mbToolbar extends MovieClip{
	private var toolbarInitXML:XMLNode; 
	private var theme:mbTheme;
	private var index:mbIndex;
	private var ldr:MovieClip;
	private var layout:mbLayout;
	
	function mbToolbar(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init(Tx:XMLNode,ld:MovieClip,t:mbTheme,lyt:mbLayout,ind:mbIndex) {
	
		toolbarInitXML = Tx;
		
		theme = t;
		ldr = ld;
		layout = lyt;
		index = ind;
		
		setUpToolbar();
		
		onResize();
	}
		
	
	public function onResize(){
	
		setSize();
		
		
	}
	
	//override functions
	
	private function setUpToolbar(){
		
	}
	
	public function setSize(w:Number,h:Number){
		
	}
	
}