## Semana 1
Esta semana tuvimos que comenzar a familiarizarnos con flutter y con el mundo de las aplicaciones móviles. Lo primero fue diseñar la app. Para ello utilizamos una
herramienta web llamada Moqups. Optamos por hacer un diseño simple, similar a la aplicación del cambio de unidades de tempratura visto en clase, con una única
pantalla y otra de error, que en un futuro quizás se convierta en un pop-up.

Después elegimos un patrón que se adaptara bien al diseño y optamos por el Provider. Se basa en la inyección de dependencias para proporcionar acceso a datos y 
servicios en toda la aplicación. Los diagramas mermaid uml se pueden ver en [Estático](/diagramas/diseño_sw_static.md) y [Dinámico](/diseño_sw.md).
## Semana 2
En esta semana hemos comenzado a implementar la aplicación. Hemos creado la estructura de carpetas y hemos implementado el modelo de datos. También hemos creado
la clase que se encarga de la conversión de unidades. Para ello hemos utilizado el patrón de diseño Strategy, que nos permite definir una familia de algoritmos,
encapsular cada uno de ellos y hacerlos intercambiables. En nuestro caso, cada algoritmo es una clase que se encarga de convertir una unidad a otra. 

Hemos avanzado mucho y la app esta casi terminada, ademas hemos conseguido una estetica agradable a la vista. +10 de salud mental
## Semana 3
En esta semana hemos realizado los test de nuestra app para probar nuestras funcionalidades principales. Hemos creado una nueva carpeta test e implementado estos mismos. Hemos tenido que realizar ciertas modificaciones en el código para adaptarlo a ellos. Para ello hemos utilizado tests de integración.
Hemos mejorado mucho la app, le hemos dado un nuevo diseño a la orientación horizontal para aprovechar más el espacio y los test funcionan perfectamente.
