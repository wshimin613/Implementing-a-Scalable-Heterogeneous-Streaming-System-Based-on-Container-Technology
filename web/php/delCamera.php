<?php

require('config.php');

if ( empty($_REQUEST['id']) ) {
    echo '沒有傳值';
}
else {
    $conn = new mysqli($servername, $user, $pwd, $db);
        
    if ($conn->connect_error) {
        die("連接失敗: " . $conn->connect_error);
    }
    else {
        $id = str_replace("'", "''", $_REQUEST['id']);
        $sql = "delete from camera where id=$id;";
        $result = $conn->query("$sql");

        if ($result) {
            echo 'success';
        }
        else {
            echo 'error';
        }
    }
}

?>