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

   struct BiasSwingAndInducement
     {
      int            biasSwingIndex;
      int            inducementIndex;
     };

   bool              oneTime;

public:


   // Constructor to initialize variables
   void              Init(BarData *barDataInstance,FractalClass *fractalInstance)
     {
      barData = barDataInstance;
      fractal = fractalInstance;

      oneTime = false;
      prevTrend = TREND_NONE;
      latestTrend = TREND_NONE;

      prevMajorHighIndex = prevMajorLowIndex = latestMajorHighIndex = latestMajorLowIndex = -1;
      biasHighIndex = biasLowIndex = -1;

      prevMajorHighPrice = prevMajorLowPrice = latestMajorHighPrice = latestMajorLowPrice = -1;
      biasHighPrice = biasLowPrice = -1;

      // No need to initialize arrays since we reference external arrays
     }

   // Calculate method which works with references to the external arrays
   void              Calculate(int Iindex)
     {
      index = Iindex;
      UpdateMarketStructure();
     }

   void              UpdateMarketStructure()
     {
      if(oneTime == true)
        {
         return;
        }
      if(latestTrend == TREND_NONE)
        {

         if(fractal.prevFractalHighIndex != -1 && fractal.latestFractalHighIndex != -1
            && fractal.prevFractalLowIndex != -1 && fractal.latestFractalLowIndex != -1)
           {

            if(fractal.latestFractalHighPrice > fractal.prevFractalHighPrice)
              {
               latestTrend = TREND_BULLISH;
              }

            if(fractal.latestFractalLowPrice < fractal.prevFractalLowPrice)
              {
               latestTrend = TREND_BEARISH;
              }


           }
         else
           {
            return;
           }


        }

      if(latestTrend == TREND_BULLISH)
        {

         if(latestMajorHighIndex == -1)
           {
            GetBiasHighAndInducement();
            if(biasHighIndex == -1)
              {
               return;
              }
            Print(barData.GetTime(index)," | bias high:",barData.GetTime(biasHighIndex)," | inducement:",barData.GetTime(inducementIndex));

            Print(barData.GetTime(index)," | low:",barData.GetLow(index)," | inducement price:",inducementPrice," | is break inducement:",barData.GetLow(index) <= inducementPrice);
            if(barData.GetLow(index) <= inducementPrice)
              {
               Print("bias high:",barData.GetTime(biasHighIndex));
               Print("inducement:",barData.GetTime(inducementIndex));
               Print("price break inducement:",barData.GetTime(index));
               oneTime = true;
              }
           }
        }

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
