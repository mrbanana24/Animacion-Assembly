.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20
	//---------------- CODE HERE ------------------------------------

	movz w10, 0x00, lsl 16
	movk w10, 0x0000, lsl 00

	mov x3, 4                    // En x3 guardamos el tamanio de "un pixel"

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]	   // Set color of pixel N
	add x0,x0,4	   		// Next pixel
	sub x1,x1,1	 	 	 // decrement X counter
	cbnz x1,loop0	  	 // If not end row jump
	sub x2,x2,1	   		// Decrement Y counter
	cbnz x2,loop1	   // if not last row, jump
	mov x0, x20

///////////////////////////////////////////////////////////////////////////////////////
	movz w10, 0xFF, lsl 16		// Set color blanco
	movk w10, 0xFFFF, lsl 00

cantidad_cuadrados: 	// Cantidad de lineas que divide la cancha
	mov x15, 12
	ldr x5, =0x04E0

pintar_cuadrado:
	mov x8, 32       // Tamanio de los cuadrados en Y
	mov x11, 4	   // Tamanio de los cuadrados en X
	bl square
	sub x15, x15, 1
	mov x14, 40

loop_x5:
	add x5, x5, 2560
	sub x14, x14, 1
	cbnz x14, loop_x5
	cbnz x15, pintar_cuadrado

 pintar_marcador_1:
	movz w10, 0xFF, lsl 16		// Set color azul
	movk w10, 0xFFFF, lsl 00
	ldr x5, =0x6680
	mov x8, 45
	mov x11, 5
	bl square
	ldr x5, =0x6608
	mov x8, 5
	mov x11, 30
	bl square


pintar_marcador_2:
	movz w10, 0xFF, lsl 16		// Set color azul
	movk w10, 0xFFFF, lsl 00
	ldr x5, =0x6B80
	mov x8, 45
	mov x11, 5
	bl square
	ldr x5,=0x6BD0
	mov x8, 45
	mov x11, 5
	bl square

///////////////////////////      ANIMACION   /////////////////////////////////////////

set_variables_pong:
	ldr x5, =0x7D064	// Guardo la direccion del pong naranja
	ldr x6, =0x7D99C  	// Guardo la direccion del pong AZUL manito
	ldr x17, =0x96088 	// Guardo la direccion de la pelota
	mov x13, 100		// Cantidad de pixeles que voy a bajar
	mov x16, 100    	// Cantidad de pixeles que voy a bajar AZUUUULLL
	mov x18, 700       // Cantidad de veces que me muevo a derecha
	mov x0, x20			// Guardo la direccion base del framebuffer

decidir_direccion_pong_1:
	sub x13, x13, 1			// Resto cantidad de pixeles que me quedan por bajar
	cmp x13, 0				// Comparo x13 con 0
	bgt loop_down_pong_1	// Si es mayor a cero voy para arriba
	cmp x13, -200			// comparo para saber si baje 200 pixeles
	bgt loop_up_pong_1		// Si x13 es mayor subo 100 pixeles
	cmp x13, -300			// comparo para saber si baje 200 pixeles
	bgt loop_down_pong_1
	b set_variables_pong

decidir_direccion_pong_2:
	sub x16, x16, 1			// Resto cantidad de pixeles que me quedan por bajar
	cmp x16, 0				// Comparo x13 con 0
	bgt loop_up_pong_2	// Si es mayor a cero voy para arriba
	cmp x16, -200			// comparo para saber si baje 200 pixeles
	bgt loop_down_pong_2		// Si x13 es mayor subo 100 pixeles
	cmp x16, -300			// comparo para saber si baje 200 pixeles
	bgt loop_up_pong_2
	b set_variables_pong

decidir_direccion_pelota:
	sub x18, x18, 1			// Resto cantidad de pixeles que me quedan por bajar
	
	// Entre 600 y 700
	cmp x18, 600				// Comparo x13 con 0
	bgt loop_right_pelota		// Si es mayor a cero voy para arriba

	// Entre 550 y 600
	cmp x18, 550				// Comparo x13 con 0
	bgt loop_UP_pelota		// Si es mayor a cero voy para arriba

	// Entre 300 y 550
	cmp x18, 300				// Comparo x13 con 0
	bgt loop_right_pelota		// Si es mayor a cero voy para arriba

	cmp x18, -200			// comparo para saber si baje 200 pixeles
	bgt loop_left_pelota		// Si x13 es mayor subo 100 pixeles
	cmp x18, -300			// comparo para saber si baje 200 pixeles
	bgt loop_right_pelota
	b set_variables_pong


loop_down_pong_1:
	add x5, x5, 2560		// Bajo el pong
	b animacion_pong_1

loop_up_pong_1:				// Sube el pong
	sub x5, x5, 2560
	b animacion_pong_1

loop_down_pong_2:
	add x6, x6, 2560		// Bajo el pong
	b animacion_pong_2

loop_up_pong_2:				// Sube el pong
	sub x6, x6, 2560
	b animacion_pong_2

loop_right_pelota:
	add x17, x17, 8			// Se mueve la pelota a la derecha
	b animacion_pelota

loop_UP_pelota:
	sub x17, x17, 2560			// Se mueve la pelota a la derecha
	b animacion_pelota

loop_left_pelota:				// Se mueve la pelota a la
	sub x17, x17, 8
	b animacion_pelota

animacion_pong_1:
	movz w10, 0xFF, lsl 16		// Set color naranja
	movk w10, 0x6666, lsl 00
	mov x8, 60       			// Tamanio de los cuadrados en Y
	mov x11, 7	   				// Tamanio de los cuadrados en X
	bl square
	bl delay
	movz w10, 0x00, lsl 16		// Set color negro
	movk w10, 0x0000, lsl 00
	mov x8, 60       			// Tamanio de los cuadrados en Y
	mov x11, 7	   				// Tamanio de los cuadrados en X
	bl square
	b decidir_direccion_pong_2

animacion_pong_2:
	movz w10, 0x02, lsl 16		// Set color azullllllllllllllll
	movk w10, 0x4a86, lsl 00
	mov x8, 60       			// Tamanio de los cuadrados en Y
	mov x11, 7	   				// Tamanio de los cuadrados en X
	sub sp, sp, #8
	str x5, [sp]
	mov x5, x6
	bl square
	bl delay
	movz w10, 0x00, lsl 16		// Set color negro
	movk w10, 0x0000, lsl 00
	mov x8, 60       			// Tamanio de los cuadrados en Y
	mov x11, 7	   				// Tamanio de los cuadrados en X
	bl square
	ldr x5, [sp]
	add sp, sp, #8
	b decidir_direccion_pelota

animacion_pelota:
	movz w10, 0xFF, lsl 16		// Set color BLANCOWW
	movk w10, 0xFFFF, lsl 00
	mov x8, 8       			// Tamanio de los cuadrados en Y
	mov x11, 8	   				// Tamanio de los cuadrados en X
	sub sp, sp, #8
	str x5, [sp]
	mov x5, x17
	bl square
	bl delay
	movz w10, 0x00, lsl 16		// Set color negro
	movk w10, 0x0000, lsl 00
	mov x8, 8       			// Tamanio de los cuadrados en Y
	mov x11, 8	   				// Tamanio de los cuadrados en X
	bl square
	ldr x5, [sp]
	add sp, sp, #8
	b decidir_direccion_pong_1


//////////////////////////////////  FUNCIONES  //////////////////////////////////

square:
	mov x4, x5
	add x4, x4, x0				//Guardo la dirrecion en el framebuffer
	mov x7, x11	        		// Reseteo el X
square_2:
	stur w10, [x4]		 	 // Set el color en el pixel
	add x4, x4, 4			 // Paso al siguiente pixel
	sub x7, x7, 1			 // Resto cantidad de pixeles que me quedan por pintar
	cbnz x7, square_2		// "if(x7 != 0) voy a square_2 para seguir pintando"
	add x0, x0, 2560	  	// Paso al pixel de abajo
	sub x8, x8, 1				// Resto cantidad de pixeles que me queadn por pintar en Y
	cbnz x8, square			// "if(x9 != 0) voy a square para seguir pintando"
	mov x0, x20
	br x30

delay:
	movz x14,0x0011, lsl 16
	movk x14,0xFFFF, lsl 00

loop_delay:
	sub x14,x14,1
	cbnz x14,loop_delay
	br x30

	//--------------------------------------------------------------
	// Infinite Loop
InfLoop:
	b InfLoop
