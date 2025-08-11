#ifndef HARMONIC_MQH
#define HARMONIC_MQH

#include "Enums.mqh";
#include "BarData.mqh";
#include "Fractal.mqh";
#include "Fibonacci.mqh";
#include "MACDFractal.mqh";


class Harmonic{

   BarData* barData;
   FractalClass* fractal;
   Fibonacci *fibonacci;
   MACDFractalClass *macdFractal;

public:

   Harmonic(){
   
      double fiboRetraceLevel[] = {
      0,
      0.382,
      0.5,
      0.618,
      0.786,
      0.886,
      1.13,
      1.27,
      1.414,
      1.618,
      2,
      2.236,
      2.618,
      3.618};
      
      fiboRetrace.setLevels(fiboRetraceLevel);
   }
   
   void Init(BarData* barDataInstance,FractalClass* fractalInstance,Fibonacci *fibonacciInstance,MACDFractalClass *macdFractalInstance){
      barData = barDataInstance;
      fractal = fractalInstance;
      fibonacci = fibonacciInstance;
      macdFractal = macdFractalInstance;
      
   }
   
   void update(int index, int totalBars){
   
      if (index >= totalBars - 1) {
        return;  // Exit if it's the last (incomplete) candle
      }
    
    
   }

}

#endif
