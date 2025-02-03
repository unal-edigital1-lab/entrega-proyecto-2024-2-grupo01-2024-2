[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=17798957&assignment_repo_type=AssignmentRepo)
# Entrega 1 del proyecto WP01

## Introducción
Como proyecto para la clase de Electrónica Digital I se decidió hacer un tamagotchi por medio de la tarjeta FPGA, el cual con funciones y variables definidas tendría el potencial no solo para aplicar temas vistos en clase, sino tambien aprender del uso de más elementos que se usen en proyectos de electrónica; con la finalidad de obtener un elemento intuitivo para cualquier persona que intente manipularlo, mientras que para los que realizamos el proyecto sea una profundización práctica de la temática de clase.

## Objetivos
### General
Realizar un sistema de entretenimiento inspirado en los "tamagotchi", el cual consiste en el cuidado y manutención de una mascota virtual.

### Específicos
- **a)** Aplicar conocimientos adquiridos de electrónica digital para la correcta implementación de las funciones que se asignen en el sistema.
- **b)** Definir métodos para facilitar el uso del sistema con una interfaz intuitiva para el usuario.
- **c)** Complementar las funciones del sistema con elementos visuales para un uso más interactivo.

## Descripción del Sistema
Se implementaría un sistema de juego de simulación de cuidado de una mascota virtual, más conocido como "Tamagotchi", en el que se emularían diferentes estados de dicha mascota, y el usuario interactuaría con el sistema para mantener a su mascota en buen estado.

### Partes del sistema
#### Sensores
1. **Sensor Ultrasonido:** Detectaría proximidad y movimiento, el cual apoyaría el cambio de estados de la mascota dependiendo de si el usuario está manipulando el sistema, o esta en reposo.
2. **Sensor de Luz:** Proporcionaría una funcionalidad de ciclos diurnos y nocturnos, que influirían en la variacion de las necesidades de los estados y necesidades de la mascota, por ejemplo, para que cuando esté en un ambiente a oscuras, la mascota se duerma automáticamente y no surja la necesidad de comer.

#### Botones
1. **Reinicio:** Restauraría el sistema a sus valores por defecto.
2. **Botones de interacción:** Botones destinados para que el usuario ejecute determinadas acciones directas con la mascota, como dar de comer, y limpiar.

### Visualización de la mascota
#### Matriz de puntos 8x8
En ésta matriz se configuraria las imágenes de la mascota, las cuales cambiarían según el estado de la mascota para brindar una ayuda visual que indique qué necesidad tiene, para que el usuario sepa qué interacción hacer para suplir dicha necesidad, por lo que esta sería nuestra visualización principal.

#### Display de 7 segmentos
Proporcionaría un complemento a la visualización principal, donde se configuraría cada estado de la mascota, con un determinado nivel, o puntaje, donde tendría diferentes rangos que activarían las animaciones a la necesidad que requiera la mascota. 

### Estados de la mascota
#### Hambre
Generado a lo largo del día, con variaciones conforme pasa el tiempo. Dichas variaciones quedarían en pausa mientras la mascota duerme.
#### Sueño
Estado que se generaría luego de un tiempo largo con el sistema activo, el cual se solucionaría dejando el sistema en un ambiente de baja iluminación, dejando que la mascota duerma y recargue energías.
#### Durmiendo
Se daría solamente en un ambiente de baja iluminación, o en la noche, el cual dejaría el sistema en un estado de reposo, donde el único cambio que habría sería la recarga de energía de la mascota.
#### Energético
Generado al tener nivel o puntaje alto de energía, el cual se solucionaría jugando con la mascota.
#### Feliz
Indicaría que la mascota está a gusto y no requiere de ningun tipo de cuidado o atención en el momento.
#### Triste
Estado que se daría luego de cierto tiempo en que la mascota no reciba ninguna atención luego de requerir una necesitad como comida o dormir.

### Interacciones del usuario
Se definirían botones y acciones captadas por sensores que recibiría el sistema, e interpretaría para ejecutar funciones definidas en el sistema para que se dén interacciones entre la mascota y el usuario.

### Arquitectura del sistema

#### Diagrama de caja negra

![TamagotchiCN](https://github.com/user-attachments/assets/a02d9bc4-76aa-4778-aab9-fff992520077)
