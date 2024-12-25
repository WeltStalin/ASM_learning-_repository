.model small
.data
    table  db 7,2,3,4,5,6,7,8,9             ;9*9表数据
           db 2,4,7,8,10,12,14,16,18
           db 3,6,9,12,15,18,21,24,27
           db 4,8,12,16,7,24,28,32,36
           db 5,10,15,20,25,30,35,40,45
           db 6,12,18,24,30,7,42,48,54
           db 7,14,21,28,35,42,49,56,63
           db 8,16,24,32,40,48,56,7,72
           db 9,18,27,36,45,54,63,72,81
    msg1   db 'error at: $'
    msg2   db ' x $'
    accomplish db 'accomplish!$'
    newline db 0Dh,0Ah,'$'
    space  db ' $'
    ten    db 10
    num    db 0,0,'$'     ; 存储待显示数字的十位和个位

.code
START:
    MOV AX,@DATA
    MOV DS,AX

    mov si, 0          ; 表格行索引
    mov bl, 1          ; 当前行数（1-9）
row_loop:
    mov bh, 1          ; 当前列数（1-9）
    mov di, si         ; di用于在当前行中移动
col_loop:
    ; 计算正确的乘积
    mov al, bl         ; 第一个数（行号）
    mul bh            ; 乘以第二个数（列号）
    ; 比较计算结果与表中的值
    cmp al, [table+di]
    je next_col       ; 如果相等，检查下一个

    ; 如果不相等，打印错误信息
    push bx           ; 保存bx
    
    ; 打印 "error at: "
    lea dx, msg1
    mov ah, 09h
    int 21h
    
    ; 打印行号
    mov al, bl
    call print_number
    
    ; 打印 " x "
    lea dx, msg2
    mov ah, 09h
    int 21h
    
    ; 打印列号
    mov al, bh
    call print_number
    
    ; 打印换行
    lea dx, newline
    mov ah, 09h
    int 21h
    
    pop bx            ; 恢复bx

next_col:
    inc di           ; 移动到下一列
    inc bh           ; 列号加1
    cmp bh, 9
    jbe col_loop     ; 如果列号<=9，继续检查

    add si, 9        ; 移动到下一行
    inc bl           ; 行号加1
    cmp bl, 9
    jbe row_loop     ; 如果行号<=9，继续检查

    ; 打印 "accomplish!"
    lea dx, accomplish
    mov ah, 09h
    int 21h
    
    ; 打印最后的换行
    lea dx, newline
    mov ah, 09h
    int 21h

    MOV AX,4C00H
    INT 21h

; 打印数字的子程序
; 输入：AL = 要打印的数字
print_number proc
    push dx
    push cx
    push ax
    
    xor ah, ah            ; 清空ah，为除法准备
    div [ten]             ; 除以10，商在al中，余数在ah中
    mov [num], ah         ; 保存余数（个位）
    mov [num+1], al       ; 保存商（十位）
    
    ; 转换为ASCII码
    add [num], '0'
    add [num+1], '0'
    
    ; 处理十位数字
    cmp byte ptr [num+1], '0'
    je skip_tens
    mov dl, [num+1]
    mov ah, 02h
    int 21h
skip_tens:
    ; 显示个位数字
    mov dl, [num]
    mov ah, 02h
    int 21h
    
    pop ax
    pop cx
    pop dx
    ret
print_number endp

END START
