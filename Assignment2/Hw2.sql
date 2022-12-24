use safety;
####### Q1

SELECT SUM(Headcount) AS Total_Headcount
FROM safety.locations
WHERE Division = "KJ";

####### Q2
SELECT Audit_Date
FROM audits
WHERE Location_ID = 2415
ORDER BY DATEDIFF(now(),STR_TO_DATE(Audit_Date, "%m/%d/%Y")) LIMIT 1;

####### Q3

SELECT COUNT(*) AS Audit_Count
FROM audits
WHERE Auditor LIKE "%ain%";

####### Q4

SELECT auditor, COUNT(*) As Total_Num_Audit
FROM audits
GROUP BY auditor;

####### Q5

SELECT COUNT(*) AS No_Corr_Num
FROM audits
WHERE Corrective_Action IS NULL;

####### Q6

SELECT Location_ID,COUNT(Incident_ID) AS Incident_Num
FROM nmi
GROUP BY Location_ID
Having COUNT(Incident_ID) > 110;

####### Q7

SELECT Location_ID,COUNT(Incident_ID) AS LTI_Incident_Num
FROM lti
GROUP BY Location_ID
Having Left(Location_ID,1) = 2 or Left(Location_ID,1) = 3;

####### Q8

SELECT Location_ID
FROM locations
WHERE Headcount < (SELECT AVG(Headcount) FROM locations);

####### Q9

SELECT locations.Location_ID,locations.Division, locations.Headcount, COUNT(Incident_ID) AS LTI_Num, COUNT(Incident_ID)/locations.Headcount AS LTI_Percent
FROM safety.lti
JOIN locations ON locations.Location_ID = lti.Location_ID
GROUP BY locations.Location_ID
HAVING LTI_Percent > 0.2;

####### Q10

SELECT locations.Location_ID,locations.Division, locations.Headcount, COUNT(Incident_ID) AS NMI_Num, COUNT(Incident_ID)/locations.Headcount AS NMI_Percent
FROM safety.nmi
JOIN locations ON locations.Location_ID = nmi.Location_ID
GROUP BY locations.Location_ID
HAVING locations.Division = "PK";