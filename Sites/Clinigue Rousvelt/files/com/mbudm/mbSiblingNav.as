/*
com.mbudm.mbSiblingNav.as 
extends MovieClip

Steve Roberts July 2009

Description
mbSiblingNav is a base for whatever graphical sibling navigation is created in the extended class
It instantiates the theme, the loader and the sibling nav and layout init xml. It listens to the onResize broadcast, and calls the setUpFooter and setSize methods, so that the extending class can create and update the graphical elements that make up the sibling nav
		
*/

import com.mbudm.mbTheme;
import com.mbudm.mbIndex;
import com.mbudm.mbLayout;
import com.mbudm.mbTransitionController;

class com.mbudm.mbSiblingNav extends MovieClip{
	private var siblingnavXML:XMLNode;
	private var layout:mbLayout;
	private var index:mbIndex;
	private var theme:mbTheme;
	private var ldr:MovieClip;
	
	private var tController:mbTransitionController;
	
	function mbSiblingNav(){
		// this class is designed to be extended so the constructur is left empty
	}
	
	public function init(sx:XMLNode,l:MovieClip,t:mbTheme,lyt:mbLayout,ind:mbIndex,tC:mbTransitionController) {
		
		
		siblingnavXML = sx;
		layout = lyt;
		
		theme = t;
		ldr = l;
		
		index = ind;
		
		tController = tC;
		
		setUpSiblingNav();
		
		onResize();
	}

	
	//override functions
	
	private function setUpSiblingNav(){
		
	}
	
	
	public function onResize(){

	}
	
}