---
title: "Instalación en Nodo Único"
date: 2025-10-29
weight: 1
description: >
  Este documento describe cómo configurar y ejecutar Texera en una sola máquina utilizando Docker Compose.
categories: [Texera]
tags: [instalación, docker, nodo-único, configuración]
lang: "es"
---

{{% pageinfo %}}
Este documento describe cómo configurar y ejecutar Texera en una sola máquina utilizando **Docker Compose**.
{{% /pageinfo %}}

## Requisitos Previos

Antes de comenzar, asegúrate de que tu computadora cumpla con los siguientes requisitos:

| Tipo de Recurso | Mínimo | Recomendado |
|-----------------|---------|-------------|
| Núcleos de CPU  | 2       | 8           |
| Memoria         | 4GB     | 16GB        |
| Espacio en Disco| 20GB    | 50GB        |

También necesitas instalar y ejecutar Docker Desktop en tu computadora. Elige el enlace de instalación adecuado según tu sistema operativo:

| Sistema Operativo | Enlace de Instalación |
|--------------------|-----------------------|
| macOS | [Docker Desktop para Mac](https://docs.docker.com/desktop/install/mac-install/) |
| Windows | [Docker Desktop para Windows](https://docs.docker.com/desktop/install/windows-install/) |
| Linux | [Docker Desktop para Linux](https://docs.docker.com/desktop/install/linux-install/) |

Después de instalar y ejecutar Docker Desktop, verifica que Docker y Docker Compose estén disponibles ejecutando los siguientes comandos en la terminal:
```bash
docker --version
docker compose version
```
Deberías ver mensajes similares a los siguientes (las versiones pueden variar):
```
$ docker --version
Docker version 27.5.1, build 9f9e405
$ docker compose version
Docker Compose version v2.23.0-desktop.1
```

---

## Descargar el Instalador de Texera (unos pocos kilobytes)

Descarga [texera-single-node-release](https://github.com/apache/texera/releases/download/1.1.0/apache-texera-incubating-release-1-1-0-single-node.zip) y extrae su contenido.

---

## Iniciar Texera

Ve al directorio extraído utilizando el siguiente comando:
```
cd apache-texera-incubating-release-1-1-0-single-node
```

Ejecuta el siguiente comando para iniciar Texera:

```bash
docker compose up
```

> Si ves un mensaje de error como `unable to get image 'nginx:alpine': Cannot connect to the Docker daemon...`, asegúrate de que Docker Desktop esté instalado y en ejecución.

> Cuando inicies Texera por primera vez, tomará alrededor de 5 minutos para descargar las imágenes necesarias. Si habilitas el [soporte para R](#configuración-avanzada), puede tardar unos 20 minutos.

El sistema estará listo cuando veas los siguientes mensajes:
```
......
texera-access-message              | ===============================================
texera-access-message              | ¡Texera está listo!
texera-access-message              | ===============================================
texera-access-message              | 
texera-access-message              | Para acceder a Texera, abre tu navegador y navega a:
texera-access-message              |     http://localhost:8080
texera-access-message              | 
texera-access-message              | Se ha creado la siguiente cuenta para ti:
texera-access-message              |     Usuario: texera
texera-access-message              |     Contraseña: texera
texera-access-message              | 
texera-access-message              | ===============================================
......
mensajes de verificación del sistema
......
```

Abre tu navegador y navega a:
```
http://localhost:8080
```

Ya existe una cuenta `texera` con la contraseña `texera`.  
Haz clic en el botón `Iniciar sesión` para acceder:  
<img width="1100" height="500" alt="texera-login" src="https://github.com/user-attachments/assets/84cd784a-09a8-4e56-b9f5-49b53da67914" />

Deberías ver la siguiente página:  
<img width="1100" height="500" alt="texera-workspace" src="https://github.com/user-attachments/assets/fb90d706-9ee1-40c2-af67-0aad540d4718" />

> **Nota:** Texera **NO** admite operadores en R de forma predeterminada. Para habilitar el soporte de R, consulta la sección [Configuración Avanzada](#configuración-avanzada).

---

## Detener, Reiniciar y Desinstalar Texera

### Detener
Presiona `Ctrl+C` en la terminal para detener Texera.

Si ya cerraste la terminal, puedes ir a la carpeta de instalación y ejecutar:
```bash
docker compose stop
```
para detener Texera.

### Reiniciar
El mismo procedimiento que para [iniciar Texera](#iniciar-texera).

### Desinstalar
Para eliminar Texera y todos sus datos, ve a la carpeta de instalación y ejecuta:
```bash
docker compose down -v
```
> ⚠️ **Advertencia:** Esto eliminará permanentemente todos los datos utilizados por Texera.

---

## Configuración Avanzada

Antes de realizar cualquiera de los cambios siguientes, primero [detén Texera](#detener).  
Una vez que termines, [reinicia Texera](#reiniciar) para aplicar los cambios.

Todos los cambios deben realizarse en el archivo `docker-compose.yml` dentro de la carpeta de instalación.

### Habilitar Soporte para el Lenguaje R
Para admitir operadores de funciones definidas por el usuario (UDF) en R, busca la sección `computing-unit-master` y cambia la etiqueta de imagen de `release-1-1-0` a `release-1-1-0-R`.

### Ejecutar Texera en Otros Puertos
Por defecto, Texera utiliza:
- Puerto 8080 para su servicio web
- Puerto 9000 para su servicio de almacenamiento MinIO

Para cambiar estos puertos:
- Para el puerto del servicio web (8080):
    - Busca la sección del servicio `nginx` y cambia la asignación de puerto de `"8080:8080"` a tu nuevo mapeo, por ejemplo `"8081:8080"`.
    - Busca la sección del servicio `texera-access-message` y cambia el puerto en `${TEXERA_HOST}:8080` a `${TEXERA_HOST}:8081`.
- Para el puerto de MinIO (9000):
    - Busca la sección del servicio `minio` y cambia el mapeo de `"9000:9000"` a `"9001:9000"`.
    - Busca la sección del servicio `lakefs` y actualiza el puerto en `LAKEFS_BLOCKSTORE_S3_PRE_SIGNED_ENDPOINT` de `9000` a `9001`.

### Cambiar las Ubicaciones de los Datos de Texera
Por defecto, Docker administra las ubicaciones de datos de Texera. Para cambiarlas a tus propias carpetas:
- Busca la sección `persistent volumes`. Para cada volumen de datos que desees modificar, agrega la siguiente configuración:
   ```yaml
   volume_name:
     driver: local
     driver_opts:
       type: none
       o: bind
       device: /ruta/a/tu/carpeta/local
   ```
  Por ejemplo, para cambiar la carpeta donde se almacena `workflow_result_data` a `/Users/johndoe/texera/data`, agrega lo siguiente:

   ```yaml
   workflow_result_data:
     driver: local
     driver_opts:
       type: none
       o: bind
       device: /Users/johndoe/texera/data
   ```

Si ya iniciaste Texera y deseas cambiar las ubicaciones de los datos, los volúmenes existentes deben recrearse al iniciar de nuevo.  
Selecciona `y` cuando se te pregunte al ejecutar `docker compose up` nuevamente:
```
$ docker compose up
? Volume "texera-single-node-release-1-1-0_workflow_result_data" exists but doesn't match configuration in compose file. Recreate (data will be lost)? (y/N)
y // responde y a este mensaje
```