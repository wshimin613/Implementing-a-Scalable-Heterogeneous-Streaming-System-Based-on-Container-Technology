<?php

if ( empty($_REQUEST['date']) ) {
    echo 'null_value';
}
else {
    $date = str_replace("'", "''", $_REQUEST['date']);
    $result = shell_exec("sudo /bin/sh /home/stream/script/query.sh $date");
    echo $result;
}

?>
