#ifndef LINEDRAWING_MQH
#define LINEDRAWING_MQH

class LineDrawing{

public:
   double buffer[];
   
   LineDrawing(){
      ArrayInitialize(buffer, EMPTY_VALUE);
   }
   
   void DrawStraightLine(int startIndex, int endIndex, double startValue, const datetime &time[]){
      for (int i = startIndex; i <= endIndex; i++) {
      // Check for a gap in dates
         buffer[i] = startValue; // Set the line value
      }
      buffer[endIndex] = EMPTY_VALUE;
   }
   


}

#endif