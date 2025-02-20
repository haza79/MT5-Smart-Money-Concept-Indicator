#ifndef FIBOCIRCLE_MQH
#define FIBOCIRCLE_MQH

#include "Enums.mqh";

class FiboCircle{

private:
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