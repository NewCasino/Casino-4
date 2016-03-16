package com.playtech.casino3.enum
{

    final public class SharedError extends Object
    {
        public static const ERR_JACKPOTBALANCE:uint = 13;
        public static const ERR_GAMEUNAVAILABLE:uint = 610;
        private static const ERR_RG_EXTENDED:uint = 724;
        public static const ERR_SUPPORTNOTAVAILABLE:uint = 15;
        public static const ERR_RG_SESSION_TIMER:uint = 710;
        public static const ERR_RG_MONTH_LOSS_LIMIT:uint = 714;
        public static const ERR_GAMEFROZEN:uint = 28;
        public static const ERR_RG_WEEK_BET_LIMIT:uint = 717;
        public static const ERR_RG_WEEK_LOSS_LIMIT:uint = 713;
        public static const ERR_ONLYREALMONEY:uint = 615;
        public static const ERR_OK:uint = 0;
        public static const ERR_RG_MONTH_BET_LIMIT:uint = 718;
        public static const ERR_SYSTEM:uint = 6;
        public static const ERR_FEATURENOTAVAILABLE:uint = 644;
        public static const ERR_CREDIT:uint = 27;
        public static const ERR_BALANCE_LOW:uint = 108;
        public static const ERR_RG_SESSION_LOSS_LIMIT:uint = 711;
        public static const ERR_RG_DAY_LOSS_LIMIT:uint = 712;
        public static const ERR_RG_DAY_BET_LIMIT:uint = 716;
        public static const ERR_RG_SESSION_BET_LIMIT:uint = 715;

        public function SharedError()
        {
            return;
        }// end function

        public static function isRGError(ERR_RG_MONTH_BET_LIMIT:uint) : Boolean
        {
            return ERR_RG_MONTH_BET_LIMIT >= ERR_RG_SESSION_TIMER && ERR_RG_MONTH_BET_LIMIT <= ERR_RG_EXTENDED;
        }// end function

    }
}
