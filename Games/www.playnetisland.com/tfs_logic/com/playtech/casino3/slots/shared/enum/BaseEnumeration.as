package com.playtech.casino3.slots.shared.enum
{
    import com.playtech.core.*;
    import flash.utils.*;

    public class BaseEnumeration extends Object
    {
        protected const CLASS_NAME:String;
        protected const QUALIFIED_CLASS_NAME:String;
        protected const INSTANTIATION_ERROR:String;
        protected const CLASS:Class;

        public function BaseEnumeration()
        {
            this.QUALIFIED_CLASS_NAME = getQualifiedClassName(this);
            this.CLASS_NAME = this.QUALIFIED_CLASS_NAME.substring((this.QUALIFIED_CLASS_NAME.lastIndexOf(":") + 1));
            this.CLASS = getDefinitionByName(this.QUALIFIED_CLASS_NAME) as Class;
            this.INSTANTIATION_ERROR = "You cant instantiate " + this.CLASS_NAME + " it is Enumeration !!!";
            return;
        }// end function

        public function get type()
        {
            Console.write("Warning Override type in sub class " + this + " of BaseEnumeration !!!");
            return null;
        }// end function

        public function toString(Console:String = "") : String
        {
            return "[ Enumeration " + this.CLASS_NAME + " " + this.type + " : " + Console + " ]";
        }// end function

        static function initEnumerations() : void
        {
            return;
        }// end function

    }
}
