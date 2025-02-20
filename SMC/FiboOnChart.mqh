#ifndef FIBOONCHART_MQH
#define FIBOONCHART_MQH

#include "BarData.mqh";
#include "MacdMarketStructure.mqh";
#include "FiboCircle.mqh";


class FiboOnChart{

private:
   BarData* barData;
   MacdMarketStructureClass* macdMarketStructure;
   FiboCircle fiboCircle;
   int index;
   
   double fiboCircleRatios[];
   int fiboCircleSize;
   struct fiboLevels {
      double ratio;
      double price;
   };
   fiboLevels fiboCircleTopLevel[];
   fiboLevels fiboCircleBottomLevel[];
   
   
   
   double GetFiboLevel(fiboLevels &fiboLevelArray[],double ratio) {
        for (int i = 0; i < ArraySize(fiboLevelArray); i++) {
            if (fiboLevelArray[i].ratio == ratio) {
                return fiboLevelArray[i].price;
            }
        }
        return -1; // Return -1 if the ratio is not found
    }
   
   //+------------------------------------------------------------------+
   //|   FIBO CIRCLE                                                    |
   //+------------------------------------------------------------------+
   int macdSwingHigh,macdSwingLow;
   
   void fiboCircleHandle(){
      if(macdMarketStructure.getLatestMajorHighIndex() == -1 || macdMarketStructure.getLatestMajorLowIndex() == -1){
         return;
      }
      if(macdMarketStructure.getLatestMajorHighIndex() == macdSwingHigh && macdMarketStructure.getLatestMajorLowIndex() == macdSwingLow){
         return;
      }else{
         macdSwingHigh = macdMarketStructure.getLatestMajorHighIndex();
         macdSwingLow = macdMarketStructure.getLatestMajorLowIndex();
      }
      switch(macdMarketStructure.latestTrend){
         case TREND_BULLISH:
            fiboCircleBullishHandle();
            break;
         
         case TREND_BEARISH:
            break;   
            
      }
   }
   
   void fiboCircleBullishHandle(){
      calculateFiboCircle(macdMarketStructure.getLatestmajorHighPrice(),macdMarketStructure.getLatestMajorLowPrice());
   }
   
   void calculateFiboCircle(double swingHighPrice, double swingLowPrice){
      ArrayResize(fiboCircleTopLevel,fiboCircleSize);
      ArrayResize(fiboCircleBottomLevel,fiboCircleSize);
      
      fiboCircle.init(swingHighPrice,swingLowPrice);
      Print("high:",barData.GetTime(macdMarketStructure.getLatestMajorHighIndex()));
      Print("low :",barData.GetTime(macdMarketStructure.getLatestMajorLowIndex()));
      for(int i = 0; i<fiboCircleSize; i++){
         double fiboRatio = fiboCircleRatios[i];
         double fiboTopLevel = fiboCircle.calculateFibo(fiboRatio,FIBO_TOP);
         double fiboBottomLevel = fiboCircle.calculateFibo(fiboRatio,FIBO_BOTTOM);
         
         fiboCircleTopLevel[i].ratio = fiboRatio;
         fiboCircleTopLevel[i].price = fiboTopLevel;
         Print("ratio:",fiboRatio," | level:",fiboTopLevel);
         
         
         fiboCircleBottomLevel[i].ratio = fiboRatio;
         fiboCircleBottomLevel[i].price = fiboBottomLevel;
      }
   }

public:

   void setFiboCircleRatios(const double &inputArray[]){
      fiboCircleSize = ArraySize(inputArray);
      ArrayResize(fiboCircleRatios,fiboCircleSize);
      ArrayCopy(fiboCircleRatios,inputArray);
   }

   void init(BarData* barDataInstance, MacdMarketStructureClass* macdMarketStructureInstance){
      // init function
      barData = barDataInstance;
      macdMarketStructure = macdMarketStructureInstance;
   }
   
   void update(int Iindex,int rates_total){
      index = Iindex;
      
      if (index >= rates_total - 1) {
        return;
      }
      
      if(macdMarketStructure.latestMarketStructure != MS_NONE){
         fiboCircleHandle();
      }
   }
   
   
   
   

}

#endif