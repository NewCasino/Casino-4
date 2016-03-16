package fl.video
{
    import flash.net.*;

    public class ConnectClient extends Object
    {
        public var connIndex:uint;
        public var nc:NetConnection;
        public var pending:Boolean;
        public var owner:NCManager;

        public function ConnectClient(param1:NCManager, param2:NetConnection, param3:uint = 0)
        {
            this.owner = param1;
            this.nc = param2;
            this.connIndex = param3;
            this.pending = false;
            return;
        }// end function

        public function onBWCheck(... args) : Number
        {
            args = owner;
            return ++args._payload;
        }// end function

        public function onBWDone(... args) : void
        {
            args = NaN;
            if (args.length > 0)
            {
                args = args[0];
            }
            owner.onConnected(nc, args);
            return;
        }// end function

        public function close() : void
        {
            return;
        }// end function

    }
}
