---
title: "Guía de Contribución"
description: "Cómo contribuir al código y la documentación de Texera."
weight: 10
lang: "es"
---

{{% pageinfo %}}
¡Gracias por tu interés en contribuir a Texera! Esta guía explica cómo contribuir tanto al **código fuente de Texera** como a su **documentación**.  
Seguimos un flujo de trabajo basado en *forks* y adoptamos el estándar [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) para los mensajes de commit.
{{% /pageinfo %}}

# Contribuir a Texera

Texera da la bienvenida a contribuciones de todos — ya sea corrigiendo errores, mejorando la documentación o agregando nuevas funciones.

---

## 👥 Roles en el Proyecto

| Rol | Permisos Clave | Cómo Unirse |
|------|-----------------|--------------|
| **Contribuidor** | Enviar issues y PRs, participar en discusiones | Comienza a contribuir — no se requiere proceso formal |
| **Committer** | Fusionar PRs, subir código, votar cambios de código | Nombrado por el PPMC basado en contribuciones de calidad |
| **Miembro del PPMC** | Gobernanza, votación de lanzamientos, aprobación de nuevos committers | Votado por los miembros actuales del PPMC |
| **Mentor** | Guiar el proyecto y asegurar el cumplimiento con Apache | Designado por el Incubator PMC |

---

## 🛠 Cómo Contribuir Código

### 1. Haz un Fork del Repositorio
Haz un fork del [repositorio de Texera](https://github.com/Texera/texera) en GitHub y clónalo localmente.

### 2. Encuentra o Crea un Issue
- Elige un issue existente o crea uno nuevo describiendo tu propuesta o error.  
- Discute tu enfoque con los committers antes de comenzar a programar para llegar a un consenso.

### 3. Crea y Envía un Pull Request
- Desarrolla en una nueva rama de tu fork.  
- Cuando esté listo, envía un PR al repositorio principal de Texera.  
- **Permite ediciones de los mantenedores** para que los committers puedan realizar pequeños ajustes si es necesario.

#### Formato del Título del PR y de los Commits
Usamos [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):
- Ejemplos de títulos:
  - `feat: agregar nuevo operador join`
  - `fix(ui): resolver fallo en el panel de flujo de trabajo`
  - `chore(deps): actualizar versiones de dependencias`
- El título del PR se convierte en el mensaje final del commit al fusionar.

#### La Descripción del PR Debe Incluir:
- **Propósito:** usa `Closes #1234` para cerrar automáticamente un issue.  
- **Resumen:** breve descripción de tus cambios.  
- Opcional: **documento de diseño**, **diagrama técnico** o **capturas de pantalla**.

Evita incluir:
- Archivos de configuración local (por ejemplo, `python_udf.conf`)  
- Secretos o credenciales  
- Archivos binarios o de compilación  

---

## 🧪 Pruebas y Verificación de Calidad

### Backend (Scala)
1. Ejecuta el linter:
   ```bash
   sbt "scalafixAll --check"
   ```
   Corrige con:
   ```bash
   sbt scalafixAll
   ```
2. Ejecuta el formateador:
   ```bash
   sbt scalafmtCheckAll
   ```
   Corrige con:
   ```bash
   sbt scalafmtAll
   ```
3. Ejecuta las pruebas:
   ```bash
   cd core
   sbt test
   ```

> Para usuarios de IntelliJ: asegúrate de que el directorio de trabajo coincida con el módulo (`amber` para pruebas del motor, `core` para servicios).

### Frontend (Angular)
1. Ejecuta las pruebas unitarias:
   ```bash
   cd core/gui
   ng test --watch=false
   ```
2. Formatea el código:
   ```bash
   yarn format:fix
   ```

Escribe pruebas `.spec.ts` para cualquier nueva funcionalidad para garantizar su estabilidad futura.

---

## 🔍 Proceso de Revisión de Pull Requests
1. Solicita a un committer que revise tu PR.  
2. Añade etiquetas (por ejemplo, `fix`, `enhancement`, `docs`).  
3. Espera a que las pruebas CI pasen ([GitHub Actions](https://github.com/Texera/texera/actions)).  
4. Marca tu PR como **draft** si aún no está listo.  
5. Una vez aprobado, un committer fusionará tu PR.

---

## 📝 Encabezado de Licencia Apache
Todos los archivos nuevos deben incluir el encabezado de la Licencia Apache.  
Para automatizar esto en IntelliJ:

1. Ve a **Settings → Editor → Copyright → Copyright Profiles**.  
2. Crea un perfil llamado **Apache** e incluye:
   ```
   Licensed to the Apache Software Foundation (ASF) under one
   or more contributor license agreements. See the NOTICE file
   distributed with this work for additional information
   regarding copyright ownership...
   ```
3. Establece este perfil como predeterminado para el proyecto.

---

## ✍️ Contribuir a la Documentación

Texera utiliza [Hugo](https://gohugo.io/) y el tema [Docsy](https://github.com/google/docsy) para construir su sitio web.  
Toda la documentación se almacena en el [repositorio de GitHub de Texera](https://github.com/Texera/texera).

### Pasos Rápidos
1. Haz clic en **Edit this page** en la parte superior de cualquier página de documentación para editar directamente en GitHub.  
2. Realiza tus ediciones y abre un Pull Request.  
3. El sitio genera automáticamente una vista previa mediante Netlify.  
4. Espera la aprobación y fusión.

### Vista Previa Local
Para previsualizar localmente:
```bash
hugo server
```
Visita `http://localhost:1313` para ver el sitio mientras editas.

---

## 📚 Recursos
- [Repositorio de Texera en GitHub](https://github.com/Texera/texera)  
- [Especificación de Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)  
- [Documentación de Pull Requests en GitHub](https://help.github.com/articles/about-pull-requests/)
