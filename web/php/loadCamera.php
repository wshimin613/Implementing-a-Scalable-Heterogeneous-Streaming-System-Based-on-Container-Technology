<?php

require('config.php');
$conn = new mysqli($servername, $user, $pwd, $db);
    
if ($conn->connect_error) {
    die("資料庫連線失敗: " . $conn->connect_error);
}
else {
    $sql = "select * from camera";
    $result = $conn->query($sql);

    if ($result) {
        $rows = array();
        while ($arr = $result->fetch_assoc()) {
            $rows[] = $arr;
        }
        echo json_encode($rows);
    }
    else {
        echo json_encode(array('error' => 'Query failed.'));
    }
}

?>