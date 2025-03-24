//+------------------------------------------------------------------+
//|                                               BalanceOfPower.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot bop
#property indicator_label1  "bop"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- indicator buffers
double         bopBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
#include "BalanceOfPower.mqh";
//+------------------------------------------------------------------+

BalanceOfPower balanceOfPower;
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,balanceOfPower.balanceOfPowerBuffer,INDICATOR_DATA);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int start = prev_calculated == 0 ? 0 : prev_calculated - 1; // for normal use
   for (int i = start; i < rates_total; i++) {
      balanceOfPower.update(i,open[i],high[i],low[i],close[i],rates_total);
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
