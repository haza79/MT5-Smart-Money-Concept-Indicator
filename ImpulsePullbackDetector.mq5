class ImpulsePullbackDetector {
private:
    int motherBarIndexHandleForSwing;
    string marketPhase;
    
    // Buffers for swings and fractals
    double swingHighBuffer[];
    double swingLowBuffer[];
    double ZigZagBuffer1[];
    double ZigZagBuffer2[];
    double FractalUpBuffer[];
    double FractalDownBuffer[];

    int lastSwingHighIndex, lastSwingLowIndex;
    int prevSwingHighIndex, prevSwingLowIndex;
    int lastHighFractalIndex, lastLowFractalIndex;
    int prevHighFractalIndex, prevLowFractalIndex;

public:
    void InitBuffers(int rates_total) {
        ArrayResize(swingHighBuffer, rates_total);
        ArrayResize(swingLowBuffer, rates_total);
        ArrayResize(ZigZagBuffer1, rates_total);
        ArrayResize(ZigZagBuffer2, rates_total);
        ArrayResize(FractalUpBuffer, rates_total);
        ArrayResize(FractalDownBuffer, rates_total);

        ArrayInitialize(swingHighBuffer, EMPTY_VALUE);
        ArrayInitialize(swingLowBuffer, EMPTY_VALUE);
        ArrayInitialize(ZigZagBuffer1, EMPTY_VALUE);
        ArrayInitialize(ZigZagBuffer2, EMPTY_VALUE);
        ArrayInitialize(FractalUpBuffer, EMPTY_VALUE);
        ArrayInitialize(FractalDownBuffer, EMPTY_VALUE);
        
        marketPhase = NULL;
        motherBarIndexHandleForSwing = -1;
    }

    void DetectImpulsePullback(int i, const double &high[], const double &low[], int rates_total) {
        int prevCandle = (motherBarCandleHandle[i - 1] == 1) ? motherBarIndexHandleForSwing : i - 1;

        if (insideBarCandleHandle[i] == 1) return; // Skip inside bar

        if (marketPhase == NULL) {
            DetermineInitialMarketPhase(i, high, low, prevCandle);
        } else if (marketPhase == "BULLISH IMPULSE") {
            DetectBullishImpulse(i, high, low, prevCandle, rates_total);
        } else if (marketPhase == "BEARISH IMPULSE") {
            DetectBearishImpulse(i, high, low, prevCandle, rates_total);
        }
    }

private:
    void DetermineInitialMarketPhase(int i, const double &high[], const double &low[], int prevCandle) {
        if (high[i] > high[prevCandle]) {
            marketPhase = "BULLISH IMPULSE";
        } else if (low[i] < low[prevCandle]) {
            marketPhase = "BEARISH IMPULSE";
        }
    }

    void DetectBullishImpulse(int i, const double &high[], const double &low[], int prevCandle, int rates_total) {
        if (low[i] < low[prevCandle] && high[i] > high[prevCandle]) {
            MarkSwingHigh(prevCandle, high, i, low, rates_total);
        } else if (low[i] < low[prevCandle]) {
            MarkSwingHigh(prevCandle, high, i, low, rates_total);
            marketPhase = "BEARISH IMPULSE";
        }
    }

    void DetectBearishImpulse(int i, const double &high[], const double &low[], int prevCandle, int rates_total) {
        if (high[i] > high[prevCandle] && low[i] < low[prevCandle]) {
            MarkSwingLow(prevCandle, low, i, high, rates_total);
        } else if (high[i] > high[prevCandle]) {
            MarkSwingLow(prevCandle, low, i, high, rates_total);
            marketPhase = "BULLISH IMPULSE";
        }
    }

    void MarkSwingHigh(int prevCandle, const double &high[], int i, const double &low[], int rates_total) {
        swingHighBuffer[prevCandle] = high[prevCandle];
        ZigZagBuffer1[prevCandle] = high[prevCandle];

        if (IsFractalUp(prevCandle, high)) {
            FractalUpBuffer[prevCandle] = high[prevCandle];
            UpdateFractalIndices(prevCandle, true);
        }

        UpdateSwingIndices(prevCandle, true);
        MarkSwingLow(i, low, i, high, rates_total);
    }

    void MarkSwingLow(int prevCandle, const double &low[], int i, const double &high[], int rates_total) {
        swingLowBuffer[prevCandle] = low[prevCandle];
        ZigZagBuffer2[prevCandle] = low[prevCandle];

        if (IsFractalDown(prevCandle, low)) {
            FractalDownBuffer[prevCandle] = low[prevCandle];
            UpdateFractalIndices(prevCandle, false);
        }

        UpdateSwingIndices(prevCandle, false);
    }

    bool IsFractalUp(int index, const double &high[]) {
        return index - 1 >= 0 && high[index] >= high[index + 1] && high[index] >= high[index - 1];
    }

    bool IsFractalDown(int index, const double &low[]) {
        return index - 1 >= 0 && low[index] <= low[index + 1] && low[index] <= low[index - 1];
    }

    void UpdateFractalIndices(int index, bool isHigh) {
        if (isHigh) {
            prevHighFractalIndex = lastHighFractalIndex;
            lastHighFractalIndex = index;
        } else {
            prevLowFractalIndex = lastLowFractalIndex;
            lastLowFractalIndex = index;
        }
    }

    void UpdateSwingIndices(int index, bool isHigh) {
        if (isHigh) {
            prevSwingHighIndex = lastSwingHighIndex;
            lastSwingHighIndex = index;
        } else {
            prevSwingLowIndex = lastSwingLowIndex;
            lastSwingLowIndex = index;
        }
    }
};
