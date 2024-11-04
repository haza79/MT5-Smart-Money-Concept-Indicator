#ifndef LINEDRAWING_MQH
#define LINEDRAWING_MQH

class LineDrawing{

public:
   double buffer[];
   
   LineDrawing(){
      ArrayInitialize(buffer, EMPTY_VALUE);
   }
   
   void DrawStraightLine(int startIndex, int endIndex, double startValue, const datetime &time[]){
      for (int i = startIndex; i < endIndex; i++) {
      // Check for a gap in dates
      if (i > startIndex && time[i] - time[i - 1] > 86400) { // 86400 seconds = 1 day
         buffer[i - 1] = EMPTY_VALUE; // Insert EMPTY_VALUE to break the line before the gap
      }
      buffer[i] = startValue; // Set the line value
   }
   }
   


}

#endif