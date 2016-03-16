package 
{
    import flash.display.*;

    dynamic public class SeekBar extends MovieClip
    {
        public var hit_mc:MovieClip;
        public var progress_mc:MovieClip;
        public var fullness_mc:MovieClip;

        public function SeekBar()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        function frame1()
        {
            stop();
            this.handleLinkageID = "SeekBarHandle";
            this.handleLeftMargin = 2;
            this.handleRightMargin = 2;
            this.handleY = 0;
            return;
        }// end function

    }
}
