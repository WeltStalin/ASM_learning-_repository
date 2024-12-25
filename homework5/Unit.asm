; 定义代码段
CODESEG SEGMENT
    ASSUME CS: CODESEG
    ; 声明公共过程
    PUBLIC DISPLAY_NUMBER, DISPLAY_TAB, DISPLAY_NEWLINE

; 显示数字的过程（支持双字显示）
DISPLAY_NUMBER PROC
    PUSH CX
    PUSH BX
    PUSH SI
    PUSH DI
    MOV DI, 10                  ; 设置显示宽度为10
    MOV SI, 0                   ; 数字位数计数器

NUMBER_CONVERSION_LOOP:
    MOV CX, 10                  ; 除数为10
    CALL DIVIDE_DOUBLEWORD      ; 调用双字除法过程
    PUSH CX                     ; 保存余数（个位数）
    INC SI                      ; 位数加1
    CMP AX, 0                   ; 检查商是否为0
    JNZ NUMBER_CONVERSION_LOOP  ; 不为0则继续除法
    CMP DX, 0                   ; 检查高16位是否为0
    JNZ NUMBER_CONVERSION_LOOP  ; 不为0则继续除法
    MOV BX, DI                  ; 计算需要补充的空格数
    SUB BX, SI

DISPLAY_DIGITS_LOOP:
    POP DX                      ; 取出数字
    ADD DL, '0'                 ; 转换为ASCII码
    MOV AH, 02H                 ; 显示字符功能
    INT 21H
    DEC SI                      ; 位数减1
    JNZ DISPLAY_DIGITS_LOOP     ; 继续显示下一位

DISPLAY_SPACES_LOOP:
    CMP BX, 0                   ; 检查是否需要显示空格
    JLE DISPLAY_DONE            ; 不需要则结束
    MOV DL, ' '                 ; 显示空格
    MOV AH, 02H
    INT 21H
    DEC BX                      ; 空格数减1
    JMP DISPLAY_SPACES_LOOP     ; 继续显示空格

DISPLAY_DONE:
    POP DI
    POP SI
    POP BX
    POP CX
    RET
DISPLAY_NUMBER ENDP

; 双字除法过程
DIVIDE_DOUBLEWORD PROC
    PUSH BX
    PUSH AX
    MOV AX, DX                  ; 处理高16位
    MOV DX, 0
    DIV CX                      ; DX:AX / CX
    POP BX
    PUSH AX                     ; 保存高16位的商
    MOV AX, BX                  ; 处理低16位
    DIV CX                      ; DX:AX / CX
    MOV CX, DX                  ; 保存最终余数
    POP DX                      ; 恢复高16位的商
    POP BX
    RET
DIVIDE_DOUBLEWORD ENDP

; 显示制表符（4个空格）
DISPLAY_TAB PROC FAR
    PUSH DX
    PUSH AX
    MOV DL, ' '                 ; 显示空格
    MOV AH, 02H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    POP AX
    POP DX
    RET
DISPLAY_TAB ENDP

; 显示换行
DISPLAY_NEWLINE PROC FAR
    PUSH DX
    PUSH AX
    MOV DL, 13                  ; 回车符
    MOV AH, 02H
    INT 21H
    MOV DL, 10                  ; 换行符
    MOV AH, 02H
    INT 21H
    POP AX
    POP DX
    RET
DISPLAY_NEWLINE ENDP

CODESEG ENDS

END