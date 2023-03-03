<?php

    include_once 'koneksi.php';

    $arr = [];
    $email = $_POST['email'];
    $password = $_POST['password'];

    $check = "SELECT * FROM tb_users WHERE email ='$email' && password = '$password'";
    $data = mysqli_fetch_array(mysqli_query($db, $check));
    
    if (isset($data)) {
        $arr['status'] = 200;
        $arr['error'] = false;
        $arr['message'] = "Login Succesfully!";
        $arr['data'] = $data;
        print(json_encode($arr));
    }else{
        $arr['status'] = 400;
        $arr['error'] = true;
        $arr['message'] = "Login Failed!";
        print(json_encode($arr));
    }

?>