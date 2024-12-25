; 16位DOS程序 - 控制台工具函数集
.model small
.stack 100h

; === 常量定义 ===
TOWER_CHAR    equ     '|'     ; 柱子字符
DISK_CHAR     equ     '='     ; 盘子字符
SPACE_CHAR    equ     ' '     ; 空格字符
BASE_CHAR     equ     '-'     ; 底座字符
MAX_DISKS     equ     9       ; 最大盘子数
TOWER_HEIGHT  equ     10      ; 塔的高度为10
BASE_LINE     equ     15      ; 底座所在行
LEFT_MARGIN   equ     5       ; 左边距
TOWER_SPACE   equ     4       ; 柱子之间的间距
BASE_SPACE    equ     25      ; 底座中心之间的距离 (21 + 4)
BASE_WIDTH    equ     21      ; 底座宽度

; 颜色常量（使用DOS颜色属性）
TOWER_COLOR   equ     0Eh     ; 浅黄色 (黑底浅黄色)
BASE_COLOR    equ     0Eh     ; 浅黄色 (黑底浅黄色)

; === 数据段 ===
.data
    ; === 游戏状态 ===
    disk_count   db      0       ; 盘子数量
    current_pos  db      3 dup(0); 三根柱子上的盘子位置
    tower_data   db      30 dup(0); 塔的数据(3塔*10层)
    
    ; 盘子颜色数组（9种不同的颜色）
    disk_colors  db      09h     ; 浅蓝色
                db      0Ah     ; 浅绿色
                db      0Bh     ; 浅青色
                db      0Ch     ; 浅红色
                db      0Dh     ; 浅紫色
                db      0Fh     ; 亮白色
                db      03h     ; 青色
                db      05h     ; 紫色
                db      07h     ; 白色
    
    ; === 提示信息 ===
    msg_input_n  db      'Enter number of disks (1-9): $'
    msg_echo     db      'Your input is: $'
    msg_continue db      'Press any key to exit...', 0Dh, 0Ah, '$'
    
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
; 函数���：goto_xy
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
    
    ; 显示题
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
    
    ; 红底亮白字的A
    mov     ax, 4Fh            ; 红底亮白字
    push    ax                 ; 颜色
    mov     ax, 5              ; y坐标
    push    ax
    mov     ax, 12             ; x坐标
    push    ax
    mov     ax, 'A'            ; 字符
    push    ax
    call    print_char
    
    ; 绿底亮青字的A
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
; 函数名：get_number
; 功能：获取用户输入的数字
; 入口参数：无
; 出口参数：AL = 输入的数字(1-9)
; ====================================
get_number proc
    push    bp              ; 保护现场
    mov     bp, sp
    push    bx
    push    dx
    
    ; 读取单个字符
    mov     ah, 01h        ; 带回显的键盘输入
    int     21h            ; 字符会自动显示
    
    ; 保存输入的字符
    mov     bl, al         ; 保存输入的ASCII码
    
    ; 输出换行
    mov     ah, 02h
    mov     dl, 0Dh
    int     21h
    mov     dl, 0Ah
    int     21h
    
    ; 显示提示
    mov     ah, 09h
    lea     dx, msg_echo
    int     21h
    
    ; 显示输入的字符
    mov     ah, 02h
    mov     dl, bl         ; 使用保存的ASCII码
    int     21h
    
    ; 再次换行
    mov     ah, 02h
    mov     dl, 0Dh
    int     21h
    mov     dl, 0Ah
    int     21h
    
    ; 转换ASCII到数值
    sub     bl, '0'        ; 转换为数值
    mov     al, bl         ; 返回数值
    
    pop     dx
    pop     bx
    pop     bp
    ret
get_number endp

; ====================================
; 函数名：IMGTower_Init
; 功能：初始化汉诺塔图形
; 参数：AL = 盘子数量(1-9)
; 返回：无
; ====================================
IMGTower_Init proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    cx
    push    dx
    push    si
    
    ; 保存盘子数量
    mov     disk_count, al
    
    ; 绘制三根柱子
    xor     al, al          ; AL = 0 (A柱)
    call    draw_tower
    mov     al, 1           ; AL = 1 (B柱)
    call    draw_tower
    mov     al, 2           ; AL = 2 (C柱)
    call    draw_tower
    
    ; 在A柱上绘制盘子
    xor     ch, ch          ; 清零CH
    mov     cl, disk_count  ; 读取盘子数量
    mov     si, cx          ; SI = 当前盘子大小（从大到小）
draw_disks_init:
    push    cx             ; 保存循环计数器
    mov     ax, si         ; AX = 当前盘子大小
    xor     bl, bl         ; BL = 0 (A柱)
    mov     cl, disk_count
    sub     cx, si         ; 位置 = 总数 - 当前大小（从下往上放）
    call    draw_disk
    pop     cx             ; 恢复循环计数器
    dec     si             ; 下一个更小的盘子
    loop    draw_disks_init
    
    ; 初始化柱子状态
    mov     al, disk_count
    mov     current_pos[0], al   ; A柱有n个盘子
    mov     current_pos[1], 0    ; B柱当前位置为0
    mov     current_pos[2], 0    ; C柱当前位置为0
    
    pop     si
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret
IMGTower_Init endp

; ====================================
; 函数名：IMGTower_Move
; 功能：移动汉诺塔盘子
; 参数：AL = 盘子大小, BL = 起始柱号, BH = 目标柱号
; 返回：无
; ====================================
IMGTower_Move proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    cx
    push    dx
    push    si
    push    di
    
    ; 保存参数
    mov     si, ax          ; SI = 盘子大小
    
    ; 获取起始柱的盘子位置
    xor     ah, ah          ; 清零AH
    mov     al, current_pos[bx]  ; 获取起始柱的当前位置
    dec     al              ; 减1得到要移动的盘子位置
    mov     cl, al          ; CL = 盘子位置
    
    ; 获取盘子颜色
    mov     ax, si          ; AX = 盘子大小
    dec     ax              ; 减1作为索引
    push    bx              ; 保存bx
    mov     bx, offset disk_colors
    add     bx, ax          ; 计算颜色数组偏移
    mov     al, [bx]        ; 获取颜色
    mov     di, ax          ; DI = 颜色（保存颜色值）
    pop     bx              ; 恢复bx
    
    ; 计算盘子宽度
    mov     ax, si          ; AX = 盘子大小
    shl     ax, 1           ; AX = 盘子大小 * 2
    dec     ax              ; 宽度 = 盘子大小 * 2 - 1
    mov     si, ax          ; SI = 盘子宽度
    
    ; 计算起始柱的X坐标
    push    bx              ; 保存柱号
    xor     bh, bh          ; 清零BH
    mov     al, BASE_SPACE  ; 柱子间距
    mul     bl              ; AX = 柱子编号 * 间距
    add     ax, LEFT_MARGIN ; 加上左边距
    add     ax, 10          ; 加上半个底座宽度
    mov     dx, ax          ; DX = 柱子中心X坐标
    
    ; 计算起始X坐标（考虑盘子宽度）
    mov     ax, si          ; AX = 盘子宽度
    shr     ax, 1           ; AX = 半宽
    sub     dx, ax          ; DX = 起始X坐标
    
    ; 向上移动循环
    mov     di, dx          ; DI = 起始X坐标
move_up:
    ; 在新位置绘制盘子
    push    cx              ; 保存当前位置
    
    ; 计算Y坐标
    mov     ax, BASE_LINE   ; 从底座行开始
    dec     ax              ; 减1到达底座上一行
    sub     ax, cx          ; 减去当前位置
    dec     ax              ; 向上移动一格
    push    ax              ; Y坐标
    
    ; 绘制盘子
    mov     cx, si          ; CX = 盘子宽度
    mov     dx, di          ; DX = 当前X坐标
draw_disk_at_new_pos:
    push    cx              ; 保存计数器
    
    ; 移动到当前位置
    push    ax              ; Y坐标已在栈上
    push    dx              ; X坐标
    call    goto_xy
    
    ; 打印盘子字符
    mov     ah, 09h
    mov     al, DISK_CHAR
    mov     bx, di  ; 使用保存的颜色值
    mov     cx, 1
    int     10h
    
    inc     dx              ; 移动到下一列
    pop     cx              ; 恢复计数器
    loop    draw_disk_at_new_pos
    
    ; 清除原位置
    pop     ax              ; 恢复Y坐标
    inc     ax              ; 回到原位置
    mov     cx, di          ; CX = 盘子宽度
    mov     dx, di          ; DX = 当前X坐标
clear_old_pos_move:         ; 修改：重命名标签
    push    cx              ; 保存计数器
    
    ; 移动到原位置
    push    ax              ; Y坐标
    push    dx              ; X坐标
    call    goto_xy
    
    ; 检查是否在柱子中心
    push    dx              ; 保存X坐标
    sub     dx, di          ; 计算相对于起始位置的偏移
    mov     ax, si          ; 盘子宽度
    shr     ax, 1           ; 除以2得到中心位置
    cmp     dx, ax          ; 比较是否在中心
    pop     dx              ; 恢复X坐标
    je      draw_tower_char_move ; 修改：重命名标签
    
    ; 不是中心位置，画空格
    mov     ah, 09h
    mov     al, SPACE_CHAR
    mov     bl, 07h         ; 黑底白字
    mov     cx, 1
    int     10h
    jmp     continue_clear_move ; 修改：重命名标签
    
draw_tower_char_move:       ; 修改：重命名标签
    mov     ah, 09h
    mov     al, TOWER_CHAR
    mov     bl, TOWER_COLOR ; 柱子颜色
    mov     cx, 1
    int     10h
    
continue_clear_move:        ; 修改：重命名标签
    inc     dx              ; 移动到下一列
    pop     cx              ; 恢复计数器
    loop    clear_old_pos_move ; 修改：重命名标签
    
    pop     cx              ; 恢复位置计数器
    dec     cx              ; 向上移动
    
    ; 延时
    call    delay_ms
    
    ; 检查是否到达目标高度（第3行）
    mov     ax, BASE_LINE   ; 从底座行开始
    dec     ax              ; 减1到达底座上一行
    sub     ax, cx          ; 减去当前位置
    cmp     ax, 3           ; 比较是否到达第3行
    jne     move_up         ; 如果没到，继续向上移动
    
    ; 更新起始柱的状态
    pop     bx              ; 恢复柱号
    mov     al, current_pos[bx]  ; 获取当前位置
    dec     al                   ; 减1
    mov     current_pos[bx], al  ; 更新位置
    
    ; 切换到目标柱
    mov     bl, bh              ; 切换到目标柱
    
    ; 更新目标柱的状态
    mov     al, current_pos[bx]  ; 获取当前位置
    inc     al                   ; 加1
    mov     current_pos[bx], al  ; 更新位置
    
    pop     di
    pop     si
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret
IMGTower_Move endp

; ====================================
; 函数名：draw_tower
; 功能：绘制汉诺塔的一根柱子
; 参数：AL = 柱子编号(0-2)
; 返回：无
; ====================================
draw_tower proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    cx
    push    dx
    
    ; 计算柱子的X坐标
    xor     ah, ah             ; 清零AH，使AX为16位
    mov     bl, al              ; 保存柱子编号
    xor     bh, bh             ; 清零BH，使BX为16位
    push    ax                 ; 保存AX
    mov     ax, BASE_SPACE      ; 柱子间距
    mul     bx                  ; AX = 柱子编号 * 间距
    add     ax, LEFT_MARGIN     ; 加上左边距
    add     ax, 10             ; 加上半个底座宽度，使柱子位于底座中心
    mov     bx, ax             ; BX = 柱子的X坐标
    pop     ax                 ; 恢复AX
    
    ; 绘制柱子主体
    mov     cx, TOWER_HEIGHT    ; 柱子高度
draw_tower_loop:
    ; 计算当前Y坐标
    mov     dx, BASE_LINE       ; 从底座行开始
    dec     dx                  ; 减1，因为要从底座上一行开始
    sub     dx, cx             ; 减去当前高度（从下往上绘制）
    inc     dx                 ; 补偿，确保画满10行
    
    ; 使用print_char绘制柱子字符（浅黄色）
    mov     ax, TOWER_COLOR    ; 浅黄色
    push    ax                 ; 颜色
    push    dx                 ; y坐标
    push    bx                 ; x坐标
    mov     ax, TOWER_CHAR     ; 柱子字符
    push    ax
    call    print_char
    
    loop    draw_tower_loop
    
    ; 绘制底座
    mov     cx, BASE_WIDTH     ; 底座宽度
    mov     dx, BASE_LINE      ; 底座Y坐标
    mov     ax, bx
    sub     ax, 10             ; 减去半个底座宽度
    mov     bx, ax             ; 保存起始X坐标
    
    ; 绘制底座字符（浅黄色）
draw_base_loop:
    mov     ax, BASE_COLOR     ; 浅黄色
    push    ax                 ; 颜色
    push    dx                 ; y坐标
    push    bx                 ; x坐标
    mov     ax, BASE_CHAR      ; 底座字符
    push    ax
    call    print_char
    
    inc     bx                ; 移动到下一个位置
    loop    draw_base_loop
    
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret
draw_tower endp

; ====================================
; 函数名：draw_disk
; 功能：在指定位置绘制一个盘子
; 参数：AL = 盘子大小(1-9)
;       BL = 柱子编号(0-2)
;       CL = 盘子位置(从下往上0开始)
; 返回：无
; ====================================
draw_disk proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    cx
    push    dx
    push    si
    
    ; AL = 盘子大小, BL = 柱子编号, CL = 位置
    xor     ah, ah            ; 清零AH，使AX为16位
    mov     si, ax           ; SI = 盘子大小（16位）
    
    ; 计算柱子的X坐标（中心位置）
    mov     al, BASE_SPACE      ; 柱子间距
    xor     ah, ah             ; 清零AH，使AX为16位
    mov     bh, 0              ; 清零BH，使BX为16位
    mul     bx                  ; AX = 柱子编号 * 间距
    add     ax, LEFT_MARGIN     ; 加上左边距
    add     ax, 10             ; 加上半个底座宽度，使柱子位于底座中心
    mov     dx, ax             ; DX = 柱子中心X坐标
    
    ; 计算Y坐标（从下往上）
    xor     ch, ch             ; 清零CH，使CX为16位
    mov     ax, BASE_LINE      ; 从底座行开始
    dec     ax                 ; 减1，到达底座上一行
    sub     ax, cx             ; 减去当前位置
    mov     bx, ax            ; BX = Y坐标
    
    ; 计算盘子宽度（最上层为1，往下依次加2）
    mov     ax, si            ; AX = 盘子大小（16位）
    shl     ax, 1            ; AX = 盘子大小 * 2
    dec     ax              ; 宽度 = 盘子大小 * 2 - 1
    mov     cx, ax          ; CX = 盘子宽度

    ; 计算起始X坐标
    mov     ax, dx            ; AX = 柱子中心X坐标
    mov     dx, cx            ; 暂存宽度
    shr     dx, 1             ; DX = 半宽
    sub     ax, dx            ; AX = 起始X坐标
    mov     dx, ax            ; DX = 当前绘制X坐标
    
    ; 获取盘子颜色（根据大小选择不同颜色）
    mov     ax, si            ; AX = 盘子大小（16位）
    dec     ax               ; 减1作为索引（1-9 -> 0-8）
    push    bx               ; 保存bx
    mov     bx, offset disk_colors
    xor     ah, ah          ; 清零AH
    add     bx, ax          ; 使用16位加法计算偏
    mov     al, [bx]        ; 从颜色数组中获取对应颜色
    mov     ah, 0            ; 清零AH
    mov     si, ax           ; 保存颜色到SI
    pop     bx              ; 恢复bx

    ; 绘制盘子
draw_disk_loop:
    mov     ax, si           ; 获取颜色
    push    ax               ; 颜色
    push    bx              ; y坐标
    push    dx              ; x坐标
    mov     ax, DISK_CHAR    ; 盘子字符
    push    ax
    call    print_char
    
    inc     dx              ; 移动到下一个位置
    loop    draw_disk_loop
    
    pop     si
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret
draw_disk endp

; ====================================
; 函数名：move_disk_up
; 功能：向上移动盘子
; 参数：AL = 盘子大小, BL = 柱子编号, CL = 当前位置
; 返回：无
; ====================================
move_disk_up proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    cx
    push    dx
    push    si
    
    ; AL = 盘子大小, BL = 柱子编号, CL = 当前位置
    xor     ah, ah            ; 清零AH，使AX为16位
    mov     si, ax           ; SI = 盘子大小（16位）
    
    ; 在新位置绘制盘子
    push    ax              ; 保存当前AX
    mov     ax, si          ; 恢复盘子大小到AL
    dec     cl              ; 向上移动一格
    call    draw_disk       ; 绘制盘子
    inc     cl              ; 恢复位置
    pop     ax              ; 恢复AX

    ; 清除原位置的盘子
    push    ax              ; 保存盘子大小
    push    bx              ; 保存柱子编号
    push    cx              ; 保存位置
    
    ; 计算原位置坐标
    mov     al, BASE_SPACE   ; 柱子间距
    mul     bl              ; AX = 柱子编号 * 间距
    add     ax, LEFT_MARGIN ; 加上左边距
    add     ax, 10          ; 加上半个底座宽度
    mov     dx, ax          ; DX = 柱子中心X坐标
    
    ; 计算Y坐标
    mov     ax, BASE_LINE   ; 从底座行开始
    dec     ax              ; 减1到达底座上一行
    sub     ax, cx          ; 减去当前位置
    mov     bx, ax          ; BX = Y坐标
    
    ; 计算盘子宽度
    mov     ax, si          ; AX = 盘子大小
    shl     ax, 1           ; AX = 盘子大小 * 2
    dec     ax              ; 宽度 = 盘子大小 * 2 - 1
    mov     cx, ax          ; CX = 盘子宽度
    
    ; 计算起始X坐标
    mov     ax, dx          ; AX = 柱子中心X坐标
    mov     dx, cx          ; 暂存宽度
    shr     dx, 1           ; DX = 半宽
    sub     ax, dx          ; AX = 起始X坐标
    mov     dx, ax          ; DX = 当前绘制X坐标
    
    ; 清除原位置
clear_old_pos:
    ; 在原位置画空格
    mov     ax, 07h         ; 黑底白字
    push    ax              ; 颜色
    push    bx              ; y坐标
    push    dx              ; x坐标
    mov     ax, SPACE_CHAR  ; 空格字符
    push    ax
    call    print_char
    
    ; 检查是否需要重绘柱子
    push    dx              ; 保存当前X坐标
    mov     ax, dx          ; 当前X坐标
    sub     ax, LEFT_MARGIN ; 减去左边距
    sub     ax, 10          ; 减去半个底座宽度
    cmp     ax, 0           ; 检查是否在柱子中心
    pop     dx              ; 恢复当前X坐标
    jne     next_pos        ; 如果不是中心位置，继续下一个位置
    
    ; 在中心位置重绘柱子
    mov     ax, TOWER_COLOR ; 浅黄色
    push    ax              ; 颜色
    push    bx              ; y坐标
    push    dx              ; x坐标
    mov     ax, TOWER_CHAR  ; 柱子字符
    push    ax
    call    print_char
    
next_pos:
    inc     dx              ; 移动到下一个位置
    loop    clear_old_pos   ; 继续清除下一个位置
    
    pop     cx              ; 恢复位置
    pop     bx              ; 恢复柱子编号
    pop     ax              ; 恢复盘子大小
    
    pop     si
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret
move_disk_up endp

; ====================================
; 函数名：delay_ms
; 功能：延时函数（约100ms）
; 参数：无
; 返回：无
; ====================================
delay_ms proc
    push    bp
    mov     bp, sp
    push    ax
    push    bx
    push    cx
    push    dx
    
    mov     cx, 10000      ; 循环10000次 ≈ 100ms
delay_loop:
    push    cx
    mov     cx, 100       ; 内层循环
delay_inner:
    loop    delay_inner
    pop     cx
    loop    delay_loop
    
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret
delay_ms endp

; ====================================
; 程序入口
; ====================================
start:
    ; 初始化数据段
    mov     ax, @data
    mov     ds, ax
    
    ; 运行测试程序
    call    test_functions
    
    ; 清屏准备开始汉诺塔程序
    mov     ax, 07h        ; 黑底白字
    push    ax
    call    clear_screen
    
    ; 移动到第18行第1列显示输入提示
    mov     ax, 18         ; y = 18
    push    ax             ; y坐标
    xor     ax, ax         ; x = 0（第一列）
    push    ax             ; x坐标
    call    goto_xy
    
    ; 提示用户输入盘子数量
    mov     ah, 09h
    lea     dx, msg_input_n
    int     21h
    
    ; 获取用户输入
    call    get_number
    
    ; 使用IMGTower_Init初始化游戏
    call    IMGTower_Init
    
    ; 移动到第19行第1列等待用户按键
    mov     ax, 19         ; y = 19
    push    ax             ; y坐标
    xor     ax, ax         ; x = 0（第一列）
    push    ax             ; x坐标
    call    goto_xy
    
    ; 显示等待提示
    mov     ah, 09h
    lea     dx, msg_continue
    int     21h

    ; 等待用户按键
    mov     ah, 01h
    int     21h
    
    ; 将最上面的盘子从A柱移动到B柱
    mov     al, 1           ; 移动大小为1的盘子
    mov     bl, 0           ; 从A柱（0号柱）
    mov     bh, 1           ; 移动到B柱（1号柱）
    call    IMGTower_Move
    
    ; 移动到第19行第1列显示退出提示
    mov     ax, 19         ; y = 19
    push    ax             ; y坐标
    xor     ax, ax         ; x = 0（第一列）
    push    ax             ; x坐标
    call    goto_xy
    
    ; 显示退出提示
    mov     ah, 09h
    lea     dx, msg_continue
    int     21h
    
    ; 等待用户按键
    mov     ah, 01h
    int     21h
    
    ; 退出程序
    mov     ax, 4C00h
    int     21h

end start