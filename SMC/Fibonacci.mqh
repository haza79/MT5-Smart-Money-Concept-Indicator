#ifndef FIBONACCI_MQH
#define FIBONACCI_MQH

#include "BarData.mqh";
#include "MacdMarketStructure.mqh";
#include "FiboCircle.mqh";


class Fibonacci{

private:
   BarData* barData;
   MacdMarketStructureClass* macdMarketStructure;
   FiboCircle fiboCircle;
   int index;
   int macdSwingHigh,macdSwingLow;
   double macdSwingHighPrice,macdSwingLowPrice;
   
   void fiboCircleHandle(){
      Print("high:",barData.GetTime(macdSwingHigh)," | low:",barData.GetTime(macdSwingLow));
      fiboCircle.calculateFibo(macdSwingHighPrice,macdSwingLowPrice);
   }
   

public:

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
      
      if(macdMarketStructure.getLatestMajorHighIndex() == -1 || macdMarketStructure.getLatestMajorLowIndex() == -1){
         return;
      }
      if(macdMarketStructure.getLatestMajorHighIndex() == macdSwingHigh && macdMarketStructure.getLatestMajorLowIndex() == macdSwingLow){
         return;
      }else{
         macdSwingHigh = macdMarketStructure.getLatestMajorHighIndex();
         macdSwingLow = macdMarketStructure.getLatestMajorLowIndex();
         
         macdSwingHighPrice = macdMarketStructure.getLatestmajorHighPrice();
         macdSwingLowPrice = macdMarketStructure.getLatestMajorLowPrice();
      }
      
      if(macdMarketStructure.latestMarketStructure != MS_NONE){
         fiboCircleHandle();
      }
   }
   
   
   
   

}

#endif