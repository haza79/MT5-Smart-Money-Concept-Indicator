//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef MINORMARKETSTRUCTURECLASS_MQH
#define MINORMARKETSTRUCTURECLASS_MQH

#include "Fractal.mqh";
#include "CandleBreakAnalyzer.mqh";
#include "Enums.mqh"
#include "LineDrawing.mqh";

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MinorMarketStructureClass
  {

private:

   // -> private variable ---------------------------------------
   FractalClass* fractal;
   CandleBreakAnalyzerClass candleBreakAnalyzer;


   Trend             trend;
   SwingType         swingType;
   // -----------------------------------------------------------

   // -> private function ---------------------------------------
   void              UpdateMarketStructure(MarketStructureType newStructure)
     {
      prevMarketStructure = latestMarketStructure;
      latestMarketStructure = newStructure;
     }
   // -----------------------------------------------------------

public:
   LineDrawing       bullishBosDrawing;
   LineDrawing       bullishChochDrawing;
   LineDrawing       bearishBosDrawing;
   LineDrawing       bearishChochDrawing;
   MarketStructureType prevMarketStructure,latestMarketStructure;
   double minorSwingHighBuffer[],minorSwingLowBuffer[];

   int               prevMinorHighIndex,prevMinorLowIndex,latestMinorHighIndex,latestMinorLowIndex;
   double prevMinorHighPrice,prevMinorLowPrice,latestMinorHighPrice,latestMinorLowPrice;

                     

   void              Init(FractalClass* fractalInstance)
     {
      fractal = fractalInstance;
      trend = TREND_NONE;
      prevMarketStructure = MS_NONE;
      latestMarketStructure = MS_NONE;

      prevMinorHighIndex   = -1;
      prevMinorLowIndex    = -1;
      latestMinorHighIndex = -1;
      latestMinorLowIndex  = -1;
      
      ArrayInitialize(minorSwingHighBuffer,EMPTY_VALUE);
      ArrayInitialize(minorSwingLowBuffer,EMPTY_VALUE);

     }

   void              Calculate(int i,
                               const int rates_total,
                               const datetime &time[],
                               const double &open[],
                               const double &high[],
                               const double &low[],
                               const double &close[])
     {
      // start here
      ArrayResize(bullishBosDrawing.buffer, rates_total);
      ArrayResize(bullishChochDrawing.buffer, rates_total);
      ArrayResize(bearishBosDrawing.buffer, rates_total);
      ArrayResize(bearishChochDrawing.buffer, rates_total);
      ArrayResize(minorSwingHighBuffer, rates_total);
      ArrayResize(minorSwingLowBuffer, rates_total);

      bullishBosDrawing.buffer[i] = EMPTY_VALUE;
      bullishChochDrawing.buffer[i] = EMPTY_VALUE;
      bearishBosDrawing.buffer[i] = EMPTY_VALUE;
      bearishChochDrawing.buffer[i] = EMPTY_VALUE;
      minorSwingHighBuffer[i] = EMPTY_VALUE;
      minorSwingLowBuffer[i] = EMPTY_VALUE;
      
      if (i >= rates_total - 1) {return;};

      if(i<1)
        {
         return;
        }

      int latestSwingHighIndex = fractal.latestFractalHighIndex;
      int latestSwingLowIndex = fractal.latestFractalLowIndex;

      int prevSwingHighIndex = fractal.prevFractalHighIndex;
      int prevSwingLowIndex = fractal.prevFractalLowIndex;

      // first run . no trend
      
      if(latestSwingHighIndex != -1 && latestSwingLowIndex != -1 && latestMinorHighIndex == -1 && latestMinorLowIndex == -1)
        {

         double latestSwingHighPrice = high[latestSwingHighIndex];
         double latestSwingLowPrice = low[latestSwingLowIndex];

         if(latestSwingHighIndex > latestSwingLowIndex && latestSwingHighPrice > latestSwingLowPrice)
           {
            trend = TREND_BULLISH;
           }
         else
            if(latestSwingLowIndex > latestSwingHighIndex && latestSwingLowPrice < latestSwingHighPrice)
              {
               trend = TREND_BEARISH;
              }

         latestMinorHighIndex = latestSwingHighIndex;

         latestMinorLowIndex = latestSwingLowIndex;
         
         minorSwingHighBuffer[latestSwingHighIndex] = high[latestSwingHighIndex];
         prevMinorHighPrice = latestMinorHighPrice;
         latestMinorHighPrice = high[latestSwingHighIndex];
         
         minorSwingLowBuffer[latestSwingLowIndex] = low[latestSwingLowIndex];
         prevMinorLowPrice = latestMinorLowPrice;
         latestMinorLowPrice = low[latestSwingLowIndex];

        }

      if(trend == TREND_NONE)
        {
         return;
        }

      //start here
      Candle currCandleStruct(open[i],high[i],low[i],close[i]);
      Candle prevCandleStruct(open[i-1],high[i-1],low[i-1],close[i-1]);

      Candle latestMinorHighPriceStruct;
      Candle latestMinorLowPriceStruct;
      if(latestMinorHighIndex != -1)
        {
         latestMinorHighPriceStruct.setValue(open[latestMinorHighIndex],high[latestMinorHighIndex],low[latestMinorHighIndex],close[latestMinorHighIndex]);
         latestMinorHighPrice = latestMinorHighPriceStruct.high;
        }

      if(latestMinorLowIndex != -1)
        {
         latestMinorLowPriceStruct.setValue(open[latestMinorLowIndex],high[latestMinorLowIndex],low[latestMinorLowIndex],close[latestMinorLowIndex]);
         latestMinorLowPrice = latestMinorLowPriceStruct.low;
        }

      if(trend == TREND_BULLISH)
        {
        
        /*
        // bos and choch in same candle. sweep. bullish bos -> bearish choch
         if(candleBreakAnalyzer.IsPriceBreakByAny(SWING_LOW,latestMinorLowPriceStruct,prevCandleStruct,currCandleStruct)&&
            candleBreakAnalyzer.IsPriceBreakByAny(SWING_HIGH,latestMinorHighPriceStruct,prevCandleStruct,currCandleStruct)){
            
            Print("sweep:",time[i]);
            trend = TREND_BEARISH;
            UpdateMarketStructure(MS_BULLISH_BOS);
            UpdateMarketStructure(MS_BEARISH_CHOCH);
            
            bullishBosDrawing.DrawStraightLine(latestMinorHighIndex,i,high[latestMinorHighIndex],time);
            bearishChochDrawing.DrawStraightLine(latestMinorLowIndex,i,low[latestMinorLowIndex],time);
            
            prevMinorHighIndex = latestMinorHighIndex;
            prevMinorLowIndex = latestMinorLowIndex;
            
            latestMinorHighIndex = candleBreakAnalyzer.GetHighestHighIndex(high,prevMinorLowIndex,i);
            latestMinorLowIndex = -1;
            
            return;
         }
         */
        
        // choch curr price break minor low
         if(candleBreakAnalyzer.IsPriceBreakByAny(SWING_LOW,latestMinorLowPriceStruct,prevCandleStruct,currCandleStruct)){
            trend = TREND_BEARISH;
            bearishChochDrawing.DrawStraightLine(latestMinorLowIndex,i,low[latestMinorLowIndex],time);

            UpdateMarketStructure(MS_BEARISH_CHOCH);

            prevMinorHighIndex = -1;
            prevMinorLowIndex = latestMinorLowIndex;

            latestMinorLowIndex = -1;
            
            
            
            return;
           }
        
        // -> bos
         if(latestMinorHighIndex == -1)
           {
            // -> get new swing high as minor high
            if(latestSwingHighIndex > prevMinorHighIndex && high[latestSwingHighIndex] > high[prevMinorHighIndex])
              {
               latestMinorHighIndex = latestSwingHighIndex;
               minorSwingHighBuffer[latestSwingHighIndex] = high[latestSwingHighIndex];
               prevMinorHighPrice = latestMinorHighPrice;
         latestMinorHighPrice = high[latestSwingHighIndex];
              }
           }
         else
           {
            if(candleBreakAnalyzer.IsPriceBreakByAny(SWING_HIGH,latestMinorHighPriceStruct,prevCandleStruct,currCandleStruct)){
               // -> bos
               bullishBosDrawing.DrawStraightLine(latestMinorHighIndex,i,high[latestMinorHighIndex],time);

               UpdateMarketStructure(MS_BULLISH_BOS);

               prevMinorHighIndex = latestMinorHighIndex;
               prevMinorLowIndex = latestMinorLowIndex;

               latestMinorHighIndex = -1;
               latestMinorLowIndex = candleBreakAnalyzer.GetLowestLowIndex(low,prevMinorHighIndex,i);
               
               minorSwingLowBuffer[latestMinorLowIndex] = low[latestMinorLowIndex];
               prevMinorLowPrice = latestMinorLowPrice;
         latestMinorLowPrice = low[latestSwingLowIndex];
               
               
               
               return;
              }

           }
        
         

         

         return;

        }


      if(trend == TREND_BEARISH)
        {
        
        /*
        // bos and choch. sweep. bearish bos -> bullish choch
        if(
        candleBreakAnalyzer.IsPriceBreakByAny(SWING_HIGH,latestMinorHighPriceStruct,prevCandleStruct,currCandleStruct) &&
        candleBreakAnalyzer.IsPriceBreakByAny(SWING_LOW,latestMinorLowPriceStruct,prevCandleStruct,currCandleStruct)){
           
            Print("sweep:",time[i]);
            
            trend = TREND_BULLISH;
            UpdateMarketStructure(MS_BEARISH_BOS);
            UpdateMarketStructure(MS_BULLISH_CHOCH);
            
            bearishBosDrawing.DrawStraightLine(prevMinorLowIndex,i,low[prevMinorLowIndex],time);
            bullishChochDrawing.DrawStraightLine(prevMinorHighIndex,i,high[prevMinorHighIndex],time);
            
            prevMinorHighIndex = latestMinorHighIndex;
            prevMinorLowIndex = latestMinorLowIndex;
            
            latestMinorHighIndex = -1;
            latestMinorLowIndex = candleBreakAnalyzer.GetLowestLowIndex(low,prevMinorLowIndex,i);
            
            return;
           
           
           
        }
        */
        
        
        // -> choch
         if(candleBreakAnalyzer.IsPriceBreakByAny(SWING_HIGH,latestMinorHighPriceStruct,prevCandleStruct,currCandleStruct)){
            trend = TREND_BULLISH;
            bullishChochDrawing.DrawStraightLine(latestMinorHighIndex,i,high[latestMinorHighIndex],time);

            UpdateMarketStructure(MS_BULLISH_CHOCH);

            prevMinorHighIndex = latestMinorHighIndex;
            prevMinorLowIndex = -1;

            latestMinorHighIndex = -1;

            return;
           }

         // -> bos
         if(latestMinorLowIndex == -1)
           {
            // -> get new swing high as minor high
            if(latestSwingLowIndex > prevMinorLowIndex && low[latestSwingLowIndex] < low[prevMinorLowIndex])
              {
               latestMinorLowIndex = latestSwingLowIndex;
               minorSwingLowBuffer[latestSwingLowIndex] = low[latestSwingLowIndex];
               prevMinorLowPrice = latestMinorLowPrice;
         latestMinorLowPrice = low[latestSwingLowIndex];
              }
           }
         else
           {
            if(candleBreakAnalyzer.IsPriceBreakByAny(SWING_LOW,latestMinorLowPriceStruct,prevCandleStruct,currCandleStruct)){
               // -> bos
               bearishBosDrawing.DrawStraightLine(latestMinorLowIndex,i,low[latestMinorLowIndex],time);

               UpdateMarketStructure(MS_BEARISH_BOS);

               prevMinorHighIndex = latestMinorHighIndex;
               prevMinorLowIndex = latestMinorLowIndex;

               latestMinorHighIndex = candleBreakAnalyzer.GetHighestHighIndex(high,prevMinorLowIndex,i);
               latestMinorLowIndex = -1;
               
               minorSwingHighBuffer[latestMinorHighIndex] = high[latestMinorHighIndex];
               prevMinorHighPrice = latestMinorHighPrice;
         latestMinorHighPrice = high[latestSwingHighIndex];
               return;
              }

           }

         

         
         return;

        }

     }
  }

#endif
//+------------------------------------------------------------------+
