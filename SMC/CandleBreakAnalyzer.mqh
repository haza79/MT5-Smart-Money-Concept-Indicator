#ifndef CANDLEBREAKANALYZERCLASS_MQH
#define CANDLEBREAKANALYZERCLASS_MQH

class CandleBreakAnalyzerClass{

public:
   
   enum CandleType {NONE,BULLISH,BEARISH,DOJI};
   enum SwingType {NONE,HIGH,LOW};
   CandleType candleType;
   SwingType swingType;

   CandleType GetCandleType(const double &open,const double &close){
      if(close > open){
         return BULLISH;
      }
      
      if(close < open){
         return BEARISH;
      }
      
      if(close == open){
         return DOJI;
      }
      
      return CandleType::NONE;
   }
   
}

#endif