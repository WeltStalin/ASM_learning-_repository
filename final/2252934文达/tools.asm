; 16位DOS程序 - 控制台工具函数集
.model small
.stack 100h

; === 常量定义 ===
COLOR_BLACK     equ     0
COLOR_BLUE      equ     1
COLOR_GREEN     equ     2
COLOR_CYAN      equ     3
COLOR_RED       equ     4
COLOR_MAGENTA   equ     5
COLOR_BROWN     equ     6
COLOR_WHITE     equ     7

; === 数据段 ===
.data
    ; === 保存原始属性 ===
    old_attr    db      ?       ; 保存原始显示属性
    
    ; === 测试用消息 ===
    msg_title   db      '=== Console Tools Test Program ===', 0Dh, 0Ah, '$'
    
    ; 颜色测试消息
    msg_color1  db      '1. Color Test Begin:', 0Dh, 0Ah, '$'
    msg_color2  db      '   Blue background, Yellow text (A)', 0Dh, 0Ah, '$'
    msg_color3  db      '   Green background, Red text (B)', 0Dh, 0Ah, '$'
    msg_color4  db      'Press any key to continue...', 0Dh, 0Ah, '$'
    
    ; 光标测试消息
    msg_cursor1 db      '2. Cursor Position Test Begin:', 0Dh, 0Ah, '$'
    msg_cursor2 db      '   Moving cursor to position (10,30)', 0Dh, 0Ah, '$'
    msg_cursor3 db      '   Cursor moved. Check the position.', 0Dh, 0Ah, '$'
    
    ; 清屏测试消息
    msg_clear1  db      '3. Clear Screen Test Begin:', 0Dh, 0Ah, '$'
    msg_clear2  db      '   Will clear screen with blue background', 0Dh, 0Ah, '$'
    msg_clear3  db      '   Screen cleared. Check the color.', 0Dh, 0Ah, '$'
    
    ; 结束信息
    msg_end     db      'All tests completed. Press any key to exit...', 0Dh, 0Ah, '$'

; === 代码段 ===
.code

; === 函数声明 ===
public set_color, goto_xy, print_char, clear_screen  ; 导出函数供其他文件使用

; ====================================
; 函数名：set_color
; 功能：设置显示颜色
; 参数：(类似C函数: void set_color(int bg_color, int fg_color))
;       栈传递参数：
;       [bp+4] = 前景色 (0-15)
;       [bp+6] = 背景色 (0-15)
; 返回：无
; ====================================
set_color proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    cx
    
    ; 计算颜色属性：背景色*16 + 前景色
    mov     al, byte ptr [bp+6]  ; 背景色
    mov     cl, 4
    shl     al, cl              ; 左移4位
    add     al, byte ptr [bp+4]  ; 加上前景色
    mov     bl, al              ; 颜色值放入bl
    
    ; 设置颜色
    mov     ah, 09h
    mov     cx, 1
    mov     al, ' '
    int     10h
    
    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret     4                   ; 清理栈上的两个参数
set_color endp

; ====================================
; 函数名：goto_xy
; 功能：设置光标位置
; 参数：(类似C函数: void goto_xy(int x, int y))
;       [bp+4] = x坐标 (0-79)
;       [bp+6] = y坐标 (0-24)
; 返回：无
; ====================================
goto_xy proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    dx
    
    mov     dl, byte ptr [bp+4]  ; x坐标
    mov     dh, byte ptr [bp+6]  ; y坐标
    mov     ah, 02h
    mov     bh, 0
    int     10h
    
    pop     dx
    pop     bx
    pop     ax
    pop     bp
    ret     4                   ; 清理栈上的两个参数
goto_xy endp

; ====================================
; 函数名：print_char
; 功能：在指定位置打印彩色字符
; 参数：(类似C函数: void print_char(char ch, int x, int y, int color))
;       [bp+4] = 字符
;       [bp+6] = x坐标
;       [bp+8] = y坐标
;       [bp+10] = 颜色属性
; 返回：无
; ====================================
print_char proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    cx
    push    dx
    
    ; 设置光标位置
    push    word ptr [bp+8]     ; y
    push    word ptr [bp+6]     ; x
    call    goto_xy
    
    ; 显示字符
    mov     al, byte ptr [bp+4] ; 字符
    mov     bl, byte ptr [bp+10] ; 颜色
    mov     ah, 09h
    mov     cx, 1
    int     10h
    
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret     8                   ; 清理栈上的四个参数
print_char endp

; ====================================
; 函数名：clear_screen
; 功能：清除屏幕
; 参数：(类似C函数: void clear_screen(int color))
;       [bp+4] = 颜色属性
; 返回：无
; ====================================
clear_screen proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    cx
    push    dx
    
    mov     ax, 0600h
    mov     bh, byte ptr [bp+4] ; 颜色属性
    mov     cx, 0000h
    mov     dx, 184Fh
    int     10h
    
    ; 重置光标位置
    mov     ax, 0              ; y = 0
    push    ax
    mov     ax, 0              ; x = 0
    push    ax
    call    goto_xy
    
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret     2                   ; 清理栈上的一个参数
clear_screen endp

; ====================================
; 函数名：test_functions
; 功能：测试所有工具函数
; ====================================
test_functions proc
    ; 先清屏，确保干净的显示环境
    mov     ax, 07h            ; 黑底白字
    push    ax
    call    clear_screen
    
    ; 显示标题
    mov     ah, 09h
    lea     dx, msg_title
    int     21h
    
    ; === 测试1：颜色设置 ===
    ; 显示颜色测试开始信息
    mov     ah, 09h
    lea     dx, msg_color1
    int     21h
    
    ; 显示第一个颜色测试说明
    mov     ah, 09h
    lea     dx, msg_color2
    int     21h
    
    ; 在多个位置显示不同颜色的A
    ; 蓝底黄字的A
    mov     ax, 1Eh            ; 蓝底黄字
    push    ax                 ; 颜色
    mov     ax, 5              ; y坐标
    push    ax
    mov     ax, 10             ; x坐标
    push    ax
    mov     ax, 'A'            ; 字符
    push    ax
    call    print_char
    
    ; 红底白字的A
    mov     ax, 4Fh            ; 红底亮白字
    push    ax                 ; 颜色
    mov     ax, 5              ; y坐标
    push    ax
    mov     ax, 12             ; x坐标
    push    ax
    mov     ax, 'A'            ; 字符
    push    ax
    call    print_char
    
    ; 绿底青字的A
    mov     ax, 2Bh            ; 绿底亮青字
    push    ax                 ; 颜色
    mov     ax, 5              ; y坐标
    push    ax
    mov     ax, 14             ; x坐标
    push    ax
    mov     ax, 'A'            ; 字符
    push    ax
    call    print_char
    
    ; 显示第二个颜色测试说明
    mov     ah, 09h
    lea     dx, msg_color3
    int     21h
    
    ; 在指定位置显示特定颜色的字符
    mov     ax, 2Ch            ; 绿底红字
    push    ax                 ; 颜色
    mov     ax, 7              ; y坐标
    push    ax
    mov     ax, 20             ; x坐标
    push    ax
    mov     ax, 'B'            ; 字符
    push    ax
    call    print_char
    
    ; 等待按键提示
    mov     ax, 9              ; y坐标
    push    ax
    mov     ax, 0              ; x坐标
    push    ax
    call    goto_xy
    
    mov     ah, 09h
    lea     dx, msg_color4
    int     21h
    
    ; 等待按键
    mov     ah, 01h
    int     21h
    
    ; === 测试2：光标定位 ===
    mov     ax, 07h            ; 黑底白字
    push    ax
    call    clear_screen
    
    ; 显示光标测试开始信息
    mov     ah, 09h
    lea     dx, msg_cursor1
    int     21h
    
    ; 显示光标移动说明
    mov     ah, 09h
    lea     dx, msg_cursor2
    int     21h
    
    ; 移动光标到(30,10)
    mov     ax, 10             ; y坐标
    push    ax
    mov     ax, 30             ; x坐标
    push    ax
    call    goto_xy
    
    ; 显示光标移动完成信息
    mov     ah, 09h
    lea     dx, msg_cursor3
    int     21h
    
    ; 等待按键提示
    mov     ax, 12             ; y坐标
    push    ax
    mov     ax, 0              ; x坐标
    push    ax
    call    goto_xy
    
    mov     ah, 09h
    lea     dx, msg_color4
    int     21h
    
    ; 等待按键
    mov     ah, 01h
    int     21h
    
    ; === 测试3：清屏测试 ===
    ; 显示清屏测试开始信息
    mov     ah, 09h
    lea     dx, msg_clear1
    int     21h
    
    ; 显示清屏说明
    mov     ah, 09h
    lea     dx, msg_clear2
    int     21h
    
    ; 等待按键提示
    mov     ah, 09h
    lea     dx, msg_color4
    int     21h
    
    ; 等待按键
    mov     ah, 01h
    int     21h
    
    ; 使用蓝底清屏
    mov     ax, 1Fh            ; 蓝底亮白字
    push    ax
    call    clear_screen
    
    ; 显示清屏完成信息
    mov     ax, 0              ; y坐标
    push    ax
    mov     ax, 0              ; x坐标
    push    ax
    call    goto_xy
    
    mov     ah, 09h
    lea     dx, msg_clear3
    int     21h
    
    ; 显示结束信息
    mov     ax, 2              ; y坐标
    push    ax
    mov     ax, 0              ; x坐标
    push    ax
    call    goto_xy
    
    mov     ah, 09h
    lea     dx, msg_end
    int     21h
    
    ; 最后等待按键
    mov     ah, 01h
    int     21h
    ret
test_functions endp

; ====================================
; 程序入口
; ====================================
start:
    ; 初始化数据段
    mov     ax, @data
    mov     ds, ax
    
    ; 保存原始显示属性
    mov     ah, 08h         ; 读取字符及属性
    mov     bh, 0           ; 页号0
    int     10h
    mov     old_attr, ah    ; 保存属性
    
    ; 运行测试程序
    call    test_functions
    
    ; 恢复原始属性并清屏
    mov     bl, old_attr
    call    clear_screen
    
    ; 退出程序
    mov     ax, 4C00h
    int     21h

end start