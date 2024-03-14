<?php

$jsonData = shell_exec("sudo /bin/sh /home/stream/script/load_state.sh");
echo $jsonData;

?>
