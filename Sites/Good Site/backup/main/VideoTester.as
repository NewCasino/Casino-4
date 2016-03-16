package 
{
    import fl.video.*;
    import flash.display.*;

    dynamic public class VideoTester extends MovieClip
    {
        public var flvPlayer:FLVPlayback;
        public var mySeekBar:SeekBar;
        public var fp:FLVPlayback;

        public function VideoTester()
        {
            addFrameScript(0, frame1);
            __setProp_flvPlayer_VideoTester_flvPlayer_0();
            return;
        }// end function

        function __setProp_flvPlayer_VideoTester_flvPlayer_0()
        {
            try
            {
                flvPlayer["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            flvPlayer.align = "center";
            flvPlayer.autoPlay = true;
            flvPlayer.scaleMode = "maintainAspectRatio";
            flvPlayer.skin = "";
            flvPlayer.skinAutoHide = false;
            flvPlayer.skinBackgroundAlpha = 1;
            flvPlayer.skinBackgroundColor = 4697035;
            flvPlayer.source = "";
            flvPlayer.volume = 1;
            try
            {
                flvPlayer["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function frame1()
        {
            fp = flvPlayer;
            fp.seekBar = mySeekBar;
            fp.source = "assets/videos/hancock-tsr2_h480p.flv";
            return;
        }// end function

    }
}
