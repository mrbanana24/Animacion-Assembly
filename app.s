.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32

.globl main
main:
	// X0 contiene la direccion base del framebuffer
 	mov x20, x0	// Save framebuffer base address to x20
	adr x21, bufferSecundario
	mov x22, x21

	//---------------- CODE HERE ------------------------------------

	movz w10, 0x00, lsl 16
	movk w10, 0x0000, lsl 00

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
	movz x5, 0x00, lsl 16
	movk x5, 0x04E0, lsl 00

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
	movz x5, 0x00, lsl 16
	movk x5, 0x6680, lsl 00
	mov x8, 45
	mov x11, 5
	bl square
	movz x5, 0x00
	movk x5, 0x6608
	mov x8, 5
	mov x11, 30
	bl square

pintar_marcador_2:
	movz w10, 0xFF, lsl 16		// Set color blanco
	movk w10, 0xFFFF, lsl 00
	movz x5, 0x00, lsl 16
	movk x5, 0x6B80, lsl 00
	mov x8, 45
	mov x11, 5
	bl square
	movz x5, 0x00, lsl 16
	movk x5, 0x6BD0, lsl 00
	mov x8, 45
	mov x11, 5
	bl square

///////////////////////////      ANIMACION   /////////////////////////////////////////

set_variables_pong:
	movz x5, 0x07, lsl 16	// Guardo la direccion del pong naranja
	movk x5, 0x0864, lsl 00
	movz x6, 0x09, lsl 16  	// Guardo la direccion del pong AZUL
	movk x6, 0x699C, lsl 00
	mov x13, 100		// Cantidad de pixeles que voy a bajar
	mov x16, 150    	// Cantidad de pixeles que voy a bajar AZUUUULLL
	mov x0, x20			// Guardo la direccion base del framebuffer

set_pelota:
	movz x17, 0x09, lsl 16 	// Guardo la direccion de la pelota
	movk x17, 0x6088, lsl 00
	mov x18, 73	    	//
	mov x19, 140      	//

decidir_direccion_pong_1:
	sub x13, x13, 1			// Resto cantidad de pixeles que me quedan por bajar
	cmp x13, 0				// Comparo x13 con 0
	bgt loop_down_pong_1	// Si es mayor a cero voy para arriba
	cmp x13, -100			// comparo para saber si baje 200 pixeles
	bgt loop_up_pong_1		// Si x13 es mayor subo 100 pixeles
	cmp x13, -150			// comparo para saber si baje 200 pixeles
	bgt loop_down_pong_1
	b set_variables_pong

decidir_direccion_pong_2:
	sub x16, x16, 1			// Resto cantidad de pixeles que me quedan por bajar
	cmp x16, 0				// Comparo x13 con 0
	bgt loop_up_pong_2		// Si es mayor a cero voy para arriba
	cmp x16, -100			// comparo para saber si baje 200 pixeles
	bgt loop_down_pong_2	// Si x13 es mayor subo 100 pixeles
	cmp x16, -200			// comparo para saber si baje 200 pixeles
	bgt loop_up_pong_2
	b set_variables_pong

decidir_mov_pelota:
	sub x18, x18, 1							// Resto cantidad de pixeles que me quedan por bajar
	cmp x18, 0
	bgt loop_up_rigth_diagonal_pelota
	sub x18, x18, 1
	cmp x18, -140
	bgt loop_down_left_diagonal_pelota

	b set_pelota

//Paletas
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

//Pelota
loop_up_rigth_diagonal_pelota:
	sub x17, x17, 2560
	add x17, x17, 32			// Se mueve la pelota a la derecha
	b animacion_pelota

loop_down_rigth_diagonal_pelota:
	add x17, x17, 2560
	add x17, x17, 32		// Se mueve la pelota a la derecha
	b animacion_pelota

loop_down_left_diagonal_pelota:
	add x17, x17, 2560
	sub x17, x17, 32		// Se mueve la pelota a la derecha
	b animacion_pelota

loop_up_left_diagonal_pelota:
	sub x17, x17, 2560
	sub x17, x17, 32			// Se mueve la pelota a la derecha
	b animacion_pelota


animacion_pong_1:
	movz w10, 0xFF, lsl 16		// Set color naranja
	movk w10, 0x6666, lsl 00
	mov x8, 60       			// Tamanio de los cuadrados en Y
	mov x11, 7	   				// Tamanio de los cuadrados en X
	bl square
	b decidir_mov_pelota

animacion_pong_2:
	movz w10, 0x02, lsl 16		// Set color azullllllllllllllll
	movk w10, 0x4a86, lsl 00
	mov x8, 60       			// Tamanio de los cuadrados en Y
	mov x11, 7	   				// Tamanio de los cuadrados en X
	sub sp, sp, #8
	stur x5, [sp]
	mov x5, x6
	bl square
	ldur x5, [sp]
	add sp, sp, #8
	/* b pintar_cuadrado  */
	b copy

animacion_pelota:
	movz w10, 0xFF, lsl 16		// Set color BLANCOWW
	movk w10, 0xFFFF, lsl 00
	mov x8, 8       			// Tamanio de los cuadrados en Y
	mov x11, 8	   				// Tamanio de los cuadrados en X
	sub sp, sp, #8
	stur x5, [sp]
	mov x5, x17
	bl square
	ldur x5, [sp]
	add sp, sp, #8
	b decidir_direccion_pong_2

//////////////////////////////////  FUNCIONES  //////////////////////////////////

square:
	mov x4, x5
	add x4, x4, x21				//Guardo la dirrecion en el framebuffer
	mov x7, x11	        		// Reseteo el X
square_2:
	stur w10, [x4]		 	 // Set el color en el pixel
	add x4, x4, 4			 // Paso al siguiente pixel
	sub x7, x7, 1			 // Resto cantidad de pixeles que me quedan por pintar
	cbnz x7, square_2		// "if(x7 != 0) voy a square_2 para seguir pintando"
	add x21, x21, 2560	  	// Paso al pixel de abajo
	sub x8, x8, 1				// Resto cantidad de pixeles que me queadn por pintar en Y
	cbnz x8, square			// "if(x9 != 0) voy a square para seguir pintando"
	mov x21, x22
	br x30


copy:
	bl delay
	movz x4, 0x25, lsl 16
	movk x4,0x8000, lsl 00
copy_buffer_2:
	ldur x3, [x21]
	stur x3, [x0]
	add x21, x21, 4
	add x0, x0, 4
	sub x4, x4, 1
	cbnz x4, copy_buffer_2
	mov x0, x20
	mov x21, x22

reset_buffer:
	movz x4, 0x25, lsl 16
	movk x4,0x8000, lsl 00
reset_buffer_2:
	movz x3, 0x00, lsl 16
	movk x3,0x0000, lsl 00
	stur x3, [x21]
	add x21, x21, 4
	sub x4, x4, 1
	cbnz x4, reset_buffer_2
	mov x21, x22
	b decidir_direccion_pong_1


delay:
	movz x14,0x002F, lsl 16
	movk x14,0xFFFF, lsl 00

loop_delay:
	sub x14,x14,1
	cbnz x14,loop_delay
	br x30

	//--------------------------------------------------------------
	// Infinite Loop
InfLoop:
	b InfLoop

.equ BYTES_FRAMEBUFFER, SCREEN_WIDTH * SCREEN_HEIGH * 8
	bufferSecundario: .skip BYTES_FRAMEBUFFER

