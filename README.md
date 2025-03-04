[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=17798957&assignment_repo_type=AssignmentRepo)
# Entrega 1 del proyecto WP01
* Jose Luis Ocoro Banguera
* Alejandro
* Mateo

## Introducción
Para la asignatura de Electrónica Digital I, hemos decidido desarrollar un Tamagotchi implementado en una FPGA. Este sistema nos permitirá simular la interacción y el cuidado de una mascota virtual mediante una combinación de sensores, botones y una interfaz visual sencilla pero efectiva.

Nuestro proyecto no solo nos permitirá aplicar los conceptos vistos en clase, sino que también nos dará la oportunidad de explorar el uso de elementos adicionales en el diseño digital, como sensores, displays y estructuras de control basadas en máquinas de estado finito (FSMs). Nuestro objetivo es crear un sistema intuitivo para el usuario y, al mismo tiempo, profundizar en el diseño de hardware digital aplicado a sistemas de entretenimiento.

## Objetivos
### General
Desarrollar un sistema de entretenimiento basado en el concepto de Tamagotchi, en el que los usuarios puedan interactuar con una mascota virtual y atender sus necesidades a través de un sistema digital implementado en FPGA.

### Específicos
- **a)** Aplicar los conocimientos adquiridos en electrónica digital para implementar correctamente las funciones del sistema.
- **b)** Diseñar una interfaz de usuario intuitiva, facilitando la interacción con la mascota virtual.
- **c)** Implementar elementos visuales dinámicos que representen los estados y necesidades de la mascota.

## Descripción del Sistema
Nuestro sistema consiste en un juego de simulación de cuidado de una mascota virtual, donde los usuarios deberán interactuar con el Tamagotchi para mantenerlo en buen estado. La mascota pasará por diferentes estados en función de las acciones realizadas y las condiciones del entorno.

### Partes del sistema
#### Sensores
1. **Sensor Ultrasonido:** Detectará la proximidad y el movimiento del usuario, influyendo en los estados de la mascota.

#### Botones
1. **Reinicio(reset):** Restablecerá el sistema a sus valores predeterminados.
### Visualización de la mascota
#### Matriz de puntos 8x8: 
* Se encargara de mostrar imágenes que representarán el estado de la mascota y proporcionarán retroalimentación visual sobre sus necesidades.
#### Display de 7 segmentos: 
* Representará variables como niveles de hambre o energía, complementando la visualización principal.
### Estados de la mascota
#### Feliz
La mascota se encontrará en este estado cuando haya interacción frecuente con el usuario. Se mostrará una expresión animada en la matriz de LEDs, indicando que está en buen estado y satisfecha. Este es el estado óptimo en el que se busca mantener a la mascota.
#### Triste
Si la mascota pasa mucho tiempo sin detectar movimiento cercano, entrará en estado de tristeza. En este estado, se representará una expresión de tristeza en la matriz de LEDs y su nivel de actividad en el display de 7 segmentos disminuirá. Para devolverla al estado "Feliz", será necesario que el usuario se acerque nuevamente.
#### Enojado
La mascota se enojará si detecta movimientos bruscos y repetitivos en un corto período de tiempo, como si el usuario estuviera acercando y alejando la mano rápidamente. En este estado, se mostrará una expresión de enojo en la matriz de LEDs, y el sistema tardará un tiempo en permitir que la mascota vuelva a su estado normal, incluso si el usuario deja de hacer movimientos bruscos.
#### Dormido
Si la mascota pasa un tiempo prolongado sin detectar movimiento, entrará en estado de sueño. En este estado, la mascota permanecerá inactiva y su animación en la matriz de LEDs reflejará que está dormida. Para despertarla, el usuario deberá acercarse nuevamente.

### Interacciones del usuario
Los usuarios podrán interactuar con la mascota a través la detección de movimiento mediante sensores. Estas interacciones afectarán los estados de la mascota, generando respuestas visuales en la matriz de LEDs y en el display de 7 segmentos.

### Arquitectura del sistema
### Módulo: BCDtoSSeg

### codigo: 
```verilog 
module BCDtoSSeg (BCD, SSeg);

  input [3:0] BCD;
  output reg [0:6] SSeg; // se puede definir de 0 a 6, o de 6 a 0, cambiando posición del bit más significativo

  always @ ( * ) begin
    case (BCD)
      4'b0000: SSeg = 7'b0000001; // "0"  
      4'b0001: SSeg = 7'b1001111; // "1" 
      4'b0010: SSeg = 7'b0010010; // "2" 
      4'b0011: SSeg = 7'b0000110; // "3" 
      4'b0100: SSeg = 7'b1001100; // "4" 
      4'b0101: SSeg = 7'b0100100; // "5" 
      4'b0110: SSeg = 7'b0100000; // "6" 
      4'b0111: SSeg = 7'b0001111; // "7" 
      4'b1000: SSeg = 7'b0000000; // "8"  
      4'b1001: SSeg = 7'b0000100; // "9" 
      4'b1010: SSeg = 7'b0001000; // "A"
      4'b1011: SSeg = 7'b1100000; // "b"
      4'b1100: SSeg = 7'b0110001; // "c"
      4'b1101: SSeg = 7'b1000010; // "d"
      4'b1110: SSeg = 7'b0110000; // "E"
      4'b1111: SSeg = 7'b0111000; // "F"
      default: SSeg = 0;
    endcase
  end

endmodule
```


#### Diagrama de caja negra

![TamagotchiCN](https://github.com/user-attachments/assets/a02d9bc4-76aa-4778-aab9-fff992520077)


## Plan de trabajo acordado 
#### Semana 1 
1. Driver 8x8 matrix con Max7219 SPI, https://www.alldatasheet.com/datasheet-pdf/view/73745/MAXIM/MAX7219.html     y     https://github.com/unal-edigital1/2024-2/blob/master/labs/buses/SPI/spi.md
2. Diver ultrasonido, https://leantec.es/wp-content/uploads/2019/06/Leantec.ES-HC-SR04.pdf
#### Semana 2
1. FSM
2. Infrarrojo
#### Semana 3 
1. Integración
2. Pruebas
