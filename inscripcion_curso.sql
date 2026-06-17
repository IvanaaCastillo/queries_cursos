-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE,
SQL_MODE = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema inscripciones_cursos
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS inscripciones_cursos
DEFAULT CHARACTER SET utf8;

USE inscripciones_cursos;

-- -----------------------------------------------------
-- Table estudiantes
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS estudiantes (
    id_estudiante INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    edad INT NOT NULL,
    PRIMARY KEY (id_estudiante)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table cursos
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS cursos (
    id_curso INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    duracion INT NOT NULL,
    PRIMARY KEY (id_curso)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table inscripciones
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS inscripciones (
    id_estudiante INT NOT NULL,
    id_curso INT NOT NULL,

    PRIMARY KEY (id_estudiante, id_curso),

    INDEX fk_inscripciones_estudiantes_idx (id_estudiante ASC) VISIBLE,
    INDEX fk_inscripciones_cursos1_idx (id_curso ASC) VISIBLE,

    CONSTRAINT fk_inscripciones_estudiantes
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiantes (id_estudiante)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CONSTRAINT fk_inscripciones_cursos1
        FOREIGN KEY (id_curso)
        REFERENCES cursos (id_curso)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE = InnoDB;

SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;


----------------------------------------------------
CREATE DATABASE inscripciones_cursos;
USE inscripciones_cursos;

-- inscripcion de nuevos estudiantes
insert into estudiantes (nombre, edad)
values 
	('Ana Torres',20),
	('Pedro Soto',22),
	('María González',19),
	('Carlos Rojas',25),
	('Camila Díaz',21);
    
select * from estudiantes;

-- creaciones de nuevos cursos
insert into cursos(nombre, duracion)
values
	('Matematicas', 40),
    ('Historia', 30),
    ('Ciencias', 25),
    ('Lenguaje', 40);
    
select * from cursos;

-- inscripion de alumnos a cursos
insert into inscripciones (id_estudiante, id_curso) 
values
	(1,1),
	(1,2),
	(2,2),
	(2,3),
	(3,1),
	(3,4),
	(4,3),
	(4,4);
    
select * from inscripciones;

-- estudiantes con sus cursos respectivos
select
    e.nombre as estudiante,
    c.nombre as curso
from estudiantes e
inner join inscripciones i
    on e.id_estudiante = i.id_estudiante
inner join cursos c
    on c.id_curso = i.id_curso
order by e.nombre;

-- estudiantes inscritos en un curso en específico
select
    e.nombre as estudiante,
    c.nombre as curso
from estudiantes e
inner join inscripciones i
    on e.id_estudiante = i.id_estudiante
inner join cursos c
    on c.id_curso = i.id_curso
where c.nombre = 'Historia';

-- cursos de un estudiante en específico
select
    e.nombre as estudiante,
    c.nombre as curso
from estudiantes e
inner join inscripciones i
    on e.id_estudiante = i.id_estudiante
inner join cursos c
    on c.id_curso = i.id_curso
where e.nombre = 'Pedro Soto';

-- cantidad de estudiantes por curso
select
    c.nombre as curso,
    count(i.id_estudiante) as cantidad_estudiantes
from cursos c
left join inscripciones i
    on c.id_curso = i.id_curso
group by c.id_curso, c.nombre;

-- estudiantes sin curso
select
    e.id_estudiante,
    e.nombre
from estudiantes e
left join inscripciones i
    on e.id_estudiante = i.id_estudiante
where i.id_estudiante IS NULL;
