#ifndef FIBONACCI_MQH
#define FIBONACCI_MQH

#include "BarData.mqh";
#include "MacdMarketStructure.mqh";
#include "FiboCircle.mqh";

class Fibonacci {
private:
    BarData* barData;
    MacdMarketStructureClass* macdMarketStructure;
    
    int index;
    int macdSwingHigh, macdSwingLow;
    double macdSwingHighPrice, macdSwingLowPrice;
    int getMarketBreakAtIndex;
    

    void fiboCircleHandle() {
         if(macdMarketStructure.getLatestMajorHighIndex() != -1 &&
            macdMarketStructure.getLatestMajorLowIndex() != -1){
            
            fiboCircle.swingHighIndex = macdMarketStructure.getLatestMajorHighIndex();
            fiboCircle.swingLowIndex = macdMarketStructure.getLatestMajorLowIndex();
            fiboCircle.calculateFibo(macdMarketStructure.getLatestmajorHighPrice(), macdMarketStructure.getLatestMajorLowPrice());
            //fiboCircle.printFiboLevels();
            isFiboCircleCalculated = true;
         }
        
    }

public:
   
   bool isMarketChange,isFiboCircleCalculated;
   FiboCircle fiboCircle;
   Trend trend;
   
   Fibonacci(){
      getMarketBreakAtIndex = -1;
      isMarketChange = false;
      isFiboCircleCalculated = false;
   }
   
    void init(BarData* barDataInstance, MacdMarketStructureClass* macdMarketStructureInstance) {
        barData = barDataInstance;
        macdMarketStructure = macdMarketStructureInstance;
        macdSwingHigh = -1;
        macdSwingLow = -1;
        macdSwingHighPrice = 0;
        macdSwingLowPrice = 0;
    }

    void update(int iIndex, int rates_total) {
        if (iIndex >= rates_total - 1) return;
        index = iIndex;
        trend = macdMarketStructure.getLatestTrend();

        if (macdMarketStructure.latestMarketStructure == MS_NONE) {
            return;
        }
        
        
        
       
         if(!isFiboCircleCalculated){
            fiboCircleHandle();
         }

        
        
        if(getMarketBreakAtIndex != macdMarketStructure.marketBreakAtIndex){
            //
            getMarketBreakAtIndex = macdMarketStructure.marketBreakAtIndex;
            //Print("market break:",barData.GetTime(index));
            isFiboCircleCalculated = false;
            
        }
        
        
        
        
    }
};

#endif
