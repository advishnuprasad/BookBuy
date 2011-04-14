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
        
SELECT A.ID FROM procurementitems A, enrichedtitles b
      WHERE
      A.enrichedtitle_id = b.ID
      AND
      /* ISBN and Supplier Details set */
      (
        b.isbn IS NOT NULL
        AND b.title_id IS NOT NULL
        AND b.publisher_id IS NOT NULL
        AND nvl(A.supplier_id,-1) = nvl(null,-1)
        AND A.branch_id IS NOT NULL
        AND b.author IS NOT NULL
      )
      AND
      /* PO Details not set */
      (A.po_number IS NULL)
      group by A.supplier_id 
        
select * from titles@jbclclink where isbn_13 = '9788184821192' or isbn_10 
SELECT * FROM inward_receipt@jbclclink WHERE ISBNNUMBER='9788184821192'
SELECT * FROM BOOKS@JBCLCLINK WHERE BOOKNUMBER=385221
SELECT * FROM ENRICHEDTITLES WHERE ISBN = '9788131707746'
SELECT * FROM POMASTER@JBCLCLINK WHERE PONUMBER='NEWB/4759/20110303'
SELECT * FROM POSUPPLIERDETAILS@JBCLCLINK WHERE PONUMBER='NEWB/4759/20110303' AND JBBOOKNUMBER=385221
SELECT * FROM PUBLISHERS WHERE id = 11401 GROUP_ID=4
SELECT * FROM SUPPLIERS WHERE ID=2
SELECT * FROM SUPPLIERDISCOUNTS WHERE PUBLISHER_ID=11401

SELECT * FROM procurementitems WHERE isbn='9788129111265'
SELECT * FROM enrichedtitles WHERE isbn='9788129111265'
select * from procurementitems where id=12934
SELECT * FROM enrichedtitles WHERE ID=145050
SELECT * FROM publishers WHERE ID=10102
SELECT * FROM publishers WHERE ID IN (10104, 10107)
update publishers set group_id=59, publishername='Sanjay and Co'  WHERE ID IN (10104, 10107)
SELECT * FROM supplierdiscounts WHERE publisher_id=11507
SELECT count(*) FROM enrichedtitles WHERE title_id IS NULL

UPDATE WORKITEMS SET WORKLIST_ID = 10048 WHERE ID IN (
SELECT ID FROM WORKITEMS WHERE WORKLIST_ID = 10057 AND REF_ID IN (
SELECT ID FROM PROCUREMENTITEMS WHERE ENRICHEDTITLE_ID IN (
SELECT ID FROM ENRICHEDTITLES WHERE PUBLISHER_ID IN (10093,10086,10092,10085)
)
)
)

DELETE FROM WORKITEMS WHERE WORKLIST_ID=10057
DELETE FROM WORKLISTS WHERE ID=10057

SELECT DISTINCT publisher_id FROM enrichedtitles WHERE publisher_id NOT IN 
(SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=102)
AND ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE ID IN (
SELECT ref_id FROM workitems WHERE worklist_id=10028))

SELECT * FROM PUBLISHERS WHERE ID IN (
SELECT PUBLISHER_ID FROM ENRICHEDTITLES WHERE ID IN (
(SELECT enrichedtitle_id FROM procurementitems WHERE ID IN (
SELECT ref_id FROM workitems WHERE worklist_id=10057))))

SELECT DISTINCT WORKLIST_ID FROM WORKITEMS WHERE REF_ID IN (
SELECT ID FROM PROCUREMENTITEMS WHERE ENRICHEDTITLE_ID IN (
SELECT ID FROM ENRICHEDTITLES WHERE PUBLISHER_ID IN (10084,10087,10088,10091,10115,10142)))

SELECT b.code, b.id "Publisher ID", b.publishername, c.id "Supplier ID", c.name FROM supplierdiscounts A, publishers b, suppliers c
WHERE A.publisher_id = b.ID
AND A.supplier_id = c.ID
ORDER BY publishername, code



SELECT * FROM PUBLISHERS WHERE UPPER(PUBLISHERNAME) LIKE '%PAN%'
SELECT * FROM PUBLISHERS WHERE CODE='0-8362'
SELECT * FROM SUPPLIERS WHERE UPPER(NAME) LIKE '%DOLPHIN%'

SELECT * FROM SUPPLIERS WHERE ID in (165,1462)

/* Supplier Correction -Start */
DELETE FROM WORKITEMS WHERE WORKLIST_ID = 10035 AND REF_ID IN (13412,13416,13419) 
DELETE FROM WORKITEMS WHERE REF_ID=13376
UPDATE ENRICHEDTITLES SET ISBNVALID='N' WHERE ID IN (SELECT ENRICHEDTITLE_ID FROM PROCUREMENTITEMS WHERE ID IN (13412,13416,13419) )
UPDATE ENRICHEDTITLES SET ISBNVALID='N' WHERE isbn='9788129111265'
UPDATE PUBLISHERS SET GROUP_ID=2, PUBLISHERNAME='Harper Collins' WHERE CODE='0-00'
UPDATE PUBLISHERS SET GROUP_ID=51, PUBLISHERNAME='Euro Kids' WHERE CODE='81-286'
UPDATE PUBLISHERS SET GROUP_ID=69, PUBLISHERNAME='Harper Collins US' WHERE CODE='0-06'
UPDATE PUBLISHERS SET GROUP_ID=6, PUBLISHERNAME='Hachette' WHERE CODE='0-340'
UPDATE PUBLISHERS SET GROUP_ID=5, PUBLISHERNAME='Rupa Publications' WHERE CODE='81-291'
UPDATE PUBLISHERS SET GROUP_ID=108, PUBLISHERNAME='Simon & Schuster US' WHERE CODE='0-8362'
UPDATE PUBLISHERS SET GROUP_ID=108, PUBLISHERNAME='Simon & Schuster US' WHERE CODE='0-85720'
UPDATE PUBLISHERS SET GROUP_ID=786, PUBLISHERNAME='Perseus Publishers' WHERE CODE='1-59315'
UPDATE PUBLISHERS SET GROUP_ID=52, PUBLISHERNAME='Pan Macmillan' WHERE ID IN (10093,10086,10092,10085)

UPDATE PROCUREMENTITEMS SET SUPPLIER_ID = 1
WHERE ID IN (
SELECT REF_ID FROM WORKITEMS WHERE WORKLIST_ID=10055
)
AND (supplier_id != 1 OR SUPPLIER_ID IS NULL)
SELECT * FROM SUPPLIERS WHERE ID in (83,1459)

SELECT SUPPLIER_ID, COUNT(*) FROM PROCUREMENTITEMS WHERE ID IN (
  SELECT REF_ID FROM WORKITEMS WHERE WORKLIST_ID=10055
)
GROUP BY SUPPLIER_ID

SELECT * FROM ENRICHEDTITLES WHERE ID IN (
  SELECT ENRICHEDTITLE_ID FROM PROCUREMENTITEMS WHERE SUPPLIER_ID =1454 AND ID IN (
    SELECT REF_ID FROM WORKITEMS WHERE WORKLIST_ID=10035
  )
)

10035, 10039, 10052, 10055

SELECT * FROM PUBLISHERS WHERE ID IN (
  SELECT PUBLISHER_ID FROM ENRICHEDTITLES WHERE ID IN (
    SELECT ENRICHEDTITLE_ID FROM PROCUREMENTITEMS WHERE SUPPLIER_ID =83 AND ID IN (
      SELECT REF_ID FROM WORKITEMS WHERE WORKLIST_ID=10039
    )
  )
)
/* Supplier Correction - End */

SELECT * FROM publishers WHERE ID IN (
SELECT publisher_id FROM enrichedtitles WHERE ID IN (
SELECT enrichedtitle_id FROM procurementitems WHERE ID IN (
SELECT ref_id FROM workitems WHERE worklist_id = 10041
)
)
)

SELECT * FROM corelist WHERE isbn IN (
  SELECT isbn FROM enrichedtitles WHERE ID IN (
    SELECT enrichedtitle_id FROM procurementitems WHERE ID IN (
      SELECT ref_id FROM workitems WHERE worklist_id = 10042
    )
  )
)
AND PUBLISHERCODE=2632


SELECT * FROM workitems WHERE ref_id IN (
SELECT ID FROM procurementitems WHERE enrichedtitle_id IN (
SELECT id FROM enrichedtitles WHERE isbn IN (
SELECT isbn FROM corelist WHERE publishercode = 69
)))
AND worklist_id = 10041

SELECT * FROM ENRICHEDTITLES WHERE 
ID IN (
SELECT ENRICHEDTITLE_ID FROM PROCUREMENTITEMS WHERE ID IN (
SELECT REF_ID FROM WORKITEMS WHERE worklist_id = 10041
))
AND isbn IN (
SELECT isbn FROM corelist WHERE publishercode = 6
)

SELECT DISTINCT ID FROM suppliers WHERE id IN (
SELECT DISTINCT suppliercode FROM posupplierdetails@jbclclink A 
where titleid in (
select titleid from titles@jbclclink where titleid in (
select title_id from enrichedtitles where id in (
SELECT enrichedtitle_id FROM procurementitems WHERE ID IN (
SELECT ref_id FROM workitems WHERE worklist_id=10027
))))
AND publisherid IS NOT NULL
and ponumber = (select max(ponumber) from posupplierdetails@jbclclink where titleid = a.titleid))

SELECT * FROM corelist WHERE isbn IN 
(
SELECT isbn FROM procurementitems WHERE ID IN (
select ref_id from workitems where worklist_id = 10027)
)

select * from enrichedtitles where isbn in (
SELECT isbn FROM procurementitems WHERE ID IN (
select ref_id from workitems where worklist_id = 10027))

SELECT * FROM procurementitems WHERE cc
select * from enrichedtitles wher

SELECT worklist_id,c.currency,count(*) FROM workitems A, procurementitems b, enrichedtitles c
WHERE A.ref_id = b.ID
AND b.enrichedtitle_id = c.ID
GROUP BY worklist_id,c.currency
order by 1

SELECT * FROM enrichedtitles WHERE ID IN 
(SELECT enrichedtitle_id FROM procurementitems WHERE ID IN (SELECT ref_id FROM workitems WHERE worklist_id=10031))
AND currency = 'INR'

SELECT * FROM publishers WHERE ID=10054
SELECT * FROM corelist WHERE isbn='9780061711480'
select * from corelist where publishercode=69

SELECT A.isbn, a.title, publishercode, publisher, publishername, group_id 
FROM
enrichedtitles A, corelist b, publishers c
WHERE A.publisher_id = c.ID
AND A.isbn = b.isbn
AND group_id != publishercode
ORDER BY 4

SELECT A.isbn, a.title, publishercode, publisher, publishername, group_id 
FROM
enrichedtitles A, corelist b, publishers c
WHERE A.publisher_id = c.ID
AND A.isbn = b.isbn
AND A.ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NOT NULL)
AND group_id != publishercode
ORDER BY 4


DELETE FROM workitems WHERE ref_id IN (
select id from procurementitems where isbn IN (
SELECT A.isbn
FROM
enrichedtitles A, corelist b, publishers c
WHERE A.publisher_id = c.ID
AND A.isbn = b.isbn
AND group_id != publishercode))

DELETE FROM workitems WHERE ref_id IN (
select id from procurementitems where isbn='9781400050840'
)

delete from worklists where id not in (select distinct worklist_id from workitems)
delete from workitems where worklist_id=10031

SELECT  * FROM corelist WHERE publisher = 'Pan Macmillan' and publishercode!=52

UPDATE corelist SET publishercode = 52 WHERE publisher = 'Pan Macmillan' 
SELECT count(*) FROM worklists
select count(*) from workitems

SELECT * FROM enrichedtitles
select * from procurementitems

CREATE OR REPLACE VIEW PO_VIEW AS
SELECT 'po_number' ponumber,b.worklist_id,d.title, d.isbn, d.author, e.publishername, A.quantity, d.listprice, d.currency 
FROM 
procurementitems A, workitems b, enrichedtitles d, publishers e
WHERE A.ID = b.ref_id
AND A.enrichedtitle_id = d.ID
AND d.publisher_id = e.ID
and worklist_id != 10027
order by worklist_id

SELECT * FROM pos
SELECT * FROM worklists
SELECT * FROM WORKITEMS

SELECT * FROM WORKLISTS WHERE ID IN
      (SELECT DISTINCT WORKLIST_ID FROM WORKITEMS WHERE REF_ID IN
        (SELECT ID FROM PROCUREMENTITEMS WHERE PO_NUMBER IS NULL)
      )
      AND ID BETWEEN 10028 AND 10059
      
DELETE FROM PROCUREMENTITEMS WHERE 
ID 
NOT IN (SELECT REF_ID FROM WORKITEMS WHERE WORKLIST_ID BETWEEN 10028 AND 10059)

SELECT COUNT(*) FROM PROCUREMENTITEMS
SELECT * FROM PROCUREMENTITEMS WHERE ID IN (SELECT REF_ID FROM WORKITEMS 
WHERE WORKLIST_ID BETWEEN 10028 AND 10059)
ORDER BY PO_NUMBER, ID
SELECT COUNT(*) FROM WORKITEMS WHERE WORKLIST_ID BETWEEN 10028 AND 10059

SELECT * FROM PO_VIEW ORDER BY PONUMBER

ALTER TABLE POS ADD TYPEOFPO VARCHAR2(255);
ALTER TABLE POS ADD CONVRATE NUMBER;
ALTER TABLE POS ADD GROSSAMT NUMBER;
ALTER TABLE POS ADD NETAMT NUMBER;
ALTER TABLE POS ADD ORGUNIT	NUMBER;
ALTER TABLE POS ADD SUBORGUNIT	NUMBER;
ALTER TABLE POS ADD EXPENSEHEAD	NUMBER;
ALTER TABLE POS ADD PAYBY1 DATE;
ALTER TABLE POS ADD PAYABLEAMT1 NUMBER;
ALTER TABLE POS ADD PAYBY2 DATE;
ALTER TABLE POS ADD PAYABLEAMT2 NUMBER;
ALTER TABLE POS ADD PAYBY3 DATE;
ALTER TABLE POS ADD PAYABLEAMT3 NUMBER;
ALTER TABLE POS ADD NARRATION VARCHAR2(255);

SELECT B.NAME, SUM(COPIES_CNT) "Total Qty", round(SUM(GROSSAMT),0) "Total Amount", round(SUM(NETAMT),0) "Net Amount", ROUND(SUM(NETAMT)/SUM(COPIES_CNT),0) "Per Book Cost"
FROM POS A, BRANCHES B
WHERE A.BRANCH_ID = B.ID
GROUP BY rollup(B.NAME)

SELECT * FROM POS ORDER BY PAYBY1

SELECT 'Pay after 90 days', sum(payableamt1) FROM POS WHERE PAYBY1 > CREATED_AT + 90
UNION
SELECT 'Pay after 60 days', sum(payableamt1) FROM POS WHERE PAYBY1 > CREATED_AT + 60 and PAYBY1 < CREATED_AT + 90
UNION
SELECT 'Pay after 30 days', sum(payableamt1) FROM POS WHERE PAYBY1 > CREATED_AT + 30 and PAYBY1 < CREATED_AT + 60
UNION
SELECT 'Pay immediately', sum(payableamt1) FROM POS WHERE PAYBY1 > CREATED_AT + 0 and PAYBY1 < CREATED_AT + 30

SELECT * FROM POS
WHERE SUPPLIER_ID = 104
and code='NSTR/0079/20110412'

select * from procurementitems where po_number='NSTR/0079/20110412'

SELECT * FROM PO_VIEW

SELECT A.CODE "PO_NUMBER", D.NAME,A.SUPPLIER_ID, B.NAME, PUBLISHER_ID, 
(SELECT DISTINCT PUBLISHERNAME FROM PUBLISHERS WHERE GROUP_ID = A.PUBLISHER_ID) "PUBLISHER",
A.COPIES_CNT "QTY", TO_CHAR(A.CREATED_AT,'DD-MON-RR') "PO DATE", A.DISCOUNT, GROSSAMT "GROSS",NETAMT "NET", 
PAYBY1 "PAY BY", PAYABLEAMT1 "AMT PAYABLE" 
FROM POS A, SUPPLIERS B, BRANCHES D
WHERE A.SUPPLIER_ID = B.ID
AND A.BRANCH_ID = D.ID
order by po_number

SELECT A.SUPPLIER_ID "Supplier ID", B.NAME "Supplier Name", TO_CHAR(PAYBY1,'DD-MON-RR') "Pay By", SUM(PAYABLEAMT1) "Amt Payable"
FROM POS A, SUPPLIERS B
WHERE A.SUPPLIER_ID = B.ID
GROUP BY A.SUPPLIER_ID, B.NAME, TO_CHAR(PAYBY1,'DD-MON-RR')
order by SUPPLIER_ID




BEGIN
  data_pull.pr_pull_corelist_items;
END;

SELECT count(*) FROM procurementitems WHERE po_number IS NULL and enrichedtitle_id not in (select id from enrichedtitles)
SELECT count(*) FROM procurementitems_bkp
delete from procurementitems where po_number is null

SELECT count(*) FROM enrichedtitles
SELECT count(*) FROM enrichedtitles_bkp
SELECT 11037-10909 FROM dual--128
SELECT count(*) FROM enrichedtitles WHERE ID NOT IN (SELECT ID FROM enrichedtitles_bkp)
  and id not in (select enrichedtitle_id from procurementitems)
delete from enrichedtitles WHERE ID NOT IN (SELECT ID FROM enrichedtitles_bkp)

SELECT * FROM corelist
SELECT DISTINCT publishercode FROM corelist
WHERE publishercode NOT IN (SELECT group_id FROM publishers)
AND publishercode IS NOT NULL
select * from supplierdiscounts where discount is null


SELECT count(A.ID) FROM procurementitems A, enrichedtitles b
        WHERE
        A.enrichedtitle_id = b.ID
        AND
        /* ISBN and Supplier Details set */
        (
          b.isbn IS NOT NULL
          --AND b.title_id IS NOT NULL
          AND b.publisher_id IS NOT NULL
          --AND b.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
          --AND nvl(A.supplier_id,-1) = nvl(supplier.supplier_id,-1)
          AND a.branch_id is not null
          AND b.author IS NOT NULL
        )
        AND
        /* PO Details not set */
        (a.po_number IS NULL)
        

SELECT count(*) FROM corelist_dup
update corelist_dup set qty=1
CREATE TABLE corelist_dup AS SELECT * FROM corelist
drop TABLE corelist_dup
SELECT count(*) FROM corelist_bkp
select count(*) from corelist_dup

BEGIN
  FOR rec IN (
    select * from corelist
  )
  LOOP
    FOR cnt IN 1..rec.qty
    LOOP
      INSERT INTO corelist_dup
      values rec;
    END LOOP;
  END LOOP;
end;

alter table corelist add branch_id number;
ALTER TABLE corelist_dup ADD branch_id NUMBER;
SELECT * FROM branches WHERE CATEGORY IN ('P','S') and id < 34 and id not in (22,13,12,5,6,23,24,27,29,30)
select * from corelist_dup
BEGIN
  FOR rec IN 
    select * from corelist_dup;
  loop
    update corelist_dup set branch_id = 
  end loop;
end;

select * from suppliers order by id


BEGIN
  worklist_generator.pr_create_newentry_wl;
end;

BEGIN 
  generate_pos;
end;

BEGIN 
  refresh_po_master;
END;

SELECT count(*) FROM worklists
SELECT count(*) FROM workitems
SELECT * FROM worklists 
delete from worklists where id not in (select id from worklists_bkp)
delete from workitems

SELECT count(*) FROM pos
select * from pos order by rowid desc

SELECT C.GROUP_ID, A.BRANCH_ID, COUNT(*) FROM
PROCUREMENTITEMS A, ENRICHEDTITLES B, PUBLISHERS C
WHERE A.ENRICHEDTITLE_ID = B.ID
AND B.PUBLISHER_ID = C.ID
AND A.PO_NUMBER IS NULL
GROUP BY C.GROUP_ID, A.BRANCH_ID
ORDER BY C.GROUP_ID, A.BRANCH_ID

SELECT * FROM PUBLISHERS
WHERE ID IN (SELECT publisher_id FROM enrichedtitles WHERE ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL))
AND group_id IS NULL

SELECT * FROM enrichedtitles WHERE isbnvalid IS NULL
SELECT count(*) FROM enrichedtitles WHERE nvl(enriched,'N') = 'N'
and id in (select enrichedtitle_id from procurementitems where po_number is null)

select * from supplierdiscounts where discount is null

SELECT distinct c.ID, b.publishercode, b.publisher
FROM enrichedtitles A, corelist b, publishers c, procurementitems d
WHERE A.isbn = b.isbn
AND A.publisher_id = c.ID
AND A.ID = d.enrichedtitle_id
AND d.po_number IS NULL
AND c.group_id IS NULL
order by c.id

SELECT * FROM procurementitems WHERE enrichedtitle_id IN (
select id from enrichedtitles where publisher_id=10190)

SELECT * FROM procurementitems WHERE po_number='NENT/0437/20110413'
SELECT * FROM pos WHERE discount IS NULL
SELECT  FROM procurementitems WHERE po_number='NENT/0437/20110413'

SELECT a.supplier_id, d.publisher_id from procurementitems A, enrichedtitles b, pos c, publishers d, suppliers e
WHERE 
A.enrichedtitle_id = b.ID 
AND b.publisher_id = d.ID
AND c.supplier_id = e.ID
AND A.po_number = c.code
and c.publisher
and c.discount is null

code like 'NENT/0437/20110413%'

UPDATE PUBLISHERS SET GROUP_ID=62, PUBLISHERNAME='Random House UK' WHERE ID=10190;
UPDATE PUBLISHERS SET GROUP_ID=6, PUBLISHERNAME='Hachette' WHERE ID=10300;
UPDATE PUBLISHERS SET GROUP_ID=53, PUBLISHERNAME='Parragon' WHERE ID=10301;
UPDATE PUBLISHERS SET GROUP_ID=113, PUBLISHERNAME='Research Press' WHERE ID=10302;
UPDATE PUBLISHERS SET GROUP_ID=113, PUBLISHERNAME='Research Press' WHERE ID=10303;
UPDATE PUBLISHERS SET GROUP_ID=113, PUBLISHERNAME='Research Press' WHERE ID=10304;
UPDATE PUBLISHERS SET GROUP_ID=113, PUBLISHERNAME='Research Press' WHERE ID=10305;
UPDATE PUBLISHERS SET GROUP_ID=52, PUBLISHERNAME='Pan Macmillan' WHERE ID=10306;
UPDATE PUBLISHERS SET GROUP_ID=1141, PUBLISHERNAME='Cnbc' WHERE ID=10307;
UPDATE PUBLISHERS SET GROUP_ID=62, PUBLISHERNAME='Random House UK' WHERE ID=10308;
UPDATE PUBLISHERS SET GROUP_ID=62, PUBLISHERNAME='Random House UK' WHERE ID=10309;
UPDATE PUBLISHERS SET GROUP_ID=62, PUBLISHERNAME='Random House UK' WHERE ID=10310;
UPDATE PUBLISHERS SET GROUP_ID=6, PUBLISHERNAME='Hachette' WHERE ID=10311;
UPDATE PUBLISHERS SET GROUP_ID=62, PUBLISHERNAME='Random House UK' WHERE ID=10312;

INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10190,104,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10300,61,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10301,102,SYSDATE,SYSDATE);
insert into supplierdiscounts values (supplierdiscounts_seq.nextval, 10302,192,sysdate,sysdate);---
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10303,192,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10304,192,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10305,192,SYSDATE,SYSDATE);
insert into supplierdiscounts values (supplierdiscounts_seq.nextval, 10306,81,sysdate,sysdate);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10307,,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10308,104,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10309,104,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10310,104,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10311,61,SYSDATE,SYSDATE);
insert into supplierdiscounts values (supplierdiscounts_seq.nextval, 10312,104,sysdate,sysdate);

SELECT distinct group_id, publishername FROM publishers WHERE ID IN (SELECT publisher_id FROM enrichedtitles WHERE ID IN
(select enrichedtitle_id from procurementitems where po_number is null))

SELECT count(A.ID) FROM procurementitems A, enrichedtitles b
          WHERE
          A.enrichedtitle_id = b.ID
          AND
          /* ISBN and Supplier Details set */
          (
            b.isbn IS NOT NULL
            --AND b.title_id IS NOT NULL
            AND b.publisher_id IS NOT NULL
            --AND nvl(A.supplier_id,-1) = nvl(supplier.supplier_id,-1)
            AND A.branch_id IS NOT NULL
            --AND b.author IS NOT NULL
          )
          AND
          /* PO Details not set */
          (a.po_number IS NULL)
          
select * from corelist where author is null

UPDATE procurementitems SET supplier_id = 2 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id=4)) and po_number is null;
UPDATE procurementitems SET supplier_id = 104 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id=5)) AND po_number IS NULL;
UPDATE procurementitems SET supplier_id = 81 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id=6)) and po_number is null;
UPDATE procurementitems SET supplier_id = 81 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id=52)) AND po_number IS NULL;
UPDATE procurementitems SET supplier_id = 102 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id=53)) and po_number is null;
UPDATE procurementitems SET supplier_id = 83 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id=57)) AND po_number IS NULL;
UPDATE procurementitems SET supplier_id = 104 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id=62)) AND po_number IS NULL;
UPDATE procurementitems SET supplier_id = 192 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id=113)) AND po_number IS NULL;
update procurementitems set supplier_id = 164 where enrichedtitle_id in (select id from enrichedtitles where publisher_id in (select id from publishers where group_id=1141)) and po_number is null;

SELECT 5+11+227+52+25+15+141+12+5 FROM dual

SELECT * FROM supplierdiscounts WHERE supplier_id NOT IN (SELECT supplier_id FROM supplir
SELECT DISTINCT publisher_id FROM procurementitems WHERE supplier_id = 2 AND enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id NOT IN (SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=2))
SELECT DISTINCT publisher_id FROM enrichedtitles WHERE ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL AND supplier_id=2) AND publisher_id NOT IN (SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=2)
SELECT DISTINCT publisher_id FROM enrichedtitles WHERE ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL AND supplier_id=104) AND publisher_id NOT IN (SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=104)
SELECT DISTINCT publisher_id FROM enrichedtitles WHERE ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL AND supplier_id=81) AND publisher_id NOT IN (SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=81)
SELECT DISTINCT publisher_id FROM enrichedtitles WHERE ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL AND supplier_id=102) AND publisher_id NOT IN (SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=102)
SELECT DISTINCT publisher_id FROM enrichedtitles WHERE ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL AND supplier_id=83) AND publisher_id NOT IN (SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=83)
SELECT DISTINCT publisher_id FROM enrichedtitles WHERE ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL AND supplier_id=104) AND publisher_id NOT IN (SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=104)
SELECT DISTINCT publisher_id FROM enrichedtitles WHERE ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL AND supplier_id=192) AND publisher_id NOT IN (SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=192)
SELECT DISTINCT publisher_id FROM enrichedtitles WHERE ID IN (SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL AND supplier_id=164) AND publisher_id NOT IN (SELECT publisher_id FROM supplierdiscounts WHERE supplier_id=164)

INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10310,104,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10312,104,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10190,104,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10309,104,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10308,104,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10306,81,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10311,81,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10300,81,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10301,102,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10302,192,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10304,192,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10305,192,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10303,192,NULL,SYSDATE,SYSDATE);
INSERT INTO supplierdiscounts VALUES (supplierdiscounts_seq.nextval, 10307,164,NULL,SYSDATE,SYSDATE);

SELECT b.ID, b.group_id "Publisher ID", b.publishername, c.ID "Supplier ID", c.NAME 
FROM supplierdiscounts A, publishers b, suppliers c
WHERE A.publisher_id = b.ID
AND A.supplier_id = c.ID
order by b.id
and a.discount is null

SELECT * FROM supplierdiscounts
ALTER TABLE supplierdiscounts ADD bulkdiscount NUMBER;
UPDATE supplierdiscounts SET bulkdiscount=discount WHERE discount IS NOT NULL
update supplierdiscounts set discount=null

SELECT * FROM procurementitems WHERE po_number IS NULL AND supplier_id IS NULL
SELECT * FROM supplierdiscounts WHERE supplier_id NOT IN (SELECT ID FROM suppliers)
SELECT * FROM supplierprofile@jbclclink WHERE suppliercode IN (192,164)
SELECT * FROM suppliers
INSERT INTO suppliers (ID,NAME,CONTACT,PHONE,CITY,TYPEOFSHIPPING,DISCOUNT,CREDITPERIOD)
SELECT suppliercode, suppliername, suppliercontact, supplierphone, suppliercity, supplytype, discount, creditperiod
from supplierprofile@jbclclink
WHERE suppliercode IN (192,164)

