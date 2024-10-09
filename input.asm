.model small
.data
    prompt db 'Please enter a number (1-100): $'
    invalidMsg db 'Invalid input. Please enter a number between 1 and 100.$'
    buffer db 3 dup (?) ; 用于存储输入的数字字符串

.code
    START:
        MOV AX,@DATA
        MOV DS,AX

        ; 显示输入提示信息
        MOV DX, offset prompt
        MOV AH, 09h
        INT 21h
    
        ; 读取用户输入的数字
        LEA DX, buffer
        MOV AH, 0Ah
        INT 21h

    convert:
        mov dl, [si]            ; 读取当前字符
        cmp dl, 13              ; 检查是否为回车
        je done
        sub dl, '0'             ; 将字符转换为数字
        mul cx                  ; ax = ax * 10
        add ax, dx              ; ax = ax + dl
        inc si                  ; 移动到下一个字符
        jmp convert

    done:
        ; 检查数字是否在1到100之间
        cmp ax, 1
        jb  invalid
        cmp ax, 100
        ;ja  invalid

        ; 打印数字
        mov dx, ax              ; 将数字移动到dx，准备打印


        ;退出
        MOV AX,4C00H
        INT 21h

    invalid:
        ; 打印无效输入消息
        mov dx, offset invalidMsg
        mov ah, 09h
        int 21h
        ;jmp START               ; 重新开始

END    START

