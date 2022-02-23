<?php
namespace Klz\Model;

use \Klz\DB\Sql;
use \Klz\Model;

class User extends Model
{
	const SESSION = "User";

	public static function login($email, $password)
	{
		$sql = new Sql();

		$results = $sql->select("SELECT * FROM tb_usuario WHERE email = :email", array(
			":email"=>$email
		));

		if(count($results) === 0){

			throw new \Exception("Usuário e ou senha inválidos!");

		}

		$data = $results[0];

		if(password_verify($password, $data["password"]) === true){

			$user = new User();

			$user->setData($data);

			$_SESSION[User::SESSION] = $user->getValues();

			return $user;

		}else{

			throw new \Exception("Usuário e ou senha inválidos!");

		}
	}

	public static function verifyLogin()
	{
		if(
			!isset($_SESSION[User::SESSION])
			||
			!$_SESSION[User::SESSION]
			||
			!(int)$_SESSION[User::SESSION]["idusuario"] > 0
		){

			header("Location: /");

			exit;

		}
	}

	public static function logout()
	{

		$_SESSION[User::SESSION] = NULL;
		
	}

	public static function listAll()
	{
		$sql = new Sql();

		return $sql->select("SELECT * FROM tb_usuario a INNER JOIN tb_pessoa b USING(idusuario) ORDER BY b.nome");
	}

	public function save()
	{
		$sql = new Sql();

		$results = $sql->select("CALL sp_users_save(:nome, :idade, :email)", array(
			":nome"=>$this->getnome(),
			":email"=>$this->getemail(),
			":idade"=>$this->getidade()
		));

		$this->setData($results[0]);
		
	}

	public function get($idusuario)
	{
		$sql = new Sql();

		$results = $sql->select("SELECT * FROM tb_usuario a INNER JOIN tb_pessoa b USING(idusuario) WHERE idusuario = :idusuario", array(
			":idusuario"=>$idusuario
		));

		$this->setData($results[0]);

	}

	public function update()
	{
		$sql = new Sql();

		$results = $sql->select("CALL sp_usersupdate_save(:idusuario, :nome, :idade, :email)", array(
			":idusuario"=>$this->getidusuario(),
			":nome"=>$this->getnome(),
			":idade"=>$this->getidade(),
			":email"=>$this->getemail()
		));

		$this->setData($results[0]);
		
	}

	public function delete()
	{
		$sql = new Sql();

		$sql->query("CALL sp_users_delete(:idusuario)", array(
			":idusuario"=>$this->getidusuario()
		));
	}
}
?>