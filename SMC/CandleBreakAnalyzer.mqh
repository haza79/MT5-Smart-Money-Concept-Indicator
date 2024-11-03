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
   
bool IsPriceBreakByBody(const SwingType &swingType, const Candle &swingPrice, const Candle &comparePrice) {
    CandleType compareCandleType = GetCandleType(comparePrice);
    double swingLevel = (swingType == SWING_HIGH) ? swingPrice.high : swingPrice.low;
    double compareOpen = comparePrice.open, compareClose = comparePrice.close;

    if (swingType == SWING_HIGH) {
        return (compareCandleType == CANDLE_BULLISH && swingLevel < compareClose && swingLevel > compareOpen) ||
               (compareCandleType == CANDLE_BEARISH && swingLevel < compareOpen && swingLevel > compareClose) ||
               (compareCandleType == CANDLE_DOJI && (swingLevel == compareOpen || swingLevel == compareClose));
    } else {  // SWING_LOW
        return (compareCandleType == CANDLE_BEARISH && swingLevel < compareOpen && swingLevel > compareClose) ||
               (compareCandleType == CANDLE_BULLISH && swingLevel < compareClose && swingLevel > compareOpen) ||
               (compareCandleType == CANDLE_DOJI && (swingLevel == compareOpen || swingLevel == compareClose));
    }
}

bool IsPriceBreakByWick(const SwingType &swingType, const Candle &swingPrice, const Candle &comparePrice) {
    CandleType compareCandleType = GetCandleType(comparePrice);
    double swingLevel = (swingType == SWING_HIGH) ? swingPrice.high : swingPrice.low;
    double compareHigh = comparePrice.high, compareLow = comparePrice.low;

    if (swingType == SWING_HIGH) {
        return (compareCandleType == CANDLE_BULLISH && swingLevel < compareHigh && swingLevel > comparePrice.close) ||
               (compareCandleType == CANDLE_BEARISH && swingLevel < compareHigh && swingLevel > comparePrice.open) ||
               (compareCandleType == CANDLE_DOJI && swingLevel < compareHigh && swingLevel > comparePrice.close);
    } else {  // SWING_LOW
        return (compareCandleType == CANDLE_BEARISH && swingLevel > compareLow && swingLevel < comparePrice.close) ||
               (compareCandleType == CANDLE_BULLISH && swingLevel > compareLow && swingLevel < comparePrice.open) ||
               (compareCandleType == CANDLE_DOJI && swingLevel > compareLow && swingLevel < comparePrice.close);
    }
}

bool IsPriceBreakByGap(const SwingType &swingType, const Candle &swingPrice, const Candle &beforeComparePrice, const Candle &comparePrice) {
    CandleType compareCandleType = GetCandleType(comparePrice);
    double swingLevel = (swingType == SWING_HIGH) ? swingPrice.high : swingPrice.low;
    double beforeCompareLevel = (swingType == SWING_HIGH) ? beforeComparePrice.high : beforeComparePrice.low;

    if (swingType == SWING_HIGH) {
        return (compareCandleType == CANDLE_BULLISH && comparePrice.open >= beforeCompareLevel && swingLevel <= comparePrice.open) ||
               (compareCandleType == CANDLE_BEARISH && comparePrice.close >= beforeCompareLevel && swingLevel <= comparePrice.close) ||
               (compareCandleType == CANDLE_DOJI && comparePrice.close >= beforeCompareLevel && swingLevel <= comparePrice.close);
    } else {  // SWING_LOW
        return (compareCandleType == CANDLE_BEARISH && comparePrice.open <= beforeCompareLevel && swingLevel >= comparePrice.open) ||
               (compareCandleType == CANDLE_BULLISH && comparePrice.close <= beforeCompareLevel && swingLevel >= comparePrice.close) ||
               (compareCandleType == CANDLE_DOJI && comparePrice.close <= beforeCompareLevel && swingLevel >= comparePrice.close);
    }
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
   
   bool IsPriceBreakByAny(const SwingType &swingType,
                       const Candle &swingPrice,
                       const Candle &beforeComparePrice,
                       const Candle &comparePrice) {
    return IsPriceBreakByBody(swingType, swingPrice, comparePrice) ||
           IsPriceBreakByWick(swingType, swingPrice, comparePrice) ||
           IsPriceBreakByGap(swingType, swingPrice, beforeComparePrice, comparePrice);
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