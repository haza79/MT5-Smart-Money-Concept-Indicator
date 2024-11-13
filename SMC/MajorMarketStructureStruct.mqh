#ifndef MARKETSTRUCTURE_MQH
#define MARKETSTRUCTURE_MQH

#include "Enums.mqh";

struct MarketStructure {
   
   // Nested SwingPoint struct
   struct SwingPoint {
      int index;
      double value;
      
      // Constructor for SwingPoint
      SwingPoint(int _index = -1, double _value = 0.0) {
         index = _index;
         value = _value;
      }
   };

   // Member variables
   Trend trend;
   Trend biasTrend;
   SwingPoint swingHigh;
   SwingPoint swingLow;
   SwingPoint biasSwingHigh;
   SwingPoint biasSwingLow;
   SwingPoint wickSwingHigh;
   SwingPoint wickSwingLow;
   SwingPoint inducement;
   bool isSwingHighWickBreak;
   bool isSwingLowWickBreak;
   MarketStructureType marketPhase;

   // Constructor for MarketStructure
   MarketStructure()
     : trend(TREND_NONE),
       biasTrend(TREND_NONE),
       swingHigh(),  // Initializes with SwingPoint(-1, 0.0) by default
       swingLow(),
       biasSwingHigh(),
       biasSwingLow(),
       wickSwingHigh(),
       wickSwingLow(),
       inducement(),
       isSwingHighWickBreak(false),
       isSwingLowWickBreak(false),
       marketPhase(MS_NONE)
   {}
};

#endif
