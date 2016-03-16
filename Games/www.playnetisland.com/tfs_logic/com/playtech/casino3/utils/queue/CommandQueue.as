package com.playtech.casino3.utils.queue
{
    import com.playtech.casino3.utils.*;
    import com.playtech.core.*;
    import flash.display.*;
    import flash.events.*;

    public class CommandQueue extends Object
    {
        private var m_stack:Array;
        private var m_execI:int;
        private var m_idCounter:int;
        private var m_framePause:Boolean;
        private var m_locks:int;
        private var m_listeners:Object;
        private var m_id:String;
        private static const NAME:String = "CommandQueue_";
        private static const ENTER_FRAME_BROADCASTER:Sprite = new Sprite();
        private static var id:int;

        public function CommandQueue(Object:Stage = null) : void
        {
            this.m_stack = [];
            this.m_listeners = new Object();
            this.m_id = NAME + id++;
            QueueEventManager.addEventListener(this.m_id, this.lockEvent);
            return;
        }// end function

        public function jumpToCommand(Object:int) : void
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_6:int = 0;
            var _loc_2:* = this.m_stack.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_2)
            {
                
                _loc_3 = this.m_stack[_loc_5].length;
                _loc_6 = 0;
                while (_loc_6 < _loc_3)
                {
                    
                    if (this.m_stack[_loc_5][_loc_6].getId() == Object)
                    {
                        _loc_4 = _loc_5;
                        break;
                    }
                    _loc_6++;
                }
                _loc_5++;
            }
            if (_loc_4 < 1)
            {
                return;
            }
            _loc_5 = 0;
            while (_loc_5 < _loc_4)
            {
                
                this.clearCommandSet(this.m_stack.shift(), _loc_5 == 0);
                _loc_5++;
            }
            if (!this.m_framePause)
            {
                this.startExecution();
            }
            return;
        }// end function

        private function clearCommandSet(Object:Array, Object:Boolean = false) : void
        {
            var _loc_4:ICommand = null;
            var _loc_3:* = Object.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_4 = Object[_loc_5];
                if (Object && !this.m_framePause)
                {
                    _loc_4.cancel();
                }
                _loc_4.clear();
                this.unregisterListener(_loc_4.getId());
                _loc_5++;
            }
            return;
        }// end function

        public function addParallel(Object:ICommand) : void
        {
            var _loc_2:String = this;
            _loc_2.m_idCounter = this.m_idCounter + 1;
            Object.setId(++this.m_idCounter);
            if (this.m_stack[0] == null)
            {
                this.m_stack.push([Object]);
            }
            else
            {
                this.m_stack[0].unshift(Object);
            }
            if (!this.m_framePause)
            {
                this.m_locks = this.m_locks + Object.execute(this.m_id + ":" + Object.getId());
                var _loc_2:String = this;
                var _loc_3:* = this.m_execI + 1;
                _loc_2.m_execI = _loc_3;
            }
            return;
        }// end function

        public function empty() : void
        {
            if (!this.m_stack)
            {
                return;
            }
            var _loc_1:* = this.m_stack.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                this.clearCommandSet(this.m_stack[_loc_2], _loc_2 == 0);
                _loc_2++;
            }
            this.m_framePause = false;
            ENTER_FRAME_BROADCASTER.removeEventListener(Event.ENTER_FRAME, this.executeCommand);
            this.m_stack = [];
            return;
        }// end function

        public function toString() : String
        {
            return this.m_stack.toString();
        }// end function

        public function unregisterListener(Object:int) : void
        {
            this.m_listeners[Object] = null;
            this.m_listeners[Object + "args"] = null;
            delete this.m_listeners[Object];
            return;
        }// end function

        private function startExecution() : void
        {
            var _loc_1:* = this.m_stack[0];
            var _loc_2:* = _loc_1.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (!ICommand(_loc_1[_loc_3]).hasFrameChange())
                {
                    this.executeCommand(null);
                    return;
                }
                _loc_3++;
            }
            this.m_framePause = true;
            ENTER_FRAME_BROADCASTER.addEventListener(Event.ENTER_FRAME, this.executeCommand);
            return;
        }// end function

        private function nextCommand() : void
        {
            this.clearCommandSet(this.m_stack.shift());
            if (this.m_stack.length > 0)
            {
                this.startExecution();
            }
            return;
        }// end function

        public function removeCommandById(Object:int) : void
        {
            return;
        }// end function

        public function dispose() : void
        {
            QueueEventManager.removeEventListener(this.m_id, this.lockEvent);
            this.empty();
            this.m_listeners = null;
            this.m_stack = null;
            return;
        }// end function

        public function add(... args) : void
        {
            args = args.length;
            var _loc_3:int = 0;
            while (_loc_3 < args)
            {
                
                var _loc_4:String = this;
                _loc_4.m_idCounter = this.m_idCounter + 1;
                args[_loc_3].setId(this.m_idCounter++);
                _loc_3++;
            }
            if (!(args[0] as ICommand).isCancelable())
            {
                this.removeSoftCommands();
            }
            this.m_stack.push(args);
            if (this.m_stack.length == 1)
            {
                this.startExecution();
            }
            return;
        }// end function

        private function executeCommand(event:Event) : void
        {
            var _loc_3:int = 0;
            this.m_framePause = false;
            ENTER_FRAME_BROADCASTER.removeEventListener(Event.ENTER_FRAME, this.executeCommand);
            if (this.m_stack.length == 0)
            {
                Console.write("CommandQueue executeCommand, but there is no command to activate");
                return;
            }
            var _loc_2:* = this.m_stack[0];
            this.m_locks = 0;
            this.m_execI = 0;
            while (this.m_execI < _loc_2.length)
            {
                
                if (this.m_stack[0] != _loc_2)
                {
                    Console.write("Parallel command has been removed before it was executed. Previous parallel command cleared this queue or this soft command.", "[CommandQueue: " + _loc_2[this.m_execI] + "] ");
                    return;
                }
                _loc_3 = _loc_2[this.m_execI].execute(this.m_id + ":" + _loc_2[this.m_execI].getId());
                this.m_locks = this.m_locks + _loc_3;
                var _loc_4:String = this;
                var _loc_5:* = this.m_execI + 1;
                _loc_4.m_execI = _loc_5;
            }
            if (this.m_locks <= 0)
            {
                if (this.m_stack != null && this.m_stack[0] == _loc_2)
                {
                    this.nextCommand();
                }
            }
            return;
        }// end function

        public function get length() : int
        {
            return this.m_stack.length;
        }// end function

        private function lockEvent(event:RegularEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:ICommand = null;
            var _loc_6:int = 0;
            if (event.data is Array)
            {
                _loc_3 = event.data[0];
                _loc_2 = event.data[1];
            }
            else
            {
                _loc_3 = event.data;
                _loc_2 = -1;
            }
            if (this.m_stack[0] == null)
            {
                Console.write("CommandQueue lockEvent stack is empty!!!");
                return;
            }
            var _loc_5:* = this.m_stack[0].length;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                if (this.m_stack[0][_loc_6].getId() == _loc_3)
                {
                    _loc_4 = this.m_stack[0][_loc_6];
                    break;
                }
                _loc_6++;
            }
            if (_loc_4 == null)
            {
                return;
            }
            var _loc_7:String = this;
            var _loc_8:* = this.m_locks - 1;
            _loc_7.m_locks = _loc_8;
            if (_loc_4.decreaseLocks() == 0)
            {
                this.callListener(_loc_3);
                if (_loc_4.getRepeatCount() != 0)
                {
                    this.m_locks = this.m_locks + _loc_4.execute(this.m_id + ":" + _loc_3);
                }
                else if (this.m_locks == 0)
                {
                    this.nextCommand();
                }
                else
                {
                    this.m_stack[0].splice(_loc_6, 1);
                    _loc_4.clear();
                    this.unregisterListener(_loc_3);
                }
            }
            return;
        }// end function

        public function unshiftCommands(... args) : void
        {
            args = args.length;
            var _loc_3:int = 0;
            while (_loc_3 < args)
            {
                
                var _loc_4:String = this;
                _loc_4.m_idCounter = this.m_idCounter + 1;
                args[_loc_3].setId(this.m_idCounter++);
                _loc_3++;
            }
            if (this.m_framePause)
            {
                this.m_stack.unshift(args);
            }
            else if (this.m_stack.length == 0)
            {
                this.m_stack.push(args);
                this.startExecution();
            }
            else
            {
                this.m_stack.splice(1, 0, args);
            }
            return;
        }// end function

        private function callListener(Object:int) : void
        {
            if (this.m_listeners[Object] != null)
            {
                (this.m_listeners[Object] as Function).apply(null, this.m_listeners[Object + "args"]);
                this.unregisterListener(Object);
            }
            return;
        }// end function

        public function registerListener(Object:int, Object:Function, ... args) : void
        {
            this.m_listeners[Object] = Object;
            this.m_listeners[Object + "args"] = args;
            return;
        }// end function

        private function removeSoftCommands() : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:Boolean = false;
            var _loc_6:Array = null;
            var _loc_1:* = this.m_stack.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                if (_loc_2 < 0)
                {
                    return;
                }
                _loc_6 = this.m_stack[_loc_2] as Array;
                if (!_loc_6)
                {
                    return;
                }
                _loc_4 = _loc_6.length;
                _loc_5 = true;
                _loc_3 = 0;
                while (_loc_3 < _loc_4)
                {
                    
                    if (_loc_6[_loc_3].isCancelable())
                    {
                    }
                    else
                    {
                        _loc_5 = false;
                        break;
                    }
                    _loc_3++;
                }
                if (_loc_5)
                {
                    this.clearCommandSet(_loc_6, _loc_2 == 0);
                    this.m_stack.splice(_loc_2, 1);
                    _loc_2 = _loc_2 - 1;
                }
                _loc_2++;
            }
            return;
        }// end function

    }
}
