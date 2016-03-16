package com.playtech.casino3.slots.shared.data
{
    import com.playtech.casino3.slots.shared.utils.*;

    dynamic public class DisposableArray extends Array implements IDisposable
    {

        public function DisposableArray(com.playtech.casino3.slots.shared.data:DisposableArray:int = 0) : void
        {
            super(com.playtech.casino3.slots.shared.data:DisposableArray);
            return;
        }// end function

        public function insertElementFromArray(param1:Array, param2:int = 0, param3:Boolean = false) : int
        {
            insertArrayElementsIntoArray(param1, this, param2, param3);
            return length;
        }// end function

        public function clear() : void
        {
            splice(0);
            return;
        }// end function

        public function dispose() : void
        {
            splice(0);
            return;
        }// end function

    }
}
