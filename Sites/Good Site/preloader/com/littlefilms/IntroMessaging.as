package com.littlefilms
{
    import flash.display.*;
    import gs.*;
    import gs.easing.*;

    public class IntroMessaging extends MovieClip
    {
        public var creativeText:MovieClip;
        public var moviesText:MovieClip;
        public var messageNoun:MessageNoun;
        public var forText:MovieClip;
        private var _mainMC:Object = null;
        public var percentageNum:uint = 0;
        private var _messagesXML:XML;
        private var _shuffledMessages:XML;
        private var _stageHeight:Number;
        private var _stageWidth:Number;
        private var _introActive:Boolean = true;
        private var _isLoading:Boolean = true;
        private var _firstCycle:Boolean = true;
        private var _currentFadeTime:Number;
        public var messageSwapSpeed:Number = 0.5;
        private var _endSwapSpeed:Number = 0.1;
        private var _messageRefreshTimes:Array;
        private var _currentItem:uint = 0;

        public function IntroMessaging(param1:XML)
        {
            _messageRefreshTimes = [1];
            addFrameScript(0, frame1, 59, frame60, 178, frame179);
            _messagesXML = param1;
            _shuffledMessages = _shuffledMessageXML(_messagesXML);
            return;
        }// end function

        public function init() : void
        {
            gotoAndPlay("reveal");
            return;
        }// end function

        public function registerMain(param1) : void
        {
            _mainMC = param1;
            return;
        }// end function

        private function _shuffledMessageXML(param1:XML) : XML
        {
            var _loc_4:Object = null;
            var _loc_5:XMLList = null;
            var _loc_2:* = <main></main>;
            var _loc_3:Array = [];
            var _loc_6:uint = 0;
            while (_loc_6 < param1.goodThing.length())
            {
                
                _loc_4 = {ranNum:Math.floor(Math.random() * 1000), node:param1.goodThing[_loc_6] as XML};
                _loc_3[_loc_6] = _loc_4;
                _loc_6 = _loc_6 + 1;
            }
            _loc_3.sortOn("ranNum", Array.NUMERIC);
            var _loc_7:uint = 0;
            while (_loc_7 < _loc_3.length)
            {
                
                _loc_2.appendChild(_loc_3[_loc_7].node);
                _loc_7 = _loc_7 + 1;
            }
            return _loc_2;
        }// end function

        public function cycleQuotes() : void
        {
            TweenMax.to(this, 0.5, {messageSwapSpeed:_endSwapSpeed, ease:Circ.easeIn, onUpdate:updateRefreshTimes});
            updateQuote();
            return;
        }// end function

        private function updateRefreshTimes() : void
        {
            _messageRefreshTimes.push(messageSwapSpeed);
            return;
        }// end function

        private function updateQuote()
        {
            var _loc_1:Number = NaN;
            if (_currentItem < _shuffledMessages.goodThing.length())
            {
                if (_firstCycle)
                {
                    _loc_1 = _currentItem > _messageRefreshTimes.length ? (_messageRefreshTimes[(_messageRefreshTimes.length - 1)]) : (_messageRefreshTimes[_currentItem]);
                    _currentFadeTime = _loc_1;
                }
                messageNoun.nounText.text = _shuffledMessages.goodThing.@name[_currentItem];
                messageNoun.alpha = 1;
                TweenMax.to(messageNoun, _currentFadeTime, {alpha:0, ease:Expo.easeIn, onComplete:updateQuote});
            }
            else
            {
                _firstCycle = false;
                if (_mainMC != null)
                {
                    gotoAndPlay("end");
                }
                else
                {
                    _currentItem = 0;
                    updateQuote();
                }
            }
            var _loc_3:* = _currentItem + 1;
            _currentItem = _loc_3;
            return;
        }// end function

        private function hideTagline() : void
        {
            TweenMax.to(this, 0.5, {alpha:0, ease:Expo.easeInOut});
            return;
        }// end function

        private function revealTagline() : void
        {
            TweenMax.to(this, 0.5, {alpha:1, ease:Expo.easeInOut});
            return;
        }// end function

        private function moveToRest() : void
        {
            _isLoading = false;
            TweenMax.to(this, 0.5, {x:30, ease:Expo.easeInOut});
            TweenMax.to(this, 1, {y:50, delay:0.5, ease:Expo.easeInOut, overwrite:0, onComplete:activateMain});
            TweenMax.to(this.creativeText, 1, {tint:16777215, ease:Expo.easeInOut, delay:0.5});
            TweenMax.to(this.moviesText, 1, {tint:16777215, ease:Expo.easeInOut, delay:0.5});
            TweenMax.to(this.forText, 1, {tint:16777215, ease:Expo.easeInOut, delay:0.5});
            TweenMax.to(this, 1, {glowFilter:{color:0, alpha:0.5, blurX:16, blurY:16}, delay:0.5});
            return;
        }// end function

        private function activateMain() : void
        {
            _mainMC.revealInterface();
            return;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            _stageHeight = param2;
            _stageWidth = param1;
            positionContent();
            return;
        }// end function

        private function positionContent() : void
        {
            if (_isLoading)
            {
                x = 110;
                y = (_stageHeight - height) / 2;
            }
            else
            {
                x = 30;
                y = 50;
            }
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame60()
        {
            cycleQuotes();
            stop();
            return;
        }// end function

        function frame179()
        {
            moveToRest();
            stop();
            return;
        }// end function

    }
}
