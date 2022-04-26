/* --------------------------------------------------------------------------------------
* #      #    #######    ########   #######   #          #######   ##      #    #########
* #     #        #       #          #         #             #      # #     #    #
* #    #         #       #          #         #             #      #  #    #    #
* ####           #       #####      #######   #             #      #   #   #    #    ####
* #    #         #       #                #   #             #      #    #  #    #       #
* #     #        #       #                #   #             #      #     # #    #       #
* #      #    ########   ########   #######   ########   #######   #      ##    #########
* 
* calc.s
* Simulacion de una calculadora que hace:
*   - Suma
*   - Resta
*   - Multiplicacion
*   - Division
*   - Potencia
*   - Raiz
 -------------------------------------------------------------------------------------- */

/* --------------------------------------- TEXT --------------------------------------- */
.text
.align 2
.global main
.type main, %function

/* -- Main --*/
main:
    stmfd sp!, {lr}
    /*impresion de menu y pide comando*/

/* -- Menu --*/
Menu:
    @@ impresion de menu
    ldr r0,=menu
    bl puts
    ldr r0,=ingreso
    bl puts

    @@ ingreso de opcion
    ldr r0,=opcion
    ldr r1,=comando
    bl scanf

/*compara comandos*/
comp:
    ldr r4,=comando
    ldrb r4,[r4]

    /*saltos dependiendo de caracter*/
    @@ identifica la opcion y hace un salto a la subrutina que corresponde
    @@ suma
    cmp r4, #'+'
    beq suma

    @@ resta
    cmpne r4, #'-'
    beq resta

    @@ multiplicacion
    cmpne r4, #'*'
    beq mul

    @@ division
    cmpne r4, #'/'
    beq div

    @@ Potencia
    cmpne r4, #'^'
    beq pot

    @@ Raiz
    cmpne r4, #'s'
    beq raiz

    @@ igual
    cmpne r4, #'='
    beq Res

    @@ salir
    cmpne r4, #'q'
    beq Salir

    @@ error incorrecto
    bne ErrorCar

/*-- Suma --*/
suma:
    @ingreso op2
    ldr r0,=ingreso_op
    bl puts
    ldr r0, =entrada
    ldr r1,=op2
    bl scanf

    @validacion
    cmp r0,#0
    beq Error

    @calculo
    ldr r6, =op1
    ldr r8,[r6]
    ldr r7,=op2
    ldr r7,[r7]
    add r8,r7

    @guarda valor
    str r8,[r6]
    ldr r0,=res
    ldr r1,=op1
    ldr r1,[r1]
    bl printf

    @regreso al menu
    b Menu

/*-- Resta --*/
resta:
    @ingreso op2
    ldr r0,=ingreso_op
    bl puts
    ldr r0, =entrada
    ldr r1,=op2
    bl scanf

    @validacion
    cmp r0,#0
    beq Error

    @calculo
    ldr r6, =op1
    ldr r8,[r6]
    ldr r7,=op2
    ldr r7,[r7]
    sub r8,r7

    @guarda y regresa
    str r8,[r6]
    ldr r0,=res
    ldr r1,=op1
    ldr r1,[r1]
    bl printf

    @regreso al menu
    b Menu

/*-- Multiplicacion --*/
mul:
    @ingreso
    ldr r0,=ingreso_op
    bl puts
    ldr r0, =entrada
    ldr r1,=op2
    bl scanf

    @validacion
    cmp r0,#0
    beq Error

    @calculo
    ldr r6, =op1
    ldr r8,[r6]
    ldr r7,=op2
    ldr r7,[r7]
    mul r8,r7

    @guarda y regresa
    str r8,[r6]
    ldr r0,=res
    ldr r1,=op1
    ldr r1,[r1]
    bl printf

    @regreso al menu
    b Menu

/*-- Division --*/
div:
    @ingreso op2
    ldr r0,=ingreso_op
    bl puts
    ldr r0, =entrada
    ldr r1,=op2
    bl scanf

    @validacion
    cmp r0,#0
    beq Error

    @carga valores
    ldr r6, =op1
    ldr r8,[r6]
    ldr r7,=op2
    ldr r7,[r7]

    @ciclo de division
    mov r10,#0 /*contador*/

/*-- Ciclo para hacer division --*/
ciclo:
    @calculo
    add r10,#1
    sub r8,r7
    cmp r8,#0
    bne ciclo
    mov r8,r10

    @guarda valor
    str r8,[r6]
    ldr r0,=res
    ldr r1,=op1
    ldr r1,[r1]
    bl printf

    @regreso al menu
    b Menu
/*-- Potencia --*/
pot:
    @ingreso op2
    ldr r0,=ingreso_op
    bl puts
    ldr r0, =entrada
    ldr r1,=op2
    bl scanf

    @validacion
    cmn r0,#0
    beq Error

    @calculo
    ldr r6, =op1
    ldr r8,[r6]
    ldr r7,=op2
    ldr r7,[r7]

    @ciclo de potencia
    mov r10,#1 /*contador*/

/*-- Ciclo para hacer potencia --*/
ciclo_pot:
    @calculo
    mul r10,r8
    sub r7,#1
    cmp r7,#0
    bne ciclo_pot
    mov r8,r10

    @guarda valor
    str r8,[r6]
    ldr r0,=res
    ldr r1,=op1
    ldr r1,[r1]
    bl printf

    @regreso al menu
    b Menu

raiz:
    @calculo
    ldr r6, =op1
    ldr r8,[r6]

    @ciclo de raiz
    mov r10,#0 /*contador*/

ciclo_raiz:
    @calculo
    add r10,#1
    mul r11,r10,r10
    cmp r11,r8
    blt ciclo_raiz

    @guarda valor
    str r8,[r6]
    ldr r0,=res
    mov r1,r10
    bl printf

    @regreso al menu
    b Menu

/*-- Ver el resultado --*/
Res:
    /*carga, muestra y regresa*/
    ldr r0,=res
    ldr r1,=op1
    ldr r1,[r1]
    bl printf
    b Menu

/*-- Salto para error de num --*/
Error:
    ldr r0,=error
    bl puts
    bl getchar
    b Salir

/*-- Salto para error de comando --*/
ErrorCar:
    ldr r0,=error
    bl puts
    bl getchar
    b Menu

/*-- Salir --*/
Salir:
    ldr r0,=adios
    bl puts
    mov r0, #0
    mov r3, #0
    ldmfd sp!, {lr}
    bx lr

/* --------------------------------------- DATA --------------------------------------- */
.data
.align 2

/*-- Variables --*/
op1: .word 0
op2: .word 0
comando: .byte 0

/*-- Mensajes y solicitudes --*/
error: .asciz "Ingreso incorrecto"
ingreso: .asciz "Ingrese un comando: "
ingreso_op: .asciz "Ingrese un valor: "
menu: .asciz "Calculadora\n+. suma\n-. resta\n*. mul\n/. div\n^. pot\ns. raiz\n=. restulado\nq. salir"
entrada: .asciz " %d"
opcion: .asciz " %c"
res: .asciz "La respuesta es: %d\n"
adios: .asciz "Hasta pronto"
