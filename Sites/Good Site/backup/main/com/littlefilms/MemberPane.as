package com.littlefilms
{
    import flash.display.*;
    import flash.events.*;
    import gs.*;
    import gs.easing.*;

    public class MemberPane extends ContentPane
    {
        private var _navInfo:Array;
        private var _avatarAreaWidth:uint = 190;

        public function MemberPane(param1:String)
        {
            _navInfo = [];
            trace("MemberPane::()");
            super(param1);
            return;
        }// end function

        override public function init() : void
        {
            TweenMax.to(_paneBG, 0, {tint:14473405});
            fetchContent(name);
            super.init();
            return;
        }// end function

        private function fetchContent(param1:String) : void
        {
            var memberNode:XMLList;
            var imagePath:String;
            var imageName:String;
            var imageWidth:uint;
            var imageHeight:uint;
            var memberAvatar:Sprite;
            var memberDetails:MemberDetails;
            var paneName:* = param1;
            var _loc_4:int = 0;
            var _loc_5:* = _mainMC.contentManager.contentXML..member;
            var _loc_3:* = new XMLList("");
            for each (_loc_6 in _loc_5)
            {
                
                var _loc_7:* = _loc_5[_loc_4];
                with (_loc_5[_loc_4])
                {
                    if (@id == paneName)
                    {
                        _loc_3[_loc_4] = _loc_6;
                    }
                }
            }
            memberNode = _loc_3;
            imagePath = _mainMC.contentManager.contentXML.meta.content_photos.@location.toString();
            imageName = memberNode.thumbnail.@src.toString();
            imageWidth = memberNode.thumbnail.@width;
            imageHeight = memberNode.thumbnail.@height;
            memberAvatar = _mainMC.contentManager.getImage(imageName, imagePath, imageWidth, imageHeight);
            memberAvatar.x = (_avatarAreaWidth - imageWidth) / 2;
            TweenMax.to(memberAvatar, 0, {dropShadowFilter:{color:0, alpha:0.7, blurX:5, blurY:5, strength:1, distance:2}});
            content.addChild(memberAvatar);
            memberDetails = new MemberDetails(memberNode);
            memberDetails.registerMain(_mainMC);
            memberDetails.x = 0;
            memberDetails.alpha = 0;
            memberDetails.init();
            content.addChild(memberDetails);
            TweenMax.to(memberDetails, 0.5, {autoAlpha:1, ease:Expo.easeInOut});
            trace("memberNode = " + memberNode);
            return;
        }// end function

        private function buildSprite(param1:uint, param2:uint) : Sprite
        {
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            var _loc_5:* = new Sprite();
            new Sprite().graphics.beginFill(0);
            _loc_5.graphics.drawRect(0, 0, _loc_3, _loc_4);
            _loc_5.graphics.endFill();
            _loc_5.x = 0;
            _loc_5.y = 0;
            return _loc_5;
        }// end function

        override protected function closeClickHandler(event:MouseEvent) : void
        {
            _mainMC.sequencer.changeSection("primary", "");
            return;
        }// end function

    }
}
