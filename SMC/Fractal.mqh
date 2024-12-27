#ifndef FRACTALCLASS_MQH
#define FRACTALCLASS_MQH

#include "Enums.mqh"
#include "ImpulsePullbackDetector.mqh"

class FractalClass {
private:
   ImpulsePullbackDetectorClass* impulsePullbackDetector;
   
   
   
   void AddToFractalArray(int &fractalArray[], int &count, int index) {
      if (count >= ArraySize(fractalArray)) {
         ArrayResize(fractalArray, count + 10); // Resize by a step to minimize frequent resizes
      }
      fractalArray[count++] = index; // Add index and increment count
   }

public:
int highFractalCount, lowFractalCount;        // Count of collected fractals'
   double highFractalBuffer[], lowFractalBuffer[];
   int highFractalIndices[], lowFractalIndices[];
   int prevFractalHighIndex, prevFractalLowIndex, latestFractalHighIndex, latestFractalLowIndex;

   void Init(ImpulsePullbackDetectorClass* impulsePullbackDetectorInstance) {
      impulsePullbackDetector = impulsePullbackDetectorInstance;
      prevFractalHighIndex = prevFractalLowIndex = -1;
      latestFractalHighIndex = latestFractalLowIndex = -1;
      
      highFractalCount = lowFractalCount = 0;


      ArrayInitialize(highFractalBuffer, EMPTY_VALUE);
      ArrayInitialize(lowFractalBuffer, EMPTY_VALUE);
      ArrayInitialize(highFractalIndices, EMPTY_VALUE);
      ArrayInitialize(lowFractalIndices, EMPTY_VALUE);
      
      ArrayResize(highFractalIndices, 10); // Initialize with a capacity of 10
      ArrayResize(lowFractalIndices, 10); // Initialize with a capacity of 10
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
            AddToFractalArray(highFractalIndices, highFractalCount, getLatestSwingHigh);

            
         }
      }

      // Check and update low fractal
      if (latestFractalLowIndex != getLatestSwingLow && (i - getLatestSwingLow) >= 2) {
         if (CheckFractalAtIndex(high, low, getLatestSwingLow, FRACTAL_LOW)) {
            lowFractalBuffer[getLatestSwingLow] = low[getLatestSwingLow];
            prevFractalLowIndex = latestFractalLowIndex;
            latestFractalLowIndex = getLatestSwingLow;
            AddToFractalArray(lowFractalIndices, lowFractalCount, getLatestSwingLow);

            
         }
      }
   }

   bool CheckFractalAtIndex(const double &high[], const double &low[], int index, FractalType type) {
      // Ensure the index is within the bounds for closed candles only
      if (index > 1 && index < ArraySize(high) - 2) {  // Ignore the last candle (open candle)
         if (type == FRACTAL_HIGH && high[index] > high[index - 1] && high[index] > high[index + 1]) {
            //updateFractalIndex(FRACTAL_HIGH,index);
            return true;
         }
         else if (type == FRACTAL_LOW && low[index] < low[index - 1] && low[index] < low[index + 1]) {
            //updateFractalIndex(FRACTAL_LOW,index);
            return true;
         }
      } else {
         Print("Index ", index, " is out of bounds for fractal checking.");
      }
      return false;
   }
   
   int GetLatestHighFractalIndex(int index) {
   if (highFractalCount > 0) {
      return highFractalIndices[highFractalCount - (1+index)]; // Return the last element
   } else {
      return -1; // Return -1 if no high fractals are available
   }
}
   
   int GetHighFractalByReverseIndex(int reverseIndex) {
    // Check if the reverseIndex is within bounds
    if (reverseIndex < 0 || reverseIndex >= highFractalCount) {
        PrintFormat("Reverse index out of bounds: %d", reverseIndex);
        return -1; // Return -1 or any other invalid value for out-of-bounds access
    }

    // Access the element from right to left
    int actualIndex = highFractalCount - (1 + reverseIndex); // Convert reverse index to actual index
    return highFractalIndices[actualIndex];

}
   
   
   
};

#endif
