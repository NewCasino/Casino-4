package com.stimuli.loading
{
    import com.stimuli.loading.loadingtypes.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class BulkLoader extends EventDispatcher
    {
        public var _name:String;
        public var _id:int;
        public var _items:Array;
        public var _contents:Dictionary;
        public var _additionIndex:int = 0;
        public var _numConnections:int = 7;
        public var _connections:Array;
        public var _loadedRatio:Number = 0;
        public var _itemsTotal:int = 0;
        public var _itemsLoaded:int = 0;
        public var _totalWeight:int = 0;
        public var _bytesTotal:int = 0;
        public var _bytesTotalCurrent:int = 0;
        public var _bytesLoaded:int = 0;
        public var _percentLoaded:Number = 0;
        public var _weightPercent:Number;
        public var avgLatency:Number;
        public var speedAvg:Number;
        public var _speedTotal:Number;
        public var _startTime:int;
        public var _endTIme:int;
        public var _lastSpeedCheck:int;
        public var _lastBytesCheck:int;
        public var _speed:Number;
        public var totalTime:Number;
        public var logLevel:int = 4;
        public var _allowsAutoIDFromFileName:Boolean = false;
        public var _isRunning:Boolean;
        public var _isFinished:Boolean;
        public var _isPaused:Boolean = true;
        public var _logFunction:Function;
        public var _stringSubstitutions:Object;
        public static const VERSION:String = "$Id: BulkLoader.as 219 2008-08-05 03:48:56Z debert $";
        public static const TYPE_BINARY:String = "binary";
        public static const TYPE_IMAGE:String = "image";
        public static const TYPE_MOVIECLIP:String = "movieclip";
        public static const TYPE_SOUND:String = "sound";
        public static const TYPE_TEXT:String = "text";
        public static const TYPE_XML:String = "xml";
        public static const TYPE_VIDEO:String = "video";
        public static const AVAILABLE_TYPES:Array = [TYPE_VIDEO, TYPE_XML, TYPE_TEXT, TYPE_SOUND, TYPE_MOVIECLIP, TYPE_IMAGE, TYPE_BINARY];
        public static var AVAILABLE_EXTENSIONS:Array = ["swf", "jpg", "jpeg", "gif", "png", "flv", "mp3", "xml", "txt", "js"];
        public static var IMAGE_EXTENSIONS:Array = ["jpg", "jpeg", "gif", "png"];
        public static var MOVIECLIP_EXTENSIONS:Array = ["swf"];
        public static var TEXT_EXTENSIONS:Array = ["txt", "js", "php", "asp", "py"];
        public static var VIDEO_EXTENSIONS:Array = ["flv", "f4v", "f4p"];
        public static var SOUND_EXTENSIONS:Array = ["mp3", "f4a", "f4b"];
        public static var XML_EXTENSIONS:Array = ["xml"];
        public static var _customTypesExtensions:Object;
        public static const PROGRESS:String = "progress";
        public static const COMPLETE:String = "complete";
        public static const HTTP_STATUS:String = "httpStatus";
        public static const ERROR:String = "error";
        public static const SECURITY_ERROR:String = "securityError";
        public static const OPEN:String = "open";
        public static const CAN_BEGIN_PLAYING:String = "canBeginPlaying";
        public static const CHECK_POLICY_FILE:String = "checkPolicyFile";
        public static const PREVENT_CACHING:String = "preventCache";
        public static const HEADERS:String = "headers";
        public static const CONTEXT:String = "context";
        public static const ID:String = "id";
        public static const PRIORITY:String = "priority";
        public static const MAX_TRIES:String = "maxTries";
        public static const WEIGHT:String = "weight";
        public static const PAUSED_AT_START:String = "pausedAtStart";
        public static const GENERAL_AVAILABLE_PROPS:Array = [WEIGHT, MAX_TRIES, HEADERS, ID, PRIORITY, PREVENT_CACHING, "type"];
        public static var _instancesCreated:int = 0;
        public static var _allLoaders:Object = {};
        public static const DEFAULT_NUM_CONNECTIONS:int = 7;
        public static const LOG_VERBOSE:int = 0;
        public static const LOG_INFO:int = 2;
        public static const LOG_WARNINGS:int = 3;
        public static const LOG_ERRORS:int = 4;
        public static const LOG_SILENT:int = 10;
        public static const DEFAULT_LOG_LEVEL:int = 4;
        public static var _typeClasses:Object = {image:ImageItem, movieclip:ImageItem, xml:XMLItem, video:VideoItem, sound:SoundItem, text:URLItem, binary:BinaryItem};

        public function BulkLoader(param1:String, param2:int = 7, param3:int = 4)
        {
            _items = [];
            _contents = new Dictionary();
            _logFunction = trace;
            if (Boolean(_allLoaders[param1]))
            {
                __debug_print_loaders();
                throw new Error("BulkLoader with name\'" + param1 + "\' has already been created.");
            }
            if (!param1)
            {
                throw new Error("Cannot create a BulkLoader instance without a name");
            }
            _allLoaders[param1] = this;
            if (param2 > 0)
            {
                this._numConnections = param2;
            }
            this.logLevel = param3;
            _name = param1;
            var _loc_5:* = _instancesCreated + 1;
            _instancesCreated = _loc_5;
            _id = _instancesCreated;
            _additionIndex = 0;
            return;
        }// end function

        public function hasItem(param1, param2:Boolean = true) : Boolean
        {
            var _loc_3:* = undefined;
            var _loc_4:BulkLoader = null;
            if (param2)
            {
                _loc_3 = _allLoaders;
            }
            else
            {
                _loc_3 = [this];
            }
            for each (_loc_4 in _loc_3)
            {
                
                if (_hasItemInBulkLoader(param1, _loc_4))
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function add(param1, param2:Object = null) : LoadingItem
        {
            var _loc_4:String = null;
            var _loc_6:String = null;
            if (!_name)
            {
                throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
            }
            if (!param1 || !String(param1))
            {
                throw new Error("[BulkLoader] Cannot add an item with a null url");
            }
            param2 = param2 || {};
            if (param1 is String)
            {
                param1 = new URLRequest(BulkLoader.substituteURLString(param1, _stringSubstitutions));
                if (param2[HEADERS])
                {
                    param1.requestHeaders = param2[HEADERS];
                }
            }
            else if (!param1 is URLRequest)
            {
                throw new Error("[BulkLoader] cannot add object with bad type for url:\'" + param1.url);
            }
            var _loc_3:* = get(param2[ID]);
            if (_loc_3)
            {
                log("Add received an already added id: " + param2[ID] + ", not adding a new item");
                return _loc_3;
            }
            if (param2["type"])
            {
                _loc_4 = param2["type"].toLowerCase();
                if (AVAILABLE_TYPES.indexOf(_loc_4) == -1)
                {
                    log("add received an unknown type:", _loc_4, "and will cast it to text", LOG_WARNINGS);
                }
            }
            if (!_loc_4)
            {
                _loc_4 = guessType(param1.url);
            }
            var _loc_8:* = _additionIndex + 1;
            _additionIndex = _loc_8;
            _loc_3 = new _typeClasses[_loc_4](param1, _loc_4, _instancesCreated + "_" + String(_additionIndex));
            if (!param2["id"] && _allowsAutoIDFromFileName)
            {
                param2["id"] = getFileName(param1.url);
                log("Adding automatic id from file name for item:", _loc_3, "( id= " + param2["id"] + " )");
            }
            var _loc_5:* = _loc_3._parseOptions(param2);
            for each (_loc_6 in _loc_5)
            {
                
                log(_loc_6, LOG_WARNINGS);
            }
            log("Added", _loc_3, LOG_VERBOSE);
            _loc_3._addedTime = getTimer();
            _loc_3._additionIndex = _additionIndex;
            _loc_3.addEventListener(Event.COMPLETE, _onItemComplete, false, int.MIN_VALUE, true);
            _loc_3.addEventListener(ERROR, _onItemError, false, 0, true);
            _loc_3.addEventListener(Event.OPEN, _onItemStarted, false, 0, true);
            _loc_3.addEventListener(ProgressEvent.PROGRESS, _onProgress, false, 0, true);
            _loc_3.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onItemSecurityError, false, 0, true);
            _items.push(_loc_3);
            (_itemsTotal + 1);
            _totalWeight = _totalWeight + _loc_3.weight;
            sortItemsByPriority();
            _isFinished = false;
            if (!_isPaused)
            {
                _loadNext();
            }
            return _loc_3;
        }// end function

        public function start(param1:int = -1) : void
        {
            if (param1 > 0)
            {
                _numConnections = param1;
            }
            if (_connections)
            {
                _loadNext();
                return;
            }
            _startTime = getTimer();
            _connections = [];
            _loadNext();
            _isRunning = true;
            _lastBytesCheck = 0;
            _lastSpeedCheck = getTimer();
            _isPaused = false;
            return;
        }// end function

        public function reload(param1) : Boolean
        {
            var _loc_2:LoadingItem = null;
            if (param1 is LoadingItem)
            {
                _loc_2 = param1;
            }
            else
            {
                _loc_2 = get(param1);
            }
            if (!_loc_2)
            {
                return false;
            }
            _removeFromItems(_loc_2);
            _removeFromConnections(_loc_2);
            _loc_2.stop();
            _loc_2.cleanListeners();
            _loc_2.status = null;
            _isFinished = false;
            _loc_2._addedTime = getTimer();
            _loc_2._additionIndex = _additionIndex + 1;
            _loc_2.addEventListener(Event.COMPLETE, _onItemComplete, false, int.MIN_VALUE, true);
            _loc_2.addEventListener(ERROR, _onItemError, false, 0, true);
            _loc_2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onItemSecurityError, false, 0, true);
            _loc_2.addEventListener(Event.OPEN, _onItemStarted, false, 0, true);
            _loc_2.addEventListener(ProgressEvent.PROGRESS, _onProgress, false, 0, true);
            _items.push(_loc_2);
            (_itemsTotal + 1);
            _totalWeight = _totalWeight + _loc_2.weight;
            sortItemsByPriority();
            _isFinished = false;
            loadNow(_loc_2);
            return true;
        }// end function

        public function loadNow(param1) : Boolean
        {
            var _loc_2:LoadingItem = null;
            var _loc_3:LoadingItem = null;
            if (param1 is LoadingItem)
            {
                _loc_2 = param1;
            }
            else
            {
                _loc_2 = get(param1);
            }
            if (!_loc_2)
            {
                return false;
            }
            if (!_connections)
            {
                _connections = [];
            }
            if (_loc_2.status == LoadingItem.STATUS_FINISHED || _loc_2.status == LoadingItem.STATUS_STARTED)
            {
                return true;
            }
            if (_connections.length >= numConnections)
            {
                _loc_3 = _getLeastUrgentOpenedItem();
                _removeFromConnections(_loc_3);
                _loc_3.status = null;
            }
            _loc_2._priority = highestPriority;
            _loadNext(_loc_2);
            return true;
        }// end function

        public function _getLeastUrgentOpenedItem() : LoadingItem
        {
            var _loc_1:* = LoadingItem(_connections.sortOn(["priority", "bytesRemaining", "_additionIndex"], [Array.NUMERIC, Array.DESCENDING, Array.NUMERIC, Array.NUMERIC])[0]);
            return _loc_1;
        }// end function

        public function _loadNext(param1:LoadingItem = null) : Boolean
        {
            var checkItem:LoadingItem;
            var toLoad:* = param1;
            if (_isFinished)
            {
                return false;
            }
            if (!_connections)
            {
                _connections = [];
            }
            _connections.forEach(function (param1:LoadingItem, ... args) : void
            {
                if (param1.status == LoadingItem.STATUS_ERROR && param1.numTries < param1.maxTries)
                {
                    _removeFromConnections(param1);
                }
                return;
            }// end function
            );
            var next:Boolean;
            if (!toLoad)
            {
                var _loc_3:int = 0;
                var _loc_4:* = _items;
                while (_loc_4 in _loc_3)
                {
                    
                    checkItem = _loc_4[_loc_3];
                    if (!checkItem._isLoading && checkItem.status != LoadingItem.STATUS_STOPPED)
                    {
                        toLoad = checkItem;
                        break;
                    }
                }
            }
            if (toLoad)
            {
                next;
                _isRunning = true;
                if (_connections.length < numConnections)
                {
                    _connections.push(toLoad);
                    toLoad.load();
                    log("Will load item:", toLoad, LOG_INFO);
                }
                if (_connections.length < numConnections)
                {
                    _loadNext();
                }
            }
            return next;
        }// end function

        public function _onItemComplete(event:Event) : void
        {
            var _loc_2:* = event.target as LoadingItem;
            _removeFromConnections(_loc_2);
            log("Loaded ", _loc_2, LOG_INFO);
            log("Items to load", getNotLoadedItems(), LOG_VERBOSE);
            _loc_2.cleanListeners();
            _contents[_loc_2.url.url] = _loc_2.content;
            var _loc_3:* = _loadNext();
            var _loc_4:* = _isAllDoneP();
            var _loc_6:* = _itemsLoaded + 1;
            _itemsLoaded = _loc_6;
            if (_loc_4)
            {
                _onAllLoaded();
            }
            return;
        }// end function

        public function _updateStats() : void
        {
            var _loc_4:LoadingItem = null;
            avgLatency = 0;
            speedAvg = 0;
            var _loc_1:Number = 0;
            var _loc_2:int = 0;
            _speedTotal = 0;
            var _loc_3:Number = 0;
            for each (_loc_4 in _items)
            {
                
                if (_loc_4._isLoaded && _loc_4.status != LoadingItem.STATUS_ERROR)
                {
                    _loc_1 = _loc_1 + _loc_4.latency;
                    _loc_2 = _loc_2 + _loc_4.bytesTotal;
                    _loc_3 = _loc_3 + 1;
                }
            }
            _speedTotal = _loc_2 / 1024 / totalTime;
            avgLatency = _loc_1 / _loc_3;
            speedAvg = _speedTotal / _loc_3;
            return;
        }// end function

        public function _removeFromItems(param1:LoadingItem) : Boolean
        {
            var _loc_2:* = _items.indexOf(param1);
            if (_loc_2 > -1)
            {
                _items.splice(_loc_2, 1);
            }
            else
            {
                return false;
            }
            if (param1._isLoaded)
            {
                var _loc_4:* = _itemsLoaded - 1;
                _itemsLoaded = _loc_4;
            }
            var _loc_4:* = _itemsTotal - 1;
            _itemsTotal = _loc_4;
            _totalWeight = _totalWeight - param1.weight;
            log("Removing " + param1, LOG_VERBOSE);
            param1.removeEventListener(Event.COMPLETE, _onItemComplete, false);
            param1.removeEventListener(ERROR, _onItemError, false);
            param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onItemSecurityError, false);
            param1.removeEventListener(Event.OPEN, _onItemStarted, false);
            param1.removeEventListener(ProgressEvent.PROGRESS, _onProgress, false);
            return true;
        }// end function

        public function _removeFromConnections(param1) : Boolean
        {
            if (!_connections)
            {
                return false;
            }
            var _loc_2:* = _connections.indexOf(param1);
            if (_loc_2 > -1)
            {
                _connections.splice(_loc_2, 1);
                return true;
            }
            return false;
        }// end function

        public function _onItemError(event:BulkErrorEvent) : void
        {
            var evt:* = event;
            var item:* = evt.target as LoadingItem;
            log("After " + item.numTries + " I am giving up on " + item.url.url, LOG_ERRORS);
            log("Error loading", item, LOG_ERRORS);
            _removeFromConnections(item);
            evt.stopPropagation();
            var bulkErrorEvent:* = new BulkErrorEvent(BulkErrorEvent.ERROR);
            bulkErrorEvent.errors = _items.filter(function (param1:LoadingItem, ... args) : Boolean
            {
                return param1.status == LoadingItem.STATUS_ERROR;
            }// end function
            );
            dispatchEvent(bulkErrorEvent);
            return;
        }// end function

        public function _onItemSecurityError(event:SecurityErrorEvent) : void
        {
            var _loc_2:* = event.target as LoadingItem;
            log("Security error loading", event, LOG_ERRORS);
            _removeFromConnections(_loc_2);
            event.stopPropagation();
            dispatchEvent(event.clone());
            return;
        }// end function

        public function _onItemStarted(event:Event) : void
        {
            var _loc_2:* = event.target as LoadingItem;
            log("Started loading", _loc_2, LOG_INFO);
            dispatchEvent(event);
            return;
        }// end function

        public function _onProgress(event:Event = null) : void
        {
            var _loc_2:* = getProgressForItems(_items);
            _bytesLoaded = _loc_2.bytesLoaded;
            _bytesTotal = _loc_2.bytesTotal;
            _weightPercent = _loc_2.weightPercent;
            _percentLoaded = _loc_2.percentLoaded;
            _bytesTotalCurrent = _loc_2.bytesTotalCurrent;
            _loadedRatio = _loc_2.ratioLoaded;
            dispatchEvent(_loc_2);
            return;
        }// end function

        public function getProgressForItems(param1:Array) : BulkProgressEvent
        {
            var _loc_11:LoadingItem = null;
            var _loc_13:* = undefined;
            var _loc_15:int = 0;
            _bytesTotalCurrent = 0;
            var _loc_15:* = _loc_15;
            _bytesTotal = _loc_15;
            _bytesLoaded = _loc_15;
            var _loc_2:Number = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:Number = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_12:Array = [];
            for each (_loc_13 in param1)
            {
                
                _loc_11 = _loc_13 is LoadingItem ? (_loc_13) : (get(_loc_13));
                if (!_loc_11)
                {
                    continue;
                }
                _loc_6++;
                _loc_3 = _loc_3 + _loc_11.weight;
                if (_loc_11.status == LoadingItem.STATUS_STARTED || _loc_11.status == LoadingItem.STATUS_FINISHED || _loc_11.status == LoadingItem.STATUS_STOPPED)
                {
                    _loc_8 = _loc_8 + _loc_11._bytesLoaded;
                    _loc_10 = _loc_10 + _loc_11._bytesTotal;
                    _loc_5 = _loc_5 + _loc_11._bytesLoaded / _loc_11._bytesTotal * _loc_11.weight;
                    if (_loc_11.status == LoadingItem.STATUS_FINISHED)
                    {
                        _loc_7++;
                    }
                    _loc_4++;
                }
            }
            if (_loc_4 != _loc_6)
            {
                _loc_9 = Number.POSITIVE_INFINITY;
            }
            else
            {
                _loc_9 = _loc_10;
            }
            _loc_2 = _loc_5 / _loc_3;
            if (_loc_3 == 0)
            {
                _loc_2 = 0;
            }
            var _loc_14:* = new BulkProgressEvent(PROGRESS);
            new BulkProgressEvent(PROGRESS).setInfo(_loc_8, _loc_9, _loc_9, _loc_7, _loc_6, _loc_2);
            return _loc_14;
        }// end function

        public function get numConnections() : int
        {
            return _numConnections;
        }// end function

        public function get contents() : Object
        {
            return _contents;
        }// end function

        public function get items() : Array
        {
            return _items.slice();
        }// end function

        public function get name() : String
        {
            return _name;
        }// end function

        public function get loadedRatio() : Number
        {
            return _loadedRatio;
        }// end function

        public function get itemsTotal() : int
        {
            return items.length;
        }// end function

        public function get itemsLoaded() : int
        {
            return _itemsLoaded;
        }// end function

        public function set itemsLoaded(param1:int) : void
        {
            _itemsLoaded = param1;
            return;
        }// end function

        public function get totalWeight() : int
        {
            return _totalWeight;
        }// end function

        public function get bytesTotal() : int
        {
            return _bytesTotal;
        }// end function

        public function get bytesLoaded() : int
        {
            return _bytesLoaded;
        }// end function

        public function get bytesTotalCurrent() : int
        {
            return _bytesTotalCurrent;
        }// end function

        public function get percentLoaded() : Number
        {
            return _percentLoaded;
        }// end function

        public function get weightPercent() : Number
        {
            return _weightPercent;
        }// end function

        public function get isRunning() : Boolean
        {
            return _isRunning;
        }// end function

        public function get isFinished() : Boolean
        {
            return _isFinished;
        }// end function

        public function get highestPriority() : int
        {
            var _loc_2:LoadingItem = null;
            var _loc_1:* = int.MIN_VALUE;
            for each (_loc_2 in _items)
            {
                
                if (_loc_2.priority > _loc_1)
                {
                    _loc_1 = _loc_2.priority;
                }
            }
            return _loc_1;
        }// end function

        public function get logFunction() : Function
        {
            return _logFunction;
        }// end function

        public function get allowsAutoIDFromFileName() : Boolean
        {
            return _allowsAutoIDFromFileName;
        }// end function

        public function set allowsAutoIDFromFileName(param1:Boolean) : void
        {
            _allowsAutoIDFromFileName = param1;
            return;
        }// end function

        public function getNotLoadedItems() : Array
        {
            return _items.filter(function (param1:LoadingItem, ... args) : Boolean
            {
                return param1.status != LoadingItem.STATUS_FINISHED;
            }// end function
            );
        }// end function

        public function get speed() : Number
        {
            var _loc_1:* = getTimer() - _lastSpeedCheck;
            var _loc_2:* = (bytesLoaded - _lastBytesCheck) / 1024;
            var _loc_3:* = _loc_2 / (_loc_1 / 1000);
            _lastSpeedCheck = _loc_1;
            _lastBytesCheck = bytesLoaded;
            return _loc_3;
        }// end function

        public function set logFunction(param1:Function) : void
        {
            _logFunction = param1;
            return;
        }// end function

        public function get id() : int
        {
            return _id;
        }// end function

        public function get stringSubstitutions() : Object
        {
            return _stringSubstitutions;
        }// end function

        public function set stringSubstitutions(param1:Object) : void
        {
            _stringSubstitutions = param1;
            return;
        }// end function

        public function changeItemPriority(param1:String, param2:int) : Boolean
        {
            var _loc_3:* = get(param1);
            if (!_loc_3)
            {
                return false;
            }
            _loc_3._priority = param2;
            sortItemsByPriority();
            return true;
        }// end function

        public function sortItemsByPriority() : void
        {
            _items.sortOn(["priority", "_additionIndex"], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC]);
            return;
        }// end function

        public function _getContentAsType(param1, param2:Class, param3:Boolean = false)
        {
            var res:*;
            var key:* = param1;
            var type:* = param2;
            var clearMemory:* = param3;
            if (!_name)
            {
                throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
            }
            var item:* = get(key);
            if (!item)
            {
                return null;
            }
            try
            {
                if (item._isLoaded || item.isStreamable() && item.status == LoadingItem.STATUS_STARTED)
                {
                    res = item.content as type;
                    if (res == null)
                    {
                        throw new Error("bad cast");
                    }
                    if (clearMemory)
                    {
                        remove(key);
                    }
                    return res;
                }
            }
            catch (e:Error)
            {
                log("Failed to get content with url: \'" + key + "\'as type:", type, LOG_ERRORS);
            }
            return null;
        }// end function

        public function getContent(param1:String, param2:Boolean = false)
        {
            return _getContentAsType(param1, Object, param2);
        }// end function

        public function getXML(param1, param2:Boolean = false) : XML
        {
            return XML(_getContentAsType(param1, XML, param2));
        }// end function

        public function getText(param1, param2:Boolean = false) : String
        {
            return String(_getContentAsType(param1, String, param2));
        }// end function

        public function getSound(param1, param2:Boolean = false) : Sound
        {
            return Sound(_getContentAsType(param1, Sound, param2));
        }// end function

        public function getBitmap(param1:String, param2:Boolean = false) : Bitmap
        {
            return Bitmap(_getContentAsType(param1, Bitmap, param2));
        }// end function

        public function getDisplayObjectLoader(param1:String, param2:Boolean = false) : Loader
        {
            return Loader(_getContentAsType(param1, Loader, param2));
        }// end function

        public function getMovieClip(param1:String, param2:Boolean = false) : MovieClip
        {
            return MovieClip(_getContentAsType(param1, MovieClip, param2));
        }// end function

        public function getAVM1Movie(param1:String, param2:Boolean = false) : AVM1Movie
        {
            return AVM1Movie(_getContentAsType(param1, AVM1Movie, param2));
        }// end function

        public function getNetStream(param1:String, param2:Boolean = false) : NetStream
        {
            return NetStream(_getContentAsType(param1, NetStream, param2));
        }// end function

        public function getNetStreamMetaData(param1:String, param2:Boolean = false) : Object
        {
            var _loc_3:* = getNetStream(param1, param2);
            return Boolean(_loc_3) ? ((get(param1) as Object).metaData) : (null);
        }// end function

        public function getBitmapData(param1, param2:Boolean = false) : BitmapData
        {
            var key:* = param1;
            var clearMemory:* = param2;
            try
            {
                return getBitmap(key, clearMemory).bitmapData;
            }
            catch (e:Error)
            {
                log("Failed to get bitmapData with url:", key, LOG_ERRORS);
            }
            return null;
        }// end function

        public function getBinary(param1, param2:Boolean = false) : ByteArray
        {
            return ByteArray(_getContentAsType(param1, ByteArray, param2));
        }// end function

        public function getSerializedData(param1, param2:Boolean = false, param3:Function = null)
        {
            var raw:*;
            var parsed:*;
            var key:* = param1;
            var clearMemory:* = param2;
            var encodingFunction:* = param3;
            try
            {
                raw = _getContentAsType(key, Object, clearMemory);
                parsed = encodingFunction.apply(null, [raw]);
                return parsed;
            }
            catch (e:Error)
            {
                log("Failed to parse key:", key, "with encodingFunction:" + encodingFunction, LOG_ERRORS);
            }
            return null;
        }// end function

        public function getHttpStatus(param1) : int
        {
            var _loc_2:* = get(param1);
            if (_loc_2)
            {
                return _loc_2.httpStatus;
            }
            return -1;
        }// end function

        public function _isAllDoneP() : Boolean
        {
            return _items.every(function (param1:LoadingItem, ... args) : Boolean
            {
                return param1._isLoaded;
            }// end function
            );
        }// end function

        public function _onAllLoaded() : void
        {
            if (_isFinished)
            {
                return;
            }
            var _loc_1:* = new BulkProgressEvent(COMPLETE);
            _loc_1.setInfo(bytesLoaded, bytesTotal, bytesTotalCurrent, _itemsLoaded, itemsTotal, weightPercent);
            var _loc_2:* = new BulkProgressEvent(PROGRESS);
            _loc_2.setInfo(bytesLoaded, bytesTotal, bytesTotalCurrent, _itemsLoaded, itemsTotal, weightPercent);
            _isRunning = false;
            _endTIme = getTimer();
            totalTime = BulkLoader.truncateNumber((_endTIme - _startTime) / 1000);
            _updateStats();
            _connections = [];
            getStats();
            _isFinished = true;
            log("Finished all", LOG_INFO);
            dispatchEvent(_loc_2);
            dispatchEvent(_loc_1);
            return;
        }// end function

        public function getStats() : String
        {
            var stats:Array;
            stats.push("\n************************************");
            stats.push("All items loaded(" + itemsTotal + ")");
            stats.push("Total time(s):       " + totalTime);
            stats.push("Average latency(s):  " + truncateNumber(avgLatency));
            stats.push("Average speed(kb/s): " + truncateNumber(speedAvg));
            stats.push("Median speed(kb/s):  " + truncateNumber(_speedTotal));
            stats.push("KiloBytes total:     " + truncateNumber(bytesTotal / 1024));
            var itemsInfo:* = _items.map(function (param1:LoadingItem, ... args) : String
            {
                return "\t" + param1.getStats();
            }// end function
            );
            stats.push(itemsInfo.join("\n"));
            stats.push("************************************");
            var statsString:* = stats.join("\n");
            log(statsString, LOG_VERBOSE);
            return statsString;
        }// end function

        public function log(... args) : void
        {
            args = isNaN(args[(args.length - 1)]) ? (3) : (int(args.pop()));
            if (args >= logLevel)
            {
                _logFunction("[BulkLoader] " + args.join(" "));
            }
            return;
        }// end function

        public function get(param1) : LoadingItem
        {
            var _loc_2:LoadingItem = null;
            if (!param1)
            {
                return null;
            }
            for each (_loc_2 in _items)
            {
                
                if (_loc_2._id == param1 || _loc_2.url.url == param1 || _loc_2.url == param1 || param1 is URLRequest && _loc_2.url.url == param1.url)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function remove(param1) : Boolean
        {
            var item:LoadingItem;
            var allDone:Boolean;
            var key:* = param1;
            try
            {
                if (key is LoadingItem)
                {
                    item = key;
                }
                else
                {
                    item = get(key);
                }
                if (!item)
                {
                    return false;
                }
                _removeFromItems(item);
                _removeFromConnections(item);
                item.destroy();
                item;
                _onProgress();
                allDone = _isAllDoneP();
                if (allDone)
                {
                    _onAllLoaded();
                }
                return true;
            }
            catch (e:Error)
            {
                log("Error while removing item from key:" + key, e.getStackTrace(), LOG_ERRORS);
            }
            return false;
        }// end function

        public function removeAll() : void
        {
            var _loc_1:LoadingItem = null;
            for each (_loc_1 in _items.slice())
            {
                
                remove(_loc_1);
            }
            _items = [];
            _connections = [];
            _contents = new Dictionary();
            return;
        }// end function

        public function clear() : void
        {
            removeAll();
            delete _allLoaders[name];
            _name = null;
            return;
        }// end function

        public function removePausedItems() : Boolean
        {
            var stoppedLoads:* = _items.filter(function (param1:LoadingItem, ... args) : Boolean
            {
                return param1.status == LoadingItem.STATUS_STOPPED;
            }// end function
            );
            stoppedLoads.forEach(function (param1:LoadingItem, ... args) : void
            {
                remove(param1);
                return;
            }// end function
            );
            _loadNext();
            return stoppedLoads.length > 0;
        }// end function

        public function removeFailedItems() : int
        {
            var numCleared:int;
            var badItems:* = _items.filter(function (param1:LoadingItem, ... args) : Boolean
            {
                return param1.status == LoadingItem.STATUS_ERROR;
            }// end function
            );
            numCleared = badItems.length;
            badItems.forEach(function (param1:LoadingItem, ... args) : void
            {
                remove(param1);
                return;
            }// end function
            );
            _loadNext();
            return numCleared;
        }// end function

        public function pause(param1, param2:Boolean = false) : Boolean
        {
            var _loc_3:* = param1 is LoadingItem ? (param1) : (get(param1));
            if (!_loc_3)
            {
                return false;
            }
            if (_loc_3.status != LoadingItem.STATUS_FINISHED)
            {
                _loc_3.stop();
            }
            log("STOPPED ITEM:", _loc_3, LOG_INFO);
            var _loc_4:* = _removeFromConnections(_loc_3);
            if (param2)
            {
                _loadNext();
            }
            return _loc_4;
        }// end function

        public function pauseAll() : void
        {
            var _loc_1:LoadingItem = null;
            for each (_loc_1 in _items)
            {
                
                pause(_loc_1);
            }
            _isRunning = false;
            _isPaused = true;
            log("Stopping all items", LOG_INFO);
            return;
        }// end function

        public function resume(param1) : Boolean
        {
            var _loc_2:* = param1 is LoadingItem ? (param1) : (get(param1));
            _isPaused = false;
            if (_loc_2 && _loc_2.status == LoadingItem.STATUS_STOPPED)
            {
                _loc_2.status = null;
                _loadNext();
                return true;
            }
            return false;
        }// end function

        public function resumeAll() : Boolean
        {
            log("Resuming all items", LOG_VERBOSE);
            var affected:Boolean;
            _items.forEach(function (param1:LoadingItem, ... args) : void
            {
                if (param1.status == LoadingItem.STATUS_STOPPED)
                {
                    resume(param1);
                    affected = true;
                }
                return;
            }// end function
            );
            _loadNext();
            return affected;
        }// end function

        override public function toString() : String
        {
            return "[BulkLoader] name:" + name + ", itemsTotal: " + itemsTotal + ", itemsLoaded: " + _itemsLoaded;
        }// end function

        public static function createUniqueNamedLoader(param1:int = 7, param2:int = 4) : BulkLoader
        {
            return new BulkLoader(BulkLoader.getUniqueName(), param1, param2);
        }// end function

        public static function getUniqueName() : String
        {
            return "BulkLoader-" + _instancesCreated;
        }// end function

        public static function getLoader(param1:String) : BulkLoader
        {
            return BulkLoader._allLoaders[param1] as BulkLoader;
        }// end function

        public static function _hasItemInBulkLoader(param1, param2:BulkLoader) : Boolean
        {
            var _loc_3:* = param2.get(param1);
            if (_loc_3)
            {
                return true;
            }
            return false;
        }// end function

        public static function whichLoaderHasItem(param1) : BulkLoader
        {
            var _loc_2:BulkLoader = null;
            for each (_loc_2 in _allLoaders)
            {
                
                if (BulkLoader._hasItemInBulkLoader(param1, _loc_2))
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public static function registerNewType(param1:String, param2:String, param3:Class) : Boolean
        {
            var _loc_4:Array = null;
            if (param1.charAt(0) == ".")
            {
                param1 = param1.substring(1);
            }
            if (AVAILABLE_TYPES.indexOf(param2) == -1)
            {
                if (!Boolean(param3))
                {
                    throw new Error("[BulkLoader]: When adding a new type and extension, you must determine which class to use");
                }
                _typeClasses[param2] = param3;
                if (!_customTypesExtensions)
                {
                    _customTypesExtensions = {};
                }
                if (!_customTypesExtensions[param2])
                {
                    _customTypesExtensions[param2] = [];
                    AVAILABLE_TYPES.push(param2);
                }
                _customTypesExtensions[param2].push(param1);
                return true;
            }
            else
            {
                _customTypesExtensions[param2].push(param1);
            }
            var _loc_5:Object = {IMAGE_EXTENSIONS:TYPE_IMAGE, VIDEO_EXTENSIONS:TYPE_VIDEO, SOUND_EXTENSIONS:TYPE_SOUND, TEXT_EXTENSIONS:TYPE_TEXT};
            _loc_4 = {IMAGE_EXTENSIONS:TYPE_IMAGE, VIDEO_EXTENSIONS:TYPE_VIDEO, SOUND_EXTENSIONS:TYPE_SOUND, TEXT_EXTENSIONS:TYPE_TEXT}[param2];
            if (_loc_4 && _loc_4.indexOf(param1) == -1)
            {
                _loc_4.push(param1);
                return true;
            }
            return false;
        }// end function

        public static function removeAllLoaders() : void
        {
            var _loc_1:BulkLoader = null;
            for each (_loc_1 in _allLoaders)
            {
                
                _loc_1.removeAll();
                _loc_1.clear();
                _loc_1 = null;
            }
            _allLoaders = {};
            return;
        }// end function

        public static function pauseAllLoaders() : void
        {
            var _loc_1:BulkLoader = null;
            for each (_loc_1 in _allLoaders)
            {
                
                _loc_1.pauseAll();
            }
            return;
        }// end function

        public static function truncateNumber(param1:Number, param2:int = 2) : Number
        {
            var _loc_3:* = Math.pow(10, param2);
            return Math.round(param1 * _loc_3) / _loc_3;
        }// end function

        public static function guessType(param1:String) : String
        {
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_2:* = param1.indexOf("?") > -1 ? (param1.substring(0, param1.indexOf("?"))) : (param1);
            var _loc_3:* = _loc_2.substring((_loc_2.lastIndexOf(".") + 1)).toLowerCase();
            if (!Boolean(_loc_3))
            {
                _loc_3 = BulkLoader.TYPE_TEXT;
            }
            if (_loc_3 == BulkLoader.TYPE_IMAGE || BulkLoader.IMAGE_EXTENSIONS.indexOf(_loc_3) > -1)
            {
                _loc_4 = BulkLoader.TYPE_IMAGE;
            }
            else if (_loc_3 == BulkLoader.TYPE_SOUND || BulkLoader.SOUND_EXTENSIONS.indexOf(_loc_3) > -1)
            {
                _loc_4 = BulkLoader.TYPE_SOUND;
            }
            else if (_loc_3 == BulkLoader.TYPE_VIDEO || BulkLoader.VIDEO_EXTENSIONS.indexOf(_loc_3) > -1)
            {
                _loc_4 = BulkLoader.TYPE_VIDEO;
            }
            else if (_loc_3 == BulkLoader.TYPE_XML || BulkLoader.XML_EXTENSIONS.indexOf(_loc_3) > -1)
            {
                _loc_4 = BulkLoader.TYPE_XML;
            }
            else if (_loc_3 == BulkLoader.TYPE_MOVIECLIP || BulkLoader.MOVIECLIP_EXTENSIONS.indexOf(_loc_3) > -1)
            {
                _loc_4 = BulkLoader.TYPE_MOVIECLIP;
            }
            else
            {
                for (_loc_5 in _customTypesExtensions)
                {
                    
                    for each (_loc_6 in _customTypesExtensions[_loc_5])
                    {
                        
                        if (_loc_6 == _loc_3)
                        {
                            _loc_4 = _loc_5;
                            break;
                        }
                        if (_loc_4)
                        {
                            break;
                        }
                    }
                }
                if (!_loc_4)
                {
                    _loc_4 = BulkLoader.TYPE_TEXT;
                }
            }
            return _loc_4;
        }// end function

        public static function substituteURLString(param1:String, param2:Object) : String
        {
            var _loc_9:Object = null;
            var _loc_10:Object = null;
            var _loc_12:String = null;
            if (!param2)
            {
                return param1;
            }
            var _loc_3:* = /(?P<var_name>\{\s*[^\}]*\})""(?P<var_name>\{\s*[^\}]*\})/g;
            var _loc_4:* = _loc_3.exec(param1);
            var _loc_5:* = _loc_3.exec(param1) ? (_loc_4.var_name) : (null);
            var _loc_6:Array = [];
            var _loc_7:int = 0;
            while (Boolean(_loc_4) && Boolean(_loc_4.var_name))
            {
                
                if (_loc_4.var_name)
                {
                    _loc_5 = _loc_4.var_name;
                    _loc_5 = _loc_5.replace("{", "");
                    _loc_5 = _loc_5.replace("}", "");
                    _loc_5 = _loc_5.replace(/\s*""\s*/g, "");
                }
                _loc_6.push({start:_loc_4.index, end:_loc_4.index + _loc_4.var_name.length, changeTo:param2[_loc_5]});
                _loc_7++;
                if (_loc_7 > 400)
                {
                    break;
                }
                _loc_4 = _loc_3.exec(param1);
                _loc_5 = _loc_4 ? (_loc_4.var_name) : (null);
            }
            if (_loc_6.length == 0)
            {
                return param1;
            }
            var _loc_8:Array = [];
            var _loc_11:* = param1.substr(0, _loc_6[0].start);
            for each (_loc_10 in _loc_6)
            {
                
                if (_loc_9)
                {
                    _loc_11 = param1.substring(_loc_9.end, _loc_10.start);
                }
                _loc_8.push(_loc_11);
                _loc_8.push(_loc_10.changeTo);
                _loc_9 = _loc_10;
            }
            _loc_8.push(param1.substring(_loc_10.end));
            return _loc_8.join("");
        }// end function

        public static function getFileName(param1:String) : String
        {
            if (param1.lastIndexOf("/") == (param1.length - 1))
            {
                return getFileName(param1.substring(0, (param1.length - 1)));
            }
            var _loc_2:* = param1.lastIndexOf("/") + 1;
            var _loc_3:* = param1.substring(_loc_2);
            var _loc_4:* = _loc_3.indexOf(".");
            if (_loc_3.indexOf(".") == -1)
            {
                if (_loc_3.indexOf("?") > -1)
                {
                    _loc_4 = _loc_3.indexOf("?");
                }
                else
                {
                    _loc_4 = _loc_3.length;
                }
            }
            var _loc_5:* = _loc_3.substring(0, _loc_4);
            return _loc_3.substring(0, _loc_4);
        }// end function

        public static function __debug_print_loaders() : void
        {
            var instNames:String;
            var theNames:Array;
            var _loc_2:int = 0;
            var _loc_3:* = BulkLoader._allLoaders;
            while (_loc_3 in _loc_2)
            {
                
                instNames = _loc_3[_loc_2];
                theNames.push(instNames);
            }
            theNames.sort();
            trace("All loaders");
            theNames.forEach(function (param1, ... args) : void
            {
                trace("\t", param1);
                return;
            }// end function
            );
            trace("===========");
            return;
        }// end function

        public static function __debug_print_num_loaders() : void
        {
            var _loc_2:String = null;
            var _loc_1:int = 0;
            for each (_loc_2 in BulkLoader._allLoaders)
            {
                
                _loc_1++;
            }
            trace("BulkLoader has ", _loc_1, "instances");
            return;
        }// end function

        public static function __debug_printStackTrace() : void
        {
            try
            {
                throw new Error("stack trace");
            }
            catch (e:Error)
            {
                trace(e.getStackTrace());
            }
            return;
        }// end function

    }
}
