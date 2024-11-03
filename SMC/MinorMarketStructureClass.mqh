//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef MINORMARKETSTRUCTURECLASS_MQH
#define MINORMARKETSTRUCTURECLASS_MQH

#include "ImpulsePullbackDetector.mqh";
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
   ImpulsePullbackDetectorClass* impulsePullbackDetector;
   CandleBreakAnalyzerClass candleBreakAnalyzer;


   Trend             trend;
   SwingType         swingType;

   MarketStructureType prevMarketStructure,latestMarketStructure;
   // -----------------------------------------------------------

   // -> private function ---------------------------------------
   void              UpdateMarketStructure(MarketStructureType newStructure)
     {
      prevMarketStructure = latestMarketStructure;
      latestMarketStructure = newStructure;
     }
   // -----------------------------------------------------------

public:
   LineDrawing       bosLineDrawing;
   LineDrawing       chochLineDrawing;
   int               prevMinorHighIndex,prevMinorLowIndex,latestMinorHighIndex,latestMinorLowIndex;

                     MinorMarketStructureClass() : impulsePullbackDetector(NULL) {}

   void              Init(ImpulsePullbackDetectorClass* impulsePullbackDetectorInstance)
     {
      impulsePullbackDetector = impulsePullbackDetectorInstance;
      trend = TREND_NONE;
      prevMarketStructure = MS_NONE;
      latestMarketStructure = MS_NONE;

      prevMinorHighIndex   = -1;
      prevMinorLowIndex    = -1;
      latestMinorHighIndex = -1;
      latestMinorLowIndex  = -1;

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
      ArrayResize(bosLineDrawing.buffer, rates_total);
      ArrayResize(chochLineDrawing.buffer, rates_total);

      bosLineDrawing.buffer[i] = EMPTY_VALUE;
      chochLineDrawing.buffer[i] = EMPTY_VALUE;
      Print("trend:",trend);
      Print("prev market:",prevMarketStructure," | latest market:",latestMarketStructure);

      if(i<1)
        {
         return;
        }

      int latestSwingHighIndex = impulsePullbackDetector.latestSwingHighIndex;
      int latestSwingLowIndex = impulsePullbackDetector.latestSwingLowIndex;

      int prevSwingHighIndex = impulsePullbackDetector.prevSwingHighIndex;
      int prevSwingLowIndex = impulsePullbackDetector.prevSwingLowIndex;

      Print("latest minor high i:",latestMinorHighIndex,"  |latest minor low i:",latestMinorLowIndex);
      Print("prev   minor high i:",prevMinorHighIndex,"    |prev minor low i:",prevMinorLowIndex);


      // first run . no trend
      if(latestSwingHighIndex != -1 && latestSwingLowIndex != -1 && latestMinorHighIndex == -1 && latestMinorLowIndex == -1)
        {

         Print("two swing are detected");

         double latestSwingHighPrice = high[latestSwingHighIndex];
         double latestSwingLowPrice = low[latestSwingLowIndex];

         if(latestSwingHighIndex > latestSwingLowIndex && latestSwingHighPrice > latestSwingLowPrice)
           {
            trend = TREND_BULLISH;
            Print("trend bullish");
           }
         else
            if(latestSwingLowIndex > latestSwingHighIndex && latestSwingLowPrice < latestSwingHighPrice)
              {
               Print("trend bearish");
               trend = TREND_BEARISH;
              }

         latestMinorHighIndex = latestSwingHighIndex;

         latestMinorLowIndex = latestSwingLowIndex;

        }

      if(trend == TREND_NONE)
        {
         Print("don't have first trend");
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
        }

      if(latestMinorLowIndex != -1)
        {
         latestMinorLowPriceStruct.setValue(open[latestMinorLowIndex],high[latestMinorLowIndex],low[latestMinorLowIndex],close[latestMinorLowIndex]);
        }
      //Candle latestMinorHighPriceStruct(open[latestMinorHighIndex],high[latestMinorHighIndex],low[latestMinorHighIndex],close[latestMinorHighIndex]);
      //Candle latestMinorLowPriceStruct(open[latestMinorLowIndex],high[latestMinorLowIndex],low[latestMinorLowIndex],close[latestMinorLowIndex]);

      if(trend == TREND_BULLISH)
        {
         // choch curr price break minor low
         if(candleBreakAnalyzer.IsPriceBreakByBody(SWING_LOW,latestMinorLowPriceStruct,currCandleStruct)
            || candleBreakAnalyzer.IsPriceBreakByWick(SWING_LOW,latestMinorLowPriceStruct,currCandleStruct)
            || candleBreakAnalyzer.IsPriceBreakByGap(SWING_LOW,latestMinorLowPriceStruct,prevCandleStruct,currCandleStruct))
           {
            // draw choch line from latest minor low to price break
            Print("bullish -> bearish choch, at ",time[i]);
            trend = TREND_BEARISH;
            chochLineDrawing.DrawStraightLine(latestMinorLowIndex,i,low[latestMinorLowIndex]);

            UpdateMarketStructure(MS_BEARISH_CHOCH);

            prevMinorHighIndex = -1;
            prevMinorLowIndex = latestMinorLowIndex;

            latestMinorLowIndex = -1;

            return;

           }

         // -> bos
         if(latestMinorHighIndex == -1)
           {
           Print("get newest swing high as minor");
            // -> get new swing high as minor high
            if(latestSwingHighIndex > prevMinorHighIndex && high[latestSwingHighIndex] > high[prevMinorHighIndex])
              {
               latestMinorHighIndex = latestSwingHighIndex;
              }
           }
         else
           {
            if(candleBreakAnalyzer.IsPriceBreakByBody(SWING_HIGH,latestMinorHighPriceStruct,currCandleStruct)
               || candleBreakAnalyzer.IsPriceBreakByWick(SWING_HIGH,latestMinorHighPriceStruct,currCandleStruct)
               || candleBreakAnalyzer.IsPriceBreakByGap(SWING_HIGH,latestMinorHighPriceStruct,prevCandleStruct,currCandleStruct))
              {
               // -> bos
               Print("bullish -> bullish bos, at ",time[i]);
               bosLineDrawing.DrawStraightLine(latestMinorHighIndex,i,high[latestMinorHighIndex]);

               UpdateMarketStructure(MS_BULLISH_BOS);

               prevMinorHighIndex = latestMinorHighIndex;
               prevMinorLowIndex = latestMinorLowIndex;

               latestMinorHighIndex = -1;
               latestMinorLowIndex = candleBreakAnalyzer.GetLowestLowIndex(low,prevMinorHighIndex,i);
              }

           }

         return;

        }


      if(trend == TREND_BEARISH)
        {

         // -> choch
         if(candleBreakAnalyzer.IsPriceBreakByBody(SWING_HIGH,latestMinorHighPriceStruct,currCandleStruct)
            || candleBreakAnalyzer.IsPriceBreakByWick(SWING_HIGH,latestMinorHighPriceStruct,currCandleStruct)
            || candleBreakAnalyzer.IsPriceBreakByGap(SWING_HIGH,latestMinorHighPriceStruct,prevCandleStruct,currCandleStruct))
           {
            Print("bearish -> bullihs choch, at ",time[i]);
            trend = TREND_BULLISH;
            chochLineDrawing.DrawStraightLine(latestMinorHighIndex,i,high[latestMinorHighIndex]);

            UpdateMarketStructure(MS_BULLISH_CHOCH);

            prevMinorHighIndex = latestMinorHighIndex;
            prevMinorLowIndex = -1;

            latestMinorHighIndex = -1;

            return;

           }

         // -> bos
         if(latestMinorLowIndex == -1)
           {
           Print("get newest swing low as minor");
            // -> get new swing high as minor high
            if(latestSwingLowIndex > prevMinorLowIndex && low[latestSwingLowIndex] < low[prevMinorLowIndex])
              {
               latestMinorLowIndex = latestSwingLowIndex;
              }
           }
         else
           {
            if(candleBreakAnalyzer.IsPriceBreakByBody(SWING_LOW,latestMinorLowPriceStruct,currCandleStruct)
               || candleBreakAnalyzer.IsPriceBreakByWick(SWING_LOW,latestMinorLowPriceStruct,currCandleStruct)
               || candleBreakAnalyzer.IsPriceBreakByGap(SWING_LOW,latestMinorLowPriceStruct,prevCandleStruct,currCandleStruct))
              {
               // -> bos
               Print("bearish -> bearish bos, at ",time[i]);
               bosLineDrawing.DrawStraightLine(latestMinorLowIndex,i,low[latestMinorLowIndex]);

               UpdateMarketStructure(MS_BEARISH_BOS);

               prevMinorHighIndex = latestMinorHighIndex;
               prevMinorLowIndex = latestMinorLowIndex;

               latestMinorHighIndex = candleBreakAnalyzer.GetHighestHighIndex(high,prevMinorLowIndex,i);
               latestMinorLowIndex = -1;
              }

           }
         Print("-----");
         return;

        }

     }
  }

#endif
//+------------------------------------------------------------------+
