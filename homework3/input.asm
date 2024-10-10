.model small
.data
    Msg0 db "Please input a number(1-100): $"
    Msg1 db "Your input is: $"
    Msg2 db "The sum is: $"

    input db 10,0
    buf1 db 4 DUP (0),'$'
    buf2 db 4 DUP (0),'$'

    sum  DW 0
    ime db 10
    number db 0
.code
    START:

    MOV  AX, @data
    MOV  DS, AX

    MOV  AH, 09H
    MOV  DX, OFFSET Msg0
    INT  21H
    ; 输入字符
    MOV  DX, OFFSET input 
    MOV  AH, 0AH 
    INT  21H

    MOV  CX, 0
    MOV  CL, [input + 1]
    MOV  SI, OFFSET input + 2


    ; 将字符转换为数字
Str_To_Int:
    MOV  AL,[number]
    MUL  ime

    MOV  BL, [SI]
    SUB  BL, '0'
    ADD  AL, BL
    INC  SI
    MOV  [number],AL
    LOOP Str_To_Int
    ;打印输入反馈
    MOV AH,02h
    MOV DL,0Ah
    INT 21h
    MOV  AH, 09H
    MOV  DX, OFFSET Msg1
    INT  21H

    MOV CX,10
    MOV AH,00
    MOV AL, [number]           ; 将SUM的值移动到AX，因为DIV会修改AX
    MOV SI,4
    MOV [buf1+0],0
    MOV [buf1+1],0
    MOV [buf1+2],0
    MOV [buf1+3],0
convert_to_decimal1:
    MOV DX, 0               ; 清除DX，为DIV做准备
    DIV CX                  ; AX / 10, 商在AX, 余数在DX
    ADD DL, '0'             ; 将余数转换为ASCII字符
    
    DEC SI                  ; 移动SI指针
    MOV [buf1 + SI], DL

    CMP AX, 0
    JNE convert_to_decimal1  ; 如果AX不为0，继续转换


    ; 打印计算和字符串
    MOV DX, offset buf1   ; 将缓冲区的地址加载到DX
    MOV AH, 09h             
    INT 21h 

    ;求和
    MOV  AX,1
    MOV  [sum],0
    MOV  CL,[number]
L1:
    ADD  [sum],AX           ;AX的值加到SUM上
    INC  AX
    LOOP L1

    ;打印计算和
    MOV AH,02h
    MOV DL,0Ah
    INT 21h
    MOV  AH, 09H
    MOV  DX, OFFSET Msg2
    INT  21H

    MOV CX,10
    MOV AX, [sum]           ; 将SUM的值移动到AX，因为DIV会修改AX
    MOV SI,4
    MOV [buf2+0],0
    MOV [buf2+1],0
    MOV [buf2+2],0
    MOV [buf2+3],0
convert_to_decimal2:
    XOR DX, DX              ; 清除DX，为DIV做准备
    DIV CX                  ; AX / 10, 商在AX, 余数在DX
    ADD DL, '0'             ; 将余数转换为ASCII字符
    
    DEC SI                  ; 移动SI指针
    MOV [buf2 + SI], DL

    CMP AX, 0
    JNE convert_to_decimal2  ; 如果AX不为0，继续转换

    ; 打印计算和字符串
    MOV DX, offset buf2   ; 将缓冲区的地址加载到DX
    MOV AH, 09h             
    INT 21h 


    
    MOV  AX,4C00H
    INT  21H
END    START

