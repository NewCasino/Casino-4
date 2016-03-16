package com.littlefilms {
	
	/**
	 * ...
	 * @author Michael Pavlov (mihpavlov@gmail.com)
	 */
	public class ColorScheme {
		
		//background colors
		public static var contactUsBG:int;
		public static var whatWeDoBG:int;
		public static var whoWeAreBG:int;
		public static var creditsPaneBG:int;
		public static var clientsPaneBG:int;
		public static var workProjectPaneBG:int;
		public static var workPaneBG:int;
		
		public static var animationPreloader:int;
		
		//text colors
		public static var footerNavItem:int;
		public static var footerNavItemHover:int;
		public static var defaultNavItem:int;
		public static var defaultNavItemHover:int;
		public static var leftNavItem:int;
		public static var leftNavItemHover:int;
		public static var contentBlockHeader:int;
		public static var contentBlockCopy:int;
		public static var teamThumbName:int;
		public static var teamThumbTitle:int;
		public static var teamMemberTitle:int;
		public static var workToggleHighlight:int;
		
		public static var workNavItemHover:int;
		public static var workNavItem:int;
		
		public static var workGalleryThumbText:int;
		public static var workGalleryThumbTextHover:int;
		public static var workGalleryThumbBG:int;
		public static var workGalleryThumbBGHover:int;
		
		public static var workProjectHeader:int;
		public static var workProjectSubHeader:int;
		public static var workProjectCopy:int;
		public static var contactUsCopy:int;
		public static var ourClientsHeader:int;
		public static var ourClientsCopy:int;
		
		public static var projectPhotoLabelText:int;
		public static var projectPhotoLabelTextHover:int;
		public static var projectPhotoLabelBG:int;
		public static var projectPhotoLabelBGHover:int;
		
		public static var creditsThumbText:int;
		public static var creditsThumbTextHover:int;
		public static var creditsThumbBG:int;
		public static var creditsThumbBGHover:int;
		
		public static var closeText:int;
		public static var closeTextHover:int;
		public static var closeBG:int;
		public static var closeBGHover:int;
		
		public static var maximizeButton:int;
		public static var maximizeButtonHover:int;
		
		public static function parseColors(data:XML):void {
			var colors:XMLList = data.color
			for each (var item:XML in colors) {
				var id:String = item.@id;				
				ColorScheme[id] = item.@hex;
			}
		}
	}
	
}