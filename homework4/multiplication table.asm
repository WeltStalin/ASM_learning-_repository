.model small
.stack 100h
.data
    space   db ' $'        ; 算式之间的空格
    msg     db 'x$'        ; 乘号
    equals  db '=$'        ; 等号
    newline db 0Dh,0Ah,'$' ; 换行符（0Dh=回车，0Ah=换行）
    ten     db 10          ; 用于十进制除法
    num     db 0,0,'$'     ; 存储待显示数字的十位和个位

.code
START:
    ; 初始化数据段
    mov ax, @data
    mov ds, ax
    
    mov cl, 9              ; cl作为外层循环计数器，从9开始倒序
outer_loop:
    mov ch, 1              ; ch作为内层循环计数器，从1开始
inner_loop:
    ; 显示第一个数字（被乘数）
    mov al, cl
    call print_number
    
    ; 显示乘号
    lea dx, msg
    mov ah, 09h
    int 21h
    
    ; 显示第二个数字（乘数）
    mov al, ch
    call print_number
    
    ; 显示等号
    lea dx, equals
    mov ah, 09h
    int 21h
    
    ; 计算并显示乘法结果
    mov al, cl             ; 被乘数放入al
    mul ch                 ; al = al * ch，结果在al中
    call print_number
    
    ; 显示空格（算式之间的分隔符）
    lea dx, space
    mov ah, 09h
    int 21h
    
    ; 内层循环控制
    inc ch                 ; 乘数加1
    cmp ch, cl            ; 比较是否达到当前的被乘数（去重）
    jbe inner_loop        ; 如果小于等于当前被乘数则继续循环
    
    ; 换行处理
    lea dx, newline
    mov ah, 09h
    int 21h
    
    ; 外层循环控制
    dec cl                 ; 被乘数减1
    cmp cl, 1             ; 比较是否达到1
    jae outer_loop        ; 如果大于等于1则继续循环

    ; 程序结束
    mov ax, 4c00h
    int 21h

; 打印数字的子程序
; 输入：AL = 要打印的数字
; 功能：将数字转换为ASCII码并打印
print_number proc
    push dx                ; 保存寄存器
    push cx
    
    xor ah, ah            ; 清空ah，为除法准备
    div [ten]             ; 除以10，商在al中，余数在ah中
    mov [num], ah         ; 保存余数（个位）
    mov [num+1], al       ; 保存商（十位）
    
    ; 转换为ASCII码（加上'0'的ASCII码值48）
    add [num], '0'
    add [num+1], '0'
    
    ; 处理十位数字
    cmp byte ptr [num+1], '0'  ; 检查十位是否为0
    je skip_tens               ; 如果是0则跳过不显示
    mov dl, [num+1]           ; 显示十位数字
    mov ah, 02h
    int 21h
skip_tens:
    ; 显示个位数字
    mov dl, [num]
    mov ah, 02h
    int 21h
    
    pop cx                    ; 恢复寄存器
    pop dx
    ret
print_number endp

END START

