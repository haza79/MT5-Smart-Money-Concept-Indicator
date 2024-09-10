//+------------------------------------------------------------------+
//|                                                     MultiLineBuffer.mq5 |
//|                        Custom Indicator Example                  |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue
#property indicator_width1 2

//--- Buffers
double PBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   //--- Indicator buffer setup
   SetIndexBuffer(0, PBuffer, INDICATOR_DATA);
   PlotIndexSetInteger(0, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetInteger(0, PLOT_LINE_COLOR, clrBlue);
   PlotIndexSetInteger(0, PLOT_LINE_WIDTH, 2);
   PlotIndexSetInteger(0, PLOT_LINE_STYLE, STYLE_DASH);

   //--- Name the indicator
   IndicatorSetString(INDICATOR_SHORTNAME, "Multiple Lines Example");

   //--- Everything is OK
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom function to draw a straight line                          |
//+------------------------------------------------------------------+
void DrawStraightLine(double &buffer[], int startIndex, int endIndex, double startValue)
  {
   //--- Draw a flat straight line between startIndex and endIndex
   for(int i = startIndex; i <= endIndex; i++)
     {
      buffer[i] = startValue;
     }
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
   //--- Check if there's enough data
   if(rates_total < 100)
      return(0);

   //--- Initialize buffer to clear any previous data
   ArrayInitialize(PBuffer, EMPTY_VALUE);

   //--- Example: Draw multiple lines at different levels
   // Line 1: Draw from index 50 to 100
   int startIndex1 = rates_total-100;
   int endIndex1 = rates_total-50;
   double startValue1 = close[startIndex1];

   // Line 2: Draw from index 120 to 150
   int startIndex2 = rates_total-50;
   int endIndex2 = rates_total-10;
   double startValue2 = low[startIndex2];


   //--- Draw the lines
   DrawStraightLine(PBuffer, startIndex1, endIndex1, startValue1);
   DrawStraightLine(PBuffer, startIndex2, endIndex2, startValue2);

   //--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
