package 
{
    import Main.*;
    import com.littlefilms.*;
    import com.stimuli.loading.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    import gs.easing.*;

    public class Main extends MovieClip
    {
        private var _logo:LittleFilmsLogo;
        private var _bgManager:BGManager;
        private var _footer:FooterUI;
        private var _reelLink:ReelLink;
        private var _testPane:ContentPane;
        private var _activated:Boolean = false;
        private var _stageWidth:uint;
        private var _stageHeight:uint;
        private var _headerHeight:Number;
        private var _footerHeight:Number;
        private var _allNavHeight:Number;
        public var contentManager:ContentManager;
        public var paneManager:PaneManager;
        public var sequencer:Sequencer;
        private static const LOGO_FOOTER_WIDTH:uint = 70;
        private static const FOOTER_NAV_BUFFER:uint = 30;
        private static const REEL_LINK_Y_BUFFER:uint = 110;

        public function Main() : void
        {
            addFrameScript(0, frame1);
            trace("Main::Main()");
            TextFormatter.setTextFormats();
            if (stage)
            {
                init();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
            }
            return;
        }// end function

        private function init(event:Event = null) : void
        {
            trace("Main::init()");
            removeEventListener(Event.ADDED_TO_STAGE, init);
            sequencer = new Sequencer();
            sequencer.registerMain(this);
            _bgManager = BGManager.getInstance(this);
            _bgManager.name = "bgManager";
            addChild(_bgManager);
            _reelLink = new ReelLink();
            _reelLink.registerMain(this);
            if (contentManager != null)
            {
                _reelLink.init(contentManager.contentXML.homeReel[0]);
            }
            addChild(_reelLink);
            paneManager = new PaneManager();
            paneManager.registerMain(this);
            addChild(paneManager);
            _footer = FooterUI.getInstance(this);
            addChild(_footer);
            _logo = new LittleFilmsLogo();
            _logo.buttonMode = true;
            _logo.mouseEnabled = true;
            _logo.mouseChildren = false;
            _logo.name = "_logo";
            _logo.width = LOGO_FOOTER_WIDTH;
            _logo.scaleY = _logo.scaleX;
            _logo.addEventListener(MouseEvent.MOUSE_OVER, logoOverHandler, false, 0, true);
            _logo.addEventListener(MouseEvent.MOUSE_OUT, logoOutHandler, false, 0, true);
            _logo.addEventListener(MouseEvent.CLICK, logoClickHandler, false, 0, true);
            addChild(_logo);
            _footerHeight = _footer.height;
            _allNavHeight = _headerHeight + _footerHeight;
            return;
        }// end function

        public function prepContent(param1:XML, param2:XML, param3:XML, param4:BulkLoader) : void
        {
            contentManager = new ContentManager(param1, param2, param3, param4);
            contentManager.name = "contentManager";
            contentManager.registerMain(this);
            addChild(contentManager);
            return;
        }// end function

        public function revealInterface() : void
        {
            _activated = true;
            var _loc_1:* = _stageHeight - _footerHeight + 1;
            var _loc_2:* = _stageHeight - _footer.bg.height / 2 - _logo.height / 2;
            var _loc_3:* = _stageWidth;
            _reelLink.y = _loc_1 - REEL_LINK_Y_BUFFER;
            TweenMax.to(_footer, 0.5, {y:_loc_1, ease:Expo.easeInOut});
            TweenMax.to(_logo, 0.5, {y:_loc_2, ease:Expo.easeInOut});
            TweenMax.to(_reelLink, 0.5, {x:_loc_3, ease:Expo.easeInOut});
            _bgManager.init();
            _bgManager.addChildAt(getChildByName("introMessaging"), 1);
            _bgManager.addChildAt(_reelLink, 1);
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            _stageWidth = param1;
            _stageHeight = param2;
            _bgManager.setSize(param1, param2);
            _footer.setSize(param1, 0);
            paneManager.setSize(param1, param2);
            _logo.x = FOOTER_NAV_BUFFER;
            if (_activated)
            {
                _footer.y = param2 - _footerHeight + 1;
                _logo.y = param2 - _footer.bg.height / 2 - _logo.height / 2;
                _reelLink.x = param1;
                _reelLink.y = _footer.y - REEL_LINK_Y_BUFFER;
            }
            else
            {
                _footer.y = param2;
                _logo.y = param2 - _footer.bg.height / 2 - _logo.height / 2 + _footerHeight;
                _reelLink.x = param1 + 22;
                _reelLink.y = _footer.y - REEL_LINK_Y_BUFFER;
            }
            return;
        }// end function

        protected function logoOverHandler(event:MouseEvent) : void
        {
            TweenMax.to(event.target, 0.2, {tint:16777215, ease:Expo.easeInOut});
            return;
        }// end function

        protected function logoOutHandler(event:MouseEvent) : void
        {
            TweenMax.to(event.target, 0.2, {removeTint:true, ease:Expo.easeInOut});
            return;
        }// end function

        protected function logoClickHandler(event:MouseEvent) : void
        {
            sequencer.changeSection("none", "");
            footer.swapNav(null);
            return;
        }// end function

        public function get bgManager() : BGManager
        {
            return _bgManager;
        }// end function

        public function set bgManager(param1:BGManager) : void
        {
            if (param1 !== _bgManager)
            {
                _bgManager = param1;
            }
            return;
        }// end function

        public function get footer() : FooterUI
        {
            return _footer;
        }// end function

        public function set footer(param1:FooterUI) : void
        {
            if (param1 !== _footer)
            {
                _footer = param1;
            }
            return;
        }// end function

        public function get logo() : LittleFilmsLogo
        {
            return _logo;
        }// end function

        public function set logo(param1:LittleFilmsLogo) : void
        {
            if (param1 !== _logo)
            {
                _logo = param1;
            }
            return;
        }// end function

        public function get stageWidth() : uint
        {
            return _stageWidth;
        }// end function

        public function set stageWidth(param1:uint) : void
        {
            if (param1 !== _stageWidth)
            {
                _stageWidth = param1;
            }
            return;
        }// end function

        public function get stageHeight() : uint
        {
            return _stageHeight;
        }// end function

        public function set stageHeight(param1:uint) : void
        {
            if (param1 !== _stageHeight)
            {
                _stageHeight = param1;
            }
            return;
        }// end function

        public function get footerHeight() : Number
        {
            return _footerHeight;
        }// end function

        public function set footerHeight(param1:Number) : void
        {
            if (param1 !== _footerHeight)
            {
                _footerHeight = param1;
            }
            return;
        }// end function

        public function get activated() : Boolean
        {
            return _activated;
        }// end function

        public function set activated(param1:Boolean) : void
        {
            if (param1 !== _activated)
            {
                _activated = param1;
            }
            return;
        }// end function

        function frame1()
        {
            return;
        }// end function

    }
}
