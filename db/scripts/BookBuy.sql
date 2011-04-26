--Links
CREATE DATABASE LINK LINK_OPAC
  CONNECT TO OPAC IDENTIFIED BY OPAC
  USING 'XE';
  
CREATE DATABASE LINK JBCLCLINK
  CONNECT TO JBPROD IDENTIFIED BY JBPROD
  USING 'XE';
  
--Views
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

--Sequence
CREATE SEQUENCE PONUMBER_SEQ MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOCYCLE;

--Tables
drop table authors;
create table authors as
SELECT authorid id, 
  trim(firstname || ' ' || lastname) NAME 
  from authorprofile@jbclclink;

drop table publishers;
create table publishers as
  select publishercode id, publishername name, publishercountry country 
  from publisherprofile@JBCLCLINK

drop table suppliers  
create table suppliers as
  SELECT * FROM supplierprofile@jbclclink --Table altered after creation
CREATE TABLE "BOOKBUY"."SUPPLIERS"
  (
    "ID"           NUMBER NOT NULL ENABLE,
    "NAME"         VARCHAR2(100 BYTE),
    "CONTACT"      VARCHAR2(100 BYTE),
    "PHONE"        VARCHAR2(100 BYTE),
    "CITY"         VARCHAR2(100 BYTE),
    "TYPE"         NUMBER,
    "DISCOUNT"     NUMBER,
    "CREDITPERIOD" NUMBER
  )
  
--SQL Statements--------------------------------------------------------------

--Cleanup Procurement
delete from procurementitems;
delete from enrichedtitles;
delete from enrichedtitle_versions;
delete from worklists;
DELETE FROM workitems;
DELETE FROM publishers;
delete from suppliers;
delete from supplierdiscounts;
commit;

--Counts
SELECT COUNT(*) from procurementitems;
SELECT COUNT(*) from enrichedtitles;
SELECT COUNT(*) FROM ENRICHEDTITLE_VERSIONS;
SELECT count(*) FROM worklists;
SELECT count(*) FROM workitems;
SELECT count(*) FROM publishers;
SELECT count(*) FROM suppliers;
SELECT count(*) FROM supplierdiscounts;

/* Procurement Items */
SELECT * FROM procurementitems
SELECT * FROM procurementitems WHERE enrichedtitle_id IS NULL
SELECT * FROM procurementitems WHERE ID=10720
select * from procurementitems where enrichedtitle_id not in (select id from enrichedtitles)
SELECT b.title, b.isbn, c.name "Author", d.name "Publisher" FROM procurementitems A, enrichedtitles b, authors c, publishers d
  WHERE A.enrichedtitle_id = b.ID and
  b.author_id = c.ID AND
  b.publisher_id = d.ID AND
  b.publisher_id not in (select publisher_id from supplierdiscounts)
select * from procurementitems where avl_quantity is not null
SELECT count(*) FROM procurementitems
SELECT * FROM procurementitems WHERE ID IN (SELECT ref_id FROM workitems WHERE  worklist_id = 10084)
SELECT supplier_id, name, count(*) FROM procurementitems A, suppliers b 
WHERE A.supplier_id = b.ID
group by supplier_id, name
DELETE from procurementitems

/* Enriched Titles */
SELECT * FROM enrichedtitles
SELECT * FROM enrichedtitles WHERE isbnvalid='Y'
select * from enrichedtitles where id=147802
SELECT * FROM enrichedtitles WHERE author_id NOT IN (SELECT ID FROM authors)
select * from enrichedtitles where publisher_id not in (select id from publishers)
SELECT * FROM enrichedtitles WHERE title_id=134411
SELECT * FROM enrichedtitles WHERE isbn LIKE '%55277%'
SELECT isbn,title_id FROM enrichedtitles WHERE title_id IS NOT NULL
update enrichedtitles set isbnvalid=null where isbnvalid='N'
SELECT count(*) FROM enrichedtitles
select count(*) from enrichedtitles where title_id is null
select count(*) from enriched_title_versions
DELETE FROM enriched_titles
update enrichedtitles set isbnvalid = null
select title_id, count(*) from enriched_titles group by title_id having count(*) > 1
select * from enrichedtitles where id in (select enrichedtitle_id from procurementitems)
  and author_id not in (select id from authors)
select * from enrichedtitles where id in (select enrichedtitle_id from procurementitems)
  AND publisher_id NOT IN (SELECT ID FROM publishers)
select * from enrichedtitles where id in (select enrichedtitle_id from procurementitems where id in (SELECT ref_id FROM workitems WHERE  worklist_id = 10084))
UPDATE enrichedtitles SET publisher_id=48 WHERE publisher_id=3117 AND title_id=173233
select * from enrichedtitles where publisher_id not in (select publisher_id from supplierdiscounts)
  
/* Authors */
select "AUTHORS".* from "AUTHORS"

/* Publishers */
SELECT * FROM publishers 
select count(*) from publishers 
select * from publishers where id=10260
SELECT * FROM publishers WHERE lower(NAME) LIKE '%unknown%'
select * from publisherprofile@jbclclink where publishercode=50
select "PUBLISHERS".* from "PUBLISHERS" where ("PUBLISHERS"."ID" = 3117) and rownum <= 1

/* SupplierDiscounts */
SELECT * FROM SupplierDiscounts
SELECT count(*) FROM SupplierDiscounts
SELECT publisher_id, supplier_id, discount FROM SupplierDiscounts ORDER BY publisher_id, supplier_id
SELECT a.publisher_id, c.code, c.publishername, a.supplier_id, b.name, a.discount FROM SupplierDiscounts A, suppliers b, publishers c
WHERE A.supplier_id = b.ID
and a.publisher_id = c.id
SELECT * FROM SupplierDiscounts WHERE publisher_id=690
select * from SupplierDiscounts where supplier_id=1

/* Suppliers */ 
SELECT * FROM Suppliers
SELECT * FROM Suppliers WHERE ID IN (1,116,1590)

SELECT * FROM Users

/* Worklist */
SELECT * FROM WORKLISTS
select worklist_id, count(*) from workitems group by worklist_id

/* Worklist Items */
select * from workitems
SELECT * FROM workitems WHERE  worklist_id = 10084
SELECT count(*) from workitems where worklist_id=10040

--Fresh Pull from IBTRS Table
select * from ibtrs@link_opac where title_id is null
SELECT * FROM ibtrs@link_opac
WHERE respondent_id=951 AND state = 'Assigned' 
and to_char(created_at, 'DD-MON-RR') = to_char(sysdate-5, 'DD-MON-RR') 

--Ashwath's query for IBT corrections
select MAX(b.id),COUNT(*),a.titleid,a.title,d.firstname||''||d.lastname as author,d.authorid,a.isbn_13,a.publisherid,c.publishername from titles a, opac.ibtrs  b, publisherprofile c,authorprofile d
where a.titleid = b.title_id
and c.publishercode (+) = a.publisherid and a.authorid=d.authorid(+) and trunc(created_at) = trunc(sysdate) - 1 and a.titleid not in (select title_id from opac.fixed_titles)
GROUP BY a.titleid,a.title,d.firstname||''||d.lastname ,d.authorid,a.isbn_13,a.publisherid,c.publishername ORDER BY 1

/* Publishers not mapped to Suppliers */
SELECT publishercode, publishername FROM PUBLISHERPROFILE@JBCLCLINK where publishercode in (
SELECT DISTINCT PUBLISHERID FROM TITLES@JBCLCLINK WHERE TITLEID IN (SELECT TITLE_ID FROM IBTRS@LINK_OPAC)
AND PUBLISHERID NOT IN (SELECT PUBLISHER_ID FROM SUPPLIERDISCOUNTS)
)

/* ISBN Not Enriched */
SELECT A.ID, A.enrichedtitle_id FROM procurementitems A, enrichedtitles b
      WHERE
      A.enrichedtitle_id = b.ID
      AND
      /* ISBN Details set */
      (nvl(b.isbnverified,'N') = 'N')

/* No Supplier set */
SELECT A.ID FROM PROCUREMENTITEMS A, ENRICHEDTITLES B
      where
      A.ENRICHEDTITLE_ID = B.ID
      AND
      /* ISBN Details set */
      (B.ISBN IS NOT NULL
      AND B.TITLE_ID IS NOT NULL
      AND B.PUBLISHER_ID IS NOT NULL
      AND B.AUTHOR_ID IS NOT NULL)
      AND
      /* Supplier Details not set */
      (supplier_id IS NULL
      OR avl_quantity IS NULL
      or avl_status is null)

/* No PO set */
SELECT A.ID FROM procurementitems A, enrichedtitles b
      WHERE
      A.enrichedtitle_id = b.ID
      AND
      /* ISBN and Supplier Details set */
      (b.isbn IS NOT NULL
      AND b.title_id IS NOT NULL
      AND b.publisher_id IS NOT NULL
      AND b.author_id IS NOT NULL
      AND supplier_id IS NOT NULL
      AND avl_status = 'Avl' 
      AND avl_quantity IS NOT NULL)
      AND
      /* PO Details not set */
      (po_number IS NULL)
--SQL Statements--------------------------------------------------------------

BEGIN
  GENERATE_POS;
END;

BEGIN
  WORKLIST_GENERATOR.pr_create_corelist_wl;
END;

BEGIN
  refresh_po_master;
end;

BEGIN
  FOR i IN (
    SELECT code FROM pos
    )
  loop
    extract_pos(i.code);
  end loop;
end;

BEGIN
  FOR i IN (
    SELECT code FROM pos
    )
  loop
    PUSH_PO_TO_FIN(i.code);
  END loop;
end;

SELECT * FROM NONBOOKPOMASTER@JBCLCLINK WHERE PONUMBER LIKE 'NSTR%'

SELECT * FROM budgetmaster@JBCLCLINK
  where orgunit = 1
  and suborgunit = 7
  AND expensetype = 110001
  and budgetdate = last_day(TO_DATE('18-06-11','DD-MM-YY'));

1	7	110001	31-05-11	1300000	2649756	3373550		6205

SELECT 
  SELECT DISTINCT B.WORKLIST_ID, D.GROUP_ID, D.PUBLISHERNAME, branch_id, currency
    FROM procurementitems A, workitems b, ENRICHEDTITLES C, PUBLISHERS D
    WHERE A.ID = b.ref_id
    AND A.ENRICHEDTITLE_ID = C.ID
    AND C.PUBLISHER_ID = D.ID
    
      SELECT DISTINCT B.WORKLIST_ID, a.supplier_id
    FROM procurementitems A, workitems b
    WHERE A.ID = b.ref_id
    
    10035, 10039, 10052, 10055
    
SELECT A.ID, C.PO_NUMBER, COUNT(*) FROM WORKLISTS A, WORKITEMS B, PROCUREMENTITEMS C
WHERE A.ID = B.WORKLIST_ID
AND B.REF_ID = C.ID 
AND B.WORKLIST_ID BETWEEN 10110 AND 10134
GROUP BY A.ID, C.PO_NUMBER

10060 - 10084
10085 - 10109
10110 - 10134

update procurementitems set branch_id=42 where id in (select ref_id from workitems where worklist_id between 10110 and 10134)
SELECT LPAD(TO_CHAR(1),4,'0') FROM DUAL

SELECT COUNT(*) FROM PROCUREMENTITEMS WHERE PO_NUMBER IS NULL

SELECT WORKLIST_ID, COUNT(*) FROM WORKITEMS WHERE REF_ID IN 
(SELECT ID FROM PROCUREMENTITEMS WHERE PO_NUMBER IS NULL) GROUP BY WORKLIST_ID

SELECT * FROM WORKLISTS WHERE ID IN (SELECT WORKLIST_ID
select * from pos order by branch_id, code

create or replace FUNCTION get_pub_name(pi_pub_id) RETURN VARCHAR2 AS
  l_name VARCHAR2(50);
 BEGIN
  SELECT lower(substr(trim(REPLACE(publisherNAME,' ','_')),1,10)) INTO l_name 
  FROM publishers WHERE group_id = pi_pub_id AND ROWNUM <2;
  RETURN l_name;
  END;
  
  
INSERT INTO PROCUREMENTITEMS (SOURCE, SOURCE_ID, ENRICHEDTITLE_ID, 
UPDATE PROCUREMENTITEMS SET BRANCH_ID=39 WHERE BRANCH_ID=4


INSERT INTO PROCUREMENTITEMS 
SELECT PROCUREMENTITEMS_SEQ.NEXTVAL, SOURCE, SOURCE_ID, ENRICHEDTITLE_ID, ISBN, STATUS, NULL, NULL, NULL, 
NULL, SYSDATE, SUPPLIER_ID, NULL, NULL, NULL, 40, SYSDATE,SYSDATE,QUANTITY FROM PROCUREMENTITEMS
WHERE ID 
IN (SELECT REF_ID FROM WORKITEMS WHERE WORKLIST_ID BETWEEN 10028 AND 10059)

SELECT COUNT(*)/2 FROM PROCUREMENTITEMS

SELECT * FROM pos
delete from pos

update supplierdiscounts set discount = 	40	 where publisher_id=	10002	 and supplier_id = 	1459	;

SELECT group_id FROM pubishers WHERE publisher_id IN 
SELECT publisher_id FROM enrichedtitles WHERE ID IN 
SELECT enrichedtitle_id FROM procurementitems IN
select ref_id from work


select * from pos
alter table pos add publisher_id number;

DECLARE
l_pub_id integer;
BEGIN
FOR i IN ( SELECT * FROM pos ) loop
 SELECT c.group_id into l_pub_id FROM procurementitems A, enrichedtitles b, publishers c 
 WHERE po_number = i.code 
 AND A.enrichedtitle_id= b.ID 
 and b.publisher_id= c.id
 AND ROWNUM < 2;
 UPDATE pos SET publisher_id = l_pub_id WHERE code = i.code AND publisher_id IS NULL;
 IF (SQL%rowcount != 1) THEN
  raise_application_error(-20000,'error');
END IF;
END loop;

end;

SELECT A.SUPPLIER_ID, B.GROUP_ID, COUNT(*)
    FROM SUPPLIERDISCOUNTS A, PUBLISHERS B, SUPPLIERS C
    WHERE A.PUBLISHER_ID = B.ID
    AND A.SUPPLIER_ID = C.ID
    GROUP BY A.SUPPLIER_ID, B.GROUP_ID
    
    AND A.SUPPLIER_ID = REC.SUPPLIER_ID
    AND B.GROUP_ID = REC.PUBLISHER_ID;
    
SELECT * FROM pos WHERE branch_id=39

CREATE TABLE corelist_bkp AS SELECT * FROM corelist
select count(*) from corelist_bkp

SELECT count(*)/4 FROM procurementitems WHERE po_number IS NULL
create table procurementitemes_bkp2 as select * from procurementitems
SELECT count(*) FROM procurementitems_bkp

SELECT count(*) FROM enrichedtitles_bkp
DROP TABLE enrichedtitles_bkp
create table enrichedtitles_bkp as select * from enrichedtitles

SELECT count(*) FROM workitems
TRUNCATE TABLE workitems_bkp
select count(*) from workitems_bkp

SELECT count(*) FROM worklists
TRUNCATE TABLE worklists_bkp
insert into worklists_bkp select * from worklists
select count(*) from worklists_bkp

CREATE TABLE publishers_bkp AS SELECT * FROM publishers
create table suppliers_bkp as select * from suppliers

DELETE FROM pos WHERE code LIKE 'NENT%'
update procurementitems set po_number = null where po_number LIKE 'NENT%'

SELECT * FROM publishers WHERE lower(publishername) LIKE '%research%'
select * from publisherprofile@jbclclink  WHERE lower(publishername) LIKE '%tree%'