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
delete from publishers;
commit;

--Counts
SELECT COUNT(*) from procurementitems;
SELECT COUNT(*) from enrichedtitles;
SELECT COUNT(*) FROM ENRICHEDTITLE_VERSIONS;
SELECT count(*) FROM worklists;
SELECT count(*) FROM workitems;
select count(*) from publishers;

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
select * from procurementitems where id in (SELECT ref_id FROM workitems WHERE  worklist_id = 10084)
DELETE from procurementitems

/* Enriched Titles */
SELECT * FROM enrichedtitles
SELECT * FROM enrichedtitles WHERE isbnvalid='Y'
select * from enrichedtitles where id=10720
SELECT * FROM enrichedtitles WHERE author_id NOT IN (SELECT ID FROM authors)
select * from enrichedtitles where publisher_id not in (select id from publishers)
SELECT * FROM enrichedtitles WHERE title_id=134411
SELECT * FROM enrichedtitles WHERE isbn LIKE '%55277%'
SELECT * FROM enrichedtitles WHERE title_id IS NOT NULL
update enrichedtitles set isbnvalid=null where isbnvalid='N'
select count(*) from enrichedtitles
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
SELECT publisher_id, supplier_id, discount FROM SupplierDiscounts order by publisher_id, supplier_id
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