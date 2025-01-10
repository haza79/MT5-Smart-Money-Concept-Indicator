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
         BullishTrendMarketHandle();
      }else if(latestTrend == TREND_BEARISH){
         BearishTrendMarketHandle();
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
   
   void BearishTrendMarketHandle(){
      BearishMajorLowHandle();
      BearishMajorHighHandle();
      
      if(latestMajorLowIndex != -1){
         Print("high:",barData.GetTime(latestMajorHighIndex));
         Print("inducement:",barData.GetTime(inducementIndex));
         Print("low:",barData.GetTime(latestMajorLowIndex));
         oneTime = true;
      }
      
      
   }
   
   void BearishMajorLowHandle(){
      if(latestMajorLowIndex == -1){
         GetBiasLowAndInducement();
         
         if(biasLowIndex == -1){
            return;
         }
         
         int inducementBreak = CheckHighInducementBreak();
         if(inducementBreak != -1){
            latestMajorLowIndex = biasLowIndex;
            latestMajorLowPrice = biasLowPrice;
         }
         return;
         
         
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
   
   void BearishMajorHighHandle(){
      // bearish choch
      if(latestMajorHighIndex == -1){
         int fractalBeforeInducement = FindHighFractalAboveInducement();
         if(fractalBeforeInducement == -1){
            fractalBeforeInducement = inducementIndex;
         }
         latestMajorHighIndex = fractalBeforeInducement;
         latestMajorHighPrice = barData.GetHigh(latestMajorHighIndex);
      }
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
   
   int CheckHighInducementBreak(){
      if(!firstTimeCheckInducementBreak){
         // first time run check inducement break
         for(int i = biasLowIndex; i<=index; i++){
            // loop check candle break inducement
            if(barData.GetHigh(i) >= inducementPrice){
               // inducement break
               return i;
            }
            // end loop
         }
         
         firstTimeCheckInducementBreak = false;
      }else{
         if(barData.GetHigh(index) >= inducementPrice){
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
         if(fractal.highFractalIndices[j] < inducementIndex && barData.GetHigh(fractal.highFractalIndices[j]) > inducementPrice){
            return fractal.highFractalIndices[j];
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



   void GetBiasLowAndInducement(){
      // start 
      if(fractal.latestFractalHighIndex == -1 || fractal.latestFractalLowIndex == -1 
         || fractal.prevFractalHighIndex == -1 || fractal.prevFractalLowIndex == -1){
         // start if statement
         return;   
      }
      
      bool setBiasLowAndInducement = false;
      
      if(biasLowIndex == -1){
         // no bias low
         if(prevMajorLowIndex == -1){
            // prev major low empty == first time run
            setBiasLowAndInducement = true;
         }else{
            // prev major low not empty
            if(fractal.latestFractalLowIndex < prevMajorLowIndex &&
               fractal.latestFractalLowPrice < prevMajorLowPrice){
               // latest low fractal < prev major low
               setBiasLowAndInducement = true;
            }
         }
      }else{
         // have bias low
         if(fractal.latestFractalLowIndex < biasLowIndex &&
            fractal.latestFractalLowPrice < biasLowPrice){
            // found new bias low
            setBiasLowAndInducement = true;
         }
      }
      // out of if statement
      
      if(setBiasLowAndInducement){
         biasLowIndex = fractal.latestFractalLowIndex;
         biasLowPrice = fractal.latestFractalLowPrice;
         
         if(fractal.latestFractalHighIndex >= biasLowIndex){
            inducementIndex = fractal.prevFractalHighIndex;
            inducementPrice = fractal.prevFractalHighPrice;
         }else{
            inducementIndex = fractal.latestFractalHighIndex;
            inducementPrice = fractal.latestFractalHighPrice;
         }
      }
   }


  };

#endif  // MAJORMARKETSTRUCTURECLASS_MQH
