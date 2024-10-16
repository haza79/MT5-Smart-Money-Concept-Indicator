#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2

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

#include "InsideBarClass.mq5";

InsideBarClass insideBar;

double plotMotherBarTopBuffer[];
double plotMotherBarBottomBuffer[];

int OnInit(){
   ////
   insideBar.Init();
   
   SetIndexBuffer(0, plotMotherBarTopBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, plotMotherBarBottomBuffer, INDICATOR_DATA);
   
   PlotIndexSetInteger(0, PLOT_ARROW, 167); // Set arrow symbol for mother bar top
   PlotIndexSetInteger(1, PLOT_ARROW, 167); // Set arrow symbol for mother bar bottom
   
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
   /////
   insideBar.Calculate(rates_total, prev_calculated, high, low);
   for (int i = 0; i < rates_total; i++)
    {
         plotMotherBarTopBuffer[i] = insideBar.GetMotherBarTop(i);
          plotMotherBarBottomBuffer[i] = insideBar.GetMotherBarBottom(i);

        
    }
   return(rates_total);
}
