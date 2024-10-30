#ifndef MINORMARKETSTRUCTURECLASS_MQH
#define MINORMARKETSTRUCTURECLASS_MQH

#include "ImpulsePullbackDetector.mqh";
#include "CandleBreakAnalyzer.mqh";
#include "Enums.mqh"

class MinorMarketStructureClass{

private:
   ImpulsePullbackDetectorClass* impulsePullbackDetector;
   CandleBreakAnalyzerClass candleBreakAnalyzer;
   Trend trend;

public:
   
   const double marketPhase[];
   int prevMinorHighIndex,prevMinorLowIndex,latestMinorHighIndex,latestMinorLowIndex;
   double prevMinorHighPrice,prevMinorLowPrice,latestMinorHighPrice,latestMinorLowPrice;
   
   MinorMarketStructureClass() : impulsePullbackDetector(NULL){}

   void Init(ImpulsePullbackDetectorClass* impulsePullbackDetectorInstance){
      impulsePullbackDetector = impulsePullbackDetectorInstance;
      trend = NONE;
      
   }
   
   void Calculate(int i,
                const int rates_total,
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[]){
      // start here
      if(i<1){
         return;
      }
      
      int latestSwingHighIndex = impulsePullbackDetector.latestSwingHighIndex;
      int latestSwingLowIndex = impulsePullbackDetector.latestSwingHighIndex
      
      int prevSwingHighIndex = impulsePullbackDetector.prevSwingHighIndex;
      int prevSwingLowIndex = impulsePullbackDetector.latestSwingHighIndex;
      
      double latestSwingHighPrice = impulsePullbackDetector.latestSwingHighPrice;
      double latestSwingLowPrice = impulsePullbackDetector.latestSwingLowPrice;
      
      double prevSwingHighPrice = impulsePullbackDetector.prevSwingHighPrice;
      double prevSwingLowPrice = impulsePullbackDetector.prevSwingLowPrice;
      
      
      // first run . no trend
      if(latestSwingHighIndex != -1 && latestSwingLowIndex != -1){
         
         if(latestSwingHighIndex > latestSwingLowIndex && latestSwingHighPrice > latestSwingLowPrice){
            trend = TREND_BULLISH;
         }else if(latestSwingLowIndex > latestSwingHighIndex && latestSwingLowPrice < latestSwingHighPrice){
            trend = TREND_BEARISH;
         }
         
         latestMinorHighIndex = latestSwingHighIndex;
         latestMinorHighPrice = latestSwingHighPrice;
         
         latestMinorLowIndex = latestSwingLowIndex;
         latestMinorLowPrice = latestSwingLowPrice;
         
      }
      
      //start here
      Candle currCandleStruct(open[i],high[i],low[i],close[i]);
      Candle currCandleStruct(open[i],high[i],low[i],close[i]);
      
      if(trend == TREND_BULLISH){
         
         if(candleBreakAnalyzer.IsPriceBreakByBody() || candleBreakAnalyzer.IsPriceBreakByWick || candleBreakAnalyzer.IsPriceBreakByGap)
         
      }
      
      
   }
}

#endif