package com.littlefilms {
	import flash.text.*;

	public class TextFormatter extends Object {
		public static  const _brown:int = 0xff0000;//5648413;
		public static  const _mediumBrown:int = 0xffff00;//10061429;
		public static  const _lightBrown:int = 0xff00ff;//8483677;
		public static  const _white:int = 0x00ff00;//16777215;
		public static  const _orange:int = 0x00ffff;//15156246;
		public static  const _darkGray:int = 0x0000ff;//0x1b1b1b;
		public static  const _mediumGray:int = 0x555555;//0x5f5f5f;		
		public static  const _yellow:int = 0xaaaaaa;//0xffd800;
		public static  const _lightGray:int = 0xffffff;//0xcccccc;
		private static  var _lfHelveticaNeue:Font = new LFHelveticaNeue();
		private static  var _lfMayaSamuelsExtraLight:Font = new LFMayaSamuelsExtraLight();
		private static  var _lfMayaSamuelsLight:Font = new LFMayaSamuelsLight();
		private static  var _footerNavItem:TextFormat;
		private static  var _leftNavItem:TextFormat;
		private static  var _contentBlockHeader:TextFormat;
		private static  var _contentBlockCopy:TextFormat;
		private static  var _teamThumbName:TextFormat;
		private static  var _teamThumbTitle:TextFormat;
		private static  var _teamMemberTitle:TextFormat;
		private static  var _workDescriptionToggleHighlight:TextFormat;
		private static  var _workGalleryThumb:TextFormat;
		private static  var _workProjectHeader:TextFormat;
		private static  var _workProjectSubHeader:TextFormat;
		private static  var _workProjectCopy:TextFormat;
		private static  var _contactUsCopy:TextFormat;
		private static  var _ourClientsHeader:TextFormat;
		private static  var _ourClientsCopy:TextFormat;

		public function TextFormatter() {
			
		}

		public static function setTextFormats() {
			_footerNavItem = new TextFormat();
			_footerNavItem.color = ColorScheme.footerNavItem;
			_footerNavItem.font = _lfMayaSamuelsLight.fontName;
			_footerNavItem.size = 10;
			_leftNavItem = new TextFormat();
			_leftNavItem.color = ColorScheme.leftNavItem;
			_leftNavItem.font = _lfMayaSamuelsExtraLight.fontName;
			_leftNavItem.size = 18;
			_contentBlockHeader = new TextFormat();
			_contentBlockHeader.color = ColorScheme.contentBlockHeader;
			_contentBlockHeader.font = _lfMayaSamuelsExtraLight.fontName;
			_contentBlockHeader.size = 42;
			_contentBlockCopy = new TextFormat();
			_contentBlockCopy.color = ColorScheme.contentBlockCopy;
			_contentBlockCopy.font = _lfHelveticaNeue.fontName;
			_contentBlockCopy.size = 12;
			_contentBlockCopy.leading = 0;
			_teamThumbName = new TextFormat();
			_teamThumbName.color = ColorScheme.teamThumbName;
			_teamThumbName.font = _lfMayaSamuelsExtraLight.fontName;
			_teamThumbName.size = 18;
			_teamThumbTitle = new TextFormat();
			_teamThumbTitle.color = ColorScheme.teamThumbTitle;
			_teamThumbTitle.font = _lfMayaSamuelsLight.fontName;
			_teamThumbTitle.size = 10;
			_teamMemberTitle = new TextFormat();
			_teamMemberTitle.color = ColorScheme.teamMemberTitle;
			_teamMemberTitle.font = _lfMayaSamuelsExtraLight.fontName;
			_teamMemberTitle.size = 18;
			_workDescriptionToggleHighlight = new TextFormat();
			_workDescriptionToggleHighlight.color = ColorScheme.workToggleHighlight;
			_workDescriptionToggleHighlight.font = _lfHelveticaNeue.fontName;
			_workDescriptionToggleHighlight.size = 12;
			_workDescriptionToggleHighlight.leading = 0;
			_workGalleryThumb = new TextFormat();
			_workGalleryThumb.color = ColorScheme.workGalleryThumbText;
			_workGalleryThumb.font = _lfHelveticaNeue.fontName;
			_workGalleryThumb.size = 10;
			_workProjectHeader = new TextFormat();
			_workProjectHeader.color = ColorScheme.workProjectHeader;
			_workProjectHeader.font = _lfMayaSamuelsExtraLight.fontName;
			_workProjectHeader.size = 32;
			_workProjectSubHeader = new TextFormat();
			_workProjectSubHeader.color = ColorScheme.workProjectSubHeader;
			_workProjectSubHeader.font = _lfMayaSamuelsExtraLight.fontName;
			_workProjectSubHeader.size = 18;
			_workProjectCopy = new TextFormat();
			_workProjectCopy.color = ColorScheme.workProjectCopy;
			_workProjectCopy.font = _lfHelveticaNeue.fontName;
			_workProjectCopy.size = 12;
			_workProjectCopy.leading = 0;
			_contactUsCopy = new TextFormat();
			_contactUsCopy.color = ColorScheme.contactUsCopy;
			_contactUsCopy.font = _lfMayaSamuelsExtraLight.fontName;
			_contactUsCopy.size = 18;
			_contactUsCopy.leading = 0;
			_ourClientsHeader = new TextFormat();
			_ourClientsHeader.color = ColorScheme.ourClientsHeader;
			_ourClientsHeader.font = _lfMayaSamuelsExtraLight.fontName;
			_ourClientsHeader.size = 42;
			_ourClientsCopy = new TextFormat();
			_ourClientsCopy.color = ColorScheme.ourClientsCopy;
			_ourClientsCopy.font = _lfHelveticaNeue.fontName;
			_ourClientsCopy.size = 12;
			_ourClientsCopy.leading = 0;			
		}

		public static function getTextFmt(param1:String):TextFormat {
			var _loc_2:TextFormat;
			if (TextFormatter[param1] == null) {
				trace("Error: invalid text format requested ... " + param1);
				_loc_2 = TextFormatter["_landingCopyBlock"];
			} else {
				_loc_2 = TextFormatter[param1];
			}
			return _loc_2;
		}

		public static function getColor(param1:String):int {
			var color:int;
			if (TextFormatter[param1] == null) {
				trace("Error: invalid text format requested ... " + param1);
				color = TextFormatter["_brown"];
			} else {
				color = TextFormatter[param1];
			}
			return color;
		}

	}
}