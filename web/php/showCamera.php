<?php

require('config.php');

$conn = new mysqli($servername, $user, $pwd, $db);    
if ($conn->connect_error) {
    die("資料庫連線失敗: " . $conn->connect_error);
}
else {
    $id = str_replace("'", "''", $_REQUEST['id']);
    $sql = "select name,ip,container_ip from camera where id=$id;";
    $result = $conn->query("$sql");
        
    if ($result) {
        $arr = $result->fetch_assoc();
        echo json_encode($arr);
    } 
    else {
        echo json_encode(array('error' => 'Query failed.'));
    }
}

?>