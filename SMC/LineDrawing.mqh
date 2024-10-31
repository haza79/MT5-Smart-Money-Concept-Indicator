#ifndef LINEDRAWING_MQH
#define LINEDRAWING_MQH

class LineDrawing{

public:
   double buffer[];
   
   LineDrawing(){
      ArrayInitialize(buffer, EMPTY_VALUE);
   }
   
   void DrawStraightLine(int startIndex, int endIndex, double startValue){
      for(int i = startIndex; i <= endIndex; i++){
         buffer[i] = startValue;
      }
   }

}

#endif