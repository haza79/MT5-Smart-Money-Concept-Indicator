//+------------------------------------------------------------------+
//|                                                    InsideBar.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.01"
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4

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

#property indicator_label3  "IsMotherBar"
#property indicator_label4  "IsInsideBar"

double motherBarTopBuffer[], motherBarBottomBuffer[], motherBarBuffer[], insideBarBuffer[];

int motherBarIndex = -1;
double motherBarHigh = 0, motherBarLow = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    SetIndexBuffer(0, motherBarTopBuffer, INDICATOR_DATA);
    SetIndexBuffer(1, motherBarBottomBuffer, INDICATOR_DATA);
    SetIndexBuffer(2, motherBarBuffer, INDICATOR_DATA);
    SetIndexBuffer(3, insideBarBuffer, INDICATOR_DATA);
    
    PlotIndexSetInteger(0, PLOT_ARROW, 167); // Set the arrow symbol for top
    PlotIndexSetInteger(1, PLOT_ARROW, 167); // Set the arrow symbol for bottom
    
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
    int start = prev_calculated > 0 ? prev_calculated - 1 : 1; // Start from the last processed bar

    // Loop only through new bars or modified bars
    for (int i = start; i < rates_total - 1; i++) {
        if (motherBarIndex == -1) {
            if (IsInsideBar(i, high, low)) {
                motherBarIndex = i - 1;
                motherBarHigh = high[i - 1];
                motherBarLow = low[i - 1];

                motherBarTopBuffer[i - 1] = motherBarHigh;
                motherBarBottomBuffer[i - 1] = motherBarLow;

                motherBarTopBuffer[i] = motherBarHigh;
                motherBarBottomBuffer[i] = motherBarLow;
                
                motherBarBuffer[i-1] = 1;
                insideBarBuffer[i] = 1;
                
            } else {
                motherBarTopBuffer[i] = EMPTY_VALUE;
                motherBarBottomBuffer[i] = EMPTY_VALUE;
            }
        } else {
            if (IsInsideMotherBar(i, high, low)) {
                motherBarTopBuffer[i] = motherBarHigh;
                motherBarBottomBuffer[i] = motherBarLow;
                
                insideBarBuffer[i] = 1;
            } else {
                motherBarIndex = -1;  // Reset the mother bar when the condition breaks
            }
        }
    }

    return rates_total; // Return total number of rates processed
}

bool IsInsideBar(int index, const double &high[], const double &low[]) {
    double prevHigh = high[index - 1];
    double prevLow = low[index - 1];
    
    double currHigh = high[index];
    double currLow = low[index];

    return (currHigh < prevHigh && currLow > prevLow);
}

bool IsInsideMotherBar(int index, const double &high[], const double &low[]) {
    double currHigh = high[index];
    double currLow = low[index];

    return (currHigh < motherBarHigh && currLow > motherBarLow);
}
