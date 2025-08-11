#property indicator_chart_window
#property indicator_buffers 20
#property indicator_plots   20

#property indicator_label1  "MACD High"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrDarkOrange
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "MACD Low"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrDarkOrange
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "Major High"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrRoyalBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

#property indicator_label4  "Major Low"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrCrimson
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

#property indicator_label5  "bullish bos"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrGreen
#property indicator_style5  STYLE_DASH
#property indicator_width5  1

#property indicator_label6  "bullish choch"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrRed
#property indicator_style6  STYLE_DASH
#property indicator_width6  1

#property indicator_label7  "bearish bos"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrGreen
#property indicator_style7  STYLE_DASH
#property indicator_width7  1

#property indicator_label8  "bearish choch"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrRed
#property indicator_style8  STYLE_DASH
#property indicator_width8  1

#property indicator_label9  "inducement"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrYellow
#property indicator_style9  STYLE_DASH
#property indicator_width9  1

#property indicator_label10  "bos ray"
#property indicator_type10   DRAW_LINE
#property indicator_color10  clrGreen
#property indicator_style10  STYLE_DOT
#property indicator_width10  1

#property indicator_label11  "choch ray"
#property indicator_type11   DRAW_LINE
#property indicator_color11  clrRed
#property indicator_style11  STYLE_DOT
#property indicator_width11  1

#property indicator_label12  "inducement ray"
#property indicator_type12   DRAW_LINE
#property indicator_color12  clrYellow
#property indicator_style12  STYLE_DASH
#property indicator_width12  1

#property indicator_label13  "fibo retrace 50"
#property indicator_type13   DRAW_LINE
#property indicator_color13  clrGold
#property indicator_style13  STYLE_DASH
#property indicator_width13  1

#property indicator_label14  "fibo retrace 61.8"
#property indicator_type14   DRAW_LINE
#property indicator_color14  clrSilver
#property indicator_style14  STYLE_DASH
#property indicator_width14  1

#property indicator_label15  "fibo retrace 78.6"
#property indicator_type15   DRAW_LINE
#property indicator_color15  clrSilver
#property indicator_style15  STYLE_DASH
#property indicator_width15  1

#property indicator_label16  "fibo retrace 88.7"
#property indicator_type16   DRAW_LINE
#property indicator_color16  clrSilver
#property indicator_style16  STYLE_DASH
#property indicator_width16  1




#include "BarData.mqh";
#include "InsideBarClass.mqh";
#include "ImpulsePullbackDetector.mqh";
#include "CandleStructs.mqh"
#include "CandleBreakAnalyzer.mqh";
#include "Fractal.mqh";
#include "MACD.mqh";
#include "MACDFractal.mqh";
#include "MacdMarketStructure.mqh";
#include "Fibonacci.mqh";
#include "PlotFiboOnChart.mqh";
#include "BalanceOfPower.mqh";
#include "BalanceOfPowerReverseCandle.mqh";
#include "OrderBlock.mqh";


MACD macd;
BarData barData;
MACDFractalClass macdFractal;
MacdMarketStructureClass macdMarketStructure;
InsideBarClass insideBar;
ImpulsePullbackDetectorClass impulsePullbackDetector;
CandleBreakAnalyzerClass candleBreakAnalyzer;
FractalClass fractal;
Fibonacci fibonacci;
PlotFiboOnChart plotFiboOnChart;
BalanceOfPower balanceOfPower;
BalanceOfPowerReverseCandle balanceOfPowerReverseCandle;
OrderBlock orderBlock;

double FibUpper[], FibLower[];  

int OnInit()
{  
    
    SetIndexBuffer(0, macdFractal.macdHighFractalBuffer, INDICATOR_DATA);
    SetIndexBuffer(1, macdFractal.macdLowFractalBuffer, INDICATOR_DATA);
    PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,-15);
    PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,15);
    PlotIndexSetInteger(0, PLOT_ARROW, 161);
    PlotIndexSetInteger(1, PLOT_ARROW, 161);
    
    SetIndexBuffer(2, macdMarketStructure.majorSwingHighBuffer, INDICATOR_DATA);
    SetIndexBuffer(3, macdMarketStructure.majorSwingLowBuffer, INDICATOR_DATA);
    PlotIndexSetInteger(2, PLOT_ARROW, 217);
    PlotIndexSetInteger(3, PLOT_ARROW, 218);
    PlotIndexSetInteger(2,PLOT_ARROW_SHIFT,-20);
    PlotIndexSetInteger(3,PLOT_ARROW_SHIFT,20);
    
    
    SetIndexBuffer(4, macdMarketStructure.bullishBosDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(5, macdMarketStructure.bullishChochDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(6, macdMarketStructure.bearishBosDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(7, macdMarketStructure.bearishChochDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(8, macdMarketStructure.inducementDrawing.buffer, INDICATOR_DATA);
    
    SetIndexBuffer(9, macdMarketStructure.bosRay.lineDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(10, macdMarketStructure.chochRay.lineDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(11, macdMarketStructure.inducementRay.lineDrawing.buffer, INDICATOR_DATA);
    
    SetIndexBuffer(12, plotFiboOnChart.fibo_retrace_500_ray.lineDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(13, plotFiboOnChart.fibo_retrace_618_ray.lineDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(14, plotFiboOnChart.fibo_retrace_786_ray.lineDrawing.buffer, INDICATOR_DATA);
    SetIndexBuffer(15, plotFiboOnChart.fibo_retrace_887_ray.lineDrawing.buffer, INDICATOR_DATA);
    
   //SetIndexBuffer(17, balanceOfPowerReverseCandle.bearishReverse, INDICATOR_DATA);
   //SetIndexBuffer(18, balanceOfPowerReverseCandle.bullishReverse, INDICATOR_DATA);
   //PlotIndexSetInteger(21, PLOT_ARROW, 234);
   //PlotIndexSetInteger(22, PLOT_ARROW, 233);
    
    // mother bar fractal
    
    
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
    PlotIndexSetDouble(12,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(13,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(14,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(15,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(16,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(17,PLOT_EMPTY_VALUE,EMPTY_VALUE);
    PlotIndexSetDouble(18,PLOT_EMPTY_VALUE,EMPTY_VALUE);

   balanceOfPowerReverseCandle.init(&balanceOfPower,&barData);
    insideBar.Init();
    impulsePullbackDetector.Init(&insideBar);
    fractal.Init(&impulsePullbackDetector);
    macdFractal.Init(&macd,&barData);
    macdMarketStructure.init(&macdFractal,&barData,&fractal);
    fibonacci.init(&barData,&macdMarketStructure);
    plotFiboOnChart.init(&fibonacci,&barData);
    orderBlock.Init(&barData,&macdMarketStructure,&fractal,&insideBar,&fibonacci);
    

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

/*
   ArrayResize(FibUpper,rates_total);
   ArrayResize(FibLower,rates_total);
   
   for(int i = rates_total-1; i>rates_total-100; i--){
      FibUpper[i] = high[rates_total-100];
      FibLower[i] = low[rates_total-100];
   }*/
   
   

   //int start = MathMax(rates_total - 500, 0);// for limit candle to process
   int start = prev_calculated == 0 ? 0 : prev_calculated - 1; // for normal use
   //verticalLineBuffer[rates_total-10] = high[rates_total-10] * 10;

   for (int i = start; i < rates_total; i++) {  // Exclude last unclosed candle
      Print(i);
      balanceOfPower.update(i,open[i],high[i],low[i],close[i],rates_total,3);
      balanceOfPowerReverseCandle.update(i,rates_total);
      macd.update(close[i],i,rates_total);
      if(i > rates_total - 1618){
         insideBar.Calculate(i, rates_total, high, low);
         impulsePullbackDetector.Calculate(i, rates_total, high, low);
         macdFractal.Update(i);
         fractal.Calculate(i, high, low, rates_total);
         macdMarketStructure.update(i,rates_total);
         fibonacci.update(i,rates_total);
         plotFiboOnChart.update(i,rates_total);
         orderBlock.update(i,rates_total);
      }else{
         
         macdFractal.macdHighFractalBuffer[i] = EMPTY_VALUE;
         macdFractal.macdLowFractalBuffer[i] = EMPTY_VALUE;
         macdMarketStructure.majorSwingHighBuffer[i] = EMPTY_VALUE;
         macdMarketStructure.majorSwingLowBuffer[i] = EMPTY_VALUE;
      }
      
      
      
      

      }
      
      /*
      static string lastComment = "";
      string newComment = 
      "Trend: " + macdMarketStructure.getLatestTrendAsString() + "\n"
      +"Inducement Break: "+macdMarketStructure.isInducementBreak;

      if(newComment != lastComment) {
          Comment(newComment);
          lastComment = newComment;
      }*/
      
      /*
      string comment = "TREND :  "+macdMarketStructure.getLatestTrendAsString()+"\n"
      +"Inducement Taken   :  "+macdMarketStructure.isInducementBreak;
      Comment(comment);
      */
      

   return rates_total;
   
}