#ifndef PLOTFIBOONCHART_MQH
#define PLOTFIBOONCHART_MQH

#include "Fibonacci.mqh";
#include "BarData.mqh";
#include "HorizontalRay.mqh";

class PlotFiboOnChart{

private:
   int index;
   Fibonacci* fibonacci;
   BarData* barData;
   
   bool extendsFiboRay,isInitFibo;
   
   void fiboCirclePlotHandle(){
      
   }

public:

   PlotFiboOnChart(){
      extendsFiboRay = false;
      isInitFibo = false;
   }
   
   void init(Fibonacci *fibonacciInstance, BarData *barDataInstance){
      fibonacci = fibonacciInstance;
      barData = barDataInstance;
   }
   
   HorizontalRay fibo_circle_top_236_ray,
         fibo_circle_top_382_ray,
         fibo_circle_top_500_ray,
         fibo_circle_top_618_ray,
         fibo_circle_top_786_ray,
         fibo_circle_top_887_ray,
         fibo_circle_top_1130_ray,
         fibo_circle_top_1272_ray,
         fibo_circle_top_1618_ray,
         fibo_circle_top_2618_ray,
         fibo_circle_top_4236_ray,
         
         fibo_circle_bottom_236_ray,
         fibo_circle_bottom_382_ray,
         fibo_circle_bottom_500_ray,
         fibo_circle_bottom_618_ray,
         fibo_circle_bottom_786_ray,
         fibo_circle_bottom_887_ray,
         fibo_circle_bottom_1130_ray,
         fibo_circle_bottom_1272_ray,
         fibo_circle_bottom_1618_ray,
         fibo_circle_bottom_2618_ray,
         fibo_circle_bottom_4236_ray;
         
   void update(int Iindex, int totalBars){
      ArrayResize(fibo_circle_top_236_ray.lineDrawing.buffer, totalBars);
      ArrayResize(fibo_circle_bottom_236_ray.lineDrawing.buffer, totalBars);
      
      index = Iindex;
      if (index >= totalBars - 1) {
        return;
      }
      
      fibo_circle_top_236_ray.lineDrawing.buffer[index] = EMPTY_VALUE;
      fibo_circle_bottom_236_ray.lineDrawing.buffer[index] = EMPTY_VALUE;
      
      if(fibonacci.isFiboCircleCalculated){
         extendsFiboRay = true;
      }else{
         extendsFiboRay = false;
         isInitFibo = false;
         fibo_circle_top_236_ray.deleteRay();
         fibo_circle_bottom_236_ray.deleteRay();
      }
      
      if(extendsFiboRay){
         if(!isInitFibo){
            isInitFibo = true;
            Print("init fibo");
            Print("fibo 236 top:",fibonacci.fiboCircle.getFiboLevel(Fibo_236,true));
            Print("fibo 236 bottom:",fibonacci.fiboCircle.getFiboLevel(Fibo_236,false));
            Print("high:",fibonacci.fiboCircle.swingHighIndex,":",barData.GetTime(fibonacci.fiboCircle.swingHighIndex));
            Print("low :",fibonacci.fiboCircle.swingLowIndex,":",barData.GetTime(fibonacci.fiboCircle.swingLowIndex));
            Print("trend:",fibonacci.trend);
            switch(fibonacci.trend){
               case TREND_BULLISH:
                  fibo_circle_top_236_ray.drawRay(fibonacci.fiboCircle.swingLowIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_236,true));
                  fibo_circle_bottom_236_ray.drawRay(fibonacci.fiboCircle.swingLowIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_236,false));
                  break;
               case TREND_BEARISH:
                  fibo_circle_top_236_ray.drawRay(fibonacci.fiboCircle.swingHighIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_236,true));
                  fibo_circle_bottom_236_ray.drawRay(fibonacci.fiboCircle.swingHighIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_236,false));
                  break;
            }
            
         }
         Print("fibo extends:",barData.GetTime(index));
         fibo_circle_top_236_ray.extendeRay(index);
         fibo_circle_bottom_236_ray.extendeRay(index);
      }
   }   
         
   
}

#endif
