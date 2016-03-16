/** 
* @author Alex PICA
* @version 1.0
* 
* Class: FlashDenPreviewFileProtection
* Description: I made this class to prevent the theft of the preview files from flashden.net
*/
import mx.utils.CollectionImpl;
import mx.utils.IteratorImpl;

class com.alexandrup.FlashDenPreviewFileProtection {

    //this var will be set to true when compiling preview files
    public static var IsPreviewFile:Boolean = false;

    /**
     * Tests if the current SWF file is stolen
     * @return TRUE if it is a stolen swf
     */
    public static function isStolenSWF():Boolean {
        //do not check if this is the fullversion file
        if (IsPreviewFile === false) return false;

        var _domain:String = (new LocalConnection()).domain();
        var _allowedDomainList:CollectionImpl = new CollectionImpl();

        //------- add here all strings that would have to be found in allowed domain names --------o
        _allowedDomainList.addItem("flashden");
        _allowedDomainList.addItem("localhost");    //add localhost and 127.0.0.1 to be able to run locally
        _allowedDomainList.addItem("127.0.0.1");
		_allowedDomainList.addItem("s3.envato.com");
		_allowedDomainList.addItem("cdn.envato.com");
		_allowedDomainList.addItem("mbudm.com");
        //--------------------------------------------o

        var _it:IteratorImpl = IteratorImpl(_allowedDomainList.getIterator());
        while (_it.hasNext()) {
            if (_domain.toLowerCase().indexOf(_it.next().toString().toLowerCase(), 0) > -1) {
                return false;
            }
        }

        return true;
    }

    //private constructor to prevent instantiation
    private function FlashDenPreviewFileProtection() { };
}
