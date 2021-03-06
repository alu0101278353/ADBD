-- MySQL Script generated by MySQL Workbench
-- vie 13 nov 2020 23:31:29 WET
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema catastro
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema catastro
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `catastro` ;
USE `catastro` ;

-- -----------------------------------------------------
-- Table `catastro`.`zona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`zona` (
  `nombre` TEXT NOT NULL,
  `area` GEOMETRY NOT NULL,
  `consejal_responsable` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`calle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`calle` (
  `nombre` TEXT NOT NULL,
  `nombre_zona` TEXT NOT NULL,
  PRIMARY KEY (`nombre`),
  INDEX `nombre_zona_idx` (`nombre_zona` ASC) VISIBLE,
  CONSTRAINT `nombre_zona`
    FOREIGN KEY (`nombre_zona`)
    REFERENCES `catastro`.`zona` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`construccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`construccion` (
  `numero_construccion` INT NOT NULL,
  `año_construccion` DATE NOT NULL,
  `coordenada_geografica` VARCHAR(45) NOT NULL,
  `nombre_calle` TEXT NOT NULL,
  PRIMARY KEY (`numero_construccion`, `año_construccion`, `coordenada_geografica`),
  INDEX `nombre_calle_idx` (`nombre_calle` ASC) VISIBLE,
  CONSTRAINT `nombre_calle`
    FOREIGN KEY (`nombre_calle`)
    REFERENCES `catastro`.`calle` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`bloque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`bloque` (
  `numero_construccion` INT NULL,
  `año_construccion` DATE NOT NULL,
  `cantidad_bloques` INT NOT NULL,
  `coordenada_geografica` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`numero_construccion`),
  INDEX `año_construccion_idx` (`año_construccion` ASC) VISIBLE,
  INDEX `coordenada_geografica_idx` (`coordenada_geografica` ASC) VISIBLE,
  CONSTRAINT `numero_construccion`
    FOREIGN KEY (`numero_construccion`)
    REFERENCES `catastro`.`construccion` (`numero_construccion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `año_construccion`
    FOREIGN KEY (`año_construccion`)
    REFERENCES `catastro`.`construccion` (`año_construccion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `coordenada_geografica`
    FOREIGN KEY (`coordenada_geografica`)
    REFERENCES `catastro`.`construccion` (`coordenada_geografica`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`piso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`piso` (
  `superficie` GEOMETRY NOT NULL,
  `cantidad_baños` INT NOT NULL,
  `cantidad_habitaciones` INT NOT NULL,
  `letra` VARCHAR(45) NOT NULL,
  `planta` VARCHAR(45) NOT NULL,
  `numero_construccion_B` INT NOT NULL,
  INDEX `numero_construccion_idx` (`numero_construccion_B` ASC) VISIBLE,
  PRIMARY KEY (`planta`),
  CONSTRAINT `numero_construccion`
    FOREIGN KEY (`numero_construccion_B`)
    REFERENCES `catastro`.`bloque` (`numero_construccion`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`unifamiliar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`unifamiliar` (
  `numero_construccion` INT NOT NULL,
  `año_construccion` DATE NOT NULL,
  `coordenada_geografica` VARCHAR(45) NOT NULL,
  `cantidad_de_personas` INT NOT NULL,
  `eficiencia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`numero_construccion`),
  INDEX `año_construccion_idx` (`año_construccion` ASC) VISIBLE,
  INDEX `coordenada_geografica_idx` (`coordenada_geografica` ASC) VISIBLE,
  CONSTRAINT `numero_construccion`
    FOREIGN KEY (`numero_construccion`)
    REFERENCES `catastro`.`construccion` (`numero_construccion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `año_construccion`
    FOREIGN KEY (`año_construccion`)
    REFERENCES `catastro`.`construccion` (`año_construccion`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `coordenada_geografica`
    FOREIGN KEY (`coordenada_geografica`)
    REFERENCES `catastro`.`construccion` (`coordenada_geografica`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `catastro`.`personas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catastro`.`personas` (
  `nombre` VARCHAR(40) NOT NULL,
  `fecha_nacimiento` DATE NOT NULL,
  `dni` VARCHAR(45) NOT NULL,
  `persona_cabeza` VARCHAR(45) NOT NULL,
  `habita_persona_piso` VARCHAR(45) NOT NULL,
  `propietario_persona` VARCHAR(45) NOT NULL,
  `habita_persona_unifamiliar` INT NOT NULL,
  PRIMARY KEY (`dni`),
  INDEX `persona_cabeza` (`persona_cabeza` ASC) VISIBLE,
  UNIQUE INDEX `dni_UNIQUE` (`dni` ASC) VISIBLE,
  INDEX `habita_persona_idx` (`habita_persona_piso` ASC) VISIBLE,
  INDEX `propietario_persona_idx` (`propietario_persona` ASC) VISIBLE,
  INDEX `habita_persona_unifamiliar_idx` (`habita_persona_unifamiliar` ASC) VISIBLE,
  CONSTRAINT `persona_cabeza`
    FOREIGN KEY (`persona_cabeza`)
    REFERENCES `catastro`.`personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `habita_persona_piso`
    FOREIGN KEY (`habita_persona_piso`)
    REFERENCES `catastro`.`piso` (`planta`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `propietario_persona`
    FOREIGN KEY (`propietario_persona`)
    REFERENCES `catastro`.`piso` (`planta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `habita_persona_unifamiliar`
    FOREIGN KEY (`habita_persona_unifamiliar`)
    REFERENCES `catastro`.`unifamiliar` (`numero_construccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
