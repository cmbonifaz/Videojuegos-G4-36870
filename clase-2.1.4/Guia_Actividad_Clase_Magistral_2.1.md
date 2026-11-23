## Guía de actividad: clase magistral sobre la captura de la entrada

Subtema 2.1.4. Cada grupo defiende un subtema ante sus compañeros con una presentación, un ejercicio en Godot y un reto para el curso.

| Dato | Detalle |
| --- | --- |
| Tema | Captura de la entrada (2.1.4), dividido en seis subtemas |
| Modalidad | Seis grupos; cada grupo defiende un subtema |
| Duración | Máximo 30 minutos por grupo |
| Productos | 1. Presentación 2. Ejercicio en Godot 4.7.x (GDScript) 3. Reto para los |
|   | compañeros 4. Plan de clase completado (plantilla en PDF) |
| Entrega | Carpeta clase-2.1.4 en el repositorio de GitHub del grupo |

## Objetivo

Dominar un subtema de la captura de la entrada y enseñarlo a los compañeros como una clase magistral: explicarlo, demostrarlo con un ejercicio y comprobar el aprendizaje con un reto.

## Temas por grupo

| Grupo | Subtema | Qué debe dominar | Qué debe demostrar el |
| --- | --- | --- | --- |
|   |   |   | ejercicio |
| 1 | Input Map y acciones | Crear acciones, asignar eventos | Un personaje que se mueve |
|   |   | de teclado, mando y otros, y | con al menos cuatro acciones, |
|   |   | ajustar la zona muerta | sin teclas escritas en el código |
| 2 | Clases de InputEvent | Jerarquía de clases y propiedades | Un panel que muestra la clase |
|   |   | de cada una (InputEventKey, | y las propiedades del evento |
|   |   | InputEventMouseButton, | recibido, con al menos tres |
|   |   | InputEventMouseMotion, | clases distintas |
|   |   | InputEventJoypadButton, |   |
|   |   | InputEventJoypadMotion, |   |
|   |   | InputEventScreenTouch, |   |
|   |   | InputEventScreenDrag, |   |
|   |   | InputEventAction) |   |
| 3 | Captura con | Comprobar la clase con is, filtrar | Una reacción que usa datos |
|   | _input(event) | con pressed, leer propiedades | del evento (por ejemplo, la |
|   |   | propias y decidir entre acción y | posición del clic) y otra que |
|   |   | tipo de evento | usa acciones |
| 4 | Una acción, muchos | Por qué el código no cambia al | La misma acción activada |
|   | dispositivos | agregar dispositivos; ventajas | desde el teclado y desde un |
|   |   | para pruebas, remapeo y | segundo dispositivo, con el |
|   |   | accesibilidad | mismo código |


| Grupo | Subtema | Qué debe dominar | Qué debe demostrar el |
| --- | --- | --- | --- |
|   |   |   | ejercicio |
| 5 | Coyote time | Qué problema resuelve y cómo se | Un salto de plataformas con el |
|   |   | programa con una ventana de | coyote time activado y |
|   |   | tiempo | desactivado, para notar la |
|   |   |   | diferencia |
| 6 | Buffer de entrada | Qué problema resuelve, cómo se | Un salto de plataformas con el |
|   |   | programa con una ventana de | buffer activado y desactivado, |
|   |   | tiempo y cómo se combina con el | para notar la diferencia |
|   |   | coyote time |   |

## Paso 1. Investiga tu subtema

Reúne la información que necesitas para enseñar el subtema y regístrala en la plantilla, con tus palabras:

- 1. Define el concepto y explica para qué sirve en un videojuego.

- 2. Describe cómo se usa en Godot, con un fragmento corto de código explicado línea por línea.

- 3. Identifica un error frecuente de quien empieza y cómo evitarlo.

- 4. Busca un videojuego real donde se note el concepto y describe cómo se nota.

Usa como mínimo tres fuentes confiables (documentación oficial de Godot, libros o artículos del área) y cítalas en formato APA 7. No uses blogs sin autor ni foros como fuente principal.

## Paso 2. Prepara la presentación

- Máximo 10 diapositivas, con pocas palabras y muchas imágenes: esquemas, capturas del editor y fragmentos cortos de código.

- Empieza con 2 o 3 objetivos de aprendizaje y termina con tres ideas clave.

- Explica; no leas las diapositivas. Todos los integrantes deben exponer.

## Paso 3. Prepara el ejercicio

El ejercicio es una demostración en Godot que el grupo resuelve en vivo, paso a paso, para que los compañeros vean el subtema funcionando.

| N.º | Requisito |
| --- | --- |
| E1 | Hecho en Godot 4.7.x con GDScript y resuelto en vivo en unos 8 minutos. |
| E2 | Demuestra el subtema del grupo, según la tabla de temas. |
| E3 | El resultado se ve en pantalla (un Label, un panel o el movimiento del personaje). |
| E4 | El código es de autoría propia y está comentado. |
| E5 | Se entrega con los pasos escritos, para que cualquier compañero pueda repetirlo. |

Si una acción no responde al probar, detén el juego, vuelve a ejecutarlo y haz clic dentro de la ventana para darle el foco.


## Paso 4. Propón un reto para tus compañeros

El reto es una tarea corta que el curso resuelve en el aula después de ver el ejercicio. Debe pedir algo nuevo; no debe repetir el ejercicio.

- 1. Escribe el enunciado en una o dos frases y de dos a tres requisitos comprobables.

- 2. Ajústalo para que se resuelva en unos 7 minutos.

- 3. Define cómo se sabe que está logrado (qué debe verse en pantalla).

- 4. Prepara la solución y una pista, y guárdalas hasta el cierre.

## Paso 5. Organiza los 30 minutos

| Minutos | Momento | Qué se hace |
| --- | --- | --- |
| 0 – 3 | Apertura | Presentan al grupo, el subtema y los objetivos |
| 3 – 12 | Presentación | Explican el contenido con esquemas, ejemplos y |
|   |   | código |
| 12 – 20 | Ejercicio | Resuelven el ejercicio en vivo, paso a paso |
| 20 – 27 | Reto | Los compañeros resuelven el reto; el grupo |
|   |   | acompaña y da la pista |
| 27 – 30 | Cierre | Muestran la solución del reto y resumen tres ideas |
|   |   | clave |

Ensaya con cronómetro. El grupo no debe pasar de 30 minutos.

## Paso 6. Entrega

- 1. Completa la plantilla del plan de clase (PDF).

- 2. Sube a clase-2.1.4 la presentación en PDF, el proyecto del ejercicio, el reto con su solución y el plan de clase.

- 3. Incluye un README.md con integrantes, subtema, versión de Godot y cómo ejecutar el ejercicio.

- 4. Haz un commit con un mensaje descriptivo, por ejemplo: «Entrega clase 2.1.4, grupo N».

## Criterios de valoración (10 puntos)

| Criterio | Puntos Qué se espera |   |
| --- | --- | --- |
| Dominio del subtema y fuentes | 2,5 | Contenido correcto, con palabras |
|   |   | propias y tres fuentes en APA 7 |
| Presentación | 2 | Clara, visual y expuesta por todos |
|   |   | los integrantes |
| Ejercicio (E1 a E5) | 2,5 | Demuestra el subtema y funciona |
|   |   | en vivo |
| Reto para los compañeros | 2 | Enunciado claro, resoluble en el |
|   |   | tiempo y con solución |
| Tiempo y entrega | 1 | 30 minutos como máximo y |
|   |   | carpeta completa en GitHub |
