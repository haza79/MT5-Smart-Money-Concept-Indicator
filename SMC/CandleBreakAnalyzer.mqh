#ifndef CANDLEBREAKANALYZERCLASS_MQH
#define CANDLEBREAKANALYZERCLASS_MQH

#include "CandleStructs.mqh"

class CandleBreakAnalyzerClass{

public:
   
   enum CandleType {NONE,BULLISH,BEARISH,DOJI};
   enum SwingType {NONE,HIGH,LOW};
   CandleType candleType;
   SwingType swingType;

   CandleType GetCandleType(const Candle &candle){
      if(candle.close > candle.open){
         return BULLISH;
      }
      
      if(candle.close < candle.open){
         return BEARISH;
      }
      
      return DOJI;
      
   }
   
}

#endif