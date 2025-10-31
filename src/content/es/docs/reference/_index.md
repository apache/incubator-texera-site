---
title: Referencia
description: Referencias técnicas y de configuración en profundidad para los componentes y el entorno de Texera.
weight: 9
lang: "es"
---

{{% pageinfo %}}
Esta sección contiene material de referencia detallado y de bajo nivel sobre la configuración, los componentes y los módulos internos de Texera.
{{% /pageinfo %}}

La sección de **Referencia** ofrece documentación de consulta para desarrolladores y mantenedores que necesitan información técnica específica sobre los aspectos internos o el entorno de Texera.  
A diferencia de la sección de [Conceptos](/docs/concepts/), que explica *cómo funciona Texera*, esta sección se centra en *cómo se configura, construye y amplía Texera*.

---

### Qué encontrarás aquí

Esta sección incluye información de referencia sobre:

- **Configuración y Entorno:** Parámetros detallados y variables de entorno utilizados para el desarrollo, despliegue y pruebas.
- **Estructura del Proyecto:** Explicación de los principales directorios del código, dependencias de módulos y convenciones de nombres.
- **Detalles del Motor de Ejecución:** Referencia de bajo nivel para los módulos del motor, ciclo de vida de los operadores y traducción de flujos de trabajo.
- **Marco de Operadores:** Notas técnicas sobre el registro de operadores, metadatos y mecanismos de extensión.
- **Componentes del Frontend:** Descripciones de la estructura de módulos de la interfaz, componentes de Angular y ganchos de visualización.
- **Persistencia y Almacenamiento:** Información sobre los modelos de almacenamiento interno de Texera, el catálogo y los metadatos de los flujos de trabajo.

---

### Cuándo usar esta sección

Utiliza esta sección cuando necesites:

- Comprender o modificar los **módulos internos o archivos de configuración** de Texera.
- **Depurar, ampliar o refactorizar** partes del código base.
- **Desplegar Texera** en entornos locales, de prueba o producción y necesites ajustar configuraciones o dependencias.

---

### Cómo mantener esta sección

Las páginas de referencia suelen ser técnicas y específicas de la versión. Mantén esta sección actualizada mediante:

- Enlazar o incrustar **documentación generada automáticamente** a partir de comentarios del código (por ejemplo, Javadoc para módulos de backend o TypeDoc para el frontend).
- Incluir **páginas de referencia manuales** para archivos de configuración, scripts de inicio y diagramas de arquitectura.
- Actualizar esta sección siempre que cambien los módulos internos o los formatos de configuración.

---

### Subpáginas sugeridas

| Archivo | Propósito |
|----------|-----------|
| `reference/configuration.md` | Variables de entorno, puertos y configuración del servidor. |
| `reference/project-structure.md` | Descripción general de los directorios y del sistema de compilación. |
| `reference/engine.md` | Explicación detallada de los aspectos internos del motor de ejecución. |
| `reference/operators.md` | Registro de operadores y detalles de su ciclo de vida. |
| `reference/frontend.md` | Arquitectura y componentes del frontend. |
| `reference/storage.md` | Capa de persistencia, catálogo y gestión de metadatos. |

---

Esta sección está pensada como un **manual técnico para desarrolladores** sobre los sistemas internos de Texera — una referencia precisa para cualquier persona que mantenga, amplíe o despliegue la plataforma.
