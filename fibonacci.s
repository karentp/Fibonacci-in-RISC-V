.data 
length: .word    21       #Este es el numero de secuencias para llegar a 10946
titulo:     .string "Fibonacci("
parentesis:     .string ") = "

.text

main:                          
        lw    a1, length     # n = 21
        li    s0, 1            # comparar si n <= 1
        jal   ra, fibonacci    # llamar a la funcion fibonacci

        mv    a2, a1           # en a a2 se guarda el valor final 
        lw    a1, length       # a1 : length
        jal   ra, printResult  # imprimir el result

        j     finish           # llamar a la funcion finish

fibonacci:
        ble   a1, s0, return       # si n <= 1)
        addi  sp, sp, -12      # push al stack
        sw    ra, 8(sp)        # guarda la direccion de retorno 
        sw    a1, 4(sp)        # guardar el length
        addi  a1, a1, -1       # reducir length n-1
        jal   ra, fibonacci    # llamar funcion fibonacci con n-1
        sw    a1, 0(sp)        # guarda el valor retornado de fibonacci n-1
        lw    a1, 4(sp)        # cargar el valor del length
        addi  a1, a1, -2       # reducir length en n-2
        jal   ra, fibonacci    # llamar funcion fibonacci con n-2
        lw    t0, 0(sp)        # guarda el valor retornado de fibonacci n-1
        add   a1, a1, t0       # fib(n - 1) + fib(n - 2)
        lw    ra, 8(sp)        # cargar la direccion de retorno
        addi  sp, sp, 12       # pop al stack
        add   t3, a1, zero     # copiar el resultado de fibonacci a t3
        slli  t3, t3, 30       # shift a t3 para que solo quede el ultimo digito en el msb
        beq   t3, zero, storeEven # si el registro es 0 significa que el ultimo digito era 0 
                                  #y por lo tanto es numero par entonces salta a guardar el num par
        ret                    # return
storeEven:
        add   a0, a1, zero     #guarda el numero par en el registro x10000000 que es el registro a0
        ret                    # regresa
        

return:
        ret                    # regresa

printResult:                   #Funcion para imprimir el resultado
        mv    t0, a1
        mv    t1, a2
        la    a1, titulo
        li    a7, 4
        ecall                  # imprimir el string de titulo
        mv    a1, t0
        li    a7, 1
        ecall                  # imprimir el length de fibonacci
        la    a1, parentesis
        li    a7, 4
        ecall                  # imprimir string 2 de cierre de parentesis
        mv    a1, t1
        li    a7, 1
        ecall                  # imprimir el resultado
        ret

finish:
        li   a7, 10
        ecall                  # sale del programa