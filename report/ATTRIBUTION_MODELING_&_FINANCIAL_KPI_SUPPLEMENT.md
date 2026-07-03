# Marketing Attribution & Financial KPI Supplement
**Author:** Akshansh Vijay  
**Date:** July 2026  
**Project:** Multi-Channel Marketing Analytics & Attribution Framework  

---

## 1. Executive Summary

This supplement documents the implementation of the advanced attribution modeling, corrected financial schemas, and critical business KPIs (**ROAS**, true **CAC**, and **CLV**) required by the project scope. 

During the audit, a major logic discrepancy was identified in the original data model's treatment of campaign spend, which has been corrected across the Python, SQL, and BI layers. In addition, we have designed and executed a multi-touch attribution comparison to measure individual channel contributions across customer interaction paths.

---

## 2. Financial Math Integrity & Schema Correction

### 🔍 The Data Discrepancy
In the raw campaign dataset, the column `Acquisition_Cost` represents the **Unit Cost Per Acquisition (CPA / CAC)** rather than the **Total Campaign Spend**. 
This is mathematically proven by the original campaign ROI formula in the raw data:
$$\text{ROI} = \frac{\text{Revenue} - \text{Total Spend}}{\text{Total Spend}} = \frac{\text{Revenue}}{\text{Acquisition\_Cost} \times \text{Conversions}} - 1$$

In the initial implementation, the team aggregated the `Acquisition_Cost` column directly as the total ad spend ($\sum \text{Acquisition\_Cost} = \text{₹62.7M}$). This led to a portfolio-wide ROI contradiction:
*   Total Revenue = **₹85.7B**
*   Total Cost (direct sum of unit costs) = **₹62.7M**
*   Implied Portfolio ROI = **1,365x** (or 136,500%)
*   Average Campaign ROI (from CSV) = **2.69x** (or 269%)

### 🛠️ The Corrected Logic
By defining $\text{True Campaign Spend} = \text{Acquisition\_Cost} \times \text{Conversions}$, the portfolio spend is correctly valued at **₹35.1B**, resulting in a consistent portfolio ROI of **1.44x** (and average campaign ROI of **2.69x**).

| Financial Metric | Before Correction (Incorrect) | After Correction (Corrected) |
| :--- | :--- | :--- |
| **Total Spend (Ad Spend)** | ₹62.70M | **₹35.09B** |
| **Net Profit** | ₹85.64B | **₹50.56B** |
| **Portfolio ROI** | 1,365.98x | **1.44x** |
| **Average Campaign CPA** | ₹2.08 | **₹207.62** |
| **Average CPC** | ₹0.32 | **₹32.07** |
| **Average CPL** | ₹0.97 | **₹96.65** |

---

## 3. Marketing KPI Framework & Formulas

To satisfy the submission requirements, the following formulas have been coded into the ETL pipelines and are recommended for the Power BI measure updates:

### 1. Return on Ad Spend (ROAS)
Measures gross revenue generated per rupee of marketing spend.
$$\text{ROAS} = \frac{\text{Revenue}}{\text{True Spend}} = \text{ROI} + 1$$
*   *Business Interpretation:* A ROAS of 2.94x means every ₹1.00 spent on advertising generates ₹2.94 in revenue.

### 2. Customer Acquisition Cost (CAC)
Measures the average cost spent to acquire a single customer.
$$\text{CAC} = \frac{\text{True Spend}}{\text{Conversions}} = \text{Acquisition\_Cost (Unit Cost)}$$
*   *Business Interpretation:* Serves as the primary metric for acquisition efficiency, with a lower CAC indicating higher campaign efficiency.

### 3. Customer Lifetime Value Floor (CLV)
In the absence of multi-purchase customer identifiers, the average purchase value driven per converted transaction serves as the baseline customer value floor.
$$\text{CLV Floor} = \frac{\text{Revenue}}{\text{Conversions}} = \text{Revenue Per Conversion}$$
*   *Business Interpretation:* The minimum revenue value a converted customer delivers. To maintain basic campaign profitability, $\text{CLV} > \text{CAC}$ must hold.

---

## 4. Multi-Touch Attribution Analysis

Since the campaigns utilize multi-channel configurations (e.g. `WhatsApp, YouTube`), we treat the channel lists as sequential customer touchpoint paths. We evaluated five core models:

1.  **First Touch:** Attributes 100% of conversion and revenue credit to the entry channel.
2.  **Last Touch:** Attributes 100% of credit to the final channel in the path (closer).
3.  **Linear:** Distributes credit equally ($1/n$) among all channels in the path.
4.  **Time-Decay:** Attributes exponentially increasing weights to later touchpoints ($w_i = 2^{i-1}$ normalized).
5.  **U-Shaped (Position-Based):** Allocates 40% to first, 40% to last, and distributes the remaining 20% to middle channels.

### 📊 Attributed Performance Comparison (in INR)

The python script [06_Attribution_Modeling.ipynb](file:///e:/Marketing-Attribution-Analytics/python/06_Attribution_Modeling.ipynb) parsed all 166,665 campaign logs to generate the following channel metrics:

#### Revenue Attribution by Model (Billions of INR)
| Channel | First Touch | Last Touch | Linear | Time-Decay | U-Shaped |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Email** | **₹14.416B** | **₹14.428B** | **₹14.437B** | **₹14.441B** | **₹14.431B** |
| **Instagram** | ₹14.382B | ₹14.393B | ₹14.384B | ₹14.386B | ₹14.385B |
| **YouTube** | ₹14.230B | ₹14.180B | ₹14.171B | ₹14.162B | ₹14.184B |
| **Google** | ₹14.229B | ₹14.045B | ₹14.167B | ₹14.126B | ₹14.155B |
| **WhatsApp** | ₹14.209B | ₹14.271B | ₹14.236B | ₹14.252B | ₹14.238B |
| **Facebook** | ₹14.184B | ₹14.334B | ₹14.255B | ₹14.283B | ₹14.257B |

#### Ad Spend Attribution by Model (Millions of INR)
| Channel | First Touch | Last Touch | Linear | Time-Decay | U-Shaped |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Email** | ₹4,863.31M | ₹4,853.48M | ₹4,869.08M | ₹4,866.69M | ₹4,864.81M |
| **Facebook** | ₹4,839.21M | ₹4,878.41M | ₹4,866.54M | ₹4,871.75M | ₹4,863.45M |
| **Google** | ₹4,854.96M | ₹4,825.41M | ₹4,839.60M | ₹4,834.47M | ₹4,839.83M |
| **Instagram** | ₹4,842.71M | ₹4,873.77M | ₹4,855.03M | ₹4,860.99M | ₹4,856.32M |
| **WhatsApp** | ₹4,851.69M | ₹4,849.85M | ₹4,846.42M | ₹4,846.19M | ₹4,848.16M |
| **YouTube** | ₹4,876.33M | ₹4,847.29M | ₹4,851.54M | ₹4,848.11M | ₹4,855.65M |

#### ROAS by Model (x Ratio)
| Channel | First Touch | Last Touch | Linear | Time-Decay | U-Shaped |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Email** | **2.96** | **2.97** | **2.97** | **2.97** | **2.97** |
| **Instagram** | 2.97 | 2.95 | 2.96 | 2.96 | 2.96 |
| **WhatsApp** | 2.93 | 2.94 | 2.94 | 2.94 | 2.94 |
| **Facebook** | 2.93 | 2.94 | 2.93 | 2.93 | 2.93 |
| **Google** | 2.93 | 2.91 | 2.93 | 2.92 | 2.92 |
| **YouTube** | 2.92 | 2.93 | 2.92 | 2.92 | 2.92 |

### 📊 Visualization Plots
Comparative visualizations generated via python are referenced here:
*   [Revenue Comparison](file:///e:/Marketing-Attribution-Analytics/images/attribution_revenue_comparison.png)
*   [ROAS Comparison](file:///e:/Marketing-Attribution-Analytics/images/attribution_roas_comparison.png)
*   [CAC Comparison](file:///e:/Marketing-Attribution-Analytics/images/attribution_cac_comparison.png)

---

## 5. Recommended Power BI DAX Updates

To fix the logical spend discrepancy in the Power BI dashboard, replace the existing measures with the following DAX definitions:

```dax
// 1. Corrected Total Spend (Ad Spend)
Total Cost = SUMX(
    fact_marketing_campaigns, 
    fact_marketing_campaigns[acquisition_cost] * fact_marketing_campaigns[conversions]
)

// 2. Corrected Portfolio Net Profit
Net Profit = SUM(fact_marketing_campaigns[revenue]) - [Total Cost]

// 3. True Portfolio ROI
Portfolio ROI = DIVIDE([Net Profit], [Total Cost], 0)

// 4. Return on Ad Spend (ROAS)
ROAS = DIVIDE(SUM(fact_marketing_campaigns[revenue]), [Total Cost], 0)

// 5. True Customer Acquisition Cost (CAC)
CAC = DIVIDE([Total Cost], SUM(fact_marketing_campaigns[conversions]), 0)

// 6. True Cost Per Click (CPC)
CPC = DIVIDE([Total Cost], SUM(fact_marketing_campaigns[clicks]), 0)

// 7. True Cost Per Lead (CPL)
CPL = DIVIDE([Total Cost], SUM(fact_marketing_campaigns[leads]), 0)

// 8. Customer Lifetime Value Floor (CLV)
CLV Floor = DIVIDE(SUM(fact_marketing_campaigns[revenue]), SUM(fact_marketing_campaigns[conversions]), 0)
```

Updating these formulas will automatically align all charts, tables, and KPIs, removing the previous visual contradictions.
