# Replication-Risk-Depression-Babies
#This is the Stata Code that runs the replication exercise
Nancy Li
Replication Final: Depression Babies

README text file

Files for Replication:

1.) For this replication exercise, data was taken from the annual S&P 500 stock returns. This data revealed the amount that the stock market returned year after year
2.) The annual returns reported by the S&P 500 returns are in nominal terms. As a result, data regarding the annual inflation rate was collected from the U.S. Bureau of Labor Statistics
3.) Then, real annual returns from the stock market were calculated by subtracting the nominal return percentage by the inflation rate percentage
4.) Data regarding risk attitudes and relevant demographic information, such as age, was collected from the most recent Survey of Consumer Finance from the year 2016
5.) The relevant categories of data that were used from the Survey of Consumer Finances were as follows: age, YESFINRISK (respondent willing to take financial risks), stocks(total value of stocks), financial assets, income, and liquid assets.
6.) All of this relevant data was compiled into one central excel document, titled “Useful Data from SCF 2016 and Stock Returns Without Headers.” This was the data used in the regressions.

Code Introduction:

1.) I first begin my code by generating a log file, which is called “Replication_log.log.” When the do file is run, this is where the regression tables and graphics can be accessed.
2.) The equation used to model the relationship between willingness to take financial risk and previous financial experiences reveals that Beta and Lambda are calculated at the same time, which means that the regression model used should not be a linear model, rather it is more akin to a quadratic model
3.) Lambda is the weight of the yearly return. For instance, if lambda is positive, it means that more recent returns are more important than earlier returns in influencing financial risk taking behaviors. If lambda is negative, it means that earlier returns are more important than more recent returns in influencing financial risk taking behaviors. If lambda is zero, it means that all years of returns are equally weighted
4.) Knowing this, if we can approximate a lambda, then we will be able to run a linear regression
5.) In the original study, they approximated lambda by estimating a function that would assign different weights to the different years of returns at different ages, estimated by the optimal return point of various individuals who were 50 years of age
6.) Given the limitations of Stata's software and the inability to generate such equations, I accounted for lambda by taking three different scenarios of returns for each individual. The first scenario was in which all returns were weighted equally, which was equivalent to lambda being equal to 0. The second scenario was in which only returns from the first half of each individual's life were accounted for in taking the average. This thereby assigns more weight to earlier returns, and as such, and as such, parallels an instance in which lambda is negative. The last scenario was in which only returns from the second half of each individual's life were accounted for in taking the average. This thereby assigns more weight to later returns, and as such, parallels an instance in which lambda is positive.
7.) These three instances were regressed against the indicators of financial attitude

Code Introductory Variable Generation:
1.) To start off the analysis, variables that revealed the percentage of total assets that a person invested in risky stocks were created. One was called "percentfin_riskyassets," which was calculated by dividing the value of total stocks by the value of total financial assets. The other was called "percentliq_riskyassets," which was calculated by dividing the value of total stocks by the value of liquid assets
2.) Next, I created a variable called "year_born," which was calculated by subtracting the individual's age from the year 2016, which was when the data was collected. This would be useful when calculating the average returns

To calculate unweighted average returns(lambda equals 0):
1.) I first summed together the total returns from the stock market from the years 1928 to 2016. This was stored in the variable "sum_total," and was calculated by adding together all the values of the yearly returns adjusted for inflation
2.) To calculate each individual's average return, I first began with making everyone's average return the maximum sum, which was "sum_total[89]." This was stored in the variable "sum_average_total"
3.) Then, for every person born after 1928, I would calculate the difference between their birth year and 1928, which was stored in the variable "difference_year," which was calculated by taking year_born and subtracting 1928
4.) Then, to adjust "sum_average_total" to the correct values for each individual, "sum_average_total" equalled sum_total[89]-sum_total[difference_year]
5.) Finally, to calculate the average stock returns per year, which was designated as "average_returns," I divided sum_average_total by age

Create a variable to see if someone participates in the stock market:
1.) I wanted to create a variable "stock_market_participation" that would equal 1 if the person owned stocks, and that would equal 0 if the person did not own stocks
2.) To do this, I first created a variable "stock_market_participation" that by default equaled 1
3.) If the amount of stocks equaled zero, "stock_market_participation" would be replaced by 0

Run effect of age on various factors:
1.) I did this just for personal knowledge, to confirm my findings later. Age is a control variable, and as a result, I wanted to know how it correlated with various risk attitudes variables

Create an age^2 and age^3 variable:
1.) I did this to better allow age to serve as a control

Regress average_returns with risk attitude indicator variables:
1.) Controlling for age and income, I regressed average returns with the various risk attitude indicator variables, which were stock_market_participation, YESFINRISK, percentfin_riskyassets, and percentliq_riskyassets

Create a variable that only takes returns from the first half of life into account:
1.) This serves as the impact of early life experiences
2.) This was done by creating a variable called "sum_average_firsthalf," which was set equal to "sum_average_total" by default
3.) Then, if the individual was born after 1928,"sum_average_firsthalf" was set equal to sum_average_total minus sum_total[89]plus sum_total[89-(age/2)]
4.) The reason why this works, is because sum_average_total is the original total stock market return across the person's life. sum_total[89] is the total amount of stock market returns from 1928 to 2016. sum_total[89-(age/2)] is the amount of stock market returns from 1928 through the first half of the person's life. I am effectively thus subtracting the returns from the latter half of the person's life from their total returns, which leaves me with only the returns from the first half of their life
5.) To calculate average returns from the first half of life, I generated a variable for this, which was called "average_firsthalf," which was calculated by taking sum_average_firsthalf divided by half of the person's age.

Regress average of first half returns to risky behavior
1.) I then took this variable, "average_firsthalf" and regressed it in the same manner as I regressed the original average_returns.

Crate a variable that only takes returns from the second half of life into account
1.) This serves as the impact of later life experiences
2.) This was done by creating a variable called "sum_average_secondhalf," which was set equal to sum_total[89] by default
3.) Then, if the individual was born after 1928, "sum_average_secondhalf" was set equal to sum_total[89]-sum_total[difference_year+(E/2)]
4.) The reason why this works is because sum_total[difference_year+(E/2)] is all the returns from the first half of the person's life, as well as all the returns from before the person was born
5.) By subtracting it from sum_total[89], which denotes total returns from 1928 to 2016, I am left only with the returns from the latter half of the person's life
6.) To calculate average returns from the latter half of life, I generated a variable for this, which was called "average_secondhalf," which was calculated by taking sum_average_secondhalf divided by half of the person's age

Regress average of second half returns to risky behavior
1.) I then took this variable, "average_secondhalf" and regressed it in the same manner as I regressed the original average_returns

Close the log file
1.) I lastly closed the log file with the line "log close"

As comparison with the original report, I took a year from before the recession, which was 2007, and I basically ran my same code, just with different data. This data is called SCF 2007 and stock returns useful data. The only difference is that I changed all the "2016" in the code to "2007"
