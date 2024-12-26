#ifndef MAJORMARKETSTRUCTURECLASS_MQH
#define MAJORMARKETSTRUCTURECLASS_MQH

#include "Enums.mqh";
#include "Fractal.mqh";
#include "MinorMarketStructureClass.mqh";
#include "MajorMarketStructureStruct.mqh";

class MajorMarketStructureClass{

private:
   FractalClass* fractal;
   MinorMarketStructureClass* minorMarketStructure;
   int oneTimeRun;
   MajorMarketStruct prevMarketStruct,latestMarketStruct;
   
public:

   int prevMajorHighIndex,latestMajorHighIndex,
      prevMajorLowIndex,latestMajorLowIndex,
      latestInducementIndex;
      
   MarketStructureType prevMarketStructure,latestMarketStructure;
   Candle majorHighPriceStruct,majorLowPriceStruct,inducementStruct;
   Trend prevMajorTrend,latestMajorTrend;
   Trend biasTrend;
         
   void Init(FractalClass* fractalInstance,MinorMarketStructureClass* minorMarketStructureInstance){
      fractal = fractalInstance;
      minorMarketStructure = minorMarketStructureInstance;
      oneTimeRun = -1;
      prevMajorTrend = TREND_NONE;
      latestMajorTrend = TREND_NONE;
      biasTrend = TREND_NONE;
   }
   
   void Calculate(){

   }
   


}

#endif