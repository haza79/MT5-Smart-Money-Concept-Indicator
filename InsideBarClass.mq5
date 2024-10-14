class InsideBarClass
{
private:
    double motherBarTopBuffer[];
    double motherBarBottomBuffer[];
    double motherBarBuffer[];
    double insideBarBuffer[];

    int motherBarIndex;
    double motherBarHigh, motherBarLow;

public:

    void Init()
    {
        motherBarIndex = -1;
        motherBarHigh = 0;
        motherBarLow = 0;

        ArrayInitialize(motherBarTopBuffer, EMPTY_VALUE);
        ArrayInitialize(motherBarBottomBuffer, EMPTY_VALUE);
        ArrayInitialize(motherBarBuffer, EMPTY_VALUE);
        ArrayInitialize(insideBarBuffer, EMPTY_VALUE);
    }

    void Calculate(const int rates_total, const int prev_calculated, const double &high[], const double &low[])
{
    // Ensure the buffers have the correct size
    ArrayResize(motherBarTopBuffer, rates_total);
    ArrayResize(motherBarBottomBuffer, rates_total);
    ArrayResize(motherBarBuffer, rates_total);
    ArrayResize(insideBarBuffer, rates_total);
    
    int start = prev_calculated > 0 ? prev_calculated - 1 : 1;  // Ensure that 'start' is always at least 1

    for (int i = start; i < rates_total; i++)
    {
        // Ensure we don't access i-1 if i == 0
        if (i < 1) continue;

        // Detect mother bar
        if (motherBarIndex == -1)
        {
            // A bar becomes a mother bar if it is followed by an inside bar
            if (IsInsideBar(i, high, low))
            {
                motherBarIndex = i - 1;  // Mark the mother bar's index
                motherBarHigh = high[i - 1];
                motherBarLow = low[i - 1];

                // Safeguard to avoid array out of range
                if (i > 0)
                {
                    // Set the mother bar values for the previous and current bar
                    motherBarTopBuffer[i - 1] = motherBarHigh;
                    motherBarBottomBuffer[i - 1] = motherBarLow;
                    motherBarTopBuffer[i] = motherBarHigh;
                motherBarBottomBuffer[i] = motherBarLow;

                    // Set the current bar as an inside bar
                    motherBarBuffer[i - 1] = 1;
                    insideBarBuffer[i] = 1;
                }
            }
        }
        else
        {
            // Detect inside bars within the mother bar's range
            if (IsInsideMotherBar(i, high, low))
            {
                // Continue marking the current bar as an inside bar
                motherBarTopBuffer[i] = motherBarHigh;
                motherBarBottomBuffer[i] = motherBarLow;

                insideBarBuffer[i] = 1;
            }
            else
            {
                // Reset the mother bar if an inside bar is no longer detected
                motherBarIndex = -1;
            }
        }
    }
}


    // Accessors for the buffers
    double GetMotherBarTop(int index) { return motherBarTopBuffer[index]; }
    double GetMotherBarBottom(int index) { return motherBarBottomBuffer[index]; }
    double GetMotherBar(int index) { return motherBarBuffer[index]; }
    double GetInsideBar(int index) { return insideBarBuffer[index]; }

private:
    // Helper function to detect if the current bar is an inside bar
    bool IsInsideBar(int index, const double &high[], const double &low[])
    {
        return (high[index] < high[index - 1] && low[index] > low[index - 1]);
    }

    // Helper function to detect if the current bar is still within the mother bar's range
    bool IsInsideMotherBar(int index, const double &high[], const double &low[])
    {
        return (high[index] < motherBarHigh && low[index] > motherBarLow);
    }
};
