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
            prevMarketStruct.swingLow.index = minorMarketStructure.prevMinorLowIndex;
            prevMarketStruct.swingLow.value = minorMarketStructure.prevMinorLowPrice;
            prevMarketStruct.swingHigh.index = minorMarketStructure.latestMinorHighIndex;
            prevMarketStruct.swingHigh.value = minorMarketStructure.latestMinorHighPrice;
            
            latestMarketStruct.biasTrend = TREND_BULLISH;
            latestMarketStruct.trend = TREND_NONE;
            latestMarketStruct.biasSwingHigh.index = -1;
            latestMarketStruct.swingHigh.index = -1;
            latestMarketStruct.swingLow.index = -1;
            latestMarketStruct.inducement.index = fractal.latestFractalLowIndex;
            break;
            
         case 12:
            prevMarketStruct.trend = TREND_BULLISH;
            prevMarketStruct.swingLow
            
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