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
#include "LineDrawing.mqh"


#include "CandleStructs.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MajorMarketStructureClass
  {

private:

   BarData           *barData;
   FractalClass      *fractal;
   
   
   
   int               oneTimeRun;
   MajorMarketStruct prevMarketStruct, latestMarketStruct;

   int               index;
   Trend             prevTrend,latestTrend;
   int               prevMajorHighIndex, prevMajorLowIndex, latestMajorHighIndex, latestMajorLowIndex;
   int               biasHighIndex, biasLowIndex;
   int               inducementIndex;
   int wickSwingHighIndex,wickSwingLowIndex;
   double wickSwingHighPrice,wickSwingLowPrice;

   double            prevMajorHighPrice, prevMajorLowPrice, latestMajorHighPrice, latestMajorLowPrice;
   double            biasHighPrice, biasLowPrice;
   double            inducementPrice;
   bool swingHighWickBreak,swingLowWickBreak;
   
   Candle majorHighPriceStruct,majorLowPriceStruct,wickSwingHighPriceStruct,wickSwingLowPriceStruct,currCandleStruct,prevCandleStruct;
   MarketStructureType prev2MarketStructure,prevMarketStructure,latestMarketStructure;

   struct BiasSwingAndInducement
     {
      int            biasSwingIndex;
      int            inducementIndex;
     };

   bool              oneTime;
   bool              firstTimeCheckInducementBreak;

public:

   LineDrawing bullishBosDrawing;
   LineDrawing bullishChochDrawing;
   LineDrawing bullishInducementDrawing;
   LineDrawing bearishBosDrawing;
   LineDrawing bearishChochDrawing;
   LineDrawing bearishInducementDrawing;


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
      
      prev2MarketStructure = prevMarketStructure = latestMarketStructure = MS_NONE;

      // No need to initialize arrays since we reference external arrays
     }

   // Calculate method which works with references to the external arrays
   void Calculate(int Iindex){
      ArrayResize(bullishBosDrawing.buffer, barData.RatesTotal());
      ArrayResize(bullishInducementDrawing.buffer, barData.RatesTotal());
      ArrayResize(bullishChochDrawing.buffer, barData.RatesTotal());

      index = Iindex;
      bullishBosDrawing.buffer[index] = EMPTY_VALUE;
      bullishInducementDrawing.buffer[index] = EMPTY_VALUE;
      bullishChochDrawing.buffer[index] = EMPTY_VALUE;
      
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
      
      currCandleStruct.setValue(barData.GetOpen(index),barData.GetHigh(index),barData.GetLow(index),barData.GetClose(index));
      prevCandleStruct.setValue(barData.GetOpen(index),barData.GetHigh(index),barData.GetLow(index),barData.GetClose(index));
      
      if(latestTrend == TREND_BULLISH){
         Print("bullish");
         BullishTrendMarketHandle();
      }else if(latestTrend == TREND_BEARISH){
         Print("bearish");
         BearishTrendMarketHandle();
      }
   
   }

     
   void BullishTrendMarketHandle(){
      BullishMajorHighHandle();
      BullishMajorLowHandle();
   }
   
   void BearishTrendMarketHandle(){
      BearishMajorLowHandle();
      BearishMajorHighHandle();
   }
   
   // *** BULLISH TREND HIGH ***
   void BullishMajorHighHandle(){
      if(latestMajorHighIndex == -1){
         GetBiasHighAndInducement();
         
         if(biasHighIndex == -1){
            return;
         }
         
         int inducementBreak = CheckLowInducementBreak();
         if(inducementBreak != -1){
            bullishInducementDrawing.DrawStraightLine(inducementIndex,inducementBreak,inducementPrice);
            latestMajorHighIndex = biasHighIndex;
            latestMajorHighPrice = biasHighPrice;
            majorHighPriceStruct.setValue(barData.GetOpen(latestMajorHighIndex),barData.GetHigh(latestMajorHighIndex),barData.GetLow(latestMajorHighIndex),barData.GetClose(latestMajorHighIndex));
         }
         
      }
      
      if(latestMajorHighIndex == -1){
         return;
      }
      
      if(swingHighWickBreak){
         // YES
         if(IsPriceBreakWickSwingHighByBodyOrGap()){
            bullishBosDrawing.DrawStraightLine(wickSwingHighIndex,index,wickSwingHighPrice);
            swingHighWickBreak = false;
            UpdateBullishBosVariable();
         }else if(IsPriceBreakWickSwingHighByWick()){
            bullishBosDrawing.DrawStraightLine(wickSwingHighIndex,index,wickSwingHighPrice);
            UpdateWickSwingHighVariable();
         }
      }else{
         // NO
         if(IsPriceBreakMajorHighByBodyOrGap()){
            // price break high by body or gap
            bullishBosDrawing.DrawStraightLine(latestMajorHighIndex,index,latestMajorHighPrice);
            UpdateBullishBosVariable();
            
         }else if(IsPriceBreakMajorHighByWick()){
            // price break high by wick
            bullishBosDrawing.DrawStraightLine(latestMajorHighIndex,index,latestMajorHighPrice);
            swingHighWickBreak = true;
            UpdateWickSwingHighVariable();
         }
      }
      
      
   }
   
   // *** BULLISH TREND LOW ***
   void BullishMajorLowHandle(){
      if(latestMajorLowIndex == -1){
         int fractalBeforeInducement = FindLowFractalBelowInducement();
         if(fractalBeforeInducement == -1){
            fractalBeforeInducement = inducementIndex;
         }
         latestMajorLowIndex = fractalBeforeInducement;
         latestMajorLowPrice = barData.GetLow(fractalBeforeInducement);
         majorLowPriceStruct.setValue(barData.GetOpen(latestMajorLowIndex),barData.GetHigh(latestMajorLowIndex),barData.GetLow(latestMajorLowIndex),barData.GetClose(latestMajorLowIndex));
      }
      
      if(latestMajorLowIndex == -1){
         return;
      }
      
      if(swingLowWickBreak){
         // swing low wick break
         if(IsPriceBreakWickSwingLowyBodyOrGap()){
            bullishChochDrawing.DrawStraightLine(wickSwingLowIndex,index,wickSwingLowPrice);
            swingLowWickBreak = false;
            UpdateBullishChochVariable();
         }else if(IsPriceBreakWickSwingLowByWick()){
            bullishChochDrawing.DrawStraightLine(wickSwingLowIndex,index,wickSwingLowPrice);
            UpdateWickSwingLowVariable();
         }
      }else{
         // not wick break
         if(IsPriceBreakMajorLowByBodyOrGap()){
            bullishChochDrawing.DrawStraightLine(latestMajorLowIndex,index,latestMajorLowPrice);
            UpdateBullishChochVariable();
         }else if(IsPriceBreakMajorLowByWick()){
            bullishChochDrawing.DrawStraightLine(latestMajorLowIndex,index,latestMajorLowPrice);
            swingLowWickBreak = true;
            UpdateWickSwingLowVariable();
         }
      }
      
   }
   
   // *** BEARISH TREND LOW ***
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
   
   // *** BEARISH TREND HIGH ***   
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
      int minus = 1;
      if(fractal.latestFractalLowIndex > inducementIndex){
         minus = 2;
      }
      for(int j = fractal.lowFractalCount-minus; j>=0; j--){
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
   
   void UpdateBullishBosVariable(){
      AddTrend(TREND_BULLISH);
      AddMarketStructure(MS_BEARISH_BOS);
      
      prevMajorHighIndex = latestMajorHighIndex;
      prevMajorHighPrice = latestMajorHighPrice;
      
      prevMajorLowIndex = latestMajorLowIndex;
      prevMajorLowPrice = latestMajorLowPrice;
      
      latestMajorHighIndex = -1;
      latestMajorHighPrice = -1;
      majorHighPriceStruct.setZero();
      
      latestMajorLowIndex = CandleBreakAnalyzerStatic::GetLowestLowIndex(barData,prevMajorHighIndex,index);
      latestMajorLowPrice = barData.GetLow(latestMajorLowIndex);
      majorLowPriceStruct.setValue(barData.GetOpen(latestMajorLowIndex),barData.GetHigh(latestMajorLowIndex),barData.GetLow(latestMajorLowIndex),barData.GetClose(latestMajorLowIndex));
   }
   
   void UpdateBullishChochVariable(){
      AddTrend(TREND_BEARISH);
      AddMarketStructure(MS_BEARISH_CHOCH);
      
      prevMajorLowIndex = latestMajorLowIndex;
      prevMajorLowPrice = latestMajorLowPrice;
      
      latestMajorHighIndex = CandleBreakAnalyzerStatic::GetHighestHighIndex(barData,prevMajorLowIndex,index);
      latestMajorHighPrice = barData.GetHigh(latestMajorHighIndex);
      majorHighPriceStruct.setValue(barData.GetOpen(latestMajorHighIndex),barData.GetHigh(latestMajorHighIndex),barData.GetLow(latestMajorHighIndex),barData.GetClose(latestMajorHighIndex));
      
      latestMajorLowIndex = -1;
      latestMajorLowPrice = -1;
      majorLowPriceStruct.setZero();
   }
   
   void UpdateWickSwingHighVariable(){
      wickSwingHighIndex = index;
      wickSwingHighPrice = barData.GetHigh(index);
      wickSwingHighPriceStruct = currCandleStruct;
   }
            
   void UpdateWickSwingLowVariable(){
      wickSwingLowIndex = index;
      wickSwingLowPrice = barData.GetLow(index);
      wickSwingLowPriceStruct = currCandleStruct;
   }
   
   void AddTrend(Trend newTrend){
      prevTrend = latestTrend;
      latestTrend = newTrend;
   }
   
   void AddMarketStructure(MarketStructureType newMarketStructure){
      prev2MarketStructure = prevMarketStructure;
      prevMarketStructure = latestMarketStructure;
      latestMarketStructure = newMarketStructure;
   }
   
   
   
   bool IsPriceBreakMajorHighByBodyOrGap(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByBody(SWING_HIGH,majorHighPriceStruct,currCandleStruct) ||
         CandleBreakAnalyzerStatic::IsPriceBreakByGap(SWING_HIGH,majorHighPriceStruct,prevCandleStruct,currCandleStruct);
   }
   
   bool IsPriceBreakMajorHighByWick(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByWick(SWING_HIGH,majorHighPriceStruct,currCandleStruct);
   }
   
   bool IsPriceBreakWickSwingHighByBodyOrGap(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByBody(SWING_HIGH,wickSwingHighPriceStruct,currCandleStruct) ||
         CandleBreakAnalyzerStatic::IsPriceBreakByGap(SWING_HIGH,wickSwingHighPriceStruct,prevCandleStruct,currCandleStruct);
   }
   
   bool IsPriceBreakWickSwingHighByWick(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByWick(SWING_HIGH,wickSwingHighPriceStruct,currCandleStruct);
   }
   
   
   
   
   bool IsPriceBreakMajorLowByBodyOrGap(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByBody(SWING_LOW,majorLowPriceStruct,currCandleStruct) ||
         CandleBreakAnalyzerStatic::IsPriceBreakByGap(SWING_LOW,majorLowPriceStruct,prevCandleStruct,currCandleStruct);
   }
   
   bool IsPriceBreakMajorLowByWick(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByWick(SWING_LOW,majorLowPriceStruct,currCandleStruct);
   }
   
   bool IsPriceBreakWickSwingLowyBodyOrGap(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByBody(SWING_LOW,wickSwingLowPriceStruct,currCandleStruct) ||
         CandleBreakAnalyzerStatic::IsPriceBreakByGap(SWING_LOW,wickSwingLowPriceStruct,prevCandleStruct,currCandleStruct);
   }
   
   bool IsPriceBreakWickSwingLowByWick(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByWick(SWING_LOW,wickSwingLowPriceStruct,currCandleStruct);
   }
   


  };

#endif  // MAJORMARKETSTRUCTURECLASS_MQH
