# Modelado y prácticas de bases de datos relacionales

Entregas de Bases de Datos 1 con modelos de Oracle SQL Developer Data Modeler, definición de tablas y scripts SQL. El repositorio contiene diseños y consultas; no implementa un motor SQL propio.

## Requisitos

Oracle Database y un cliente SQL compatible. Para editar los archivos .dmd, usar SQL Developer Data Modeler. Crear un esquema de pruebas independiente antes de ejecutar DDL.

## Ejecución

Los comandos parten de la raíz del repositorio, salvo donde se indica otra terminal.

```bash
# Desde SQLcl o SQL*Plus, conectado a un esquema de prácticas:
@Practica1_202302220/db/ddl.sql
```

## Recorrido de demostración

Abrir el modelo de la práctica, revisar sus entidades y relaciones y ejecutar el DDL en un esquema vacío. Comprobar tablas, llaves primarias y referencias usando el catálogo de Oracle. Revisar cada script antes de aplicarlo: puede crear o reemplazar objetos.

## Organización

Carpetas de la entrega: [`Practica1_202302220/`](Practica1_202302220/), [`Practica2_202302220/`](Practica2_202302220/), [`Proyecto_202302220/`](Proyecto_202302220/).

## Alcance y límites

Cada entrega es independiente y puede necesitar datos iniciales propios. Los scripts no son migraciones de una aplicación web ni un parser SQL.

## Contexto y licencia

Trabajo académico o de aprendizaje conservado en el portafolio de [Enner Mendizabal](https://github.com/Ennero). Los créditos de los trabajos en grupo se conservan en sus entregas y manuales.

Consultar [LICENSE](LICENSE) para la licencia de la raíz. Las dependencias y los componentes con avisos o licencias propios conservan sus condiciones.
