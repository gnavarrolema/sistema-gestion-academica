USE gestion_academica_db;

DELIMITER //

CREATE FUNCTION fn_calcular_promedio_estudiante(
    p_estudiante_id INT
)
RETURNS DECIMAL(4,2)
READS SQL DATA
BEGIN
    DECLARE v_promedio DECIMAL(4,2);

    SELECT AVG(nota) INTO v_promedio
    FROM calificaciones
    WHERE estudiante_id = p_estudiante_id;

    -- Si el estudiante no tiene calificaciones, AVG(nota) devuelve NULL.
    -- Podemos devolver 0.00 en ese caso, o NULL si se prefiere.
    IF v_promedio IS NULL THEN
        SET v_promedio = 0.00;
    END IF;

    RETURN v_promedio;
END //

DELIMITER ;

SELECT fn_calcular_promedio_estudiante(1); -- Donde 1 es el ID de un estudiante.