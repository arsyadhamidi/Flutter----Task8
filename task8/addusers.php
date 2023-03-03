<?php

    include_once 'koneksi.php';

    $nama = $_POST['nama'];
    $email = $_POST['email'];
    $password = $_POST['password'];    
    
    $foto_profile = date("dmYMis").str_replace(" ", " ", basename($_FILES['foto_profile']['name']));
    $imagePath = "upload/".$foto_profile;
    move_uploaded_file($_FILES['foto_profile']['tmp_name'], $imagePath);

    $query = "INSERT INTO tb_users(nama,email,password,foto_profile) VALUES ('$nama','$email','$password','$foto_profile')";

    $arr = [];
    $result = mysqli_query($db, $query);
    if($result > 0){
        $arr['status'] = 200;
        $arr['error'] = false;
        $arr['message'] = "Add Users Succesfully";
    }else{
        $arr['status'] = 400;
        $arr['error'] = true;
        $arr['message'] = "Add Users Failed!";
    }

    print(json_encode($arr));

?>