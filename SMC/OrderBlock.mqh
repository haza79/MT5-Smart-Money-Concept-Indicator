#ifndef ORDERBLOCK_MQH
#define ORDERBLOCK_MQH

#include "BarData.mqh";
#include "Fractal.mqh";

class OrderBlock{

private:
   
   BarData* barData;
   FractalClass* fractal;

public:

   void Init(BarData* barDataInstance,FractalClass* fractalInstance){
      barData = barDataInstance;
      fractal = fractalInstance;
   }

}

#endif
