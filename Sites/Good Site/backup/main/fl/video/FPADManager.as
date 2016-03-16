package fl.video
{
    import flash.events.*;
    import flash.net.*;

    public class FPADManager extends Object
    {
        var _parseResults:ParseResults;
        var rtmpURL:String;
        var _url:String;
        var xmlLoader:URLLoader;
        var xml:XML;
        var _uriParam:String;
        private var _owner:INCManager;
        public static const VERSION:String = "2.1.0.14";
        public static const SHORT_VERSION:String = "2.1";

        public function FPADManager(param1:INCManager)
        {
            _owner = param1;
            return;
        }// end function

        function connectXML(param1:String, param2:String, param3:String, param4:ParseResults) : Boolean
        {
            _uriParam = param2;
            _parseResults = param4;
            _url = param1 + "uri=" + _parseResults.protocol;
            if (_parseResults.serverName != null)
            {
                _url = _url + ("/" + _parseResults.serverName);
            }
            if (_parseResults.portNumber != null)
            {
                _url = _url + (":" + _parseResults.portNumber);
            }
            if (_parseResults.wrappedURL != null)
            {
                _url = _url + ("/?" + _parseResults.wrappedURL);
            }
            _url = _url + ("/" + _parseResults.appName);
            _url = _url + param3;
            xml = new XML();
            xmlLoader = new URLLoader();
            xmlLoader.addEventListener(Event.COMPLETE, xmlLoadEventHandler);
            xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadEventHandler);
            xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlLoadEventHandler);
            xmlLoader.load(new URLRequest(_url));
            return false;
        }// end function

        function xmlLoadEventHandler(event:Event) : void
        {
            var proxy:String;
            var e:* = event;
            try
            {
                if (e.type != Event.COMPLETE)
                {
                    _owner.helperDone(this, false);
                }
                else
                {
                    xml = new XML(xmlLoader.data);
                    if (xml == null || xml.localName() == null)
                    {
                        throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" No root node found; if url is for an flv it must have .flv extension and take no parameters");
                    }
                    else if (xml.localName() != "fpad")
                    {
                        throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" Root node not fpad");
                    }
                    proxy;
                    if (xml.proxy.length() > 0 && xml.proxy.hasSimpleContent() && xml.proxy.*[0].nodeKind() == "text")
                    {
                        proxy = xml.proxy.*[0].toString();
                    }
                    if (proxy == null)
                    {
                        throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" fpad xml requires proxy tag.");
                    }
                    rtmpURL = _parseResults.protocol + "/" + proxy + "/?" + _uriParam;
                    _owner.helperDone(this, true);
                }
            }
            catch (err:Error)
            {
                _owner.helperDone(this, false);
                throw err;
            }
            return;
        }// end function

    }
}
