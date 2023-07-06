ascensor
=====
La aplicaciòn ascensor conta de dos partes una la maquina de estados que se encuentra en la carpeta src esta debe ser
ejecutada de manera local, y el servidor de erlang en este caso en rebar3 la maquina de estados tendra disponibles 4 estados representado los pisos del ascensor, y la llamada a la parte web se realizara a esta direcciòn: http://localhost:8080/ascensor
en la cual realizara peticiones mediante ajax al servidor.

A Cowboy OTP application
La presente aplicaciòn fue creada para funcionar con un servidor y maquinas de estado en erlang
Para el servidor se hace uso de rebar3 para lo cual se usa estos comandos:
Para compilar
-----
    $ rebar3 compile
Para ejecutar
-----
    $ rebar3 shell
Para la ejecuciòn de la maquina de estados se debe dirigir a la carpeta src en la cual dentro de la 
shell de erlang se ejecuta lo siguiente:
Para compilar
-----
    > c(ascensor).
Para ejecutar
-----
    ascensor:start().

Nota: En este proyecto se usan rutas en diferentes llamadas de funciones para la lectura de txt, estas estan quemadas en el proyecto por lo que requieren ser cambiadas segun sea el caso con el fin de llamar a los dos txt que se encuentran en la carpeta tmp esto 349126segun lo requiera el programa
