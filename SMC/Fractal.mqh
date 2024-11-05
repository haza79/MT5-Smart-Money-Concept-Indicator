//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef FRACTALCLASS_MQH
#define FRACTALCLASS_MQH

#include "Enums.mqh"
#include "ImpulsePullbackDetector.mqh";

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class FractalClass
  {

private:
   ImpulsePullbackDetectorClass* impulsePullbackDetector;

public:
   double            highFractalBuffer[],lowFractalBuffer[];
   int               prevFractalHighIndex,prevFractalLowIndex,latestFractalHighIndex,latestFractalLowIndex;

   void              Init(ImpulsePullbackDetectorClass* impulsePullbackDetectorInstance)
     {
      impulsePullbackDetector = impulsePullbackDetectorInstance;

      prevFractalHighIndex = -1;
      prevFractalLowIndex = -1;
      latestFractalHighIndex = -1;
      latestFractalLowIndex - -1;

      ArrayInitialize(highFractalBuffer, EMPTY_VALUE);
      ArrayInitialize(lowFractalBuffer, EMPTY_VALUE);
     }
     
     void Calculate(const int &i,const double &high[],const double &low[]){
      int getLatestSwingHigh = impulsePullbackDetector.latestSwingHighIndex;
      int getLatestSwingLow = impulsePullbackDetector.latestSwingLowIndex;
      
      if(latestFractalHighIndex != getLatestSwingHigh){
         if(i-getLatestSwingHigh >= 2){
            if(CheckFractalAtIndex(high,low,getLatestSwingHigh,FRACTAL_HIGH)){
               latestFractalHighIndex[getLatestSwingHigh] = high[getLatestSwingHigh];
               prevFractalHighIndex = latestFractalHighIndex;
               latestFractalHighIndex = getLatestSwingHigh;
            }
         }
      }
     }

   bool              CheckFractalAtIndex(const double &high[], const double &low[], int index, FractalType type)
     {
      // Ensure the index is within closed candles only
      if(index > 1 && index < ArraySize(high) - 2)    // Ignore the last candle (open candle)
        {
         switch(type)
           {
            case FRACTAL_HIGH:
               if(high[index] > high[index - 1] && high[index] > high[index + 1])
                 {
                  return true;
                 }
               break;
            case FRACTAL_LOW:
               if(low[index] < low[index - 1] && low[index] < low[index + 1])
                 {
                  return true;
                 }
               break;
            default:
               Print("Unknown fractal type.");
               break;
           }
        }
      else
        {
         Print("Index ", index, " is out of bounds for fractal checking.");
        }
      return false;
     }
  };

#endif
//+------------------------------------------------------------------+
