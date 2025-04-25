#ifndef ORDERBLOCK_MQH
#define ORDERBLOCK_MQH

#include "Enums.mqh";
#include "BarData.mqh";
#include "MacdMarketStructure.mqh";
#include "Fractal.mqh";


class OrderBlock{

private:
   
   int index;
   bool isOrderBlockCalculated;
   BarData* barData;
   MacdMarketStructureClass* macdMarketStructure;
   FractalClass* fractal;
   
   
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
            
            int fractalFromRange[];
            if(macdMarketStructure.getLatestTrend() == TREND_BULLISH){
            
               fractal.GetFractalFromRange(macdMarketStructure.getLatestMajorLowIndex(),macdMarketStructure.getInducementIndex()-1,false,fractalFromRange);
               for(int i = 0; i<ArraySize(fractalFromRange); i++){
                  Print(i,":",barData.GetTime(fractalFromRange[i]));
               }
               
               isOrderBlockCalculated = true;
            
            }else if(macdMarketStructure.getLatestTrend() == TREND_BEARISH){
            
            }
            
            
         }
      }
      
      if(!macdMarketStructure.isInducementBreak){
         isOrderBlockCalculated = false;
      }
      
      
      
   }

}

#endif
