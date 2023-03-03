<?php

    include_once 'koneksi.php';

    if(isset($_POST["id_users"])){
        $id_users = $_POST["id_users"];
    }else return;

    $query = "DELETE FROM tb_users WHERE id_users ='$id_users'";

    $execute = mysqli_query($db, $query);

    $arr = [];

    if($execute > 0){
        $arr['status'] = 200;
        $arr['message'] = "Data Delete Successfully";
    }else{
        $arr['status'] = 200;
        $arr['message'] = "Data Delete Successfully";
    }

    print(json_encode($arr));

?>