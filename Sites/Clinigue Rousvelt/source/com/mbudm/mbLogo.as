/*
com.mbudm.mbLogo.as 
extends MovieClip

Steve Roberts May 2009

Description
mbLogo is a base for whatever graphical logo is created in the extended class
It instantiates the theme, the index, the loader and the logo and layout init xml. It listens to the onResize broadcast, and calls the setUpLogo and setSize methods, so that the extending class can create and update the graphical elements that make up the logo
		
*/

import com.mbudm.mbTheme;
import com.mbudm.mbIndex;
import com.mbudm.mbLayout;

class com.mbudm.mbLogo extends MovieClip{
	private var logoInitXML:XMLNode; 
	private var theme:mbTheme;
	private var index:mbIndex;
	private var ldr:MovieClip;
	private var layout:mbLayout;
	private var tController:MovieClip;
	
	function mbLogo(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init(lx:XMLNode,ld:MovieClip,t:mbTheme,lyt:mbLayout,ind:mbIndex,tC:MovieClip) {
	
		logoInitXML = lx;
		
		theme = t;
		ldr = ld;
		layout = lyt;
		index = ind;
		
		tController = tC;
		
		setUpLogo();
		
		onResize();
	}
		
	
	public function onResize(){
	
		setSize();
		
		
	}
	
	//override functions
	
	private function setUpLogo(){
		
	}
	
	public function setSize(w:Number,h:Number){
		
	}
	
}