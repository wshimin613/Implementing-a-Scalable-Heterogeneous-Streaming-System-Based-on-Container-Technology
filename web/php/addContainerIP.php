<?php

require('config.php');
$conn = new mysqli($servername, $user, $pwd, $db);
        
if ($conn->connect_error) {
    die("連接失敗: " . $conn->connect_error);
}
else {
    $sql = "SELECT MAX(container_ip) AS max_container_ip FROM camera";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $maxContainerIp = $row['max_container_ip'];
        if ($maxContainerIp < 254) {
            echo $maxContainerIp + 1;
        }
        else {
            echo 'Available range is 1 ~ 254';
        }
    }
    else {
        echo 1;
    }
}

?>