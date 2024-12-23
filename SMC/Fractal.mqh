#ifndef FRACTALCLASS_MQH
#define FRACTALCLASS_MQH

#include "Enums.mqh"
#include "ImpulsePullbackDetector.mqh"

class FractalClass {
private:
   ImpulsePullbackDetectorClass* impulsePullbackDetector;

public:
   double highFractalBuffer[], lowFractalBuffer[];
   int prevFractalHighIndex, prevFractalLowIndex, latestFractalHighIndex, latestFractalLowIndex;

   void Init(ImpulsePullbackDetectorClass* impulsePullbackDetectorInstance) {
      impulsePullbackDetector = impulsePullbackDetectorInstance;
      prevFractalHighIndex = prevFractalLowIndex = -1;
      latestFractalHighIndex = latestFractalLowIndex = -1;

      ArrayInitialize(highFractalBuffer, EMPTY_VALUE);
      ArrayInitialize(lowFractalBuffer, EMPTY_VALUE);
   }

   void Calculate(const int &i, const double &high[], const double &low[]) {
      int getLatestSwingHigh = impulsePullbackDetector.latestSwingHighIndex;
      int getLatestSwingLow = impulsePullbackDetector.latestSwingLowIndex;

      // Check and update high fractal
      if (latestFractalHighIndex != getLatestSwingHigh && (i - getLatestSwingHigh) >= 2) {
         if (CheckFractalAtIndex(high, low, getLatestSwingHigh, FRACTAL_HIGH)) {
            highFractalBuffer[getLatestSwingHigh] = high[getLatestSwingHigh];
            prevFractalHighIndex = latestFractalHighIndex;
            latestFractalHighIndex = getLatestSwingHigh;
         }
      }

      // Check and update low fractal
      if (latestFractalLowIndex != getLatestSwingLow && (i - getLatestSwingLow) >= 2) {
         if (CheckFractalAtIndex(high, low, getLatestSwingLow, FRACTAL_LOW)) {
            lowFractalBuffer[getLatestSwingLow] = low[getLatestSwingLow];
            prevFractalLowIndex = latestFractalLowIndex;
            latestFractalLowIndex = getLatestSwingLow;
         }
      }
   }

   bool CheckFractalAtIndex(const double &high[], const double &low[], int index, FractalType type) {
      // Ensure the index is within the bounds for closed candles only
      if (index > 1 && index < ArraySize(high) - 2) {  // Ignore the last candle (open candle)
         if (type == FRACTAL_HIGH && high[index] > high[index - 1] && high[index] > high[index + 1]) {
            return true;
         }
         else if (type == FRACTAL_LOW && low[index] < low[index - 1] && low[index] < low[index + 1]) {
            return true;
         }
      } else {
         Print("Index ", index, " is out of bounds for fractal checking.");
      }
      return false;
   }
};

#endif
