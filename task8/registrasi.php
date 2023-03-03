<?php

    include_once "koneksi.php";

    $arr = [];

    $nama = $_POST['nama'];
    $email = $_POST['email'];
    $password = $_POST['password'];

    $check = "SELECT * FROM tb_users WHERE email ='$email'";
    $data = mysqli_fetch_array(mysqli_query($db, $check));

    if(isset($data)){
        $arr['status'] = 400;
        $arr['message'] = "Email already in use!";
        $arr['data'] = $data;
        print(json_encode($arr));
    }else{
        $query = "INSERT INTO tb_users(nama, email, password) VALUES ('$nama','$email','$password')";

        $result = mysqli_query($db, $query);

        if($result > 0){
            $arr['status'] = 200;
            $arr['error'] = false;
            $arr['message'] = "Add Data Successfully";
            print(json_encode($arr));
        }else{
            $arr['status'] = 400;
            $arr['error'] = true;
            $arr['message'] = "Add Data Successfully";
            print(json_encode($arr));
        }

    }
?>