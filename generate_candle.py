import matplotlib
matplotlib.use('TkAgg')  # Or 'Qt5Agg', 'Agg'
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from mplfinance.original_flavor import candlestick_ohlc

def generate_candlesticks_from_swings(swing_points, timeframe_minutes=15):
    """Generates candlestick data from provided swing points with interpolation."""
    if len(swing_points) < 2:
        raise ValueError("At least two swing points are required.")

    data = []
    for i in range(len(swing_points) - 1):
        start_datetime_str, start_price = swing_points[i]
        end_datetime_str, end_price = swing_points[i + 1]

        try:
            start_datetime = datetime.strptime(start_datetime_str, "%d/%m/%Y %H:%M:%S")
            end_datetime = datetime.strptime(end_datetime_str, "%d/%m/%Y %H:%M:%S")
        except ValueError:
            raise ValueError("Invalid date/time format. Use DD/MM/YYYY HH:MM:SS")

        if end_datetime < start_datetime:
            raise ValueError(f"End datetime of swing {i+1} must be after start datetime of swing {i}.")

        total_minutes = int((end_datetime - start_datetime).total_seconds() / 60)
        num_candles = max(1, int(total_minutes / timeframe_minutes)) #Ensure at least one candle

        prices = np.linspace(start_price, end_price, num_candles + 1)

        current_datetime = start_datetime
        for j in range(num_candles):
            open_price = prices[j]
            close_price = prices[j + 1]

            price_range = abs(close_price - open_price)
            high_wick = np.random.uniform(0, price_range * 0.5)
            low_wick = np.random.uniform(0, price_range * 0.3) if np.random.rand() < 0.5 else 0

            high_price = max(open_price, close_price) + high_wick
            low_price = min(open_price, close_price) - low_wick

            data.append({
                "DATE": current_datetime.strftime("%Y-%m-%d"),
                "TIME": current_datetime.strftime("%H:%M:%S"),
                "OPEN": open_price,
                "HIGH": high_price,
                "LOW": low_price,
                "CLOSE": close_price
            })
            current_datetime += timedelta(minutes=timeframe_minutes)

    return pd.DataFrame(data)

def plot_candlestick(df):
    """Plots candlestick chart."""
    try:
        if df.empty:
            print("DataFrame is empty. No plot to display.")
            return

        df['DateTime'] = pd.to_datetime(df['DATE'] + ' ' + df['TIME'])
        df = df.set_index('DateTime')

        df[['OPEN', 'HIGH', 'LOW', 'CLOSE']] = df[['OPEN', 'HIGH', 'LOW', 'CLOSE']].apply(pd.to_numeric)

        df['DateNum'] = mdates.date2num(df.index)

        fig, ax = plt.subplots(figsize=(12, 6))

        candlestick_ohlc(ax, df[['DateNum', 'OPEN', 'HIGH', 'LOW', 'CLOSE']].values, width=0.005, colorup='green', colordown='red')

        ax.xaxis.set_major_locator(mdates.AutoDateLocator())
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d %H:%M'))
        plt.xticks(rotation=45, ha='right')
        plt.xlabel('Date and Time')
        plt.ylabel('Price')
        plt.title('Candlestick Chart from Swing Points')
        plt.grid(True)
        plt.tight_layout()
        plt.show()

    except Exception as e:
        print(f"Plotting Error: {e}")
        plt.savefig("candlestick_chart.png")
        print("Chart saved to candlestick_chart.png")

# Example Usage
swing_points = [
    ("17/12/2024 10:45:00", 120417.55),
    ("18/12/2024 04:30:00", 116016.35),
    ("18/12/2024 14:15:00", 117281.69),
    ("18/12/2024 21:45:00", 114512.6),
    ("19/12/2024 22:15:00", 118323.3),
    ("20/12/2024 08:15:00", 115136.67),
    ("20/12/2024 20:45:00", 116092.66),
    ("21/12/2024 03:45:00", 112981),
    ("21/12/2024 14:45:00", 114086.95),
    ("22/12/2024 04:45:00", 110262.99),
    ("23/12/2024 01:15:00", 115380.35),
    ("23/12/2024 11:45:00", 113880.76),
    ("23/12/2024 22:45:00", 116148.89),
    ("24/12/2024 12:15:00", 112025.01),
    ("24/12/2024 22:45:00", 113393.39),
    ("25/12/2024 09:15:00", 111031.53),
    ("25/12/2024 22:15:00", 114161.93),
    ("26/12/2024 12:15:00", 108857.13),
    ("27/12/2024 01:45:00", 110075.54),
    ("27/12/2024 08:45:00", 107338.79),
    ("28/12/2024 02:15:00", 110637.89),
    ("28/12/2024 12:15:00", 106720.21),
    ("28/12/2024 23:15:00", 107957.37),
    ("29/12/2024 05:45:00", 105595.51),
    ("29/12/2024 16:15:00", 106420.29),
    ("29/12/2024 19:45:00", 104470.82),
    ("30/12/2024 06:15:00", 105501.79),
    ("30/12/2024 16:45:00", 102971.23),
    ("31/12/2024 12:15:00", 106551.5),
    ("31/12/2024 20:45:00", 104695.76),
    ("01/01/2025 12:45:00", 108613.44),
    ("01/01/2025 15:45:00", 107282.55),
    ("02/01/2025 06:45:00", 111182.53),
    ("02/01/2025 15:45:00", 107654.73),
    ("02/01/2025 23:15:00", 108916.90),
    ("03/01/2025 10:15:00", 105710.51),
    ("04/01/2025 02:45:00", 109810.61),
    ("04/01/2025 15:45:00", 107897.75),
    ("05/01/2025 02:15:00", 112523.10),
    ("05/01/2025 16:45:00", 110633.76),
    ("06/01/2025 07:15:00", 114710.34),
    ("07/01/2025 00:15:00", 110296.66),
    ("07/01/2025 07:15:00", 111676.18),
    ("08/01/2025 06:45:00", 106725.97),
    ("09/01/2025 00:15:00", 111820.97),
    ("09/01/2025 12:45:00", 110029.13),
    ("10/01/2025 06:45:00", 116581.13),
    ("10/01/2025 16:45:00", 114201.05),
    ("11/01/2025 07:45:00", 117811.89),
    ("11/01/2025 23:45:00", 113667.12),
    ("13/01/2025 00:45:00", 119558.49),
    ("13/01/2025 11:00:00", 117567.55),
    ("14/01/2025 00:45:00", 121087.9),
    ("14/01/2025 18:15:00", 115694.26),
    ("15/01/2025 08:15:00", 118155.78),
    ("15/01/2025 22:00:00", 112807.39),
    ("16/01/2025 15:45:00", 114608.29),
    ("17/01/2025 02:15:00", 111422.78),
    ("17/01/2025 18:45:00", 115612.81),
    ("18/01/2025 04:15:00", 112318.71),
    ("18/01/2025 14:45:00", 113965.76),
    ("19/01/2025 11:45:00", 107748.59)
]

try:
    df = generate_candlesticks_from_swings(swing_points)
    print("Generated Data:")
    print(df)
    df.to_csv("candlestick_data_smooth.csv", index=False)
    plot_candlestick(df)
except ValueError as e:
    print(f"Error: {e}")
