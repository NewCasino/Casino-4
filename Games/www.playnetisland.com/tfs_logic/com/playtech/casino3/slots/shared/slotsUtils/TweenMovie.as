package com.playtech.casino3.slots.shared.slotsUtils
{
    import __AS3__.vec.*;
    import com.playtech.casino3.slots.shared.utils.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class TweenMovie extends Object
    {
        private var m_bitmapContainer:Sprite;
        private var m_completitionArgs:Array;
        private var m_completitionHandler:Function;
        private var m_tween:Tween;
        private var m_useBitmap:Boolean = true;
        private var m_isRemoveOnFinish:Boolean;
        private var m_params:Object;
        private var m_do:DisplayObject;
        private static var m_objs:Vector.<TweenMovie>;

        public function TweenMovie(param1:DisplayObject, param2:Object, param3:Boolean = false, param4:Function = null, ... args)
        {
            args = null;
            var _loc_7:Bitmap = null;
            this.m_do = param1;
            this.m_params = param2;
            if (param2.useBitmap != undefined && param2.useBitmap == false)
            {
                this.m_useBitmap = false;
            }
            else
            {
                args = this.m_do.getBounds(this.m_do);
                this.m_bitmapContainer = new Sprite();
                _loc_7 = getPartFromAsBitmap(args, this.m_do, false, true);
                _loc_7.x = args.x;
                _loc_7.y = args.y;
                _loc_7.smoothing = true;
                this.m_bitmapContainer.addChild(_loc_7);
                this.m_bitmapContainer.x = this.m_do.x;
                this.m_bitmapContainer.y = this.m_do.y;
                this.m_do.parent.addChildAt(this.m_bitmapContainer, this.m_do.parent.getChildIndex(this.m_do));
                this.m_do.y = this.m_do.y + -2000;
            }
            this.m_isRemoveOnFinish = param3;
            this.m_completitionHandler = param4;
            this.m_completitionArgs = args;
            this.m_do.addEventListener(Event.REMOVED_FROM_STAGE, this.clear);
            this.tween();
            if (m_objs == null)
            {
                m_objs = new Vector.<TweenMovie>;
            }
            m_objs.push(this);
            return;
        }// end function

        protected function tween() : void
        {
            var _loc_1:* = this.m_params.easing != undefined ? (this.m_params.easing) : (Regular.easeIn);
            var _loc_2:* = this.m_useBitmap ? (this.m_bitmapContainer) : (this.m_do);
            this.m_tween = new Tween(_loc_2, this.m_params.prop, _loc_1, this.m_params.begin, this.m_params.finish, this.m_params.duration);
            this.m_tween.addEventListener(TweenEvent.MOTION_FINISH, this.finish, false, 0, true);
            this.m_tween.start();
            return;
        }// end function

        public function clear(event:Event = null) : void
        {
            if (this.m_useBitmap && !this.m_isRemoveOnFinish)
            {
                this.mainObjectBack();
            }
            this.m_do.removeEventListener(Event.REMOVED_FROM_STAGE, this.clear);
            if (this.m_tween != null)
            {
                this.m_tween.stop();
                this.m_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.finish);
                this.m_tween = null;
            }
            if (this.m_useBitmap)
            {
                this.m_bitmapContainer.parent.removeChild(this.m_bitmapContainer);
                this.m_bitmapContainer = null;
            }
            this.m_params = null;
            this.m_do = null;
            this.m_completitionHandler = null;
            this.m_completitionArgs = null;
            var _loc_2:* = m_objs.indexOf(this);
            if (_loc_2 != -1)
            {
                m_objs.splice(_loc_2, 1);
            }
            return;
        }// end function

        private function finish(event:TweenEvent) : void
        {
            this.m_do.removeEventListener(Event.REMOVED_FROM_STAGE, this.clear);
            if (this.m_isRemoveOnFinish)
            {
                this.m_do.parent.removeChild(this.m_do);
            }
            if (this.m_completitionHandler != null)
            {
                this.m_completitionHandler.apply(null, this.m_completitionArgs);
            }
            this.clear();
            return;
        }// end function

        private function mainObjectBack() : void
        {
            this.m_do.y = this.m_do.y + 2000;
            this.m_do[this.m_params.prop] = this.m_params.finish;
            return;
        }// end function

    }
}
