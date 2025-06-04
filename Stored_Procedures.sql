USE gestion_academica_db;

DELIMITER //
CREATE PROCEDURE sp_registrar_calificacion(
    IN p_estudiante_id INT,
    IN p_materia_id INT,
    IN p_nota DECIMAL(4,2),
    IN p_fecha DATE
)
BEGIN
    -- Validar que la nota esté entre 0 y 10
    IF p_nota < 0.00 OR p_nota > 10.00 THEN
        SIGNAL SQLSTATE '45000' -- '45000' es un SQLSTATE genérico para errores definidos por el usuario
        SET MESSAGE_TEXT = 'Error: La nota debe estar entre 0 y 10.';
    ELSE
        -- Insertar la calificación
        INSERT INTO calificaciones (estudiante_id, materia_id, nota, fecha)
        VALUES (p_estudiante_id, p_materia_id, p_nota, p_fecha);
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_inscribir_estudiante(
    IN p_estudiante_id INT,
    IN p_materia_id INT,
    IN p_fecha_inscripcion DATE
)
BEGIN
    DECLARE v_estado_estudiante VARCHAR(20);
    DECLARE v_estudiante_existe INT;
    DECLARE v_materia_existe INT;
    DECLARE v_ya_inscrito INT;

    -- Verificar si el estudiante existe
    SELECT COUNT(*) INTO v_estudiante_existe FROM estudiantes WHERE id = p_estudiante_id;
    IF v_estudiante_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El estudiante especificado no existe.';
    END IF;

    -- Verificar si la materia existe
    SELECT COUNT(*) INTO v_materia_existe FROM materias WHERE id = p_materia_id;
    IF v_materia_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: La materia especificada no existe.';
    END IF;

    -- Obtener el estado del estudiante
    SELECT estado INTO v_estado_estudiante
    FROM estudiantes
    WHERE id = p_estudiante_id;

    -- Verificar si el estudiante está activo
    IF v_estado_estudiante != 'activo' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El estudiante no está activo y no puede ser inscrito.';
    ELSE
        -- (Opcional) Verificar si ya está inscrito en esa materia
        SELECT COUNT(*) INTO v_ya_inscrito
        FROM inscripciones
        WHERE estudiante_id = p_estudiante_id AND materia_id = p_materia_id;

        IF v_ya_inscrito > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: El estudiante ya está inscrito en esta materia.';
        ELSE
            -- Inscribir al estudiante
            INSERT INTO inscripciones (estudiante_id, materia_id, fecha)
            VALUES (p_estudiante_id, p_materia_id, p_fecha_inscripcion);
        END IF;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION fn_determinar_estado_academico(
    p_promedio DECIMAL(4,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_estado VARCHAR(20);

    IF p_promedio >= 6.00 THEN
        SET v_estado = 'Aprobado';
    ELSE
        SET v_estado = 'En Curso'; -- O 'Reprobado', 'Regular', etc.
    END IF;

    RETURN v_estado;
END //

DELIMITER ;

DROP FUNCTION IF EXISTS fn_determinar_estado_academico;

DELIMITER //

CREATE FUNCTION fn_determinar_estado_academico(
    p_promedio DECIMAL(4,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE v_estado VARCHAR(20);

    IF p_promedio >= 6.00 THEN
        SET v_estado = 'Aprobado';
    ELSE
        SET v_estado = 'En Curso'; -- Puedes cambiar 'En Curso' por 'Reprobado' si lo prefieres para promedios < 6
    END IF;

    RETURN v_estado;
END //

DELIMITER ;

SELECT fn_determinar_estado_academico(7.5);