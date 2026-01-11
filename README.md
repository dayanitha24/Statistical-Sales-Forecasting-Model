# 📈 Time Series Forecasting with R – Ecuador Store Sales

This project focuses on **time series forecasting of retail sales in Ecuador (2013–2017)** using the Kaggle *Store Sales – Time Series Forecasting* dataset.  
Multiple classical, statistical, and machine learning models are implemented and compared using the **Modeltime** framework in R.

---

## 🧠 Objective

- Explore and visualize sales patterns across time, cities, product families, promotions, holidays, and oil prices
- Perform seasonal decomposition and stationarity testing
- Build and compare multiple forecasting models
- Generate future sales forecasts for a specific store

---

## 🛠 Tech Stack

**Language:** R  

**Libraries Used:**
- tidyverse  
- lubridate  
- modeltime  
- timetk  
- tidymodels  
- forecast  
- tseries  
- glmnet  
- randomForest  
- prophet  
- xgboost  

---

## 📂 Project Structure

Time-Series-Forecasting-with-R/
├── data/
│ ├── train.csv
│ ├── test.csv
│ ├── oil.csv
│ ├── holidays_events.csv
│ ├── stores.csv
│ └── transactions.csv
│
├── pics/
│ ├── plot_oil_initial.png
│ ├── plot1.png
│ ├── plot_holidays.png
│ ├── plot_products.png
│ ├── plot_city1.png
│ ├── plot_city2.png
│ ├── plot_oil.png
│ ├── plot_promotions.png
│ ├── stl_plot.png
│ └── final_rf_prediction.png
│
├── main.R
└── README.md

yaml
Copy code

---

## 📊 Exploratory Data Analysis

The following analyses were performed:

- Daily sales trend analysis  
- Impact of national holidays on sales  
- Product family–wise sales comparison  
- City-wise sales distribution  
- Influence of promotions  
- Relationship between oil prices and sales  

All plots are automatically saved in the `pics/` directory.

---

## 🔄 Seasonal Decomposition

- STL decomposition applied to aggregated daily sales
- Trend, seasonality, and residual components analyzed
- Augmented Dickey–Fuller (ADF) test used to verify stationarity

---

## 🤖 Forecasting Models Implemented

Sales forecasting was performed for **Store 51** using the following models:

1. Auto ARIMA  
2. Prophet  
3. TBATS  
4. Seasonal Naïve  
5. Elastic Net Regression  
6. Random Forest  
7. Prophet Boost (Prophet + XGBoost)

### Feature Engineering
- Time series signatures  
- Fourier terms for multiple seasonal cycles  
- Dummy encoding of categorical features  

---

## 📏 Model Evaluation

- Rolling time series cross-validation
- Performance metrics:
  - RMSE
  - MAE
  - R²
- Calibration and evaluation performed using **modeltime**

---

## 🔮 Final Forecast

- Best-performing model (**Random Forest**) refitted on full dataset
- Generated **3-month future sales forecast**
- Final visualization saved as:

pics/final_rf_prediction.png

yaml
Copy code

---

## ▶️ How to Run the Project

1. Clone the repository  
```bash
git clone https://github.com/your-username/Time-Series-Forecasting-with-R.git
Open main.R in RStudio

Set working directory if needed

r
Copy code
setwd("path/to/project")
Install required packages (run once)

r
Copy code
install.packages(c(
  "tidyverse","lubridate","modeltime","tidymodels","timetk",
  "tseries","forecast","glmnet","randomForest","prophet"
))
Run the script from top to bottom

📌 Dataset Source
Kaggle – Store Sales: Time Series Forecasting
https://www.kaggle.com/competitions/store-sales-time-series-forecasting

✨ Key Takeaways
Promotions and holidays significantly influence sales

Oil prices show a measurable relationship with demand

Machine learning models outperform classical methods for short-term forecasting

Feature-engineered Random Forest provided the most stable results
