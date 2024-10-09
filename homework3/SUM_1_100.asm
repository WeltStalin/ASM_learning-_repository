.model small
.data
    sum    DW 0
    buffer DB 4 DUP('0'), '$'  ; 定义足够大的缓冲区，假设最大值是5位数
.code
    START:
        MOV AX,@DATA
        MOV DS,AX

    ;放在寄存器中
        MOV  AX,1
        MOV  BX,0
        MOV  CX,100
    L0:
        ADD  BX,AX      ;AX的值加到BX上
        INC  AX
        LOOP L0

        ;打印结果
        MOV CX,10
        MOV AX, BX              ; 将BX的值移动到AX，因为DIV会修改AX
        MOV SI,4
    convert_to_decimal0:
        XOR DX, DX              ; 清除DX，为DIV做准备
        DIV CX                  ; AX / 10, 商在AX, 余数在DX
        ADD DL, '0'             ; 将余数转换为ASCII字符
        
        DEC SI                  ; 移动SI指针
        MOV [buffer + SI], DL

        CMP AX, 0
        JNE convert_to_decimal0  ; 如果AX不为0，继续转换

        ; 打印十进制字符串
        MOV DX, offset buffer   ; 将缓冲区的地址加载到DX
        MOV AH, 09h             
        INT 21h                 


        MOV AH,02h
        MOV DL,0Ah
        INT 21h
        MOV DL,0Ah
        INT 21h

        ;放在数据段中
        MOV  AX,1
        MOV  [sum],0
        MOV  CX,100
    L1:
        ADD  [sum],AX           ;AX的值加到SUM上
        INC  AX
        LOOP L1

        ;打印结果
        MOV CX,10
        MOV AX, [sum]           ; 将SUM的值移动到AX，因为DIV会修改AX
        MOV SI,4
    convert_to_decimal1:
        XOR DX, DX              ; 清除DX，为DIV做准备
        DIV CX                  ; AX / 10, 商在AX, 余数在DX
        ADD DL, '0'             ; 将余数转换为ASCII字符
        
        DEC SI                  ; 移动SI指针
        MOV [buffer + SI], DL

        CMP AX, 0
        JNE convert_to_decimal1  ; 如果AX不为0，继续转换

        ; 打印十进制字符串
        MOV DX, offset buffer   ; 将缓冲区的地址加载到DX
        MOV AH, 09h             
        INT 21h                 


        MOV AH,02h
        MOV DL,0Ah
        INT 21h
        MOV DL,0Ah
        INT 21h

        ;退出
        MOV AX,4C00H
        INT 21h
END    START

