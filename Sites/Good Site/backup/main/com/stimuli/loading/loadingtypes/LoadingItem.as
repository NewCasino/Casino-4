package com.stimuli.loading.loadingtypes
{
    import com.stimuli.loading.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class LoadingItem extends EventDispatcher
    {
        public var _type:String;
        public var url:URLRequest;
        public var _id:String;
        public var _uid:String;
        public var _additionIndex:int;
        public var _priority:int = 0;
        public var _isLoaded:Boolean;
        public var _isLoading:Boolean;
        public var status:String;
        public var maxTries:int = 3;
        public var numTries:int = 0;
        public var weight:int = 1;
        public var preventCache:Boolean;
        public var _bytesTotal:int = -1;
        public var _bytesLoaded:int = 0;
        public var _bytesRemaining:int = 10000000;
        public var _percentLoaded:Number;
        public var _weightPercentLoaded:Number;
        public var _addedTime:int;
        public var _startTime:int;
        public var _responseTime:Number;
        public var _latency:Number;
        public var _totalTime:int;
        public var _timeToDownload:int;
        public var _speed:Number;
        public var _content:Object;
        public var _httpStatus:int = -1;
        public var _context:Object = null;
        public var specificAvailableProps:Array;
        public var propertyParsingErrors:Array;
        public static const STATUS_STOPPED:String = "stopped";
        public static const STATUS_STARTED:String = "started";
        public static const STATUS_FINISHED:String = "finished";
        public static const STATUS_ERROR:String = "error";

        public function LoadingItem(param1:URLRequest, param2:String, param3:String)
        {
            this._type = param2;
            this.url = param1;
            if (!specificAvailableProps)
            {
                specificAvailableProps = [];
            }
            this._uid = param3;
            return;
        }// end function

        public function _parseOptions(param1:Object) : Array
        {
            var _loc_3:String = null;
            preventCache = param1[BulkLoader.PREVENT_CACHING];
            _id = param1[BulkLoader.ID];
            _priority = int(param1[BulkLoader.PRIORITY]) || 0;
            maxTries = param1[BulkLoader.MAX_TRIES] || 3;
            weight = int(param1[BulkLoader.WEIGHT]) || 1;
            var _loc_2:* = BulkLoader.GENERAL_AVAILABLE_PROPS.concat(specificAvailableProps);
            propertyParsingErrors = [];
            for (_loc_3 in param1)
            {
                
                if (_loc_2.indexOf(_loc_3) == -1)
                {
                    propertyParsingErrors.push(this + ": got a wrong property name: " + _loc_3 + ", with value:" + param1[_loc_3]);
                }
            }
            return propertyParsingErrors;
        }// end function

        public function get content()
        {
            return _content;
        }// end function

        public function load() : void
        {
            var _loc_1:String = null;
            if (preventCache)
            {
                _loc_1 = "BulkLoaderNoCache=" + _uid + "_" + int(Math.random() * 100 * getTimer());
                if (url.url.indexOf("?") == -1)
                {
                    url.url = url.url + ("?" + _loc_1);
                }
                else
                {
                    url.url = url.url + ("&" + _loc_1);
                }
            }
            _isLoading = true;
            _startTime = getTimer();
            return;
        }// end function

        public function onHttpStatusHandler(event:HTTPStatusEvent) : void
        {
            _httpStatus = event.status;
            dispatchEvent(event);
            return;
        }// end function

        public function onProgressHandler(param1) : void
        {
            _bytesLoaded = param1.bytesLoaded;
            _bytesTotal = param1.bytesTotal;
            _bytesRemaining = _bytesTotal - bytesLoaded;
            _percentLoaded = _bytesLoaded / _bytesTotal;
            _weightPercentLoaded = _percentLoaded * weight;
            dispatchEvent(param1);
            return;
        }// end function

        public function onCompleteHandler(event:Event) : void
        {
            _totalTime = getTimer();
            _timeToDownload = (_totalTime - _responseTime) / 1000;
            if (_timeToDownload == 0)
            {
                _timeToDownload = 0.2;
            }
            _speed = BulkLoader.truncateNumber(bytesTotal / 1024 / _timeToDownload);
            if (_timeToDownload == 0)
            {
                _speed = 3000;
            }
            status = STATUS_FINISHED;
            _isLoaded = true;
            dispatchEvent(event);
            event.stopPropagation();
            return;
        }// end function

        public function onErrorHandler(event:Event) : void
        {
            var _loc_2:BulkErrorEvent = null;
            var _loc_4:* = numTries + 1;
            numTries = _loc_4;
            status = STATUS_ERROR;
            event.stopPropagation();
            if (numTries >= maxTries)
            {
                _loc_2 = new BulkErrorEvent(BulkErrorEvent.ERROR);
                _loc_2.errors = [this];
                dispatchEvent(_loc_2);
            }
            else
            {
                status = null;
                load();
            }
            return;
        }// end function

        public function onSecurityErrorHandler(param1) : void
        {
            var _loc_2:SecurityErrorEvent = null;
            status = STATUS_ERROR;
            if (param1 is Event)
            {
                _loc_2 = param1;
                param1.stopPropagation();
            }
            else if (param1 is SecurityError)
            {
                _loc_2 = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR, false, true, param1.message);
            }
            _loc_2.stopPropagation();
            dispatchEvent(_loc_2);
            return;
        }// end function

        public function onStartedHandler(event:Event) : void
        {
            _responseTime = getTimer();
            _latency = BulkLoader.truncateNumber((_responseTime - _startTime) / 1000);
            status = STATUS_STARTED;
            dispatchEvent(event);
            return;
        }// end function

        override public function toString() : String
        {
            return "LoadingItem url: " + url.url + ", type:" + _type + ", status: " + status;
        }// end function

        public function stop() : void
        {
            if (_isLoaded)
            {
                return;
            }
            status = STATUS_STOPPED;
            _isLoading = false;
            return;
        }// end function

        public function cleanListeners() : void
        {
            return;
        }// end function

        public function isVideo() : Boolean
        {
            return false;
        }// end function

        public function isSound() : Boolean
        {
            return false;
        }// end function

        public function isText() : Boolean
        {
            return false;
        }// end function

        public function isXML() : Boolean
        {
            return false;
        }// end function

        public function isImage() : Boolean
        {
            return false;
        }// end function

        public function isSWF() : Boolean
        {
            return false;
        }// end function

        public function isLoader() : Boolean
        {
            return false;
        }// end function

        public function isStreamable() : Boolean
        {
            return false;
        }// end function

        public function destroy() : void
        {
            _content = null;
            return;
        }// end function

        public function get bytesTotal() : int
        {
            return _bytesTotal;
        }// end function

        public function get bytesLoaded() : int
        {
            return _bytesLoaded;
        }// end function

        public function get bytesRemaining() : int
        {
            return _bytesRemaining;
        }// end function

        public function get percentLoaded() : Number
        {
            return _percentLoaded;
        }// end function

        public function get weightPercentLoaded() : Number
        {
            return _weightPercentLoaded;
        }// end function

        public function get priority() : int
        {
            return _priority;
        }// end function

        public function get type() : String
        {
            return _type;
        }// end function

        public function get isLoaded() : Boolean
        {
            return _isLoaded;
        }// end function

        public function get addedTime() : int
        {
            return _addedTime;
        }// end function

        public function get startTime() : int
        {
            return _startTime;
        }// end function

        public function get responseTime() : Number
        {
            return _responseTime;
        }// end function

        public function get latency() : Number
        {
            return _latency;
        }// end function

        public function get totalTime() : int
        {
            return _totalTime;
        }// end function

        public function get timeToDownload() : int
        {
            return _timeToDownload;
        }// end function

        public function get speed() : Number
        {
            return _speed;
        }// end function

        public function get httpStatus() : int
        {
            return _httpStatus;
        }// end function

        public function get id() : String
        {
            return _id;
        }// end function

        public function getStats() : String
        {
            return "Item url:" + url.url + ", total time: " + _timeToDownload + "(s), latency:" + _latency + "(s), speed: " + _speed + " kb/s, size: " + BulkLoader.truncateNumber(_bytesTotal / 1024) + " kb";
        }// end function

    }
}
