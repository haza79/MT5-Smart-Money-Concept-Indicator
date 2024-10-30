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
   
   bool IsPriceBreakByBody(const SwingType &swingType,
                           const Candle &swingPrice,
                           const Candle &comparePrice){
                           
      // start here
      CandleType swingCandleType = GetCandleType(swingPrice);
      CandleType compareCandleType = GetCandleType(comparePrice);
      
      if(swingType == HIGH){
         
         if(compareCandleType == BULLISH && swingPrice.high < comparePrice.close && swingPrice.high > comparePrice.open){
            return true;
         }
         
         if(compareCandleType == BEARISH && swingPrice.high < comparePrice.open && swingPrice.high > comparePrice.close){
            return true;
         }
         
         if(compareCandleType == DOJI && (swingPrice.high == comparePrice.open || swingPrice.high == comparePrice.close)){
            return true;
         }
         
      }
      
      if(swingType == LOW){
      
         if(compareCandleType == BEARISH && swingPrice.low < comparePrice.open && swingPrice.low > comparePrice.close){
            return true;
         }
         
         if(compareCandleType == BULLISH && swingPrice.low < comparePrice.close && swingPrice.low > comparePrice.open){
            return true;
         }
         
         if(compareCandleType == DOJI && (swingPrice.low == comparePrice.open || swingPrice.low == comparePrice.close)){
            return true;
         }
      
      }
      
      return false;
      
   }
   
      bool IsPriceBreakByWick(const SwingType &swingType,
                           const Candle &swingPrice,
                           const Candle &comparePrice){
                           
      // start here
      CandleType swingCandleType = GetCandleType(swingPrice);
      CandleType compareCandleType = GetCandleType(comparePrice);
      
      if(swingType == HIGH){
         
         if(compareCandleType == BULLISH && swingPrice.high < comparePrice.high && swingPrice.high > comparePrice.close){
            return true;
         }
         
         if(compareCandleType == BEARISH && swingPrice.high < comparePrice.high && swingPrice.high > comparePrice.open){
            return true;
         }
         
         if(compareCandleType == DOJI && swingPrice.high < comparePrice.high && swingPrice.high > comparePrice.close){
            return true;
         }
         
      }
      
      if(swingType == LOW){
      
         if(compareCandleType == BEARISH && swingPrice.low > comparePrice.low && swingPrice.low < comparePrice.close){
            return true;
         }
         
         if(compareCandleType == BULLISH && swingPrice.low > comparePrice.low && swingPrice.low < comparePrice.open){
            return true;
         }
         
         if(compareCandleType == DOJI && swingPrice.low > comparePrice.low && swingPrice.low < comparePrice.close){
            return true;
         }
      
      }
      
      return false;
      
   }
   
      bool IsPriceBreakByGap(const SwingType &swingType,
                           const Candle &swingPrice,
                           const Candle &beforeComparePrice,
                           const Candle &comparePrice){
                           
      // start here
      CandleType swingCandleType = GetCandleType(swingPrice);
      CandleType compareCandleType = GetCandleType(comparePrice);
      
      if(swingType == HIGH){
         
         if(compareCandleType == BULLISH && comparePrice.open >= beforeComparePrice.high && swingPrice.high <= comparePrice.open){
            return true;
         }
         
         if(compareCandleType == BEARISH && comparePrice.close >= beforeComparePrice.high && swingPrice.high <= comparePrice.close){
            return true;
         }
         
         if(compareCandleType == DOJI && comparePrice.close >= beforeComparePrice.high && swingPrice.high <= comparePrice.close){
            return true;
         }
         
      }
      
      if(swingType == LOW){
      
         if(compareCandleType == BEARISH && comparePrice.open <= beforeComparePrice.low && swingPrice.low >= comparePrice.open){
            return true;
         }
         
         if(compareCandleType == BULLISH && comparePrice.close <= beforeComparePrice.low && swingPrice.low >= comparePrice.close){
            return true;
         }
         
         if(compareCandleType == DOJI && comparePrice.close <= beforeComparePrice.low && swingPrice.low >= comparePrice.close){
            return true;
         }
      
      }
      
      return false;
      
   }   
   
}

#endif