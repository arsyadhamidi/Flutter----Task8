<?php

    include_once 'koneksi.php';

    $nama = $_POST['nama'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $id_users = $_POST['id_users'];    
    
    $foto_profile = date("dmYMis").str_replace(" ", " ", basename($_FILES['foto_profile']['name']));
    $imagePath = "upload/".$foto_profile;
    move_uploaded_file($_FILES['foto_profile']['tmp_name'], $imagePath);

    $query = "UPDATE tb_users SET foto_profile='$foto_profile', nama='$nama', email='$email', password='$password' WHERE id_users = '$id_users'";

    $arr = [];
    $result = mysqli_query($db, $query);
    if($result > 0){
        $arr['status'] = 200;
        $arr['error'] = false;
        $arr['message'] = "Edit User Succesfully";
    }else{
        $arr['status'] = 400;
        $arr['error'] = true;
        $arr['message'] = "Edit User Failed!";
    }

    print(json_encode($arr));

?>