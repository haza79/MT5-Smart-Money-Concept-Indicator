#ifndef ORDERBLOCK_MQH
#define ORDERBLOCK_MQH

#include "Enums.mqh";
#include "BarData.mqh";
#include "MacdMarketStructure.mqh";
#include "Fractal.mqh";
#include "CandleBreakAnalyzerStatic.mqh";


class OrderBlock{

private:
   
   int index;
   bool isOrderBlockCalculated;
   BarData* barData;
   MacdMarketStructureClass* macdMarketStructure;
   FractalClass* fractal;
   
   int getMarketBreakAtIndex;
   
   struct InducementBand{
      double upperBand;
      double lowerBand;
   };
   
   void calcOrderBlock(){
      
      switch(macdMarketStructure.getLatestTrend()){
         case TREND_BULLISH:
            calcBullishOrderBlock();
            break;
         case TREND_BEARISH:
            calcBearishOrderBlock();
            break;
      };
      
      isOrderBlockCalculated = true;
   
   }
   
   void calcBullishOrderBlock(){
      int fractalFromRange[],result[];
      fractal.GetFractalFromRange(macdMarketStructure.getLatestMajorLowIndex(),macdMarketStructure.getInducementIndex()-1,false,fractalFromRange);
   
      int tmp[];
      ArrayResize(tmp, macdMarketStructure.getInducementIndex() - macdMarketStructure.getLatestMajorLowIndex()); // max possible size
      int count = 0;
      
      for(int i = 0; i<ArraySize(fractalFromRange); i++){
         
         InducementBand inducementBand = getInducementBand(fractalFromRange[i]);
         
         bool isFractalSweep = checkBullishFractalSweep(fractalFromRange[i],inducementBand);
         
         if(isFractalSweep){
            tmp[count++] = fractalFromRange[i];
         }

      }
      
      ArrayResize(result, count);
      for (int i = 0; i < count; i++){
         result[i] = tmp[i];
      }
      
      for(int i = 0; i<ArraySize(result); i++){
         //Print(i," : fractal sweep : ",barData.GetTime(result[i]));
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

   void Init(BarData* barDataInstance,MacdMarketStructureClass* macdMarketStructureInstance,FractalClass* fractalInstance){
      barData = barDataInstance;
      macdMarketStructure = macdMarketStructureInstance;
      fractal = fractalInstance;
      
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
