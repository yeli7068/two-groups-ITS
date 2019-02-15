**************************************************************************
* 这个项目提供如下文章中所使用的实验数据和Stata代码：
* 两组中断时间序列设计及其分析方法
* 作者：李洋
* 邮箱：yeli7068@outlook.com
* License: GPL3.0
**************************************************************************
clear
import delimited example_data.csv, clear 

/*
相关变量解释：
incidence 疾病发病率
time 时间编码
int 干预哑变量编码
post 干预后斜率编码
group 分组哑变量
*/

* 第一步 声明交互项
gen grouptime=group*time
gen groupint=group*int
gen grouppost=group*post

* 第二步 声明该数据为时间序列数据
tsset group time

* 第三步 使用线性回归
regress incidence time int post group grouptime groupint grouppost

* 第四步 对模型进行自相关检验
actest, lag(10)

* 第五步 使用prais和newey进行回归与模型检验
prais incidence time int post group grouptime groupint grouppost
newey incidence time int post group grouptime groupint grouppost, lag(1) force
predict newey_residuals, residuals
swilk newey_residuals
