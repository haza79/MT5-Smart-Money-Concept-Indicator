#ifndef CANDLEBREAKANALYZERCLASS_MQH
#define CANDLEBREAKANALYZERCLASS_MQH

#include "CandleStructs.mqh"
#include "Enums.mqh"

class CandleBreakAnalyzerClass{

public:

   CandleType GetCandleType(const Candle &candle){
      if(candle.close > candle.open){
         return CANDLE_BULLISH;
      }
      
      if(candle.close < candle.open){
         return CANDLE_BEARISH;
      }
      
      return CANDLE_DOJI;
      
   }
   
   bool IsPriceBreakByBody(const SwingType &swingType,
                           const Candle &swingPrice,
                           const Candle &comparePrice){
                           
      // start here
      CandleType swingCandleType = GetCandleType(swingPrice);
      CandleType compareCandleType = GetCandleType(comparePrice);
      
      if(swingType == SWING_HIGH){
         
         if(compareCandleType == CANDLE_BULLISH && swingPrice.high < comparePrice.close && swingPrice.high > comparePrice.open){
            return true;
         }
         
         if(compareCandleType == CANDLE_BEARISH && swingPrice.high < comparePrice.open && swingPrice.high > comparePrice.close){
            return true;
         }
         
         if(compareCandleType == CANDLE_DOJI && (swingPrice.high == comparePrice.open || swingPrice.high == comparePrice.close)){
            return true;
         }
         
      }
      
      if(swingType == SWING_LOW){
      
         if(compareCandleType == CANDLE_BEARISH && swingPrice.low < comparePrice.open && swingPrice.low > comparePrice.close){
            return true;
         }
         
         if(compareCandleType == CANDLE_BULLISH && swingPrice.low < comparePrice.close && swingPrice.low > comparePrice.open){
            return true;
         }
         
         if(compareCandleType == CANDLE_DOJI && (swingPrice.low == comparePrice.open || swingPrice.low == comparePrice.close)){
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
      
      if(swingType == SWING_HIGH){
         
         if(compareCandleType == CANDLE_BULLISH && swingPrice.high < comparePrice.high && swingPrice.high > comparePrice.close){
            return true;
         }
         
         if(compareCandleType == CANDLE_BEARISH && swingPrice.high < comparePrice.high && swingPrice.high > comparePrice.open){
            return true;
         }
         
         if(compareCandleType == CANDLE_DOJI && swingPrice.high < comparePrice.high && swingPrice.high > comparePrice.close){
            return true;
         }
         
      }
      
      if(swingType == SWING_LOW){
      
         if(compareCandleType == CANDLE_BEARISH && swingPrice.low > comparePrice.low && swingPrice.low < comparePrice.close){
            return true;
         }
         
         if(compareCandleType == CANDLE_BULLISH && swingPrice.low > comparePrice.low && swingPrice.low < comparePrice.open){
            return true;
         }
         
         if(compareCandleType == CANDLE_DOJI && swingPrice.low > comparePrice.low && swingPrice.low < comparePrice.close){
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
      
      if(swingType == SWING_HIGH){
         
         if(compareCandleType == CANDLE_BULLISH && comparePrice.open >= beforeComparePrice.high && swingPrice.high <= comparePrice.open){
            return true;
         }
         
         if(compareCandleType == CANDLE_BEARISH && comparePrice.close >= beforeComparePrice.high && swingPrice.high <= comparePrice.close){
            return true;
         }
         
         if(compareCandleType == CANDLE_DOJI && comparePrice.close >= beforeComparePrice.high && swingPrice.high <= comparePrice.close){
            return true;
         }
         
      }
      
      if(swingType == SWING_LOW){
      
         if(compareCandleType == CANDLE_BEARISH && comparePrice.open <= beforeComparePrice.low && swingPrice.low >= comparePrice.open){
            return true;
         }
         
         if(compareCandleType == CANDLE_BULLISH && comparePrice.close <= beforeComparePrice.low && swingPrice.low >= comparePrice.close){
            return true;
         }
         
         if(compareCandleType == CANDLE_DOJI && comparePrice.close <= beforeComparePrice.low && swingPrice.low >= comparePrice.close){
            return true;
         }
      
      }
      
      return false;
      
   }   
   
   int GetLowestLowIndex(const double &low[], int startIndex, int endIndex) {
      // Ensure the range is valid
      if (startIndex < 0 || endIndex >= ArraySize(low) || startIndex > endIndex) {
         return -1; // Invalid range
      }
      
      double lowestLow = low[startIndex];
      int lowestIndex = startIndex;
      
      for (int i = startIndex + 1; i <= endIndex; i++) {
         if (low[i] < lowestLow) {
            lowestLow = low[i];
            lowestIndex = i;
         }
      }
      
      return lowestIndex;
   }

   int GetHighestHighIndex(const double &high[], int startIndex, int endIndex) {
      // Ensure the range is valid
      if (startIndex < 0 || endIndex >= ArraySize(high) || startIndex > endIndex) {
         return -1; // Invalid range
      }
      
      double highestHigh = high[startIndex];
      int highestIndex = startIndex;
      
      for (int i = startIndex + 1; i <= endIndex; i++) {
         if (high[i] > highestHigh) {
            highestHigh = high[i];
            highestIndex = i;
         }
      }
      
      return highestIndex;
   }


   
}

#endif