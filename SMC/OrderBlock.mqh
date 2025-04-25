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
   
      if(macdMarketStructure.getLatestTrend() == TREND_BULLISH){
         calcBullishOrderBlock();
      }
      
      isOrderBlockCalculated = true;
   
   }
   
   void calcBullishOrderBlock(){
      int fractalFromRange[];
      fractal.GetFractalFromRange(macdMarketStructure.getLatestMajorLowIndex(),macdMarketStructure.getInducementIndex()-1,false,fractalFromRange);
   
      for(int i = 0; i<ArraySize(fractalFromRange); i++){
         Print(i,":",barData.GetTime(fractalFromRange[i]));
         
         InducementBand inducementBand = getInducementBand(fractalFromRange[i]);
         
         checkBullishFractalSweep(fractalFromRange[i],inducementBand);
         
         Print("---");
      }
   }
   
   void checkBullishFractalSweep(int fractalIndex,InducementBand &inducementBand){
      for(int j = fractalIndex-1; j > macdMarketStructure.getPrevMajorLowIndex(); j--){
         if(barData.GetLow(j) < inducementBand.lowerBand){
            Print(j,": out at candle:",barData.GetTime(j));
            break;
         }
         Print(j,": check at:",barData.GetTime(j));
         if(barData.GetLow(j) >= inducementBand.lowerBand && barData.GetLow(j) <= inducementBand.upperBand){
            Print(j,": fractal sweep from candle:",barData.GetTime(j));
            break;
         }
      }
   }
   
   InducementBand getInducementBand(int inducementIndex){
      double inducementUpperBand,inducementLowerBand;
      if(barData.GetClose(inducementIndex) >= barData.GetOpen(inducementIndex)){
      // inducement bullish candle
         inducementUpperBand = barData.GetOpen(inducementIndex);
         inducementLowerBand = barData.GetLow(inducementIndex);
      }else{
         // inducement bearish candle
         inducementUpperBand = barData.GetClose(inducementIndex);
         inducementLowerBand = barData.GetLow(inducementIndex);
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
