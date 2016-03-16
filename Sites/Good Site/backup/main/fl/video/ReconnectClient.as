package fl.video
{

    public class ReconnectClient extends Object
    {
        public var owner:NCManager;

        public function ReconnectClient(param1:NCManager)
        {
            this.owner = param1;
            return;
        }// end function

        public function close() : void
        {
            return;
        }// end function

        public function onBWDone(... args) : void
        {
            owner.onReconnected();
            return;
        }// end function

    }
}
