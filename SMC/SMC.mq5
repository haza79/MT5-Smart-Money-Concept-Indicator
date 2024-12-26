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

#property indicator_label6  "minor bullish bos"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrGreen
#property indicator_style6  STYLE_DOT
#property indicator_width6  1

#property indicator_label7  "minor bullish choch"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrRed
#property indicator_style7  STYLE_SOLID
#property indicator_width7  1

#property indicator_label8  "minor bearish bos"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrGreen
#property indicator_style8  STYLE_DOT
#property indicator_width8  1

#property indicator_label9  "minor bearish choch"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrRed
#property indicator_style9  STYLE_SOLID
#property indicator_width9  1

#property indicator_label10  "minor high"
#property indicator_type10   DRAW_ARROW
#property indicator_color10  clrGold
#property indicator_style10  STYLE_SOLID
#property indicator_width10  1

#property indicator_label11  "minor low"
#property indicator_type11   DRAW_ARROW
#property indicator_color11  clrGold
#property indicator_style11  STYLE_SOLID
#property indicator_width11  1

#include "InsideBarClass.mqh";
#include "ImpulsePullbackDetector.mqh";
#include "CandleStructs.mqh"
#include "CandleBreakAnalyzer.mqh";
#include "MinorMarketStructureClass.mqh";
#include "Fractal.mqh";
#include "MajorMarketStructure.mqh";

InsideBarClass insideBar;
ImpulsePullbackDetectorClass impulsePullbackDetector;
CandleBreakAnalyzerClass candleBreakAnalyzer;
MinorMarketStructureClass minorMarketStructure;
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
    
    ///
    SetIndexBuffer(6, minorMarketStructure.bullishBosDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(7, minorMarketStructure.bullishChochDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(8, minorMarketStructure.bearishBosDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(9, minorMarketStructure.bearishChochDrawing.buffer, INDICATOR_DATA);
    
    SetIndexBuffer(10, minorMarketStructure.minorSwingHighBuffer, INDICATOR_DATA);
    SetIndexBuffer(11, minorMarketStructure.minorSwingLowBuffer, INDICATOR_DATA);
    
    // mother bar fractal
    PlotIndexSetInteger(0, PLOT_ARROW, 158);
    PlotIndexSetInteger(1, PLOT_ARROW, 158);
    
    // swing high low
    PlotIndexSetInteger(4, PLOT_ARROW, 159);
    PlotIndexSetInteger(5, PLOT_ARROW, 159);
    
    PlotIndexSetInteger(10, PLOT_ARROW, 159);
    PlotIndexSetInteger(11, PLOT_ARROW, 159);
    
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
    
    // swing high low arrwo shift
    PlotIndexSetInteger(3,PLOT_ARROW_SHIFT,-10);
    PlotIndexSetInteger(4,PLOT_ARROW_SHIFT,10);
    
    PlotIndexSetInteger(9,PLOT_ARROW_SHIFT,-15);
    PlotIndexSetInteger(10,PLOT_ARROW_SHIFT,15);
    
    //PlotIndexSetInteger(6,PLOT_SHIFT,1);
    //PlotIndexSetInteger(7,PLOT_SHIFT,1);
    //PlotIndexSetInteger(8,PLOT_SHIFT,1);
    //PlotIndexSetInteger(9,PLOT_SHIFT,1);
    
    insideBar.Init();
    impulsePullbackDetector.Init(&insideBar);
    fractal.Init(&impulsePullbackDetector);
    minorMarketStructure.Init(&fractal);
    majorMarketStructure.Init(&fractal,&minorMarketStructure);
    

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
   //2024.01.08 18.00
   //2024.01.09 20.00
   
   //2023.09.05 12.00
   int start = prev_calculated == 0 ? 0 : prev_calculated - 1;

   for (int i = start; i < rates_total; i++) {  // Exclude last unclosed candle
      insideBar.Calculate(i, rates_total, high, low);
      impulsePullbackDetector.Calculate(i, rates_total, high, low);
      fractal.Calculate(i, high, low);
      minorMarketStructure.Calculate(i, rates_total, time, open, high, low, close);
      majorMarketStructure.Calculate();
      
      if(fractal.prevFractalHighIndex != -1 && fractal.prevFractalLowIndex != -1){
         Print("prev high:",time[fractal.prevFractalHighIndex]," | last high:",time[fractal.latestFractalHighIndex]);
         Print("prev low :",time[fractal.prevFractalLowIndex],"  | last low :",time[fractal.latestFractalLowIndex]);
      }
      
   }

   return rates_total;
}