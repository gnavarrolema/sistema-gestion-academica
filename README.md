# Sistema de Gestión Académica - Base de Datos

Este repositorio contiene los scripts SQL para crear, poblar y gestionar una base de datos para un sistema de gestión académica.

## Contenido de los Scripts

* **`Dataset_Gestion_Estudiantes.sql`**: Crea la estructura de la base de datos (`gestion_academica_db`), las tablas (`estudiantes`, `materias`, `inscripciones`, `calificaciones`, `auditoria_eliminaciones`), e inserta datos de ejemplo. También incluye un trigger inicial `trg_actualizar_estado_academico`.
* **`Functions.sql`**: Contiene la función `fn_calcular_promedio_estudiante(p_estudiante_id)` que calcula el promedio de calificaciones de un estudiante.
* **`Stored_Procedures.sql`**: Incluye los procedimientos almacenados:
    * `sp_registrar_calificacion`: Para registrar una nueva calificación, validando que la nota esté entre 0 y 10.
    * `sp_inscribir_estudiante`: Para inscribir un estudiante activo en una materia, verificando la existencia del estudiante y la materia, y que no esté ya inscrito.
    * También define una función `fn_determinar_estado_academico(p_promedio)`. (Considera consolidar, ya que podría haber múltiples definiciones o una definición principal en otro archivo).
* **`Triggers.sql`**: Define los triggers:
    * `trg_auditar_eliminacion_estudiante`: Registra en `auditoria_eliminaciones` antes de que un estudiante sea eliminado.
    * `trg_actualizar_estado_academico`: Actualiza el estado del estudiante en la tabla `estudiantes` después de insertar una nueva calificación. (Nota: Este trigger también está presente en `Dataset_Gestion_Estudiantes.sql`. Asegúrate de que solo una definición esté activa o reconcílialas).
* **`Views.sql`**: Crea la vista `vista_rendimiento_estudiantes` que muestra el ID, nombre, email del estudiante, su promedio académico (usando `fn_calcular_promedio_estudiante`) y su estado académico (usando `fn_determinar_estado_academico`).

## Orden de Ejecución Sugerido

1.  Asegúrate de tener un servidor MySQL o compatible en ejecución.
2.  Ejecuta `Dataset_Gestion_Estudiantes.sql` para crear la base de datos, tablas, datos iniciales y el primer trigger.
3.  Ejecuta `Functions.sql` para crear las funciones necesarias.
4.  Ejecuta `Stored_Procedures.sql` para crear los procedimientos almacenados. (Revisa la función `fn_determinar_estado_academico` para evitar conflictos).
5.  Ejecuta `Triggers.sql`. (Revisa el trigger `trg_actualizar_estado_academico` para evitar conflictos con el definido en `Dataset_Gestion_Estudiantes.sql`).
6.  Ejecuta `Views.sql` para crear las vistas.

## Nota sobre Duplicados y Consideraciones

* El trigger `trg_actualizar_estado_academico` está definido tanto en `Dataset_Gestion_Estudiantes.sql` como en `Triggers.sql`. Deberías tener solo una definición activa para evitar errores al ejecutar los scripts.
* La función `fn_determinar_estado_academico` se define en `Stored_Procedures.sql` (y hay una definición similar o idéntica comentada o eliminada con `DROP FUNCTION IF EXISTS` antes de ser recreada en el mismo archivo). Asegúrate de que esta es la versión que deseas utilizar y que no cause conflictos, especialmente porque la vista `vista_rendimiento_estudiantes` depende de ella.