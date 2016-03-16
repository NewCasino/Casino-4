package com.playtech.casino3.utils
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class RuntimeElsLoader extends EventDispatcher
    {
        private var m_percentEnd:Number;
        private var m_descriptor:Object;
        private var m_groupsToLoad:Array;
        private var m_currLoadingId:int;
        private var m_forceQId:String;
        private var m_mcLoader:MovieClip;
        private var m_currLoading:Object;
        private var m_isStarted:Boolean;
        private var m_tfLoading:TextField;
        private var m_forceCompFuncArgs:Array;
        private var m_forceCompFunc:Function;
        private var m_mi:IModuleInterface;
        private var m_percentStart:Number;
        private var m_mcLoading:MovieClip;
        private var m_forcedGroupToLoad:String;
        private var m_mcLoaderMask:MovieClip;
        public static var EVT_FINISHED:String = "evt_rtels_finished";

        public function RuntimeElsLoader(param1:IModuleInterface, param2:Object)
        {
            this.m_groupsToLoad = new Array();
            this.m_mi = param1;
            this.m_descriptor = param2;
            this.m_isStarted = false;
            return;
        }// end function

        public function forceToLoadNextFunc(com.playtech.casino3:String, com.playtech.casino3:Function, com.playtech.casino3:Array = null) : void
        {
            Console.write("forceToLoadNextFunc() " + com.playtech.casino3 + " compfunc:  " + com.playtech.casino3, this);
            this.m_forceCompFunc = com.playtech.casino3;
            this.m_forceCompFuncArgs = com.playtech.casino3;
            this.forceToLoad(com.playtech.casino3);
            return;
        }// end function

        override public function toString() : String
        {
            return "[RtElsLdr]";
        }// end function

        private function drawArc(com.playtech.casino3:MovieClip, com.playtech.casino3:Number, com.playtech.casino3:Number, com.playtech.casino3:Number, com.playtech.casino3:Number, com.playtech.casino3:Number, com.playtech.casino3:Number) : void
        {
            var _loc_13:Number = NaN;
            var _loc_8:* = 2 * Math.PI;
            var _loc_9:* = com.playtech.casino3 / com.playtech.casino3;
            var _loc_10:* = com.playtech.casino3 + Math.cos(com.playtech.casino3 * _loc_8) * com.playtech.casino3;
            var _loc_11:* = com.playtech.casino3 + Math.sin(com.playtech.casino3 * _loc_8) * com.playtech.casino3;
            com.playtech.casino3.graphics.lineStyle(1, 16711680);
            com.playtech.casino3.graphics.moveTo(com.playtech.casino3, com.playtech.casino3);
            com.playtech.casino3.graphics.lineTo(_loc_10, _loc_11);
            com.playtech.casino3.graphics.beginFill(16711680, 1);
            com.playtech.casino3.graphics.moveTo(_loc_10, _loc_11);
            var _loc_12:int = 1;
            while (_loc_12 <= com.playtech.casino3)
            {
                
                _loc_13 = com.playtech.casino3 + _loc_12 * _loc_9;
                _loc_10 = com.playtech.casino3 + Math.cos(_loc_13 * _loc_8) * com.playtech.casino3;
                _loc_11 = com.playtech.casino3 + Math.sin(_loc_13 * _loc_8) * com.playtech.casino3;
                com.playtech.casino3.graphics.lineTo(_loc_10, _loc_11);
                _loc_12++;
            }
            com.playtech.casino3.graphics.lineTo(com.playtech.casino3, com.playtech.casino3);
            return;
        }// end function

        private function onAllLoaded() : void
        {
            this.m_currLoadingId = -1;
            this.m_currLoading = null;
            dispatchEvent(new Event(EVT_FINISHED));
            return;
        }// end function

        private function onElLoaded() : void
        {
            Console.write("onElLoaded() " + this.m_currLoading.name + " callfunc: " + this.m_currLoading.func, this);
            if (this.m_currLoading && this.m_currLoading.func != null)
            {
                (this.m_currLoading.func as Function).apply(null);
            }
            if (this.m_currLoading.name == this.m_forcedGroupToLoad)
            {
                Console.write("\t loading of forced group finished. m_forceCompFunc: " + this.m_forceCompFunc + " m_forceQId: " + this.m_forceQId, this);
                this.showLoadingMC(false);
                this.m_forcedGroupToLoad = null;
                if (this.m_forceCompFunc != null)
                {
                    if (this.m_forceCompFuncArgs == null)
                    {
                        this.m_forceCompFunc.apply(null);
                    }
                    else
                    {
                        this.m_forceCompFunc.apply(null, this.m_forceCompFuncArgs);
                    }
                    this.m_forceCompFuncArgs = null;
                    this.m_forceCompFunc = null;
                }
                else if (this.m_forceQId)
                {
                    QueueEventManager.dispatchEvent(this.m_forceQId);
                    this.m_forceQId = null;
                }
            }
            this.loadNext();
            return;
        }// end function

        private function forceToLoad( callfunc: :String) : int
        {
            var _loc_4:Object = null;
            var _loc_2:int = -1;
            var _loc_3:int = 0;
            while (_loc_3 < this.m_groupsToLoad.length)
            {
                
                if (this.m_groupsToLoad[_loc_3].name ==  callfunc: )
                {
                    _loc_2 = _loc_3;
                    break;
                }
                _loc_3++;
            }
            Console.write("\t idx: " + _loc_2 + " m_currLoading.name: " + this.m_currLoading.name, this);
            if (_loc_2 == -1)
            {
                if (this.m_currLoading.name ==  callfunc: )
                {
                    Console.write("\t currently loading the group that needs to be forced", this);
                    this.m_forcedGroupToLoad =  callfunc: ;
                    this.m_percentStart = 0;
                    this.m_percentEnd = 100;
                }
                else
                {
                    Console.write("\t forced group ALERADY loaded or NOT to be set for loading at all", this);
                    return 0;
                }
            }
            else
            {
                this.m_forcedGroupToLoad =  callfunc: ;
                if (_loc_2 != 0)
                {
                    _loc_4 = this.m_groupsToLoad.splice(_loc_2, 1)[0];
                    this.m_groupsToLoad.unshift(_loc_4);
                    Console.write("\t forced is set to be loaded next m_groupsToLoad: " + this.m_groupsToLoad, this);
                }
                else
                {
                    Console.write("\t forced is already to be loaded next m_groupsToLoad: " + this.m_groupsToLoad, this);
                }
                this.m_percentStart = 0;
                this.m_percentEnd = 50;
            }
            this.m_mi.listenLoad(this.m_currLoadingId, this.loadProgress);
            this.showLoadingMC(true);
            return 1;
        }// end function

        public function isGroupLoadingFinished(com.playtech.casino3.utils:RuntimeElsLoader/private:onAllLoaded:String) : Boolean
        {
            var _loc_2:int = 0;
            while (_loc_2 < this.m_groupsToLoad.length)
            {
                
                if (this.m_groupsToLoad[_loc_2].name == com.playtech.casino3.utils:RuntimeElsLoader/private:onAllLoaded)
                {
                    return false;
                }
                _loc_2++;
            }
            if (this.m_currLoading.name == com.playtech.casino3.utils:RuntimeElsLoader/private:onAllLoaded)
            {
                return false;
            }
            return true;
        }// end function

        public function add(com.playtech.casino3:String, com.playtech.casino3:Function = null) : void
        {
            var _loc_3:* = new Object();
            _loc_3.name = com.playtech.casino3;
            _loc_3.func = com.playtech.casino3;
            this.m_groupsToLoad.push(_loc_3);
            Console.write("add() " + com.playtech.casino3, this);
            return;
        }// end function

        public function start() : void
        {
            Console.write("start() num of groups to be loaded: " + this.m_groupsToLoad.length, this);
            this.m_isStarted = true;
            this.loadNext();
            return;
        }// end function

        public function dispose() : void
        {
            Console.write("dispose() ", this);
            this.m_mcLoading = null;
            this.m_mcLoader = null;
            this.m_mcLoaderMask = null;
            this.m_tfLoading = null;
            this.m_forceCompFunc = null;
            this.m_forceCompFuncArgs = null;
            this.m_forcedGroupToLoad = null;
            this.m_forceQId = null;
            this.m_groupsToLoad = null;
            this.m_descriptor = null;
            this.m_mi = null;
            return;
        }// end function

        private function showLoadingMC(com.playtech.casino3:Boolean) : void
        {
            if (com.playtech.casino3 == true)
            {
                if (this.m_mcLoading == null)
                {
                    this.m_mcLoading = Lib.getMCFromLib("ui.element_loading");
                    this.m_mcLoader = this.m_mcLoading.getChildByName("loader") as MovieClip;
                    this.m_mcLoaderMask = this.m_mcLoader.getChildByName("loadermask") as MovieClip;
                    this.m_tfLoading = this.m_mcLoading.getChildByName("tf_percent") as TextField;
                    this.m_descriptor.gfxRef.addChild(this.m_mcLoading);
                }
                (this.m_mi as IServiceInterface).enableGameKeyboardCapture(false);
            }
            else
            {
                if (this.m_mcLoading)
                {
                    if (this.m_mcLoading.parent)
                    {
                        this.m_mcLoading.parent.removeChild(this.m_mcLoading);
                        this.m_mcLoading = null;
                        this.m_mcLoader = null;
                        this.m_mcLoaderMask = null;
                        this.m_tfLoading = null;
                    }
                }
                (this.m_mi as IServiceInterface).enableGameKeyboardCapture(true);
            }
            return;
        }// end function

        private function loadNext() : void
        {
            var _loc_1:String = null;
            if (this.m_groupsToLoad.length > 0)
            {
                this.m_currLoading = this.m_groupsToLoad.shift();
                _loc_1 = this.m_currLoading.name;
                Console.write("loadNext() " + _loc_1, this);
                this.m_currLoadingId = this.m_mi.loadRuntimeElementGroup(this.m_descriptor, _loc_1, this.onElLoaded);
                if (this.m_forcedGroupToLoad)
                {
                    this.m_percentStart = 50;
                    this.m_percentEnd = 100;
                    this.m_mi.listenLoad(this.m_currLoadingId, this.loadProgress);
                }
            }
            else
            {
                Console.write("all loaded", this);
                this.onAllLoaded();
            }
            return;
        }// end function

        private function loadProgress(com.playtech.casino3:Number, com.playtech.casino3:Number) : void
        {
            var _loc_3:Number = NaN;
            if (this.m_tfLoading)
            {
                _loc_3 = Math.round(com.playtech.casino3 * (this.m_percentEnd - this.m_percentStart) + this.m_percentStart);
                this.m_tfLoading.text = _loc_3 + "%";
                this.createLoaderMask(_loc_3);
            }
            return;
        }// end function

        private function createLoaderMask(com.playtech.casino3:Number) : void
        {
            var _loc_2:Number = NaN;
            if (com.playtech.casino3 == 100)
            {
                this.m_mcLoader.g1.gotoAndStop(1);
                this.m_mcLoader.g2.gotoAndStop(2);
            }
            _loc_2 = com.playtech.casino3 * 360 / 100;
            this.m_mcLoaderMask.graphics.clear();
            this.drawArc(this.m_mcLoaderMask, 0, 0, 37, -90 / 360, _loc_2 / 360, 200);
            this.m_mcLoader.g2.mask = this.m_mcLoaderMask;
            return;
        }// end function

        public function forceToLoadNextCmd( callfunc: :String,  callfunc: :String) : int
        {
            Console.write("forceToLoadNextCmd() queueId: " +  callfunc: , this);
            this.m_forceQId =  callfunc: ;
            var _loc_3:* = this.forceToLoad( callfunc: );
            return _loc_3;
        }// end function

    }
}
