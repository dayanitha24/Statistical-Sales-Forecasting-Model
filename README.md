# 📈 Time Series Forecasting with R  
### Ecuador Retail Store Sales (2013–2017)

This project focuses on **time series forecasting of retail sales in Ecuador** using the **Kaggle Store Sales – Time Series Forecasting dataset**.  
It explores sales behavior over time and compares **classical statistical models and machine learning approaches** using the **Modeltime framework in R**.

---

## 🧠 Project Objectives
- Explore and visualize sales patterns across:
  - Time
  - Cities
  - Product families
  - Promotions
  - Holidays
  - Oil prices
- Perform **seasonal decomposition** and **stationarity testing**
- Build and compare multiple **forecasting models**
- Generate **future sales forecasts** for a selected store

---

## 🛠️ Tech Stack

**Language**
- R

**Libraries**
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

```text
Project_Folder/
│
├── main_script.R          # The R code provided
├── pics/                  # Folder where all plots are saved (created automatically)
└── data/                  # Source data files
    ├── train.csv
    ├── test.csv
    ├── oil.csv
    ├── holidays_events.csv
    ├── stores.csv
    └── transactions.csv


> ⚠️ **Note:**  
> The training dataset (`train.csv`) is excluded from the repository due to GitHub file size limits.

```

## 📊 Exploratory Data Analysis (EDA)

The following analyses were performed:
- Daily sales trend analysis
- City-wise sales distribution
- Product family sales comparison
- Impact of promotions on daily sales
- Influence of national holidays
- Relationship between oil prices and sales

All visualizations are automatically saved in the `pics/` directory.

---

## 🔄 Seasonal Decomposition & Stationarity
- **STL decomposition** applied to aggregated daily sales
- Trend, seasonality, and residual components analyzed
- **Augmented Dickey–Fuller (ADF) test** used to verify stationarity

---

## 🤖 Forecasting Models Implemented

Sales forecasting was performed for **Store 51** using:

- Seasonal Naïve  
- Auto ARIMA  
- TBATS  
- Prophet  
- Elastic Net Regression  
- Random Forest  
- Prophet Boost (Prophet + XGBoost)  

---

## ⚙️ Feature Engineering
- Time series signatures
- Fourier terms for multiple seasonal cycles
- Dummy encoding of categorical variables
- Promotion and holiday indicators

---

## 📏 Model Evaluation
- Rolling **time series cross-validation**
- Evaluation metrics:
  - RMSE
  - MAE
  - R²
- Calibration and performance comparison using **modeltime**

---

## 🔮 Final Forecast
- Best-performing model: **Random Forest**
- Refit on the full dataset
- Generated **3-month future sales forecast**
- Final visualization saved as:

pics/final_rf_prediction.png

---

## ▶️ How to Run the Project

### 1️⃣ Clone the repository
```bash
git clone https://github.com/dayanitha24/Statistical-Sales-Forecasting-Model.git
```
2️⃣ Open the script in RStudio

Open Code_v1.R

3️⃣ Set working directory (if required)
setwd("path/to/Statistical-Sales-Forecasting-Model")

4️⃣ Install required packages (run once)
install.packages(c(
  "tidyverse", "lubridate", "modeltime", "timetk",
  "tidymodels", "forecast", "tseries",
  "glmnet", "randomForest", "prophet", "xgboost"
))

5️⃣ Run the script

Execute the script from top to bottom.

📌 Dataset Source

Kaggle – Store Sales: Time Series Forecasting
https://www.kaggle.com/competitions/store-sales-time-series-forecasting

✨ Key Takeaways

Promotions and holidays significantly influence retail sales

Oil prices show a measurable relationship with demand

Machine learning models outperform classical methods for short-term forecasting

Feature-engineered Random Forest delivered the most stable results
