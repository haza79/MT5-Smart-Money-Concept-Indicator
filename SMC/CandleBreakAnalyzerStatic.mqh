#ifndef CANDLEBREAKANALYZER_MQH
#define CANDLEBREAKANALYZER_MQH

#include "CandleStructs.mqh"
#include "Enums.mqh"
#include "BarData.mqh"


class CandleBreakAnalyzerStatic {

public:

   static CandleType GetCandleType(const Candle &candle) {
      if (candle.close > candle.open) {
         return CANDLE_BULLISH;
      }
      if (candle.close < candle.open) {
         return CANDLE_BEARISH;
      }
      return CANDLE_DOJI;
   }
   
   static bool IsPriceBreakByBody(const SwingType &swingType, const Candle &swingPrice, const Candle &comparePrice) {
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

   static bool IsPriceBreakByWick(const SwingType &swingType, const Candle &swingPrice, const Candle &comparePrice) {
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

   static bool IsPriceBreakByGap(const SwingType &swingType, const Candle &swingPrice, const Candle &beforeComparePrice, const Candle &comparePrice) {
      double swingLevel = (swingType == SWING_HIGH) ? swingPrice.high : swingPrice.low;
      double beforeCompareLevel = (swingType == SWING_HIGH) ? beforeComparePrice.high : beforeComparePrice.low;

      if (swingType == SWING_HIGH) {
         return (comparePrice.open > beforeComparePrice.high && comparePrice.open >= swingLevel) || 
                (comparePrice.close > beforeComparePrice.high && comparePrice.close >= swingLevel);
      } else {  // SWING_LOW
         return (comparePrice.open < beforeComparePrice.low && comparePrice.open <= swingLevel) ||
                (comparePrice.close < beforeComparePrice.low && comparePrice.close <= swingLevel);
      }
   }

   static int GetLowestLowIndex(const double &low[], int startIndex, int endIndex) {
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
   
   static bool IsPriceBreakByAny(const SwingType &swingType, const Candle &swingPrice, const Candle &beforeComparePrice, const Candle &comparePrice) {
      return IsPriceBreakByBody(swingType, swingPrice, comparePrice) || 
             IsPriceBreakByWick(swingType, swingPrice, comparePrice) || 
             IsPriceBreakByGap(swingType, swingPrice, beforeComparePrice, comparePrice);
   }
   
   static int GetLowestLowIndex(const BarData &data, int startIndex, int endIndex) {
      if (startIndex < 0 || endIndex >= data.GetLowArrSize() || startIndex > endIndex) {
         return -1; // Invalid range
      }

      double lowestLow = data.GetLow(startIndex);
      int lowestIndex = startIndex;

      for (int i = startIndex + 1; i <= endIndex; i++) {
         if (data.GetLow(i) < lowestLow) {
            lowestLow = data.GetLow(i);
            lowestIndex = i;
         }
      }

      return lowestIndex;
   }


   static int GetHighestHighIndex(const double &high[], int startIndex, int endIndex) {
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
   
   static int GetHighestHighIndex(const BarData &data, int startIndex, int endIndex) {
      if (startIndex < 0 || endIndex >= data.GetHighArrSize() || startIndex > endIndex) {
         return -1; // Invalid range
      }

      double highestHigh = data.GetHigh(startIndex);
      int highestIndex = startIndex;

      for (int i = startIndex + 1; i <= endIndex; i++) {
         if (data.GetHigh(i) > highestHigh) {
            highestHigh = data.GetHigh(i);
            highestIndex = i;
         }
      }

      return highestIndex;
   }
   
};

#endif
