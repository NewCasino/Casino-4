package 
{
    import flash.display.*;

    dynamic public class PauseButton extends MovieClip
    {
        public var placeholder_mc:MovieClip;

        public function PauseButton()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        function frame1()
        {
            stop();
            this.upLinkageID = "PauseButtonNormal";
            this.overLinkageID = "PauseButtonOver";
            this.downLinkageID = "PauseButtonDown";
            this.disabledLinkageID = "PauseButtonDisabled";
            return;
        }// end function

    }
}
