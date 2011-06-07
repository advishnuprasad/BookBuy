ALTER TABLE "POS" ADD ( "CURRENCY" VARCHAR2(1020) );
ALTER TABLE "POS" ADD ( "PROCUREMENT_ID" NUMBER (38,0) );

--------------------------------------------------------
--  DDL for Table PROCUREMENTS
--------------------------------------------------------

CREATE TABLE "PROCUREMENTS" 
   (	"ID" NUMBER(38,0), 
	"SOURCE_ID" NUMBER(38,0), 
	"DESCRIPTION" VARCHAR2(255 CHAR), 
	"REQUESTS_CNT" NUMBER(38,0), 
	"CREATED_BY" NUMBER(38,0), 
	"MODIFIED_BY" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE, 
	"STATUS" VARCHAR2(255 CHAR)
   ) ;
 
alter table "PROCUREMENTITEMS" add ( "AVAILABILITY" VARCHAR2(1020) );
alter table "PROCUREMENTITEMS" add ( "TITLE_ID" NUMBER (38,0) );
alter table "PROCUREMENTITEMS" add ( "PROCUREMENT_ID" NUMBER (38,0) );

--------------------------------------------------------
--  Constraints for Table PROCUREMENTS
--------------------------------------------------------

ALTER TABLE "PROCUREMENTS" MODIFY ("ID" NOT NULL ENABLE);
 
ALTER TABLE "PROCUREMENTS" ADD PRIMARY KEY ("ID") ENABLE;
 
--------------------------------------------------------
--  DDL for Sequence PROCUREMENTS_SEQ
--------------------------------------------------------
CREATE SEQUENCE  "PROCUREMENTS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10060 CACHE 20 NOORDER  NOCYCLE ;

alter table "WORKLISTS" add ( "PROCUREMENT_ID" NUMBER (38,0) );

--------------------------------------------------------
--  DDL for View AUTHORS
--------------------------------------------------------

CREATE OR REPLACE VIEW "AUTHORS" ("ID", "NAME", "FIRSTNAME", "MIDDLENAME", "LASTNAME") AS 
  SELECT authorid id,
    firstname
    || ' '
    || middlename
    || ' '
    || lastname name,
    firstname firstname,
    middlename middlename,
    lastname lastname
  FROM authorprofile@jbclclink
WITH read only;
 
--------------------------------------------------------
--  DDL for View BOOKS_OF_BRANCH_IN_CORELIST
--------------------------------------------------------

CREATE OR REPLACE VIEW "BOOKS_OF_BRANCH_IN_CORELIST" ("ISBN", "TITLE", "AUTHOR", "PUBLISHER", "PUBLISHERCODE", "PRICE", "CURRENCY", "CATEGORY", "SUBCATEGORY", "QTY", "ID", "KEY_ID") AS 
  SELECT c."ISBN",
    c."TITLE",
    c."AUTHOR",
    c."PUBLISHER",
    c."PUBLISHERCODE",
    c."PRICE",
    c."CURRENCY",
    c."CATEGORY",
    c."SUBCATEGORY",
    c."QTY",
    c."ID",
    c."KEY_ID"
  FROM enrichedtitles A,
    titles@link_hyd b,
    corelist c
  WHERE A.title_id = b.titleid
  AND A.isbn       = c.isbn
  AND c.key_id     = 3
  AND A.isbn      IN
    (SELECT isbn FROM corelist WHERE key_id = 3
    )
  AND b.titleid IN
    (SELECT DISTINCT titleid
    FROM books@link_hyd
    WHERE LOCATION  =21
    AND origlocation=21
    )
  AND a.title_id IS NOT NULL
 ;
 
--------------------------------------------------------
--  DDL for View BRANCHES
--------------------------------------------------------

  CREATE OR REPLACE VIEW "BRANCHES" ("ID", "NAME", "ADDRESS", "CITY", "PHONE", "EMAIL", "CATEGORY", "PARENT_ID", "PARENT_NAME", "CARD_ID") AS 
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
WITH read only
 ;

--------------------------------------------------------
--  DDL for View CATEGORIES
--------------------------------------------------------

  CREATE OR REPLACE VIEW "CATEGORIES" ("ID", "NAME", "DIVISION") AS 
  SELECT categorycode id,
    categoryname name,
    categorytype division
  FROM CATEGORY@jbclclink
WITH READ ONLY;

--------------------------------------------------------
--  DDL for View DISCOUNTS_TO_BE_FILLED
--------------------------------------------------------

  CREATE OR REPLACE VIEW "DISCOUNTS_TO_BE_FILLED" ("SUPPLIER_ID", "NAME", "PUBLISHER_ID", "GROUP_ID", "PUBLISHERNAME", "KEY_ID") AS 
  SELECT DISTINCT A.supplier_id,
    d.NAME,
    b.publisher_id,
    c.group_id,
    c.publishername,
    f.key_id
  FROM procurementitems A,
    enrichedtitles b,
    publishers c,
    suppliers d,
    supplierdiscounts e,
    corelist f
  WHERE A.enrichedtitle_id = b.ID
  AND b.publisher_id       = c.ID
  AND A.supplier_id        = d.ID
  and a.isbn = f.isbn  
  AND c.ID        = e.publisher_id
  AND d.ID        = e.supplier_id
  AND e.discount IS NULL
 ;
 

--------------------------------------------------------
--  DDL for View DISCOUNTS_TO_BE_INSERTED
--------------------------------------------------------

  CREATE OR REPLACE VIEW "DISCOUNTS_TO_BE_INSERTED" ("SUPPLIER_ID", "NAME", "PUBLISHER_ID", "GROUP_ID", "PUBLISHERNAME", "KEY_ID") AS 
  SELECT DISTINCT a.supplier_id,
    d.name,
    b.publisher_id,
    c.group_id,
    c.publishername,
    e.key_id
  FROM procurementitems A,
    enrichedtitles b,
    publishers c,
    suppliers d,
    corelist e
  WHERE A.enrichedtitle_id = b.ID
  AND b.publisher_id       = c.ID
  AND A.supplier_id        = d.ID
  and a.isbn = e.isbn
  AND b.publisher_id
    || '-'
    || A.supplier_id NOT IN
    (SELECT publisher_id || '-' || supplier_id FROM supplierdiscounts
    )
 ;
 

--------------------------------------------------------
--  DDL for View EXCESS_ITEMS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "EXCESS_ITEMS" ("PO_NO", "SUPPLIER_ID", "ISBN", "INVOICE_NO", "TITLE", "ORDERED", "RECEIVED") AS 
  SELECT a.po_no,
    b.supplier_id,
    A.isbn,
    a.invoice_no,
    c.title,
    b.quantity    AS ordered,
    COUNT(A.isbn) AS received
  FROM titlereceipts A,
    procurementitems b,
    enrichedtitles c
  WHERE A.isbn           = b.isbn
  AND A.po_no            = b.po_number
  AND b.enrichedtitle_id = c.ID
  GROUP BY a.po_no, b.supplier_id, A.isbn, a.invoice_no, c.title, b.quantity
  HAVING COUNT(*) > b.quantity
 ;
 

--------------------------------------------------------
--  DDL for View ISBNS_OF_A_LIST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "ISBNS_OF_A_LIST" ("ID", "TITLE_ID", "TITLE", "PUBLISHER_ID", "ISBN", "LANGUAGE", "CATEGORY", "SUBCATEGORY", "ISBN10", "CREATED_AT", "UPDATED_AT", "VERSION", "VERIFIED", "AUTHOR", "ISBNVALID", "LISTPRICE", "CURRENCY", "ENRICHED") AS 
  SELECT "ID",
    "TITLE_ID",
    "TITLE",
    "PUBLISHER_ID",
    "ISBN",
    "LANGUAGE",
    "CATEGORY",
    "SUBCATEGORY",
    "ISBN10",
    "CREATED_AT",
    "UPDATED_AT",
    "VERSION",
    "VERIFIED",
    "AUTHOR",
    "ISBNVALID",
    "LISTPRICE",
    "CURRENCY",
    "ENRICHED"
  FROM ENRICHEDTITLES
  WHERE ISBN IN
    (SELECT ISBN
    FROM PROCUREMENTITEMS
    WHERE ISBN IN
      (SELECT ISBN FROM NEWARRIVALS_EXPANDED WHERE KEY_ID=7
      )
    )
 ;
 

--------------------------------------------------------
--  DDL for View ISBN_VALIDITY_IN_LIST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "ISBN_VALIDITY_IN_LIST" ("ISBNVALID", "CNT") AS 
  SELECT ISBNVALID,
    COUNT(*) AS CNT
  FROM ENRICHEDTITLES
  WHERE ISBN IN
    (SELECT ISBN
    FROM PROCUREMENTITEMS
    WHERE ISBN IN
      (SELECT ISBN FROM NEWARRIVALS_EXPANDED WHERE KEY_ID=8
      )
    )
  GROUP BY ISBNVALID
 ;
 

--------------------------------------------------------
--  DDL for View ISBN_VALIDITY_IN_LIST_IN_CL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "ISBN_VALIDITY_IN_LIST_IN_CL" ("ISBNVALID", "CNT") AS 
  SELECT ISBNVALID,
    COUNT(*) AS CNT
  FROM ENRICHEDTITLES
  WHERE ISBN IN
    (SELECT ISBN
    FROM PROCUREMENTITEMS
    WHERE ISBN IN
      (SELECT ISBN FROM CORELIST WHERE KEY_ID=5
      )
    )
  GROUP BY ISBNVALID
 ;
 

--------------------------------------------------------
--  DDL for View NEW_STORE_INVENTORIES
--------------------------------------------------------

  CREATE OR REPLACE VIEW "NEW_STORE_INVENTORIES" ("branch_id", "name", "invoice_qty", "received", "cataloged") AS 
  SELECT DISTINCT A.branch_id,
    b.name,
    (SELECT SUM(quantity)
    FROM invoices
    WHERE po_id IN
      (SELECT id FROM pos WHERE branch_id = A.branch_id
      )
    ) AS "invoice_qty",
    (SELECT COUNT(*)
    FROM titlereceipts
    WHERE po_no IN
      (SELECT code FROM pos WHERE branch_id = A.branch_id
      )
    ) AS "received",
    (SELECT COUNT(*)
    FROM bookreceipts
    WHERE po_no IN
      (SELECT code FROM pos WHERE branch_id = A.branch_id
      )
    ) AS "cataloged"
  FROM procurementitems A,
    branches b
  WHERE A.branch_id = b.ID
  AND branch_ID BETWEEN 39 AND 43
 ;
 

--------------------------------------------------------
--  DDL for View NEXT_PUSH_BOOKS_TIME
--------------------------------------------------------

  CREATE OR REPLACE VIEW "NEXT_PUSH_BOOKS_TIME" ("SYSDATE", "INTERVAL_DATE") AS 
  SELECT sysdate,
    CASE
      WHEN ( TO_CHAR(SYSDATE, 'HH24') BETWEEN 6 AND 17
      AND TO_CHAR(SYSDATE, 'DY') NOT      IN ('SAT','SUN') )
      THEN TRUNC(sysdate)                  + (TRUNC(TO_CHAR(sysdate,'sssss')/900)+1)*15/24/60
      WHEN (TO_CHAR(sysdate, 'DY') NOT    IN ('FRI','SAT','SUN'))
      THEN TRUNC(sysdate)                  +1+6/24
      ELSE next_day(TRUNC(sysdate), 'Mon') + 6/24
    END interval_date
  FROM dual
 ;
 

--------------------------------------------------------
--  DDL for View POS_BRANCHWISE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "POS_BRANCHWISE" ("PO NUMBER", "SUPPLIER", "STORE", "QUANTITY", "MRP", "DISCOUNT", "NET") AS 
  SELECT CODE "PO NUMBER", C.NAME "SUPPLIER", B.NAME "STORE", A.COPIES_CNT "QUANTITY", A.GROSSAMT "MRP", A.DISCOUNT, A.NETAMT "NET" FROM POS A ,BRANCHES B, SUPPLIERS C
WHERE A.BRANCH_ID = B.ID
AND A.SUPPLIER_ID = C.ID
ORDER BY A.ID
 ;
 

--------------------------------------------------------
--  DDL for View PO_VIEW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "PO_VIEW" ("PO_NO", "WORKLIST_ID", "TITLE", "ISBN", "AUTHOR", "PUBLISHERNAME", "SUPPLIER", "SUPPLIER_ID", "QUANTITY", "LISTPRICE", "CURRENCY", "CONV_RATE", "INRPRICE", "DISCOUNT", "COSTPRICE", "TITLE_ID", "BRANCH_ID", "CREATED_AT") AS 
  SELECT a.po_number,
    0,--b.worklist_id,
    d.title,
    d.isbn,
    d.author,
    e.publishername,
    f.NAME,
    f.id,
    A.quantity,
    d.listprice,
    d.currency,
    DECODE(d.currency,'USD',47.90,'GBP',77.50,'EUR',65.70,1),
    d.listprice * DECODE(d.currency,'USD',47.90,'GBP',77.50,'EUR',65.70,1),
    g.discount,
    ROUND(g.discount * d.listprice * DECODE(d.currency,'USD',47.90,'GBP',77.50,'EUR',65.70,1)/100,2),
    d.title_id,
    A.BRANCH_ID,
    A.CREATED_AT
  FROM procurementitems A,
    --workitems b,
    enrichedtitles d,
    publishers e,
    suppliers f,
    supplierdiscounts g
  WHERE --A.ID             = b.ref_id
  --AND
  A.enrichedtitle_id = d.ID
  AND d.publisher_id     = e.ID
  AND a.po_number       IS NOT NULL
  AND A.supplier_id      = f.ID
  AND g.supplier_id      = f.id
  AND g.publisher_id     = e.ID

 ;
 

--------------------------------------------------------
--  DDL for View PUBLISHERS_TO_BE_UPDATED
--------------------------------------------------------

  CREATE OR REPLACE VIEW "PUBLISHERS_TO_BE_UPDATED" ("SQL") AS 
  SELECT DISTINCT 'update publishers set group_id = '
    || a.publishercode
    || ', publishername = '''
    || a.publisher
    || ''' where id = '
    || b.publisher_id
    || ';' AS SQL
  FROM newarrivals_expanded A,
    enrichedtitles b,
    publishers c
  WHERE A.isbn       = b.isbn
  AND b.publisher_id = c.ID
  AND c.group_id    IS NULL
 ;
 

--------------------------------------------------------
--  DDL for View PUBLISHERS_TO_BE_UPDATED_IN_CL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "PUBLISHERS_TO_BE_UPDATED_IN_CL" ("SQL") AS 
  SELECT DISTINCT 'update publishers set group_id = '
    || a.publishercode
    || ', publishername = '''
    || a.publisher
    || ''' where id = '
    || b.publisher_id
    || ';' AS SQL
  FROM corelist A,
    enrichedtitles b,
    publishers c
  WHERE (A.isbn = b.isbn OR a.isbn = b.isbn10)
  AND b.publisher_id = c.ID
  AND c.group_id    IS NULL
 ;
 

--------------------------------------------------------
--  DDL for View SUPPLIERS_TO_BE_UPDATED
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SUPPLIERS_TO_BE_UPDATED" ("GROUP_ID", "PUBLISHERNAME", "KEY_ID") AS 
  SELECT DISTINCT C.GROUP_ID,
    C.PUBLISHERNAME,
    D.KEY_ID
  FROM PROCUREMENTITEMS A,
    ENRICHEDTITLES B,
    PUBLISHERS C,
    CORELIST D
  WHERE A.ENRICHEDTITLE_ID = B.ID
  AND B.PUBLISHER_ID       = C.ID
  AND (B.ISBN               = D.ISBN OR B.ISBN10 = D.ISBN)
  AND a.supplier_id       IS NULL
 ;
 

--------------------------------------------------------
--  DDL for View SUPPLIERS_TO_BE_UPDATED_IN_NEW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SUPPLIERS_TO_BE_UPDATED_IN_NEW" ("GROUP_ID", "PUBLISHERNAME", "KEY_ID") AS 
  SELECT DISTINCT C.GROUP_ID,
    C.PUBLISHERNAME,
    D.KEY_ID
  FROM PROCUREMENTITEMS A,
    ENRICHEDTITLES B,
    PUBLISHERS C,
    newarrivals_expanded D
  WHERE A.ENRICHEDTITLE_ID = B.ID
  AND B.PUBLISHER_ID       = C.ID
  AND (B.ISBN              = D.ISBN
  OR B.ISBN10              = D.ISBN)
  AND a.supplier_id       IS NULL
 ;
 

--------------------------------------------------------
--  DDL for View TITLES
--------------------------------------------------------

  CREATE OR REPLACE VIEW "TITLES" ("ID", "TITLE", "AUTHOR_ID", "PUBLISHER_ID", "YEAROFPUBLICATION", "EDITION", "CATEGORY_ID", "ISBN10", "ISBN13", "NOOFPAGES", "LANGUAGE", "CNT_RATED", "RATING", "NO_OF_RENTED", "TITLE_TYPE") AS 
  SELECT titleid id,
    title title,
    authorid author_id,
    NVL(publisherid,50) publisher_id,
    yearofpublication yearofpublication,
    edition edition,
    category category_id,
    isbn_10 isbn10,
    isbn_13 isbn13,
    no_of_pages noofpages,
    language language,
    nooftimesrated cnt_rated,
    bookrating rating,
    no_of_rented,
    titletype title_type
  FROM titles@jbclclink
WITH read only;
 

--------------------------------------------------------
--  DDL for Function FN_PUSH_BOOKS_TO_INV
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "FN_PUSH_BOOKS_TO_INV" RETURN PLS_INTEGER AS
  V_BOOK BOOKS@JBCLCLINK%ROWTYPE;
  POVIEW PO_VIEW%ROWTYPE;
  I      PLS_INTEGER := 0;
  V_ERRMSG VARCHAR2(255);
BEGIN
  FOR REC IN (SELECT *
              FROM BOOKRECEIPTS
              WHERE TO_NUMBER(SUBSTR(BOOK_NO,2)) NOT IN (
                SELECT TO_NUMBER(SUBSTR(BOOK_NO,2)) FROM BOOK_MIG_LOG
                MINUS
                SELECT BOOKNUMBER FROM BOOKS@JBCLCLINK
              )) 
  LOOP
    BEGIN
      SELECT *
        INTO POVIEW
        FROM PO_VIEW
       WHERE PO_NO = REC.PO_NO
         AND ISBN = REC.ISBN
         AND ROWNUM < 2;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        INSERT INTO BOOK_MIG_LOG
          (BOOK_NO, BRANCH_ID, CREATED_AT, STATUS, MSG)
        VALUES
          (REC.BOOK_NO, V_BOOK.ORIGLOCATION, SYSDATE, 'E', 'NO DATA IN POVIEW');
    END;
  
    V_BOOK                  := NULL;
    V_BOOK.TITLEID          := REC.TITLE_ID;
    V_BOOK.BOOKNUMBER       := SUBSTR(REC.BOOK_NO, 2);
    V_BOOK.SUPPLIERID       := POVIEW.SUPPLIER_ID;
    V_BOOK.MRP_COST         := POVIEW.LISTPRICE;
    V_BOOK.JB_COST          := POVIEW.COSTPRICE;
    V_BOOK.DATE_OF_PURCHASE := POVIEW.CREATED_AT;
    V_BOOK.STATUS           := 'P';
    V_BOOK.LOCATION         := POVIEW.BRANCH_ID;
    V_BOOK.ORIGLOCATION     := POVIEW.BRANCH_ID;
    V_BOOK.USERID           := 'AMS';
    V_BOOK.TIMES_RENTED     := 0;
  
    BEGIN
      INSERT INTO BOOKS@JBCLCLINK VALUES V_BOOK;
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        INSERT INTO BOOK_MIG_LOG
          (BOOK_NO, BRANCH_ID, CREATED_AT, STATUS, MSG)
        VALUES
          (REC.BOOK_NO, V_BOOK.ORIGLOCATION, SYSDATE, 'E', 'UNIQUE INDX ERR');
      WHEN OTHERS THEN
        V_ERRMSG := SUBSTR(SQLERRM,1,200);
        INSERT INTO BOOK_MIG_LOG
          (BOOK_NO, BRANCH_ID, CREATED_AT, STATUS, MSG)
        VALUES
          (REC.BOOK_NO, V_BOOK.ORIGLOCATION, SYSDATE, 'E', 'OTHERS - ' || V_ERRMSG);
    END;
  
    INSERT INTO BOOK_MIG_LOG
      (BOOK_NO, BRANCH_ID, CREATED_AT, STATUS, MSG)
    VALUES
      (REC.BOOK_NO, V_BOOK.ORIGLOCATION, SYSDATE, 'Y', 'DONE');
  
    I := I + 1;
  END LOOP;
  RETURN I;
END FN_PUSH_BOOKS_TO_INV;
/
 

--------------------------------------------------------
--  DDL for Function FN_PUSH_NEW_TITLES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "FN_PUSH_NEW_TITLES" RETURN NUMBER AS
  v_titles          titles@JBCLCLINK%ROWTYPE;
  v_title_id        NUMBER;
  v_auth_id         NUMBER;
  I                 PLS_INTEGER := 0;
BEGIN
  FOR REC IN
  ( 
    SELECT  *
    FROM enrichedtitles
    WHERE title_id IS NULL
  )
  LOOP
    v_title_id := NULL;
    v_auth_id := NULL;
    
    BEGIN
      SELECT AUTHORID INTO V_AUTH_ID FROM AUTHORPROFILE@JBCLCLINK
      WHERE LOWER(FIRSTNAME) = LOWER(REC.AUTHOR) AND ROWNUM=1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT SEQ_AUTHPROFILE.nextval@JBCLCLINK INTO v_auth_id FROM dual;
        BEGIN
          INSERT INTO AUTHORPROFILE@JBCLCLINK (AUTHORID, FIRSTNAME)
          VALUES (V_AUTH_ID, rec.author);
        EXCEPTION
          WHEN OTHERS THEN
            INSERT INTO TITLE_MIG_LOG
            (TITLE_ID, CREATED_AT, STATUS, MSG)
            VALUES
            (V_TITLE_ID, SYSDATE, 'E', 'AUTHOR CREATION - UNIQUE INDX ERR');
        END;
    END;

    SELECT seq_titles.nextval@JBCLCLINK INTO v_title_id FROM dual;
    
    v_titles                      := null;
    v_titles.titleid              := v_title_id;
    v_titles.title                := rec.title;
    v_titles.authorid             := v_auth_id;
    v_titles.publisherid          := rec.publisher_id;
    v_titles.isbn_10              := rec.isbn10;
    v_titles.isbn_13              := rec.isbn;
    v_titles.language             := rec.language;
    v_titles.titletype            := 'B';
    v_titles.insertdate           := sysdate;
    v_titles.userid               := 'AMS';

    BEGIN
      INSERT INTO titles@JBCLCLINK VALUES v_titles;
    EXCEPTION
      WHEN OTHERS THEN
        INSERT INTO TITLE_MIG_LOG
        (TITLE_ID, CREATED_AT, STATUS, MSG)
        VALUES
        (V_TITLE_ID, SYSDATE, 'E', 'UNIQUE INDX ERR');
    END;
    
    UPDATE ENRICHEDTITLES SET TITLE_ID = V_TITLE_ID WHERE ID = rec.ID;
    
    INSERT INTO TITLE_MIG_LOG
      (TITLE_ID, CREATED_AT, STATUS, MSG)
    VALUES
      (V_TITLE_ID, SYSDATE, 'Y', 'DONE');
      
    I := I + 1;
  END LOOP;
  RETURN I;
END FN_PUSH_NEW_TITLES;
/
 

--------------------------------------------------------
--  DDL for Function GET_PUB_NAME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "GET_PUB_NAME" (pi_pub_id integer) RETURN VARCHAR2 AS
  l_name VARCHAR2(50);
 BEGIN
  SELECT lower(substr(trim(REPLACE(publisherNAME,' ','_')),1,10)) INTO l_name 
  FROM publishers WHERE group_id = pi_pub_id AND ROWNUM <2;
  RETURN l_name;
  END;
 /
 

--------------------------------------------------------
--  DDL for Package DATA_PULL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "DATA_PULL" AS
  PROCEDURE pr_pull_ibtr_items;
  FUNCTION pull_ibtr_items(p_procurement_id NUMBER) RETURN NUMBER;
  FUNCTION get_ibtr_items_count RETURN NUMBER;
  PROCEDURE pr_init_data_pull;
  PROCEDURE pr_pull_corelist_items (p_key_id number);
  PROCEDURE pr_pull_newarrival_items (p_key_id number);
END data_pull;
/
 

--------------------------------------------------------
--  DDL for Package PO_GENERATOR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PO_GENERATOR" AS 
  FUNCTION generate(p_procurement_id IN NUMBER, p_type IN VARCHAR2) RETURN NUMBER;
  FUNCTION extract(p_po_number IN VARCHAR2) RETURN VARCHAR2;
END PO_GENERATOR;
/
 

--------------------------------------------------------
--  DDL for Package WORKLIST_GENERATOR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "WORKLIST_GENERATOR" AS
  PROCEDURE generate_ibtr_wl(p_procurement_id NUMBER);
  PROCEDURE regenerate_ibtr_wl(p_procurement_id NUMBER);
  PROCEDURE pr_create_corelist_wl(p_procurement_id NUMBER);
  PROCEDURE pr_create_newentry_wl(p_procurement_id NUMBER);
END WORKLIST_GENERATOR;
/
 

--------------------------------------------------------
--  DDL for Package Body DATA_PULL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "DATA_PULL" 
AS
  /* Master Values */
  v_procurement_branch_id   NUMBER        := 951;
  v_procurement_pull_status VARCHAR2(255) := 'Assigned';
  v_days_before             NUMBER        := 8;
  
  FUNCTION get_ibtr_items_count RETURN NUMBER
  AS
  v_cnt NUMBER;
  BEGIN
    SELECT count(*) into v_cnt
      FROM ibtrs@link_opac
      WHERE respondent_id                  = v_procurement_branch_id
      AND state                            = v_procurement_pull_status
      AND to_char(created_at, 'DD-MON-RR') = to_char(SYSDATE-v_days_before, 'DD-MON-RR');
    RETURN v_cnt;
  END get_ibtr_items_count;
  
  FUNCTION pull_ibtr_items(p_procurement_id NUMBER) RETURN NUMBER 
  AS
    v_procurement_item procurementitems%rowtype;
    v_enriched_title enrichedtitles%rowtype;
    v_enriched_title_version enrichedtitle_versions%rowtype;
    v_author_clc authorprofile@jbclclink%rowtype;
    v_title titles.title@jbclclink%TYPE;
    v_titleid titles.titleid@jbclclink%TYPE;
    v_authorid titles.authorid@jbclclink%TYPE;
    v_isbn_10 titles.isbn_10@jbclclink%TYPE;
    v_isbn_13 titles.isbn_13@jbclclink%TYPE;
    v_language titles.language@jbclclink%TYPE;
    v_category titles.CATEGORY@jbclclink%TYPE;
    v_authorname enrichedtitles.author%TYPE;
    v_procurement_item_id       NUMBER;
    v_enriched_title_id         NUMBER;
    v_enriched_title_version_id NUMBER;
    l_count                     NUMBER := 0;
    v_cnt                       NUMBER := 0;
  BEGIN
    FOR rec IN
    (SELECT *
    FROM ibtrs@link_opac
    WHERE respondent_id                  = v_procurement_branch_id
    AND state                            = v_procurement_pull_status
    AND to_char(created_at, 'DD-MON-RR') = to_char(SYSDATE-v_days_before, 'DD-MON-RR')
    )
    loop
      SELECT titleid,
        title,
        authorid,
        isbn_10,
        isbn_13,
        language,
        CATEGORY
      INTO v_titleid,
        v_title,
        v_authorid,
        v_isbn_10,
        v_isbn_13,
        v_language,
        v_category
      FROM titles@jbclclink
      WHERE titleid = rec.title_id;
        
      --Check if this title ID is already present in Enrichedtitles
      BEGIN
        --Find by Title ID
        SELECT ID
        INTO v_enriched_title_id
        FROM enrichedtitles
        WHERE title_id = rec.title_id;
      exception
      WHEN no_data_found THEN
        BEGIN
          --Find by ISBN
          SELECT ID 
          INTO v_enriched_title_id 
          FROM enrichedtitles
          WHERE isbn = v_isbn_13 OR isbn10 = v_isbn_13;
        EXCEPTION
        WHEN no_data_found THEN
          v_enriched_title_id := NULL;
        END;
      END;
      
      IF(v_enriched_title_id IS NULL) THEN
        --If its not present, Attempt to create it
        
        --Fill Author Name instead of Author ID
        --Author ID concept is being removed
        SELECT trim(firstname
          || ' '
          || lastname)
        INTO v_authorname
        FROM authorprofile@jbclclink
        WHERE authorid = v_authorid;
        
        IF(v_isbn_13 IS NULL AND V_isbn_10 IS NULL) THEN
          /* If ISBNs are not present, update a dummy XXXXXXXXXXXXX as ISBN */
          v_isbn_13 := 'XXXXXXXXXXXXX';
        ELSIF(v_isbn_13 IS NULL AND V_isbn_10 IS NOT NULL) THEN
          /* If ISBN 10 is present, update it temporarily into ISBN 13
            ISBN scanning process will update it to 13 digits */
          v_isbn_13 := v_isbn_10;
        END IF;
        
        IF(v_isbn_13 != 'XXXXXXXXXXXXX') THEN
          /* Enriched Titles */
          SELECT enrichedtitles_seq.nextval INTO v_enriched_title_id FROM dual;
          v_enriched_title              := NULL;
          v_enriched_title.ID           := v_enriched_title_id;
          v_enriched_title.title_id     := v_titleid;
          v_enriched_title.title        := v_title;
          v_enriched_title.author       := v_authorname;
          v_enriched_title.isbn         := v_isbn_13;
          v_enriched_title.language     := v_language;
          v_enriched_title.CATEGORY     := v_category;
          v_enriched_title.isbn10       := v_isbn_10;
          v_enriched_title.VERSION      := 1;
          v_enriched_title.created_at   := SYSDATE;
          v_enriched_title.updated_at   := SYSDATE;
          INSERT INTO enrichedtitles VALUES v_enriched_title;
          
          /* Enriched Titles Version*/
          SELECT enrichedtitle_versions_seq.nextval
          INTO v_enriched_title_version_id
          FROM dual;
          v_enriched_title_version                  := NULL;
          v_enriched_title_version.ID               := v_enriched_title_version_id;
          v_enriched_title_version.enrichedtitle_id := v_enriched_title_id;
          v_enriched_title_version.VERSION          := 1;
          v_enriched_title_version.title_id         := v_titleid;
          v_enriched_title_version.title            := v_title;
          v_enriched_title_version.author           := v_authorname;
          v_enriched_title_version.isbn             := v_isbn_13;
          v_enriched_title_version.language         := v_language;
          v_enriched_title_version.CATEGORY         := v_category;
          v_enriched_title_version.isbn10           := v_isbn_10;
          v_enriched_title_version.created_at       := SYSDATE;
          v_enriched_title_version.updated_at       := SYSDATE;
          INSERT INTO enrichedtitle_versions VALUES v_enriched_title_version;
        END IF;
      END IF;
      
      /* Procurement Items */
      SELECT procurementitems_seq.nextval
      INTO v_procurement_item_id
      FROM dual;
      v_procurement_item                  := NULL;
      v_procurement_item.ID               := v_procurement_item_id;
      v_procurement_item.SOURCE           := 'IBTR';
      v_procurement_item.source_id        := 1;
      v_procurement_item.enrichedtitle_id := v_enriched_title_id;
      v_procurement_item.branch_id        := rec.branch_id;
      v_procurement_item.member_id        := rec.member_id;
      v_procurement_item.isbn             := v_isbn_13;
      v_procurement_item.status           := 'Assigned';
      v_procurement_item.last_action_date := SYSDATE;
      v_procurement_item.created_at       := SYSDATE;
      v_procurement_item.updated_at       := SYSDATE;
      v_procurement_item.procured_cnt     := 0;
      v_procurement_item.procurement_id   := p_procurement_id;
      v_procurement_item.title_id         := rec.title_id;
      v_procurement_item.quantity         := 1;
      INSERT INTO procurementitems VALUES v_procurement_item;
      l_count := l_count + 1;
    END loop;
    return l_count;
  END pull_ibtr_items;

  PROCEDURE pr_pull_corelist_items (p_key_id number)
  IS
    v_procurement_item procurementitems%rowtype;
    v_enriched_title enrichedtitles%rowtype;
    v_enriched_title_version enrichedtitle_versions%rowtype;
    v_title titles.title@jbclclink%TYPE;
    v_titleid titles.titleid@jbclclink%TYPE;
    v_authorid titles.authorid@jbclclink%TYPE;
    v_isbn_10 titles.isbn_10@jbclclink%TYPE;
    v_isbn_13 titles.isbn_13@jbclclink%TYPE;
    v_language titles.language@jbclclink%TYPE;
    v_category titles.CATEGORY@jbclclink%TYPE;
    v_enriched_title_id         NUMBER;
    v_enriched_title_version_id NUMBER;
    v_procurement_item_id       NUMBER;
    
    v_cnt                       NUMBER;
  BEGIN
    FOR rec IN
    (
      SELECT *
        FROM CORELIST 
        WHERE key_id = p_key_id 
        order by id
    )
    loop
      BEGIN
        SELECT ID
        INTO v_enriched_title_id
        FROM enrichedtitles
        WHERE isbn = rec.isbn OR isbn10 = rec.isbn;
      exception
      WHEN no_data_found THEN
        v_enriched_title_id := NULL;
      END;
      
      --Find by ISBN if title is not present already
      IF(v_enriched_title_id IS NULL) THEN
        SELECT count(*) INTO v_cnt FROM titles@jbclclink
        WHERE isbn_13 = rec.isbn OR isbn_10 = rec.isbn;
        
        IF(v_cnt > 0) THEN
          --ISBN was found in Titles
          BEGIN
            SELECT titleid,
              title,
              authorid,
              isbn_10,
              isbn_13,
              language,
              CATEGORY
            INTO v_titleid,
              v_title,
              v_authorid,
              v_isbn_10,
              v_isbn_13,
              v_language,
              v_category
            FROM titles@jbclclink
            WHERE (isbn_13 = rec.isbn OR isbn_10 = rec.isbn)
            AND TITLEID = 
            (
              SELECT MAX(TITLEID) FROM titles@jbclclink
              WHERE isbn_13 = rec.isbn OR isbn_10 = rec.isbn
            );
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              DBMS_OUTPUT.PUT_LINE('ISBN-'||rec.isbn);
          END;
          
          /* Enriched Titles */
          SELECT enrichedtitles_seq.nextval INTO v_enriched_title_id FROM dual;
          v_enriched_title              := NULL;
          v_enriched_title.ID           := v_enriched_title_id;
          v_enriched_title.title_id     := v_titleid;
          v_enriched_title.title        := rec.title;
          v_enriched_title.author       := rec.author;
          v_enriched_title.isbn         := rec.isbn;
          v_enriched_title.language     := v_language;
          v_enriched_title.CATEGORY     := rec.CATEGORY;
          v_enriched_title.subCATEGORY  := rec.subcategory;
          v_enriched_title.listprice    := rec.price;
          v_enriched_title.currency     := rec.currency;
          v_enriched_title.isbn10       := null;
          v_enriched_title.VERSION      := 1;
          v_enriched_title.created_at   := SYSDATE;
          v_enriched_title.updated_at   := SYSDATE;
          INSERT INTO enrichedtitles VALUES v_enriched_title;
          
          /* Enriched Titles Version*/
          SELECT enrichedtitle_versions_seq.nextval
          INTO v_enriched_title_version_id
          FROM dual;
          v_enriched_title_version                  := NULL;
          v_enriched_title_version.ID               := v_enriched_title_version_id;
          v_enriched_title_version.enrichedtitle_id := v_enriched_title_id;
          v_enriched_title_version.VERSION          := 1;
          v_enriched_title_version.title_id         := v_titleid;
          v_enriched_title_version.title            := rec.title;
          v_enriched_title_version.author           := rec.author;
          v_enriched_title_version.isbn             := rec.isbn;
          v_enriched_title_version.language         := v_language;
          v_enriched_title_version.CATEGORY         := rec.CATEGORY;
          v_enriched_title_version.subCATEGORY      := rec.subcategory;
          v_enriched_title_version.listprice        := rec.price;
          v_enriched_title_version.currency         := rec.currency;
          v_enriched_title_version.isbn10           := null;
          v_enriched_title_version.created_at       := SYSDATE;
          v_enriched_title_version.updated_at       := SYSDATE;
          INSERT INTO enrichedtitle_versions VALUES v_enriched_title_version;
        ELSE
          --ISBN was not found in Titles, Create New
          
          /* Enriched Titles */
          SELECT enrichedtitles_seq.nextval INTO v_enriched_title_id FROM dual;
          v_enriched_title              := NULL;
          v_enriched_title.ID           := v_enriched_title_id;
          v_enriched_title.title_id     := NULL;
          v_enriched_title.title        := rec.title;
          v_enriched_title.author       := rec.author;
          v_enriched_title.isbn         := rec.isbn;
          v_enriched_title.language     := null;
          v_enriched_title.CATEGORY     := rec.CATEGORY;
          v_enriched_title.subCATEGORY  := rec.subcategory;
          v_enriched_title.listprice    := rec.price;
          v_enriched_title.currency     := rec.currency;
          v_enriched_title.isbn10       := null;
          v_enriched_title.VERSION      := 1;
          v_enriched_title.created_at   := SYSDATE;
          v_enriched_title.updated_at   := SYSDATE;
          INSERT INTO enrichedtitles VALUES v_enriched_title;
          
          /* Enriched Titles Version*/
          SELECT enrichedtitle_versions_seq.nextval
          INTO v_enriched_title_version_id
          FROM dual;
          v_enriched_title_version                  := NULL;
          v_enriched_title_version.ID               := v_enriched_title_version_id;
          v_enriched_title_version.enrichedtitle_id := v_enriched_title_id;
          v_enriched_title_version.VERSION          := 1;
          v_enriched_title_version.title_id         := null;
          v_enriched_title_version.title            := rec.title;
          v_enriched_title_version.author           := rec.author;
          v_enriched_title_version.isbn             := rec.isbn;
          v_enriched_title_version.language         := null;
          v_enriched_title_version.CATEGORY         := rec.CATEGORY;
          v_enriched_title_version.subCATEGORY      := rec.subcategory;
          v_enriched_title_version.listprice        := rec.price;
          v_enriched_title_version.currency         := rec.currency;
          v_enriched_title_version.isbn10           := null;
          v_enriched_title_version.created_at       := SYSDATE;
          v_enriched_title_version.updated_at       := SYSDATE;
          INSERT INTO enrichedtitle_versions VALUES v_enriched_title_version;
        END IF;
      END IF;
      
      /* Procurement Items */
      SELECT procurementitems_seq.nextval
      INTO v_procurement_item_id
      FROM dual;
      v_procurement_item                  := NULL;
      v_procurement_item.ID               := v_procurement_item_id;
      v_procurement_item.SOURCE           := 'CORELIST';
      v_procurement_item.source_id        := 2;
      v_procurement_item.enrichedtitle_id := v_enriched_title_id;
      v_procurement_item.isbn             := rec.isbn;
      v_procurement_item.branch_id        := rec.branchid;
      v_procurement_item.status           := 'Assigned';
      v_procurement_item.quantity         := rec.qty;
      v_procurement_item.last_action_date := SYSDATE;
      v_procurement_item.created_at       := SYSDATE;
      v_procurement_item.updated_at       := SYSDATE;
      v_procurement_item.procured_cnt     := 0;
      INSERT INTO procurementitems VALUES v_procurement_item;
    END loop;
  END;
  
  PROCEDURE pr_pull_newarrival_items (p_key_id number)
  IS
    v_procurement_item procurementitems%rowtype;
    v_enriched_title enrichedtitles%rowtype;
    v_enriched_title_version enrichedtitle_versions%rowtype;
    v_title titles.title@jbclclink%TYPE;
    v_titleid titles.titleid@jbclclink%TYPE;
    v_authorid titles.authorid@jbclclink%TYPE;
    v_isbn_10 titles.isbn_10@jbclclink%TYPE;
    v_isbn_13 titles.isbn_13@jbclclink%TYPE;
    v_language titles.language@jbclclink%TYPE;
    v_category titles.CATEGORY@jbclclink%TYPE;
    v_enriched_title_id         NUMBER;
    v_enriched_title_version_id NUMBER;
    v_procurement_item_id       NUMBER;
    
    v_cnt                       NUMBER;
  BEGIN
    FOR rec IN
    (
      SELECT *
        FROM newarrivals_expanded 
        WHERE key_id = p_key_id
        order by id
    )
    loop
      BEGIN
        SELECT ID
        INTO v_enriched_title_id
        FROM enrichedtitles
        WHERE isbn = rec.isbn OR isbn10 = rec.isbn;
      exception
      WHEN no_data_found THEN
        v_enriched_title_id := NULL;
      END;
      
      --Find by ISBN if title is not present already
      IF(v_enriched_title_id IS NULL) THEN
        SELECT count(*) INTO v_cnt FROM titles@jbclclink
        WHERE isbn_13 = rec.isbn OR isbn_10 = rec.isbn;
        
        IF(v_cnt > 0) THEN
          --ISBN was found in Titles
          BEGIN
            SELECT titleid,
              title,
              authorid,
              isbn_10,
              isbn_13,
              language,
              CATEGORY
            INTO v_titleid,
              v_title,
              v_authorid,
              v_isbn_10,
              v_isbn_13,
              v_language,
              v_category
            FROM titles@jbclclink
            WHERE (isbn_13 = rec.isbn OR isbn_10 = rec.isbn)
            AND TITLEID = 
            (
              SELECT MAX(TITLEID) FROM titles@jbclclink
              WHERE isbn_13 = rec.isbn OR isbn_10 = rec.isbn
            );
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              DBMS_OUTPUT.PUT_LINE('ISBN-'||rec.isbn);
          END;
          
          /* Enriched Titles */
          SELECT enrichedtitles_seq.nextval INTO v_enriched_title_id FROM dual;
          v_enriched_title              := NULL;
          v_enriched_title.ID           := v_enriched_title_id;
          v_enriched_title.title_id     := v_titleid;
          v_enriched_title.title        := rec.title;
          v_enriched_title.author       := rec.author;
          v_enriched_title.isbn         := rec.isbn;
          v_enriched_title.language     := v_language;
          v_enriched_title.CATEGORY     := rec.CATEGORY;
          v_enriched_title.subCATEGORY  := rec.subcategory;
          v_enriched_title.listprice    := rec.price;
          v_enriched_title.currency     := rec.currency;
          v_enriched_title.isbn10       := null;
          v_enriched_title.VERSION      := 1;
          v_enriched_title.created_at   := SYSDATE;
          v_enriched_title.updated_at   := SYSDATE;
          INSERT INTO enrichedtitles VALUES v_enriched_title;
          
          /* Enriched Titles Version*/
          SELECT enrichedtitle_versions_seq.nextval
          INTO v_enriched_title_version_id
          FROM dual;
          v_enriched_title_version                  := NULL;
          v_enriched_title_version.ID               := v_enriched_title_version_id;
          v_enriched_title_version.enrichedtitle_id := v_enriched_title_id;
          v_enriched_title_version.VERSION          := 1;
          v_enriched_title_version.title_id         := v_titleid;
          v_enriched_title_version.title            := rec.title;
          v_enriched_title_version.author           := rec.author;
          v_enriched_title_version.isbn             := rec.isbn;
          v_enriched_title_version.language         := v_language;
          v_enriched_title_version.CATEGORY         := rec.CATEGORY;
          v_enriched_title_version.subCATEGORY      := rec.subcategory;
          v_enriched_title_version.listprice        := rec.price;
          v_enriched_title_version.currency         := rec.currency;
          v_enriched_title_version.isbn10           := null;
          v_enriched_title_version.created_at       := SYSDATE;
          v_enriched_title_version.updated_at       := SYSDATE;
          INSERT INTO enrichedtitle_versions VALUES v_enriched_title_version;
        ELSE
          --ISBN was not found in Titles, Create New
          
          /* Enriched Titles */
          SELECT enrichedtitles_seq.nextval INTO v_enriched_title_id FROM dual;
          v_enriched_title              := NULL;
          v_enriched_title.ID           := v_enriched_title_id;
          v_enriched_title.title_id     := NULL;
          v_enriched_title.title        := rec.title;
          v_enriched_title.author       := rec.author;
          v_enriched_title.isbn         := rec.isbn;
          v_enriched_title.language     := null;
          v_enriched_title.CATEGORY     := rec.CATEGORY;
          v_enriched_title.subCATEGORY  := rec.subcategory;
          v_enriched_title.listprice    := rec.price;
          v_enriched_title.currency     := rec.currency;
          v_enriched_title.isbn10       := null;
          v_enriched_title.VERSION      := 1;
          v_enriched_title.created_at   := SYSDATE;
          v_enriched_title.updated_at   := SYSDATE;
          INSERT INTO enrichedtitles VALUES v_enriched_title;
          
          /* Enriched Titles Version*/
          SELECT enrichedtitle_versions_seq.nextval
          INTO v_enriched_title_version_id
          FROM dual;
          v_enriched_title_version                  := NULL;
          v_enriched_title_version.ID               := v_enriched_title_version_id;
          v_enriched_title_version.enrichedtitle_id := v_enriched_title_id;
          v_enriched_title_version.VERSION          := 1;
          v_enriched_title_version.title_id         := null;
          v_enriched_title_version.title            := rec.title;
          v_enriched_title_version.author           := rec.author;
          v_enriched_title_version.isbn             := rec.isbn;
          v_enriched_title_version.language         := null;
          v_enriched_title_version.CATEGORY         := rec.CATEGORY;
          v_enriched_title_version.subCATEGORY      := rec.subcategory;
          v_enriched_title_version.listprice        := rec.price;
          v_enriched_title_version.currency         := rec.currency;
          v_enriched_title_version.isbn10           := null;
          v_enriched_title_version.created_at       := SYSDATE;
          v_enriched_title_version.updated_at       := SYSDATE;
          INSERT INTO enrichedtitle_versions VALUES v_enriched_title_version;
        END IF;
      END IF;
      
      /* Procurement Items */
      SELECT procurementitems_seq.nextval
      INTO v_procurement_item_id
      FROM dual;
      v_procurement_item                  := NULL;
      v_procurement_item.ID               := v_procurement_item_id;
      v_procurement_item.SOURCE           := 'NEWARRIVALS';
      v_procurement_item.source_id        := 3;
      v_procurement_item.enrichedtitle_id := v_enriched_title_id;
      v_procurement_item.isbn             := rec.isbn;
      v_procurement_item.branch_id        := rec.branchid;
      v_procurement_item.status           := 'Assigned';
      v_procurement_item.quantity         := rec.qty;
      v_procurement_item.procured_cnt     := 0;
      v_procurement_item.last_action_date := SYSDATE;
      v_procurement_item.created_at       := SYSDATE;
      v_procurement_item.updated_at       := SYSDATE;
      INSERT INTO procurementitems VALUES v_procurement_item;
    END loop;
  END;
  
  PROCEDURE pr_init_data_pull
  IS
  BEGIN
    pr_pull_ibtr_items;
  END;
  
  PROCEDURE pr_pull_ibtr_items
  IS
    v_procurement_item procurementitems%rowtype;
    v_enriched_title enrichedtitles%rowtype;
    v_enriched_title_version enrichedtitle_versions%rowtype;
    v_author_clc authorprofile@jbclclink%rowtype;
    v_title titles.title@jbclclink%TYPE;
    v_titleid titles.titleid@jbclclink%TYPE;
    v_authorid titles.authorid@jbclclink%TYPE;
    v_isbn_10 titles.isbn_10@jbclclink%TYPE;
    v_isbn_13 titles.isbn_13@jbclclink%TYPE;
    v_language titles.language@jbclclink%TYPE;
    v_category titles.CATEGORY@jbclclink%TYPE;
    v_authorname enrichedtitles.author%TYPE;
    v_procurement_item_id       NUMBER;
    v_enriched_title_id         NUMBER;
    v_enriched_title_version_id NUMBER;
    l_count                     NUMBER := 0;
  BEGIN
    FOR rec IN
    (SELECT *
    FROM ibtrs@link_opac
    WHERE respondent_id                  = v_procurement_branch_id
    AND state                            = v_procurement_pull_status
    AND to_char(created_at, 'DD-MON-RR') = to_char(SYSDATE-v_days_before, 'DD-MON-RR')
    )
    loop
      BEGIN
        SELECT ID
        INTO v_enriched_title_id
        FROM enrichedtitles
        WHERE title_id = rec.title_id;
      exception
      WHEN no_data_found THEN
        v_enriched_title_id := NULL;
      END;
      IF(v_enriched_title_id IS NULL) THEN
        
        SELECT titleid,
          title,
          authorid,
          isbn_10,
          isbn_13,
          language,
          CATEGORY
        INTO v_titleid,
          v_title,
          v_authorid,
          v_isbn_10,
          v_isbn_13,
          v_language,
          v_category
        FROM titles@jbclclink
        WHERE titleid = rec.title_id;
        --Fill Author Name instead of Author ID
        --Author ID concept is being removed
        SELECT trim(firstname
          || ' '
          || lastname)
        INTO v_authorname
        FROM authorprofile@jbclclink
        WHERE authorid = v_authorid;
        
        /* Enriched Titles */
        SELECT enrichedtitles_seq.nextval INTO v_enriched_title_id FROM dual;
        v_enriched_title              := NULL;
        v_enriched_title.ID           := v_enriched_title_id;
        v_enriched_title.title_id     := v_titleid;
        v_enriched_title.title        := v_title;
        v_enriched_title.author       := v_authorname;
        v_enriched_title.isbn         := v_isbn_13;
        v_enriched_title.language     := v_language;
        v_enriched_title.CATEGORY     := v_category;
        v_enriched_title.isbn10       := v_isbn_10;
        v_enriched_title.VERSION      := 1;
        v_enriched_title.created_at   := SYSDATE;
        v_enriched_title.updated_at   := SYSDATE;
        INSERT INTO enrichedtitles VALUES v_enriched_title;
        
        /* Enriched Titles Version*/
        SELECT enrichedtitle_versions_seq.nextval
        INTO v_enriched_title_version_id
        FROM dual;
        v_enriched_title_version                  := NULL;
        v_enriched_title_version.ID               := v_enriched_title_version_id;
        v_enriched_title_version.enrichedtitle_id := v_enriched_title_id;
        v_enriched_title_version.VERSION          := 1;
        v_enriched_title_version.title_id         := v_titleid;
        v_enriched_title_version.title            := v_title;
        v_enriched_title_version.author           := v_authorname;
        v_enriched_title_version.isbn             := v_isbn_13;
        v_enriched_title_version.language         := v_language;
        v_enriched_title_version.CATEGORY         := v_category;
        v_enriched_title_version.isbn10           := v_isbn_10;
        v_enriched_title_version.created_at       := SYSDATE;
        v_enriched_title_version.updated_at       := SYSDATE;
        INSERT INTO enrichedtitle_versions VALUES v_enriched_title_version;
      END IF;
      
      /* Procurement Items */
      SELECT procurementitems_seq.nextval
      INTO v_procurement_item_id
      FROM dual;
      v_procurement_item                  := NULL;
      v_procurement_item.ID               := v_procurement_item_id;
      v_procurement_item.SOURCE           := 'IBTR';
      v_procurement_item.source_id        := 1;
      v_procurement_item.enrichedtitle_id := v_enriched_title_id;
      v_procurement_item.branch_id        := rec.branch_id;
      v_procurement_item.isbn             := v_isbn_13;
      v_procurement_item.status           := 'Assigned';
      v_procurement_item.last_action_date := SYSDATE;
      v_procurement_item.created_at       := SYSDATE;
      v_procurement_item.updated_at       := SYSDATE;
      v_procurement_item.procured_cnt     := 0;
      INSERT INTO procurementitems VALUES v_procurement_item;
    END loop;
  END;
END data_pull;
/
 

--------------------------------------------------------
--  DDL for Package Body PO_GENERATOR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PO_GENERATOR" AS
  FUNCTION generate_pos(p_procurement_id NUMBER, p_po_type VARCHAR2) 
  RETURN NUMBER 
  IS 
    v_ponumber procurementitems.po_number%TYPE;
    v_supplierid procurementitems.supplier_id%TYPE;
    v_branchid procurementitems.branch_id%TYPE;
    v_publisherid enrichedtitles.publisher_id%TYPE;
    v_curr enrichedtitles.currency%type;
    v_pos_id pos.id%type;
    v_newpo pos%rowtype;
    v_titlescnt number;
    v_copiescnt number;
    v_poscnt number := 0;
    v_discount supplierdiscounts.discount%TYPE;
    v_convrate NUMBER;
    v_grossamt pos.grossamt%TYPE;
    v_netamt pos.netamt%TYPE;
    v_creditperiod suppliers.creditperiod%TYPE;
    v_expensehead number;
  BEGIN
    --Per Supplier, Publisher, Currency and Branch
    FOR supp IN
    (
      SELECT DISTINCT a.supplier_id
      FROM procurementitems A, procurements b, enrichedtitles c, publishers d
      WHERE A.procurement_id = b.ID
      AND A.enrichedtitle_id = c.ID
      AND c.publisher_id = d.ID
      AND A.po_number IS NULL 
      AND b.ID = p_procurement_id
      AND A.supplier_id IS NOT NULL
      AND (A.isbn IS NOT NULL AND A.isbn != 'XXXXXXXXXXXXX') 
      AND c.isbnvalid = 'Y'
      AND (
        c.verified = 'Y'
        AND c.isbn IS NOT NULL
        AND c.title_id IS NOT NULL
        AND c.publisher_id IS NOT NULL
        AND c.author IS NOT NULL
        )
    )
    LOOP
      FOR grp IN 
      (
        SELECT DISTINCT d.group_id
        FROM procurementitems A, procurements b, enrichedtitles c, publishers d
        WHERE A.procurement_id = b.ID
        AND A.enrichedtitle_id = c.ID
        AND c.publisher_id = d.ID
        AND A.po_number IS NULL 
        AND b.ID = p_procurement_id
        AND A.supplier_id IS NOT NULL
        AND (A.isbn IS NOT NULL AND A.isbn != 'XXXXXXXXXXXXX') 
        AND c.isbnvalid = 'Y'
        AND (
          c.verified = 'Y'
          AND c.isbn IS NOT NULL
          AND c.title_id IS NOT NULL
          AND c.publisher_id IS NOT NULL
          AND c.author IS NOT NULL
          )
        AND a.supplier_id = supp.supplier_id
      )
      LOOP
        FOR curr IN 
        (
          SELECT DISTINCT c.currency
          FROM procurementitems A, procurements b, enrichedtitles c, publishers d
          WHERE A.procurement_id = b.ID
          AND A.enrichedtitle_id = c.ID
          AND c.publisher_id = d.ID
          AND A.po_number IS NULL 
          AND b.ID = p_procurement_id
          AND A.supplier_id IS NOT NULL
          AND (A.isbn IS NOT NULL AND A.isbn != 'XXXXXXXXXXXXX') 
          AND c.isbnvalid = 'Y'
          AND (
            c.verified = 'Y'
            AND c.isbn IS NOT NULL
            AND c.title_id IS NOT NULL
            AND c.publisher_id IS NOT NULL
            AND c.author IS NOT NULL
            )
          AND a.supplier_id = supp.supplier_id
          AND c.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
        )
        LOOP
          FOR brn IN 
          (
            SELECT distinct a.branch_id
            FROM procurementitems A, procurements b, enrichedtitles c, publishers d
            WHERE A.procurement_id = b.ID
            AND A.enrichedtitle_id = c.ID
            AND c.publisher_id = d.ID
            AND A.po_number IS NULL 
            AND b.ID = p_procurement_id
            AND A.supplier_id IS NOT NULL
            AND (A.isbn IS NOT NULL AND A.isbn != 'XXXXXXXXXXXXX') 
            AND c.isbnvalid = 'Y'
            AND (
              c.verified = 'Y'
              AND c.isbn IS NOT NULL
              AND c.title_id IS NOT NULL
              AND c.publisher_id IS NOT NULL
              AND c.author IS NOT NULL
              )
            AND a.supplier_id = supp.supplier_id
            AND c.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
            AND c.currency = curr.currency
          )
          LOOP
            --Create PO
            SELECT P_PO_TYPE || '/' || LPAD(TO_CHAR(PONUMBER_SEQ.NEXTVAL),4,'0') || '/' || TO_CHAR(SYSDATE,'YYYYMMDD') 
              INTO v_ponumber 
              FROM DUAL;
              
            select pos_seq.nextval into v_pos_id from dual;
            
            SELECT DISTINCT A.supplier_id, a.branch_id, d.group_id, c.currency
              INTO v_supplierid, v_branchid, v_publisherid, v_curr
              FROM procurementitems A, procurements b, enrichedtitles c, publishers d
              WHERE A.procurement_id = b.ID
              AND A.enrichedtitle_id = c.ID
              AND c.publisher_id = d.ID
              AND A.po_number IS NULL 
              AND b.ID = p_procurement_id
              AND A.supplier_id IS NOT NULL
              AND (A.isbn IS NOT NULL AND A.isbn != 'XXXXXXXXXXXXX') 
              AND c.isbnvalid = 'Y'
              AND (
                c.verified = 'Y'
                AND c.isbn IS NOT NULL
                AND c.title_id IS NOT NULL
                AND c.publisher_id IS NOT NULL
                AND c.author IS NOT NULL
                )
              AND a.supplier_id = supp.supplier_id
              AND c.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
              AND c.currency = curr.currency
              and a.branch_id = brn.branch_id;
              
            v_newpo                := NULL;
            v_newpo.ID             := v_pos_id;
            v_newpo.CODE           := v_ponumber;
            v_newpo.supplier_id    := v_supplierid;
            v_newpo.branch_id      := v_branchid;
            v_newpo.publisher_id   := v_publisherid;
            v_newpo.procurement_id := p_procurement_id;
            v_newpo.currency       := v_curr;
            v_newpo.raised_on      := SYSDATE;
            v_newpo.copies_cnt     := NULL;
            v_newpo.status         := 'O';
            v_newpo.created_at     := SYSDATE;
            v_newpo.updated_at     := SYSDATE;
            v_newpo.discount       := NULL;
              
            INSERT INTO pos values v_newpo;
            v_poscnt := v_poscnt + 1;
            
            --Update PO Number
            UPDATE PROCUREMENTITEMS SET po_number = v_ponumber 
            WHERE ID IN 
              (
                SELECT a.id
                FROM procurementitems A, procurements b, enrichedtitles c, publishers d
                WHERE A.procurement_id = b.ID
                AND A.enrichedtitle_id = c.ID
                AND c.publisher_id = d.ID
                AND A.po_number IS NULL 
                AND b.ID = p_procurement_id
                AND A.supplier_id IS NOT NULL
                AND (A.isbn IS NOT NULL AND A.isbn != 'XXXXXXXXXXXXX') 
                AND c.isbnvalid = 'Y'
                AND (
                  c.verified = 'Y'
                  AND c.isbn IS NOT NULL
                  AND c.title_id IS NOT NULL
                  AND c.publisher_id IS NOT NULL
                  AND c.author IS NOT NULL
                  )
                AND a.supplier_id = supp.supplier_id
                AND c.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
                AND c.currency = curr.currency
                and a.branch_id = brn.branch_id
              );
              
            --Update Titles Count back into PO
            v_titlescnt := SQL%ROWCOUNT;
            select sum(quantity) into v_copiescnt from procurementitems
              where po_number = v_ponumber;
            update pos set titles_cnt = v_titlescnt, copies_cnt = v_copiescnt where code = v_ponumber;
  
            --Update other details into PO
            SELECT DISTINCT DISCOUNT 
              INTO v_discount
              FROM PO_VIEW WHERE PO_NO=v_ponumber;
    
            SELECT DISTINCT DECODE(currency,'USD',47.90,'GBP',77.50,'EUR',65.70,1)
              INTO v_convrate
              FROM ENRICHEDTITLES WHERE ID IN (
                SELECT ENRICHEDTITLE_ID FROM PROCUREMENTITEMS
                WHERE PO_NUMBER=v_ponumber
              );
      
            SELECT SUM(listprice) * v_convrate INTO v_grossamt
              FROM ENRICHEDTITLES WHERE ID IN (
                SELECT ENRICHEDTITLE_ID FROM PROCUREMENTITEMS
                WHERE PO_NUMBER=v_ponumber
              );
    
            SELECT v_grossamt - (ROUND((v_discount * v_grossamt/100),2)) INTO v_netamt FROM dual;
    
            SELECT CREDITPERIOD 
            INTO v_creditperiod 
            FROM SUPPLIERS
            WHERE ID = v_supplierid;
    
            SELECT DECODE(SUBSTR(v_ponumber, 0, 4), 'NSTR',110001001, 'NENT',110008001, 'IBTR', 10001, -1) 
              INTO v_expensehead 
              FROM DUAL;
      
            UPDATE POS SET
              DISCOUNT    = v_discount,
              TYPEOFPO    = SUBSTR(v_ponumber, 0, 4),
              CONVRATE    = v_convrate,
              GROSSAMT    = v_grossamt,
              NETAMT      = v_netamt,
              ORGUNIT     = 1,
              SUBORGUNIT  = 7,
              EXPENSEHEAD = v_expensehead,
              PAYBY1      = CREATED_AT+v_creditperiod+7,
              PAYABLEAMT1 = v_netamt
            WHERE CODE = v_ponumber;
    
            --Push PO to Fin System
            /*SELECT * INTO REC FROM POS WHERE CODE = v_ponumber;
            SELECT DECODE(REC.TYPEOFPO,'NSTR',110001,'NENT',110008, REC.TYPEOFPO) INTO v_typeofpo
              FROM POS WHERE CODE = REC.CODE;
            CREATE_PO_FOR_BUDGETING@jbclclink(
              v_typeofpo,
              v_ponumber,
              REC.CREATED_AT,
              REC.COPIES_CNT,
              REC.CONVRATE,
              REC.GROSSAMT,
              REC.DISCOUNT,
              REC.NETAMT,
              REC.SUPPLIER_ID,
              REC.NARRATION,
              TRUNC(REC.PAYBY1),
              REC.PAYABLEAMT1,
              TRUNC(REC.PAYBY2),
              REC.PAYABLEAMT2,
              TRUNC(REC.PAYBY3),
              REC.PAYABLEAMT3,
              REC.ORGUNIT,
              REC.SUBORGUNIT,
              REC.EXPENSEHEAD,
              REC.BRANCH_ID
            );*/
          END loop;
        END LOOP;
      END loop;
    end loop;
    return v_poscnt;
  END GENERATE_POS;
  
  FUNCTION extract(p_po_number IN VARCHAR2) RETURN VARCHAR2
  IS
    v_filename VARCHAR2(255);
    OutputRecord   VARCHAR2(4000);
    OutputFile     utl_file.FILE_TYPE;
  BEGIN
    SELECT 
    lower(substr(trim(replace(name,' ','_')),1,10)) || '-' || get_pub_name(a.publisher_id) || '-' || BRANCH_ID || '-' || replace(a.code,'/','.')
    INTO v_filename
    FROM POS A, suppliers b
    WHERE A.code=P_PO_NUMBER
    AND A.supplier_id = b.ID;
    
    OutputFile := utl_file.fopen(UPPER('DMPDIR'), v_filename || '.csv', 'w', 32767);
    OutputRecord := 'PO_NO,WORKLIST_ID,TITLE,ISBN,AUTHOR,PUBLISHERNAME,SUPPLIER,QUANTITY,LISTPRICE,CURRENCY,CONV_RATE,INRPRICE,DISCOUNT,COSTPRICE';
    utl_file.put_line(Outputfile, OutputRecord);
    FOR REC IN
    (
      SELECT * FROM PO_VIEW WHERE PO_NO = P_PO_NUMBER
    )
    LOOP
      OutputRecord := REC.PO_NO || ',"' || REC.WORKLIST_ID || '","' || REC.TITLE || '","' || REC.ISBN || '","' || REC.AUTHOR || '","' || REC.PUBLISHERNAME || '","' || 
        REC.SUPPLIER || '","' || REC.QUANTITY || '","' || REC.LISTPRICE || '","' || REC.CURRENCY || '","' || REC.CONV_RATE || '","' || REC.INRPRICE || '","' || REC.DISCOUNT || '",' || REC.COSTPRICE;
      utl_file.put_line(OutputFile, OutputRecord);
    END LOOP;
    utl_file.fclose(OutputFile);
    return v_filename || '.csv';
  END;
  
  FUNCTION generate(p_procurement_id IN NUMBER, p_type IN VARCHAR2) 
  RETURN NUMBER IS
  v_poscnt number;
  BEGIN
    v_poscnt := generate_pos(p_procurement_id, p_type);
    return v_poscnt;
  END;
END PO_GENERATOR;
/
 

--------------------------------------------------------
--  DDL for Package Body WORKLIST_GENERATOR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "WORKLIST_GENERATOR" AS
  v_no_supplier_wl_size NUMBER := 100; /* Worklist size for Supplier not set recprds*/
  
  v_avl_no_po_wl_size NUMBER := 100; /* Worklist size for Available items with No PO set*/
  v_not_avl_no_po_wl_size NUMBER := 1; /* Worklist size for Not available items with No PO set*/
  
  /* Min sizes for Worklist creation */
  v_no_supplier_wl_min_size NUMBER := 100; 
  v_avl_no_po_wl_min_size NUMBER := 100;
  v_details_not_enriched_wl_size NUMBER := 100;
  v_invalid_isbn_wl_size NUMBER := 100;
  v_no_isbn_wl_size NUMBER := 100;

  FUNCTION fn_create_worklist(description IN VARCHAR2,list_type IN VARCHAR2, 
    procurement_id IN NUMBER)
  RETURN NUMBER IS
    v_worklist        worklists%rowtype;
    v_worklist_id     pls_integer;
  BEGIN
    SELECT worklists_seq.nextval INTO v_worklist_id FROM dual;
    v_worklist.ID             := v_worklist_id;
    v_worklist.description    := description;
    v_worklist.status         := 'Open';
    v_worklist.open_date      := SYSDATE;
    v_worklist.close_date     := NULL;
    v_worklist.created_by     := 'SYSTEM';
    v_worklist.created_at     := SYSDATE;
    v_worklist.updated_at     := SYSDATE;
    v_worklist.list_type      := list_type;
    v_worklist.procurement_id := procurement_id;
    INSERT INTO worklists VALUES v_worklist;

    RETURN v_worklist_id;
  END fn_create_worklist;

  FUNCTION fn_populate_workitem(pworklistid IN NUMBER,
    pprocurementitemid IN NUMBER, pitemtype IN VARCHAR2,
    pstatus IN VARCHAR2)
  RETURN NUMBER IS
    v_worklist_item         workitems%rowtype;
    v_worklist_item_id      NUMBER;
  BEGIN
    SELECT workitems_seq.nextval INTO v_worklist_item_id FROM dual;

    v_worklist_item.ID                    := v_worklist_item_id;
    v_worklist_item.worklist_id           := pworklistid;
    v_worklist_item.ref_id    := pprocurementitemid;
    v_worklist_item.item_type             := pitemtype;
    v_worklist_item.status                := pstatus;
    v_worklist_item.created_at            := SYSDATE;
    v_worklist_item.updated_at            := SYSDATE;
    INSERT INTO workitems VALUES v_worklist_item;
    RETURN v_worklist_item_id;
  END fn_populate_workitem;
  
  FUNCTION fn_clear_current_worklists(p_procurement_id IN NUMBER)
  RETURN BOOLEAN IS
  BEGIN
    UPDATE worklists SET status='Closed' WHERE procurement_id = p_procurement_id;
    return true;
  END;

  PROCEDURE pr_create_no_isbn_wl(p_procurement_id NUMBER)
  IS
    v_worklist_item       workitems%rowtype;
    
    l_worklist_id         NUMBER := NULL;
    l_worklist_item_id    NUMBER := NULL;
  BEGIN
    FOR rec IN
    (
      SELECT A.ID FROM procurementitems A
      WHERE
      /* No ISBN */
      (A.isbn IS NULL
      OR A.isbn = 'XXXXXXXXXXXXX')
      AND A.PROCUREMENT_ID = p_procurement_id
      AND ROWNUM <= v_no_isbn_wl_size
    )
    loop
      /* Create Worklist */
      IF l_worklist_id IS NULL THEN
        l_worklist_id := fn_create_worklist('Procurement Items with No ISBN', NULL, p_procurement_id);
      END IF;

      /* Populate Items */
      l_worklist_item_id := fn_populate_workitem(l_worklist_id,rec.ID,
                              'ProcurementItem', 'Open');
    END loop;
  END;
  
  PROCEDURE pr_invalid_isbn_wl(p_procurement_id NUMBER)
  IS
    v_worklist_item       workitems%rowtype;
    
    l_worklist_id         NUMBER := NULL;
    l_worklist_item_id    NUMBER := NULL;
  BEGIN
    FOR rec IN
    (
      SELECT A.ID, A.enrichedtitle_id FROM procurementitems A, enrichedtitles b
      WHERE
      A.enrichedtitle_id = b.ID
      AND
      /* Invalid ISBN */
      (b.isbnvalid = 'N')
      AND (A.isbn IS NOT NULL AND A.isbn != 'XXXXXXXXXXXXX')
      AND A.PROCUREMENT_ID = p_procurement_id
      AND ROWNUM <= v_invalid_isbn_wl_size
    )
    loop
      /* Create Worklist */
      IF l_worklist_id IS NULL THEN
        l_worklist_id := fn_create_worklist('Procurement Items with Invalid ISBN', NULL, p_procurement_id);
      END IF;

      /* Populate Items */
      l_worklist_item_id := fn_populate_workitem(l_worklist_id,rec.ID,
                              'ProcurementItem', 'Open');
    END loop;
  END;
  
  PROCEDURE pr_create_details_not_enriched(p_procurement_id NUMBER)
  IS
    v_worklist_item       workitems%rowtype;
    
    l_worklist_id         NUMBER := NULL;
    l_worklist_item_id    NUMBER := NULL;
  BEGIN
    FOR rec IN
    (SELECT A.ID, A.enrichedtitle_id FROM procurementitems A, enrichedtitles b
      WHERE
      A.enrichedtitle_id = b.ID
      AND
      /* ISBN Details not verified */
      (nvl(b.verified,'N') = 'N')
      AND (A.isbn IS NOT NULL AND A.isbn != 'XXXXXXXXXXXXX')
      AND b.isbnvalid = 'Y'
      AND A.PROCUREMENT_ID = p_procurement_id
      AND ROWNUM <= v_details_not_enriched_wl_size
    )
    loop
      /* Create Worklist */
      IF l_worklist_id IS NULL THEN
        l_worklist_id := fn_create_worklist('Procurement Items with Details Not Verified', NULL, p_procurement_id);
      END IF;

      /* Populate Items */
      l_worklist_item_id := fn_populate_workitem(l_worklist_id,rec.ID,
                              'ProcurementItem', 'Open');
    END loop;
  END;
  
  PROCEDURE pr_create_no_supp_det_wl(p_procurement_id NUMBER)
  IS
    v_worklist_item       workitems%rowtype;

    l_worklist_id         NUMBER := NULL;
    l_worklist_item_id    NUMBER := NULL;
  BEGIN
    FOR rec IN
    (SELECT A.ID FROM procurementitems A, enrichedtitles b
      WHERE
      A.enrichedtitle_id = b.ID
      AND
      /* Supplier Details not set */
      (supplier_id IS NULL)
      AND (A.isbn IS NOT NULL AND A.isbn != 'XXXXXXXXXXXXX')
      AND b.isbnvalid = 'Y'
      /* ISBN and Other Details set */
      AND (b.verified = 'Y' 
        AND b.isbn IS NOT NULL
        AND b.title_id IS NOT NULL
        AND b.publisher_id IS NOT NULL
        AND b.author IS NOT NULL
      )
      AND A.PROCUREMENT_ID = p_procurement_id
      AND ROWNUM <= v_avl_no_po_wl_size
    )
    loop
      /* Create Worklist */
      IF l_worklist_id IS NULL THEN
        l_worklist_id := fn_create_worklist('Procurement Items with No Supplier Details', NULL, p_procurement_id);
      END IF;

      /* Populate Items */
      l_worklist_item_id := fn_populate_workitem(l_worklist_id,rec.ID,
                              'ProcurementItem', 'Open');
    END loop;
  END;

  PROCEDURE generate_ibtr_wl(p_procurement_id NUMBER)
  IS
  BEGIN
    pr_create_no_isbn_wl(p_procurement_id);
    pr_invalid_isbn_wl(p_procurement_id);
    pr_create_details_not_enriched(p_procurement_id);
    pr_create_no_supp_det_wl(p_procurement_id);
  END;
  
  PROCEDURE regenerate_ibtr_wl(p_procurement_id NUMBER)
  IS
  BEGIN
    if (fn_clear_current_worklists(p_procurement_id)) then
      pr_create_no_isbn_wl(p_procurement_id);
      pr_invalid_isbn_wl(p_procurement_id);
      pr_create_details_not_enriched(p_procurement_id);
      pr_create_no_supp_det_wl(p_procurement_id);
    end if;
  END;

  PROCEDURE pr_create_corelist_wl(p_procurement_id NUMBER)
  IS
    v_worklist_item       workitems%rowtype;

    l_worklist_id         NUMBER := NULL;
    l_worklist_item_id    NUMBER := NULL;
  BEGIN
    FOR grp IN 
    (SELECT DISTINCT c.group_id FROM procurementitems A, enrichedtitles b, publishers c
      WHERE
      A.enrichedtitle_id = b.ID
      AND b.publisher_id = c.ID
      AND b.isbnvalid = 'Y'
      AND
      /* ISBN and Supplier Details set */
      (
        b.isbn IS NOT NULL
        --AND b.title_id IS NOT NULL
        AND b.publisher_id IS NOT NULL
        --AND A.supplier_id IS NOT NULL
        AND a.branch_id is not null
        AND b.author IS NOT NULL
      )
      AND
      /* PO Details not set */
      (A.po_number IS NULL)
    )
    LOOP
      FOR curr IN 
      (SELECT DISTINCT b.currency FROM procurementitems A, enrichedtitles b, publishers c
        WHERE
        A.enrichedtitle_id = b.ID
        AND b.publisher_id = c.id
        AND b.isbnvalid = 'Y'
        AND
        /* ISBN and Supplier Details set */
        (
          b.isbn IS NOT NULL
          --AND b.title_id IS NOT NULL
          AND b.publisher_id IS NOT NULL
          --AND A.supplier_id IS NOT NULL
          AND a.branch_id is not null
          AND b.author IS NOT NULL
          AND b.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
        )
        AND
        /* PO Details not set */
        (A.po_number IS NULL)
      )
      LOOP
        FOR brn IN 
        (
          SELECT distinct a.branch_id FROM procurementitems A, enrichedtitles b
            WHERE
            A.enrichedtitle_id = b.ID
            AND b.isbnvalid = 'Y'
            AND
            /* ISBN and Supplier Details set */
            (
              b.isbn IS NOT NULL
              --AND b.title_id IS NOT NULL
              AND b.publisher_id IS NOT NULL
              AND b.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
              --AND nvl(A.supplier_id,-1) = nvl(supplier.supplier_id,-1)
              AND a.branch_id is not null
              AND b.author IS NOT NULL
              AND b.currency = curr.currency
            )
            AND
            /* PO Details not set */
            (a.po_number IS NULL)
        )
        LOOP
          FOR rec IN
          (SELECT A.ID FROM procurementitems A, enrichedtitles b
            WHERE
            A.enrichedtitle_id = b.ID
            AND b.isbnvalid = 'Y'
            AND
            /* ISBN and Supplier Details set */
            (
              b.isbn IS NOT NULL
              --AND b.title_id IS NOT NULL
              AND b.publisher_id IS NOT NULL
              AND b.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
              --AND nvl(A.supplier_id,-1) = nvl(supplier.supplier_id,-1)
              AND a.branch_id is not null
              AND b.author IS NOT NULL
              AND b.currency = curr.currency
              and a.branch_id = brn.branch_id
            )
            AND
            /* PO Details not set */
            (a.po_number IS NULL)
          )
          loop
            /* Create Worklist */
            IF l_worklist_id IS NULL THEN
              l_worklist_id := fn_create_worklist('Procurement Items with PO not generated', NULL, p_procurement_id);
            END IF;
      
            /* Populate Items */
            l_worklist_item_id := fn_populate_workitem(l_worklist_id,rec.ID,
                                    'ProcurementItem', 'Open');
          END loop;
          l_worklist_id := NULL;
          l_worklist_item_id := NULL;
        END loop;
      END LOOP;
    END loop;
  END;
  
  PROCEDURE pr_create_newentry_wl(p_procurement_id NUMBER)
  IS
    v_worklist_item       workitems%rowtype;

    l_worklist_id         NUMBER := NULL;
    l_worklist_item_id    NUMBER := NULL;
  BEGIN
    FOR grp IN 
    (SELECT DISTINCT c.group_id FROM procurementitems A, enrichedtitles b, publishers c
      WHERE
      A.enrichedtitle_id = b.ID
      AND b.publisher_id = c.id
      AND b.isbnvalid = 'Y'
      AND
      /* ISBN and Supplier Details set */
      (
        b.isbn IS NOT NULL
        --AND b.title_id IS NOT NULL
        AND b.publisher_id IS NOT NULL
        --AND A.supplier_id IS NOT NULL
        AND A.branch_id IS NOT NULL
        --AND b.author IS NOT NULL
      )
      AND
      /* PO Details not set */
      (A.po_number IS NULL)
      order by c.group_id
    )
    LOOP
      FOR BRN IN 
      (
        SELECT DISTINCT A.BRANCH_ID FROM procurementitems A, enrichedtitles b
        WHERE
        A.enrichedtitle_id = b.ID
        AND b.isbnvalid = 'Y'
        AND
        /* ISBN and Supplier Details set */
        (
          b.isbn IS NOT NULL
          --AND b.title_id IS NOT NULL
          AND b.publisher_id IS NOT NULL
          AND b.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
          --AND nvl(A.supplier_id,-1) = nvl(supplier.supplier_id,-1)
          AND A.branch_id IS NOT NULL
          --AND b.author IS NOT NULL
        )
        AND
        /* PO Details not set */
        (a.po_number IS NULL)
      )
      LOOP
        FOR rec IN
        (SELECT A.ID FROM procurementitems A, enrichedtitles b
          WHERE
          A.enrichedtitle_id = b.ID
          AND b.isbnvalid = 'Y'
          AND
          /* ISBN and Supplier Details set */
          (
            b.isbn IS NOT NULL
            --AND b.title_id IS NOT NULL
            AND b.publisher_id IS NOT NULL
            AND b.publisher_id in (select id from publishers where nvl(group_id,-1) = nvl(grp.group_id,-1))
            --AND nvl(A.supplier_id,-1) = nvl(supplier.supplier_id,-1)
            AND A.branch_id IS NOT NULL
            --AND b.author IS NOT NULL
            and a.branch_id = brn.branch_id
          )
          AND
          /* PO Details not set */
          (a.po_number IS NULL)
        )
        loop
          /* Create Worklist */
          IF l_worklist_id IS NULL THEN
            l_worklist_id := fn_create_worklist('Procurement Items with PO not generated', NULL,p_procurement_id);
          END IF;
    
          /* Populate Items */
          l_worklist_item_id := fn_populate_workitem(l_worklist_id,rec.ID,
                                  'ProcurementItem', 'Open');
        END loop;
        l_worklist_id := NULL;
        l_worklist_item_id := NULL;      
      END loop;
      END LOOP;     
  END;
  
  /*PROCEDURE PR_CREATE_CANCELLED_WL
  IS
  BEGIN
    NULL;
  end;

  PROCEDURE PR_CREATE_EXPIRED_PO_WL
  IS
  BEGIN
    NULL;
  end;

  PROCEDURE PR_ISBN_ENRICHMENT_WL
  IS
  BEGIN
    NULL;
  end;

  PROCEDURE PR_CREATE_SUPP_ENRICHMENT_WL
  IS
  BEGIN
    NULL;
  end;

  PROCEDURE PR_CREATE_AVL_STOCK_WL
  IS
  BEGIN
    NULL;
  end;

  PROCEDURE PR_CREATE_NOT_AVL_STOCK_WL
  IS
  BEGIN
    NULL;
  end;*/
END worklist_generator;
/
 

--------------------------------------------------------
--  DDL for Procedure COMPRESS_NEWARRIVALS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "COMPRESS_NEWARRIVALS" 
(
  P_KEY_ID IN NUMBER  
) AS 
BEGIN
  UPDATE NEWARRIVALS_EXPANDED A 
  SET QTY = (SELECT SUM(QTY) FROM NEWARRIVALS_EXPANDED WHERE KEY_ID=A.KEY_ID AND ISBN = A.ISBN AND BRANCHID = A.BRANCHID) 
  WHERE isbn IN (SELECT isbn FROM newarrivals_expanded WHERE key_id=P_KEY_ID GROUP BY key_id, isbn, branchid HAVING count(*) > 1)
  and key_id=P_KEY_ID;
  
  DELETE FROM NEWARRIVALS_EXPANDED A WHERE 
  isbn IN (SELECT isbn FROM newarrivals_expanded WHERE key_id=P_KEY_ID GROUP BY key_id, isbn, branchid HAVING count(*) > 1)
  AND key_id=P_KEY_ID 
  AND ROWID NOT IN (SELECT MAX(ROWID) FROM newarrivals_expanded WHERE KEY_ID=A.KEY_ID AND ISBN = A.ISBN AND BRANCHID = A.BRANCHID); 

END COMPRESS_NEWARRIVALS;
 /
 

--------------------------------------------------------
--  DDL for Procedure DUPLICATE_PROCUREMENTITEMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "DUPLICATE_PROCUREMENTITEMS" AS 
  v_worklistid  worklist.ID%TYPE;
  
BEGIN
  FOR REC IN 
    (SELECT * FROM WORKLISTS WHERE ID IN
      (SELECT DISTINCT WORKLIST_ID FROM WORKITEMS WHERE REF_ID IN
        (SELECT ID FROM PROCUREMENTITEMS WHERE PO_NUMBER IS NULL)
      )
      AND ID BETWEEN 10028 AND 10059
    )
  LOOP
    SELECT worklists_seq.nextval INTO v_worklistid FROM dual;
    
    INSERT INTO worklists (ID, DESCRIPTION, STATUS, OPEN_DATE, TYPE, CREATED_BY, CREATED_AT, UPDATED_AT)
    VALUES (v_worklistid, 'Procurement Items with PO not generated', 'Open',sysdate, 'NSTR', 'SYSTEM', sysdate, sysdate);
    
    FOR v_workitems IN (
      SELECT * FROM WORKITEMS WHERE WORKLIST_ID = REC.ID
    )
    LOOP      
      INSERT INTO PROCUREMENTITEMS
        SELECT * FROM PROCUREMENTITEMS WHERE ID = v_workitems.ref_id
        RETURNING ;
      INSERT INTO WORKITEMS 
        SELECT WORKITEMS_SEQ.NEXTVAL, v_worklistid, 'ProcurementItem',
        
    END LOOP;   
  END LOOP;
END DUPLICATE_PROCUREMENTITEMS;
/
 

--------------------------------------------------------
--  DDL for Procedure EXPAND_NEWARRIVALS_ITEMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "EXPAND_NEWARRIVALS_ITEMS" 
(
  P_KEY_ID IN NUMBER  
) AS 
  V_NEWARRIVAL NEWARRIVALS_EXPANDED%ROWTYPE;
  v_new_id number := 0;
BEGIN
  BEGIN
  FOR rec IN (
    select * from corelist WHERE KEY_ID = P_KEY_ID
  )
  LOOP
    FOR cnt IN 1..rec.qty
    LOOP
      SELECT NEWARRIVALS_EXPANDED_SEQ.nextval INTO v_new_id FROM dual;
      
      V_NEWARRIVAL := NULL;     
      V_NEWARRIVAL.ISBN := rec.ISBN;
      V_NEWARRIVAL.TITLE := rec.TITLE;
      V_NEWARRIVAL.AUTHOR := rec.AUTHOR;
      V_NEWARRIVAL.PUBLISHER := rec.PUBLISHER;
      V_NEWARRIVAL.PUBLISHERCODE := rec.PUBLISHERCODE;
      V_NEWARRIVAL.PRICE := rec.PRICE;
      V_NEWARRIVAL.CURRENCY := rec.CURRENCY;
      V_NEWARRIVAL.CATEGORY := rec.CATEGORY;
      V_NEWARRIVAL.SUBCATEGORY := rec.SUBCATEGORY;
      V_NEWARRIVAL.QTY := 1;
      V_NEWARRIVAL.ID := v_new_id;
      V_NEWARRIVAL.KEY_ID := rec.KEY_ID;
      
      INSERT INTO NEWARRIVALS_EXPANDED
      values V_NEWARRIVAL;
    END LOOP;
  END LOOP;
end;
END EXPAND_NEWARRIVALS_ITEMS;
/
 

--------------------------------------------------------
--  DDL for Procedure PULL_SUPPLIER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PULL_SUPPLIER" 
(
  P_SUPPLIER_ID IN NUMBER  
) AS 
BEGIN
  FOR REC IN
  (
    SELECT * FROM SUPPLIERPROFILE@JBCLCLINK WHERE SUPPLIERCODE = P_SUPPLIER_ID
  )
  LOOP
    INSERT INTO suppliers
    VALUES(REC.SUPPLIERCODE,REC.SUPPLIERNAME,REC.SUPPLIERCONTACT,REC.SUPPLIERPHONE,REC.SUPPLIERCITY,REC.SUPPLYTYPE,REC.DISCOUNT,REC.CREDITPERIOD);
  END LOOP;
END PULL_SUPPLIER;
/
 

--------------------------------------------------------
--  DDL for Procedure REMOVE_DUPS_IN_CL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "REMOVE_DUPS_IN_CL" 
(
  P_KEY_ID IN NUMBER  
) AS 
BEGIN
  DELETE FROM CORELIST A WHERE 
  isbn IN (SELECT isbn FROM CORELIST WHERE key_id=P_KEY_ID GROUP BY key_id, isbn, branchid HAVING count(*) > 1)
  AND key_id=P_KEY_ID 
  AND ROWID NOT IN (SELECT MAX(ROWID) FROM CORELIST WHERE KEY_ID=A.KEY_ID AND ISBN = A.ISBN AND BRANCHID = A.BRANCHID); 

END REMOVE_DUPS_IN_CL;
 /
 






