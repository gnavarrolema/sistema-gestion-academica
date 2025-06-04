USE gestion_academica_db;

DELIMITER //

CREATE TRIGGER trg_auditar_eliminacion_estudiante
BEFORE DELETE ON estudiantes
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_eliminaciones (estudiante_id, email, eliminado_en)
    VALUES (OLD.id, OLD.email, NOW());
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_actualizar_estado_academico
AFTER INSERT ON calificaciones
FOR EACH ROW
BEGIN
    DECLARE promedio_estudiante DECIMAL(4,2);
    DECLARE nuevo_estado VARCHAR(20);

    -- Calcular el promedio del estudiante
    SELECT AVG(nota) INTO promedio_estudiante
    FROM calificaciones
    WHERE estudiante_id = NEW.estudiante_id;

    -- Determinar el nuevo estado académico
    IF promedio_estudiante >= 6.00 THEN
        SET nuevo_estado = 'Aprobado';
    ELSE
        SET nuevo_estado = 'En Curso'; -- O 'Regular', 'Reprobado', según se defina.
                                     -- Por ahora 'En Curso' si no alcanza el 6.
    END IF;

    -- Actualizar el estado en la tabla estudiantes
    UPDATE estudiantes
    SET estado = nuevo_estado
    WHERE id = NEW.estudiante_id;
END //

DELIMITER ;