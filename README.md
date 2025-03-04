[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=17798957&assignment_repo_type=AssignmentRepo)
# Entrega 1 del proyecto WP01
* Jose Luis Ocoro Banguera
* Alejandro Jiménez Zabala
* Nicolas Mateo Guio M.

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

## Arquitectura del sistema
## Ultrasonido
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

### Explicación Detallada del modulo:
Este módulo se encarga de convertir un número BCD (Binary-Coded Decimal) en la configuración correspondiente de un display de 7 segmentos. Su función principal es recibir un número de 4 bits (BCD) y activar los segmentos correctos del display para representar el dígito o letra correspondiente.
### Entradas y Salidas del modulo:
Entrada: input [3:0] BCD;
* Es una señal de entrada de 4 bits.
* Representa un número en formato BCD (0000 a 1111, es decir, valores decimales de 0 a 15).
* Utilizamos un input porque el sistema externo proporciona este valor y nuestro módulo solo lo procesa, sin modificarlo.

Salidas: output reg [0:6] SSeg
* Es una salida de 7 bits que representa los segmentos del display de 7 segmentos.
* Usamos reg porque la señal cambia dentro del always, lo que significa que su valor se mantiene hasta la siguiente actualización.
* La numeración [0:6] indica que el bit 6 es el más significativo y el bit 0 el menos significativo, aunque esto puede variar dependiendo de cómo esté cableado el display.

### Funcionamiento del always y case
* La instrucción always @(*) significa que el bloque de código dentro de always se ejecuta cada vez que cualquier señal dentro de él cambia.
* Utilizamos un case (BCD) para evaluar el valor de BCD y asignar el patrón de bits adecuado a SSeg, activando los segmentos correctos en el display.
* Cada número del 0 al 9, y las letras de la A a la F, tiene su configuración específica en 7 bits.

### Módulo: dis.v

Codigo: 
```verilog
module dis(an,clk,number,seg,rst);
    output reg [7:0] an;  
    input [31:0] number;  
    output [0:6] seg;  
    input rst;  
    reg [7:0] th;  
    input clk;  
    reg [31:0] num=0;  
    wire [4:0] temp;  
    wire [7:0] tempConv;  
    wire[1:0] alert;  
    wire o_DV;  
    reg start=1'b1;  

    reg[2:0] count =0;  
    reg [26:0] fre;  
    wire enable;  
    assign enable =fre[16];  
    reg [2:0] test=0;  

    BCDtoSSeg bcd(.BCD(th),.SSeg(seg));  

    always @(posedge clk) begin
        if(rst==1) begin
                fre <= 0;
            end else begin
                fre <=fre+1;
        end
    end

    always @(posedge enable) begin
        if(rst==0) begin
            count<= count+1;
            num<=number;
            case (count)
                3'd0: begin th <= num[3:0]; an <= 8'b11110111; end
                3'd1: begin th <= num[7:4]; an <= 8'b11111011; end
                3'd2: begin th <= num[11:8]; an <= 8'b11111101; end
                3'd3: begin th <= num[15:12]; an <= 8'b11111110; end
                3'd4: begin th <= num[19:16]; an <= 8'b11101111; end
                3'd5: begin th <= num[23:20]; an <= 8'b11011111; end
                3'd6: begin th <= num[27:24]; an <= 8'b10111111; end
                3'd7: begin th <= num[31:28]; an <= 8'b01111111; end
            endcase
        end else begin
            count<= 0; 
        end
    end
endmodule
```
### Explicación Detallada de este modulo:
Este módulo se encarga de controlar la visualización de números de 32 bits en displays de 7 segmentos de 8 dígitos, utilizando multiplexación para encender secuencialmente cada dígito con una frecuencia específica.
### Entradas y Salidas del modulo:
Entrada 1: clk (input):
* Señal de reloj que sincroniza las operaciones del sistema.
* La utilizamos como entrada porque es generada por la FPGA para marcar el tiempo de ejecución.
rst (input):
* Señal de reinicio que restablece el sistema a su estado inicial.
* La definimos como input porque permite al usuario reiniciar el sistema manualmente.
number (input):
* Contiene los datos que se mostrarán en los displays.
* Tiene 32 bits para representar hasta 8 dígitos BCD, uno por cada display.
Salidas: an (output):
* Representa los ánodos activos bajos que controlan qué display de 7 segmentos está encendido en cada momento.
* Lo definimos como reg porque se actualiza dentro del bloque always.
seg (output):
* Señal de salida que se conecta al módulo BCDtoSSeg para controlar qué segmentos se iluminan según el valor de cada dígito.
* Tiene 7 bits para controlar los 7 segmentos del display.
### Multiplexación de Displays:
Dado que solo podemos encender un display a la vez, implementamos un sistema de multiplexación para mostrar los 8 dígitos rápidamente y generar la sensación de que todos están encendidos al mismo tiempo.
¿Cómo funciona?
* El contador count recorre del 0 al 7 para seleccionar cada uno de los 8 dígitos.
* Extraemos el valor correspondiente de 4 bits desde la entrada number y lo asignamos a th.
* La señal an activa el display correspondiente (usando lógica activa baja).
* Enviamos th al módulo BCDtoSSeg, que convierte los 4 bits en la configuración del display.

### Divisor de Frecuencia:
Utilizamos un bloque de división de frecuencia para reducir la velocidad de actualización de los displays y hacerlos visibles de manera estable.
```verilog
reg [26:0] fre;
assign enable = fre[16];
```
Este contador fre se incrementa en cada flanco de subida del reloj, y la señal enable se activa cada vez que fre[16].
### Secuencia de Activación: 
Cada vez que la señal enable se activa:
* Incrementamos count para seleccionar el siguiente dígito.
* Asignamos los bits correctos a th.
* Encendemos el display correspondiente con an.
### Módulo: ultrasonic:

Codigo:
```verilog
module ultrasonic(clk,reset,echo,trigger,an,seg,enable,true_cm);
    input clk;
    input reset;
    input echo;             
    output reg trigger=0;
    reg [15:0] cm=0;
    output [7:0] an;
    output [0:6] seg;
    reg [22:0] counter;
    reg [11:0] cm_cont;
    input enable;
    output reg [15:0] true_cm=0;
    reg [15:0] otros=0;

    dis Dis(.an(an),.clk(clk),.number({otros,true_cm}),.seg(seg),.rst(reset));

    always @(posedge clk or posedge reset) begin
        if (reset==1) begin
            counter <= 0;
            trigger <= 0;
            cm_cont <=0;
            cm<=0; 
        end else begin
            counter <= counter + 1;
            cm_cont<=cm_cont+1;
            if (cm_cont>=2900 && enable==1 && echo==1) begin
                cm_cont<=0;
                cm<=cm+1;
                true_cm<=cm;
            end
            // Generación del pulso de Trigger (10 µs mínimo)
            if (counter < 500) begin  // 10 µs con clk de 50 MHz
                trigger <= 1;
            end else if (counter < 1000) begin
                trigger <= 0;
            end 

            // Reiniciar el ciclo cada 100 ms (~5,000,000 ciclos a 50 MHz)
            if (counter >= 5000000) begin
                counter <= 0;
                cm_cont <=0;
                cm<=0;
            end
        end
    end
endmodule
```
### Explicación Detallada del modulo:
Este módulo se encarga de medir la distancia de un objeto utilizando un sensor ultrasónico y mostrar la distancia en un display de 7 segmentos. Para lograrlo, generamos pulsos de activación (trigger), medimos el tiempo de respuesta (echo) y convertimos esa medición en centímetros (true_cm).

### Entradas y Salidas del modulo: clk (entrada)
* Es el reloj del sistema, que utilizamos para sincronizar los procesos de medición.
reset (entrada):
* Restablece todos los registros a su estado inicial.
echo (entrada):
* Es la señal de respuesta del sensor ultrasónico. Nos indica cuándo ha regresado el pulso ultrasónico tras rebotar en un objeto.
trigger (salida, reg):
* Genera el pulso necesario para iniciar la medición en el sensor ultrasónico.
an (salida):
* Controla qué display de 7 segmentos se ilumina.
seg (salida):
* Contiene la información de qué segmentos deben encenderse para mostrar la distancia medida.
enable (entrada):
* Habilita o deshabilita la medición de distancia.
true_cm (salida, reg):
* Contiene la distancia medida en centímetros.

### Funcionamiento Interno: 
### Generación del Pulso de Trigger (10 µs):
Para que el sensor ultrasónico realice una medición, debemos enviar un pulso de al menos 10 µs en la señal trigger. Esto lo logramos con el siguiente código:
```verilog
if (counter < 500) begin  
    trigger <= 1;  
end else if (counter < 1000) begin  
    trigger <= 0;  
end 
```
Dado que utilizamos un reloj de 50 MHz, cada ciclo dura 20 ns, por lo que 500 ciclos equivalen a 10 µs

### Medición del Tiempo de Eco (echo):
Una vez que enviamos el pulso de trigger, el sensor pone en alto (1) la señal echo hasta que el sonido rebota y regresa. El tiempo que echo permanece en alto es proporcional a la distancia.
```verilog
if (cm_cont>=2900 && enable==1 && echo==1) begin  
    cm_cont<=0;  
    cm<=cm+1;  
    true_cm<=cm;  
end
```
Aquí:
* cm_cont es un contador que mide el tiempo en que echo está activo.
* Cada 2900 ciclos (~58 µs) equivalen a 1 cm de distancia.
* Si echo sigue en 1, incrementamos cm para reflejar la distancia en centímetros.

### Reinicio Automático Cada 100 ms:
Para evitar errores y permitir mediciones continuas, se busco que el sistema se reinicia automáticamente cada 100 ms dando las siguientes intruciones:
```verilog
if (counter >= 5000000) begin  
    counter <= 0;  
    cm_cont <=0;  
    cm<=0;  
end
```
Dado que trabajamos con un reloj de 50 MHz, esto nos dio una equivalencia de 5,000,000 ciclos.

## Matriz 8x8

Para el funcionamiento de la matriz se propone la implementación de dos módulos, uno que inicie el sistema estableciendo una comunicacion de la tarjeta FPGA con la matriz, y el otro módulo, que se encargue de definir las salidas, o las secuencias de luces que se encenderá para los diferentes casos que se establezcan, donde, para este proyecto del tamagotchi, dichos casos corresponderían a los estados en los que se pued a encontrar la mascota.

### Módulo de inicio del sistema de la matriz (spi_master.v)

#### Código:

```verilog
module spi_master(
   input clk,                // Reloj del sistema
   input reset,              // Señal de reset
   input [7:0] data_in,      // Datos de entrada para enviar
   input start,              // Inicio de la transmisión
   input [15:0] div_factor,   // Divisor del reloj para la velocidad SPI
   input  miso,          // Master In Slave Out
   output reg mosi,               // Master Out Slave In
   output reg sclk,          // Reloj SPI
   output reg cs,            // Chip Select
   output reg [7:0] data_out, // Datos recibidos
   output reg busy,          // Señal de ocupado
   output reg avail  // Señal de dato recibido
);

   reg [7:0] shift_reg;
   reg [3:0] bit_count;
   reg [15:0] clk_count;
	reg active;
   
	

	always @(posedge clk or posedge reset) begin
	  if (reset) begin
			sclk <= 0;
			cs <= 1;
			shift_reg <= 0;
			bit_count <= 0;
			clk_count <= 0;
			active <= 0;
			busy <= 0;
			avail <= 0;
	  end else if (start && !active) begin
			active <= 1;
			busy <= 1;
			avail <= 0;
			cs <= 0;
			shift_reg <= data_in;
			bit_count <= 7;
	  end else if (active) begin
			if (clk_count < div_factor - 1) begin
				 clk_count <= clk_count + 1;
			end else begin
				 clk_count <= 0;
				 sclk <= !sclk;

				 if (sclk) begin
						mosi <= shift_reg[7];
				 end else begin
					  if (bit_count > 0) begin
							bit_count <= bit_count - 1;
							shift_reg <= {shift_reg[6:0], miso};
					  end else begin
							data_out <= shift_reg;
							cs <= 1;
							active <= 0;
							busy <= 0;
							avail <= 1;
					  end
				 end
			end
	  end
	end
endmodule
```

Éste código nos permite inicializar la matriz 8x8 y establecer un sistema de comunicación con un elemento maestro, para éste caso tendriamos un "Master", que sería la tarjeta FPGA, y un "Slave", el cual sería la misma matriz.

Inicia definiendo entradas y salidas, los cuales serían los datos con los que se comunican el Master con el Slave, iniciando la transmisión de datos, habilitando o deshabilitando el encendido de la matriz, y almacenando los datos de salida.

### Módulo de máquina de estados (matriz_caras2.v)

Se propone una máquina de estados para definir las expresiones que tendría la cara de nuestra mascota, lo que nos permitiría dividir el código de una forma comprensible para diferenciar los casos que podrían ser almacenados en la memoria.

#### Código:

```verilog
module matriz_caras2 (
    input clk,                // Reloj del sistema
    input reset,              // Señal de reset
    input [3:0] state,        // Selector de patrones de LED
    output mosi,              // Master Out Slave In (Din)
    output sclk,              // Reloj SPI
    output cs                 // Chip Select
);

    reg [7:0] data_in;
    wire [7:0] data_out;

    reg start;
    wire busy;
    wire avail;

    wire [25:0] div_factor = 25000000;  // Factor de división fijo

    spi_master spi (
        .clk(clk),
        .reset(~reset),
        .data_in(data_in),
        .start(start),
        .div_factor(div_factor),
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .data_out(data_out),
        .busy(busy),
        .avail(avail)
    );

    // Memorias para diferentes patrones de LEDs
    reg [7:0] patron1 [7:0];  // Patrón 1
    reg [7:0] patron2 [7:0];  // Patrón 2
    reg [7:0] patron3 [7:0];  // Patrón 3
    reg [7:0] patron4 [7:0];  // Patrón 4

    reg [4:0] memory4CommandSend [17:0]; // Buffer de datos a enviar

    reg [5:0] mem_index = 0;
    reg sendByte;
    reg [10:0] state_send = 0;
    reg [1:0] prev_state = 2'b00;  // Para detectar cambios en el estado externo

    // Inicialización de patrones
    initial begin
        
        //Boot Matriz
        memory4CommandSend[0] = 8'h0C;  // Shutdown command
        memory4CommandSend[1] = 8'h01;  // Shutdown Normal Operation
        memory4CommandSend[2] = 8'h09;  // Decode-Mode
        memory4CommandSend[3] = 8'h00;  // Decode-Mode No decode for digits 7–0
	memory4CommandSend[4] = 8'h0A;  // Intensity
	memory4CommandSend[5] = 8'h0A;  // Intensity value
        memory4CommandSend[6] = 8'h0B;  // Scan Limit
        memory4CommandSend[7] = 8'h07;  // Scan Limit Value
	memory4CommandSend[8] = 8'h0F;  // Display Test 
        memory4CommandSend[9] = 8'h00;  // Display Test Value

        // Patrón 1 - Feliz
        patron1[0] = 8'b11111111;
        patron1[1] = 8'b10000001;
        patron1[2] = 8'b10100101;
        patron1[3] = 8'b10000001;
        patron1[4] = 8'b10100101;
        patron1[5] = 8'b10011001;
        patron1[6] = 8'b10000001;
        patron1[7] = 8'b11111111;

        // Patrón 2 - Triste
        patron2[0] = 8'b11111111;
        patron2[1] = 8'b10000001;
        patron2[2] = 8'b10100101;
        patron2[3] = 8'b10000001;
        patron2[4] = 8'b10011001;
        patron2[5] = 8'b10100101;
        patron2[6] = 8'b10000001;
        patron2[7] = 8'b11111111;

        // Patrón 3 - Enojado
        patron3[0] = 8'b11111111;
        patron3[1] = 8'b11000011;
        patron3[2] = 8'b10100101;
        patron3[3] = 8'b10100101;
        patron3[4] = 8'b10000001;
        patron3[5] = 8'b10011001;
        patron3[6] = 8'b10100101;
        patron3[7] = 8'b11111111;

        // Patrón 4 - Dormido
        patron4[0] = 8'b11111111;
        patron4[1] = 8'b10000001;
        patron4[2] = 8'b10000001;
        patron4[3] = 8'b11100111;
        patron4[4] = 8'b10000001;
        patron4[5] = 8'b10011001;
        patron4[6] = 8'b10011001;
        patron4[7] = 8'b11111111;
    end

    // Detectar cambios en `state` y actualizar `memory4CommandSend`
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= state; // Almacena el estado actual
            case (state)
                2'b00: begin
                    memory4CommandSend[10]  = patron1[0];
                    memory4CommandSend[11]  = patron1[1] ;
                    memory4CommandSend[12]  = patron1[2] ;
                    memory4CommandSend[13]  = patron1[3] ;
                    memory4CommandSend[14]  = patron1[4] ;
                    memory4CommandSend[15]  = patron1[5] ;
                    memory4CommandSend[16]  = patron1[6] ;
                    memory4CommandSend[17]  = patron1[7] ;

                end
                2'b01: begin
                    memory4CommandSend[10]  = patron2[0];
                    memory4CommandSend[11]  = patron2[1] ;
                    memory4CommandSend[12]  = patron2[2] ;
                    memory4CommandSend[13]  = patron2[3] ;
                    memory4CommandSend[14]  = patron2[4] ;
                    memory4CommandSend[15]  = patron2[5] ;
                    memory4CommandSend[16]  = patron2[6] ;
                    memory4CommandSend[17]  = patron2[7] ;

                end
                2'b10: begin
                    memory4CommandSend[10]  = patron3[0];
                    memory4CommandSend[11]  = patron3[1] ;
                    memory4CommandSend[12]  = patron3[2] ;
                    memory4CommandSend[13]  = patron3[3] ;
                    memory4CommandSend[14]  = patron3[4] ;
                    memory4CommandSend[15]  = patron3[5] ;
                    memory4CommandSend[16]  = patron3[6] ;
                    memory4CommandSend[17]  = patron3[7] ;

                end
            
                2'b11: begin
                    memory4CommandSend[10]  = patron4[0];
                    memory4CommandSend[11]  = patron4[1] ;
                    memory4CommandSend[12]  = patron4[2] ;
                    memory4CommandSend[13]  = patron4[3] ;
                    memory4CommandSend[14]  = patron4[4] ;
                    memory4CommandSend[15]  = patron4[5] ;
                    memory4CommandSend[16]  = patron4[6] ;
                    memory4CommandSend[17]  = patron4[7] ;

                end
                
            endcase
        
        end
    end

    // Máquina de estados para transmisión SPI
    always @(posedge clk) begin
        if (~reset) begin
            state_send <= 0;
            sendByte <= 0;
            mem_index <= 0;
        end else begin
            case (state_send)
                0: begin
                    data_in <= memory4CommandSend[mem_index]; 
                    sendByte <= 1; 
                    state_send <= 1;
                end
                1: begin
                    state_send <= 2;
                end
                2: begin
                    sendByte <= 0; 
                    if (avail) begin
                        state_send <= 0;    
                        mem_index <= mem_index + 1;
                        if (mem_index > 7) begin
                            mem_index <= 0;    
                            state_send <= 3;    
                        end
                    end
                end
                3: begin 
                    mem_index <= 0;            
                end 
            endcase
        end
    end

    // Envío de un byte por SPI
    always @(negedge clk) begin
        if (~reset) begin
            start <= 0;
        end else begin
            case (start)
                0: begin  // IDLE
                    if (!busy && sendByte) begin
                        start <= 1;
                    end
                end
                1: begin  // SEND
                    if (avail) begin
                        start <= 0;
                    end
                end
            endcase
        end
    end
endmodule
```

## Interacción entre Módulos:
Nuestro sistema está compuesto por varios módulos que trabajan juntos para simular el comportamiento de un Tamagotchi en la FPGA. A continuación, describimos cómo se relacionan entre sí y cómo logran el funcionamiento del sistema.

#### Diagrama de caja negra

![TamagotchiCN](https://github.com/user-attachments/assets/a02d9bc4-76aa-4778-aab9-fff992520077)

#### Diagrama de caja gris

![CajaGrisTamagotchi](https://github.com/user-attachments/assets/5a8425dc-d880-4a37-be2f-d654b34de4fd)

#### Descripción de la Interacción: 
* Módulo ultrasonic – Detección de Proximidad
Este módulo mide la distancia entre la FPGA y el usuario mediante un sensor ultrasónico.
Convierte la información en centímetros (true_cm) y la envía al módulo de control.
Además, la distancia medida se muestra en el display de 7 segmentos mediante el módulo dis.

* Lógica de Control – FSM del Tamagotchi
Basándonos en la distancia (true_cm), definimos el estado actual de la mascota.
La FSM decide si la mascota estará feliz, triste, enojada o dormida.
Según el estado actual, activa señales para la matriz 8x8, encargada de mostrar la expresión correspondiente.
Ejemplo de transición de estados:
* Si el usuario se acerca, el Tamagotchi pasa a feliz.
* Si el usuario se aleja, el Tamagotchi puede volverse triste o enojado.
* Si no hay movimiento por mucho tiempo, la FSM lo pone en modo dormido.

* Módulo dis – Control del Display de 7 Segmentos: se encarga de Recibir la señal true_cm desde ultrasonic y mostral la distancia en los displays de 7 segmentos usando multiplexación. Ademas de apoyarse en el módulo BCDtoSSeg para convertir valores numéricos en señales adecuadas para el display.
  
* Módulo matrix – Control de la Matriz 8x8: Es la encargada de Recibir la señal de estado de la FSM y Cambiar la animación de la mascota virtual dependiendo de su estado:
Feliz → Cara sonriente.
Triste → Cara con lágrimas.
Enojado → Expresión de molestia.
Dormido → Ojos cerrados.
La FSM envía un código binario que indica qué patrón debe mostrar la matriz.

### Flujo de Datos entre los Módulos:
* El sensor ultrasónico (ultrasonic) detecta la distancia del usuario y la envía como true_cm.
* El valor de true_cm se muestra en el display (dis) para referencia visual.
* La FSM procesa true_cm y determina el estado del Tamagotchi.
* El estado se envía a la matriz (matrix), que cambia la animación en la pantalla 8x8.

### Prototipo y Simulación:
Para validar el correcto funcionamiento de nuestro Tamagotchi en FPGA, realizamos pruebas en hardware y verificamos que cada módulo interactuara correctamente con los demás.

* ### Pruebas realizadas: 
   * Prueba del sensor ultrasónico: Se verificó que el sensor detecta correctamente la distancia y que los valores se actualizan en el display de 7 segmentos y Comprobamos que true_cm reflejara cambios en la proximidad del usuario.
   * Prueba de la FSM y cambio de estados: Se probó que la mascota cambiara entre los estados de feliz, triste, enojado y dormido, dependiendo de la distancia medida y validamos que no hubiera cambios abruptos o erráticos en los estados.
   * Prueba de la matriz 8x8: Se comprobó que los gráficos de la mascota se mostraran correctamente en la matriz de LEDs y verificamos que la FSM enviara la señal correcta para cada estado.
   * Integración final del sistema: Se realizó una prueba completa en la FPGA para verificar la interacción entre todos los módulos y ajustamos temporizaciones y actualizaciones de estado para mejorar la fluidez de los cambios.

### Video de funcionamiento del prototipo final:



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
