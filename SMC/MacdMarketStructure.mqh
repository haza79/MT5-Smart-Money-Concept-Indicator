//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef MACDMARKETSTRUCTURECLASS_MQH
#define MACDMARKETSTRUCTURECLASS_MQH

#include "BarData.mqh"
#include "Enums.mqh"
#include "MACDFractal.mqh"
#include "CandleBreakAnalyzerStatic.mqh"
#include "CandleStructs.mqh"
#include "LineDrawing.mqh"
#include "HorizontalRay.mqh";

class MacdMarketStructureClass{

private:
   BarData* barData;
   
   int index;
   
   
   //+------------------------------------------------------------------+
   //|   GLOBAL VARIABLE                                                |
   //+------------------------------------------------------------------+
   
   
   
   Candle prevMajorHighCandle,latestMajorHighCandle,
      prevMajorLowCandle,latestMajorLowCandle,
      wickHighCandle,wickLowCandle,
      prevCandle,currCandle;
   
   int prevMajorHighIndex,latestMajorHighIndex,
      prevMajorLowIndex,latestMajorLowIndex,
      wickHighIndex,wickLowIndex,
      prevWickHighIndex,prevWickLowIndex;
      
   double prevMajorHighPrice,latestMajorHighPrice,
      prevMajorLowPrice,latestMajorLowPrice,
      wickHighPrice,wickLowPrice,
      prevWickHighPrice,prevWickLowPrice;
      
   bool isHighWickBreak,isLowWickBreak,
      isPrevHighWickBreak,isPrevLowWickBreak;
      

   //+------------------------------------------------------------------+
   //|   SWING HANDLE                                                   |
   //+------------------------------------------------------------------+
   
   //--- BULLISH HIGH **
   void bullishMajorHighHandle(){
      if(latestMajorHighIndex == -1){
         if(getNewMajorHigh()){
            majorSwingHighBuffer[latestMajorHighIndex] = latestMajorHighPrice;
            bosRay.drawRay(latestMajorHighIndex,index,latestMajorHighPrice);
         }
      }
      
      if(latestMajorHighIndex == -1){
         return;
      }
      
      if(isHighWickBreak){
         // high wick break
         if(!bosRay.drew){
            bosRay.drawRay(wickHighIndex,index,wickHighPrice);
         }
         
         if(isPriceBreakWickHighByBodyOrGap()){
            // bullish bos
            bullishBosDrawing.DrawStraightLine(wickHighIndex,index,wickHighPrice);
            
            updateBullishBosVariable();
            majorSwingLowBuffer[latestMajorLowIndex] = latestMajorLowPrice;
            bosRay.deleteRay();
            chochRay.deleteRay();
            
         }else if(isPriceBreakWickHighByWick()){
            // continue wick break
            bullishBosDrawing.DrawStraightLine(wickHighIndex,index,wickHighPrice);
            updateWickHighVariable();
            bosRay.deleteRay();
         }
         
      }else{
         // not wick break
         if(isPriceBreakHighByBobyOrGap()){
            // bullish bos
            updateBullishBosVariable();
            majorSwingLowBuffer[latestMajorLowIndex] = latestMajorLowPrice;
            bullishBosDrawing.DrawStraightLine(prevMajorHighIndex,index,prevMajorHighPrice);
            
            bosRay.deleteRay();
            chochRay.deleteRay();
            
         }else if(isPriceBreakHighByWick()){
            // high wick break
            isHighWickBreak = true;
            updateWickHighVariable();
            bullishBosDrawing.DrawStraightLine(latestMajorHighIndex,index,latestMajorHighPrice);
            bosRay.deleteRay();
         }
         
         
      }
   }
   
   //--- BULLISH LOW **
   void bullishMajorLowHandle(){
   
      if(!chochRay.drew){
         chochRay.drawRay(latestMajorLowIndex,index,latestMajorLowPrice);
      }
      
      if(isLowWickBreak){
         // low wick break
         if(!chochRay.drew){
            chochRay.drawRay(wickLowIndex,index,wickLowPrice);
         }
         
         if(isPriceBreakWickLowByBodyOrGap()){
            // bullish bos
            bearishChochDrawing.DrawStraightLine(wickLowIndex,index,wickLowPrice);
            updateBearishChochVariable();
            bosRay.deleteRay();
            chochRay.deleteRay();
            
         }else if(isPriceBreakWickLowByWick()){
            // continue wick break
            bearishChochDrawing.DrawStraightLine(wickLowIndex,index,wickLowPrice);
            updateWickLowVariable();
            chochRay.deleteRay();
         }
         
      }else{
         // not wick break
         if(isPriceBreakLowByBodyOrGap()){
            // bullish bos
            updateBearishChochVariable();
            bearishChochDrawing.DrawStraightLine(prevMajorLowIndex,index,prevMajorLowPrice);
            bosRay.deleteRay();
            chochRay.deleteRay();
            
         }else if(isPriceBreakLowByWick()){
            // high wick break
            isLowWickBreak = true;
            updateWickLowVariable();
            bearishChochDrawing.DrawStraightLine(latestMajorLowIndex,index,latestMajorLowPrice);
            chochRay.deleteRay();
         }
         
         
      }
   }
   
   
   
   
   
   
   
   
   
   
   
   //--- BEARISH LOW **
   void bearishMajorLowHandle(){
      if(latestMajorLowIndex == -1){
         if(getNewMajorLow()){
            majorSwingLowBuffer[latestMajorLowIndex] = latestMajorLowPrice;
            bosRay.drawRay(latestMajorLowIndex,index,latestMajorLowPrice);
         }
      }
      
      if(latestMajorLowIndex == -1){
         return;
      }
      
      if(isLowWickBreak){
      
         if(!bosRay.drew){
            bosRay.drawRay(wickLowIndex,index,wickLowPrice);
         }
         
         if(isPriceBreakWickLowByBodyOrGap()){
            // bullish bos
            bearishBosDrawing.DrawStraightLine(wickLowIndex,index,wickLowPrice);
            
            updateBearishBosVariable();
            majorSwingHighBuffer[latestMajorHighIndex] = latestMajorHighPrice;
            
            bosRay.deleteRay();
            chochRay.deleteRay();
            
         }else if(isPriceBreakWickLowByWick()){
            // continue wick break
            bearishBosDrawing.DrawStraightLine(wickLowIndex,index,wickLowPrice);
            updateWickLowVariable();
            bosRay.deleteRay();
         }
         
      }else{
         // not wick break
         if(isPriceBreakLowByBodyOrGap()){
            // bearish bos
            updateBearishBosVariable();
            majorSwingHighBuffer[latestMajorHighIndex] = latestMajorHighPrice;
            bearishBosDrawing.DrawStraightLine(prevMajorLowIndex,index,prevMajorLowPrice);
            bosRay.deleteRay();
            chochRay.deleteRay();
            
         }else if(isPriceBreakLowByWick()){
            // high wick break
            isLowWickBreak = true;
            updateWickLowVariable();
            bearishBosDrawing.DrawStraightLine(latestMajorLowIndex,index,latestMajorLowPrice);
            bosRay.deleteRay();
            
         }
         
         
      }
   }
   
   
   //--- BEARISH HIGH **
   void bearishMajorHighHandle(){
   
      if(!chochRay.drew){
         chochRay.drawRay(latestMajorHighIndex,index,latestMajorHighPrice);
      }
      
      if(isHighWickBreak){
         // high wick break
         if(!chochRay.drew){
            chochRay.drawRay(wickHighIndex,index,wickHighPrice);
         }
         
         if(isPriceBreakWickHighByBodyOrGap()){
            // bullish bos
            bullishChochDrawing.DrawStraightLine(wickHighIndex,index,wickHighPrice);
            updateBullishChochVariable();
            bosRay.deleteRay();
            chochRay.deleteRay();
            
         }else if(isPriceBreakWickHighByWick()){
            // continue wick break
            bullishChochDrawing.DrawStraightLine(wickHighIndex,index,wickHighPrice);
            updateWickHighVariable();
            chochRay.deleteRay();
         }
         
      }else{
         // not wick break
         if(isPriceBreakHighByBobyOrGap()){
            // bullish bos
            Print("break:",barData.GetTime(index));
            updateBullishChochVariable();
            Print("get major low")
            majorSwingLowBuffer[latestMajorLowIndex] = latestMajorLowPrice;
            bullishChochDrawing.DrawStraightLine(prevMajorHighIndex,index,prevMajorHighPrice);
            bosRay.deleteRay();
            chochRay.deleteRay();
            
         }else if(isPriceBreakHighByWick()){
            // high wick break
            isHighWickBreak = true;
            updateWickHighVariable();
            bullishChochDrawing.DrawStraightLine(latestMajorHighIndex,index,latestMajorHighPrice);
            bosRay.deleteRay();
         }
         
         
      }
   }
   
   
   
   
   
   
   
   
   //+------------------------------------------------------------------+
   //|   HELPER FUNCTION                                                |
   //+------------------------------------------------------------------+
   
   
   bool getNewMajorHigh(){
   
      if(macdFractal.latestMacdHighFractalIndex > prevMajorHighIndex &&
         macdFractal.latestMacdHighFractalPrice > prevMajorHighPrice){
         
         latestMajorHighIndex = macdFractal.latestMacdHighFractalIndex;
         latestMajorHighPrice = macdFractal.latestMacdHighFractalPrice;
         latestMajorHighCandle.setValue(
            barData.GetOpen(latestMajorHighIndex),
            barData.GetHigh(latestMajorHighIndex),
            barData.GetLow(latestMajorHighIndex),
            barData.GetClose(latestMajorHighIndex)
         );
         
         return true;
      }
      
      return false;
      
   }
   
   bool getNewMajorLow(){
   
      if(macdFractal.latestMacdLowFractalIndex > prevMajorLowIndex &&
         macdFractal.latestMacdLowFractalPrice < prevMajorLowPrice){
         
         latestMajorLowIndex = macdFractal.latestMacdLowFractalIndex;
         latestMajorLowPrice = macdFractal.latestMacdLowFractalPrice;
         latestMajorLowCandle.setValue(
            barData.GetOpen(latestMajorLowIndex),
            barData.GetHigh(latestMajorLowIndex),
            barData.GetLow(latestMajorLowIndex),
            barData.GetClose(latestMajorLowIndex)
         );
         
         return true;
      }
      
      return false;
      
   }
   
   void getFirstTrend(){
      
      if(macdFractal.prevMacdHighFractalIndex == -1 || macdFractal.prevMacdLowFractalIndex == -1
         || macdFractal.latestMacdHighFractalIndex == -1 || macdFractal.latestMacdLowFractalIndex == -1){
         return;
      }
   
      if(latestMajorHighIndex == -1 || latestMajorLowIndex == -1){
         latestMajorHighIndex = macdFractal.latestMacdHighFractalIndex;
         latestMajorHighPrice = macdFractal.latestMacdHighFractalPrice;
         
         latestMajorLowIndex = macdFractal.latestMacdLowFractalIndex;
         latestMajorLowPrice = macdFractal.latestMacdLowFractalPrice;
      }
   
      if(latestMajorHighIndex == -1 || latestMajorLowIndex == -1 || latestMajorLowIndex == EMPTY_VALUE || latestMajorLowIndex == EMPTY_VALUE){
         return;
      }
      
      majorSwingHighBuffer[latestMajorHighIndex] = latestMajorHighPrice;
      majorSwingLowBuffer[latestMajorLowIndex] = latestMajorLowPrice;
      
      latestMajorHighCandle.setValue(
         barData.GetOpen(latestMajorHighIndex),
         barData.GetHigh(latestMajorHighIndex),
         barData.GetLow(latestMajorHighIndex),
         barData.GetClose(latestMajorHighIndex)
      );
      
      latestMajorLowCandle.setValue(
         barData.GetOpen(latestMajorLowIndex),
         barData.GetHigh(latestMajorLowIndex),
         barData.GetLow(latestMajorLowIndex),
         barData.GetClose(latestMajorLowIndex)
      );
      
      Print("high:",latestMajorHighIndex,"|",barData.GetTime(latestMajorHighIndex));
      Print("low :",latestMajorLowIndex,"|",barData.GetTime(latestMajorLowIndex));
      
      if(latestMajorHighIndex >= latestMajorLowIndex &&
         latestMajorHighPrice >= latestMajorLowPrice){
         
         latestTrend = TREND_BULLISH;
         Print("first trend: BULLISH");
      }
      else if(latestMajorLowIndex >= latestMajorHighIndex &&
         latestMajorLowPrice <= latestMajorHighPrice){
         
         latestTrend = TREND_BEARISH;
         Print("first trend: BEARISH");
      }
      
   }
   
   void updateBullishBosVariable(){
      addTrend(TREND_BULLISH);
      addMarketStructure(MS_BULLISH_BOS);
      
      prevMajorHighIndex = latestMajorHighIndex;
      prevMajorHighPrice = latestMajorHighPrice;
      prevMajorLowIndex = latestMajorLowIndex;
      prevMajorLowPrice = latestMajorLowPrice;
      
      latestMajorHighIndex = -1;
      latestMajorHighPrice = -1;
      latestMajorLowIndex = CandleBreakAnalyzerStatic::GetLowestLowIndex(barData,prevMajorHighIndex,index);
      latestMajorLowPrice = barData.GetLow(latestMajorLowIndex);
      latestMajorLowCandle.setValue(
         barData.GetOpen(latestMajorLowIndex),
         barData.GetHigh(latestMajorLowIndex),
         barData.GetLow(latestMajorLowIndex),
         barData.GetClose(latestMajorLowIndex)
      );
      
      marketBreakAtIndex = index;
      
      resetWickBreak();
      
   }
   
   void updateBearishChochVariable(){
      // bullish major low break
      addTrend(TREND_BEARISH);
      addMarketStructure(MS_BEARISH_CHOCH);
      
      prevMajorLowIndex = latestMajorLowIndex;
      prevMajorLowPrice = latestMajorLowPrice;
      
      latestMajorLowIndex = -1;
      latestMajorLowPrice = -1;
      
      marketBreakAtIndex = index;
      
      resetWickBreak();
      
   }
   
   
   
   
   void updateBearishBosVariable(){
      addTrend(TREND_BEARISH);
      addMarketStructure(MS_BEARISH_BOS);
      
      prevMajorHighIndex = latestMajorHighIndex;
      prevMajorHighPrice = latestMajorHighPrice;
      prevMajorLowIndex = latestMajorLowIndex;
      prevMajorLowPrice = latestMajorLowPrice;
      
      latestMajorHighIndex = CandleBreakAnalyzerStatic::GetHighestHighIndex(barData,prevMajorLowIndex,index);
      latestMajorHighPrice = barData.GetHigh(latestMajorHighIndex);
      latestMajorHighCandle.setValue(
         barData.GetOpen(latestMajorHighIndex),
         barData.GetHigh(latestMajorHighIndex),
         barData.GetLow(latestMajorHighIndex),
         barData.GetClose(latestMajorHighIndex)
      );
      latestMajorLowIndex = -1;
      latestMajorLowPrice = -1;
      
      marketBreakAtIndex = index;
      
      resetWickBreak();
   }
   
   void updateBullishChochVariable(){
      addTrend(TREND_BULLISH);
      addMarketStructure(MS_BULLISH_CHOCH);
      
      prevMajorHighIndex = latestMajorHighIndex;
      prevMajorHighPrice = latestMajorHighPrice;
      
      latestMajorHighIndex = -1;
      latestMajorHighPrice = -1;
      
      marketBreakAtIndex = index;
      
      resetWickBreak();
      
      
   }
   
   void resetWickBreak(){
      isHighWickBreak = false;
      isLowWickBreak = false;
      wickHighIndex = -1;
      wickLowIndex = -1;
      wickHighPrice = -1;
      wickLowPrice = -1;
   }
   
   void updateWickHighVariable(){
      wickHighIndex = index;
      wickHighPrice = barData.GetHigh(index);
      wickHighCandle.setValue(
         barData.GetOpen(wickHighIndex),
         barData.GetHigh(wickHighIndex),
         barData.GetLow(wickHighIndex),
         barData.GetClose(wickHighIndex)
      );
   }
   
   void updateWickLowVariable(){
      wickLowIndex = index;
      wickLowPrice = barData.GetLow(index);
      wickLowCandle.setValue(
         barData.GetOpen(wickLowIndex),
         barData.GetHigh(wickLowIndex),
         barData.GetLow(wickLowIndex),
         barData.GetClose(wickLowIndex)
      );
   }
   
   void addTrend(Trend newTrend){
      prevTrend = latestTrend;
      latestTrend = newTrend;
   }
   
   void addMarketStructure(MarketStructureType newMarketStructure){
      prev2MarketStructure = prevMarketStructure;
      prevMarketStructure = latestMarketStructure;
      latestMarketStructure = newMarketStructure;
   }
      
   //+------------------------------------------------------------------+
   //|   HIGH BREAK                                                     |
   //+------------------------------------------------------------------+
   
   //--- MAJOR HIGH
   bool isPriceBreakHighByBobyOrGap(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByBody(SWING_HIGH,latestMajorHighCandle,currCandle) ||
            CandleBreakAnalyzerStatic::IsPriceBreakByGap(SWING_HIGH,latestMajorHighCandle,prevCandle,currCandle);
   }
   
   bool isPriceBreakHighByWick(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByWick(SWING_HIGH,latestMajorHighCandle,currCandle);
   }
   
   //--- WICK HIGH
   bool isPriceBreakWickHighByBodyOrGap(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByBody(SWING_HIGH,wickHighCandle,currCandle) ||
            CandleBreakAnalyzerStatic::IsPriceBreakByGap(SWING_HIGH,wickHighCandle,prevCandle,currCandle);
   }
   
   bool isPriceBreakWickHighByWick(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByWick(SWING_HIGH,wickHighCandle,currCandle);
   }
   
   //+------------------------------------------------------------------+
   //|   LOW BREAK                                                      |
   //+------------------------------------------------------------------+
   
   //--- MAJOR LOW
   bool isPriceBreakLowByBodyOrGap(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByBody(SWING_LOW,latestMajorLowCandle,currCandle) ||
            CandleBreakAnalyzerStatic::IsPriceBreakByGap(SWING_LOW,latestMajorLowCandle,prevCandle,currCandle);
   }
   
   bool isPriceBreakLowByWick(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByWick(SWING_LOW,latestMajorLowCandle,currCandle);
   }
   
   //--- WICK LOW
   bool isPriceBreakWickLowByBodyOrGap(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByBody(SWING_LOW,wickLowCandle,currCandle) ||
            CandleBreakAnalyzerStatic::IsPriceBreakByGap(SWING_LOW,wickLowCandle,prevCandle,currCandle);
   }
   
   bool isPriceBreakWickLowByWick(){
      return CandleBreakAnalyzerStatic::IsPriceBreakByWick(SWING_LOW,wickLowCandle,currCandle);
   }
   

public:

   MACDFractalClass* macdFractal;

   LineDrawing bullishBosDrawing,
               bullishChochDrawing,
               bullishInducementDrawing,
               bearishBosDrawing,
               bearishChochDrawing,
               bearishInducementDrawing;
   HorizontalRay bosRay,chochRay;               
   
   double majorSwingHighBuffer[],majorSwingLowBuffer[];
   Trend prevTrend,latestTrend;
   MarketStructureType prev2MarketStructure,prevMarketStructure,latestMarketStructure;
   
   int marketBreakAtIndex;

   MacdMarketStructureClass(){
      // construction
      
   }
   
   int getLatestMajorHighIndex(){
      return latestMajorHighIndex;
   }
   
   int getLatestMajorLowIndex(){
      return latestMajorLowIndex;
   }
   
   double getLatestmajorHighPrice(){
      return latestMajorHighPrice;
   }
   
   double getLatestMajorLowPrice(){
      return latestMajorLowPrice;
   }
   
   Trend getLatestTrend(){
      return latestTrend;
   }
   
   
   void init(MACDFractalClass* macdFractalInstance, BarData* barDataInstance){
      // init function
      macdFractal = macdFractalInstance;
      barData = barDataInstance;
      
      latestMajorHighIndex = -1;
      latestMajorLowIndex = -1;
      
      prevTrend = TREND_NONE;
      latestTrend = TREND_NONE;
      
      marketBreakAtIndex = -1;
   }

   void update(int Iindex, int totalBars){
   
      ArrayResize(bullishBosDrawing.buffer, totalBars);
      ArrayResize(bullishInducementDrawing.buffer, totalBars);
      ArrayResize(bullishChochDrawing.buffer, totalBars);
      ArrayResize(bearishBosDrawing.buffer, totalBars);
      ArrayResize(bearishInducementDrawing.buffer, totalBars);
      ArrayResize(bearishChochDrawing.buffer, barData.RatesTotal());
      ArrayResize(bosRay.lineDrawing.buffer, barData.RatesTotal());
      ArrayResize(chochRay.lineDrawing.buffer, barData.RatesTotal());
      
      ArrayResize(majorSwingHighBuffer, totalBars);
      ArrayResize(majorSwingLowBuffer, totalBars);
      
      bullishBosDrawing.buffer[index] = EMPTY_VALUE;
      bullishInducementDrawing.buffer[index] = EMPTY_VALUE;
      bullishChochDrawing.buffer[index] = EMPTY_VALUE;
      bearishBosDrawing.buffer[index] = EMPTY_VALUE;
      bearishInducementDrawing.buffer[index] = EMPTY_VALUE;
      bearishChochDrawing.buffer[index] = EMPTY_VALUE;
      
      bosRay.lineDrawing.buffer[index] = EMPTY_VALUE;
      chochRay.lineDrawing.buffer[index] = EMPTY_VALUE;
      
      majorSwingHighBuffer[index] = EMPTY_VALUE;
      majorSwingLowBuffer[index] = EMPTY_VALUE;
      
      bosRay.extendeRay(index);
      chochRay.extendeRay(index);
      
      index = Iindex;
      if (index >= totalBars - 1) {
        return;
      }
      
      currCandle.setValue(barData.GetOpen(index),
                        barData.GetHigh(index),
                        barData.GetLow(index),
                        barData.GetClose(index));
                        
      prevCandle.setValue(barData.GetOpen(index-1),
                        barData.GetHigh(index-1),
                        barData.GetLow(index-1),
                        barData.GetClose(index-1));                        
      
      if(latestTrend == TREND_NONE){
         getFirstTrend();
      }
      
      switch(latestTrend){
         case TREND_BULLISH:
            bullishMajorHighHandle();
            bullishMajorLowHandle();
            break;
         case TREND_BEARISH:
            bearishMajorHighHandle();
            bearishMajorLowHandle();
            break;   
      }
   }
   
   

   

}

#endif  // MAJORMARKETSTRUCTURECLASS_MQH
