#ifndef MAJORMARKETSTRUCTURECLASS_MQH
#define MAJORMARKETSTRUCTURECLASS_MQH

#include "Enums.mqh";
#include "Fractal.mqh";
#include "MinorMarketStructureClass.mqh";

class MajorMarketStructureClass{

private:
   FractalClass* fractal;
   MinorMarketStructureClass* minorMarketStructure;
   int oneTimeRun;
   
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
      if(oneTimeRun == -1){
         oneTimeRun = GetFirstMarketTrendForm();
      }
   }
   
   int GetFirstMarketTrendForm(){
      if(minorMarketStructure.latestMarketStructure == MS_NONE){
         return -1;
      } 

      if(minorMarketStructure.prevMarketStructure == MS_NONE &&
      minorMarketStructure.latestMarketStructure == MS_BULLISH_BOS){
         return 11;
      }
      
      if(minorMarketStructure.prevMarketStructure == MS_BEARISH_CHOCH &&
      minorMarketStructure.latestMarketStructure == MS_BULLISH_CHOCH){
         return 12;
      }
      
      if(minorMarketStructure.prevMarketStructure == MS_BEARISH_CHOCH &&
      minorMarketStructure.latestMarketStructure == MS_BEARISH_BOS){
         return 13;   
      }
      
      if(minorMarketStructure.prevMarketStructure == MS_NONE &&
      minorMarketStructure.latestMarketStructure == MS_BEARISH_BOS){
         return 21;   
      }
      
      if(minorMarketStructure.prevMarketStructure == MS_BULLISH_CHOCH &&
      minorMarketStructure.latestMarketStructure == MS_BEARISH_CHOCH){
         return 22;
      }
      
      if(minorMarketStructure.prevMarketStructure == MS_BULLISH_CHOCH &&
      minorMarketStructure.latestMarketStructure == MS_BULLISH_BOS){
         return 23;
      }

      // end of function
      return -1;
   }
   
   void GetFirstMarketTrend(int marketTrend){
      switch (marketTrend){
         case 11:
            biasTrend = TREND_BULLISH;
            latestMajorTrend = TREND_NONE;
            latestMajorHighIndex = -1;
            latestMajorLowIndex = minorMarketStructure.prevMinorLowIndex;
            latestInducementIndex = fractal.latestFractalLowIndex;
            break;
            
         case 12:
            biasTrend = TREND_NONE;
            latestMajorTrend = TREND_BULLISH;
            
            break;
            
         case 13:
            break;
            
         case 21:
            break;
            
         case 22:
            break;
            
         case 23:
            break;                                 
         
      }
   }

}

#endif