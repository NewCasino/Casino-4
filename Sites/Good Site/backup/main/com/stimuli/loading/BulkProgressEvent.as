package com.stimuli.loading
{
    import flash.events.*;

    public class BulkProgressEvent extends ProgressEvent
    {
        public var bytesTotalCurrent:int;
        public var _ratioLoaded:Number;
        public var _percentLoaded:Number;
        public var _weightPercent:Number;
        public var itemsLoaded:int;
        public var itemsTotal:int;
        public var name:String;
        public static const PROGRESS:String = "progress";
        public static const COMPLETE:String = "complete";

        public function BulkProgressEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
        {
            super(param1, param2, param3);
            this.name = param1;
            return;
        }// end function

        public function setInfo(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Number) : void
        {
            this.bytesLoaded = param1;
            this.bytesTotal = param2;
            this.bytesTotalCurrent = param3;
            this.itemsLoaded = param4;
            this.itemsTotal = param5;
            this.weightPercent = param6;
            this.percentLoaded = param2 > 0 ? (param1 / param2) : (0);
            ratioLoaded = param5 == 0 ? (0) : (param4 / param5);
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new BulkProgressEvent(name, bubbles, cancelable);
            _loc_1.setInfo(bytesLoaded, bytesTotal, bytesTotalCurrent, itemsLoaded, itemsTotal, weightPercent);
            return _loc_1;
        }// end function

        public function loadingStatus() : String
        {
            var _loc_1:Array = [];
            _loc_1.push("bytesLoaded: " + bytesLoaded);
            _loc_1.push("bytesTotal: " + bytesTotal);
            _loc_1.push("itemsLoaded: " + itemsLoaded);
            _loc_1.push("itemsTotal: " + itemsTotal);
            _loc_1.push("bytesTotalCurrent: " + bytesTotalCurrent);
            _loc_1.push("percentLoaded: " + BulkLoader.truncateNumber(percentLoaded));
            _loc_1.push("weightPercent: " + BulkLoader.truncateNumber(weightPercent));
            _loc_1.push("ratioLoaded: " + BulkLoader.truncateNumber(ratioLoaded));
            return "BulkProgressEvent " + _loc_1.join(", ") + ";";
        }// end function

        public function get weightPercent() : Number
        {
            return _weightPercent;
        }// end function

        public function set weightPercent(param1:Number) : void
        {
            if (isNaN(param1) || !isFinite(param1))
            {
                param1 = 0;
            }
            _weightPercent = param1;
            return;
        }// end function

        public function get percentLoaded() : Number
        {
            return _percentLoaded;
        }// end function

        public function set percentLoaded(param1:Number) : void
        {
            if (isNaN(param1) || !isFinite(param1))
            {
                param1 = 0;
            }
            _percentLoaded = param1;
            return;
        }// end function

        public function get ratioLoaded() : Number
        {
            return _ratioLoaded;
        }// end function

        public function set ratioLoaded(param1:Number) : void
        {
            if (isNaN(param1) || !isFinite(param1))
            {
                param1 = 0;
            }
            _ratioLoaded = param1;
            return;
        }// end function

        override public function toString() : String
        {
            return super.toString();
        }// end function

    }
}
