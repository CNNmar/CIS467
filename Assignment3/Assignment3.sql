use expense;
SET sql_mode = (SELECT REPLACE(@@SQL_MODE, "ONLY_FULL_GROUP_BY", ""));
CREATE OR REPLACE VIEW FourTableComb AS
SELECT em.ssn,first_name, last_name, total_expense, 
tr.number_of_trips, ROUND(sum(DISTINCT re.reimbursement_amount),2) AS total_reimbursement, COUNT(DISTINCT re.reimbursement_amount) AS reimbursement_num,
COALESCE(max(re.reimbursement_date), "Haven't reimbursed yet") AS last_reimbursement_date, ROUND(total_expense-sum(DISTINCT re.reimbursement_amount),2) AS Amount_not_reimbursed
FROM employees em 
JOIN (SELECT t.employee, t.trip_id, str_to_date(t.start_date,"%m/%d/%Y") as start_date, str_to_date(t.end_date,"%m/%d/%Y") as end_date, COUNT(*) AS number_of_trips
	FROM trips t
    GROUP BY t.employee) as tr
	ON em.ssn = tr.employee 
JOIN (SELECT e.employee, COUNT(DISTINCT e.trip_id) as num_of_trips, e.expense_seq, e.account_no, 
			ROUND(SUM(gross_amount),2) as total_expense
	FROM expenses e
    GROUP BY e.employee) as ex
    ON tr.employee = ex.employee
JOIN (SELECT r.employee, r.trip_id, auditor, ROUND(reimbursement_amount,2) as reimbursement_amount, str_to_date(reimbursement_date,"%m/%d/%Y") as reimbursement_date
	FROM reimbursements r
    ) as re
    ON re.employee = tr.employee
	AND re.employee = ex.employee
GROUP BY em.ssn, first_name, last_name
ORDER BY Amount_not_reimbursed DESC, total_expense DESC;

#### 1
SELECT(SELECT COUNT(*)
FROM FourTableComb
WHERE total_expense/number_of_trips < 
(SELECT AVG(total_expense/number_of_trips) FROM FourTableComb)) - 
(SELECT COUNT(*)
FROM FourTableComb
WHERE total_expense/number_of_trips > 
(SELECT AVG(total_expense/number_of_trips) FROM FourTableComb)) AS Diff_Lower_to_Higher;

#### 2
SELECT AVG(reimbursement_num/number_of_trips) AS reimburse_rate, AVG(Amount_not_reimbursed/total_expense) AS total_reimburse_money_rate,AVG(Amount_not_reimbursed/total_expense)/ AVG(reimbursement_num/number_of_trips) AS reimburse_money_rate_per_time
FROM FourTableComb;

#### 3
SELECT re.auditor, sum(DISTINCT re.reimbursement_amount) as total_reimbursement_amount
FROM 
(SELECT ssn, total_reimbursement/total_expense as reimbursement_ratio
FROM FourTableComb 
WHERE total_expense > 10000
ORDER BY reimbursement_ratio DESC LIMIT 10
) as f
JOIN reimbursements re ON re.employee = f.ssn
WHERE re.reimbursement_amount > 0
GROUP BY re.auditor
ORDER BY total_reimbursement_amount DESC;

#### 4
SELECT ssn,first_name, last_name,DATEDIFF(STR_TO_DATE('2017-12-31',"%Y-%m-%d"), STR_TO_DATE(last_reimbursement_date,"%Y-%m-%d")) as Time_since_last_time
FROM FourTableComb
WHERE DATEDIFF(STR_TO_DATE('2017-12-31',"%Y-%m-%d"), STR_TO_DATE(last_reimbursement_date,"%Y-%m-%d")) > 180
ORDER BY Time_since_last_time DESC;