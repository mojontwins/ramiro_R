Ramiro el Vampiro Revamp Project 
================================

Porque en un juego asín, "Revamp" es la palabra que mejor pega para "R".

20160125
========

Con las cintas para publicar el juego en camino (color red jelly, eso mowla) me he decidido de una vez por todas a crear versiones remozadas de estos juegos usando MK2. Sencillamente, los Ramiros están entre mis preferidos de todos los que hemos hecho, y creo que ya que los vamos a sacar en cinta lo suyo es que lleven la tecnología más actual. Los originales están geniales, pero están construidos con la versión 4.5 de la Churrera, y eso es de antes de que decidiéramos liberarla y la reseteásemos a la 3.1 sobre la que construimos la 3.99, que fue la que terminó evolucionando hasta convertirse en MK2. O sea, que el código que soporta las andaduras de nuestro vampiro favorito es realmente viejo. Creo que en MK2 el juego se moverá mucho mejor, podremos utilizar una salida de texto más interesante, y se liberará el espacio suficiente para meter música en el menú.

Así, de cabeza, necesitaría:

- Revisar detenidamente el script original de Ramiro para ver qué cosas faltarían en MK2. Sin pensarlo demasiado, creo que con la potencia actual de msc3 se podría simular toda la mierda custom que había, pero siempre hay algo que falla.  En ese caso, habría que evaluar si es necesario ampliar el motor o meterlo como custom (cosas como las que pasan en el segundo juego, que al final todos los enemigos se transforman en murciélagos, estaba hecho en motor y activado desde el script en 4.5, cuando puede hacerse de forma mucho más sencilla con un custom; a fin de cuentas, es algo muy específico).

- Implementar el comportamiento "roba energía" de los tiles donde te da el sol. Esto no está hecho. Tengo que recordar las características; creo que se mostraba un contador y que el tick de dicho contador era configurable. Lo miraré.

- Estaba pensando en modificar map2bin para añadir soporte para juegos que utilicen 2 tilesets de 16 que se cambie dependiendo de la pantalla. Creo que puede venir bien para el futuro, aunque tendría que procesar los .map originales para que empléen los tiles reales - meh bleh. Cosas. Vamos, que yo me entiendo. 

Ampliación de map2bin:

Al final la idea es que tengamos un tileset de 48 tiles en el formato siguiente:

```
    1111111111111111
    EEEEEEEEEEEEEEEE
    2222222222222222
```

y que el conversor map2bin haga lo siguiente:

- Los tiles "1" y "2", de las filas primera y tercera, se consideran tilesets de un mapa packed. En el binario generado, habrá una sección al final donde se escriba un 1 o un 2 dependiendo de qué tile se utilice. "¡Mastuerzo!", dirás, "¡pero si eso lo puedes empaquetar en bits y usar un bit por pantalla!" Lo pensaré, porque a lo mejor el código necesario para desempaquetar los bits ocupa más que lo que se ahorre en los datos. ¿Qué hablamos, de 30 bytes? ¿35? Meh, eso se lo ventila z88dk con dos expresiones. Mejor hacerlo a byte.

- Los tiles "E" son decoraciones y se tratarán como hasta ahora.

Hacer el mapa de Ramiro fue un poco dolor, porque había que estar cambiando el tileset importado en mappy constantemente. Creo recordar que no había demasiadas decoraciones, pero hubo que ponerlas a mano. Eso es otra cosa que tendré que hacer sobre el mapa original: trasladar las decoraciones desde el script.

"Pero melón", pensarás, "vas a trabajar para que luego el conversor te convierta automáticamente lo que ya tienes convertido a mano". Sí, pichurro, pero así podremos usar esto en otros juegos futuros.

~

Lo que más pereza me da es que ahora tengo que actualizar whatsnew.txt con todas las cosas de K2T que había metidas... ¡Y son un montón! Conociéndome, no creo que haya ido actualizándolo a medida que ho hacía. Al menos llevé un diario. Es lo mejor llevar estos putos diarios. 

~~

Me cago y mequeda... ¡Sí que lo llevaba actualizado! No sé si 100% al día, pero bastante. Seguro que sí, teniendo en cuenta la fecha del archivo y que las cosas de motor las hice al principio - luego todo fue custom y scripting. Lo miro despacito luego. Voy a ir creando el proyecto de Sublime Edit 2 (dios, como amo este editor de textos, ¿por qué coño no lo conocí antes?) y luego me voy a tomar un desayunito.

~~

Anoto cosas que veo en el script:

- Uf, no hay apenas comentarios y esto es de cuando no había nombres descriptivos para los flags - nada que un find & replace no pueda resolver.
- Sección `PLAYER_GETS_COIN`. Ahora por mis muelas que no recuerdo si esto está en msc3. Si no, algo parecido habrá. Si no, añadirlo es una tontería. Se puede usar para lanzar cuando el jugador coja un `TILE_GET`
- `SHOW_COINS` / `HIDE_COINS`. Si las monedas son decoraciones, esto sobra porque puedo usar `DECORATIONS`. Lo que tengo que mirar es qué coño hace `HIDE_COINS`, porque supuestamente las monedas las hemos tenido que coger.
- Las monedas que se cogen en las pantallas trampa se cuentan sobre el `FLAG 1`. La comprobación de que se haya cogido las 20 se hace en la sección `PLAYER_GETS_COIN`. En cualquier caso se incrementa en 1 la vida.
- `ENABLE_TYPE_6` y `DISABLE_TYPE_6` hacen que los murciélagos empiecen a moverse o se queden paralizados. Esto se puede hacer de forma diferente en MK2, pero creo que no me cuesta nada adaptarlo en msc3. Las directivas ya están, pero generan código viejo. Sólo tengo que adaptar la generación de código y hacer una leve modificación al motor, así que esto lo añado.
- Casi todos los textos se ponen con `TEXT` y son de la leche de limitados. Ahora todos irán en cajas de texto. Pensaba usar directamente las cajas de texto de Ninjajar!/etc, pero mola el sonido tipo "adultos de las películas de Peanuts" que aparece con cada linea, así que las cogeré y las modificaré levemente para que suenen así.
- Creo que MK2 no lleva el mismo set de sonidos. Habrá que ponerlo y adaptar. Tengo que mirar esto también.
- Que te puedan matar despacito o no se controla con `ENABLE_KILL_SLOWLY` y `DISABLE_KILL_SLOWLY`. Esto es fácil de añadir, aunque en realidad podría hacerlo con un extern... Tengo que pensarlo. >> LATER: Siguiendo al convención de muchas otras cosas nuevas que hay en MK2, puedo poner en config.h `ENABLE_KILL_SLOWLY_FLAG` para controlarlo con una flag. Es lo más fácil y más mejor (y menos peor).
- Acabo de mirar que `HIDE_COINS` sólo toca una variable de estado, así que paso de implementar estos. Quito las monedas del mapa, las pongo como decoraciones, y a tomar viento.
- Tengo que usar `LINE_OF_TEXT` de todos modos porque se usa para los nombres de las pantallas. O puedo usar el módulo de nombres de pantalla y darle un nombre a cada pantalla, que eso le encanta a Anjuel.
- El script del juego es realmente arcáico. Creo que tardo menos reescribiéndolo todo con las nuevas características, que son la leche de potentes.
- No sé si está definido que fanty y lineales quiten diferente vida. En concreto, 12 fanty y 9 los normales.


No me puedo demorar en trasladar las mejoras de msc3nes a msc3. Creo que será lo primerísimo que haga.  Luego intentaré generar el mapa completo para el nuevo formato.

~~

Para generar el nuevo mapa, partiré del .map original y haré un pequeño programilla en freeBASIC que me haga las adaptaciones pertinentes. Las apunto aquí:

- Son 30 pantallas (15x2).
- En la fila de arriba, `tiles1 = tiles0`.
- En la fila de abajo, `tiles1 = tiles0 + 32`.
- En cualquier pantalla, si `tiles0 = 13`, `tiles1 = 0`, y sacar archivo cruces.spt con las cruces como decoraciones.

Sobre el archivo generado pintaré las decoraciones en mappy según lo que lea en el script. No son demasiadas.

Nah, eso es de chumis. Voy a meter las decoraciones automáticamente parseando el script.

~~ 

Hecho. Voy a hacer los cambios necesarios en msc3, a saber (repito lo escrito con pepito y su enorme pito): `ENABLE/DISABLE_TYPE_6`. Por cierto, `PLAYER_GETS_COIN` existe, es `(MAP_W*MAP_H*2 + 4)`.

`ENABLE/DISABLE_TYPE_6` funcionará si en config.h definimos `TYPE_6_NUMBABLE`.

Qué coño, no, joder, que soy farfolla.

Se hace un define TYPE_6_NUMB_ON_FLAG y se controla con un puto flag! Lo que tengo que hacer ahora es meter estas cosas en el motor:

- `ENABLE_KILL_SLOWLY`      [X]
- `KILL_SLOWLY_ON_FLAG n`   [X]
- `KILL_SLOWLY_GAUGE`       [X]
- `KILL_SLOWLY_FRAMES`      [X]
- `PATROLLERS_HIT n`        [ ]
- `FANTIES_NUMB_ON_FLAG`    [x]
- `FANTIES_HIT n`           [ ]

O sea, 0 cambios en msc3, y esos pequeños cambios en el motor. Vamos al lío, pero ahora voy a comer alguna mierda.

~~

Cómo funciona lo del `KILL_SLOWLY`, en palabras: Si se detecta que el centro del jugador está en una zona de las que matan, se decrementa cada X frames un contador. Cada vez que se decremente el contador suena un sonido. Cuando el contador llega a 0, se quita vida. Mientras te quita vida, suena un beep cada 8 frames.

~~ 

Lo que menos problema parecía que iba a dar es lo que me está quebrando la cabeza: `PATROLLERS_HIT` / `FANTIES_HIT` / `XXX_HIT`. Tengo centralizadas las muertes y las colisiones. A ver cómo me las ingenio para integrar esto.

Voy a dejarlo un rato mientras pienso.

IDEA: Cambiar `kill_player (sonido)` por `kill_player (sonido, amount)` y tal. La putada es que eso gasta bytes sí o sí aunque no estemos usando diferentes cantidades :-/

Tengo que pensar algo mejor. Está claro que los juegos con vidas y los juegos con energía son dos bestias diferentes. Llevo años tratándolos igual, pero está claro que cuando las vidas bajan de uno en uno el código siempre es más sencillo.

Mira, ¿sabes qué te digo? Lo pongo estándar. Si algún día me veo apurado y puedo optimizar esto de forma custom, lo haré.

Joder, es que no hay que ser más papista que el papa.

~~ 

Creo que lo he resuelto. Dentro de un rato probaré a configurar y compilar, a ver qué sale.

~

Languidecewwwwwwr. Joer, tengo que dormir más o moriré jóven.

~

He estado un rato dándole a la compilación. En el proceso he arreglado varias patazas que metí en los cambios para la 0.90 (key to time). Cuando termine este proyecto haré un merge.

Ahora se queda aún a un paso del éxito. Tengo que revisar cosas. Me dice que no encuentra una variable que defino poco antes.. Me temo que va a haber #ifdefs mal balanceados. Pero es que hoy estoy demasiado cansado para seguir.

20160126
========

Pues no, no era nada de eso. Era una reorganización de código que hice para K2T que metía una cagada que, con la combinación de #defines de ese juego en config.h, no daba la cara.

También he enmendado un montón de efectos colaterales introducidos en K2T. Realmente me está viniendo bien esto: modifiqué y añadí cielo y tierra en K2T - un juego para 128K en un nuevo modo de Genital (New Genital!) que intenta imitar una suerte de 2.5D tipo "engañar al chamán" (no hay alturas reales), y ahora me pongo con un juego para 48K de plataformas que apena necesita desarrollo, ¡pero me sirve para maquear todas las posibles cagadas cometidas! Siempre mola alternar juegos de diferentes características por esto mismo.

En fin, veamos como se ha quedado esto. Primera compilación, en al que no funcionará apenas nada - pero al menos todo está ahí, salvo el script. Y ahora ocupa.... (redoble) ~30K! O_o Joder, habla de mejoras.

El Ramiro original apenas cabía, coño, tuvimos que dejar de incluir música en el menú y todo. Ahora voy a poder decirle al murciano que se curre algo y, si me deja sitio, poner algo de más age en la intro (aunque mejor que no empiece a fliparme con esto, que aún hay que meter el scripting y, además, más textos que en el original - y las rutinas para mostrarlo).

Otra cosa que tengo que hacer es meter los sonidos, y aprovecharé para hacerlo en condiciones y usar constantes.

~~

Acabo de recordar que ayer se me fue la pinza y dejé el modo twots de map2bin.exe (el que interpreta y genera datos para mapas de dos tilesets de 16 + decoraciones) a falta de crear al final la tabla con el mapeo de tilesets para cada pantalla. Voy a ellou.

~

Sigo arreglando algunas cosillas, pero acabo de darme cuenta de que se me ha ocurrido cargarme el módulo viejo de enemigos para siempre justo cuando lo necesito XD

Vaya, que Ramiro usa en su .ene, obviamente, el formato viejo... Y acabo de ventilármelo.

Lo que voy a hacer es algo que vendrá bien (o será completamente inutil) en el futuro: un parseador/conversor del formato viejo al antiguo. No es complicado, se trata de cambiar el "tipo" del enemigo.

El tipo viejo era así:

```
    t = 1 - 3, lineal.
    t = 4, plataforma (lineal).
    t = 6, fanty.
    t = 7, pursuer.
```

Había más, pero para hacer revisiones de clásicos me basta y sobra con esos.

El formato nuevo es:

```
    // XTTTTDNN where
    // X = dead
    // TTTT = type       1000 = platform
    //                   0001 = linear
    //                   0010 = flying
    //                   0011 = pursuing
```

Así que es tan fácil como:

```
    t0  t1
    1   00001000 (8)
    2   00001001 (9)
    3   00001010 (10)
    4   01000011 (67)
    6   00010010 (18)
    7   00011000 (24)
    8   00001100 (12)
```

Venga, si tardo más de cinco minutos soy una patata con tupé.

~

Ya se mueven los enemigos y tal, pero me he dado cuenta de algo que hay diferente: en la versión original, el cálculo de los atributos era levemente diferente a al hora de convertir el tileset. Antes, cuando sólo encontraba un color, forzaba a que el otro fuera negro. Ahora intenta compensar (claro con oscuro). Voy a estudiar como era exactamente la conversión original y hago un custom para convertir este tileset de la misma manera.

¡Joer, monto un circo y me crecen los enanos!

~

Hecho. A otra cosa. Para probar más cosas tengo que empezar con el script. Lo primero es poner la interacción de Ramiro con la hija canija en la primera pantalla. De paso, voy definiendo la utilidad de cada flag. 

Antes que nada voy a leer la breve lista de flags que hay al principio del script original para hacer find & replace y "etiquetar" los números para que sea más fácil seguir el script.

~~

Como últimamente no paro de fliparme (no sé qué pasa) voy a hacer una nueva versión de la rutina que imprime textos. Básicamente será la de Ninjajar / Leovigildo / etc, pero:

- Muestra el texto linea a linea con los sonidos POPOOOOU del original.
- Se presenta en una caja de texto con un título en rojete con el nombre del que habla.
- Hacer esto de la forma más sencilla posible [*]

[*] Así: el text stuffer mete saltos de linea con "%", que además puedo meter yo de forma explícita. Lo que se hace es que la primera linea que se escribe es el título (y se pinta de otro color y tal).

Se me acumula la mierda: 

[X] Añadir al fuente ¡ ¿ Ñ y algo para pintar un recuadro.
[ ] Cambiar los sonidos del engine (usando constantes).
[X] Adaptar la función de pintar textos y encasquetarla en el extern.

~~ 

Ya tengo la función nueva de pintar las cajas de texto. Voy a probar a ver si funciona. Como el cuadro de texto (levemente más complejo que e costumbre) se vea guay, soy el rey de pichas.

~

Antes de probar nada me he empezado a rayar con los nombres de las pantallas. 30 pantallas de 30 caracteres por nombre son 900 bytes. Vamos bien de memoria, pero me parece un desperdicio, así que lo meteré dentro del texto empaquetado para reducir. Serán los 30 primeros textos. Los que se imprimen desde el script empiezan en el 31.

~~

¡Perfecto! Así ocupan 532 bytes, poco más de la mitad. Voy a modificar las rutinas y a quitar la extensión levelnames.h

~~

Urm - hay algún problema con el texto comprimido. O bien se comprime mal, o bien se descomprime mal. Sé que modifiqué textstuffer2 para k2t y poder meter los cuadros de texto con caritas y tal que tenían un word-wrapping diferente; quizá se cambiase algo en el empaquetado.

La cosa es que salen letras raras donde no deberían. Tengo que revisar qué estoy jiñando.

Vale, creo que me acabo de acordar: creo que en K2T se admite más de 256 textos y yo estoy considerando un máximo de 256... Revisemos... Hmmm ... parece que hay cambios pero no parece que deberían afectar. Revisemos más. Obviamente algo hay distinto.

... Ya está. Era una estupidez. Había cambiado esto para usar el espacio en el caracter 31, que estaba vacío, pero ese era también el caracter de escape para el rango de los caracteres menos usados. Voy a ver si ya funfuña...

~~

Funfuñaba, pero me dije de centrar verticalmente los cuadros de texto, que siempre queda más molón, y obtengo resultados raros. Creo que tengo que revisar textstuffer2. Desde luego llevo un par de días de un espeso acojonante. A ver si vuelvo a un mejor estado de forma.

20160127
========

Buenos días por la mañana. Voy a añadir algo al sistema de scripting que vendrá de muerte: `SET BEH (X, Y) = B` para establecer el comportamiento de un tile. Voy a ellou.

Hecho y funcionando, con más enmiendas. Pero al final no lo voy a usar. Si alguien quiere salir y quemarse, que salga y se queme.

Lo que sí tengo que hacer es bucar la forma de interrumpir o acelerar los cuadros de texto - pero esto es un problema: detectar las teclas será difícil porque la mayoría del tiempo esto está ocupado haciendo sonido. Bueno, es mejor que nada...

Otra cosa que haré es meter "REDRAW / SHOW" en el código del extern, que no hago más que repetirlo por todo el script...

~~

Done. Ahora, obra y gracia del script, la Bruja Maruja se harta de hablar y al final te lanza el hechizo postizo. No sé si hacer algún efecto de "hechizo postizo". ¿Tengo por ahí el código del kjjjj del borde? Lo miraré luego. Un kjjjj siempre mola. Pero lo suyo es que fuese en blanco y negro sólo.

Ahora tengo que añadir al marcador el valor de `p_ks_gauge` para terminar de introducir el tema del `ENABLE_KILL_SLOWLY`.

OK - ya está hecho. Voy a seguir con el script.

~

Voy a intentar hacer de un tirón la cripta de juanillo el colmillo y todo el recorrido hasta la trampa y la primera pieza del talismán. Así compruebo que esté todo. Los otros recorridos serán triviales después de hacer este.

Pero hoy estoy espeso no, SUPER espeso.     

~~ 

cosas raras / que mirar:

- No se puede pasar a la fila inferior del mapa. Seguramente el código del "flick screen" esté mal por alguna cagada que he metido en K2T. < mirarlo despacio para no romper el código de K2T de los mapas cíclicos.
- Modificar el código del extern para que borre la linea de texto anterior en los nombres de las pantallas, que se quedan ahí los caracteres.

~~ 

Todo lo de arriba, arreglado. Lo que no cachirola ahora es el cambio automático de set al pasar a la tira de abajo. Voy a revisar cosas.

~~

Fixed. Era una soberana tontería causa de programar dormido. Ahora tengo que revisar la colisión con los tiles tipo 1, que, como siempre, va rara. Joder, cinco años con lo mismo... Veamos qué tal resolvemos.

~

Resueltas las miserias. Además he hecho algo super divertido, que ha consistido en mirar todo el código para cambiar los numeritos de las llamadas a los diferentes motores de sonido para tocar efectos por constantes que se definen en definitions.h

YUJU.

20160129
========

Tras un día en barbecho, vuelvo. Antes de ponerme a seguir con el script, voy a darle un poco fran a la configuración de los enemigos de tipo 6. Es una tontería: ahora mismo está configurado como en Ninjajar!, en los que frames 0 y 1 se usaban para que el muñeco mirase a la izquierda y a la derecha. Eso ya no me vale: ahora necesito que los frames 0 y 1 esten continuamente alternando para hacer la animación del movimiento de las alas.

También tengo que revisar alguna que otra nimiedad. A ver si tal. Lo que pasa es que ahora mismo no lo recuerdo - fue algo en lo que pensé el otro día mientras probaba la activación y desactivación del fanty y que me dije "esto puede dar problemas, tengo que mirarlo". ¿Por qué narices no lo apunté?

En fin...

~

Me he acordado: 
- Hacer que el estado "numb" de los fantys haga que siempre estén en el estado "volviendo a casa" (si no están en casa)
- Ampliar la distancia de la vista.

~

Todas las ampliaciones necesarias de los fantys hechas. Segundo talismán hecho. "Es una tduampa" hecha. Sólo faltan dos talismanes y las comprobaciones finales con la Bruja Maruja, el Encantamiento del Pimiento, y el Tesoro del Moro con la Hija Canija.

~~

A las 23:57 - ¡"El Vampiro Ramiro no tiene un respiro" terminado! - Bueno, a falta de testing y musiquilla murciana.

20160130
========

Empezamos "El Vampiro Ramiro devuelve el zafiro". Copio la carpeta del juego anterior, sobrescribo los sets gráficos, y...

- Convertir mapa old->mapa new
- Reescribir script
- ????
- Profit

~~

Map is 75x60 tiles -> 5x6 = 30 pantallas.

OK - Todo el trabajo inicial está hecho: he convertido mapa y enemigos, he nombrado todas las habitaciones, he colocado las decoraciones en su sitio, he vaciado el script, he apañado el config y el make.bat, cambiado el título... Todo funciona perfe. Sólo queda hacer el script nuevo.

Tema `ENABLE/DISABLE_MAKE_TYPE_6`

Estudiemos el código viejo:

- En primer lugar, la característica se activaba a golpe de script. Teníamos `ENABLE/DISABLE_MAKE_TYPE_6`. Esto hacía que se ejecutase `scenery_info.make_type_6 = 1 / 0`. Esa estructura `scenery_info` murió con la versión 4 de MK1. 
- Al entrar en una pantalla e inicializar los enemigos, si `scenery_info.make_type_6 == 1`, los enemigos tipo 0 (no existentes) se creaban como tipo 6 en una posición al azar.

Esto lo hago con un custom. No creo que vaya a usar algo así en ningún otro juego. Lo dejo en un flag y que el motor lea el flag y haga lo que tenga que hacer en un bonito bloque `CUSTOM { } END_OF_CUSTOM`. 

Pero ahora es la hora de comewr.

Cosas que mirar para luego

- El código que elige uno u otro tileset a veces no funciona. En concreto, parece que no se vuelve bien del tileset 1 (+32) al 0 (+0). -- Era una tontería. Resuelto y trasladado a la parte 1.
- No aparecen enemigos en ramiro2. Algo se me ha tenido que escapar. ¿No he convertido bien el formato? ¿Se me olvidó copiar el archivo? -- No, es que el conversor no funcionaba si no lo ponías en modo "verbose" por una gilipollez de principiante (dormido).

Démosle fran al script.

~~

OK - He dejado el script listo a falta de criptas y parte final. Voy a probar, que no me gusta hacer tantas cosas sin probar. Al menos debería poder hablar con todos los guardianes y con Gonzalo, y tras esto, deberían aparecer los cristales que accionan las trampas.

20160510
========

Retomo después de un millón de años, más o menos, que hay que escamondar esto bien para el Verkami. 

Ahora mismo el problema es que si activamos el `MAKE_TYPE_6` parece que los murciélagos aparecen siempre en la esquina superior izquierda. Voy a ver la inicialización de los enemigos.

Joder, tengo MK2 completamente borrado de la memoria. No sé muy bien donde tengo que mirar XD

~~ 

Creo que era un break mal puesto. Como sea esto, me jeringo.

No era eso, pero voy avanzando: por un lado, si están así, no pueden estar "NUMB", así que hay que poner esa variable a 1 también. Ahora veo que colisionan conmigo, pero siguen en la esquina. Creo que esto es un problema de no estár pintándolos donde es debidow... HUM.

¿Dónde coño se hacía el render? XDD

~

Creo que el tema está aquí:

```
    if (
        (baddies [enoffsmasi].t & 0x78) == 16
    ) {
```

Que eso no vale así. Eso es 0 para estos murciélagos. A ver cómo me las apaño. 

Quizá sea un buen momento para cambiar lo mierda que es esta parte de MK2, I mean, wat?

Puedo usar gpen_cx directamente en el render, si no me equivoco, y ahorrar muchos bytes y tiempo. 

Joder, esto se me ha ido de las manos. Acabo de darme cuenta de que MK2 está muuuuuuuy lleno de caca, hay que sanear.

Bueno, por lo pronto he movido el render de los enemigos a la propia función que los actualiza, y además de ahorrar ciclos y bytes, he hecho que funcione esta mierda. 

Ahora a ver si retomo. Tengo que ver en qué punto del script me hallo. Esto de abandonar algo así varios meses no mola, luego cuesta la hostia retomar.

~~ 

Vale, recuerdo que todo se llevaba con GAME_STATE, eso creo que lo puedo consultar. Guay, me amo, lo estaba haciendo genial:

```
    # Game state. Somewhat more complex than originally
        # 0 -> Initial
        # 1 -> "Go talk with Gonzalo"
        # 2 -> Already talked to Gonzalo
        # 3 -> Talisman pieces on fire!
```

Entonces en teoría sólo me quedaría el final, cuando habla con Gonzalo, I suppose. Tengo que ver el script original y talw.

Este es el código original de Gonzalo el Malo

```
    ###################
    # GONZALO EL MALO #
    ###################

    ENTERING SCREEN 2
        IF TRUE
        THEN
            SET TILE (4, 7) = 30
            SET TILE (4, 8) = 31
            #TEXT __WEEVIL_THE_EVIL'S_CHAMBER___
            TEXT _LA_CAMARA_DE_GONZALO_EL_MALO_
            SET FLAG 6 = 0
            SET_FIRE_ZONE 0, 48, 112, 255
        END
    END

    PRESS_FIRE AT SCREEN 2
        IF PLAYER_IN_X 48, 96
        IF FLAG 4 = 0
        IF FLAG 6 = 0
        THEN
            SET FLAG 4 = 1
            SET FLAG 5 = 1
            SET FLAG 6 = 1
            EXTERN 2
            EXTERN 3
            REDRAW
            SET TILE (4, 7) = 30
            SET TILE (4, 8) = 31
        END
        
        IF PLAYER_IN_X 48, 96
        IF FLAG 4 = 1
        IF FLAG 6 = 0
        IF FLAG 2 <> 4
        THEN
            SET FLAG 6 = 1
            #TEXT _WEEVIL:_MORE_WORK_TO_BE_DONE_
            TEXT _GONZALO:_AUN_NO_ESTAN_TODOS!_
            SHOW
            SOUND 7
        END
        
        IF PLAYER_IN_X 48, 96
        IF FLAG 4 = 1
        IF FLAG 2 = 4
        THEN
            EXTERN 4
            WIN GAME
        END
    END
```

Voy a ver qué tengo eu...

¡Coño, si está terminado!

Bueno, pues sólo hay que probarlo, pues. Voy a por el Bosque del Suspiro, pero antes voy a trasladar el cambio que he hecho al motor y a ver en mojonia si hay algún bug registrado.

~~

Menos mal que tengo diarios. Tengo que convertir mapa y enemigos a nuevos formatos y tal. Voy a ello, que ya tengo montada la carpeta dle proyecto y limpiado el script.

~~ 

UM.

Esto no era así, este parece diferente. Tengo que recordar más cosas. El conversor de mapa me genera cosas muy raras. Creo que voy a tener que hacer un cambio en el conversor para este juego. Voy a examinar las cosas a ver como son...

En los juegos 1 y 2 las cruces estaban en el mapa. Lo que hacía en el conversor, además de resolver las decoraciones a partir del script y meterlas en el mapa, era quitar las cruces y sacarlas a código de script que añadir en el script de verdad. Pero creo que este juego era diferente...

VALE, JODER

Que tengo que adaptar el adaptador de mapas, claro, hostia picha tontolculero. Esta tarde, ahora me voy a casa.

~~

En casa acabo de convertir el mapa sin (demasiados) problemas (joder, vaya mi memoria, está cagada del todo). Ahora voy a ver qué se hace de los enemigos y tal y cual...

20160515
========

Ya tengo casi listo "en el bosque del suspiro", me queda copiapegadaptar el código de script de tres criptas y probar. Ah, y he metido un 

BUG: Con el cambio en el renderer, los enemigos vacíos "se pintan" (con basura de la pantalla anterior). Tengo que solucionar esto de la mejor forma posible.

Cada vez me gusta menos MK2 - me explico: está demasiado sucio. No tengo ganas de empezar un MK3 o algo así, pero si algún día vuelvo "full fledged" al Spectrum, a lo mejor empiezo el motor "limpio" y cortando/pegando.

Mis motores de NES están mucho más limpicos.

Pero claro, uno evoluciona y tal.

En fin, yo a lo que voy. Por el momento, cada vez que vea una zapatiesta la arreglaré lo mejor que pueda.

Y no se me puede olvidar trasladar todos estos fixes al código de K2T, por dios.

20160516
========

He visto un pequeño bug que creo que me comentaron estos hace algún tiempo: cuando tienes menos de la energía que te quita un enemigo, plife da la vuelta (se pone negativo, vaya) y no detecta la muerte.

Creo que es el momento para centralizar en kill_player este tema.

Voy a ello. Espero no romper nada de rebote.

~~

Vale, está pseudohecho. No me gusta mucho como está hecho, pero por ahora me va a valer porque no quiero perder más tiempo con estos juegos. 

Llevamos varios días de prueba, casi está. No creo que vuelva a escribir aquí. Adieu!

Bueno sí, sólo quiero decir que MK2 queda oficialmente abandonado. Tirarse un año sin mirarlo y verlo luego de nuevo me ha dado la perspectiva suficiente para entender que hay tanta mierda que lo mejor es un `rm -rf` y empezar de nuevo.
