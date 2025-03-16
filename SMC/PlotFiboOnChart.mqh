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
   
   bool extendsFiboRay,isInitFibo,extendsFiboRetraceRay,isInitFiboRetrace;
   
   void fiboCirclePlotHandle(){
      
   }

public:

   PlotFiboOnChart(){
      extendsFiboRay = false;
      extendsFiboRetraceRay = false;
      isInitFibo = false;
      isInitFiboRetrace = false;
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
         fibo_circle_bottom_4236_ray,
         
         fibo_retrace_500_ray,
         fibo_retrace_618_ray,
         fibo_retrace_786_ray,
         fibo_retrace_887_ray;
         
   void update(int Iindex, int totalBars){
   /*
      ArrayResize(fibo_circle_top_236_ray.lineDrawing.buffer, totalBars);
      ArrayResize(fibo_circle_bottom_236_ray.lineDrawing.buffer, totalBars);
      ArrayResize(fibo_circle_top_500_ray.lineDrawing.buffer, totalBars);
      ArrayResize(fibo_circle_bottom_500_ray.lineDrawing.buffer, totalBars);
      ArrayResize(fibo_circle_top_618_ray.lineDrawing.buffer, totalBars);
      ArrayResize(fibo_circle_bottom_618_ray.lineDrawing.buffer, totalBars);
      */
      
      ArrayResize(fibo_retrace_500_ray.lineDrawing.buffer, totalBars);
      ArrayResize(fibo_retrace_618_ray.lineDrawing.buffer, totalBars);
      ArrayResize(fibo_retrace_786_ray.lineDrawing.buffer, totalBars);
      ArrayResize(fibo_retrace_887_ray.lineDrawing.buffer, totalBars);
      
      /*
      fibo_circle_top_236_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      fibo_circle_bottom_236_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      fibo_circle_top_500_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      fibo_circle_bottom_500_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      fibo_circle_top_618_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      fibo_circle_bottom_618_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      */
      
      fibo_retrace_500_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      fibo_retrace_618_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      fibo_retrace_786_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      fibo_retrace_887_ray.lineDrawing.buffer[Iindex] = EMPTY_VALUE;
      
      index = Iindex;
      if (index >= totalBars - 1) {
        return;
      }
      
      
      /*
      if(fibonacci.isFiboCircleCalculated){
         extendsFiboRay = true;
      }else{
         extendsFiboRay = false;
         isInitFibo = false;
         fibo_circle_top_236_ray.deleteRay();
         fibo_circle_bottom_236_ray.deleteRay();
         fibo_circle_top_500_ray.deleteRay();
         fibo_circle_bottom_500_ray.deleteRay();
         fibo_circle_top_618_ray.deleteRay();
         fibo_circle_bottom_618_ray.deleteRay();
      }
      
      if(fibonacci.isFiboRetraceCalculated){
         extendsFiboRetraceRay = true;
      }else{
         extendsFiboRetraceRay = false;
         isInitFiboRetrace = false;
         fibo_retrace_500_ray.deleteRay();
         fibo_retrace_618_ray.deleteRay();
         fibo_retrace_786_ray.deleteRay();
         fibo_retrace_887_ray.deleteRay();
      }
      
      if(extendsFiboRay){
         if(!isInitFibo){
            isInitFibo = true;
            int startIndex = -1;
            switch(fibonacci.trend){
               case TREND_BULLISH:
                  startIndex = fibonacci.fiboCircle.swingLowIndex;
                  break;
               case TREND_BEARISH:
                  startIndex = fibonacci.fiboCircle.swingHighIndex;
                  break;
            }
            
            if(startIndex == -1){
               return;
            }
            
            fibo_circle_top_236_ray.drawRay(startIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_236,true));
            fibo_circle_bottom_236_ray.drawRay(startIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_236,false));
            fibo_circle_top_500_ray.drawRay(startIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_500,true));
            fibo_circle_bottom_500_ray.drawRay(startIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_500,false));
            fibo_circle_top_618_ray.drawRay(startIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_618,true));
            fibo_circle_bottom_618_ray.drawRay(startIndex,index,fibonacci.fiboCircle.getFiboLevel(Fibo_618,false));
            
         }
         //Print("fibo extends:",barData.GetTime(index));
         fibo_circle_top_236_ray.extendeRay(index);
         fibo_circle_bottom_236_ray.extendeRay(index);
         fibo_circle_top_500_ray.extendeRay(index);
         fibo_circle_bottom_500_ray.extendeRay(index);
         fibo_circle_top_618_ray.extendeRay(index);
         fibo_circle_bottom_618_ray.extendeRay(index);
      }
      */
      
      if(extendsFiboRetraceRay){
         if(!isInitFiboRetrace){
            isInitFiboRetrace = true;
            int startIndex = -1;
            switch(fibonacci.trend){
               case TREND_BULLISH:
                  startIndex = fibonacci.fiboRetrace.swingLowIndex;
                  break;
               case TREND_BEARISH:
                  startIndex = fibonacci.fiboRetrace.swingHighIndex;
                  break;
            }
            
            if(startIndex == -1){
               return;
            }
            
            fibo_retrace_500_ray.drawRay(startIndex,index,fibonacci.fiboRetrace.getFiboLevel(Fibo_500));
            fibo_retrace_618_ray.drawRay(startIndex,index,fibonacci.fiboRetrace.getFiboLevel(Fibo_618));
            fibo_retrace_786_ray.drawRay(startIndex,index,fibonacci.fiboRetrace.getFiboLevel(Fibo_786));
            fibo_retrace_887_ray.drawRay(startIndex,index,fibonacci.fiboRetrace.getFiboLevel(Fibo_887));
            
         }
         
         fibo_retrace_500_ray.extendeRay(index);
         fibo_retrace_618_ray.extendeRay(index);
         fibo_retrace_786_ray.extendeRay(index);
         fibo_retrace_887_ray.extendeRay(index);
         
         
         
      }
      
   }   
   
   
         
   
}

#endif
