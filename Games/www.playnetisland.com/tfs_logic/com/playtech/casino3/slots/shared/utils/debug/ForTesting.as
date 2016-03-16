package com.playtech.casino3.slots.shared.utils.debug
{
    import com.playtech.casino3.*;
    import com.playtech.casino3.utils.queue.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class ForTesting extends Object implements IDisposable
    {
        protected var _module_interface:IModuleInterface;
        protected var frame_reate_text_filed:TextField;
        protected var target:DisplayObject;
        protected var is_blocked:Boolean = false;
        protected var queue:CommandQueue;
        protected var block_queue_id:String;
        protected var stage:Stage;

        public function ForTesting(frameRate:IModuleInterface, frameRate:DisplayObject, frameRate:CommandQueue, frameRate:Boolean = false) : void
        {
            this.target = frameRate;
            this.queue = frameRate;
            this.stage = this.target.stage;
            this._module_interface = frameRate;
            if (!frameRate)
            {
                Console.disable();
            }
            this.stage.addEventListener(Event.ACTIVATE, this.windowFocus);
            this.stage.addEventListener(Event.DEACTIVATE, this.windowFocus);
            this.frame_reate_text_filed = new TextField();
            this.frame_reate_text_filed.type = TextFieldType.INPUT;
            this.frame_reate_text_filed.background = true;
            this.frame_reate_text_filed.backgroundColor = 16777215;
            this.frame_reate_text_filed.border = true;
            this.frame_reate_text_filed.borderColor = 0;
            this.frame_reate_text_filed.restrict = "0-9";
            this.frame_reate_text_filed.x = -50;
            this.frame_reate_text_filed.width = 50;
            this.frame_reate_text_filed.height = 20;
            this.frame_reate_text_filed.textColor = 0;
            this.frame_reate_text_filed.defaultTextFormat = new TextFormat("_sans", 15, 0, true, null, null, null, null, TextFormatAlign.CENTER);
            this.frame_reate_text_filed.text = this.stage.frameRate + "";
            this.frame_reate_text_filed.tabEnabled = false;
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            this.frame_reate_text_filed.addEventListener(Event.CHANGE, this.onFrameRateChange);
            this.stage.addChild(this.frame_reate_text_filed);
            this.target.addEventListener(Event.REMOVED_FROM_STAGE, this.onDispose);
            return;
        }// end function

        public function onDispose(event:Event) : void
        {
            this.target.removeEventListener(Event.REMOVED_FROM_STAGE, this.onDispose);
            this.dispose();
            return;
        }// end function

        public function play() : void
        {
            QueueEventManager.dispatchEvent(this.block_queue_id);
            this.block_queue_id = null;
            return;
        }// end function

        protected function onKeyDown(event:KeyboardEvent) : void
        {
            if (event.ctrlKey && event.charCode == "s".charCodeAt(0))
            {
                this.is_blocked = !this.is_blocked;
                if (this.is_blocked)
                {
                    this.stop();
                }
                else
                {
                    this.play();
                }
            }
            return;
        }// end function

        protected function onFrameRateChange(event:Event) : void
        {
            var _loc_2:* = event.target as TextField;
            var _loc_3:* = int(_loc_2.text);
            if (_loc_3 < 1)
            {
                _loc_3 = 1;
            }
            this.stage.frameRate = _loc_3;
            return;
        }// end function

        protected function windowFocus(event:Event) : void
        {
            if (this._module_interface)
            {
                this._module_interface.muteSoundBySource(null, event.type == Event.DEACTIVATE);
            }
            return;
        }// end function

        public function block(CHANGE:String) : int
        {
            this.block_queue_id = CHANGE;
            return 1;
        }// end function

        public function stop() : void
        {
            this.queue.unshiftCommands(new CommandObject(this.block));
            return;
        }// end function

        public function dispose() : void
        {
            this.stage.removeEventListener(Event.ACTIVATE, this.windowFocus);
            this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            this.stage.removeChild(this.frame_reate_text_filed);
            this.frame_reate_text_filed.removeEventListener(Event.CHANGE, this.onFrameRateChange);
            this.frame_reate_text_filed = null;
            this._module_interface = null;
            this.target = null;
            this.queue = null;
            this.stage = null;
            return;
        }// end function

    }
}
