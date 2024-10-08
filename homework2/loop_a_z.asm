.model small
.data
    char DB "A"
    i0   DB 2
    i1   DB 13
    i2   DB 26
    count DB 0
.code
    START:
        MOV AX,@DATA
        MOV DS,AX

        MOV  AH,2
    ;LOOP实现
        MOV  CL,[i0]
    L0:
        MOV  [i0],CL
        MOV  CL,[i1]
    L1:  
        MOV  AL,[char]
        MOV  DL,AL
        INC  AL
        MOV  [char],AL
        INT  21H
        LOOP L1

        MOV DL,0Ah
        INT 21h
        MOV  CL,[i0]
        
        LOOP L0

        MOV DL,0Ah
        INT 21h
        MOV DL,0Ah
        INT 21h

    ;JUMP实现
        MOV [char],"A"
        MOV [i0],0
        MOV [i1],0
    print_letter:

        MOV AL,[char]
        MOV DL,AL
        INC AL
        INC [i1]
        MOV [char],AL
        INT 21H
        CMP [i1], 13-1          ; 检查是否已经输出了13个字母
        JLE print_letter        ; 如果是，跳转到newline标签，否则继续输出

        JMP newline

    newline:
        INC [i0]
        MOV [i1],0
        MOV DL,0Ah
        INT 21h

        CMP [i0], 2-1           ; 检查是否已经输出了2行
        JLE print_letter        ; 如果是，跳转到程序退出，否则继续输出

        JMP exit

    exit:
        MOV AX,4C00H
        INT 21h
END    START