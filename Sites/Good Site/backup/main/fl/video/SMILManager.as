package fl.video
{
    import flash.events.*;
    import flash.net.*;

    public class SMILManager extends Object
    {
        var width:int;
        var xmlLoader:URLLoader;
        var xml:XML;
        var height:int;
        private var _url:String;
        var videoTags:Array;
        var baseURLAttr:Array;
        private var _owner:INCManager;
        public static const VERSION:String = "2.1.0.14";
        public static const SHORT_VERSION:String = "2.1";

        public function SMILManager(param1:INCManager)
        {
            _owner = param1;
            width = -1;
            height = -1;
            return;
        }// end function

        function parseVideo(param1:XML) : Object
        {
            var _loc_2:Object = null;
            default xml namespace = xml.namespace();
            _loc_2 = new Object();
            if (param1.@src.length() > 0)
            {
                _loc_2.src = param1.@src.toString();
            }
            if (param1["system-bitrate"].length() > 0)
            {
                _loc_2.bitrate = int(param1["system-bitrate"].toString());
            }
            if (param1.@dur.length() > 0)
            {
                _loc_2.dur = parseTime(param1.@dur.toString());
            }
            return _loc_2;
        }// end function

        function connectXML(param1:String) : Boolean
        {
            _url = fixURL(param1);
            xmlLoader = new URLLoader();
            xmlLoader.addEventListener(Event.COMPLETE, xmlLoadEventHandler);
            xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadEventHandler);
            xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlLoadEventHandler);
            xmlLoader.load(new URLRequest(_url));
            return false;
        }// end function

        function parseSwitch(param1:XML) : void
        {
            var _loc_2:String = null;
            var _loc_3:XML = null;
            default xml namespace = xml.namespace();
            for (_loc_2 in param1.*)
            {
                
                _loc_3 = param1.*[_loc_2];
                if (_loc_3.nodeKind() != "element")
                {
                    continue;
                }
                switch(_loc_3.localName())
                {
                    case "video":
                    case "ref":
                    {
                        videoTags.push(parseVideo(_loc_3));
                        break;
                    }
                    default:
                    {
                        break;
                        break;
                    }
                }
            }
            return;
        }// end function

        function fixURL(param1:String) : String
        {
            var _loc_2:String = null;
            if (/^(http:|https:)""^(http:|https:)/i.test(param1))
            {
                _loc_2 = param1.indexOf("?") >= 0 ? ("&") : ("?");
                return param1 + _loc_2 + "FLVPlaybackVersion=" + SHORT_VERSION;
            }
            return param1;
        }// end function

        function xmlLoadEventHandler(event:Event) : void
        {
            var e:* = event;
            try
            {
                if (e.type != Event.COMPLETE)
                {
                    _owner.helperDone(this, false);
                }
                else
                {
                    baseURLAttr = new Array();
                    videoTags = new Array();
                    xml = new XML(xmlLoader.data);
                    default xml namespace = xml.namespace();
                    if (xml == null || xml.localName() == null)
                    {
                        throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" No root node found; if url is for an flv it must have .flv extension and take no parameters");
                    }
                    else if (xml.localName() != "smil")
                    {
                        throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" Root node not smil");
                    }
                    checkForIllegalNodes(xml, "element", ["head", "body"]);
                    if (xml.head.length() > 0)
                    {
                        parseHead(xml.head[0]);
                    }
                    if (xml.body.length() < 1)
                    {
                        throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" Tag body is required.");
                    }
                    else
                    {
                        parseBody(xml.body[0]);
                    }
                    _owner.helperDone(this, true);
                }
            }
            catch (err:Error)
            {
                _owner.helperDone(this, false);
                throw err;
            }
            finally
            {
                xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadEventHandler);
                xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlLoadEventHandler);
                xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, xmlLoadEventHandler);
                xmlLoader = null;
            }
            return;
        }// end function

        function checkForIllegalNodes(param1:XML, param2:String, param3:Array) : void
        {
            var _loc_4:String = null;
            var _loc_5:Boolean = false;
            var _loc_6:XML = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            default xml namespace = xml.namespace();
            for (_loc_4 in param1.*)
            {
                
                _loc_5 = false;
                _loc_6 = param1.*[_loc_4];
                if (_loc_6.nodeKind() != param2)
                {
                    continue;
                }
                _loc_7 = _loc_6.localName();
                for (_loc_8 in param3)
                {
                    
                    if (param3[_loc_8] == _loc_7)
                    {
                        _loc_5 = true;
                        break;
                    }
                }
                if (!_loc_5)
                {
                    throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" " + param2 + " " + _loc_7 + " not supported in " + param1.localName() + " tag.");
                }
            }
            return;
        }// end function

        function parseHead(param1:XML) : void
        {
            default xml namespace = xml.namespace();
            checkForIllegalNodes(param1, "element", ["meta", "layout"]);
            if (param1.meta.length() > 0)
            {
                checkForIllegalNodes(param1.meta[0], "element", []);
                checkForIllegalNodes(param1.meta[0], "attribute", ["base"]);
                if (param1.meta.@base.length() > 0)
                {
                    baseURLAttr.push(param1.meta.@base.toString());
                }
            }
            if (param1.layout.length() > 0)
            {
                parseLayout(param1.layout[0]);
            }
            return;
        }// end function

        function parseBody(param1:XML) : void
        {
            var _loc_2:XML = null;
            var _loc_3:String = null;
            var _loc_4:Object = null;
            default xml namespace = xml.namespace();
            if (param1.*.length() != 1 || param1.*[0].nodeKind() != "element")
            {
                throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" Tag " + param1.localName() + " is required to contain exactly one tag.");
            }
            _loc_2 = param1.*[0];
            _loc_3 = _loc_2.localName();
            switch(_loc_3)
            {
                case "switch":
                {
                    parseSwitch(_loc_2);
                    break;
                }
                case "video":
                case "ref":
                {
                    _loc_4 = parseVideo(_loc_2);
                    videoTags.push(_loc_4);
                    break;
                }
                default:
                {
                    throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" Tag " + _loc_3 + " not supported in " + param1.localName() + " tag.");
                    break;
                }
            }
            if (videoTags.length < 1)
            {
                throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" At least one video of ref tag is required.");
            }
            return;
        }// end function

        function parseTime(param1:String) : Number
        {
            var _loc_2:Object = null;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            default xml namespace = xml.namespace();
            _loc_2 = /^((\d+):)?(\d+):((\d+)(.\d+)?)$""^((\d+):)?(\d+):((\d+)(.\d+)?)$/.exec(param1);
            if (_loc_2 == null)
            {
                _loc_3 = Number(param1);
                if (isNaN(_loc_3) || _loc_3 < 0)
                {
                    throw new VideoError(VideoError.INVALID_XML, "Invalid dur value: " + param1);
                }
                return _loc_3;
            }
            else
            {
                _loc_4 = 0;
                _loc_4 = _loc_4 + uint(_loc_2[2]) * 60 * 60;
                _loc_4 = _loc_4 + uint(_loc_2[3]) * 60;
                _loc_4 = _loc_4 + Number(_loc_2[4]);
                return _loc_4;
            }
        }// end function

        function parseLayout(param1:XML) : void
        {
            var _loc_2:XML = null;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            default xml namespace = xml.namespace();
            checkForIllegalNodes(param1, "element", ["root-layout"]);
            if (param1["root-layout"].length() > 1)
            {
                throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" Only one base attribute supported in meta tag.");
            }
            if (param1["root-layout"].length() > 0)
            {
                _loc_2 = param1["root-layout"][0];
                if (_loc_2.@width.length() > 0)
                {
                    _loc_3 = Number(_loc_2.@width[0]);
                }
                if (_loc_2.@height.length() > 0)
                {
                    _loc_4 = Number(_loc_2.@height[0]);
                }
                if (isNaN(_loc_3) || _loc_3 < 0 || isNaN(_loc_4) || _loc_4 < 0)
                {
                    throw new VideoError(VideoError.INVALID_XML, "URL: \"" + _url + "\" Tag " + param1.localName() + " requires attributes width and height.  Width and height must be numbers greater than or equal to 0.");
                }
                width = Math.round(_loc_3);
                height = Math.round(_loc_4);
            }
            return;
        }// end function

    }
}
