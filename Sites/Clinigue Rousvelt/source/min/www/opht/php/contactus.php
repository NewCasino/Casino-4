<?
// edit these 3 items
$sendTo  =  "najette@derni.com"; // your email - should be the same as the server domain otherwise the mail might not send (some servers restrict the use of the mail() command to avaoid any risk of spam)
$subjectPre = "Website Query: Clinique Roosevelt"; // a 'prefix' for the subject
$msg = "This is the response from the php script. You can edit this in the php file. Thanks for trying out the form"; // your thank you message


// No need to edit this
$subject = $_POST["subject"];
$headers = "De: " . $_POST["name"];
$headers .= "<" . $_POST["email"] . ">\r\n";
$headers .= "Reply-To: " . $_POST["email"] . "\r\n";
$headers .= "Return-Path: " . $_POST["email"];
$message = $_POST["message"];

$mailSent = mail($sendTo, $subject, $message, $headers); 

echo "&returnMessage=$msg"; 
?>