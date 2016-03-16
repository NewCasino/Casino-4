package fl.video
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class NCManager extends Object implements INCManager
    {
        var _serverName:String;
        var _tryNCTimer:Timer;
        var _autoSenseBW:Boolean;
        var _fpadZone:Number;
        var _appName:String;
        public const DEFAULT_TIMEOUT:uint = 60000;
        var _ncConnected:Boolean;
        var _fpadMgr:FPADManager;
        var _bitrate:Number;
        var _timeoutTimer:Timer;
        var _wrappedURL:String;
        var _payload:Number;
        var _proxyType:String;
        var _nc:NetConnection;
        var _streamLength:Number;
        var _connTypeCounter:uint;
        var _streamWidth:int;
        var _ncUri:String;
        var _contentPath:String;
        var _smilMgr:SMILManager;
        var _streamHeight:int;
        var _isRTMP:Boolean;
        var _tryNC:Array;
        var _owner:VideoPlayer;
        var _streams:Array;
        var _portNumber:String;
        var _streamName:String;
        var _objectEncoding:uint;
        public var fallbackServerName:String;
        var _protocol:String;
        public static const VERSION:String = "2.1.0.14";
        public static const SHORT_VERSION:String = "2.1";

        public function NCManager()
        {
            _fpadZone = NaN;
            _objectEncoding = ObjectEncoding.AMF0;
            _proxyType = "best";
            _timeoutTimer = new Timer(DEFAULT_TIMEOUT);
            _timeoutTimer.addEventListener(TimerEvent.TIMER, this._onFMSConnectTimeOut);
            _tryNCTimer = new Timer(1500, 1);
            _tryNCTimer.addEventListener(TimerEvent.TIMER, this.nextConnect);
            initNCInfo();
            initOtherInfo();
            _nc = null;
            _ncConnected = false;
            return;
        }// end function

        function initNCInfo() : void
        {
            _isRTMP = false;
            _serverName = null;
            _wrappedURL = null;
            _portNumber = null;
            _appName = null;
            return;
        }// end function

        function cleanConns() : void
        {
            var _loc_1:uint = 0;
            _tryNCTimer.reset();
            if (_tryNC != null)
            {
                _loc_1 = 0;
                while (_loc_1 < _tryNC.length)
                {
                    
                    if (_tryNC[_loc_1] != null)
                    {
                        _tryNC[_loc_1].removeEventListener(NetStatusEvent.NET_STATUS, connectOnStatus);
                        if (_tryNC[_loc_1].client.pending)
                        {
                            _tryNC[_loc_1].addEventListener(NetStatusEvent.NET_STATUS, disconnectOnStatus);
                        }
                        else
                        {
                            _tryNC[_loc_1].close();
                        }
                    }
                    _tryNC[_loc_1] = null;
                    _loc_1 = _loc_1 + 1;
                }
                _tryNC = null;
            }
            return;
        }// end function

        public function get streamWidth() : int
        {
            return _streamWidth;
        }// end function

        public function connectToURL(param1:String) : Boolean
        {
            var parseResults:ParseResults;
            var canReuse:Boolean;
            var name:String;
            var url:* = param1;
            initOtherInfo();
            _contentPath = url;
            if (_contentPath == null || _contentPath == "")
            {
                throw new VideoError(VideoError.INVALID_SOURCE);
            }
            parseResults = parseURL(_contentPath);
            if (parseResults.streamName == null || parseResults.streamName == "")
            {
                throw new VideoError(VideoError.INVALID_SOURCE, url);
            }
            if (parseResults.isRTMP)
            {
                canReuse = canReuseOldConnection(parseResults);
                _isRTMP = true;
                _protocol = parseResults.protocol;
                _streamName = parseResults.streamName;
                _serverName = parseResults.serverName;
                _wrappedURL = parseResults.wrappedURL;
                _portNumber = parseResults.portNumber;
                _appName = parseResults.appName;
                if (_appName == null || _appName == "" || _streamName == null || _streamName == "")
                {
                    throw new VideoError(VideoError.INVALID_SOURCE, url);
                }
                _autoSenseBW = _streamName.indexOf(",") >= 0;
                return canReuse || connectRTMP();
            }
            else
            {
                name = parseResults.streamName;
                if (name.indexOf("?") < 0 && (name.length < 4 || name.slice(-4).toLowerCase() != ".txt") && (name.length < 4 || name.slice(-4).toLowerCase() != ".xml") && (name.length < 5 || name.slice(-5).toLowerCase() != ".smil"))
                {
                    canReuse = canReuseOldConnection(parseResults);
                    _isRTMP = false;
                    _streamName = name;
                    return canReuse || connectHTTP();
                }
                if (name.indexOf("/fms/fpad") >= 0)
                {
                    try
                    {
                        return connectFPAD(name);
                    }
                    catch (err:Error)
                    {
                    }
                }
            }
            _smilMgr = new SMILManager(this);
            return _smilMgr.connectXML(name);
        }// end function

        public function get streamName() : String
        {
            return _streamName;
        }// end function

        function reconnectOnStatus(event:NetStatusEvent) : void
        {
            if (event.info.code == "NetConnection.Connect.Failed" || event.info.code == "NetConnection.Connect.Rejected")
            {
                _nc = null;
                _ncConnected = false;
                _owner.ncReconnected();
            }
            return;
        }// end function

        public function get videoPlayer() : VideoPlayer
        {
            return _owner;
        }// end function

        function getStreamLengthResult(param1:Number) : void
        {
            if (param1 > 0)
            {
                _streamLength = param1;
            }
            _owner.ncConnected();
            return;
        }// end function

        function canReuseOldConnection(param1:ParseResults) : Boolean
        {
            if (_nc == null || !_ncConnected)
            {
                return false;
            }
            if (!param1.isRTMP)
            {
                if (!_isRTMP)
                {
                    return true;
                }
                _owner.close();
                _nc = null;
                _ncConnected = false;
                initNCInfo();
                return false;
            }
            if (_isRTMP)
            {
                if (param1.serverName == _serverName && param1.appName == _appName && param1.protocol == _protocol && param1.portNumber == _portNumber && param1.wrappedURL == _wrappedURL)
                {
                    return true;
                }
                _owner.close();
                _nc = null;
                _ncConnected = false;
            }
            initNCInfo();
            return false;
        }// end function

        public function getProperty(param1:String)
        {
            switch(param1)
            {
                case "fallbackServerName":
                {
                    return fallbackServerName;
                }
                case "fpadZone":
                {
                    return _fpadZone;
                }
                case "objectEncoding":
                {
                    return _objectEncoding;
                }
                case "proxyType":
                {
                    return _proxyType;
                }
                default:
                {
                    throw new VideoError(VideoError.UNSUPPORTED_PROPERTY, param1);
                    break;
                }
            }
        }// end function

        function connectRTMP() : Boolean
        {
            var _loc_1:int = 0;
            var _loc_2:uint = 0;
            _timeoutTimer.stop();
            _timeoutTimer.start();
            _tryNC = new Array();
            _loc_1 = _protocol == "rtmp:/" || _protocol == "rtmpe:/" ? (2) : (1);
            _loc_2 = 0;
            while (_loc_2 < _loc_1)
            {
                
                _tryNC[_loc_2] = new NetConnection();
                _tryNC[_loc_2].objectEncoding = _objectEncoding;
                _tryNC[_loc_2].proxyType = _proxyType;
                if (!isNaN(_fpadZone))
                {
                    _tryNC[_loc_2].fpadZone = _fpadZone;
                }
                _tryNC[_loc_2].client = new ConnectClient(this, _tryNC[_loc_2], _loc_2);
                _tryNC[_loc_2].addEventListener(NetStatusEvent.NET_STATUS, connectOnStatus);
                _loc_2 = _loc_2 + 1;
            }
            nextConnect();
            return false;
        }// end function

        public function reconnect() : void
        {
            if (!_isRTMP)
            {
                throw new Error("Cannot call reconnect on an http connection");
            }
            _nc.client = new ReconnectClient(this);
            _nc.addEventListener(NetStatusEvent.NET_STATUS, reconnectOnStatus);
            _nc.connect(_ncUri, false);
            return;
        }// end function

        public function helperDone(param1:Object, param2:Boolean) : void
        {
            var _loc_3:ParseResults = null;
            var _loc_4:String = null;
            var _loc_5:Boolean = false;
            var _loc_6:uint = 0;
            var _loc_7:Number = NaN;
            if (!param2)
            {
                _nc = null;
                _ncConnected = false;
                _owner.ncConnected();
                _smilMgr = null;
                _fpadMgr = null;
                return;
            }
            _loc_5 = false;
            if (param1 == _fpadMgr)
            {
                _loc_4 = _fpadMgr.rtmpURL;
                _fpadMgr = null;
                _loc_3 = parseURL(_loc_4);
                _isRTMP = _loc_3.isRTMP;
                _protocol = _loc_3.protocol;
                _serverName = _loc_3.serverName;
                _portNumber = _loc_3.portNumber;
                _wrappedURL = _loc_3.wrappedURL;
                _appName = _loc_3.appName;
                _streamName = _loc_3.streamName;
                _loc_7 = _fpadZone;
                _fpadZone = NaN;
                connectRTMP();
                _fpadZone = _loc_7;
                return;
            }
            if (param1 != _smilMgr)
            {
                return;
            }
            _streamWidth = _smilMgr.width;
            _streamHeight = _smilMgr.height;
            _loc_4 = _smilMgr.baseURLAttr[0];
            if (_loc_4 != null && _loc_4 != "")
            {
                if (_loc_4.charAt((_loc_4.length - 1)) != "/")
                {
                    _loc_4 = _loc_4 + "/";
                }
                _loc_3 = parseURL(_loc_4);
                _isRTMP = _loc_3.isRTMP;
                _loc_5 = true;
                _streamName = _loc_3.streamName;
                if (_isRTMP)
                {
                    _protocol = _loc_3.protocol;
                    _serverName = _loc_3.serverName;
                    _portNumber = _loc_3.portNumber;
                    _wrappedURL = _loc_3.wrappedURL;
                    _appName = _loc_3.appName;
                    if (_appName == null || _appName == "")
                    {
                        _smilMgr = null;
                        throw new VideoError(VideoError.INVALID_XML, "Base RTMP URL must include application name: " + _loc_4);
                    }
                    if (_smilMgr.baseURLAttr.length > 1)
                    {
                        _loc_3 = parseURL(_smilMgr.baseURLAttr[1]);
                        if (_loc_3.serverName != null)
                        {
                            fallbackServerName = _loc_3.serverName;
                        }
                    }
                }
            }
            _streams = _smilMgr.videoTags;
            _smilMgr = null;
            _loc_6 = 0;
            while (_loc_6 < _streams.length)
            {
                
                _loc_4 = _streams[_loc_6].src;
                _loc_3 = parseURL(_loc_4);
                if (!_loc_5)
                {
                    _isRTMP = _loc_3.isRTMP;
                    _loc_5 = true;
                    if (_isRTMP)
                    {
                        _protocol = _loc_3.protocol;
                        if (_streams.length > 1)
                        {
                            throw new VideoError(VideoError.INVALID_XML, "Cannot switch between multiple absolute RTMP URLs, must use meta tag base attribute.");
                        }
                        _serverName = _loc_3.serverName;
                        _portNumber = _loc_3.portNumber;
                        _wrappedURL = _loc_3.wrappedURL;
                        _appName = _loc_3.appName;
                        if (_appName == null || _appName == "")
                        {
                            throw new VideoError(VideoError.INVALID_XML, "Base RTMP URL must include application name: " + _loc_4);
                        }
                    }
                    else if (_loc_3.streamName.indexOf("/fms/fpad") >= 0 && _streams.length > 1)
                    {
                        throw new VideoError(VideoError.INVALID_XML, "Cannot switch between multiple absolute fpad URLs, must use meta tag base attribute.");
                    }
                }
                else if (_streamName != null && _streamName != "" && !_loc_3.isRelative && _streams.length > 1)
                {
                    throw new VideoError(VideoError.INVALID_XML, "When using meta tag base attribute, cannot use absolute URLs for video or ref tag src attributes.");
                }
                _streams[_loc_6].parseResults = _loc_3;
                _loc_6 = _loc_6 + 1;
            }
            _autoSenseBW = _streams.length > 1;
            if (!_autoSenseBW)
            {
                if (_streamName != null)
                {
                    _streamName = _streamName + _streams[0].parseResults.streamName;
                }
                else
                {
                    _streamName = _streams[0].parseResults.streamName;
                }
                if (_isRTMP && _streamName.substr(-4).toLowerCase() == ".flv")
                {
                    _streamName = _streamName.substr(0, _streamName.length - 4);
                }
                _streamLength = _streams[0].dur;
            }
            if (_isRTMP)
            {
                connectRTMP();
            }
            else if (_streamName != null && _streamName.indexOf("/fms/fpad") >= 0)
            {
                connectFPAD(_streamName);
            }
            else
            {
                if (_autoSenseBW)
                {
                    bitrateMatch();
                }
                connectHTTP();
                _owner.ncConnected();
            }
            return;
        }// end function

        public function get netConnection() : NetConnection
        {
            return _nc;
        }// end function

        public function get bitrate() : Number
        {
            return _bitrate;
        }// end function

        public function setProperty(param1:String, param2) : void
        {
            switch(param1)
            {
                case "fallbackServerName":
                {
                    fallbackServerName = String(param2);
                    break;
                }
                case "fpadZone":
                {
                    _fpadZone = Number(param2);
                    break;
                }
                case "objectEncoding":
                {
                    _objectEncoding = uint(param2);
                    break;
                }
                case "proxyType":
                {
                    _proxyType = String(param2);
                    break;
                }
                default:
                {
                    throw new VideoError(VideoError.UNSUPPORTED_PROPERTY, param1);
                    break;
                }
            }
            return;
        }// end function

        public function get timeout() : uint
        {
            return _timeoutTimer.delay;
        }// end function

        public function set videoPlayer(param1:VideoPlayer) : void
        {
            _owner = param1;
            return;
        }// end function

        function bitrateMatch() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            _loc_1 = _bitrate;
            if (isNaN(_loc_1))
            {
                _loc_1 = 0;
            }
            _loc_2 = _streams.length;
            _loc_3 = 0;
            while (_loc_3 < _streams.length)
            {
                
                if (isNaN(_streams[_loc_3].bitrate) || _loc_1 >= _streams[_loc_3].bitrate)
                {
                    _loc_2 = _loc_3;
                    break;
                }
                _loc_3 = _loc_3 + 1;
            }
            if (_loc_2 == _streams.length)
            {
                throw new VideoError(VideoError.NO_BITRATE_MATCH);
            }
            if (_streamName != null)
            {
                _streamName = _streamName + _streams[_loc_2].src;
            }
            else
            {
                _streamName = _streams[_loc_2].src;
            }
            if (_isRTMP && _streamName.substr(-4).toLowerCase() == ".flv")
            {
                _streamName = _streamName.substr(0, _streamName.length - 4);
            }
            _streamLength = _streams[_loc_2].dur;
            return;
        }// end function

        function disconnectOnStatus(event:NetStatusEvent) : void
        {
            if (event.info.code == "NetConnection.Connect.Success")
            {
                event.target.removeEventListener(NetStatusEvent.NET_STATUS, disconnectOnStatus);
                event.target.close();
            }
            return;
        }// end function

        function nextConnect(event:TimerEvent = null) : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            if (_connTypeCounter == 0)
            {
                _loc_2 = _protocol;
                _loc_3 = _portNumber;
            }
            else
            {
                _loc_3 = null;
                if (_protocol == "rtmp:/")
                {
                    _loc_2 = "rtmpt:/";
                }
                else if (_protocol == "rtmpe:/")
                {
                    _loc_2 = "rtmpte:/";
                }
                else
                {
                    _tryNC.pop();
                    return;
                }
            }
            _loc_4 = _loc_2 + (_serverName == null ? ("") : ("/" + _serverName + (_loc_3 == null ? ("") : (":" + _loc_3)) + "/")) + (_wrappedURL == null ? ("") : (_wrappedURL + "/")) + _appName;
            _tryNC[_connTypeCounter].client.pending = true;
            _tryNC[_connTypeCounter].connect(_loc_4, _autoSenseBW);
            if (_connTypeCounter < (_tryNC.length - 1))
            {
                var _loc_6:* = _connTypeCounter + 1;
                _connTypeCounter = _loc_6;
                _tryNCTimer.reset();
                _tryNCTimer.start();
            }
            return;
        }// end function

        function connectFPAD(param1:String) : Boolean
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:ParseResults = null;
            _loc_2 = /^(.+)(\?|\&)(uri=)([^&]+)(\&.*)?$""^(.+)(\?|\&)(uri=)([^&]+)(\&.*)?$/.exec(param1);
            if (_loc_2 == null)
            {
                throw new VideoError(VideoError.INVALID_SOURCE, "fpad url must include uri parameter: " + param1);
            }
            _loc_3 = _loc_2[1] + _loc_2[2];
            _loc_4 = _loc_2[4];
            _loc_5 = _loc_2[5] == undefined ? ("") : (_loc_2[5]);
            _loc_6 = parseURL(_loc_4);
            if (!_loc_6.isRTMP)
            {
                throw new VideoError(VideoError.INVALID_SOURCE, "fpad url uri parameter must be rtmp url: " + param1);
            }
            _fpadMgr = new FPADManager(this);
            return _fpadMgr.connectXML(_loc_3, _loc_4, _loc_5, _loc_6);
        }// end function

        function connectHTTP() : Boolean
        {
            _nc = new NetConnection();
            _nc.connect(null);
            _ncConnected = true;
            return true;
        }// end function

        public function get isRTMP() : Boolean
        {
            return _isRTMP;
        }// end function

        public function get streamLength() : Number
        {
            return _streamLength;
        }// end function

        public function connectAgain() : Boolean
        {
            var _loc_1:int = 0;
            var _loc_2:String = null;
            _loc_1 = _appName.indexOf("/");
            if (_loc_1 < 0)
            {
                _loc_1 = _streamName.indexOf("/");
                if (_loc_1 >= 0)
                {
                    _appName = _appName + "/";
                    _appName = _appName + _streamName.slice(0, _loc_1);
                    _streamName = _streamName.slice((_loc_1 + 1));
                }
                return false;
            }
            _loc_2 = _appName.slice((_loc_1 + 1));
            _loc_2 = _loc_2 + "/";
            _loc_2 = _loc_2 + _streamName;
            _streamName = _loc_2;
            _appName = _appName.slice(0, _loc_1);
            close();
            _payload = 0;
            _connTypeCounter = 0;
            cleanConns();
            connectRTMP();
            return true;
        }// end function

        function parseURL(param1:String) : ParseResults
        {
            var _loc_2:ParseResults = null;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_8:ParseResults = null;
            _loc_2 = new ParseResults();
            _loc_3 = 0;
            _loc_4 = param1.indexOf(":/", _loc_3);
            if (_loc_4 >= 0)
            {
                _loc_4 = _loc_4 + 2;
                _loc_2.protocol = param1.slice(_loc_3, _loc_4).toLowerCase();
                _loc_2.isRelative = false;
            }
            else
            {
                _loc_2.isRelative = true;
            }
            if (_loc_2.protocol != null && (_loc_2.protocol == "rtmp:/" || _loc_2.protocol == "rtmpt:/" || _loc_2.protocol == "rtmps:/" || _loc_2.protocol == "rtmpe:/" || _loc_2.protocol == "rtmpte:/"))
            {
                _loc_2.isRTMP = true;
                _loc_3 = _loc_4;
                if (param1.charAt(_loc_3) == "/")
                {
                    _loc_3++;
                    _loc_5 = param1.indexOf(":", _loc_3);
                    _loc_6 = param1.indexOf("/", _loc_3);
                    if (_loc_6 < 0)
                    {
                        if (_loc_5 < 0)
                        {
                            _loc_2.serverName = param1.slice(_loc_3);
                        }
                        else
                        {
                            _loc_4 = _loc_5;
                            _loc_2.portNumber = param1.slice(_loc_3, _loc_4);
                            _loc_3 = _loc_4 + 1;
                            _loc_2.serverName = param1.slice(_loc_3);
                        }
                        return _loc_2;
                    }
                    if (_loc_5 >= 0 && _loc_5 < _loc_6)
                    {
                        _loc_4 = _loc_5;
                        _loc_2.serverName = param1.slice(_loc_3, _loc_4);
                        _loc_3 = _loc_4 + 1;
                        _loc_4 = _loc_6;
                        _loc_2.portNumber = param1.slice(_loc_3, _loc_4);
                    }
                    else
                    {
                        _loc_4 = _loc_6;
                        _loc_2.serverName = param1.slice(_loc_3, _loc_4);
                    }
                    _loc_3 = _loc_4 + 1;
                }
                if (param1.charAt(_loc_3) == "?")
                {
                    _loc_7 = param1.slice((_loc_3 + 1));
                    _loc_8 = parseURL(_loc_7);
                    if (_loc_8.protocol == null || !_loc_8.isRTMP)
                    {
                        throw new VideoError(VideoError.INVALID_SOURCE, param1);
                    }
                    _loc_2.wrappedURL = "?";
                    _loc_2.wrappedURL = _loc_2.wrappedURL + _loc_8.protocol;
                    if (_loc_8.serverName != null)
                    {
                        _loc_2.wrappedURL = _loc_2.wrappedURL + "/";
                        _loc_2.wrappedURL = _loc_2.wrappedURL + _loc_8.serverName;
                    }
                    if (_loc_8.portNumber != null)
                    {
                        _loc_2.wrappedURL = _loc_2.wrappedURL + (":" + _loc_8.portNumber);
                    }
                    if (_loc_8.wrappedURL != null)
                    {
                        _loc_2.wrappedURL = _loc_2.wrappedURL + "/";
                        _loc_2.wrappedURL = _loc_2.wrappedURL + _loc_8.wrappedURL;
                    }
                    _loc_2.appName = _loc_8.appName;
                    _loc_2.streamName = _loc_8.streamName;
                    return _loc_2;
                }
                _loc_4 = param1.indexOf("/", _loc_3);
                if (_loc_4 < 0)
                {
                    _loc_2.appName = param1.slice(_loc_3);
                    return _loc_2;
                }
                _loc_2.appName = param1.slice(_loc_3, _loc_4);
                _loc_3 = _loc_4 + 1;
                _loc_4 = param1.indexOf("/", _loc_3);
                if (_loc_4 < 0)
                {
                    _loc_2.streamName = param1.slice(_loc_3);
                    if (_loc_2.streamName.slice(-4).toLowerCase() == ".flv")
                    {
                        _loc_2.streamName = _loc_2.streamName.slice(0, -4);
                    }
                    return _loc_2;
                }
                _loc_2.appName = _loc_2.appName + "/";
                _loc_2.appName = _loc_2.appName + param1.slice(_loc_3, _loc_4);
                _loc_3 = _loc_4 + 1;
                _loc_2.streamName = param1.slice(_loc_3);
                if (_loc_2.streamName.slice(-4).toLowerCase() == ".flv")
                {
                    _loc_2.streamName = _loc_2.streamName.slice(0, -4);
                }
            }
            else
            {
                _loc_2.isRTMP = false;
                _loc_2.streamName = param1;
            }
            return _loc_2;
        }// end function

        function initOtherInfo() : void
        {
            _contentPath = null;
            _streamName = null;
            _streamWidth = -1;
            _streamHeight = -1;
            _streamLength = NaN;
            _streams = null;
            _autoSenseBW = false;
            _payload = 0;
            _connTypeCounter = 0;
            cleanConns();
            return;
        }// end function

        public function set timeout(param1:uint) : void
        {
            _timeoutTimer.delay = param1;
            return;
        }// end function

        function _onFMSConnectTimeOut(event:TimerEvent = null) : void
        {
            cleanConns();
            _nc = null;
            _ncConnected = false;
            if (!connectAgain())
            {
                _owner.ncConnected();
            }
            return;
        }// end function

        public function get streamHeight() : int
        {
            return _streamHeight;
        }// end function

        function connectOnStatus(event:NetStatusEvent) : void
        {
            var _loc_2:ParseResults = null;
            event.target.client.pending = false;
            if (event.info.code == "NetConnection.Connect.Success")
            {
                _nc = _tryNC[event.target.client.connIndex];
                cleanConns();
            }
            else if (event.info.code == "NetConnection.Connect.Rejected" && event.info.ex != null && event.info.ex.code == 302)
            {
                _connTypeCounter = 0;
                cleanConns();
                _loc_2 = parseURL(event.info.ex.redirect);
                if (_loc_2.isRTMP)
                {
                    _protocol = _loc_2.protocol;
                    _serverName = _loc_2.serverName;
                    _wrappedURL = _loc_2.wrappedURL;
                    _portNumber = _loc_2.portNumber;
                    _appName = _loc_2.appName;
                    if (_loc_2.streamName != null)
                    {
                        _appName = _appName + ("/" + _loc_2.streamName);
                    }
                    connectRTMP();
                }
                else
                {
                    tryFallBack();
                }
            }
            else if ((event.info.code == "NetConnection.Connect.Failed" || event.info.code == "NetConnection.Connect.Rejected") && event.target.client.connIndex == (_tryNC.length - 1))
            {
                if (!connectAgain())
                {
                    tryFallBack();
                }
            }
            return;
        }// end function

        function onReconnected() : void
        {
            _ncConnected = true;
            _owner.ncReconnected();
            return;
        }// end function

        function tryFallBack() : void
        {
            if (_serverName == fallbackServerName || fallbackServerName == null)
            {
                _nc = null;
                _ncConnected = false;
                _owner.ncConnected();
            }
            else
            {
                _connTypeCounter = 0;
                cleanConns();
                _serverName = fallbackServerName;
                connectRTMP();
            }
            return;
        }// end function

        public function set bitrate(param1:Number) : void
        {
            if (!_isRTMP)
            {
                _bitrate = param1;
            }
            return;
        }// end function

        function onConnected(param1:NetConnection, param2:Number) : void
        {
            var _loc_3:Array = null;
            var _loc_4:uint = 0;
            var _loc_5:String = null;
            _timeoutTimer.stop();
            param1.removeEventListener(NetStatusEvent.NET_STATUS, connectOnStatus);
            _nc = param1;
            _ncUri = _nc.uri;
            _ncConnected = true;
            if (_autoSenseBW)
            {
                _bitrate = param2 * 1024;
                if (_streams != null)
                {
                    bitrateMatch();
                }
                else
                {
                    _loc_3 = _streamName.split(",");
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3.length)
                    {
                        
                        _loc_5 = stripFrontAndBackWhiteSpace(_loc_3[_loc_4]);
                        if ((_loc_4 + 1) < _loc_3.length)
                        {
                            if (param2 <= Number(_loc_3[(_loc_4 + 1)]))
                            {
                                _streamName = _loc_5;
                                break;
                            }
                        }
                        else
                        {
                            _streamName = _loc_5;
                            break;
                        }
                        _loc_4 = _loc_4 + 2;
                    }
                    if (_streamName.slice(-4).toLowerCase() == ".flv")
                    {
                        _streamName = _streamName.slice(0, -4);
                    }
                }
            }
            if (!_owner.isLive && isNaN(_streamLength))
            {
                _nc.call("getStreamLength", new Responder(getStreamLengthResult), _streamName);
            }
            else
            {
                _owner.ncConnected();
            }
            return;
        }// end function

        public function close() : void
        {
            if (_nc)
            {
                _nc.close();
                _ncConnected = false;
            }
            return;
        }// end function

        static function stripFrontAndBackWhiteSpace(param1:String) : String
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            _loc_3 = param1.length;
            _loc_4 = 0;
            _loc_5 = _loc_3;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                switch(param1.charCodeAt(_loc_2))
                {
                    case 9:
                    case 10:
                    case 13:
                    case 32:
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_4 = _loc_2;
                break;
                _loc_2 = _loc_2 + 1;
            }
            _loc_2 = _loc_3;
            while (_loc_2 >= 0)
            {
                
                switch(param1.charCodeAt(_loc_2))
                {
                    case 9:
                    case 10:
                    case 13:
                    case 32:
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_5 = _loc_2 + 1;
                break;
                _loc_2 = _loc_2 - 1;
            }
            if (_loc_5 <= _loc_4)
            {
                return "";
            }
            return param1.slice(_loc_4, _loc_5);
        }// end function

    }
}
