<?php

/*



?>


<?php




include "../connect.php";
$title=filterRequest('title');
$content=filterRequest('content');
$userid=filterRequest('id');



$stmt=$con->prepare("INSERT INTO `notes`(`notes_title`, `notes_content`, `notes_image`, `notes_users`)
 VALUES (?,?,?)");

$stmt ->execute(array($title,$content,$userid));

$count=$stmt->rowCount();


if($count>0)
{
   echo json_encode(array("status"=>"success"));
}else{
    echo json_encode(array("status"=>"fail"));
}


*/
?>
<?php

include "../connect.php";

$id=filterRequest('id');
$title=filterRequest('title');
$content=filterRequest('content');
$imagename=imageUpload('file');
if($imagename!="fail")
{
    
    $stmt=$con->prepare("
    INSERT INTO `notes` (`notes_title`, `notes_content`, `notes_image`, `notes_users`)
    VALUES ( ?, ? , ?, ?);

    ");

    $stmt->execute(array($title,$content,$imagename,$id));   

    $count=$stmt->rowCount();

    if($count>0)
    {
    echo json_encode(array("status"=>"success"));
    }else{
        echo json_encode(array("status"=>"fail"));
    }

}else{
    echo json_encode(array("status"=>"fail"));
}




?>



