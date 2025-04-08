*================== AI发展 ====================*
use "/Users/wangzhanzhi/Desktop/人工智能/AI词频统计CASMAR.dta", clear
drop if year == 2024
* 按年度汇总AI词频（考虑多公司情况）
collapse (sum) AIWordF, by(year)

* 绘制更规范的曲线图
twoway (connected AIWordF year, ///
        xtitle("年份", size(medlarge)) ///
        ytitle("AI总词频数", size(medlarge)) ///
        xlabel(2010(1)2023, labsize(med) angle(45)) ///  // 关键修改点：angle(45)
        ylabel(, labsize(med) angle(0)) ///
        graphregion(color(white)) ///
        plotregion(color(white)) ///
        lcolor("navy") ///
        mcolor("maroon") msize(medlarge) ///
        msymbol(D)),
        note("数据来源：上市公司年报文本分析", size(small))
graph export "AI_WordFrequency_Trend.png", width(2000) replace



*除以公司数量
use "/Users/wangzhanzhi/Desktop/人工智能/AI词频统计CASMAR.dta", clear
drop if year == 2024

* 数据预处理
duplicates drop stkcd year, force
collapse (sum) AIWordF (count) N = stkcd, by(year)
gen AI_mean = AIWordF / N

* 双轴可视化设置
twoway (connected AIWordF year, yaxis(1) lcolor(navy) mcolor(navy) msymbol(D) msize(medlarge)) ///
       (connected AI_mean year, yaxis(2) lcolor(maroon) mcolor(maroon) msymbol(T) msize(medlarge)), ///
       title("AI词频总量与均值趋势对比", size(medium)) ///
       xtitle("年份", size(medlarge)) ///
       ytitle("总词频数", axis(1) size(medlarge)) ///
       ytitle("词频均值", axis(2) size(medlarge) color(maroon)) ///
       xlabel(2010(1)2023, angle(45) labsize(med)) ///
       ylabel(, axis(1) labsize(med) nogrid) ///
       ylabel(0(2)20, axis(2) labsize(med) angle(0) nogrid) ///  // 根据实际均值范围调整
       legend(order(1 "总词频数" 2 "词频均值") position(6) rows(1)) ///
       graphregion(color(white)) ///
       plotregion(color(white))
//      note("数据来源：CSMAR数据库（2010-2023）", size(vsmall))
//        text(15000 2020 "总词频数趋势", placement(east) color(navy)) ///
//        text(12 2020 "词频均值趋势", placement(east) color(maroon))
       
* 高质量输出
graph export "AI_DualAxis_Trend.png", width(2400) replace


		
use "/Users/wangzhanzhi/Desktop/人工智能/AI投资CASMAR.dta", clear
drop if year == 2024
* 按年度汇总AI投资（考虑多公司情况）
replace AIInvestTotal = AIInvestTotal/100000000
replace AISoftInvest = AISoftInvest/100000000
replace AIHardInvest = AIHardInvest/100000000
collapse (sum) AIInvestTotal AISoftInvest AIHardInvest , by(year)

* 绘制更规范的曲线图
* 示例数据变量：AIWordF（AI词频）、CloudWordF（云计算词频）、IoTWordF（物联网词频）

* 保持数据原样直接绘图
twoway (connected AIInvestTotal year, lcolor(blue) mcolor(blue) msymbol(D)) ///
       (connected AISoftInvest year, lcolor(red) mcolor(red) msymbol(T)) ///
       (connected AIHardInvest year, lcolor(green) mcolor(green) msymbol(S)), ///
       xtitle("年份", size(medlarge)) ///
       ytitle("投资（亿元）", size(medlarge)) ///
       xlabel(2010(1)2023, angle(45)) ///
       legend(label(1 "AI总投资") label(2 "AI硬件投资") label(3 "AI软件投资") ///
              position(6) rows(1)) ///
       graphregion(color(white))
graph export "AI_Investment_Trend.png", width(2000) replace
