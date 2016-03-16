package com.playtech.casino3.slots.shared.novel.novelComponents.messageWindows
{
    import com.playtech.casino3.slots.shared.novel.novelEnums.*;

    public class WindowParameters extends Object
    {
        private var m_linkageBackground:String;
        private var m_inAnimation:int;
        private var m_hasContinueBtn:Boolean = false;
        private var m_inSound:String;
        private var m_linkageName:String;
        private var m_duration:int = -1;
        private var m_clickTarget:int;
        private var m_outAnimation:int;
        private var m_outSound:String;

        public function WindowParameters()
        {
            this.m_clickTarget = MessageWindowInfo.NONE;
            this.m_inAnimation = MessageWindowInfo.NO_ANIM;
            this.m_outAnimation = MessageWindowInfo.NO_ANIM;
            return;
        }// end function

        public function get outSound() : String
        {
            return this.m_outSound;
        }// end function

        public function set outSound(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as:String) : void
        {
            this.m_outSound = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as;
            return;
        }// end function

        public function get linkageBackground() : String
        {
            return this.m_linkageBackground;
        }// end function

        public function get outAnimation() : int
        {
            return this.m_outAnimation;
        }// end function

        public function get duration() : int
        {
            return this.m_duration;
        }// end function

        public function get inAnimation() : int
        {
            return this.m_inAnimation;
        }// end function

        public function set linkageName(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as:String) : void
        {
            this.m_linkageName = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as;
            return;
        }// end function

        public function set inSound(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as:String) : void
        {
            this.m_inSound = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as;
            return;
        }// end function

        public function get inSound() : String
        {
            return this.m_inSound;
        }// end function

        public function set outAnimation(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as:int) : void
        {
            this.m_outAnimation = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as;
            return;
        }// end function

        public function set linkageBackground(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as:String) : void
        {
            this.m_linkageBackground = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as;
            return;
        }// end function

        public function set duration(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as:int) : void
        {
            this.m_duration = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as;
            return;
        }// end function

        public function set clickTarget(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as:int) : void
        {
            this.m_clickTarget = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as;
            return;
        }// end function

        public function set hasContinueBtn(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as:Boolean) : void
        {
            this.m_hasContinueBtn = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as;
            return;
        }// end function

        public function get linkageName() : String
        {
            return this.m_linkageName;
        }// end function

        public function get clickTarget() : int
        {
            return this.m_clickTarget;
        }// end function

        public function get hasContinueBtn() : Boolean
        {
            return this.m_hasContinueBtn;
        }// end function

        public function set inAnimation(D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as:int) : void
        {
            this.m_inAnimation = D:\projects\build_10.1\webclient;com\playtech\casino3\slots\shared\novel\novelComponents\messageWindows;WindowParameters.as;
            return;
        }// end function

    }
}
