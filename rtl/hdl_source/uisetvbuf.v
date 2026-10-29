
/*******************************MILIANKE*******************************
*Company : MiLianKe Electronic Technology Co., Ltd.
*WebSite:https://www.milianke.com
*TechWeb:https://www.uisrc.com
*tmall-shop:https://milianke.tmall.com
*jd-shop:https://milianke.jd.com
*taobao-shop1: https://milianke.taobao.com
*Create Date: 2023/03/23
*Module Name:
*File Name:
*Description: 
*The reference demo provided by Milianke is only used for learning. 
*We cannot ensure that the demo itself is free of bugs, so users 
*should be responsible for the technical problems and consequences
*caused by the use of their own products.
*Copyright: Copyright (c) MiLianKe
*All rights reserved.
*Revision: 1.1
*Signal description
*1) I_ input
*2) O_ output
*3) IO_ input output
*4) S_ system internal signal
*5) _n activ low
*6) _dg debug signal 
*7) _r delay or register
*8) _s state mechine
*********************************************************************/
`timescale 1ns / 1ps

module uisetvbuf#(
parameter  integer                  BUF_DELAY     = 1,
parameter  integer                  BUF_LENTH     = 3
)
(

input      [7   :0]                 bufn_i,
output     [7   :0]                 bufn_o
);   


// 3÷°ª∫¥Ê —”≥Ÿ1÷°Õ∆µº BUF_DELAY     = 1 ,BUF_LENTH     = 3
//0<BUF_DELAY(1)     BUF_LENTH(3)   - BUF_DELAY(1) + bufn_i(0)  = 2
//1=BUF_DELAY(1)     bufn_i(1)      - BUF_DELAY(1)   = 0
//2>BUF_DELAY(1)     bufn_i(2)      - BUF_DELAY(1)   = 1



// 3÷°ª∫¥Ê —”≥Ÿ2÷°Õ∆µº BUF_DELAY     = 2 ,BUF_LENTH     = 3
//0<BUF_DELAY(2)     BUF_LENTH(3) - BUF_DELAY(2) + bufn_i(0)  = 1
//1<BUF_DELAY(2)     BUF_LENTH(3) - BUF_DELAY(2) + bufn_i(1)  = 2
//2=BUF_DELAY(2)     bufn_i(2)    - BUF_DELAY(2)   = 0


// 4÷°ª∫¥Ê —”≥Ÿ1÷°Õ∆µº BUF_DELAY     = 1 ,BUF_LENTH     = 4
//0<BUF_DELAY(1)     BUF_LENTH(4) - BUF_DELAY(1) + bufn_i(0)   = 3

//1=BUF_DELAY(1)     bufn_i(1)    - BUF_DELAY(1)               = 0

//2>BUF_DELAY(1)     bufn_i(2)    - BUF_DELAY(1)               = 1

//3>BUF_DELAY(1)     bufn_i(3)    - BUF_DELAY(1)               = 2


// 4÷°ª∫¥Ê —”≥Ÿ2÷°Õ∆µº BUF_DELAY     = 2 ,BUF_LENTH     = 4
//0<BUF_DELAY(2)     BUF_LENTH(4) - BUF_DELAY(2) + bufn_i(0)   = 2

//1<BUF_DELAY(2)     BUF_LENTH(4) - BUF_DELAY(2) + bufn_i(1)   = 3

//2=BUF_DELAY(2)     bufn_i(2)    - BUF_DELAY(2)               = 0

//3>BUF_DELAY(2)     bufn_i(3)    - BUF_DELAY(2)               = 1

//∫Û√Ê≤ª‘ŸÕ∆µº

assign bufn_o = bufn_i < BUF_DELAY?  (BUF_LENTH - BUF_DELAY + bufn_i) : (bufn_i - BUF_DELAY) ;


endmodule

