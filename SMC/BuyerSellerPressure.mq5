//+------------------------------------------------------------------+
//|                                          BuyerSellerPressure.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_plots   3
//--- plot seller
#property indicator_label1  "seller"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot buyer
#property indicator_label2  "buyer"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "signal"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- indicator buffers
double         signalBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
#include "BuyerSellerPressure.mqh";

BuyerSellerPressure buyerSellerPressure;

int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,buyerSellerPressure.sellerPressureBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,buyerSellerPressure.buyerPressureBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,signalBuffer,INDICATOR_DATA);
   
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
   
//--- return value of prev_calculated for next call
   int start = prev_calculated == 0 ? 1 : prev_calculated - 1;
   for (int i = start; i < rates_total; i++) {
      buyerSellerPressure.update(open[i],high[i],low[i],close[i],i,rates_total);
      
      
   }
   
   return(rates_total);
  }
//+------------------------------------------------------------------+
