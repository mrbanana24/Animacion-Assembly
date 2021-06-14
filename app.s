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
	add x0,x0,4	   // Next pixel
	sub x1,x1,1	   // decrement X counter
	cbnz x1,loop0	   // If not end row jump
	sub x2,x2,1	   // Decrement Y counter
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


veces_que_baja_pong_1:
	mov x13, 10
 pintar_pong_1:
	movz w10, 0xFF, lsl 16		// Set color naranja
	movk w10, 0x6666, lsl 00
	ldr x5, =0x7D064
	mov x8, 60     // Tamanio de los cuadrados en Y
	mov x11, 7     // Tamanio de los cuadrados en X
	bl square
	//Empieza la animacion
	movz w10, 0x00, lsl 16		// Set color naranja
	movk w10, 0x0000, lsl 00
	ldr x5, =0x7D064
animacion_pong_1:
	add x0, x0, 2560
	add x5,x5,x0
	mov x8, 60     // Tamanio de los cuadrados en Y
	mov x11, 7     // Tamanio de los cuadrados en X
	bl square
	sub x13,x13,1
	cbnz x13, animacion_pong_1


pintar_pong_2:
	movz w10, 0x02, lsl 16		// Set color azul
	movk w10, 0x4a86, lsl 00
	ldr x5, =0x7D99C
	mov x8, 60       // Tamanio de los cuadrados en Y
	mov x11, 7       // Tamanio de los cuadrados en X
	bl square

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
	b InfLoop

/* pintar_pelotita:
	mov x11, 4       // Tamanio de los cuadrados en X
	mov x8, 4        // Tamanio de los cuadrados en Y
	bl square
	b InfLoop */

////////////////////////////////// Animaciones //////////////////////////////////



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
    movz x3,0x8888, lsl 16
    movk x3,0xFFFF, lsl 00

loop_delay:
    sub x3,x3,1
    cbnz x3,loop_delay
    BR x30

	//---------------------------------------------------------------
	// Infinite Loop
InfLoop:
	b InfLoop


