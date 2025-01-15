#property indicator_chart_window
#property indicator_buffers 12
#property indicator_plots   12

#property indicator_label1  "MotherBarTop"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "MotherBarBottom"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "ZigZag"
#property indicator_type3   DRAW_ZIGZAG
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

#property indicator_label4  "SwingHigh"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrGreen
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

#property indicator_label5  "SwingLow"
#property indicator_type5   DRAW_ARROW
#property indicator_color5  clrGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1

#property indicator_label6  "bullish bos"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrGreen
#property indicator_style6  STYLE_DOT
#property indicator_width6  1



#include "BarData.mqh";
#include "InsideBarClass.mqh";
#include "ImpulsePullbackDetector.mqh";
#include "CandleStructs.mqh"
#include "CandleBreakAnalyzer.mqh";
#include "Fractal.mqh";
#include "MajorMarketStructure.mqh";

BarData barData;
InsideBarClass insideBar;
ImpulsePullbackDetectorClass impulsePullbackDetector;
CandleBreakAnalyzerClass candleBreakAnalyzer;
FractalClass fractal;
MajorMarketStructureClass majorMarketStructure;

int OnInit()
{

    SetIndexBuffer(0, insideBar.motherBarTopBuffer, INDICATOR_DATA);
    SetIndexBuffer(1, insideBar.motherBarBottomBuffer, INDICATOR_DATA);
    
    SetIndexBuffer(2, impulsePullbackDetector.highZigZagBuffer, INDICATOR_DATA);
    SetIndexBuffer(3, impulsePullbackDetector.lowZigZagBuffer, INDICATOR_DATA);
    
    SetIndexBuffer(4, fractal.highFractalBuffer, INDICATOR_DATA);
    SetIndexBuffer(5, fractal.lowFractalBuffer, INDICATOR_DATA);
    
    SetIndexBuffer(6, majorMarketStructure.bullishBosDrawing.buffer, INDICATOR_DATA);
    
    // mother bar fractal
    PlotIndexSetInteger(0, PLOT_ARROW, 158);
    PlotIndexSetInteger(1, PLOT_ARROW, 158);
    
    // zigzag plot empty
    PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(2,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(3,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(4,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(5,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(6,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(7,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(8,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(9,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(10,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(11,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    
    PlotIndexSetInteger(3,PLOT_ARROW_SHIFT,-10);
    PlotIndexSetInteger(4,PLOT_ARROW_SHIFT,10);
    

    insideBar.Init();
    impulsePullbackDetector.Init(&insideBar);
    fractal.Init(&impulsePullbackDetector);
    majorMarketStructure.Init(&barData,&fractal);
    

    return(INIT_SUCCEEDED);
}

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

   if (!barData.SetData(rates_total, time, open, high, low, close)) { // Call SetData() ONLY ONCE, BEFORE the loop
       Print("Setting data failed");
       return rates_total;
   }
//bias L     : 2024.01.23 14:00:00
//inducement : 2024.01.23 12:00:00


   
   
   //int start = MathMax(rates_total - 100, 0);// for limit candle to process
   int start = prev_calculated == 0 ? 0 : prev_calculated - 1; // for normal use

   for (int i = start; i < rates_total; i++) {  // Exclude last unclosed candle
      
      insideBar.Calculate(i, rates_total, high, low);
      impulsePullbackDetector.Calculate(i, rates_total, high, low);
      fractal.Calculate(i, high, low);
      //minorMarketStructure.Calculate(i, rates_total, time, open, high, low, close);
      majorMarketStructure.Calculate(i);
      
      
      
      

      }
      

   return rates_total;
   
}