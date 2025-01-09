//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef MAJORMARKETSTRUCTTURECLASS_MQH
#define MAJORMARKETSTRUCTTURECLASS_MQH

#include "BarData.mqh"
#include "Enums.mqh"
#include "Fractal.mqh"
#include "MinorMarketStructureClass.mqh"
#include "MajorMarketStructureStruct.mqh"
#include "CandleBreakAnalyzerStatic.mqh"

#include "CandleStructs.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MajorMarketStructureClass
  {

private:

   BarData           *barData;
   FractalClass      *fractal;
   MinorMarketStructureClass *minorMarketStructure;
   int               oneTimeRun;
   MajorMarketStruct prevMarketStruct, latestMarketStruct;

   int               index;
   Trend             prevTrend,latestTrend;
   int               prevMajorHighIndex, prevMajorLowIndex, latestMajorHighIndex, latestMajorLowIndex;
   int               biasHighIndex, biasLowIndex;
   int               inducementIndex;

   double            prevMajorHighPrice, prevMajorLowPrice, latestMajorHighPrice, latestMajorLowPrice;
   double            biasHighPrice, biasLowPrice;
   double            inducementPrice;
   bool swingHighWickBreak,swingLowWickBreak;
   
   Candle majorHighPriceStruct,majorLowPriceStruct;

   struct BiasSwingAndInducement
     {
      int            biasSwingIndex;
      int            inducementIndex;
     };

   bool              oneTime;
   bool              firstTimeCheckInducementBreak;

public:


   // Constructor to initialize variables
   void              Init(BarData *barDataInstance,FractalClass *fractalInstance)
     {
      barData = barDataInstance;
      fractal = fractalInstance;

      oneTime = false;
      firstTimeCheckInducementBreak = true;
      prevTrend = TREND_NONE;
      latestTrend = TREND_NONE;

      prevMajorHighIndex = prevMajorLowIndex = latestMajorHighIndex = latestMajorLowIndex = -1;
      biasHighIndex = biasLowIndex = -1;

      prevMajorHighPrice = prevMajorLowPrice = latestMajorHighPrice = latestMajorLowPrice = -1;
      biasHighPrice = biasLowPrice = -1;
      
      swingHighWickBreak = swingLowWickBreak = false;

      // No need to initialize arrays since we reference external arrays
     }

   // Calculate method which works with references to the external arrays
   void              Calculate(int Iindex)
     {
      index = Iindex;
      UpdateMarketStructure();
     }

   void UpdateMarketStructure(){
      if(oneTime == true){
         return;
      }
      
      if(fractal.prev2FractalHighIndex == -1 || fractal.prevFractalHighIndex == -1 || fractal.latestFractalHighIndex == -1
      || fractal.prev2FractalLowIndex == -1 || fractal.prevFractalLowIndex == -1 || fractal.latestFractalLowIndex == -1){
         return;
      }
      
      if(latestTrend == TREND_NONE){
         GetFirstTrend();
      }
      
      if(latestTrend == TREND_BULLISH){
         Print("bullish");
         BullishTrendMarketHandle();
      }else if(latestTrend == TREND_BEARISH){
         Print("bearish");
      }
   
   }

     
   void BullishTrendMarketHandle(){
      BullishMajorHighHandle();
      BullishMajorLowHandle();
      
      if(latestMajorHighIndex != -1){
         Print("high:",barData.GetTime(latestMajorHighIndex));
         Print("inducement:",barData.GetTime(inducementIndex));
         Print("low:",barData.GetTime(latestMajorLowIndex));
         oneTime = true;
      }
   }
   
   void BullishMajorHighHandle(){
      if(latestMajorHighIndex == -1){
         GetBiasHighAndInducement();
         
         if(biasHighIndex == -1){
            return;
         }
         
         int inducementBreak = CheckLowInducementBreak();
         if(inducementBreak != -1){
            latestMajorHighIndex = biasHighIndex;
            latestMajorHighPrice = biasHighPrice;
            majorHighPriceStruct.setValue(barData.GetOpen(latestMajorHighIndex),barData.GetHigh(latestMajorHighIndex),barData.GetLow(latestMajorHighIndex),barData.GetClose(latestMajorHighIndex));
         }
         
      }
      
      Candle currCandle(barData.GetOpen(index),barData.GetHigh(index),barData.GetLow(index),barData.GetClose(index));
      Candle prevCandle(barData.GetOpen(index),barData.GetHigh(index),barData.GetLow(index),barData.GetClose(index));
      
      
      
      
   }
   
   void BullishMajorLowHandle(){
      if(latestMajorLowIndex == -1){
         int fractalBeforeInducement = FindLowFractalBelowInducement();
         if(fractalBeforeInducement == -1){
            fractalBeforeInducement = inducementIndex;
         }
         latestMajorLowIndex = fractalBeforeInducement;
         latestMajorLowPrice = barData.GetLow(latestMajorLowIndex);
      }
   }
   
   int CheckLowInducementBreak(){
      if(!firstTimeCheckInducementBreak){
         // first time run check inducement break
         for(int i = biasHighIndex; i<=index; i++){
            // loop check candle break inducement
            if(barData.GetLow(i) <= inducementPrice){
               // inducement break
               return i;
            }
            // end loop
         }
         
         firstTimeCheckInducementBreak = false;
      }else{
         if(barData.GetLow(index) <= inducementPrice){
            return index;
         }
      }
      
      return -1;
   }
     
   void GetFirstTrend(){
      if(fractal.prevFractalHighIndex != -1 && fractal.latestFractalHighIndex != -1
      && fractal.prevFractalLowIndex != -1 && fractal.latestFractalLowIndex != -1){
      
         if(fractal.latestFractalHighPrice > fractal.prevFractalHighPrice){
            latestTrend = TREND_BULLISH;
         }
         
         if(fractal.latestFractalLowPrice < fractal.prevFractalLowPrice){
            latestTrend = TREND_BEARISH;
         }
      
      }else{
         return;
      }
      
   }
        
   int FindLowFractalBelowInducement(){
      // start function
      for(int j = fractal.lowFractalCount-1; j>=0; j--){
         // start loop
         if(fractal.lowFractalIndices[j] < inducementIndex && barData.GetLow(fractal.lowFractalIndices[j]) < inducementPrice){
            return fractal.lowFractalIndices[j];
         }
         // end if statement
      }
      
      return -1;
      // end function
   }
   
   int FindHighFractalAboveInducement(){
      // start function
      for(int j = fractal.highFractalCount-1; j>=0; j--){
         // start loop
         if(fractal.lowFractalIndices[j] < inducementIndex && barData.GetLow(fractal.lowFractalIndices[j]) < inducementPrice){
            return fractal.lowFractalIndices[j];
         }
         // end if statement
      }
      
      return -1;
      // end function
   }

   void              GetBiasHighAndInducement()
     {
      if(fractal.latestFractalHighIndex == -1 || fractal.latestFractalLowIndex == -1)
        {
         return;
        }

      int newBiasHighIndex = -1;
      double newBiasHighPrice = 0.0;

      if(biasHighIndex != -1)
        {
         if(fractal.latestFractalHighIndex > biasHighIndex &&
            fractal.latestFractalHighPrice > biasHighPrice)
           {
            newBiasHighIndex = fractal.latestFractalHighIndex;
            newBiasHighPrice = fractal.latestFractalHighPrice;
           }
        }
      else
        {
         if(prevMajorHighIndex == -1 ||
            (fractal.latestFractalHighIndex > prevMajorHighIndex &&
             fractal.latestFractalHighPrice > prevMajorHighPrice))
           {
            newBiasHighIndex = fractal.latestFractalHighIndex;
            newBiasHighPrice = fractal.latestFractalHighPrice;
           }
        }

      if(newBiasHighIndex != -1)
        {
         biasHighIndex = newBiasHighIndex;
         biasHighPrice = newBiasHighPrice;
         inducementIndex = (biasHighIndex == fractal.latestFractalLowIndex) ?
                           fractal.prevFractalLowIndex : fractal.latestFractalLowIndex;
         inducementPrice = (biasHighIndex == fractal.latestFractalLowIndex) ?
                           fractal.prevFractalLowPrice : fractal.latestFractalLowPrice;
        }
     }



   void              GetBiasLowAndInducement()
     {
      if(fractal.latestFractalHighIndex == -1 || fractal.latestFractalLowIndex == -1)
        {
         return;
        }

      int newBiasLowIndex = -1;
      double newBiasLowPrice = 0.0;

      if(biasLowIndex != -1)
        {
         if(fractal.latestFractalLowIndex > biasLowIndex &&
            fractal.latestFractalLowPrice < biasLowPrice)   // Note the '<' for lows
           {
            newBiasLowIndex = fractal.latestFractalLowIndex;
            newBiasLowPrice = fractal.latestFractalLowPrice;
           }
        }
      else
        {
         if(prevMajorLowIndex == -1 ||
            (fractal.latestFractalLowIndex > prevMajorLowIndex &&
             fractal.latestFractalLowPrice < prevMajorLowPrice))   // Note the '<' for lows
           {
            newBiasLowIndex = fractal.latestFractalLowIndex;
            newBiasLowPrice = fractal.latestFractalLowPrice;
           }
        }

      if(newBiasLowIndex != -1)
        {
         biasLowIndex = newBiasLowIndex;
         biasLowPrice = newBiasLowPrice;

         inducementIndex = (biasLowIndex == fractal.latestFractalHighIndex) ?
                           fractal.prevFractalHighIndex : fractal.latestFractalHighIndex;
         inducementPrice = (biasLowIndex == fractal.latestFractalHighIndex) ?
                           fractal.prevFractalHighPrice : fractal.latestFractalHighPrice;
        }
     }


  };

#endif  // MAJORMARKETSTRUCTURECLASS_MQH
