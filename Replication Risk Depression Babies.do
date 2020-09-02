log using Replication_log.log

//import data; file titled "Useful Data from SCF 2016 and stock returns without headers"
//Column A = year; Column B = yearly return of general stock market
//Column C = yearly return adjusted for inflation; Column D = inflation rate
//Column E = age; Column F = YESFINRISK (respondant willing to take financial risk)
//Column G = NOFINRISK; Column H = stocks (total value of stocks)
//Column I = financial assets; Column J = income; Column K = liquid assets

//note: the original study accounts for age, year, and wealth/income effects. Because I am looking at the data for one year, I am not able to control for year

//note: because we calculate beta and lambda at the same time, we must use a nonlinear regression model

//fraction of financial assets invested in stocks
gen percentfin_riskyassets = H/I
gen percentliq_riskyassets = H/K

//calculate weighted average of past asset returns according to age; this is just the normal average, whcih occurs when lambda = 0
gen year_born = 2016-E
gen sum_total = sum(C)

gen sum_average_total = sum_total[89]

if year_born>1928{
	gen difference_year = year_born - 1928
	replace sum_average_total = sum_total[89] - sum_total[difference_year]
}

gen average_returns = sum_average_total/E


//find the relationship of different ages on investment in risky assets
regress E percentfin_riskyassets
regress E percentliq_riskyassets

//stock market participation
gen stock_market_participation = 1
replace stock_market_participation = 0 if H==0

//find the relationship of different ages on participation in stock market
regress E stock_market_participation

//find the relationship of different ages on average returns
regress E average_returns

//run a regression of weighted average to risky behavior
//controlling for age and income
//this shows how the average yearly stock market returns across a person's life affect his or her tendencies to invest in the stock market
gen age2=E^2
gen age3=E^3
regress average_returns E age2 age3 J percentfin_riskyassets
regress average_returns E age2 age3 J percentliq_riskyassets


//find the relationship between stock market performance over life and participation in stock market
//controlling for demographic effects
regress average_returns E age2 age3 J stock_market_participation

//regress self-reported financial risk taking with average of past returns
regress average_returns E age2 age3 J F

//only average the returns from the first half of people's lives
//this will serve as the impact of early life experiences

gen sum_average_firsthalf = sum_average_total

if year_born>1928{
	replace sum_average_firsthalf = sum_average_total-(sum_total[89]-sum_total[89-(E/2)])
}

gen average_firsthalf = sum_average_firsthalf/(E/2)


//regress average of first half returns to risky behavior
regress average_firsthalf E age2 age3 J percentfin_riskyassets
regress average_firsthalf E age2 age3 J percentliq_riskyassets

//regress stock market participation with average of first-half of life returns
regress average_firsthalf E age2 age3 J stock_market_participation

//regress self-reported financial risk taking with average of first-half of life returns
regress average_firsthalf E age2 age3 J F


//only average the returns from the second half of people's lives
//this will serve as the impact of later life experiences
gen sum_average_secondhalf = sum_total[89]
if year_born>1928{
	replace sum_average_secondhalf = sum_total[89] - sum_total[difference_year+(E/2)]
}
gen average_secondhalf = sum_average_secondhalf/(E/2)

//regress average of second half returns to risky behavior
regress average_secondhalf E age2 age3 J percentfin_riskyassets
regress average_secondhalf E age2 age3 J percentliq_riskyassets

//regress stock market participation with average of second-half of life returns
regress average_secondhalf E age2 age3 J stock_market_participation

//regress self-reported financial risk taking with average of second-half of life returns
regress average_secondhalf E age2 age3 J F



log close
