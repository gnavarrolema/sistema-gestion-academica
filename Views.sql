USE gestion_academica_db;

CREATE VIEW vista_rendimiento_estudiantes AS
SELECT
    e.id AS estudiante_id,
    e.nombre AS nombre_estudiante,
    e.email AS email_estudiante,
    fn_calcular_promedio_estudiante(e.id) AS promedio_academico,
    fn_determinar_estado_academico(fn_calcular_promedio_estudiante(e.id)) AS estado_academico,
    e.estado AS estado_administrativo -- La columna original de la tabla estudiantes
FROM
    estudiantes e;
    
SELECT * FROM vista_rendimiento_estudiantes WHERE estado_academico = 'Aprobado';