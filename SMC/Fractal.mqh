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
   int prev2FractalHighIndex,prev2FractalLowIndex,prevFractalHighIndex, prevFractalLowIndex, latestFractalHighIndex, latestFractalLowIndex;
   double prev2FractalHighPrice,prev2FractalLowPrice,prevFractalHighPrice,prevFractalLowPrice,latestFractalHighPrice,latestFractalLowPrice;

   void Init(ImpulsePullbackDetectorClass* impulsePullbackDetectorInstance) {
      impulsePullbackDetector = impulsePullbackDetectorInstance;
      
      prev2FractalHighIndex = prev2FractalLowIndex = -1;
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

   void Calculate(const int &i, const double &high[], const double &low[], const int &rate_total) {
   ArrayResize(highFractalBuffer,rate_total);
   ArrayResize(lowFractalBuffer,rate_total);
   highFractalBuffer[i] = EMPTY_VALUE;
   lowFractalBuffer[i] = EMPTY_VALUE;
      int getLatestSwingHigh = impulsePullbackDetector.latestSwingHighIndex;
      int getLatestSwingLow = impulsePullbackDetector.latestSwingLowIndex;

      // Check and update high fractal
      if (latestFractalHighIndex != getLatestSwingHigh && (i - getLatestSwingHigh) >= 2) {
         if (CheckFractalAtIndex(high, low, getLatestSwingHigh, FRACTAL_HIGH)) {
            highFractalBuffer[getLatestSwingHigh] = high[getLatestSwingHigh];
            
            prev2FractalHighIndex = prevFractalHighIndex;
            prevFractalHighIndex = latestFractalHighIndex;
            latestFractalHighIndex = getLatestSwingHigh;
            
            prev2FractalHighPrice = prevFractalHighPrice;
            prevFractalHighPrice = latestFractalHighPrice;
            latestFractalHighPrice = high[getLatestSwingHigh];
            
            //AddToFractalArray(highFractalIndices, highFractalCount, getLatestSwingHigh);

            
         }
      }

      // Check and update low fractal
      if (latestFractalLowIndex != getLatestSwingLow && (i - getLatestSwingLow) >= 2) {
         if (CheckFractalAtIndex(high, low, getLatestSwingLow, FRACTAL_LOW)) {
            lowFractalBuffer[getLatestSwingLow] = low[getLatestSwingLow];
            
            prev2FractalLowIndex = prevFractalLowIndex;
            prevFractalLowIndex = latestFractalLowIndex;
            latestFractalLowIndex = getLatestSwingLow;
            
            prev2FractalLowPrice = prevFractalLowPrice;
            prevFractalLowPrice = latestFractalLowPrice;
            latestFractalLowPrice = low[getLatestSwingLow];
            
            //AddToFractalArray(lowFractalIndices, lowFractalCount, getLatestSwingLow);

            
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
         //Print("Index ", index, " is out of bounds for fractal checking.");
      }
      return false;
   }
   
   void GetFractalFromRange(int fromIndex, int toIndex, bool isHigh, int &result[])
{
   int tmp[];
   ArrayResize(tmp, toIndex - fromIndex); // max possible size
   int count = 0;

   for (int i = fromIndex; i < toIndex; i++)
   {
      if (isHigh && highFractalBuffer[i] != EMPTY_VALUE)
         tmp[count++] = i;
      else if (!isHigh && lowFractalBuffer[i] != EMPTY_VALUE)
         tmp[count++] = i;
   }

   ArrayResize(result, count);
   for (int i = 0; i < count; i++)
      result[i] = tmp[i];
}

   
   int GetLatestHighFractalIndex() {
      if (highFractalCount > 0) {
         return highFractalIndices[highFractalCount - 1]; // Return the last element
      } else {
         return -1; // Return -1 if no high fractals are available
      }
   }
   
   int GetPrevHighFractalIndex() {
      if (highFractalCount > 1) {
         return highFractalIndices[highFractalCount - 2]; // Return the last element
      } else {
         return -1; // Return -1 if no high fractals are available
      }
   }
   
   int GetLatestLowFractalIndex() {
      if (lowFractalCount > 0) {
         return lowFractalIndices[lowFractalCount - 1]; // Return the last element
      } else {
         return -1; // Return -1 if no high fractals are available
      }
   }
   
   int GetPrevLowFractalIndex() {
      if (lowFractalCount > 1) {
         return lowFractalIndices[lowFractalCount - 2]; // Return the last element
      } else {
         return -1; // Return -1 if no high fractals are available
      }
   }
   
   
   
};

#endif
