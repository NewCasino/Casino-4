package com.littlefilms
{
    import flash.text.*;

    public class TextFormatter extends Object
    {
        private static var _brown:Number = 5648413;
        private static var _mediumBrown:Number = 10061429;
        private static var _lightBrown:Number = 8483677;
        private static var _white:Number = 16777215;
        private static var _orange:Number = 15156246;
        private static var _darkGray:Number = 3551021;
        private static var _lfHelveticaNeue:Font = new LFHelveticaNeue();
        private static var _lfMayaSamuelsExtraLight:Font = new LFMayaSamuelsExtraLight();
        private static var _lfMayaSamuelsLight:Font = new LFMayaSamuelsLight();
        private static var _footerNavItem:TextFormat;
        private static var _leftNavItem:TextFormat;
        private static var _contentBlockHeader:TextFormat;
        private static var _contentBlockCopy:TextFormat;
        private static var _teamThumbName:TextFormat;
        private static var _teamThumbTitle:TextFormat;
        private static var _teamMemberTitle:TextFormat;
        private static var _workToggleHighlight:TextFormat;
        private static var _workGalleryThumb:TextFormat;
        private static var _workProjectHeader:TextFormat;
        private static var _workProjectSubHeader:TextFormat;
        private static var _workProjectCopy:TextFormat;
        private static var _contactUsCopy:TextFormat;
        private static var _ourClientsHeader:TextFormat;
        private static var _ourClientsCopy:TextFormat;

        public function TextFormatter()
        {
            return;
        }// end function

        public static function setTextFormats()
        {
            _footerNavItem = new TextFormat();
            _footerNavItem.color = _lightBrown;
            _footerNavItem.font = _lfMayaSamuelsLight.fontName;
            _footerNavItem.size = 10;
            _leftNavItem = new TextFormat();
            _leftNavItem.color = _lightBrown;
            _leftNavItem.font = _lfMayaSamuelsExtraLight.fontName;
            _leftNavItem.size = 18;
            _contentBlockHeader = new TextFormat();
            _contentBlockHeader.color = _brown;
            _contentBlockHeader.font = _lfMayaSamuelsExtraLight.fontName;
            _contentBlockHeader.size = 42;
            _contentBlockCopy = new TextFormat();
            _contentBlockCopy.color = _lightBrown;
            _contentBlockCopy.font = _lfHelveticaNeue.fontName;
            _contentBlockCopy.size = 12;
            _contentBlockCopy.leading = 0;
            _teamThumbName = new TextFormat();
            _teamThumbName.color = _orange;
            _teamThumbName.font = _lfMayaSamuelsExtraLight.fontName;
            _teamThumbName.size = 18;
            _teamThumbTitle = new TextFormat();
            _teamThumbTitle.color = _lightBrown;
            _teamThumbTitle.font = _lfMayaSamuelsLight.fontName;
            _teamThumbTitle.size = 10;
            _teamMemberTitle = new TextFormat();
            _teamMemberTitle.color = _orange;
            _teamMemberTitle.font = _lfMayaSamuelsExtraLight.fontName;
            _teamMemberTitle.size = 18;
            _workToggleHighlight = new TextFormat();
            _workToggleHighlight.color = _orange;
            _workToggleHighlight.font = _lfHelveticaNeue.fontName;
            _workToggleHighlight.size = 12;
            _workToggleHighlight.leading = 0;
            _workGalleryThumb = new TextFormat();
            _workGalleryThumb.color = _white;
            _workGalleryThumb.font = _lfHelveticaNeue.fontName;
            _workGalleryThumb.size = 10;
            _workProjectHeader = new TextFormat();
            _workProjectHeader.color = _darkGray;
            _workProjectHeader.font = _lfMayaSamuelsExtraLight.fontName;
            _workProjectHeader.size = 32;
            _workProjectSubHeader = new TextFormat();
            _workProjectSubHeader.color = _orange;
            _workProjectSubHeader.font = _lfMayaSamuelsExtraLight.fontName;
            _workProjectSubHeader.size = 18;
            _workProjectCopy = new TextFormat();
            _workProjectCopy.color = _mediumBrown;
            _workProjectCopy.font = _lfHelveticaNeue.fontName;
            _workProjectCopy.size = 12;
            _workProjectCopy.leading = 0;
            _contactUsCopy = new TextFormat();
            _contactUsCopy.color = _brown;
            _contactUsCopy.font = _lfMayaSamuelsExtraLight.fontName;
            _contactUsCopy.size = 18;
            _contactUsCopy.leading = 0;
            _ourClientsHeader = new TextFormat();
            _ourClientsHeader.color = _darkGray;
            _ourClientsHeader.font = _lfMayaSamuelsExtraLight.fontName;
            _ourClientsHeader.size = 42;
            _ourClientsCopy = new TextFormat();
            _ourClientsCopy.color = _lightBrown;
            _ourClientsCopy.font = _lfHelveticaNeue.fontName;
            _ourClientsCopy.size = 12;
            _ourClientsCopy.leading = 0;
            return;
        }// end function

        public static function getTextFmt(param1:String) : TextFormat
        {
            var _loc_2:TextFormat = null;
            if (TextFormatter[param1] == null)
            {
                trace("Error: invalid text format requested ... " + param1);
                _loc_2 = TextFormatter["_landingCopyBlock"];
            }
            else
            {
                _loc_2 = TextFormatter[param1];
            }
            return _loc_2;
        }// end function

        public static function getColor(param1:String) : Number
        {
            var _loc_2:Number = NaN;
            if (TextFormatter[param1] == null)
            {
                trace("Error: invalid text format requested ... " + param1);
                _loc_2 = TextFormatter["_brown"];
            }
            else
            {
                _loc_2 = TextFormatter[param1];
            }
            return _loc_2;
        }// end function

    }
}
