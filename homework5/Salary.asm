; 定义堆栈段
STKSEG SEGMENT
    DW 32 DUP(0)      ; 定义32个字的堆栈空间
STKSEG ENDS

; 定义数据段
DATASEG SEGMENT
    ; 存储21年的年份数据（每个年份4字节）
    YEARS DB '1975','1976','1977','1978','1979','1980','1981','1982','1983'
         DB '1984','1985','1986','1987','1988','1989','1990','1991','1992'
         DB '1993','1994','1995'
    
    ; 存储21年的收入数据（每个收入4字节）
    INCOMES DD 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
            DD 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    
    ; 存储21年的员工数据（每个数据2字节）
    EMPLOYEES DW 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
              DW 11542,14430,15257,17800
DATASEG ENDS

; 定义表格段，用于存储处理后的数据
TABLE SEGMENT
    DB 21 DUP('year summ ne ??')    ; 每条记录16字节：年份4字节，收入4字节，人数2字节，人均收入2字节
TABLE ENDS

; 定义代码段
CODESEG SEGMENT
    ASSUME CS: CODESEG, DS: DATASEG, ES:TABLE
    ; 声明外部过程
    EXTRN DISPLAY_NUMBER: FAR, DISPLAY_TAB: FAR, DISPLAY_NEWLINE: FAR

MAIN_PROC PROC FAR
    ; 初始化数据段和附加段
    MOV AX, DATASEG
    MOV DS, AX
    MOV AX, TABLE
    MOV ES, AX

    ; 复制年份数据
    MOV CX, 21                  ; 设置循环次数
    MOV SI, OFFSET YEARS        ; 源数据偏移地址
    MOV DI, 0                   ; 目标数据偏移地址

COPY_YEARS_LOOP:
    ; 复制4字节年份数据
    MOVSB                       ; 每次移动一个字节
    MOVSB
    MOVSB
    MOVSB
    ADD DI, 12                  ; 移动到下一条记录
    LOOP COPY_YEARS_LOOP

    ; 复制收入数据
    MOV CX, 21                  ; 重置循环次数
    MOV SI, OFFSET INCOMES      ; 收入数据偏移地址
    MOV DI, 5                   ; 目标位置（跳过年份和一个字节）

COPY_INCOMES_LOOP:
    ; 复制4字节收入数据
    MOV AX, [SI]               ; 复制低16位
    MOV DX, [SI + 2]          ; 复制高16位
    MOV ES:[DI], AX
    MOV ES:[DI + 2], DX
    ADD DI, 16                 ; 移动到下一条记录
    ADD SI, 4                  ; 移动到下一个收入数据
    LOOP COPY_INCOMES_LOOP

    ; 复制员工数据
    MOV CX, 21                 ; 重置循环次数
    MOV SI, OFFSET EMPLOYEES   ; 员工数据偏移地址
    MOV DI, 10                 ; 目标位置（跳过年份和收入）

COPY_EMPLOYEES_LOOP:
    ; 复制2字节员工数据
    MOV AX, [SI]
    MOV ES:[DI], AX
    ADD DI, 16                 ; 移动到下一条记录
    ADD SI, 2                  ; 移动到下一个员工数据
    LOOP COPY_EMPLOYEES_LOOP

    ; 计算人均收入
    MOV CX, 21                 ; 重置循环次数
    MOV BX, 13                 ; 人均收入存储位置偏移
    MOV SI, OFFSET INCOMES     ; 收入数据偏移地址
    MOV DI, OFFSET EMPLOYEES   ; 员工数据偏移地址

CALCULATE_AVERAGES_LOOP:
    PUSH BX                    ; 保存BX
    MOV AX, [SI]              ; 获取收入低16位
    MOV DX, [SI + 2]          ; 获取收入高16位
    ADD SI, 4                  ; 移动到下一个收入数据
    MOV BX, [DI]              ; 获取员工数
    ADD DI, 2                  ; 移动到下一个员工数据
    DIV BX                     ; 计算人均收入 (DX:AX / BX)
    POP BX                     ; 恢复BX
    PUSH DI                    ; 保存DI
    MOV DI, BX                ; 设置存储位置
    MOV ES:[DI], AX           ; 存储人均收入
    ADD DI, 16                ; 移动到下一条记录
    MOV BX, DI                ; 更新BX
    POP DI                    ; 恢复DI
    LOOP CALCULATE_AVERAGES_LOOP

    ; 打印表格数据
    MOV BX, 21                ; 设置打印次数
    MOV SI, 0                 ; 重置数据指针
    MOV AX, TABLE             ; 切换到表格段
    MOV DS, AX

PRINT_TABLE_LOOP:
    CALL DISPLAY_TAB          ; 打印制表符
    MOV CX, 4                 ; 设置年份字符数

PRINT_YEAR:
    ; 打印年份（4个字符）
    MOV DL, [SI]
    MOV AH, 02H
    INT 21H
    INC SI
    LOOP PRINT_YEAR

    ; 打印收入
    CALL DISPLAY_TAB
    CALL DISPLAY_TAB
    CALL DISPLAY_TAB
    INC SI                    ; 跳过分隔符
    MOV AX, [SI]             ; 获取收入低16位
    ADD SI, 2
    MOV DX, [SI]             ; 获取收入高16位
    ADD SI, 2
    CALL DISPLAY_NUMBER      ; 显示收入

    ; 打印员工数
    CALL DISPLAY_TAB
    CALL DISPLAY_TAB
    INC SI                    ; 跳过分隔符
    MOV AX, [SI]             ; 获取员工数
    MOV DX, 0
    ADD SI, 2
    CALL DISPLAY_NUMBER      ; 显示员工数

    ; 打印人均收入
    CALL DISPLAY_TAB
    CALL DISPLAY_TAB
    INC SI                    ; 跳过分隔符
    MOV AX, [SI]             ; 获取人均收入
    MOV DX, 0
    ADD SI, 2
    CALL DISPLAY_NUMBER      ; 显示人均收入
    INC SI                    ; 移动到下一条记录
    CALL DISPLAY_NEWLINE     ; 换行
    DEC BX                   ; 递减计数器
    JNZ PRINT_TABLE_LOOP     ; 如果未完成全部打印则继续

    ; 程序结束
    MOV AX, 4C00H
    INT 21H

MAIN_PROC ENDP

CODESEG ENDS

END MAIN_PROC