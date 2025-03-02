#ifndef PLOTFIBOONCHART_MQH
#define PLOTFIBOONCHART_MQH

#include "Fibonacci.mqh";
#include "BarData.mqh";

class PlotFiboOnChart{

private:
   int index;
   Fibonacci* fibonacci;
   BarData* barData;
   
   bool extendsFiboRay;
   
   void fiboCirclePlotHandle(){
      
   }

public:

   PlotFiboOnChart(){
      extendsFiboRay = false;
   }
   
   void init(Fibonacci *fibonacciInstance, BarData *barDataInstance){
      fibonacci = fibonacciInstance;
      barData = barDataInstance;
   }
   
   double fibo_circle_top_236_buffer[],
         fibo_circle_top_382_buffer[],
         fibo_circle_top_500_buffer[],
         fibo_circle_top_618_buffer[],
         fibo_circle_top_786_buffer[],
         fibo_circle_top_887_buffer[],
         fibo_circle_top_1130_buffer[],
         fibo_circle_top_1272_buffer[],
         fibo_circle_top_1618_buffer[],
         fibo_circle_top_2618_buffer[],
         fibo_circle_top_4236_buffer[],
         
         fibo_circle_bottom_236_buffer[],
         fibo_circle_bottom_382_buffer[],
         fibo_circle_bottom_500_buffer[],
         fibo_circle_bottom_618_buffer[],
         fibo_circle_bottom_786_buffer[],
         fibo_circle_bottom_887_buffer[],
         fibo_circle_bottom_1130_buffer[],
         fibo_circle_bottom_1272_buffer[],
         fibo_circle_bottom_1618_buffer[],
         fibo_circle_bottom_2618_buffer[],
         fibo_circle_bottom_4236_buffer[];
         
   void update(int Iindex, int totalBars){
      index = Iindex;
      if (index >= totalBars - 1) {
        return;
      }
      
      
      if(fibonacci.isFiboCircleCalculated){
         extendsFiboRay = true;
      }else{
         extendsFiboRay = false;
      }
      
      if(extendsFiboRay){
         Print("fibo extends:",barData.GetTime(index));
      }
   }   
         
   
}

#endif
