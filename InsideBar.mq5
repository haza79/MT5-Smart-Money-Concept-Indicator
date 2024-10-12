//+------------------------------------------------------------------+
//|                                                    InsideBar.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.01"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2

#property indicator_label1  "MotherBar"
#property indicator_type1   DRAW_FILLING
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

#property indicator_label2  "InsideBar"
#property indicator_type2   DRAW_FILLING
#property indicator_color2  clrBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2

double upperBuffer[], lowerBuffer[];
int motherBarIndex = -1;
double motherBarHigh = 0, motherBarLow = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   // Set indicator buffers
   SetIndexBuffer(0, upperBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, lowerBuffer, INDICATOR_DATA);
   
   // Set buffer empty values
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, 0.0);
   
   return (INIT_SUCCEEDED);
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

   return rates_total;
}

void DrawRectangle(int currentBarIndex, double high, double low)
{
   for (int i = motherBarIndex; i <= currentBarIndex; i++)
   {
      upperBuffer[i] = high;
      lowerBuffer[i] = low;
   }
}

bool IsInsideBar(int index,const double &high[],const double &low[]){
   double prevHigh = high[index-1];
   double prevLow = low[index-1];
   
   double currHigh = high[index];
   double currLow = low[index];
   
   if(currHigh < prevHigh && currLow > prevLow){
      return true;
   }
   
   return false;
}

bool isInsideBarBreak(int index,const double &high[],const double &low[]){
   double currHigh = high[index];
   double currLow = low[index];
   
   if(currHigh > motherBarHigh || currLow < motherBarLow){
      return true;
   }
   
   return false;
}