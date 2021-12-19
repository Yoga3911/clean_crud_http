<?php

$host = "localhost";
$user = "root";
$pass = "yyooggaa2020";
$db = "crud";
$table = "warga";

$action = $_POST["action"];
$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die($conn->connect_error);
    return;
}

// Create Table
if ("CREATE_TABLE" == $action) {
    $sql = "CREATE TABLE IF NOT EXISTS $table (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        nama VARCHAR(30) NOT NULL,
        umur VARCHAR(3) NOT NULL
    )";

    if ($conn->query($sql)) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

// Ambil semua data pada tabel
if ("GET_ALL" == $action) {
    $sql = "SELECT * FROM warga";
    $result = $conn->query($sql);

    $datas = [];
    if ($result->num_rows > 0) {
        while ($data = $result->fetch_assoc()) {
            $datas[] = $data;
        }
        echo json_encode($datas);
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

// Tambah data pada tabel
if ("ADD_WARGA" == $action) {
    $nama = $_POST["nama"];
    $umur = $_POST["umur"];
    
    $sql = "INSERT INTO warga (nama, umur) VALUES ('$nama', '$umur')";

    if ($conn->query($sql)) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}

// Update data pada tabel
if ("UPDATE_WARGA" == $action) {
    $id = $_POST["id"];
    $nama = $_POST["nama"];
    $umur = $_POST["umur"];

    $sql = "UPDATE warga SET nama = '$nama', umur = '$umur' WHERE id = '$id'";

    if ($conn->query($sql)) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
    
}

// Hapus data dari tabel
if ("DELETE_WARGA" == $action) {
    $id = $_POST["id"];

    $sql = "DELETE FROM warga WHERE id = '$id'";

    if ($conn->query($sql)) {
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}