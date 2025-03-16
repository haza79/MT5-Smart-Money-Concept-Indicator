#ifndef FIBONACCI_MQH
#define FIBONACCI_MQH

#include "BarData.mqh";
#include "MacdMarketStructure.mqh";
#include "FiboCircle.mqh";
#include "FiboTimeZone.mqh";
#include "FiboRetrace.mqh";

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
    
    void fiboRetraceHandle() {
         if(macdMarketStructure.getLatestMajorHighIndex() != -1 &&
            macdMarketStructure.getLatestMajorLowIndex() != -1){
            
            fiboRetrace.swingHighIndex = macdMarketStructure.getLatestMajorHighIndex();
            fiboRetrace.swingLowIndex = macdMarketStructure.getLatestMajorLowIndex();
            fiboRetrace.calculateFibo(macdMarketStructure.getLatestmajorHighPrice(), macdMarketStructure.getLatestMajorLowPrice(),macdMarketStructure.getLatestTrend());
            isFiboRetraceCalculated = true;
         }
        
    }
    
    void fiboTimeZoneHandle(){
      if(macdMarketStructure.getLatestMajorHighIndex() == -1 && macdMarketStructure.getLatestMajorLowIndex() == -1){
         return;
      }
      
      if(macdMarketStructure.getLatestTrend() == TREND_BULLISH){
      
         if(macdMarketStructure.getLatestMajorHighIndex() != -1 && macdMarketStructure.macdFractal.latestMacdLowFractalIndex > macdMarketStructure.getLatestMajorLowIndex()){
            //Print("Calc fibo time zone:BULLISH");
            isFiboTimeZoneCalculated = true;
         }
      
      }else if(macdMarketStructure.getLatestTrend() == TREND_BEARISH){
         
         if(macdMarketStructure.getLatestMajorLowIndex() != -1 && macdMarketStructure.macdFractal.latestMacdHighFractalIndex > macdMarketStructure.getLatestMajorHighIndex()){
            //Print("Calc fibo time zone:BEARISH");
            isFiboTimeZoneCalculated = true;
         }
         
      }
      
    }

public:
   
   bool isMarketChange,isFiboCircleCalculated,isFiboTimeZoneCalculated,isFiboRetraceCalculated;
   FiboCircle fiboCircle;
   FiboTimeZone fiboTimeZone;
   FiboRetrace fiboRetrace;
   Trend trend;
   
   Fibonacci(){
      getMarketBreakAtIndex = -1;
      isMarketChange = false;
      isFiboCircleCalculated = false;
      isFiboTimeZoneCalculated = false;
      isFiboRetraceCalculated = false;
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
        
        
        
       /*
         if(!isFiboCircleCalculated){
            fiboCircleHandle();
         }
         */
         
         if(!isFiboTimeZoneCalculated){
            fiboTimeZoneHandle();
         }
         
         if(!isFiboRetraceCalculated){
            fiboRetraceHandle();
         }

        
        
        if(getMarketBreakAtIndex != macdMarketStructure.marketBreakAtIndex){
            //
            getMarketBreakAtIndex = macdMarketStructure.marketBreakAtIndex;
            //Print("market break:",barData.GetTime(index));
            isFiboCircleCalculated = false;
            isFiboTimeZoneCalculated = false;
            isFiboRetraceCalculated = false;
            
        }
        
        
        
        
    }
};

#endif
