#ifndef PLOTFIBOONCHART_MQH
#define PLOTFIBOONCHART_MQH

#include "Fibonacci.mqh";

class PlotFiboOnChart{

private:
   Fibonacci* fibonacci;

public:

   PlotFiboOnChart(){
   }
   
   void init(Fibonacci *fibonacciInstance){
      fibonacci = fibonacciInstance;
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
         
   void update(){
      
   }      
         
   
}

#endif
