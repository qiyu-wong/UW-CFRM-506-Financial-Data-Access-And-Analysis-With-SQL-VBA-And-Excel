USE NYCTaxi_Sample;

EXECUTE sp_execute_external_script
	@language = N'R'
	,@script = N'

bin <- function(x,thresh)
{
	if(x > thresh)
		return (1)
	else
		return (0)
}

LGSTC <- sapply(InputDataSet[,1], bin, thresh = 0.0)
lgstcData <- cbind(LGSTC, InputDataSet[,-1])
form <- LGSTC ~ trip_distance + passenger_count + trip_time_in_secs + fare_amount + surcharge + mta_tax + tolls_amount
scope <- list(lower = ~ trip_distance, upper = ~ trip_distance + passenger_count + trip_time_in_secs + fare_amount + surcharge + mta_tax + tolls_amount)
varSel <- rxStepControl(stepCriterion = "AIC", scope = scope)
rxlg.step <- rxLogit(formula = form, data = lgstcData, variableSelection = varSel, verbose = 0)
coeff.lgstc.df <- as.data.frame(rxlg.step$coefficients)
OutputDataSet <- cbind(rownames(coeff.lgstc.df), coeff.lgstc.df);'

	,@input_data_1 = N'SELECT tip_amount, trip_distance, passenger_count, trip_time_in_secs, fare_amount, surcharge, mta_tax, tolls_amount FROM nyctaxi_sample;'
WITH RESULT SETS ((Variable_Names VARCHAR(30), Coeff FLOAT));



EXECUTE sp_execute_external_script
	@language = N'R'
	,@script = N'
bin <- function(x,thresh)
{
	if(x > thresh)
		return (1)
	else
		return (0)
}

LGSTC <- sapply(InputDataSet[,1], bin, thresh = 0.0)
lgstcData <- cbind(LGSTC, InputDataSet[,-1])
form <- LGSTC ~ trip_distance + passenger_count + trip_time_in_secs + fare_amount + surcharge + mta_tax + tolls_amount
rxdt <- rxDTree(formula = form, data = lgstcData)
pred.rxdt <- rxPredict(modelObject = rxdt, data = lgstcData)
pred.df <- as.data.frame(pred.rxdt)
LGSTSP <- sapply(pred.df[,1], bin, thresh = 0.5)
pred.rxdt.df <- as.data.frame(cbind(lgstcData[,1], pred.rxdt,LGSTSP))

OutputDataSet <- pred.rxdt.df;'
,@input_data_1 = N'SELECT TOP (500000) tip_amount, trip_distance, passenger_count, trip_time_in_secs, fare_amount, surcharge, mta_tax, tolls_amount FROM nyctaxi_sample;'
WITH RESULT SETS ((Actual FLOAT, Predicted1 FLOAT, Predicted FLOAT));