
<?php

include "../connect.php";

$id=filterRequest('id');

$stmt=$con->prepare("SELECT * FROM notes WHERE notes_users = ?");

$stmt->execute(array($id));

$count=$stmt->rowCount();

$data=$stmt->fetchAll(PDO::FETCH_ASSOC);

if($count>0)
{
   echo json_encode(array("status"=>"success","data"=>$data));
}else{
    echo json_encode(array("status"=>"fail"));
}


?>

