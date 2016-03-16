package 
{
    import flash.display.*;

    dynamic public class PlayButton extends MovieClip
    {
        public var placeholder_mc:MovieClip;

        public function PlayButton()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        function frame1()
        {
            stop();
            this.upLinkageID = "PlayButtonNormal";
            this.overLinkageID = "PlayButtonOver";
            this.downLinkageID = "PlayButtonDown";
            this.disabledLinkageID = "PlayButtonDisabled";
            return;
        }// end function

    }
}
