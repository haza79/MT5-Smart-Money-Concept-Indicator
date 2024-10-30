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
   SwingType swingType;

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
      
      
      // first run . no trend
      if(latestSwingHighIndex != -1 && latestSwingLowIndex != -1){
         
         if(latestSwingHighIndex > latestSwingLowIndex && latestSwingHighPrice > latestSwingLowPrice){
            trend = TREND_BULLISH;
         }else if(latestSwingLowIndex > latestSwingHighIndex && latestSwingLowPrice < latestSwingHighPrice){
            trend = TREND_BEARISH;
         }
         
         latestMinorHighIndex = latestSwingHighIndex;
         
         latestMinorLowIndex = latestSwingLowIndex;
         
      }
      
      //start here
      Candle currCandleStruct(open[i],high[i],low[i],close[i]);
      Candle prevCandleStruct(open[i-1],high[i-1],low[i-1],close[i-1]);
      
      if(trend == TREND_BULLISH){
         Candle swingPriceStruct(open[latestMinorHighIndex],high[latestMinorHighIndex],low[latestMinorHighIndex],close[latestMinorHighIndex]);
         
         if(candleBreakAnalyzer.IsPriceBreakByBody(swingType,swingPriceStruct,currCandleStruct) || candleBreakAnalyzer.IsPriceBreakByWick(swingType,swingPriceStruct,currCandleStruct) || candleBreakAnalyzer.IsPriceBreakByGap(swingType,swingPriceStruct,prevCandleStruct,currCandleStruct)){
            // todo -> draw choch line from latest minor low to price break
         }
         
      }
      
      
   }
}

#endif