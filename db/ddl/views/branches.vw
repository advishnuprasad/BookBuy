CREATE OR REPLACE FORCE VIEW "BRANCHES" ("ID", "NAME", "ADDRESS", "CITY", "PHONE", "EMAIL", "CATEGORY", "PARENT_ID", "PARENT_NAME", "CARD_ID")
AS
 SELECT a.branchid id,
   a.branchid
   || ' - '
   || a.branchname name,
   a.branchaddress address,
   b.cityname city,
   a.contactnumbers phone,
   a.emailid email,
   a.branchtype category,
   a.parentbranchid parent_id,
   c.branchname parent_name,
   c.branchcard card_id
 from branch@jbclclink a,
   city@jbclclink b,
   branch@JBCLCLINK c
 WHERE a.cityid       = b.cityid (+)
 and a.parentbranchid = c.branchid (+)
WITH read only;
