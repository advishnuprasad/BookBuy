--JBPROD Tables
SELECT * FROM pomaster@jbclclink
SELECT * FROM posuppliermaster@jbclclink

SELECT * FROM posupplierdetails@jbclclink
SELECT * FROM posupplierdetails@jbclclink WHERE
SELECT * FROM BRANCH@JBCLCLINK
select * from inward_receipt@jbclclink

--Considers only isbn13s
SELECT COUNT(*) FROM (
  select * from enrichedtitles where isbn in (
    SELECT ISBN FROM ENRICHEDTITLES
    MINUS
    --SELECT isbnnumber FROM inward_receipt@jbclclink where ponumber in (select ponumber from pomaster@jbclclink where branchid = 37)
    SELECT isbnnumber FROM inward_receipt@jbclclink 
  )
  AND title_id IS NULL
  and isbnvalid = 'Y'
)

--Correct Query for Title IDs
select * from corelist where isbn in (
select isbn from enrichedtitles where isbn in (
    SELECT ISBN FROM ENRICHEDTITLES
    MINUS
    --SELECT isbnnumber FROM inward_receipt@jbclclink where ponumber in (select ponumber from pomaster@jbclclink where branchid = 37)
    SELECT isbnnumber FROM inward_receipt@jbclclink 
  )
  AND title_id IS NULL
  AND isbnvalid = 'Y'
)
OR isbn IN (
  select isbn10 from enrichedtitles where isbn in (
    SELECT ISBN FROM ENRICHEDTITLES
    MINUS
    --SELECT isbnnumber FROM inward_receipt@jbclclink where ponumber in (select ponumber from pomaster@jbclclink where branchid = 37)
    SELECT isbnnumber FROM inward_receipt@jbclclink 
  )
  AND title_id IS NULL
  AND isbnvalid = 'Y'
)

--From Stock_audit_log
SELECT COUNT(*) FROM (
  select * from enrichedtitles where isbn in (
    SELECT ISBN FROM ENRICHEDTITLES
    MINUS
    SELECT n_isbn_13 FROM stock_audit_log@jbclclink WHERE action IS NULL AND n_isbn_13 IS NOT NULL AND branch_id IN (37,1) 
  )
  union
  SELECT * FROM enrichedtitles WHERE isbn10 IN (
    select isbn10 from enrichedtitles
    MINUS
    SELECT n_isbn_10 FROM stock_audit_log@jbclclink WHERE action IS NULL AND n_isbn_13 IS NOT NULL AND branch_id IN (37,1)
  )
)

--Corelist
SELECT * FROM corelist
drop table corelist2
TRUNCATE TABLE corelist
SELECT COUNT(*) FROM CORELIST -- 10909
SELECT * FROM corelist WHERE isbn='9788184821208'
drop table corelist_bkp

--Titles
SELECT *
  FROM titles@jbclclink
  WHERE isbn_13 = '9788184820362' OR isbn_10 = '9788184820362';

--Duplicate Titles by ISBN
SELECT * FROM PROCUREMENTITEMS WHERE ENRICHEDTITLE_ID IN (
SELECT ENRICHEDTITLE_ID FROM PROCUREMENTITEMS
GROUP BY ENRICHEDTITLE_ID HAVING COUNT(*) > 1)

--Duplicate Titles by ISBN
SELECT * FROM ENRICHEDTITLES WHERE ID IN (
SELECT ENRICHEDTITLE_ID FROM PROCUREMENTITEMS
GROUP BY ENRICHEDTITLE_ID HAVING COUNT(*) > 1)

DELETE FROM ENRICHEDTITLES;
DELETE FROM PUBLISHERS;

--ISBNs pointing to same Title ID
9780330438124
9780330415446
9780141033709
9780670918102
9780070583955
9780070534070

--Enrichment

select * from procurementitems where id=118263
SELECT * FROM ENRICHEDTITLES where id = 118252

CREATE TABLE enrichedtitles_bkp AS SELECT * FROM enrichedtitles
SELECT count(*) FROM enrichedtitles
SELECT count(*) FROM enrichedtitles_bkp
TRUNCATE TABLE enrichedtitles
INSERT INTO enrichedtitles
select * from enrichedtitles_bkp

--ISBN Validity
SELECT ISBNVALID, COUNT(*) FROM ENRICHEDTITLES GROUP BY ISBNVALID
update enrichedtitles set isbnvalid=null, isbn10 = null where isbnvalid='Y' and isbn10 is not null
SELECT * FROM enrichedtitles WHERE isbn IS NULL
SELECT * FROM enrichedtitles WHERE isbnvalid='N'
select * from enrichedtitles where isbn10 is not null and length(isbn10) != 10
SELECT * FROM corelist WHERE isbn IN (SELECT isbn FROM enrichedtitles WHERE isbnvalid='N')

SELECT COUNT(*) FROM ENRICHEDTITLES WHERE LENGTH(ISBN) = 13
AND ISBNVALID = 'Y'

--Publishers and Suppliers
SELECT * FROM publishers
SELECT count(*) FROM enrichedtitles WHERE title_id IS NOT NULL
SELECT * FROM inward_receipt@jbclclink
SELECT * FROM pomaster@jbclclink
select * from posupplierdetails@jbclclink
SELECT DISTINCT publisherid FROM posupplierdetails@jbclclink WHERE ponumber='NEWB/166/20100531'
select distinct suppliercode from posupplierdetails@jbclclink where ponumber='NEWB/166/20100531'

SELECT COUNT(*) FROM (
  SELECT TITLEID,BOOKNUMBEFROM BOOKS@JBCLCLINK WHERE BOOKNUMBER IN (
    SELECT BOOKNUMBER FROM INWARD_RECEIPT@JBCLCLINK A WHERE 
    ISBNNUMBER IN (SELECT ISBN FROM enrichedtitles WHERE title_id IS NULL)
    AND BOOKNUMBER = (
      SELECT MAX(BOOKNUMBER) FROM INWARD_RECEIPT@JBCLCLINK WHERE ISBNNUMBER = A.ISBNNUMBER
    )
  )
)

UPDATE ENRICHEDTITLES X SET TITLE_ID = (
  SELECT TITLEID FROM BOOKS@JBCLCLINK WHERE BOOKNUMBER IN (
    SELECT BOOKNUMBER FROM INWARD_RECEIPT@JBCLCLINK A WHERE
    ISBNNUMBER = X.ISBN
    AND BOOKNUMBER = (
      SELECT MAX(BOOKNUMBER) FROM INWARD_RECEIPT@JBCLCLINK WHERE ISBNNUMBER = A.ISBNNUMBER
    )
  )
)
WHERE title_id IS NULL

