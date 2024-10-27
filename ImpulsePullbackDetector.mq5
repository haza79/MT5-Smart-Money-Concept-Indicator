#include "InsideBarClass.mq5";
#include "Fractal.mq5";

class ImpulsePullbackDetectorClass
{
private:
   InsideBarClass* insideBarClass;
   FractalClass fractal;
   
   enum Trend {NONE,BULLISH,BEARISH};
   Trend trend;
   bool isInsideBar;
   int swingHighIndex,swingLowIndex;
   int motherBarIndex;
   double swingHighPrice,swingLowPrice;

public:

   double highZigZagBuffer[],lowZigZagBuffer[];
   double swingHighBuffer[],swingLowBuffer[];
   double highFractalBuffer[],lowFractalBuffer[];
   
   int prevSwingHighIndex,prevSwingLowIndex,latestSwingHighIndex,latestSwingLowIndex;
   
   ImpulsePullbackDetectorClass() : insideBarClass(NULL){}

   void Init(InsideBarClass* insideBarInstance){
      insideBarClass = insideBarInstance;
      trend          = NONE;
      isInsideBar    = false;
      swingHighIndex = -1;
      swingLowIndex  = -1;
      swingHighPrice = -1;
      swingLowPrice  = -1;
      
      ArrayInitialize(highZigZagBuffer, EMPTY_VALUE);
      ArrayInitialize(lowZigZagBuffer, EMPTY_VALUE);
   }
   
   void Calculate(int i,const int rates_total, const double &high[], const double &low[]){
      
      ArrayResize(highZigZagBuffer, rates_total);
      ArrayResize(lowZigZagBuffer, rates_total);
      ArrayResize(swingHighBuffer, rates_total);
      ArrayResize(swingLowBuffer, rates_total);
      ArrayResize(highFractalBuffer, rates_total);
      ArrayResize(lowFractalBuffer, rates_total);
      
      if(i <= 1){
         return;
      }
      
      double currHigh   = high[i];
      double currLow    = low[i];
      int prevIndex  = i-1;
      double prevHigh   = high[i-1];
      double prevLow    = low[i-1];
      
      if(trend == NONE){
         if(currHigh > prevHigh && currLow >= prevLow){
            trend = BULLISH;
            return;
         }
         
         if(currLow < prevLow && currHigh <= prevHigh){
            trend = BEARISH;
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
         case BULLISH:
            if(currHigh > prevHigh && currLow >= prevLow){
               // impulse
               isInsideBar=false;
               break;
            }
            
            if(currHigh <= prevHigh && currLow < prevLow){
               //pullback
               trend = BEARISH;
               swingHighIndex = prevIndex;
               swingHighPrice = prevHigh;
               isInsideBar = false;
               
               AddHighZigZag();
               AddSwingHighPoint();
               
               if (fractal.CheckFractalAtIndex(high, low, swingHighIndex, fractal.FractalType::HIGH) && swingHighIndex < ArraySize(highFractalBuffer)) {
                    highFractalBuffer[swingHighIndex] = swingHighPrice;
               }
               
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
               
               if (fractal.CheckFractalAtIndex(high, low, swingHighIndex, fractal.FractalType::HIGH) && swingHighIndex < ArraySize(highFractalBuffer)) {
                    highFractalBuffer[swingHighIndex] = swingHighPrice;
               }
               
               if (fractal.CheckFractalAtIndex(high, low, swingLowIndex, fractal.FractalType::LOW) && swingLowIndex < ArraySize(lowFractalBuffer)) {
                    lowFractalBuffer[swingLowIndex] = swingLowPrice;
               }
               
               break;
            }
            
            break;
         case BEARISH:
            if(currLow < prevLow && currHigh <= prevHigh){
               //impulse
               isInsideBar = false;
               break;
            }
            
            if(currHigh > prevHigh && currLow >= prevLow){
               //pullback
               trend = BULLISH;
               swingLowIndex = prevIndex;
               swingLowPrice = prevLow;
               isInsideBar = false;
               
               AddLowZigZag();
               AddSwingLowPoint();
               
               if (fractal.CheckFractalAtIndex(high, low, swingLowIndex, fractal.FractalType::LOW) && swingLowIndex < ArraySize(lowFractalBuffer)) {
                    lowFractalBuffer[swingLowIndex] = swingLowPrice;
               }
               
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
               
               if (fractal.CheckFractalAtIndex(high, low, swingHighIndex, fractal.FractalType::HIGH) && swingHighIndex < ArraySize(highFractalBuffer)) {
                    highFractalBuffer[swingHighIndex] = swingHighPrice;
               }
               
               if (fractal.CheckFractalAtIndex(high, low, swingLowIndex, fractal.FractalType::LOW) && swingLowIndex < ArraySize(lowFractalBuffer)) {
                    lowFractalBuffer[swingLowIndex] = swingLowPrice;
               }
               
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
      latestSwingHighIndex = swingHighIndex;
      
   }
   
   void AddSwingLowPoint(){
      swingLowBuffer[swingLowIndex] = swingLowPrice;
      
      prevSwingLowIndex    = latestSwingLowIndex;
      latestSwingLowIndex  = swingLowIndex;
   }
};   