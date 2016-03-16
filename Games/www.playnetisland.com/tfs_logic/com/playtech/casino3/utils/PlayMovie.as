package com.playtech.casino3.utils
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;

    public class PlayMovie extends Object
    {
        private var m_completitionArgs:Array;
        private var m_endFrame:int;
        private var m_completitionHandler:Function;
        private var m_endFrameStr:String;
        protected var m_mc:MovieClip;
        private var m_startFrameStr:String;
        private var m_remove:Boolean;
        private var m_startFrame:int;
        private static var m_objs:Vector.<PlayMovie>;

        public function PlayMovie(param1:MovieClip, param2:Boolean = false, param3 = 1, param4 = -1, param5:Function = null, ... args)
        {
            this.m_mc = param1;
            this.m_remove = param2;
            this.m_completitionHandler = param5;
            this.m_completitionArgs = args;
            if (typeof(param4) == "number")
            {
                this.m_endFrame = int(param4);
                if (param4 == -1 || param4 > this.m_mc.totalFrames)
                {
                    this.m_endFrame = this.m_mc.totalFrames;
                }
                if (this.m_startFrame > this.m_endFrame)
                {
                    this.m_startFrame = 1;
                }
            }
            else
            {
                this.m_endFrameStr = String(param4);
            }
            if (typeof(param3) == "number")
            {
                this.m_startFrame = int(param3);
                this.m_mc.gotoAndPlay(this.m_startFrame);
            }
            else
            {
                this.m_startFrameStr = String(param3);
                this.m_mc.gotoAndPlay(this.m_startFrameStr);
            }
            this.m_mc.addEventListener(Event.ENTER_FRAME, this.play);
            this.m_mc.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
            if (m_objs == null)
            {
                m_objs = new Vector.<PlayMovie>;
            }
            m_objs.push(this);
            return;
        }// end function

        private function onRemovedFromStage(event:Event = null) : void
        {
            this.onEnd();
            this.clear();
            return;
        }// end function

        protected function clear() : void
        {
            this.m_mc = null;
            var _loc_1:* = m_objs.indexOf(this);
            if (_loc_1 != -1)
            {
                m_objs.splice(_loc_1, 1);
            }
            return;
        }// end function

        private function removeMC() : void
        {
            if (this.m_remove)
            {
                this.m_mc.parent.removeChild(this.m_mc);
                this.m_remove = false;
            }
            return;
        }// end function

        public function cancel() : void
        {
            this.removeListener();
            this.removeMC();
            return;
        }// end function

        protected function play(event:Event) : void
        {
            if (this.m_endFrameStr == null && this.m_mc.currentFrame >= this.m_endFrame || this.m_endFrameStr != null && this.m_mc.currentFrameLabel == this.m_endFrameStr)
            {
                this.onEnd();
                this.removeMC();
                this.clear();
            }
            return;
        }// end function

        private function onEnd() : void
        {
            this.removeListener();
            if (this.m_completitionHandler != null)
            {
                this.m_completitionHandler.apply(null, this.m_completitionArgs);
                this.m_completitionHandler = null;
                this.m_completitionArgs = null;
            }
            return;
        }// end function

        private function removeListener() : void
        {
            if (this.m_mc != null)
            {
                this.m_mc.removeEventListener(Event.ENTER_FRAME, this.play);
                this.m_mc.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
                this.m_mc.stop();
            }
            return;
        }// end function

        public static function disposeAll() : void
        {
            var _loc_2:PlayMovie = null;
            if (m_objs == null)
            {
                return;
            }
            var _loc_1:* = m_objs.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_1)
            {
                
                _loc_2 = m_objs.shift();
                _loc_2.cancel();
                _loc_2.clear();
                _loc_3++;
            }
            m_objs = null;
            return;
        }// end function

    }
}
