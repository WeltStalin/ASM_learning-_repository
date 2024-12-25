/* 信08 2252934 文达 */
#pragma once

/* ------------------------------------------------------------------------------------------------------

     本文件功能：
	1、为了保证 hanoi_main.cpp/hanoi_menu.cpp/hanoi_multiple_solutions.cpp 能相互访问函数的函数声明
	2、一个以上的cpp中用到的宏定义（#define）或全局只读（const）变量，个数不限
	3、可以参考 cmd_console_tools.h 的写法（认真阅读并体会）
   ------------------------------------------------------------------------------------------------------ */
#define _CRT_SECURE_NO_WARNINGS
#include "cmd_console_tools.h"
#include <iostream>
#include <iomanip>
#include <conio.h>
#include <Windows.h>
using namespace std;

#define Height 12
#define HalWidth  11
#define Space  9
#define Delta (HalWidth*2+Space+1)
#define ImageX (HalWidth*3+Space+3)
#define ImageY (Height+1+4)

#define NUM  0x00
#define STA  0x01
#define MID  0x02
#define END  0x03
#define Ox 11
#define Oy 21
#define Ox_img 11
#define Oy_img (ImageY+15)
#define Oblank 10



//菜单函数
int menu(void);
//游戏运行函数
void FunTpye1(void);
void FunTpye2(void);
void FunTpye3(void);
void FunTpye4(void);
void FunTpye5(void);
void FunTpye6(void);
void FunTpye7(void);
void FunTpye8(void);
void FunTpye9(void);
