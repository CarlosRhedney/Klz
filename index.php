<?php
session_start();

require_once("vendor/autoload.php");

use \Slim\Slim;
use \Klz\Page;
use \Klz\Model\User;

$app = new Slim();

$app->config("debug", true);

$app->get('/admin', function(){

	User::verifyLogin();

	$page = new Page();

	$page->setTpl("index");

});

$app->get('/', function(){

	$page = new Page([
		"header"=>false,
		"footer"=>false
	]);

	$page->setTpl("login");

});

$app->post('/admin/login', function(){

	User::login($_POST["email"], $_POST["password"]);

	header("Location: /admin");

	exit;

});

$app->get('/admin/logout', function(){

	User::logout();

	header("Location: /");

	exit;

});

$app->get('/admin/users', function(){

	User::verifyLogin();

	$users = User::listAll();

	$page = new Page();

	$page->setTpl("users", array(
		"users"=>$users
	));

});

$app->get('/admin/users/create', function(){

	User::verifyLogin();

	$page = new Page();

	$page->setTpl("users-create");

});

$app->get('/admin/users/:idusuario/delete', function($idusuario){

	User::verifyLogin();

	$user = new User();

	$user->get((int)$idusuario);

	$user->delete();

	header("Location: /admin/users");

	exit;

});

$app->get('/admin/users/:idusuario', function($idusuario){

	User::verifyLogin();

	$user = new User();

	$user->get((int)$idusuario);

	$page = new Page();

	$page->setTpl("users-update", array(
		"user"=>$user->getValues()
	));

});

$app->post('/admin/users/create', function(){

	User::verifyLogin();

	$user = new User();

	$user->setData($_POST);

	$user->save();

	header("Location: /admin/users");

	exit;

});

$app->post('/admin/users/:idusuario', function($idusuario){

	User::verifyLogin();

	$user = new User();

	$user->get((int)$idusuario);

	$user->setData($_POST);

	$user->update();

	header("Location: /admin/users");

	exit;

});

$app->run();

?>