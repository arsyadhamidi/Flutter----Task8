<?php

    include_once 'koneksi.php';

    $query = "SELECT * FROM tb_users";

    $result = mysqli_query($db, $query);

    $arr = [];

    while($data = mysqli_fetch_array($result)){
        $arr[] = $data;
    }

    print(json_encode($arr));

?>