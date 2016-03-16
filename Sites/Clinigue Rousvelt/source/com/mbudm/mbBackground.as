/*
com.mbudm.mbBackground.as 
extends MovieClip

Steve Roberts May 2009

Description
mbBackground is a base for whatever graphical background is created in the extended class
It instantiates the theme, the tController, and the loader. It listens to the onResize and onIndexUpdate broadcasts, and calls the updateBackground and setSize methods, so that the extending class can create and update the graphical elements that make up the background
		
*/
import com.mbudm.mbIndex;
import com.mbudm.mbTheme;
import com.mbudm.mbLayout;
import com.mbudm.mbTransitionController;

class com.mbudm.mbBackground extends MovieClip{
	private var indexNode:XMLNode; 
	private var index:mbIndex
	private var theme:mbTheme;
	private var ldr:MovieClip;
	private var backgroundXML:XMLNode;
	private var layout:mbLayout;

	private var tController:mbTransitionController;
	
	function mbBackground(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init(ind:mbIndex,l:MovieClip,t:mbTheme,tC:mbTransitionController,bX:XMLNode,lyt:mbLayout) {
		index = ind;
		theme = t;
		ldr = l;
		tController = tC;
		layout = lyt;
		
		backgroundXML = bX;
		
		setupBackground();
		
		onResize();
	}
	
	public function onIndexUpdate(){
		indexNode = index.getItemAt(index.currentIndex);
		updateBackground();
	}
	
	//override functions
	
	private function setupBackground(){
	}
	
	public function onResize(){
		
	}
	
	private function updateBackground(){
		
	}
	
}