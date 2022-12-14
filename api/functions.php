<?php

define("MB",1048576);
function filterRequest($requestName)
{
    return htmlspecialchars(strip_tags($_POST[$requestName]));
}

// دالة رفع الصورة
function imageUpload($imageRequest)
{
    
    global $msgError;
    $imagename=uniqid().$_FILES[$imageRequest]['name'];
    $imagtmp=$_FILES[$imageRequest]['tmp_name'];
    $imagesize=$_FILES[$imageRequest]['size'];
    $allowExt=array("jpg" , "png" , "gif" , "mp3" , "pdf");
    $strToArray = explode("." ,$imagename);
    $ext = end($strToArray);
    $ext=strtolower($ext);
    if(!empty($imagename)  && !in_array($ext,$allowExt)){
        $msgError[]="Ext Error";
    }
    if($imagesize  > 2* MB ){
        $msgError[]="Size Error";
    }
  if(empty($msgError))
  {
    move_uploaded_file($imagtmp,"../upload/".$imagename);
    return $imagename;
  }else{
    print_r($msgError);
    return "fail";
  }

}
// دالة حذف الملفات

function deleteFile($dir , $filename)
{
    if(file_exists($dir."/".$filename))
    {
        unlink($dir."/".$filename);
        
    }
}
//
function checkAuthenticate()
{
    if (isset($_SERVER['PHP_AUTH_USER'])  && isset($_SERVER['PHP_AUTH_PW'])) {
        if ($_SERVER['PHP_AUTH_USER'] != "haytham" ||  $_SERVER['PHP_AUTH_PW'] != "ww227"){
            header('WWW-Authenticate: Basic realm="My Realm"');
            header('HTTP/1.0 401 Unauthorized');
            echo 'Page Not Found';
            exit;
        }
    } else {
        exit;
    }
}

?>