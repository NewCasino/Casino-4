package com.playtech.casino3.slots.top_trumps_stars.wins.anims
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.*;
    import com.playtech.casino3.slots.shared.base_game.*;
    import com.playtech.casino3.slots.shared.data.*;
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;
    import com.playtech.casino3.slots.shared.novel.winAnimations.*;
    import com.playtech.casino3.slots.shared.utils.*;
    import com.playtech.casino3.slots.top_trumps_stars.*;
    import com.playtech.casino3.slots.top_trumps_stars.enum.*;
    import com.playtech.casino3.slots.top_trumps_stars.slot_symbols.*;
    import com.playtech.casino3.utils.*;
    import com.playtech.casino3.utils.queue.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class BallAnim extends ThemeAnim
    {
        protected var _ball_symbol:MovieClip;
        protected var _position_index:int = 0;
        protected var _ball_controller:MovieClipController;
        protected var _ball:MovieClip;
        protected var _logic:Logic;
        protected var _tween_x:Tween;
        protected var _tween_y:Tween;
        protected var _queue_id:String;
        protected var _ball_position:Point;
        protected var _positions:Vector.<Point>;
        protected var _bounces:Vector.<DisplayObjectContainer>;
        protected var _to_position:Point;
        protected var _pay_numbers:Vector.<DisplayObjectContainer>;
        protected var _is_left:Boolean;
        static const BALL_WIN_SOUND_SOURCE:String = getQualifiedClassName(BallAnim) + ".BALL_WIN_SOUND_SOURCE";

        public function BallAnim(params:WinsNovel, params:SlotsWin, params:Vector.<int>, params:Vector.<SlotsSymbol>, params:SlotsPayline, params:Object = null) : void
        {
            this._pay_numbers = new Vector.<DisplayObjectContainer>;
            this._bounces = new Vector.<DisplayObjectContainer>;
            super(params, params, params, params, params, params);
            this._logic = params.logic;
            statusKey = "pass_the_ball_feature_win";
            this._positions = this._logic._reels.getGlobalPositions();
            return;
        }// end function

        override public function activate(http://adobe.com/AS3/2006/builtin:int, http://adobe.com/AS3/2006/builtin:String) : int
        {
            this._queue_id = http://adobe.com/AS3/2006/builtin;
            if (http://adobe.com/AS3/2006/builtin == WinsNovel.PHASE_1)
            {
                return this.playBallAnim();
            }
            if (http://adobe.com/AS3/2006/builtin == WinsNovel.PHASE_2)
            {
                hideShowVideos(false);
                return super.activate(http://adobe.com/AS3/2006/builtin, http://adobe.com/AS3/2006/builtin);
            }
            return 0;
        }// end function

        protected function onBallEnd(event:Event) : void
        {
            if (this._ball.parent)
            {
                this._ball.parent.removeChild(this._ball);
            }
            this._ball_symbol.visible = true;
            this.showHideDisplayObjects(this._pay_numbers, false);
            m_movies[0].visible = true;
            QueueEventManager.dispatchEvent(this._queue_id);
            return;
        }// end function

        protected function playBallAnim() : int
        {
            EventPool.addEventListener(WinAnimInfo.ANIM_STOPPED, this.onAnimationStop);
            winsAnimator.videosToTop(symbolIndexes, 0);
            var _loc_1:* = getDefinitionByName(LINKAGE_PREFIX + BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + ".ball_anim") as Class;
            this._ball = new _loc_1 as MovieClip;
            this._ball_controller = new MovieClipController(this._ball);
            this._ball_controller.addEventListener("bounce_start", this.onBounce);
            this._ball_controller.playTo("bounce");
            winsAnimator.playSound(LINKAGE_PREFIX + BaseSlotSymbols.SOUND_SYMBOLS_PACKAGE + ".ball", "");
            var _loc_3:String = this;
            _loc_3._position_index = this._position_index + 1;
            var _loc_2:* = symbolIndexes[this._position_index++];
            this._ball_position = this._positions[_loc_2];
            this._is_left = _loc_2 % GameParameters.numReels == 1;
            this._ball.x = this._ball_position.x;
            this._ball.y = this._ball_position.y;
            this._logic._game_window.addChild(this._ball);
            this._ball_symbol = this._logic._reels.symbolOnFlatIndex(_loc_2) as MovieClip;
            this._ball_symbol.visible = false;
            m_movies[0].visible = false;
            return 1;
        }// end function

        protected function removeOtherAnims() : void
        {
            this.removeDisplayObjectsFromParent(this._pay_numbers);
            this.removeDisplayObjectsFromParent(this._bounces);
            return;
        }// end function

        protected function onBounce(event:Event) : void
        {
            this._ball_controller.playToFrom("bounce_end", "bounce");
            if (this._position_index >= 2 && this._position_index <= symbolIndexes.length)
            {
                this.createBounceAnim((this._position_index - 1));
            }
            if (this._position_index == symbolIndexes.length)
            {
                return this.bounceOut();
            }
            var _loc_2:String = this;
            _loc_2._position_index = this._position_index + 1;
            this._to_position = this._positions[symbolIndexes[this._position_index++]];
            this._tween_x = new Tween(this._ball, "x", Regular.easeInOut, this._ball.x, this._to_position.x, 30);
            this._tween_y = new Tween(this._ball, "y", Regular.easeInOut, this._ball.y, this._to_position.y, 30);
            this._tween_x.addEventListener(TweenEvent.MOTION_FINISH, this.onBounce);
            return;
        }// end function

        protected function onAnimationStop(event:Event) : void
        {
            this.cancelAnimation();
            return;
        }// end function

        protected function stopTweens() : void
        {
            if (this._tween_x)
            {
                this._tween_x.stop();
            }
            if (this._tween_y)
            {
                this._tween_y.stop();
            }
            return;
        }// end function

        override protected function cycle2(http://adobe.com/AS3/2006/builtin:String) : int
        {
            this.showHideDisplayObjects(this._pay_numbers, true);
            return super.cycle2(http://adobe.com/AS3/2006/builtin);
        }// end function

        protected function createBounceAnim(params:int) : void
        {
            var image:MovieClip;
            var show_image:Function;
            var at_index:* = params;
            show_image = function () : void
            {
                image.visible = true;
                return;
            }// end function
            ;
            var country:* = this._is_left ? (this._logic.country_1) : (this._logic.country_2);
            var symbol:* = symbols[at_index] as GameSpecificSlotSymbol;
            var anim_linkage:* = LINKAGE_PREFIX + BaseSlotSymbols.VIDEO_SYMBOLS_PACKAGE + "." + country.type.toLowerCase() + ".players.player_" + symbol.player_index;
            var player_anim_class:* = getDefinitionByName(anim_linkage) as Class;
            var player_anim:* = new player_anim_class as MovieClip;
            var sound_index:* = at_index % 5;
            winsAnimator.playSound(LINKAGE_PREFIX + BaseSlotSymbols.SOUND_SYMBOLS_PACKAGE + ".ball_win_" + sound_index, "");
            image = this._logic._reels.symbolOnFlatIndex(symbolIndexes[at_index]) as MovieClip;
            image.visible = false;
            var player_anim_controller:* = new MovieClipController(player_anim, true, 1, player_anim.totalFrames, show_image);
            var at_position:* = this._positions[symbolIndexes[at_index]];
            this._bounces.push(player_anim);
            player_anim.x = at_position.x;
            player_anim.y = at_position.y;
            var SOUND_LINAKGE:* = LINKAGE_PREFIX + BaseSlotSymbols.SOUND_SYMBOLS_PACKAGE + ".ball_win.";
            SOUND_LINAKGE = SOUND_LINAKGE + ((this._is_left ? (this._logic.country_1.type) : (this._logic.country_2.type)).toLowerCase() + "." + (at_index == (symbols.length - 1) ? ("last") : ("regular")) + ".player_" + symbol.player_index);
            this._logic._module_interface.playAsEffect(SOUND_LINAKGE, BALL_WIN_SOUND_SOURCE);
            var pay_number_class:* = getDefinitionByName(LINKAGE_PREFIX + "texts.pay_number") as Class;
            var pay_number:* = new pay_number_class as DisplayObjectContainer;
            this._pay_numbers.push(pay_number);
            var text:* = pay_number.getChildByName("text") as TextField;
            text.text = Money.format(this._logic._round_info.getTotalBet() * 3);
            var bold_text_format:* = new TextFormat();
            bold_text_format.bold = true;
            text.setTextFormat(bold_text_format);
            pay_number.x = player_anim.x;
            pay_number.y = player_anim.y;
            this._logic._effects_above_reels.addChildAt(pay_number, 0);
            image.visible = false;
            this._logic._effects_above_reels.addChildAt(player_anim, 0);
            return;
        }// end function

        protected function removeDisplayObjectsFromParent(params:Vector.<DisplayObjectContainer>) : void
        {
            var _loc_2:DisplayObjectContainer = null;
            if (!params)
            {
                return;
            }
            for each (_loc_2 in params)
            {
                
                if (_loc_2.parent)
                {
                    _loc_2.parent.removeChild(_loc_2);
                }
            }
            return;
        }// end function

        protected function onBounceEnd(event:Event) : void
        {
            this._ball_controller.playToFrom(this._ball.totalFrames, "bounce_end");
            this._ball.nextFrame();
            this._ball_controller.stop();
            this._ball.x = this._ball_position.x;
            this._ball.y = this._ball_position.y;
            return;
        }// end function

        protected function onGoalEnd(event:Event = null) : void
        {
            this._ball_controller.addEventListener("goal_end", this.onGoalEnd);
            this._ball_controller.playTo(this._ball.totalFrames);
            this._ball_controller.addEventListener(MovieClipFramesData.LAST_FRAME_REACHED, this.onBallEnd);
            this._ball.x = this._ball_position.x;
            this._ball.y = this._ball_position.y;
            return;
        }// end function

        protected function bounceOut() : void
        {
            var _loc_1:* = this._is_left ? (200) : (-200);
            var _loc_2:* = this._is_left ? (this._positions[9]) : (this._positions[5]);
            this._tween_x = new Tween(this._ball, "x", Regular.easeInOut, this._ball.x, _loc_2.x + _loc_1, 30);
            this._tween_y = new Tween(this._ball, "y", Regular.easeInOut, this._ball.y, _loc_2.y, 30);
            this._tween_x.addEventListener(TweenEvent.MOTION_FINISH, this.onBounceEnd);
            this._tween_x.addEventListener(TweenEvent.MOTION_CHANGE, this.onBallBaounceOutChange);
            return;
        }// end function

        protected function onBallBaounceOutChange(event:TweenEvent) : void
        {
            if (event.position > 30 && event.position < 770)
            {
                return;
            }
            this._tween_x.removeEventListener(TweenEvent.MOTION_CHANGE, this.onBallBaounceOutChange);
            var _loc_2:* = LINKAGE_PREFIX + BaseSlotSymbols.SOUND_SYMBOLS_PACKAGE + ".ball_win.goal";
            this._logic._module_interface.playAsEffect(_loc_2, BALL_WIN_SOUND_SOURCE);
            var _loc_3:* = LINKAGE_PREFIX + "anims.goal";
            var _loc_4:* = getDefinitionByName(_loc_3) as Class;
            var _loc_5:* = new _loc_4 as MovieClip;
            var _loc_6:* = new MovieClipController(_loc_5, true, 1, _loc_5.totalFrames, this.onGoalEnd);
            _loc_5.x = this._positions[7].x;
            _loc_5.y = this._positions[7].y;
            this._logic._effects_above_reels.addChild(_loc_5);
            this._bounces.push(_loc_5);
            return;
        }// end function

        override public function dispose() : void
        {
            EventPool.removeEventListener(WinAnimInfo.ANIM_STOPPED, this.onAnimationStop);
            this.cancelAnimation();
            disposeObjects(this._ball_controller);
            this._logic = null;
            this._positions = null;
            this._ball_position = null;
            this._ball = null;
            this._ball_controller = null;
            this._tween_x = null;
            this._tween_y = null;
            this._pay_numbers = null;
            this._bounces = null;
            super.dispose();
            return;
        }// end function

        protected function showHideDisplayObjects(params:Vector.<DisplayObjectContainer>, params:Boolean) : void
        {
            var _loc_3:DisplayObjectContainer = null;
            if (!params)
            {
                return;
            }
            for each (_loc_3 in params)
            {
                
                _loc_3.visible = params;
            }
            return;
        }// end function

        override public function cancelAnimation() : void
        {
            this.stopTweens();
            this.removeOtherAnims();
            if (this._logic)
            {
                this._logic._module_interface.stopSoundsBySource(BALL_WIN_SOUND_SOURCE);
            }
            if (this._ball_controller)
            {
                this._ball_controller.stop();
            }
            if (this._ball && this._ball.parent)
            {
                this._ball.parent.removeChild(this._ball);
            }
            if (this._ball_symbol)
            {
                this._ball_symbol.visible = true;
            }
            if (m_movies)
            {
                m_movies[0].visible = true;
            }
            return;
        }// end function

        override public function deactivate() : void
        {
            this.showHideDisplayObjects(this._pay_numbers, false);
            super.deactivate();
            return;
        }// end function

    }
}
