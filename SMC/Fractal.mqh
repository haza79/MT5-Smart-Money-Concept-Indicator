#ifndef FRACTALCLASS_MQH
#define FRACTALCLASS_MQH

class FractalClass
{
public:
    // Enum for fractal type, scoped within the class
    enum FractalType
    {
        HIGH, // For checking Fractal Highs
        LOW   // For checking Fractal Lows
    };

    // Method to check if a specific index is a fractal high or low
    bool CheckFractalAtIndex(const double &high[], const double &low[], int index, FractalType type)
    {
        // Ensure the index is valid
        if (index > 0 && index < ArraySize(high) - 1)
        {
            switch(type)
            {
                case HIGH:
                    // Check for a fractal high
                    if (high[index] > high[index - 1] && high[index] > high[index + 1])
                    {
                        return true;
                    }
                    break;

                case LOW:
                    // Check for a fractal low
                    if (low[index] < low[index - 1] && low[index] < low[index + 1])
                    {
                        return true;
                    }
                    break;

                default:
                    Print("Unknown fractal type.");
                    break;
            }
        }
        else
        {
            Print("Index ", index, " is out of bounds for fractal checking.");
        }

        return false;
    }
};

#endif