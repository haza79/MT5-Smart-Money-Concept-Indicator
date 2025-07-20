#ifndef ORDERBLOCK_MQH
#define ORDERBLOCK_MQH

#include "Enums.mqh";
#include "BarData.mqh";
#include "MacdMarketStructure.mqh";
#include "Fractal.mqh";
#include "CandleBreakAnalyzerStatic.mqh";
#include "InsideBarClass.mqh";
#include "Fibonacci.mqh";

class OrderBlock{

private:
   
   int index;
   bool isOrderBlockCalculated;
   BarData* barData;
   MacdMarketStructureClass* macdMarketStructure;
   FractalClass* fractal;
   InsideBarClass *insideBar;
   Fibonacci *fibonacci;
   
   int getMarketBreakAtIndex;
   
   struct InducementBand{
      double upperBand;
      double lowerBand;
   };
   
   void calcOrderBlock(){
      
      switch(macdMarketStructure.getLatestTrend()){
         case TREND_BULLISH:
            Print("bullish orderblock at major swing H:",barData.GetTime(macdMarketStructure.getLatestMajorHighIndex())," L:",barData.GetTime(macdMarketStructure.getPrevMajorLowIndex()));
            calcBullishOrderBlock();
            break;
         case TREND_BEARISH:
            Print("bearish orderblock at major swing H:",barData.GetTime(macdMarketStructure.getLatestMajorHighIndex())," L:",barData.GetTime(macdMarketStructure.getPrevMajorLowIndex()));
            calcBearishOrderBlock();
            break;
      };
      
      Print("++++++++");
      isOrderBlockCalculated = true;
   
   }
   
   void calcBullishOrderBlock(){
      int fractalFromRange[],result[],orderBlock[];
      fractal.GetFractalFromRange(macdMarketStructure.getLatestMajorLowIndex(),macdMarketStructure.getInducementIndex()-1,false,fractalFromRange);
      
      int fractalRemoveCount = ArraySize(fractalFromRange);
      if (fractalRemoveCount == 0)
         return; // nothing to do
      
      double fiboLevel = fibonacci.fiboRetrace.getFiboLevel(0);
      
      for (int i = fractalRemoveCount - 1; i >= 0; i--) {
          int fractalIndex = fractalFromRange[i];
          double low = barData.GetLow(fractalIndex);
      
          if (low < fiboLevel) {
              ArrayRemove(fractalFromRange, i + 1);  // Keep elements 0..i
              break;
          }
      }
      

      
      int tmp[],orderBlockTmp[];
      ArrayResize(tmp, macdMarketStructure.getInducementIndex() - macdMarketStructure.getLatestMajorLowIndex()); // max possible size
      ArrayResize(orderBlockTmp, macdMarketStructure.getInducementIndex() - macdMarketStructure.getLatestMajorLowIndex()); // max possible size
      int count = 0,orderBlockCount = 0;
      
      for(int i = 0; i<ArraySize(fractalFromRange); i++){
      
         int getFractal = fractalFromRange[i];
         
         InducementBand inducementBand = getInducementBand(getFractal);
         
         bool isFractalSweep = checkBullishFractalSweep(getFractal,inducementBand);
         
         if(isFractalSweep){
            
            bool isFvg = identifyFVG(TREND_BULLISH,getFractal,getFractal+1,getFractal+2);
            
            int lowestLowIndex = barData.getLowestLowValueByRange(getFractal+3);
            double lowestLowPrice = barData.GetLow(lowestLowIndex);
            
            if(lowestLowPrice<=barData.GetHigh(getFractal)){
               continue;
            }
            
            if(isFvg){
               orderBlockTmp[orderBlockCount++] = getFractal;
            }
         }
         
         /*
         if(insideBar.GetMotherBar(fractalFromRange[i]) == 1){
            // fractal are mother bar
         }else{
            // fractal not mother bar
            bool isFvg = identifyFVG(TREND_BULLISH,fractalFromRange[i],fractalFromRange[i]+1,fractalFromRange[i]+2);
            if(isFvg){
               Print("orderblock:",barData.GetTime(fractalFromRange[i])," | have fvg");
            }
         }
         */
         
         if(isFractalSweep){
            tmp[count++] = getFractal;
         }

      }
      
      ArrayResize(result, count);
      for (int i = 0; i < count; i++){
         result[i] = tmp[i];
      }
      
      ArrayResize(orderBlock, orderBlockCount);
      for (int i = 0; i < orderBlockCount; i++){
         orderBlock[i] = orderBlockTmp[i];
      }
      
      
      for(int i = 0; i<ArraySize(result); i++){
         Print(i," : fractal sweep : ",barData.GetTime(result[i]));
      }
      
      for(int i = 0; i<ArraySize(orderBlock); i++){
         Print(i," : orderblock : ",barData.GetTime(orderBlock[i]));
      }
         
         
   }
   
   void calcBearishOrderBlock(){
      int fractalFromRange[],result[];
      fractal.GetFractalFromRange(macdMarketStructure.getLatestMajorHighIndex(),macdMarketStructure.getInducementIndex()-1,true,fractalFromRange);
      
      
   
      int tmp[];
      ArrayResize(tmp, macdMarketStructure.getInducementIndex() - macdMarketStructure.getLatestMajorHighIndex()); // max possible size
      int count = 0;
      
      for(int i = 0; i<ArraySize(fractalFromRange); i++){
         
         InducementBand inducementBand = getInducementBand(fractalFromRange[i]);
         
         bool isFractalSweep = checkBearishFractalSweep(fractalFromRange[i],inducementBand);
         
         if(isFractalSweep){
            tmp[count++] = fractalFromRange[i];
         }

      }
      
      ArrayResize(result, count);
      for (int i = 0; i < count; i++){
         result[i] = tmp[i];
      }
      
      for(int i = 0; i<ArraySize(result); i++){
         Print(i," : fractal sweep : ",barData.GetTime(result[i]));
      }
         
         
   }
   
   bool identifyFVG(Trend trend, int firstCandleIndex, int secondCandleIndex, int thirdCandleIndex){
      // Validate indices
      if(firstCandleIndex < 0 || secondCandleIndex < 0 || thirdCandleIndex < 0)
         return false;
   
      double firstCandleHigh,firstCandleLow,secondCandleHigh,secondCandleLow,thirdCandleHigh,thirdCandleLow;
      
      firstCandleHigh = barData.GetHigh(firstCandleIndex);
      secondCandleHigh = barData.GetHigh(secondCandleIndex);
      thirdCandleHigh = barData.GetHigh(thirdCandleIndex);
      
      firstCandleLow = barData.GetLow(firstCandleIndex);
      secondCandleLow = barData.GetLow(secondCandleIndex);
      thirdCandleLow = barData.GetLow(thirdCandleIndex);
      
      if(trend == TREND_BULLISH){
         if(secondCandleHigh > firstCandleHigh &&
            secondCandleLow <= firstCandleHigh &&
            secondCandleLow > firstCandleLow &&
            thirdCandleHigh > secondCandleHigh &&
            thirdCandleLow <= secondCandleHigh &&
            thirdCandleLow > secondCandleLow){
            
            // fvg
            return true;   
         }
      }
      else if(trend == TREND_BEARISH){
         if(secondCandleHigh >= firstCandleLow &&
            secondCandleHigh < firstCandleHigh &&
            secondCandleLow < firstCandleLow &&
            thirdCandleHigh >= secondCandleLow &&
            thirdCandleHigh < secondCandleHigh &&
            thirdCandleLow < secondCandleLow){
            // fvg
            return true;
         }
      }
   
      return false;
   }
   
   void filterUnTakenFractal(int &fractals[],int &result[]){
      for(int i = 0; i<ArraySize(fractals); i++){
      
      }
   }
   
   bool checkBullishFractalSweep(int fractalIndex,InducementBand &inducementBand){
      for(int j = fractalIndex-1; j > macdMarketStructure.getPrevMajorLowIndex(); j--){
         if(barData.GetLow(j) < inducementBand.lowerBand){
            // out of candle to process
            // candle are break inducement band
            return false;
         }
         
         if(barData.GetLow(j) >= inducementBand.lowerBand && barData.GetLow(j) <= inducementBand.upperBand){
            // fractal get sweep by wick
            return true;
         }
      }
      
      return false;
   }
   
   bool checkBearishFractalSweep(int fractalIndex,InducementBand &inducementBand){
      for(int j = fractalIndex-1; j > macdMarketStructure.getPrevMajorHighIndex(); j--){
         if(barData.GetHigh(j) > inducementBand.upperBand){
            // out of candle to process
            // candle are break inducement band
            return false;
         }
         
         if(barData.GetHigh(j) >= inducementBand.lowerBand && barData.GetHigh(j) <= inducementBand.upperBand){
            // fractal get sweep by wick
            return true;
         }
      }
      
      return false;
   }
   
   
   
   InducementBand getInducementBand(int inducementIndex){
      double inducementUpperBand,inducementLowerBand;
      if(barData.GetClose(inducementIndex) >= barData.GetOpen(inducementIndex)){
      // inducement bullish candle
         inducementUpperBand = barData.GetOpen(inducementIndex);
         inducementLowerBand = barData.GetLow(inducementIndex);
      }else{
         // inducement bearish candle
         inducementUpperBand = barData.GetHigh(inducementIndex);
         inducementLowerBand = barData.GetOpen(inducementIndex);
      }
      
      InducementBand inducement;
      inducement.upperBand = inducementUpperBand;
      inducement.lowerBand = inducementLowerBand;
      return inducement;
   }
   
   
   
   
public:

   void Init(BarData* barDataInstance,MacdMarketStructureClass* macdMarketStructureInstance,FractalClass* fractalInstance,InsideBarClass *insideBarInstance,Fibonacci *fibonacciInstance){
      barData = barDataInstance;
      macdMarketStructure = macdMarketStructureInstance;
      fractal = fractalInstance;
      insideBar = insideBarInstance;
      fibonacci = fibonacciInstance;
      
      isOrderBlockCalculated = false;
   }
   
   void update(int Iindex, int totalBars){
      index = Iindex;
      if (index >= totalBars - 1) {
        return;
      }
      
      if(!isOrderBlockCalculated){
         if(macdMarketStructure.isInducementBreak){
            
            calcOrderBlock();
            
         }
      }
      
      if(getMarketBreakAtIndex != macdMarketStructure.marketBreakAtIndex){
            //
            getMarketBreakAtIndex = macdMarketStructure.marketBreakAtIndex;
            isOrderBlockCalculated = false;
            
        }
      
      
      
   }

}

#endif
