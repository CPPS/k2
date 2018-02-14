<?php
/**
 * Provide register functionality.
 *
 * Created by Pieter Kokx
 */

require('init.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $login = $_POST['username'];    

    $mail = "a@a.a";
    $name = $_POST['name'];

    $sql = "INSERT INTO team SET %S";
    $data = array(
        'externalid' => $login, 
        'name' => $name,
        'categoryid' => 2,
        'affilid' => 1,
        'members' => $name
    );
    $tid = $DB->q('RETURNID ' . $sql, $data);
    
    $sql = "INSERT INTO user SET %S";
    $data = array(
        'username' => $login,
        'name' => $name,
        'email' => $mail,
        'teamid' => $tid
    );
    $uid = $DB->q('RETURNID ' . $sql, $data);
    
    $sql = "INSERT INTO userrole SET %S";
    $data = array(
        'userid' => $uid,
        'roleid' => 3
    );
    $DB->q($sql, $data);

    //$response['request'] = array('account_id' => $tid);
    //exit(json_encode($response));
    exit((string)$tid);
}
yolo:
?>
<!DOCTYPE html>
<html lang="en" xml:lang="en">
<head>
    <!-- DOMjudge version 4.0.2 -->
<meta charset="utf-8"/>
<title>Not Authenticated</title>
<link rel="icon" href="../images/favicon.png" type="image/png" />
<link rel="stylesheet" href="../style.css" type="text/css" />
<script type="text/javascript" src="../js/domjudge.js"></script>
</head>
<body>
<h1>Register</h1>

<p>
Register yourself with your TU/e credentials (s-number and password).
</p>

<form action="/domjudge/api/register.php" method="post">
<table>
    <tr>
        <td><label for="username">Username:</label></td>
        <td><input type="text" name="username" size="15" maxlength="15" accesskey="l" autofocus /></td>
    </tr>
    <tr>
        <td><label for="name">Name:</label></td>
        <td><input type="text" name="name" value="" size="15" maxlength="255" accesskey="p" /></td>
    </tr>
    <tr>
        <td></td>
        <td><input type="submit" value="Register" /></td>
    </tr>
</table>
</form>
</body>
</html>
