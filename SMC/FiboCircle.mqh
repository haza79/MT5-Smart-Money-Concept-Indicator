#ifndef FIBOCIRCLE_MQH
#define FIBOCIRCLE_MQH

#include "Enums.mqh";

class FiboCircle{

private:
   const double fiboCircleRatios[] = {0.236,0.382,0.5,0.618,0.786,0.887,1.13,1.272,1.618,2.618,4.236};
   double center,radius;
   

public:
   
   void init(double swingHigh, double swingLow){
      center = (swingHigh+swingLow)/2;
      radius = (swingHigh-swingLow)/2;
   }
   
   double calculateFibo(double fiboRatio,FiboTopOrBottom fiboTopOrBottom){
      double fiboLevelCalc = radius * fiboRatio;
      if(fiboTopOrBottom == FIBO_TOP){
         return center + fiboLevelCalc;
      }else if(fiboTopOrBottom == FIBO_BOTTOM){
         return center - fiboLevelCalc;
      }
      
      return -1;
   }


}

#endif