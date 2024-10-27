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

#property indicator_label3  "SwingHigh"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

#property indicator_label4  "SwingLow"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrGreen
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

#property indicator_label5  "ZigZag"
#property indicator_type5   DRAW_ZIGZAG
#property indicator_color5  clrGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1



#include "InsideBarClass.mq5";
#include "ImpulsePullbackDetector.mq5";

InsideBarClass insideBar;
ImpulsePullbackDetectorClass impulsePullbackDetector;


int OnInit()
{

    SetIndexBuffer(0, insideBar.motherBarTopBuffer, INDICATOR_DATA);
    SetIndexBuffer(1, insideBar.motherBarBottomBuffer, INDICATOR_DATA);
    
    SetIndexBuffer(2, impulsePullbackDetector.highFractalBuffer, INDICATOR_DATA);
    SetIndexBuffer(3, impulsePullbackDetector.lowFractalBuffer, INDICATOR_DATA);
    
    SetIndexBuffer(4, impulsePullbackDetector.highZigZagBuffer, INDICATOR_DATA);
    SetIndexBuffer(5, impulsePullbackDetector.lowZigZagBuffer, INDICATOR_DATA);
    
    // mother bar fractal
    PlotIndexSetInteger(0, PLOT_ARROW, 158);
    PlotIndexSetInteger(1, PLOT_ARROW, 158);
    
    // swing high low
    PlotIndexSetInteger(2, PLOT_ARROW, 159);
    PlotIndexSetInteger(3, PLOT_ARROW, 159);
    
    // zigzag plot empty
    PlotIndexSetDouble(4,PLOT_EMPTY_VALUE,0);
    PlotIndexSetDouble(5,PLOT_EMPTY_VALUE,0);
    
    // swing high low arrwo shift
    PlotIndexSetInteger(2,PLOT_ARROW_SHIFT,-10);
    PlotIndexSetInteger(3,PLOT_ARROW_SHIFT,10);
    
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