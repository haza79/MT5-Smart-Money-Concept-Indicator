//+------------------------------------------------------------------+
//|                                                          SMC.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 11 
#property indicator_plots   11

#property indicator_label1  "inside bar"
#property indicator_label2  "mother bar"

//--- plot swing high
#property indicator_label3  "swing high"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

//--- plot swing low
#property indicator_label4  "swing low"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

//--- plot ZigZag
#property indicator_label5  "ZigZag"
#property indicator_type5   DRAW_ZIGZAG
#property indicator_color5  clrBlue
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1

//--- plot Fractal
#property indicator_label7  "Fractal Up"
#property indicator_type7  DRAW_ARROW
#property indicator_color7  clrGreen
#property indicator_style7  STYLE_SOLID
#property indicator_width7  1

//--- plot Fractal
#property indicator_label8  "Fractal Down"
#property indicator_type8  DRAW_ARROW
#property indicator_color8  clrRed
#property indicator_style8  STYLE_SOLID
#property indicator_width8  1

double motherBarCandleHandle[];
double insideBarCandleHandle[];
double zzBuffer[];
double swingHighBuffer[];
double swingLowBuffer[];
double ZigZagBuffer1[];
double ZigZagBuffer2[];
double FractalUpBuffer[];
double FractalDownBuffer[];

int motherBarIndex = 0;

int rectangleHandle;
string rectangleNameHandle;
datetime x1TimeHandle;
datetime x2TimeHandle;
double y1PriceHandle;
double y2PriceHandle;
string colorHandle;

int motherBarIndexHandleForSwing = -1;
string marketPhase = NULL;

int    ExtArrowShift=-10;

int lastSwingHighIndex,
   lastSwingLowIndex,
   prevSwingHighIndex,
   prevSwingLowIndex,
   lastHighFractalIndex,
   lastLowFractalIndex,
   prevHighFractalIndex,
   prevLowFractalIndex;

int fractalIndex = 1;

struct InsideBarS{

   bool insideBarDetected;
   int motherBarIndex;
   int motherBarIndexHandleForSwing;
   
   InsideBarS(bool _insideBarDetected = false,
            int _motherBarIndex = 0,
            int _motherBarIndexHandleForSwing = -1)
   :insideBarDetected(_insideBarDetected),
      motherBarIndex(_motherBarIndex),
      motherBarIndexHandleForSwing(_motherBarIndexHandleForSwing)
   {}

};

struct MinorMarketStructureS {

   string minorMarketPhase;
   string biasMinorMarketPhase;
   
   int biasMinorSwingHighIndex;
   int biasMinorSwingLowIndex;
   int latestMinorSwingHighIndex;
   int latestMinorSwingLowIndex;
   
   double swingHighPrice;
   double swingLowPrice;
   
   bool isHighBreakByWick;
   int latestWickHighIndex;
   int swingHighObjectIndex;
   string swingHighObjectNames[];
   
   bool isLowBreakByWick;
   int latestWickLowIndex;
   int swingLowObjectIndex;
   string swingLowObjectNames[];
   
   string highObjNameHandle;
   string lowObjNameHandle;
   
   MinorMarketStructureS(bool _isHighBreakByWick = false, 
                        int _swingHighObjectIndex = 0,
                        bool _isLowBreakByWick = false,
                        int _swingLowObjectIndex = 0)
                        :isHighBreakByWick(_isHighBreakByWick),
                        swingHighObjectIndex(_swingHighObjectIndex),
                        isLowBreakByWick(_isLowBreakByWick),
                        swingLowObjectIndex(_swingLowObjectIndex)
                        {}
   
   /*
   MinorMarketStructureS(string _minorMarketPhase = NULL,
                        string _biasMinorMarketPhase = NULL,
                        int _biasMinorSwingHighIndex = NULL,
                        int _biasMinorSwingLowIndex = NULL,
                        int _latestMinorSwingHighIndex = NULL,
                        int _latestMinorSwingLowIndex = NULL,
                        bool _isHighBreakByWick = false,
                        bool _isLowBreakByWick = false,
                        string _highObjNameHandle = NULL,
                        string _lowObjNameHandle = NULL)
                        :minorMarketPhase(_minorMarketPhase),
                        biasMinorMarketPhase(_biasMinorMarketPhase),
                        biasMinorSwingHighIndex(_biasMinorSwingHighIndex),
                        biasMinorSwingLowIndex(_biasMinorSwingLowIndex),
                        latestMinorSwingHighIndex(_latestMinorSwingHighIndex),
                        latestMinorSwingLowIndex(_latestMinorSwingLowIndex),
                        isHighBreakByWick(_isHighBreakByWick),
                        isLowBreakByWick(_isLowBreakByWick),
                        highObjNameHandle(_highObjNameHandle),
                        lowObjNameHandle(_lowObjNameHandle)
                        
                        {}
                        */
   
};

        
        
struct Gap{

   bool exists;
   double gapStart;
   double gapEnd;
   string trend;
   
};



MinorMarketStructureS minorMarketStructureS;
InsideBarS insideBarS;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   // indicator buffer mapping
   SetIndexBuffer(0,insideBarCandleHandle,INDICATOR_DATA);
   SetIndexBuffer(1,motherBarCandleHandle,INDICATOR_DATA);
   
   SetIndexBuffer(2,swingHighBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,swingLowBuffer,INDICATOR_DATA);
   
   SetIndexBuffer(4,ZigZagBuffer1,INDICATOR_DATA);
   SetIndexBuffer(5,ZigZagBuffer2,INDICATOR_DATA);
   
   SetIndexBuffer(7,FractalUpBuffer,INDICATOR_DATA);
   SetIndexBuffer(8,FractalDownBuffer,INDICATOR_DATA);

   // set the indicator label
   
   PlotIndexSetString(4,PLOT_LABEL,"ZigZag High;ZigZag Low");
   
   PlotIndexSetInteger(2,PLOT_ARROW,159);
   PlotIndexSetInteger(3,PLOT_ARROW,159);
   
   PlotIndexSetInteger(6,PLOT_ARROW,119);
   PlotIndexSetInteger(7,PLOT_ARROW,119);
   
   PlotIndexSetInteger(2,PLOT_ARROW_SHIFT,ExtArrowShift);
   PlotIndexSetInteger(3,PLOT_ARROW_SHIFT,-ExtArrowShift);
   
   PlotIndexSetInteger(6,PLOT_ARROW_SHIFT,(ExtArrowShift*2));
   PlotIndexSetInteger(7,PLOT_ARROW_SHIFT,(-(ExtArrowShift*2)));
   
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

   int start = prev_calculated - 1;
   if (start < 1) start = 1; // Ensure we start from the second candle

   ArrayInitialize(insideBarCandleHandle,EMPTY_VALUE);
   ArrayInitialize(motherBarCandleHandle,EMPTY_VALUE);
   ArrayInitialize(swingHighBuffer,EMPTY_VALUE);
   ArrayInitialize(swingLowBuffer,EMPTY_VALUE);
   ArrayInitialize(zzBuffer,EMPTY_VALUE);
   ArrayInitialize(ZigZagBuffer1,EMPTY_VALUE);
   ArrayInitialize(ZigZagBuffer2,EMPTY_VALUE);
   ArrayInitialize(FractalUpBuffer,EMPTY_VALUE);
   ArrayInitialize(FractalDownBuffer,EMPTY_VALUE);
   
   for(int i = start; i < rates_total; i++){

      if(i>=1){
      
         insideBarDetector(
            time[i-1],
            time[i],
            open[i-1],
            open[i],
            high[i-1],
            high[i],
            low[i-1],
            low[i],
            close[i-1],
            close[i],
            high[motherBarIndex],
            low[motherBarIndex],
            i
         );
         
         impulsePullbackDetector(
            i,
            high,
            low,
            rates_total
         );
         
         

         //============ start

         if(minorMarketStructureS.minorMarketPhase == NULL){
            // initialize bias 
            if(minorMarketStructureS.biasMinorMarketPhase == NULL &&
               prevHighFractalIndex != lastHighFractalIndex && prevLowFractalIndex != lastLowFractalIndex){
            
              minorMarketStructureS.biasMinorSwingHighIndex = lastHighFractalIndex;
              minorMarketStructureS.biasMinorSwingLowIndex = lastLowFractalIndex;
              
              
              if(minorMarketStructureS.biasMinorSwingHighIndex > minorMarketStructureS.biasMinorSwingLowIndex){
              
                  minorMarketStructureS.biasMinorMarketPhase = "BULLISH";
              
              }else if(minorMarketStructureS.biasMinorSwingLowIndex > minorMarketStructureS.biasMinorSwingHighIndex){
              
                  minorMarketStructureS.biasMinorMarketPhase = "BEARISH";
              
              }
            
            }
            // end initialize bias
            
            if(minorMarketStructureS.biasMinorMarketPhase == "BULLISH"){
               if(isSwingBreakByBody(open,close,i,high[minorMarketStructureS.biasMinorSwingHighIndex],"high") ||
                  isSwingBreakByGap(open,high,low,close,i,high[minorMarketStructureS.biasMinorSwingHighIndex],"high")){
               
                  minorMarketStructureS.minorMarketPhase = "BULLISH";
                  int lowestPriceIndex = getLowestPriceIndexInRange(low,minorMarketStructureS.biasMinorSwingHighIndex,i);
                  minorMarketStructureS.latestMinorSwingLowIndex = lowestPriceIndex;
                  minorMarketStructureS.latestMinorSwingHighIndex = minorMarketStructureS.biasMinorSwingHighIndex;
                  
                  minorMarketStructureS.biasMinorSwingHighIndex = NULL;
                  
                  drawBosLine(high,low,time,"high",minorMarketStructureS.latestMinorSwingHighIndex,i,objectNameGenerator("bos",time[i]));
               
                  
                  
                  
               }else if(isSwingBreakByWick(open,high,low,close,i,high[minorMarketStructureS.biasMinorSwingHighIndex],"high")){
               
                  drawBosLine(high,low,time,"high",minorMarketStructureS.biasMinorSwingHighIndex,i,objectNameGenerator("bos",time[i]));
                  minorMarketStructureS.biasMinorSwingHighIndex = i;
               
               }
               
               if(isSwingBreakByBody(open,close,i,low[minorMarketStructureS.biasMinorSwingLowIndex],"low") ||
                  isSwingBreakByGap(open,high,low,close,i,low[minorMarketStructureS.biasMinorSwingLowIndex],"low")){
               
                  minorMarketStructureS.minorMarketPhase = "BEARISH";
                  minorMarketStructureS.latestMinorSwingLowIndex = minorMarketStructureS.biasMinorSwingLowIndex;
                  minorMarketStructureS.latestMinorSwingHighIndex = minorMarketStructureS.biasMinorSwingHighIndex;
                  
                  minorMarketStructureS.biasMinorSwingHighIndex = NULL;
                  minorMarketStructureS.biasMinorSwingLowIndex = NULL;
                  
                  drawBosLine(high,low,time,"low",minorMarketStructureS.latestMinorSwingLowIndex,i,objectNameGenerator("bos",time[i]));
                                    
                  
               }else if(isSwingBreakByWick(open,high,low,close,i,low[minorMarketStructureS.biasMinorSwingLowIndex],"low")){
               
                  drawBosLine(high,low,time,"low",minorMarketStructureS.biasMinorSwingLowIndex,i,objectNameGenerator("bos",time[i]));
                  minorMarketStructureS.biasMinorSwingLowIndex = i;
               
               }
            
            }else if(minorMarketStructureS.biasMinorMarketPhase == "BEARISH"){
               
               if(isSwingBreakByBody(open,close,i,low[minorMarketStructureS.biasMinorSwingLowIndex],"low") ||
                  isSwingBreakByGap(open,high,low,close,i,low[minorMarketStructureS.biasMinorSwingLowIndex],"low")){
               
                  minorMarketStructureS.minorMarketPhase = "BEARISH";
                  int highestPriceIndex = getHighestPriceIndexInRange(high,minorMarketStructureS.biasMinorSwingLowIndex,i);
                  minorMarketStructureS.latestMinorSwingHighIndex = highestPriceIndex;
                  minorMarketStructureS.latestMinorSwingLowIndex = minorMarketStructureS.biasMinorSwingLowIndex;
                  
                  minorMarketStructureS.biasMinorSwingHighIndex = NULL;
                  minorMarketStructureS.biasMinorSwingLowIndex = NULL;
                  
                  drawBosLine(high,low,time,"low",minorMarketStructureS.latestMinorSwingLowIndex,i,objectNameGenerator("bos",time[i]));
                  
                  
                  
               }else if(isSwingBreakByWick(open,high,low,close,i,low[minorMarketStructureS.biasMinorSwingLowIndex],"low")){
               
                  drawBosLine(high,low,time,"low",minorMarketStructureS.biasMinorSwingLowIndex,i,objectNameGenerator("bos",time[i]));
                  minorMarketStructureS.biasMinorSwingLowIndex = i;
               
               }
               
               
               if(isSwingBreakByBody(open,close,i,high[minorMarketStructureS.biasMinorSwingHighIndex],"high") ||
                  isSwingBreakByGap(open,high,low,close,i,high[minorMarketStructureS.biasMinorSwingHighIndex],"high")){
               
                  minorMarketStructureS.minorMarketPhase = "BULLISH";
                  minorMarketStructureS.latestMinorSwingLowIndex = minorMarketStructureS.biasMinorSwingLowIndex;
                  minorMarketStructureS.latestMinorSwingHighIndex = minorMarketStructureS.biasMinorSwingHighIndex;
                  
                  minorMarketStructureS.biasMinorSwingHighIndex = NULL;
                  minorMarketStructureS.biasMinorSwingLowIndex = NULL;
                  
                  drawBosLine(high,low,time,"high",minorMarketStructureS.latestMinorSwingHighIndex,i,objectNameGenerator("bos",time[i]));
                  
               }else if(isSwingBreakByWick(open,high,low,close,i,high[minorMarketStructureS.biasMinorSwingHighIndex],"high")){
               
                  drawBosLine(high,low,time,"high",minorMarketStructureS.biasMinorSwingHighIndex,i,objectNameGenerator("bos",time[i]));
                  minorMarketStructureS.biasMinorSwingHighIndex = i;
               
               }
               
               
               
            
            }
            
         
         }
         // Minor Market Trend Are Not Empty (initialized)
         else{
         
            if(minorMarketStructureS.minorMarketPhase == "BULLISH"){
            
               if(minorMarketStructureS.biasMinorSwingHighIndex == NULL &&
                  high[lastHighFractalIndex] > high[minorMarketStructureS.latestMinorSwingHighIndex]){
               
                  minorMarketStructureS.biasMinorSwingHighIndex = lastHighFractalIndex;
               
               }
               
               
               if(isSwingBreakByBody(open,close,i,high[minorMarketStructureS.biasMinorSwingHighIndex],"high") ||
                  isSwingBreakByGap(open,high,low,close,i,high[minorMarketStructureS.biasMinorSwingHighIndex],"high")){
               
                  int lowestPriceIndex = getLowestPriceIndexInRange(low,minorMarketStructureS.biasMinorSwingHighIndex,i);
                  minorMarketStructureS.latestMinorSwingLowIndex = lowestPriceIndex;
                  minorMarketStructureS.latestMinorSwingHighIndex = minorMarketStructureS.biasMinorSwingHighIndex;
                  
                  minorMarketStructureS.biasMinorSwingHighIndex = NULL;
                  minorMarketStructureS.biasMinorSwingLowIndex = NULL;
                  
                  drawBosLine(high,low,time,"high",minorMarketStructureS.latestMinorSwingHighIndex,i,objectNameGenerator("bos",time[i]));
                  
               }else if(isSwingBreakByWick(open,high,low,close,i,high[minorMarketStructureS.biasMinorSwingHighIndex],"high")){
               
                  drawBosLine(high,low,time,"high",minorMarketStructureS.biasMinorSwingHighIndex,i,objectNameGenerator("bos",time[i]));
                  minorMarketStructureS.biasMinorSwingHighIndex = i;
               
               }
               
               
               if(isSwingBreakByBody(open,close,i,low[minorMarketStructureS.latestMinorSwingLowIndex],"low") ||
                  isSwingBreakByGap(open,high,low,close,i,low[minorMarketStructureS.latestMinorSwingLowIndex],"low")){
               
                  minorMarketStructureS.minorMarketPhase = "BEARISH";
                  minorMarketStructureS.latestMinorSwingHighIndex = minorMarketStructureS.biasMinorSwingHighIndex;
                  
                  minorMarketStructureS.biasMinorSwingHighIndex = NULL;
                  minorMarketStructureS.biasMinorSwingLowIndex = NULL;
                  
                  drawBosLine(high,low,time,"low",minorMarketStructureS.latestMinorSwingLowIndex,i,objectNameGenerator("bos",time[i]));
                                    
                  
               }else if(isSwingBreakByWick(open,high,low,close,i,low[minorMarketStructureS.latestMinorSwingLowIndex],"low")){
               
                  drawBosLine(high,low,time,"low",minorMarketStructureS.latestMinorSwingLowIndex,i,objectNameGenerator("bos",time[i]));
                  minorMarketStructureS.latestMinorSwingLowIndex = i;
               
               }
               
               
               
               
               
               
            }else if(minorMarketStructureS.minorMarketPhase == "BEARISH"){
               
               if(minorMarketStructureS.biasMinorSwingLowIndex == NULL &&
                  low[lastLowFractalIndex] < low[minorMarketStructureS.latestMinorSwingLowIndex]){
               
                  minorMarketStructureS.biasMinorSwingLowIndex = lastLowFractalIndex;
               
               }
               
               if(isSwingBreakByBody(open,close,i,low[minorMarketStructureS.biasMinorSwingLowIndex],"low") ||
                  isSwingBreakByGap(open,high,low,close,i,low[minorMarketStructureS.biasMinorSwingLowIndex],"low")){
               
                  int highestPriceIndex = getHighestPriceIndexInRange(high,minorMarketStructureS.biasMinorSwingLowIndex,i);
                  minorMarketStructureS.latestMinorSwingHighIndex = highestPriceIndex;
                  minorMarketStructureS.latestMinorSwingLowIndex = minorMarketStructureS.biasMinorSwingLowIndex;
                  
                  minorMarketStructureS.biasMinorSwingHighIndex = NULL;
                  minorMarketStructureS.biasMinorSwingLowIndex = NULL;
                  
                  drawBosLine(high,low,time,"low",minorMarketStructureS.latestMinorSwingLowIndex,i,objectNameGenerator("bos",time[i]));
                  
                  
                  
               }else if(isSwingBreakByWick(open,high,low,close,i,low[minorMarketStructureS.biasMinorSwingLowIndex],"low")){
               
                  drawBosLine(high,low,time,"low",minorMarketStructureS.biasMinorSwingLowIndex,i,objectNameGenerator("bos",time[i]));
                  minorMarketStructureS.biasMinorSwingLowIndex = i;
               
               }
               
               
               if(isSwingBreakByBody(open,close,i,high[minorMarketStructureS.latestMinorSwingHighIndex],"high") ||
                  isSwingBreakByGap(open,high,low,close,i,high[minorMarketStructureS.latestMinorSwingHighIndex],"high")){
               
                  minorMarketStructureS.minorMarketPhase = "BULLISH";
                  minorMarketStructureS.latestMinorSwingLowIndex = minorMarketStructureS.biasMinorSwingLowIndex;
                  
                  minorMarketStructureS.biasMinorSwingHighIndex = NULL;
                  minorMarketStructureS.biasMinorSwingLowIndex = NULL;
                  
                  drawBosLine(high,low,time,"high",minorMarketStructureS.latestMinorSwingHighIndex,i,objectNameGenerator("bos",time[i]));
                  
               }else if(isSwingBreakByWick(open,high,low,close,i,high[minorMarketStructureS.latestMinorSwingHighIndex],"high")){
               
                  drawBosLine(high,low,time,"high",minorMarketStructureS.latestMinorSwingHighIndex,i,objectNameGenerator("bos",time[i]));
                  minorMarketStructureS.latestMinorSwingHighIndex = i;
               
               }
               
               
               
            
            }
            
            
            
            
            
            
            
            
            
            
            
            
         
         }

         //============ end
         

         
         
         
         
         
      }
      
      
      
   }
   

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


void drawBosLine(const double &high[], const double &low[], const datetime &time[], string swingType ,int startIndex, int endIndex,string objName){

   if(swingType == "high"){
   
      ObjectCreate(0,objName,OBJ_TREND,0,time[startIndex],high[startIndex],time[endIndex],high[startIndex]);
   
   }else if(swingType == "low"){
   
      ObjectCreate(0,objName,OBJ_TREND,0,time[startIndex],low[startIndex],time[endIndex],low[startIndex]);
   
   }

}

// Function to find the index of the lowest price in a given range
int getLowestPriceIndexInRange(const double &low[], int startIndex, int endIndex) {
    int lowestIndex = startIndex;
    double lowestLow = low[startIndex];
    
    for (int i = startIndex + 1; i <= endIndex; i++) {
        if (low[i] < lowestLow) {
            lowestLow = low[i];
            lowestIndex = i;
        }
    }
    
    return lowestIndex;
}

// Function to find the index of the highest price in a given range
int getHighestPriceIndexInRange(const double &high[], int startIndex, int endIndex) {
    int highestIndex = startIndex;
    double highestHigh = high[startIndex];
    
    for (int i = startIndex + 1; i <= endIndex; i++) {
        if (high[i] > highestHigh) {
            highestHigh = high[i];
            highestIndex = i;
        }
    }
    
    return highestIndex;
}

bool isSwingBreakByBody(const double &open[], const double &close[], int index, double swingPrice, string swingType) {
    if (index <= 0) return false;

    double currOpen = open[index];
    double currClose = close[index];

    bool currBullish = currClose > currOpen;
    bool currBearish = currClose < currOpen;

    if (swingType == "high") {
        return (currBullish && swingPrice <= currClose && swingPrice >= currOpen) ||
               (currBearish && swingPrice <= currOpen && swingPrice >= currClose);
    } else if (swingType == "low") {
        return (currBullish && swingPrice <= currClose && swingPrice >= currOpen) ||
               (currBearish && swingPrice <= currOpen && swingPrice >= currClose);
    }

    return false;
}

bool isSwingBreakByWick(const double &open[], const double &high[], const double &low[], const double &close[], int index, double swingPrice, string swingType) {
    bool currBullish = close[index] > open[index];
    bool currBearish = close[index] < open[index];
    bool currDoji = close[index] == open[index];

    if (swingType == "high") {
        return (currBullish && swingPrice > close[index] && swingPrice <= high[index]) ||
               (currBearish && swingPrice > open[index] && swingPrice <= high[index]) ||
               (currDoji && swingPrice > close[index] && swingPrice < high[index]);
    } else if (swingType == "low") {
        return (currBullish && swingPrice < open[index] && swingPrice >= low[index]) ||
               (currBearish && swingPrice < close[index] && swingPrice >= low[index]) ||
               (currDoji && swingPrice < close[index] && swingPrice >= low[index]);
    }

    return false;
}

bool isSwingBreakByGap(const double &open[], const double &high[], const double &low[], const double &close[], int index, double swingPrice, string swingType) {
    Gap gap = identifyGap(open, high, low, close, index);
    if (gap.exists) {
        if (swingType == "high" && swingPrice <= gap.gapEnd && swingPrice >= gap.gapStart) {
            return true;
        } else if (swingType == "low" && swingPrice >= gap.gapEnd && swingPrice <= gap.gapStart) {
            return true;
        }
    }

    return false;
}

Gap identifyGap(const double &open[], const double &high[], const double &low[], const double &close[], int index) {
    Gap gap;
    gap.exists = false;

    if (index <= 0) return gap;

    double prevHigh = high[index - 1];
    double prevLow = low[index - 1];
    double currOpen = open[index];
    double currClose = close[index];
    double currHigh = high[index];
    double currLow = low[index];

    if (currHigh > prevHigh) {
        gap.trend = "BULLISH";
        if ((currClose > currOpen && currOpen > prevHigh) || (currClose < currOpen && currClose > prevHigh)) {
            gap.exists = true;
            gap.gapStart = prevHigh;
            gap.gapEnd = (currClose > currOpen) ? currOpen : currClose;
        }
    } else if (currLow < prevLow) {
        gap.trend = "BEARISH";
        if ((currClose < currOpen && currOpen < prevLow) || (currClose > currOpen && currClose < prevLow)) {
            gap.exists = true;
            gap.gapStart = prevLow;
            gap.gapEnd = (currClose < currOpen) ? currOpen : currClose;
        }
    }

    return gap;
}


//+------------------------------------------------------------------+
//| Custom indicator impulse pullback detector                       |
//+------------------------------------------------------------------+

void impulsePullbackDetector(
int i,
const double &high[],
const double &low[],
int rates_total
){

   int prevCandle;
   
   // is prev candle are mother bar
   if(motherBarCandleHandle[i-1] == 1){
   
      motherBarIndexHandleForSwing = i-1;
   
   }
   
   // is curr candle are inside bar
   if(insideBarCandleHandle[i] == 1){
   
      //zzBuffer[i] = EMPTY_VALUE;
      return;
   
   }
   
   // is prev candle are inside bar
   if(insideBarCandleHandle[i-1] == 1){
   
      prevCandle = motherBarIndexHandleForSwing;
   
   }else{
   
      prevCandle = i-1;
   
   }
   
   // is market phase are empty
   if(marketPhase==NULL){
   
      // is curr candle are making higher high
      if(high[i] > high[prevCandle]){
      
         marketPhase = "BULLISH IMPULSE";
      
      // is curr candle are making lower low
      }else if(low[i] < low[prevCandle]){
      
         marketPhase = "BEARISH IMPULSE";
      
      }
      
      return;
   
   }else{
      
      // market phase
      // bullish impluse
      if(marketPhase == "BULLISH IMPULSE"){
      
         // is curr candle make lower low and higher high
         if(low[i] < low[prevCandle] && high[i] > high[prevCandle]){
         
            // pullback
            // mark prev high
            swingHighBuffer[prevCandle] = high[prevCandle];
            ZigZagBuffer1[prevCandle] = high[prevCandle];
            
            if(prevCandle-1 >= 0 && high[prevCandle] >= high[prevCandle+1] && high[prevCandle] >= high[prevCandle-1]){
               FractalUpBuffer[prevCandle] = high[prevCandle];
               prevHighFractalIndex = lastHighFractalIndex;
               lastHighFractalIndex = prevCandle;
            }
            
            prevSwingHighIndex = lastSwingHighIndex;
            lastSwingHighIndex = prevCandle;
            
            // impulse
            // mark curr low
            swingLowBuffer[i] = low[i];
            
            if(i-1 >= 0 && i+1 <= rates_total && low[i] <= low[i+1] && low[i] <= low[i-1]){
               FractalDownBuffer[i] = low[i];
               prevLowFractalIndex = lastLowFractalIndex;
               lastLowFractalIndex = i;
            }
            
            ZigZagBuffer2[i] = low[i];
            prevSwingLowIndex = lastSwingLowIndex;
            lastSwingLowIndex = i;
         
         }
         // is curr candle make lower low
         else if(low[i] < low[prevCandle]){
             
            // pullback
            // mark prev high
            // market phase change to bearish impulse
            //zzBuffer[prevCandle] = high[prevCandle];
            swingHighBuffer[prevCandle] = high[prevCandle];
            ZigZagBuffer1[prevCandle] = high[prevCandle];
            
            if(prevCandle-1 >= 0 && high[prevCandle] >= high[prevCandle+1] && high[prevCandle] >= high[prevCandle-1]){
            
               FractalUpBuffer[prevCandle] = high[prevCandle];
               prevHighFractalIndex = lastHighFractalIndex;
               lastHighFractalIndex = prevCandle;
            
            }
            
            prevSwingHighIndex = lastSwingHighIndex;
            lastSwingHighIndex = prevCandle;
            
            //zzBuffer[i] = EMPTY_VALUE;
            //ZigZagBuffer1[i] = EMPTY_VALUE;
            //ZigZagBuffer2[i] = EMPTY_VALUE;
            
            marketPhase = "BEARISH IMPULSE";
            
            
         // is curr candle make higher high
         }else{
         
            //zzBuffer[i] = EMPTY_VALUE;
            //ZigZagBuffer1[i] = EMPTY_VALUE;
            //ZigZagBuffer2[i] = EMPTY_VALUE;
         
         }
      
      }else if(marketPhase == "BEARISH IMPULSE"){
      
         // is curr candle make higher high and lower low
         if(high[i] > high[prevCandle] && low[i] < low[prevCandle]){
         
            // pullback
            // mark prev low
            //zzBuffer[prevCandle] = low[prevCandle];
            swingLowBuffer[prevCandle] = low[prevCandle];
            ZigZagBuffer2[prevCandle] = low[prevCandle];
            
            if(prevCandle-1 >= 0 && low[prevCandle] <= low[prevCandle+1] && low[prevCandle] <= low[prevCandle-1]){
               FractalDownBuffer[prevCandle] = low[prevCandle];
               prevLowFractalIndex = lastLowFractalIndex;
               lastLowFractalIndex = prevCandle;
            }
            
            prevSwingLowIndex = lastSwingLowIndex;
            lastSwingLowIndex = prevCandle;
            
            // impulse
            // mark curr high
            //zzBuffer[i] = high[i];
            swingHighBuffer[i] = high[i];
            ZigZagBuffer1[i] = high[i];
            
            if(i-1 >= 0 && i+1 <= rates_total && high[i] >= high[i+1] && high[i] >= high[i-1]){
               FractalUpBuffer[i] = high[i];
               prevHighFractalIndex = lastHighFractalIndex;
               lastHighFractalIndex = i;
            }
            
            prevSwingHighIndex = lastSwingHighIndex;
            lastSwingHighIndex = i;
            
         }
         // is curr candle make higher high
         else if(high[i] > high[prevCandle]){
         
         
            // pullback
            // mark prev low
            // market phase change to bearish impulse
            //zzBuffer[prevCandle] = low[prevCandle];
            swingLowBuffer[prevCandle] = low[prevCandle];
            ZigZagBuffer2[prevCandle] = low[prevCandle];
            
            if(prevCandle-1 >= 0 && low[prevCandle] <= low[prevCandle+1] && low[prevCandle] <= low[prevCandle-1]){
               FractalDownBuffer[prevCandle] = low[prevCandle];
               prevLowFractalIndex = lastLowFractalIndex;
               lastLowFractalIndex = prevCandle;
            }
            
            prevSwingLowIndex = lastSwingLowIndex;
            lastSwingLowIndex = prevCandle;
            
            //zzBuffer[i] = EMPTY_VALUE;
            marketPhase = "BULLISH IMPULSE";
            
         
         // is curr candle make higher high
         }else{
         
            //zzBuffer[i] = EMPTY_VALUE;
         
         }
      
      }else{
      
         //zzBuffer[i] = EMPTY_VALUE;
      
      }
   
   }

}

//+------------------------------------------------------------------+
//| Custom indicator inside bar detector                             |
//+------------------------------------------------------------------+
void insideBarDetector(
   datetime prevTime,datetime currTime,
   double prevOpen, double currOpen,
   double prevHigh, double currHign,
   double prevLow, double currLow,
   double prevClose, double currClose,
   double motherBarHigh, double motherBarLow,
   int currIndex
){
   
   if(insideBarS.insideBarDetected){
   
      if(currHign <= motherBarHigh && currLow >= motherBarLow){
         
         insideBarCandleHandle[currIndex] = 1;
         
         redrawRectangle(
            rectangleNameHandle,
            colorHandle,
            x1TimeHandle,
            y1PriceHandle,
            prevTime,
            y2PriceHandle
         );
         
         
      }else {
      
         insideBarS.insideBarDetected = false;
         
         
         if(currIndex - motherBarIndex <= 1){
         
            ObjectDelete(0,rectangleNameHandle);
            ChartRedraw(0);
            
         }else{
         
            redrawRectangle(
               rectangleNameHandle,
               colorHandle,
               x1TimeHandle,
               y1PriceHandle,
               prevTime,
               y2PriceHandle
            );
         
         }
         
      
      }
   
   }else if(currHign <= prevHigh && currLow >= prevLow){
   
      insideBarCandleHandle[currIndex] = 1;
      motherBarCandleHandle[currIndex-1] = 1;
      insideBarS.insideBarDetected = true;
      motherBarIndex = currIndex-1;
      
      //rectangleNameHandle = "mother_bar_"+TimeToString(prevTime,TIME_DATE | TIME_MINUTES | TIME_SECONDS);
      rectangleNameHandle = objectNameGenerator("mother_bar",prevTime);
      x1TimeHandle = prevTime;
      x2TimeHandle = currTime;
      y1PriceHandle = prevLow;
      y2PriceHandle = prevHigh;
      
      
      rectangleHandle = ObjectCreate(0,rectangleNameHandle,OBJ_RECTANGLE,0,x1TimeHandle,y1PriceHandle,x2TimeHandle,y2PriceHandle);
      colorHandle = prevClose > prevOpen ? "BULLISH" : "BEARISH";
      setRectangleProp(colorHandle);
      
   }else{
      
      insideBarCandleHandle[currIndex] = EMPTY_VALUE;
      motherBarCandleHandle[currIndex-1] = EMPTY_VALUE;
      
      
   }

                   
}

void redrawRectangle(string objName,string candleType,datetime x1_time,double y1_price,datetime x2_time,double y2_price){

   ObjectDelete(0,objName);
   
   rectangleHandle = ObjectCreate(
      0,
      objName,
      OBJ_RECTANGLE,
      0,
      x1_time,
      y1_price,
      x2_time,
      y2_price
   );
   
   setRectangleProp(candleType);

}



void setRectangleProp(string candleType){

   if(candleType == "BULLISH"){
   
      ObjectSetInteger(0,rectangleNameHandle,OBJPROP_COLOR,clrLightGreen);
   
   }else if(candleType == "BEARISH"){
   
      ObjectSetInteger(0,rectangleNameHandle,OBJPROP_COLOR,clrSalmon);
   
   }
   
   ObjectSetInteger(0,rectangleNameHandle,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,rectangleNameHandle,OBJPROP_BACK,true);

}

//+------------------------------------------------------------------+

string objectNameGenerator(string prefix, datetime dateTime){

   return "SMC "+prefix+"-"+TimeToString(dateTime,TIME_DATE | TIME_MINUTES | TIME_SECONDS);

}

void OnDeinit(const int reason){

   ObjectsDeleteAll(0,"SMC");

}