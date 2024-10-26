#property indicator_chart_window
#property indicator_buffers 8
#property indicator_plots   8

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

#property indicator_label5  "SwingHigh"
#property indicator_type5   DRAW_COLOR_ARROW
#property indicator_color5  clrGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1

#property indicator_label6  "SwingLow"
#property indicator_type6   DRAW_COLOR_ARROW
#property indicator_color6  clrGreen
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1

#include "InsideBarClass.mq5";
#include "ImpulsePullbackDetector.mq5";

InsideBarClass insideBar;
ImpulsePullbackDetectorClass impulsePullbackDetector;


int OnInit()
{

    SetIndexBuffer(0, insideBar.motherBarTopBuffer, INDICATOR_DATA);
    SetIndexBuffer(1, insideBar.motherBarBottomBuffer, INDICATOR_DATA);
    
    SetIndexBuffer(2, impulsePullbackDetector.highZigZagBuffer, INDICATOR_DATA);
    SetIndexBuffer(3, impulsePullbackDetector.lowZigZagBuffer, INDICATOR_DATA);
    
    SetIndexBuffer(4, impulsePullbackDetector.swingHighBuffer, INDICATOR_DATA);
    SetIndexBuffer(5, impulsePullbackDetector.swingLowBuffer, INDICATOR_DATA);
    
    PlotIndexSetInteger(0, PLOT_ARROW, 167); // Set arrow symbol for mother bar top
    PlotIndexSetInteger(1, PLOT_ARROW, 167); // Set arrow symbol for mother bar bottom
    
    PlotIndexSetInteger(4, PLOT_ARROW, 108);
    PlotIndexSetInteger(5, PLOT_ARROW, 108);
    
    PlotIndexSetDouble(2,PLOT_EMPTY_VALUE,0);
    PlotIndexSetDouble(4,PLOT_EMPTY_VALUE,0);
    PlotIndexSetDouble(5,PLOT_EMPTY_VALUE,0);
    
    //PlotIndexSetInteger(4,PLOT_ARROW_SHIFT,1);
    //PlotIndexSetInteger(5,PLOT_ARROW_SHIFT,1);
    
    insideBar.Init();
    impulsePullbackDetector.Init(&insideBar);

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
   
   int start = prev_calculated == 0 ? 0 : prev_calculated - 1;
   
   for (int i = start; i < rates_total; i++){
      insideBar.Calculate(i,rates_total, high, low);
      impulsePullbackDetector.Calculate(i,rates_total,high,low);
      
   }
   
   return rates_total;
}