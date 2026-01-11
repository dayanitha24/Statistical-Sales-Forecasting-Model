# ==========================================
# 1. SETUP & LIBRARIES
# ==========================================
# Remove objects
rm(list=ls())

# Load all required libraries for your specific models
library(tidyverse)
library(lubridate)
library(modeltime)
library(tidymodels)
library(timetk)
library(tseries)
library(forecast)
library(glmnet)
library(randomForest)

# Set directory
setwd("C:/Users/dayan/Downloads/Time-Series-Forecasting-with-R-main/Time-Series-Forecasting-with-R-main")

# Ensure pics folder exists
if(!dir.exists("pics")) dir.create("pics")

# ==========================================
# 2. READ DATASETS
# ==========================================
df_train=read.csv(file="data/train.csv", 
                  header=TRUE, sep=",", 
                  colClasses=c("integer","Date","factor","factor","numeric","numeric"))

df_test=read.csv(file="data/test.csv", 
                 header=TRUE, sep=",",
                 colClasses=c("integer","Date","factor","factor","numeric"))

df_oil = read.csv(file="data/oil.csv", 
                  header=TRUE, sep=",",
                  colClasses=c("Date","numeric"))

df_holidays = read.csv(file="data/holidays_events.csv", 
                       header=TRUE, sep=",",
                       colClasses=c("Date","factor","factor","factor","character","factor"))

df_stores = read.csv(file="data/stores.csv",
                     header=TRUE, sep=",",
                     colClasses =c("factor","factor","factor","factor","integer"))

df_transactions = read.csv(file="data/transactions.csv", 
                           header=TRUE, sep=",",
                           colClasses=c("Date","factor","numeric"))

# ==========================================
# 3. OIL FACTOR PROCESSING & PLOT
# ==========================================
df_oil$oil_NNA<-df_oil$dcoilwtico
df_oil[1,3]=df_oil[2,3]
prev_val=df_oil[1,3] # Initialize prev_val

for(i in 2:nrow(df_oil)){
  if(is.na(df_oil[i,3])){
    df_oil[i,3]=prev_val
  }else{
    prev_val=df_oil[i,3]
  }
}

# Fix: Store plot in variable and print so it shows in RStudio
plot_oil_init <- df_oil %>%
  mutate(date=as.Date(date)) %>%
  mutate(mod=ifelse(oil_NNA<=63,1,2)) %>%
  ggplot(aes(x=date,y=oil_NNA,col=as.factor(mod)))+geom_point()+
  scale_x_date(date_breaks="1 year")+ylab("Oil price")+xlab("date")+
  labs(title="Oil courses in Ecuador")

print(plot_oil_init)
ggsave("pics/plot_oil_initial.png", plot_oil_init)

# ==========================================
# 4. JOIN TABLES
# ==========================================
df_train <- left_join(x=df_train, y=df_stores, by="store_nbr")
df_train <- left_join(x=df_train, y=df_transactions, by=c("store_nbr","date"))
df_train[is.na(df_train$transactions),11] <- 0
df_train <- left_join(x=df_train, y=df_holidays, by="date")
df_train <- left_join(x=df_train, y=df_oil, by="date")

# ==========================================
# 5. DATA VISUALIZATION
# ==========================================

# Daily sales
plot1<-df_train %>%
  group_by(date) %>%
  summarise(daily_sales=sum(sales)) %>%
  ggplot(aes(x=date,y=daily_sales,groups=1))+geom_line()+geom_smooth()+
  labs(title="Sales",subtitle="Ecuador (2013-2017)")+
  xlab("Date")+ylab("Sales")
print(plot1)
ggsave("pics/plot1.png", plot1)

# Holidays plot
plot_holidays <-df_train %>%
  mutate(holidays_fact=ifelse(is.na(locale) | locale!="National","No","Yes")) %>%
  group_by(date) %>%
  summarise(
    daily_sales=sum(sales,na.rm=TRUE),
    holidays_fact=min(as.character(holidays_fact),na.rm=TRUE)
  )%>%
  mutate(holidays_fact=factor(holidays_fact,levels=c("No","Yes"))) %>%
  ggplot(aes(x=holidays_fact,y=daily_sales,fill=holidays_fact,group=holidays_fact))+geom_boxplot()+
  labs(title="Average sales",subtitle="Ecuador (2013-2017)")+xlab("National holidays (Yes / No)")+ylab("Average daily sales")
print(plot_holidays)
ggsave("pics/plot_holidays.png", plot_holidays)

# Products plot
plot_products <-df_train %>%
  group_by(date,family) %>%
  summarise(daily_sales=sum(sales,na.rm=TRUE), .groups = "drop") %>%
  filter(family %in% levels(family)[c(11:12,30,33)]) %>%
  ggplot(aes(x=date,y=daily_sales,color=family))+geom_line()+
  facet_grid(rows=vars(family))+labs(title="Daily sales for some products",subtitle="Ecuador (2013-2017)")+
  xlab("Date")+ylab("Daily sales")
print(plot_products)
ggsave("pics/plot_products.png", plot_products)

# Cities plots
plot_cities <- df_train %>%
  group_by(date,city) %>%
  summarise(sales=sum(sales,na.rm=TRUE), .groups = "drop") %>%
  ggplot(aes(x=city,y=sales,color=city))+geom_boxplot()+
  labs(title="Daily sales by city",subtitle="Ecuador (2013-2017)")+
  xlab("City")+ylab("Sales")
print(plot_cities)
ggsave("pics/plot_city1.png", plot_cities)

plot_cities2 <- df_train %>%
  group_by(date,city) %>%
  summarise(sales=sum(sales,na.rm=TRUE), .groups = "drop") %>%
  filter(city %in% levels(city)[c(1:4)]) %>%
  ggplot(aes(x=date,y=sales,color=city))+geom_line()+
  facet_grid(rows=vars(city))+
  labs(title="Daily sales for some cities",subtitle="Ecuador (2013-2017)")+
  xlab("Date")+ylab("Daily sales")
print(plot_cities2)
ggsave("pics/plot_city2.png", plot_cities2)

# Relation sales/oil
plot_salesvsoil <-df_train %>%
  group_by(date) %>%
  summarise(daily_sales=sum(sales,na.rm=TRUE),
            daily_oil=mean(oil_NNA,na.rm=TRUE)) %>%
  ggplot(aes(x=daily_oil,y=daily_sales))+geom_point()+geom_smooth()+
  ylim(c(300000,1200000))+
  labs(title="Impact of oil price",subtitle="Ecuador (2013-2017)")+
  xlab("Oil Price")+ylab("Daily sales")
print(plot_salesvsoil)
ggsave("pics/plot_oil.png", plot_salesvsoil)

# Promotions
Plot_promotions <- df_train %>%
  group_by(date) %>%
  summarise(sales = mean(sales, na.rm = TRUE),
            onprom = sum(onpromotion, na.rm = TRUE)) %>%
  mutate(Promotions = ifelse(onprom == 0, "No", "Yes")) %>%
  ggplot(aes(x = Promotions, y = sales, fill = Promotions)) +
  geom_boxplot() +
  labs(title = "Influence of promotions on daily sales", subtitle = "Ecuador (2013-2017)") +
  xlab("Promotions ?") + ylab("Daily sales")
print(Plot_promotions)
ggsave("pics/plot_promotions.png", Plot_promotions)

# ==========================================
# 6. SEASONAL DECOMPOSITION
# ==========================================
max_date=max(df_train$date)
min_date=min(df_train$date)

dat_ts_data <- df_train %>%
  filter(!grepl("Terremoto", description, fixed = TRUE)) %>%
  select(date,sales) %>%
  group_by(date) %>%
  summarise(value=sum(sales,na.rm=TRUE)) %>%
  arrange(date) # Ensure sorting

dat_ts <-ts(dat_ts_data$value, end=c(year(max_date), month(max_date)),
            start=c(year(min_date), month(min_date)),
            frequency = 30)

# Show in RStudio first, then copy to file
plot(stl(dat_ts,s.window = "periodic"), 
     main="Seasonal Decomposition of Time Series by Loess")
dev.copy(png, file="pics/stl_plot.png", width=960, height=960)
dev.off()

print(adf.test(dat_ts))

# ==========================================
# 7. TIME SERIES MODELING (STORE 51)
# ==========================================
data<- df_train %>%
  filter(!grepl("Terremoto", description, fixed = TRUE)) %>%
  filter(store_nbr==51) %>%
  group_by(date) %>%
  summarise(value=mean(sales,na.rm=TRUE)) %>%
  arrange(date) # Essential for time_series_split

# Split
splits <- data %>% time_series_split(assess = "3 months", cumulative = TRUE)

# Visualizing splits in RStudio
p_split <- splits %>%
  tk_time_series_cv_plan() %>%
  plot_time_series_cv_plan(date, value, .interactive = FALSE)
print(p_split)

# 1- Auto Arima
model_arima <- arima_reg() %>% set_engine("auto_arima") %>% fit(value ~ date, training(splits))

# 2- Prophet
model_prophet <- prophet_reg(seasonality_yearly = TRUE, seasonality_weekly =TRUE) %>%
  set_engine("prophet", holidays=df_holidays) %>%
  fit(value ~ date, training(splits))

# 3- TBATS
model_tbats<-seasonal_reg(mode="regression", seasonal_period_1= "auto") %>%
  set_engine("tbats") %>%
  fit(value ~ date, training(splits))

# 4- Seasonal Naive
model_snaive <- naive_reg() %>% set_engine("snaive") %>% fit(value ~ date, training(splits))

# Recipe for ML models
recipe <- recipe(value ~ date, training(splits)) %>%
  step_timeseries_signature(date) %>%
  step_fourier(date, period = c(365, 91.25, 30.42), K = 5) %>%
  step_dummy(all_nominal(),all_predictors())

# 5- Elastic Net
model_glmnet <- workflow() %>%
  add_model(linear_reg(penalty = 0.01, mixture = 0.5) %>% set_engine("glmnet")) %>%
  add_recipe(recipe %>% step_rm(date)) %>%
  fit(training(splits))

# 6- Random forest
model_rf <- workflow() %>%
  add_model(rand_forest(mode="regression",trees = 50, min_n = 5) %>% set_engine("randomForest")) %>%
  add_recipe(recipe %>% step_rm(date)) %>%
  fit(training(splits))

# 7- Prophet boost
model_prophet_boost <- workflow() %>%
  add_model(prophet_boost() %>% set_engine("prophet_xgboost")) %>%
  add_recipe(recipe) %>%
  fit(training(splits))

# ==========================================
# 8. EVALUATION & FORECASTING
# ==========================================
models_table <- modeltime_table(
  model_arima, model_prophet, model_tbats, model_snaive, model_glmnet, model_rf, model_prophet_boost
) 

calib_table <- models_table %>% modeltime_calibrate(testing(splits))

# Print Accuracy Table to Console
print(calib_table %>% modeltime_accuracy() %>% arrange(desc(rsq)))

# Plot Prophet + Prophet Boost (Fixed Subscript Error)
p_subset <- calib_table %>%
  filter(.model_id %in% c(2,7)) %>%
  modeltime_forecast(new_data = testing(splits), actual_data = data) %>%
  plot_modeltime_forecast(.interactive = FALSE,.conf_interval_show = FALSE)
print(p_subset)

# Plot All Models (Interactive)
p_all_inter <- calib_table %>%
  modeltime_forecast(new_data = testing(splits), actual_data = data) %>%
  plot_modeltime_forecast(.interactive = TRUE,.smooth=FALSE)
print(p_all_inter) # View in RStudio Viewer tab

# Final 3 Months Prediction using RF
p_final_forecast <- calib_table %>%
  filter(.model_id == 6) %>%
  modeltime_refit(data) %>%
  modeltime_forecast(h = "3 month", actual_data = data) %>%
  plot_modeltime_forecast(.y_lab="Sales",.x_lab="Date",
                          .title="Sales forecasting - Store 51",
                          .interactive = FALSE,.smooth=FALSE)
print(p_final_forecast)
ggsave("pics/final_rf_prediction.png", p_final_forecast)

