/*
com.mbudm.mbFooter.as 
extends MovieClip

Steve Roberts May 2009

Description
mbFooter is a base for whatever graphical footer is created in the extended class
It instantiates the theme, the loader and the footer and layout init xml. It listens to the onResize broadcast, and calls the setUpFooter and setSize methods, so that the extending class can create and update the graphical elements that make up the footer
		
*/

import com.mbudm.mbTheme;
import com.mbudm.mbIndex;
import com.mbudm.mbLayout;

class com.mbudm.mbFooter extends MovieClip{
	private var footerXML:XMLNode;
	private var layout:mbLayout;
	private var index:mbIndex;
	private var theme:mbTheme;
	private var ldr:MovieClip;
	private var tController:MovieClip;
	
	function mbFooter(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init(fx:XMLNode,l:MovieClip,t:mbTheme,lyt:mbLayout,ind:mbIndex,tC:MovieClip) {
		
		
		footerXML = fx;
		layout = lyt;
		
		theme = t;
		ldr = l;
		
		index = ind;
		
		tController = tC;
		
		setUpFooter();
		
		onResize();
	}

	
	//override functions
	
	private function setUpFooter(){
		
	}
	
	
	public function onResize(){

	}
	
}