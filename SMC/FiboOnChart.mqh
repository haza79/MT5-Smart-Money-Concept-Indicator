#ifndef FIBOONCHART_MQH
#define FIBOONCHART_MQH

#include "BarData.mqh";
#include "MacdMarketStructure.mqh";
#include "FiboCircle.mqh";


class FiboOnChart{

private:
   BarData* barData;
   MacdMarketStructureClass* macdMarketStructure;
   int index;

public:

   void init(BarData* barDataInstance, MacdMarketStructureClass* macdMarketStructureInstance){
      // init function
      barData = barDataInstance;
      macdMarketStructure = macdMarketStructureInstance;
   }
   
   void update(int Iindex){
      index = Iindex;
      
      if (index >= barData.RatesTotal() - 1) {
        return;
      }
   }

}

#endif