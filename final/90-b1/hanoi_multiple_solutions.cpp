/* 信08 2252934 文达 */
# include "hanoi.h"

/* ----------------------------------------------------------------------------------

     本文件功能：
    1、存放被 hanoi_main.cpp 中根据菜单返回值调用的各菜单项对应的执行函数

     本文件要求：
    1、不允许定义外部全局变量（const及#define不在限制范围内）
    2、允许定义静态全局变量（具体需要的数量不要超过文档显示，全局变量的使用准则是：少用、慎用、能不用尽量不用）
    3、静态局部变量的数量不限制，但使用准则也是：少用、慎用、能不用尽量不用
    4、按需加入系统头文件、自定义头文件、命名空间等

   ----------------------------------------------------------------------------------- */
int Step_count = 0, p[3] = { -1,-1,-1 }, Data[3][10] = { 0 }, speed;


/***************************************************************************
  函数名称：
  功    能：转大写
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
char strupr(char ch)
{
    char UPPER = ch;
    if ((ch >= 'a') && (ch <= 'z'))
    {
        UPPER -= 0x20;
    }

    return UPPER;
}

/***************************************************************************
  函数名称：
  功    能：全局变量初始化
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void Claer_Value(void)
{
    int i;

    Step_count = 0;
    p[0] = -1;
    p[1] = -1;
    p[2] = -1;
    for (i = 0; i < 3 * 10; i++)
    {
        Data[i / 10][i % 10] = 0;
    }
}

/***************************************************************************
  函数名称：
  功    能：延时函数
  输入参数：Mod：等待模式
  返 回 值：
  说    明：
***************************************************************************/
void wait(int Mod)
{
    if (Mod == 1)
    {
        if (speed)
        {
            Sleep(500 / speed);
        }
        else
        {
            while (_getch() != '\r')
                ;
        }
    }
    else if (Mod == 2)
    {
        if (speed)
        {
            Sleep(500 / speed / speed / speed / speed);
        }
        else
        {
            Sleep(500);
        }
    }
}

/***************************************************************************
函数名称：汉诺塔信息输入函数
功    能：
输入参数：OPData:承接用数组
          Type：模式
返 回 值：
说    明：
***************************************************************************/
void InPut(char* OPData, int Type)
{
    int Step = 0, NuFlash = 0, i;
    char ChFlash = '0';

    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (1)
    {
        switch (Step)
        {
            case 0:
                cout << "请输入汉诺塔的层数(1-10)" << endl;
                cin >> NuFlash;
                break;
            case 1:
                cout << "请输入起始柱(A-C)" << endl;
                cin >> ChFlash;
                break;
            case 2:
                cout << "请输入目标柱(A-C)" << endl;
                cin >> ChFlash;
                break;
            case 3:
                cout << "请输入移动速度(0-5：0-按回车单步演示 1-延时最长 5-延时最短)" << endl;
                cin >> NuFlash;
                break;
        }
        ChFlash = strupr(ChFlash);
        cin.clear();
        cin.ignore(INT_MAX, '\n');
        if (Step == 0)
        {
            if (NuFlash >= 1 && NuFlash <= 10)
            {
                OPData[NUM] = NuFlash;
                Step++;
            }
        }
        else if (Step == 1)
        {
            if ((ChFlash >= 'A') && (ChFlash <= 'C'))
            {
                OPData[STA] = ChFlash - 'A';
                Step++;
                p[OPData[STA]] += OPData[NUM];
                for (i = 0; i < OPData[NUM]; i++)
                {
                    Data[OPData[STA]][i] = OPData[NUM] - i;
                }
            }
        }
        else if (Step == 2)
        {
            if ((ChFlash >= 'A') && (ChFlash <= 'C'))
            {
                OPData[END] = ChFlash - 'A';
                OPData[MID] = 3 - OPData[STA] - OPData[END];
                if (OPData[END] != OPData[STA])
                {
                    if (Type == 4 || Type == 8)
                    {
                        Step++;
                    }
                    else
                    {
                        break;
                    }
                }
                else
                {
                    cout << "目标柱(" << char('A' + OPData[STA]) << ")不能与起始柱(" << char('A' + OPData[END]) << ")相同" << endl;
                }
            }
        }
        else if (Step == 3)
        {
            if (NuFlash >= 0 && NuFlash <= 5)
            {
                speed = NuFlash;
                break;
            }
        }
    }
    cct_setcursor(CURSOR_INVISIBLE);
}

/***************************************************************************
  函数名称：
  功    能：打表
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void print_num(void)
{
    int i, j, blank;

    for (j = 0; j < 3; j++)
    {
        cout << ' ' << char(j + 'A') << ":";
        for (i = 0; i <= p[j]; i++)
        {
            cout << setw(2) << Data[j][i];
        }
        blank = 20 - (p[j] + 1) * 2;
        if (blank > 0)
        {
            cout << setw(blank) << ' ';
        }
    }
    cout << endl;
}

/***************************************************************************
  函数名称：
  功    能：字符塔初始化
  输入参数：Type：模式
            n：层数
            sta：起始柱子
  返 回 值：
  说    明：
***************************************************************************/
void CHTower_Init(int n, int sta, int Type)
{
    int i, x = 0, y = 0;

    if (Type == 4)
    {
        x = Ox;
        y = Oy;
    }
    else if (Type == 8 || Type == 9)
    {
        x = Ox_img;
        y = Oy_img;
    }
    cct_gotoxy(x, y);
    cout << "A         B         C";
    cct_gotoxy(x - 2, y - 1);
    cout << "=========================";
    for (i = n; i > 0; i--)
    {
        cct_gotoxy(x + Oblank * sta, y - 2 + i - n);
        cout << i;
    }
}

/***************************************************************************
  函数名称：
  功    能：字符塔操作
  输入参数：Obj：对象
            Ways：方式或输出值（-1为清除）
            Type：模式
  返 回 值：
  说    明：
***************************************************************************/
void CHTower_Show(int Obj, int Ways, int Type)
{
    int x = 0, y = 0;

    if (Type == 4)
    {
        x = Ox;
        y = Oy;
    }
    else if (Type == 8 || Type == 9)
    {
        x = Ox_img;
        y = Oy_img;
    }
    if (Type == 4 || Type == 8 || Type == 9)
    {
        cct_gotoxy(x + Obj * Oblank, y - 2 - p[Obj]);
        if (Ways == -1)
        {
            wait(1);
            cout << "   ";
        }
        else
        {
            cout << (int)Ways;
        }
    }
}

/***************************************************************************
  函数名称：
  功    能：图像塔初始化
  输入参数：Type：模式
            n：层数
            sta：起始柱子
  返 回 值：
  说    明：
***************************************************************************/
void IMGTower_Init(int n, int sta, int Type)
{
    char color = COLOR_HYELLOW;
    int i, j;

    for (i = 0; i < Height + 1; i++)
    {
        for (j = 0; j < 3; j++)
        {
            Sleep(50);
            if (i == 0)
            {
                cct_showch(ImageX + (j - 1) * Delta - HalWidth, ImageY, ' ', color, COLOR_BLACK, Delta - HalWidth + 2);
            }
            else
            {
                cct_showch(ImageX + (j - 1) * Delta, ImageY - i, ' ', color, 1);
            }
        }
    }

    color = COLOR_BLUE + n - 1;
    if (Type >= 6)
    {
        for (i = n; i > 0; i--)
        {
            Sleep(50);
            cct_showch(ImageX + Delta * (sta - 1) - i, ImageY - 1 + i - n, ' ', color--, COLOR_BLACK, 2 * i + 1);
        }
    }

    cct_showch(ImageX + 9, ImageY + 9, ' ', COLOR_BLACK, COLOR_WHITE, 1);
    Sleep(1000);
}

/***************************************************************************
  函数名称：
  功    能：图像塔操作
  输入参数：src :出发地
            dst ：目的地
  返 回 值：
  说    明：
***************************************************************************/
void IMGTower_Move(int src, int dst)
{
    int i, STx = 0, STy = 0, DTx = 0, DTy = 0, ID = 0, color;

    //   Data[src][p[src]]------->Data[dst][p[dst]]
        //数据载入
    STx = ImageX + Delta * (src - 1);
    STy = ImageY - 1 - (p[src] + 1);
    DTx = ImageX + Delta * (dst - 1);
    DTy = ImageY - 1 - p[dst];
    ID = Data[dst][p[dst]];
    color = COLOR_BLUE + ID - 1;
    //上升
    for (i = 0; i < STy - 2; i++)
    {
        wait(2);
        if (i <= STy - (ImageY - Height))
        {
            cct_showch(STx - ID, STy - i, ' ', COLOR_BLACK, COLOR_BLACK, ID);
            cct_showch(STx, STy - i, ' ', COLOR_HYELLOW, COLOR_BLACK, 1);
            cct_showch(STx + 1, STy - i, ' ', COLOR_BLACK, COLOR_BLACK, ID);
        }
        else
        {
            cct_showch(STx - ID, STy - i, ' ', COLOR_BLACK, COLOR_BLACK, 2 * ID + 1);
        }
        cct_showch(STx - ID, STy - i - 1, ' ', color, COLOR_BLACK, 2 * ID + 1);
    }
    //平移
    if (DTx > STx)    //右
    {
        for (i = 0; i < DTx - STx; i++)
        {
            wait(2);
            cct_showch(STx + i + ID + 1, 2, ' ', color, COLOR_BLACK, 1);
            cct_showch(STx + i - ID - 1, 2, ' ', COLOR_BLACK, COLOR_BLACK, 2);
        }
    }
    else
    {
        for (i = 0; i < STx - DTx; i++)
        {
            wait(2);
            cct_showch(STx - i - ID - 1, 2, ' ', color, COLOR_BLACK, 1);
            cct_showch(STx - i + ID, 2, ' ', COLOR_BLACK, COLOR_BLACK, 2);
        }
    }
    //下降
    for (i = 0; i <= DTy - 2; i++)
    {
        wait(2);
        if (i > (ImageY - Height) - 2)
        {
            cct_showch(DTx - ID, 2 + i - 1, ' ', COLOR_BLACK, COLOR_BLACK, ID);
            cct_showch(DTx, 2 + i - 1, ' ', COLOR_HYELLOW, COLOR_BLACK, 1);
            cct_showch(DTx + 1, 2 + i - 1, ' ', COLOR_BLACK, COLOR_BLACK, ID);
        }
        else
        {
            cct_showch(DTx - ID, 2 + i - 1, ' ', COLOR_BLACK, COLOR_BLACK, 2 * ID + 1);
        }
        cct_showch(DTx - ID, 2 + i, ' ', color, COLOR_BLACK, 2 * ID + 1);
    }
    //清除影响
    cct_showch(ImageX + 9, ImageY + 9, ' ', COLOR_BLACK, COLOR_WHITE, 1);
}

/***************************************************************************
  函数名称：输出函数
  功    能：
  输入参数：src :出发地
            dst ：目的地
            n   ：层数
            Type：输出方式
  返 回 值：
  说    明：
***************************************************************************/
void OutPut(char src, char dst, int n, int Type)
{
    int flash = 0;

    Step_count++;
    //源数组操作
    CHTower_Show(src, -1, Type);
    flash = Data[src][p[src]];
    Data[src][p[src]] = 0;
    p[src]--;
    //目标数组操作
    p[dst]++;
    CHTower_Show(dst, flash, Type);
    Data[dst][p[dst]] = flash;
    if (Type == 1)
    {
        cout << " " << n << "# " << (char)(src + 'A') << "-->" << (char)(dst + 'A') << endl;
    }
    else if (Type == 2)
    {
        cout << "第" << setw(4) << Step_count << " 步(" << setw(2) << n << "#: " << (char)(src + 'A') << "-->" << (char)(dst + 'A') << ")" << endl;
    }
    else if (Type == 3)
    {
        cout << "第" << setw(4) << Step_count << " 步(" << setw(2) << n << "#: " << (char)(src + 'A') << "-->" << (char)(dst + 'A') << ")";
        print_num();
    }
    else if (Type == 4)
    {
        cct_gotoxy(Ox + 9, Oy + 4);
        cout << setw(100) << ' ';
        cct_gotoxy(Ox + 9, Oy + 4);
        cout << "第" << setw(4) << Step_count << " 步(" << setw(2) << n << "#: " << (char)(src + 'A') << "-->" << (char)(dst + 'A') << ") ";
        print_num();
    }
    else if (Type == 7)
    {
        if (Step_count == 1)
        {
            IMGTower_Move(src, dst);
        }
    }
    else if (Type == 8 || Type == 9)
    {
        cct_gotoxy(Ox_img, Oy_img + 4);
        cout << setw(100) << ' ';
        cct_gotoxy(Ox_img, Oy_img + 4);
        cout << "第" << setw(4) << Step_count << " 步(" << setw(2) << n << "#: " << (char)(src + 'A') << "-->" << (char)(dst + 'A') << ") ";
        print_num();
        IMGTower_Move(src, dst);
    }
}

/***************************************************************************
  函数名称：汉诺塔递归函数1
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void hanoi(int n, char src, char tmp, char dst, int Type)
{
    if (n == 1)
    {
        OutPut(src, dst, n, Type);
    }
    else
    {
        hanoi(n - 1, src, dst, tmp, Type);
        OutPut(src, dst, n, Type);
        hanoi(n - 1, tmp, src, dst, Type);
    }
}

/***************************************************************************
  函数名称：汉诺塔调用函数1
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void FunTpye1(void)
{
    char OPData[4], Type = 1;

    InPut(OPData, Type);
    hanoi(OPData[NUM], OPData[STA], OPData[MID], OPData[END], Type);

    cout << endl << "按回车键继续.";
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (_getch() != '\r')
        ;
    cct_cls();
    Claer_Value();
}

/***************************************************************************
  函数名称：汉诺塔调用函数2
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void FunTpye2(void)
{
    char OPData[4], Type = 2;

    InPut(OPData, Type);
    hanoi(OPData[NUM], OPData[STA], OPData[MID], OPData[END], Type);

    cout << endl << "按回车键继续.";
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (_getch() != '\r')
        ;
    cct_cls();
    Claer_Value();
}

/***************************************************************************
  函数名称：汉诺塔调用函数3
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void FunTpye3(void)
{
    char OPData[4], Type = 3;

    InPut(OPData, Type);
    hanoi(OPData[NUM], OPData[STA], OPData[MID], OPData[END], Type);

    cout << endl << "按回车键继续.";
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (_getch() != '\r')
        ;
    cct_cls();
    Claer_Value();
}

/***************************************************************************
  函数名称：汉诺塔调用函数4
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void FunTpye4(void)
{
    char OPData[4], Type = 4;

    InPut(OPData, Type);
    //初始显示
    cct_cls();
    cout << "从 " << char(OPData[STA] + 'A') << " 移动到 " << char(OPData[END] + 'A') << " ，共 " << (int)OPData[NUM] << " 层，延时设置为 " << speed << "，";
    CHTower_Init(OPData[NUM], OPData[STA], Type);
    cct_gotoxy(Ox + 9, Oy + 4);
    cout << setw(100) << ' ';
    cct_gotoxy(Ox + 9, Oy + 4);
    cout << "初始:" << setw(16) << ' ';
    print_num();
    //运行
    hanoi(OPData[NUM], OPData[STA], OPData[MID], OPData[END], Type);

    cct_gotoxy(Ox + 9, Oy + 14);
    cout << endl << "按回车键继续.";
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (_getch() != '\r')
        ;
    cct_cls();
    Claer_Value();
}

/***************************************************************************
  函数名称：汉诺塔调用函数5
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void FunTpye5(void)
{
    char Type = 5;

    cct_cls();
    IMGTower_Init(0, 0, Type);

    cct_gotoxy(Ox_img + 9, Oy_img + 5);
    cout << endl << "按回车键继续.";
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (_getch() != '\r')
        ;
    cct_cls();
    Claer_Value();
}

/***************************************************************************
  函数名称：汉诺塔调用函数6
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void FunTpye6(void)
{
    char OPData[4], Type = 6;

    InPut(OPData, Type);
    //初始化
    cct_cls();
    cout << "从 " << char(OPData[STA] + 'A') << " 移动到 " << char(OPData[END] + 'A') << " ，共 " << (int)OPData[NUM] << " 层" << endl;
    IMGTower_Init(OPData[NUM], OPData[STA], Type);
    //结束
    cct_gotoxy(Ox_img + 9, Oy_img + 5);
    cout << endl << "按回车键继续.";
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (_getch() != '\r')
        ;
    cct_cls();
    Claer_Value();
}

/***************************************************************************
  函数名称：汉诺塔调用函数7
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void FunTpye7(void)
{
    char OPData[4], Type = 7;

    InPut(OPData, Type);
    speed = (2);
    //初始化
    cct_cls();
    cout << "从 " << char(OPData[STA] + 'A') << " 移动到 " << char(OPData[END] + 'A') << " ，共 " << (int)OPData[NUM] << " 层" << endl;
    IMGTower_Init(OPData[NUM], OPData[STA], Type);
    //运行
    hanoi(OPData[NUM], OPData[STA], OPData[MID], OPData[END], Type);
    //结束
    cct_gotoxy(Ox_img + 9, Oy_img + 5);
    cout << endl << "按回车键继续.";
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (_getch() != '\r')
        ;
    cct_cls();
    Claer_Value();
}

/***************************************************************************
  函数名称：汉诺塔调用函数8
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void FunTpye8(void)
{
    char OPData[4], Type = 8;

    InPut(OPData, Type);
    //初始化
    cct_cls();
    cout << "从 " << char(OPData[STA] + 'A') << " 移动到 " << char(OPData[END] + 'A') << " ，共 " << (int)OPData[NUM] << " 层，延时设置为 " << speed << "，";
    CHTower_Init(OPData[NUM], OPData[STA], Type);
    cct_gotoxy(Ox_img, Oy_img + 4);
    cout << setw(100) << ' ';
    cct_gotoxy(Ox_img, Oy_img + 4);
    cout << "初始:" << setw(16) << ' ';
    print_num();
    IMGTower_Init(OPData[NUM], OPData[STA], Type);
    //运行
    hanoi(OPData[NUM], OPData[STA], OPData[MID], OPData[END], Type);
    //结束
    cct_gotoxy(Ox_img, Oy_img + 5);
    cout << endl << "按回车键继续.";
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (_getch() != '\r')
        ;
    cct_cls();
    Claer_Value();
}

/***************************************************************************
  函数名称：汉诺塔调用函数9
  功    能：
  输入参数：
  返 回 值：
  说    明：
***************************************************************************/
void FunTpye9(void)
{
    char OPData[4], Type = 9, src = 0, dst = 0, strFlash[3] = { 0 };

    InPut(OPData, Type);
    //初始化
    cct_cls();
    cout << "从 " << char(OPData[STA] + 'A') << " 移动到 " << char(OPData[END] + 'A') << " ，共 " << (int)OPData[NUM] << " 层，延时设置为 " << speed << "，";
    CHTower_Init(OPData[NUM], OPData[STA], Type);
    cct_gotoxy(Ox_img, Oy_img + 4);
    cout << setw(100) << ' ';
    cct_gotoxy(Ox_img, Oy_img + 4);
    cout << "初始:" << setw(16) << ' ';
    print_num();
    IMGTower_Init(OPData[NUM], OPData[STA], Type);
    speed = 0;
    wait(1);
    //运行
    speed = 3;
    while (1)
    {
        cct_gotoxy(0, Oy_img + 6);
        cout << setw(100) << ' ';
        cct_gotoxy(0, Oy_img + 7);
        cout << setw(100) << ' ';
        cct_gotoxy(Ox_img, Oy_img + 6);
        strFlash[0] = 0;
        strFlash[1] = 0;
        cout << "请输入移动的柱号(命令形式：AC = A顶端的盘子移动到C，Q = 退出) ：";
        cct_gotoxy(Ox_img + 64, Oy_img + 6);
        cct_setcursor(CURSOR_VISIBLE_NORMAL);
        cin >> strFlash;
        cin.clear();
        cin.ignore(INT_MAX, '\n');
        cct_setcursor(CURSOR_INVISIBLE);
        src = strupr(strFlash[0]);
        dst = strupr(strFlash[1]);
        if (src == 'Q' && dst == 0)
        {
            cct_gotoxy(Ox_img, Oy_img + 7);
            cout << "游戏中止!!!!!";
            break;
        }
        else
        {
            if ((src >= 'A' && src <= 'C' && dst >= 'A' && dst <= 'C') && (src != dst))
            {
                src -= 'A';
                dst -= 'A';
                if (p[src] == -1)
                {
                    cct_gotoxy(Ox_img, Oy_img + 7);
                    cout << "源柱为空!";
                    Sleep(1000);
                }
                else if ((Data[src][p[src]] > Data[dst][p[dst]]) && (p[dst] != -1))
                {
                    cct_gotoxy(Ox_img, Oy_img + 7);
                    cout << "大盘压小盘，非法移动!";
                    Sleep(1000);
                }
                else
                {
                    OutPut(src, dst, Step_count, Type);
                    if ((p[OPData[STA]] == -1) && (p[OPData[MID]] == -1) && (p[OPData[END]] == OPData[NUM] - 1))
                    {
                        cct_gotoxy(Ox_img, Oy_img + 7);
                        cout << "游戏结束!!!!!";
                        break;
                    }
                }
            }
        }
    }
    //结束
    cct_gotoxy(Ox_img, Oy_img + 8);
    cout << endl << "按回车键继续.";
    cct_setcursor(CURSOR_VISIBLE_NORMAL);
    while (_getch() != '\r')
        ;
    cct_cls();
    Claer_Value();
}
