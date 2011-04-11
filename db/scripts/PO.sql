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
select count(*) from corelist where isbn in (
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
ALTER TABLE corelist ADD branchid NUMBER;
update corelist set branchid=4;

SELECT * FROM CORELIST
WHERE ISBN IN (
SELECT ISBN FROM ENRICHEDTITLES WHERE TITLE_ID IS NOT NULL AND ISBNVALID='Y'
UNION
SELECT ISBN10 FROM ENRICHEDTITLES WHERE TITLE_ID IS NOT NULL AND ISBNVALID='Y'
)

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
TRUNCATE TABLE enrichedtitle_versions
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
SELECT count(*) FROM enrichedtitles WHERE title_id IS NULL
select count(*) from procurementitems where enrichedtitle_id in (select id from enrichedtitles where title_id is not null)

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


--Bangalore
SELECT * FROM BRANCH ORDER BY BRANCHID DESC
SELECT * FROM POMASTER WHERE BRANCHID=37
SELECT * FROM POSUPPLIERDETAILS WHERE BRANCHID=37 AND INVOICENUMBER IS NOT NULL AND JBBOOKNUMBER IS NOT NULL
and (isbn is not null or isbn_13 is not null or isbn_10 is not null)
SELECT COUNT(*) FROM POSUPPLIERDETAILS WHERE BRANCHID=37 AND INVOICENUMBER IS NOT NULL AND JBBOOKNUMBER IS NOT NULL
SELECT COUNT(*) FROM BOOKS WHERE ORIGLOCATION=37
SELECT ISBNNUMBER FROM INWARD_RECEIPT WHERE PONUMBER IN (SELECT PONUMBER FROM POMASTER WHERE BRANCHID=37)
SELECT * FROM INWARD_RECEIPT WHERE PONUMBER IN (SELECT PONUMBER FROM POMASTER WHERE BRANCHID=37)
AND length(ISBNNUMBER) = 13
SELECT * FROM TITLES WHERE ISBN_10 = '9780006165439' OR ISBN_13 = '9780006165439'
SELECT * FROM POSUPPLIERDETAILS WHERE ISBN_10 = '9780006165439' OR ISBN_13 = '9780006165439' OR ISBN = '9780006165439'

SELECT * FROM stock_audit_log WHERE branch_id = 37 AND to_char(log_date,'DD-MON-RR') = '09-APR-11'
SELECT count(*) FROM stock_audit_log WHERE action IS NULL AND 
n_isbn_13 is null and branch_id = 37 AND to_char(log_date,'DD-MON-RR') = '09-APR-11'


select  to_char(log_date,'DD-MON-RR'), count(*) from stock_audit_log where branch_id = 1 GROUP BY to_char(log_date,'DD-MON-RR')

select * from stock_audit_log where n_isbn_10 is not null

SELECT * FROM inward_receipt WHERE BOOKNUMBER=385422
select * from inward_receipt where isbnnumber='9780330508537'
select count(*) from inward_receipt wher
SELECT * FROM BOOKS WHERE BOOKNUMBER=385422
SELECT * FROM supplierprofile
SELECT * FROM pomaster
SELECT * FROM PUBLISHERPROFILE WHERE PUBLISHERCODE IN (51,143)
SELECT DISTINCT PUBLISHERID FROM POSUPPLIERDETAILS WHERE PONUMBER='NEWB/4759/20110303'
SELECT * FROM posupplierdetails WHERE jbbooknumber=385422


SELECT booknumber, ponumber 
      FROM inward_receipt A 
      WHERE 
      isbnnumber = '9789380032382'
      --Picking the latest Book Entry
      AND booknumber = (
        SELECT MAX(booknumber) FROM inward_receipt WHERE isbnnumber = A.isbnnumber
        AND BOOKNUMBER IN (SELECT BOOKNUMBER FROM BOOKS)
      )
      
SELECT publisherid, PONUMBER, COUNT(*)
        FROM posupplierdetails
        GROUP BY publisherid, PONUMBER
        HAVING COUNT(*) > 1
        
SELECT a.* FROM procurementitems A, enrichedtitles b
      WHERE
      A.enrichedtitle_id = b.ID
      AND
      /* ISBN and Supplier Details set */
      (
        b.isbn IS NOT NULL
        AND b.title_id IS NOT NULL
        AND b.publisher_id IS NOT NULL
        --AND A.supplier_id IS NOT NULL
        AND A.branch_id IS NOT NULL
        AND b.author IS NOT NULL
      )
      AND
      /* PO Details not set */
      (a.po_number IS NULL)
      
      AND A.supplier_id IS NULL
        
select * from titles@jbclclink where isbn_13 = '9788186734667' or isbn_10 
SELECT * FROM inward_receipt@jbclclink WHERE ISBNNUMBER='9788186734667'
SELECT * FROM BOOKS@JBCLCLINK WHERE BOOKNUMBER=385221
SELECT * FROM ENRICHEDTITLES WHERE ISBN = '9789380658001'
SELECT * FROM POMASTER@JBCLCLINK WHERE PONUMBER='NEWB/4759/20110303'
SELECT * FROM POSUPPLIERDETAILS@JBCLCLINK WHERE PONUMBER='NEWB/4759/20110303' AND JBBOOKNUMBER=385221
SELECT * FROM PUBLISHERS WHERE id = 11401 GROUP_ID=4
SELECT * FROM SUPPLIERS WHERE ID=2
SELECT * FROM SUPPLIERDISCOUNTS WHERE PUBLISHER_ID=11401