package fl.video
{
    import flash.net.*;

    public interface INCManager
    {

        public function INCManager();

        function set timeout(param1:uint) : void;

        function get streamLength() : Number;

        function get timeout() : uint;

        function connectToURL(param1:String) : Boolean;

        function get streamName() : String;

        function get bitrate() : Number;

        function get streamHeight() : int;

        function helperDone(param1:Object, param2:Boolean) : void;

        function getProperty(param1:String);

        function get streamWidth() : int;

        function connectAgain() : Boolean;

        function reconnect() : void;

        function set videoPlayer(param1:VideoPlayer) : void;

        function setProperty(param1:String, param2) : void;

        function set bitrate(param1:Number) : void;

        function get netConnection() : NetConnection;

        function get videoPlayer() : VideoPlayer;

        function get isRTMP() : Boolean;

        function close() : void;

    }
}
