package fl.video
{

    public class CuePointManager extends Object
    {
        var _disabledCuePointsByNameOnly:Object;
        var navCuePoints:Array;
        var allCuePoints:Array;
        var _disabledCuePoints:Array;
        var _asCuePointTolerance:Number;
        var _linearSearchTolerance:Number;
        var _asCuePointIndex:int;
        var asCuePoints:Array;
        var flvCuePoints:Array;
        var _metadataLoaded:Boolean;
        var _id:uint;
        private var _owner:FLVPlayback;
        var eventCuePoints:Array;
        public static const SHORT_VERSION:String = "2.1";
        public static const VERSION:String = "2.1.0.14";
        static const DEFAULT_LINEAR_SEARCH_TOLERANCE:Number = 50;
        static var cuePointsReplace:Array = ["&quot;", "\"", "&#39;", "\'", "&#44;", ",", "&amp;", "&"];

        public function CuePointManager(param1:FLVPlayback, param2:uint)
        {
            _owner = param1;
            _id = param2;
            reset();
            _asCuePointTolerance = _owner.getVideoPlayer(_id).playheadUpdateInterval / 2000;
            _linearSearchTolerance = DEFAULT_LINEAR_SEARCH_TOLERANCE;
            return;
        }// end function

        function getCuePoint(param1:Array, param2:Boolean, param3) : Object
        {
            var _loc_4:Object = null;
            var _loc_5:int = 0;
            switch(typeof(param3))
            {
                case "string":
                {
                    _loc_4 = {name:param3};
                    break;
                }
                case "number":
                {
                    _loc_4 = {time:param3};
                    break;
                }
                case "object":
                {
                    _loc_4 = param3;
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_5 = getCuePointIndex(param1, param2, _loc_4.time, _loc_4.name);
            if (_loc_5 < 0)
            {
                return null;
            }
            _loc_4 = deepCopyObject(param1[_loc_5]);
            _loc_4.array = param1;
            _loc_4.index = _loc_5;
            return _loc_4;
        }// end function

        public function resetASCuePointIndex(param1:Number) : void
        {
            var _loc_2:int = 0;
            if (param1 <= 0 || asCuePoints == null)
            {
                _asCuePointIndex = 0;
                return;
            }
            _loc_2 = getCuePointIndex(asCuePoints, true, param1);
            _asCuePointIndex = asCuePoints[_loc_2].time < param1 ? ((_loc_2 + 1)) : (_loc_2);
            return;
        }// end function

        public function set playheadUpdateInterval(param1:Number) : void
        {
            _asCuePointTolerance = param1 / 2000;
            return;
        }// end function

        function addOrDisable(param1:Boolean, param2:Object) : void
        {
            if (param1)
            {
                if (param2.type == CuePointType.ACTIONSCRIPT)
                {
                    throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "Cannot disable actionscript cue points");
                }
                setFLVCuePointEnabled(false, param2);
            }
            else if (param2.type == CuePointType.ACTIONSCRIPT)
            {
                addASCuePoint(param2);
            }
            return;
        }// end function

        public function processFLVCuePoints(param1:Array) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Number = NaN;
            var _loc_4:Object = null;
            var _loc_5:Array = null;
            var _loc_6:Number = NaN;
            var _loc_7:int = 0;
            _metadataLoaded = true;
            if (param1 == null || param1.length < 1)
            {
                flvCuePoints = null;
                navCuePoints = null;
                eventCuePoints = null;
                return;
            }
            flvCuePoints = param1;
            navCuePoints = new Array();
            eventCuePoints = new Array();
            _loc_3 = -1;
            _loc_5 = _disabledCuePoints;
            _loc_6 = 0;
            _disabledCuePoints = new Array();
            _loc_7 = 0;
            do
            {
                
                if (_loc_3 > 0 && _loc_3 >= _loc_4.time)
                {
                    flvCuePoints = null;
                    navCuePoints = null;
                    eventCuePoints = null;
                    _disabledCuePoints = new Array();
                    _disabledCuePointsByNameOnly = new Object();
                    throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "Unsorted cuePoint found after time: " + _loc_3);
                }
                _loc_3 = _loc_4.time;
                while (_loc_6 < _loc_5.length && cuePointCompare(_loc_5[_loc_6].time, null, _loc_4) < 0)
                {
                    
                    _loc_6 = _loc_6 + 1;
                }
                if (_disabledCuePointsByNameOnly[_loc_4.name] != undefined || _loc_6 < _loc_5.length && cuePointCompare(_loc_5[_loc_6].time, _loc_5[_loc_6].name, _loc_4) == 0)
                {
                    _disabledCuePoints.push({time:_loc_4.time, name:_loc_4.name});
                }
                if (_loc_4.type == CuePointType.NAVIGATION)
                {
                    navCuePoints.push(_loc_4);
                }
                else if (_loc_4.type == CuePointType.EVENT)
                {
                    eventCuePoints.push(_loc_4);
                }
                if (allCuePoints == null || allCuePoints.length < 1)
                {
                    allCuePoints = new Array();
                    allCuePoints.push(_loc_4);
                }
                else
                {
                    _loc_2 = getCuePointIndex(allCuePoints, true, _loc_4.time);
                    _loc_2 = allCuePoints[_loc_2].time > _loc_4.time ? (0) : ((_loc_2 + 1));
                    allCuePoints.splice(_loc_2, 0, _loc_4);
                }
                var _loc_8:* = flvCuePoints[_loc_7++];
                _loc_4 = flvCuePoints[_loc_7++];
            }while (_loc_8 != undefined)
            _disabledCuePointsByNameOnly = new Object();
            return;
        }// end function

        public function addASCuePoint(param1, param2:String = null, param3:Object = null) : Object
        {
            var _loc_4:Object = null;
            var _loc_5:Boolean = false;
            var _loc_6:Boolean = false;
            var _loc_7:int = 0;
            var _loc_8:Number = NaN;
            var _loc_9:Object = null;
            var _loc_10:int = 0;
            if (typeof(param1) == "object")
            {
                _loc_4 = deepCopyObject(param1);
            }
            else
            {
                _loc_4 = {time:param1, name:param2, parameters:deepCopyObject(param3)};
            }
            if (_loc_4.parameters == null)
            {
                delete _loc_4.parameters;
            }
            _loc_5 = isNaN(_loc_4.time) || _loc_4.time < 0;
            if (_loc_5)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "time must be number");
            }
            _loc_6 = _loc_4.name == null;
            if (_loc_6)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "name cannot be undefined or null");
            }
            _loc_4.type = CuePointType.ACTIONSCRIPT;
            if (asCuePoints == null || asCuePoints.length < 1)
            {
                _loc_7 = 0;
                asCuePoints = new Array();
                asCuePoints.push(_loc_4);
            }
            else
            {
                _loc_7 = getCuePointIndex(asCuePoints, true, _loc_4.time);
                _loc_7 = asCuePoints[_loc_7].time > _loc_4.time ? (0) : ((_loc_7 + 1));
                asCuePoints.splice(_loc_7, 0, _loc_4);
            }
            if (allCuePoints == null || allCuePoints.length < 1)
            {
                allCuePoints = new Array();
                allCuePoints.push(_loc_4);
            }
            else
            {
                _loc_10 = getCuePointIndex(allCuePoints, true, _loc_4.time);
                _loc_10 = allCuePoints[_loc_10].time > _loc_4.time ? (0) : ((_loc_10 + 1));
                allCuePoints.splice(_loc_10, 0, _loc_4);
            }
            _loc_8 = _owner.getVideoPlayer(_id).playheadTime;
            if (_loc_8 > 0)
            {
                if (_asCuePointIndex == _loc_7)
                {
                    if (_loc_8 > asCuePoints[_loc_7].time)
                    {
                        var _loc_12:* = _asCuePointIndex + 1;
                        _asCuePointIndex = _loc_12;
                    }
                }
                else if (_asCuePointIndex > _loc_7)
                {
                    var _loc_12:* = _asCuePointIndex + 1;
                    _asCuePointIndex = _loc_12;
                }
            }
            else
            {
                _asCuePointIndex = 0;
            }
            _loc_9 = deepCopyObject(asCuePoints[_loc_7]);
            _loc_9.array = asCuePoints;
            _loc_9.index = _loc_7;
            return _loc_9;
        }// end function

        public function get metadataLoaded() : Boolean
        {
            return _metadataLoaded;
        }// end function

        public function reset() : void
        {
            _metadataLoaded = false;
            allCuePoints = null;
            asCuePoints = null;
            _disabledCuePoints = new Array();
            _disabledCuePointsByNameOnly = new Object();
            flvCuePoints = null;
            navCuePoints = null;
            eventCuePoints = null;
            _asCuePointIndex = 0;
            return;
        }// end function

        public function removeCuePoints(param1:Array, param2:Object) : Number
        {
            var _loc_3:int = 0;
            var _loc_4:Object = null;
            var _loc_5:int = 0;
            _loc_5 = 0;
            _loc_3 = getCuePointIndex(param1, true, -1, param2.name);
            while (_loc_3 >= 0)
            {
                
                _loc_4 = param1[_loc_3];
                param1.splice(_loc_3, 1);
                _loc_3 = _loc_3 - 1;
                _loc_5++;
                _loc_3 = getNextCuePointIndexWithName(_loc_4.name, param1, _loc_3);
            }
            return _loc_5;
        }// end function

        function unescape(param1:String) : String
        {
            var _loc_2:String = null;
            var _loc_3:int = 0;
            _loc_2 = param1;
            _loc_3 = 0;
            while (_loc_3 < cuePointsReplace.length)
            {
                
                _loc_2 = _loc_2.replace(cuePointsReplace[_loc_3++], cuePointsReplace[_loc_3++]);
            }
            return _loc_2;
        }// end function

        public function setFLVCuePointEnabled(param1:Boolean, param2) : int
        {
            var _loc_3:Object = null;
            var _loc_4:Boolean = false;
            var _loc_5:Boolean = false;
            var _loc_6:uint = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:Object = null;
            switch(typeof(param2))
            {
                case "string":
                {
                    _loc_3 = {name:param2};
                    break;
                }
                case "number":
                {
                    _loc_3 = {time:param2};
                    break;
                }
                case "object":
                {
                    _loc_3 = param2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_4 = isNaN(_loc_3.time) || _loc_3.time < 0;
            _loc_5 = _loc_3.name == null;
            if (_loc_4 && _loc_5)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "time must be number and/or name must not be undefined or null");
            }
            _loc_6 = 0;
            if (_loc_4)
            {
                if (!_metadataLoaded)
                {
                    if (_disabledCuePointsByNameOnly[_loc_3.name] == undefined)
                    {
                        if (!param1)
                        {
                            _disabledCuePointsByNameOnly[_loc_3.name] = new Array();
                        }
                    }
                    else
                    {
                        if (param1)
                        {
                            delete _disabledCuePointsByNameOnly[_loc_3.name];
                        }
                        return -1;
                    }
                    removeCuePoints(_disabledCuePoints, _loc_3);
                    return -1;
                }
                if (param1)
                {
                    _loc_6 = removeCuePoints(_disabledCuePoints, _loc_3);
                }
                else
                {
                    _loc_7 = getCuePointIndex(flvCuePoints, true, -1, _loc_3.name);
                    while (_loc_7 >= 0)
                    {
                        
                        _loc_9 = flvCuePoints[_loc_7];
                        _loc_8 = getCuePointIndex(_disabledCuePoints, true, _loc_9.time);
                        if (_loc_8 < 0 || _disabledCuePoints[_loc_8].time != _loc_9.time)
                        {
                            _disabledCuePoints = insertCuePoint(_loc_8, _disabledCuePoints, {name:_loc_9.name, time:_loc_9.time});
                            _loc_6 = _loc_6 + 1;
                        }
                        _loc_7 = getNextCuePointIndexWithName(_loc_9.name, flvCuePoints, _loc_7);
                    }
                }
                return _loc_6;
            }
            _loc_7 = getCuePointIndex(_disabledCuePoints, false, _loc_3.time, _loc_3.name);
            if (_loc_7 < 0)
            {
                if (param1)
                {
                    if (!_metadataLoaded)
                    {
                        _loc_7 = getCuePointIndex(_disabledCuePoints, false, _loc_3.time);
                        if (_loc_7 < 0)
                        {
                            _loc_8 = getCuePointIndex(_disabledCuePointsByNameOnly[_loc_3.name], true, _loc_3.time);
                            if (cuePointCompare(_loc_3.time, null, _disabledCuePointsByNameOnly[_loc_3.name]) != 0)
                            {
                                _disabledCuePointsByNameOnly[_loc_3.name] = insertCuePoint(_loc_8, _disabledCuePointsByNameOnly[_loc_3.name], _loc_3);
                            }
                        }
                        else
                        {
                            _disabledCuePoints.splice(_loc_7, 1);
                        }
                    }
                    return _metadataLoaded ? (0) : (-1);
                }
            }
            else
            {
                if (param1)
                {
                    _disabledCuePoints.splice(_loc_7, 1);
                    _loc_6 = 1;
                }
                else
                {
                    _loc_6 = 0;
                }
                return _metadataLoaded ? (_loc_6) : (-1);
            }
            if (_metadataLoaded)
            {
                _loc_7 = getCuePointIndex(flvCuePoints, false, _loc_3.time, _loc_3.name);
                if (_loc_7 < 0)
                {
                    return 0;
                }
                if (_loc_5)
                {
                    _loc_3.name = flvCuePoints[_loc_7].name;
                }
            }
            _loc_8 = getCuePointIndex(_disabledCuePoints, true, _loc_3.time);
            _disabledCuePoints = insertCuePoint(_loc_8, _disabledCuePoints, _loc_3);
            _loc_6 = 1;
            return _metadataLoaded ? (_loc_6) : (-1);
        }// end function

        public function isFLVCuePointEnabled(param1) : Boolean
        {
            var _loc_2:Object = null;
            var _loc_3:Boolean = false;
            var _loc_4:Boolean = false;
            var _loc_5:int = 0;
            if (!_metadataLoaded)
            {
                return true;
            }
            switch(typeof(param1))
            {
                case "string":
                {
                    _loc_2 = {name:param1};
                    break;
                }
                case "number":
                {
                    _loc_2 = {time:param1};
                    break;
                }
                case "object":
                {
                    _loc_2 = param1;
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_3 = isNaN(_loc_2.time) || _loc_2.time < 0;
            _loc_4 = _loc_2.name == null;
            if (_loc_3 && _loc_4)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "time must be number and/or name must not be undefined or null");
            }
            if (_loc_3)
            {
                _loc_5 = getCuePointIndex(flvCuePoints, true, -1, _loc_2.name);
                if (_loc_5 < 0)
                {
                    return true;
                }
                while (_loc_5 >= 0)
                {
                    
                    if (getCuePointIndex(_disabledCuePoints, false, flvCuePoints[_loc_5].time, flvCuePoints[_loc_5].name) < 0)
                    {
                        return true;
                    }
                    _loc_5 = getNextCuePointIndexWithName(_loc_2.name, flvCuePoints, _loc_5);
                }
                return false;
            }
            return getCuePointIndex(_disabledCuePoints, false, _loc_2.time, _loc_2.name) < 0;
        }// end function

        public function removeASCuePoint(param1) : Object
        {
            var _loc_2:Object = null;
            var _loc_3:int = 0;
            if (asCuePoints == null || asCuePoints.length < 1)
            {
                return null;
            }
            switch(typeof(param1))
            {
                case "string":
                {
                    _loc_2 = {name:param1};
                    break;
                }
                case "number":
                {
                    _loc_2 = {time:param1};
                    break;
                }
                case "object":
                {
                    _loc_2 = param1;
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_3 = getCuePointIndex(asCuePoints, false, _loc_2.time, _loc_2.name);
            if (_loc_3 < 0)
            {
                return null;
            }
            _loc_2 = asCuePoints[_loc_3];
            asCuePoints.splice(_loc_3, 1);
            _loc_3 = getCuePointIndex(allCuePoints, false, _loc_2.time, _loc_2.name);
            if (_loc_3 > 0)
            {
                allCuePoints.splice(_loc_3, 1);
            }
            if (_owner.getVideoPlayer(_id).playheadTime > 0)
            {
                if (_asCuePointIndex > _loc_3)
                {
                    var _loc_5:* = _asCuePointIndex - 1;
                    _asCuePointIndex = _loc_5;
                }
            }
            else
            {
                _asCuePointIndex = 0;
            }
            return _loc_2;
        }// end function

        public function get id() : uint
        {
            return _id;
        }// end function

        public function processCuePointsProperty(param1:Array) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:Object = null;
            var _loc_7:Boolean = false;
            var _loc_8:int = 0;
            if (param1 == null || param1.length == 0)
            {
                return;
            }
            _loc_2 = 0;
            _loc_8 = 0;
            while (_loc_8 < (param1.length - 1))
            {
                
                switch(_loc_2)
                {
                    case 6:
                    {
                        addOrDisable(_loc_7, _loc_6);
                        _loc_2 = 0;
                    }
                    case 0:
                    {
                        if (param1[_loc_8++] != "t")
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "unexpected cuePoint parameter format");
                        }
                        if (isNaN(param1[_loc_8]))
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "time must be number");
                        }
                        _loc_6 = new Object();
                        _loc_6.time = param1[_loc_8] / 1000;
                        _loc_2 = _loc_2 + 1;
                        break;
                    }
                    case 1:
                    {
                        if (param1[_loc_8++] != "n")
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "unexpected cuePoint parameter format");
                        }
                        if (param1[_loc_8] == undefined)
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "name cannot be null or undefined");
                        }
                        _loc_6.name = unescape(param1[_loc_8]);
                        _loc_2 = _loc_2 + 1;
                        break;
                    }
                    case 2:
                    {
                        if (param1[_loc_8++] != "t")
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "unexpected cuePoint parameter format");
                        }
                        if (isNaN(param1[_loc_8]))
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "type must be number");
                        }
                        switch(param1[_loc_8])
                        {
                            case 0:
                            {
                                _loc_6.type = CuePointType.EVENT;
                                break;
                            }
                            case 1:
                            {
                                _loc_6.type = CuePointType.NAVIGATION;
                                break;
                            }
                            case 2:
                            {
                                _loc_6.type = CuePointType.ACTIONSCRIPT;
                                break;
                            }
                            default:
                            {
                                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "type must be 0, 1 or 2");
                                break;
                            }
                        }
                        _loc_2 = _loc_2 + 1;
                        break;
                    }
                    case 3:
                    {
                        if (param1[_loc_8++] != "d")
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "unexpected cuePoint parameter format");
                        }
                        if (isNaN(param1[_loc_8]))
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "disabled must be number");
                        }
                        _loc_7 = param1[_loc_8] != 0;
                        _loc_2 = _loc_2 + 1;
                        break;
                    }
                    case 4:
                    {
                        if (param1[_loc_8++] != "p")
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "unexpected cuePoint parameter format");
                        }
                        if (isNaN(param1[_loc_8]))
                        {
                            throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "num params must be number");
                        }
                        _loc_3 = param1[_loc_8];
                        _loc_2 = _loc_2 + 1;
                        if (_loc_3 == 0)
                        {
                            _loc_2 = _loc_2 + 1;
                        }
                        else
                        {
                            _loc_6.parameters = new Object();
                        }
                        break;
                    }
                    case 5:
                    {
                        _loc_4 = param1[_loc_8++];
                        _loc_5 = param1[_loc_8];
                        if (_loc_4 is String)
                        {
                            _loc_4 = unescape(_loc_4);
                        }
                        if (_loc_5 is String)
                        {
                            _loc_5 = unescape(_loc_5);
                        }
                        _loc_6.parameters[_loc_4] = _loc_5;
                        _loc_3 = _loc_3 - 1;
                        if (_loc_3 == 0)
                        {
                            _loc_2 = _loc_2 + 1;
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_8++;
            }
            if (_loc_2 == 6)
            {
                addOrDisable(_loc_7, _loc_6);
            }
            else
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "unexpected end of cuePoint param string");
            }
            return;
        }// end function

        function getNextCuePointIndexWithName(param1:String, param2:Array, param3:int) : int
        {
            var _loc_4:int = 0;
            if (param1 == null)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "name cannot be undefined or null");
            }
            if (param2 == null)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "cuePoint.array undefined");
            }
            if (isNaN(param3) || param3 < -1 || param3 >= param2.length)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "cuePoint.index must be number between -1 and cuePoint.array.length");
            }
            _loc_4 = param3 + 1;
            while (_loc_4 < param2.length)
            {
                
                if (param2[_loc_4].name == param1)
                {
                    break;
                }
                _loc_4++;
            }
            if (_loc_4 < param2.length)
            {
                return _loc_4;
            }
            return -1;
        }// end function

        public function dispatchASCuePoints() : void
        {
            var _loc_1:Number = NaN;
            _loc_1 = _owner.getVideoPlayer(_id).playheadTime;
            if (_owner.getVideoPlayer(_id).stateResponsive && asCuePoints != null)
            {
                while (_asCuePointIndex < asCuePoints.length && asCuePoints[_asCuePointIndex].time <= _loc_1 + _asCuePointTolerance)
                {
                    
                    _owner.dispatchEvent(new MetadataEvent(MetadataEvent.CUE_POINT, false, false, deepCopyObject(asCuePoints[_asCuePointIndex++]), _id));
                }
            }
            return;
        }// end function

        function getNextCuePointWithName(param1:Object) : Object
        {
            var _loc_2:int = 0;
            var _loc_3:Object = null;
            if (param1 == null)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "cuePoint parameter undefined");
            }
            if (isNaN(param1.time) || param1.time < 0)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "time must be number");
            }
            _loc_2 = getNextCuePointIndexWithName(param1.name, param1.array, param1.index);
            if (_loc_2 < 0)
            {
                return null;
            }
            _loc_3 = deepCopyObject(param1.array[_loc_2]);
            _loc_3.array = param1.array;
            _loc_3.index = _loc_2;
            return _loc_3;
        }// end function

        public function insertCuePoint(param1:int, param2:Array, param3:Object) : Array
        {
            if (param1 < 0)
            {
                param2 = new Array();
                param2.push(param3);
            }
            else
            {
                if (param2[param1].time > param3.time)
                {
                    param1 = 0;
                }
                else
                {
                    param1++;
                }
                param2.splice(param1, 0, param3);
            }
            return param2;
        }// end function

        function getCuePointIndex(param1:Array, param2:Boolean, param3:Number = NaN, param4:String = null, param5:int = -1, param6:int = -1) : int
        {
            var _loc_7:Boolean = false;
            var _loc_8:Boolean = false;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:int = 0;
            if (param1 == null || param1.length < 1)
            {
                return -1;
            }
            _loc_7 = isNaN(param3) || param3 < 0;
            _loc_8 = param4 == null;
            if (_loc_7 && _loc_8)
            {
                throw new VideoError(VideoError.ILLEGAL_CUE_POINT, "time must be number and/or name must not be undefined or null");
            }
            if (param5 < 0)
            {
                param5 = 0;
            }
            if (param6 < 0)
            {
                param6 = param1.length;
            }
            if (!_loc_8 && (param2 || _loc_7))
            {
                if (_loc_7)
                {
                    _loc_12 = param5;
                }
                else
                {
                    _loc_12 = getCuePointIndex(param1, param2, param3);
                }
                _loc_13 = _loc_12;
                while (_loc_13 >= param5)
                {
                    
                    if (param1[_loc_13].name == param4)
                    {
                        break;
                    }
                    _loc_13 = _loc_13 - 1;
                }
                if (_loc_13 >= param5)
                {
                    return _loc_13;
                }
                _loc_13 = _loc_12 + 1;
                while (_loc_13 < param6)
                {
                    
                    if (param1[_loc_13].name == param4)
                    {
                        break;
                    }
                    _loc_13++;
                }
                if (_loc_13 < param6)
                {
                    return _loc_13;
                }
                return -1;
            }
            if (param6 <= _linearSearchTolerance)
            {
                _loc_14 = param5 + param6;
                _loc_15 = param5;
                while (_loc_15 < _loc_14)
                {
                    
                    _loc_9 = cuePointCompare(param3, param4, param1[_loc_15]);
                    if (_loc_9 == 0)
                    {
                        return _loc_15;
                    }
                    if (_loc_9 < 0)
                    {
                        break;
                    }
                    _loc_15++;
                }
                if (param2)
                {
                    if (_loc_15 > 0)
                    {
                        return (_loc_15 - 1);
                    }
                    return 0;
                }
                return -1;
            }
            _loc_10 = int(param6 / 2);
            _loc_11 = param5 + _loc_10;
            _loc_9 = cuePointCompare(param3, param4, param1[_loc_11]);
            if (_loc_9 < 0)
            {
                return getCuePointIndex(param1, param2, param3, param4, param5, _loc_10);
            }
            if (_loc_9 > 0)
            {
                return getCuePointIndex(param1, param2, param3, param4, (_loc_11 + 1), (_loc_10 - 1) + param6 % 2);
            }
            return _loc_11;
        }// end function

        static function deepCopyObject(param1:Object, param2:uint = 0) : Object
        {
            var _loc_3:Object = null;
            var _loc_4:* = undefined;
            if (param1 == null)
            {
                return param1;
            }
            _loc_3 = new Object();
            for (_loc_4 in param1)
            {
                
                if (param2 == 0 && (_loc_4 == "array" || _loc_4 == "index"))
                {
                    continue;
                }
                if (typeof(param1[_loc_4]) == "object")
                {
                    _loc_3[_loc_4] = deepCopyObject(param1[_loc_4], (param2 + 1));
                    continue;
                }
                _loc_3[_loc_4] = param1[_loc_4];
            }
            return _loc_3;
        }// end function

        static function cuePointCompare(param1:Number, param2:String, param3:Object) : int
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_4 = Math.round(param1 * 1000);
            _loc_5 = Math.round(param3.time * 1000);
            if (_loc_4 < _loc_5)
            {
                return -1;
            }
            if (_loc_4 > _loc_5)
            {
                return 1;
            }
            if (param2 != null)
            {
                if (param2 == param3.name)
                {
                    return 0;
                }
                if (param2 < param3.name)
                {
                    return -1;
                }
                return 1;
            }
            return 0;
        }// end function

    }
}
