#ifndef IMPULSEPULLBACKDETECTORCLASS_MQH
#define IMPULSEPULLBACKDETECTORCLASS_MQH

#include "InsideBarClass.mqh";
#include "Enums.mqh"

class ImpulsePullbackDetectorClass
{
private:
   
   Trend trend;
   bool isInsideBar;
   int swingHighIndex,swingLowIndex;
   int motherBarIndex;
   double swingHighPrice,swingLowPrice;

public:

   InsideBarClass* insideBarClass;

   double highZigZagBuffer[],lowZigZagBuffer[];
   double swingHighBuffer[],swingLowBuffer[];
   
   int prevSwingHighIndex,prevSwingLowIndex,latestSwingHighIndex,latestSwingLowIndex;
   double prevSwingHighPrice,prevSwingLowPrice,latestSwingHighPrice,latestSwingLowPrice;
   
   ImpulsePullbackDetectorClass() : insideBarClass(NULL){}

   void Init(InsideBarClass* insideBarInstance){
      insideBarClass = insideBarInstance;
      trend          = TREND_NONE;
      isInsideBar    = false;
      swingHighIndex = -1;
      swingLowIndex  = -1;
      swingHighPrice = -1;
      swingLowPrice  = -1;
      
      prevSwingHighIndex   = -1;
      prevSwingLowIndex    = -1;
      latestSwingHighIndex = -1;
      latestSwingLowIndex  = -1;
      
      prevSwingHighPrice   = -1;
      prevSwingLowPrice    = -1;
      latestSwingHighPrice = -1;
      latestSwingLowPrice  = -1;
      
      ArrayInitialize(highZigZagBuffer, EMPTY_VALUE);
      ArrayInitialize(lowZigZagBuffer, EMPTY_VALUE);
      ArrayInitialize(swingHighBuffer, EMPTY_VALUE);
      ArrayInitialize(swingLowBuffer, EMPTY_VALUE);
   }
   
   void Calculate(int i,const int rates_total, const double &high[], const double &low[]){
      
      ArrayResize(highZigZagBuffer, rates_total);
      ArrayResize(lowZigZagBuffer, rates_total);
      ArrayResize(swingHighBuffer, rates_total);
      ArrayResize(swingLowBuffer, rates_total);
      
      highZigZagBuffer[i] = EMPTY_VALUE;
      lowZigZagBuffer[i] = EMPTY_VALUE;
      swingHighBuffer[i] = EMPTY_VALUE;
      swingLowBuffer[i] = EMPTY_VALUE;
      
      
      if(i <= 1){
         return;
      }
      
      double currHigh   = high[i];
      double currLow    = low[i];
      int prevIndex  = i-1;
      double prevHigh   = high[i-1];
      double prevLow    = low[i-1];
      
      if(trend == TREND_NONE){
         if(currHigh > prevHigh && currLow >= prevLow){
            trend = TREND_BULLISH;
            return;
         }
         
         if(currLow < prevLow && currHigh <= prevHigh){
            trend = TREND_BEARISH;
            return;
         }
      }
      
      if(isInsideBar){
         prevIndex = motherBarIndex;
      }else{
         if(insideBarClass.GetMotherBarIndex() != -1){
            isInsideBar = true;
            motherBarIndex = insideBarClass.GetMotherBarIndex();
            prevIndex = motherBarIndex;
         }
      }
      
      ImpulsePullbackChecker(i,prevIndex,high,low);
      
   }

private:
   void ImpulsePullbackChecker(int currIndex,
                              int prevIndex,
                              const double &high[],
                              const double &low[]){
      // start here
      double currHigh = high[currIndex];
      double currLow = low[currIndex];
      double prevHigh = high[prevIndex];
      double prevLow = low[prevIndex];
      
      
                                                                     
      switch(trend){
         case TREND_BULLISH:
            if(currHigh > prevHigh && currLow >= prevLow){
               // impulse
               isInsideBar=false;
               break;
            }
            
            if(currHigh <= prevHigh && currLow < prevLow){
               //pullback
               trend = TREND_BEARISH;
               swingHighIndex = prevIndex;
               swingHighPrice = prevHigh;
               isInsideBar = false;
               
               AddHighZigZag();
               AddSwingHighPoint();
               // 2024.8.30 20.45
               break;
            }
            
            if(currHigh > prevHigh && currLow < prevLow){
               //pullback and impulse
               swingHighIndex = prevIndex;
               swingHighPrice = prevHigh;
               swingLowIndex = currIndex;
               swingLowPrice = currLow;
               isInsideBar = false;
               
               AddHighZigZag();
               AddLowZigZag();
               
               AddSwingHighPoint();
               AddSwingLowPoint();
               
               break;
            }
            
            break;
         case TREND_BEARISH:
            if(currLow < prevLow && currHigh <= prevHigh){
               //impulse
               isInsideBar = false;
               break;
            }
            
            if(currHigh > prevHigh && currLow >= prevLow){
               //pullback
               trend = TREND_BULLISH;
               swingLowIndex = prevIndex;
               swingLowPrice = prevLow;
               isInsideBar = false;
               
               AddLowZigZag();
               AddSwingLowPoint();
               
               break;
            }
            
            if(currHigh > prevHigh && currLow < prevLow){
               //pullback and impulse
               swingHighIndex = currIndex;
               swingHighPrice = currHigh;
               swingLowIndex = prevIndex;
               swingLowPrice = prevLow;
               isInsideBar = false;
               
               AddHighZigZag();
               AddLowZigZag();
               
               AddSwingHighPoint();
               AddSwingLowPoint();
               
               break;
            }
            break;
      }
   }
   
   void AddHighZigZag(){
      highZigZagBuffer[swingHighIndex] = swingHighPrice;
   }
   
   void AddLowZigZag(){
      lowZigZagBuffer[swingLowIndex] = swingLowPrice;
   }
   
   void AddSwingHighPoint(){
      swingHighBuffer[swingHighIndex] = swingHighPrice;
                 
      prevSwingHighIndex   = latestSwingHighIndex;
      prevSwingHighPrice   = latestSwingHighPrice;
      
      latestSwingHighIndex = swingHighIndex;
      latestSwingHighPrice = swingHighPrice;
   }
   
   void AddSwingLowPoint(){
      swingLowBuffer[swingLowIndex] = swingLowPrice;
        
      prevSwingLowIndex    = latestSwingLowIndex;
      prevSwingLowPrice   = latestSwingLowPrice;
      
      latestSwingLowIndex  = swingLowIndex;
      latestSwingLowPrice  = swingLowPrice;
   }
   
   
};   

#endif