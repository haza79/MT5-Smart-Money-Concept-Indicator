//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef MACDMARKETSTRUCTURECLASS_MQH
#define MACDMARKETSTRUCTURECLASS_MQH

#include "BarData.mqh"
#include "Enums.mqh"
#include "MACDFractal.mqh"
#include "CandleBreakAnalyzerStatic.mqh"
#include "CandleStructs.mqh"

class MacdMarketStructureClass{

private:
   BarData* barData;
   MACDFractalClass* macdFractal;
   
   Trend trend;
   
   int prevMajorHighIndex,latestMajorHighIndex,
      prevMajorLowIndex,latestMajorLowIndex;
      
   double prevMajorHighPrice,latestMajorHighPrice,
      prevMajorLowPrice,latestMajorLowPrice;      

public:

   MacdMarketStructureClass(){
      // construction
      trend = TREND_NONE;
   }
   
   void init(MACDFractalClass* macdFractalInstance, BarData* barDataInstance){
      // init function
      macdFractal = macdFractalInstance;
      barData = barDataInstance;
      
      latestMajorHighIndex = -1;
      latestMajorLowIndex = -1;
   }

   void update(int index, int totalBars){
      // start here
      if (index >= totalBars - 1) {
        return;
      }
      
      if(trend == TREND_NONE){
         getFirstTrend();
      }
   }
   
   void getFirstTrend(){
      if(latestMajorHighIndex == -1 || latestMajorLowIndex == -1){
         latestMajorHighIndex = macdFractal.latestMacdHighFractalIndex;
         latestMajorHighPrice = macdFractal.latestMacdHighFractalPrice;
         
         latestMajorLowIndex = macdFractal.latestMacdLowFractalIndex;
         latestMajorLowPrice = macdFractal.latestMacdLowFractalPrice;
      }
   
      if(latestMajorHighIndex == -1 || latestMajorLowIndex == -1){
         return;
      }
      
      
      
      
      
   }

   

}

#endif  // MAJORMARKETSTRUCTURECLASS_MQH
