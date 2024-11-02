#ifndef CANDLE_MQH
#define CANDLE_MQH

struct Candle {
    double open;
    double high;
    double low;
    double close;

    Candle(double o, double h, double l, double c)
        : open(o), high(h), low(l), close(c) {}
};

#endif