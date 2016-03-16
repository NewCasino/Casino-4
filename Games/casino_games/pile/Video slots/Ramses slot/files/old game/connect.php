<?

$host="localhost";
$user="";
$pswd="";
$dbh="";
$database="gamblersclub";
$table_name="";

$dbh=MYSQL_CONNECT($host, $user, $pswd) OR DIE("Can not connected to database.");
@mysql_select_db($database) or log("Can not select database.");


function _log($somecontent) {
	$filename="fileocska.txt";
	$date = date('y/m/d-h:i:s');
	if (file_exists($filename)) {
	 $handle=fopen($filename, 'a');
	} else { 
	 $handle=fopen($filename, 'w');
	}
	fwrite($handle, $date.':'.$somecontent."<br>\n"); 
	  
}
	
	

?>
