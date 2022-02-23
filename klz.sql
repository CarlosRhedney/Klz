-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 23-Fev-2022 às 06:58
-- Versão do servidor: 10.4.14-MariaDB
-- versão do PHP: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `klz`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usersupdate_save` (`pidusuario` INT, `pnome` VARCHAR(64), `pidade` INT(11), `pemail` VARCHAR(128))  BEGIN
  
    DECLARE vidusuario INT;
    
  SELECT idusuario INTO vidusuario
    FROM tb_usuario
    WHERE idusuario = pidusuario;
    
    UPDATE tb_pessoa
    SET 
    nome = pnome,
    idade = pidade
  WHERE idusuario = vidusuario;
    
    UPDATE tb_usuario
    SET
        email = pemail
  WHERE idusuario = pidusuario;
    
    SELECT * FROM tb_usuario a INNER JOIN tb_pessoa b USING(idusuario) WHERE a.idusuario = pidusuario;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_delete` (`pidusuario` INT)  BEGIN
  
    DECLARE vidpessoa INT;
    
  SELECT idpessoa INTO vidpessoa
    FROM tb_pessoa
    WHERE idusuario = pidusuario;
    
    DELETE FROM tb_usuario WHERE idusuario = pidusuario;
    DELETE FROM tb_pessoa WHERE idpessoa = vidpessoa;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_save` (`pnome` VARCHAR(64), `pidade` INT(11), `pemail` VARCHAR(128))  BEGIN
  
    DECLARE vidusuario INT;

    INSERT INTO tb_usuario (email)
    VALUES(pemail);

    SET vidusuario = LAST_INSERT_ID();
    
  INSERT INTO tb_pessoa (idusuario, nome, idade)
    VALUES(vidusuario, pnome, pidade);
    
    SELECT * FROM tb_usuario a INNER JOIN tb_pessoa b USING(idusuario) WHERE a.idusuario = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_pessoa`
--

CREATE TABLE `tb_pessoa` (
  `idpessoa` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `nome` varchar(64) NOT NULL,
  `idade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_pessoa`
--

INSERT INTO `tb_pessoa` (`idpessoa`, `idusuario`, `nome`, `idade`) VALUES
(1, 1, 'Carlos Rhedney', 32);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_usuario`
--

CREATE TABLE `tb_usuario` (
  `idusuario` int(11) NOT NULL,
  `email` varchar(64) NOT NULL,
  `password` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_usuario`
--

INSERT INTO `tb_usuario` (`idusuario`, `email`, `password`) VALUES
(1, 'twisterpsa@hotmail.com', '$2y$12$YlooCyNvyTji8bPRcrfNfOKnVMmZA9ViM2A3IpFjmrpIbp5ovNmga');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `tb_pessoa`
--
ALTER TABLE `tb_pessoa`
  ADD PRIMARY KEY (`idpessoa`),
  ADD KEY `FK_pessoa_usuario_idx` (`idusuario`);

--
-- Índices para tabela `tb_usuario`
--
ALTER TABLE `tb_usuario`
  ADD PRIMARY KEY (`idusuario`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `tb_pessoa`
--
ALTER TABLE `tb_pessoa`
  MODIFY `idpessoa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `tb_usuario`
--
ALTER TABLE `tb_usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `tb_pessoa`
--
ALTER TABLE `tb_pessoa`
  ADD CONSTRAINT `fk_pessoa_usuario` FOREIGN KEY (`idusuario`) REFERENCES `tb_usuario` (`idusuario`) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
