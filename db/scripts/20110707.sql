--------------------------------------------------------
--  DDL for Sequence LISTITEMS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "LISTITEMS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 CACHE 20 NOORDER  NOCYCLE ;
 

--------------------------------------------------------
--  DDL for Sequence LISTS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "LISTS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 CACHE 20 NOORDER  NOCYCLE ;
 

--------------------------------------------------------
--  DDL for Sequence LIST_STAGINGS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "LIST_STAGINGS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 CACHE 20 NOORDER  NOCYCLE ;
 
--------------------------------------------------------
--  DDL for Table LISTITEMS
--------------------------------------------------------

  CREATE TABLE "LISTITEMS" 
   (	"ID" NUMBER(38,0), 
	"ISBN" VARCHAR2(255 CHAR), 
	"TITLE" VARCHAR2(255 CHAR), 
	"AUTHOR" VARCHAR2(255 CHAR), 
	"PUBLISHER" VARCHAR2(255 CHAR), 
	"PUBLISHER_ID" NUMBER(38,0), 
	"QUANTITY" NUMBER(38,0), 
	"LISTPRICE" NUMBER, 
	"CURRENCY" VARCHAR2(255 CHAR), 
	"CATEGORY" VARCHAR2(255 CHAR), 
	"SUBCATEGORY" VARCHAR2(255 CHAR), 
	"BRANCH_ID" NUMBER(38,0), 
	"CREATED_BY" NUMBER(38,0), 
	"MODIFIED_BY" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE, 
	"ERROR" VARCHAR2(255 CHAR), 
	"PULLED" VARCHAR2(255 CHAR), 
	"LIST_ID" NUMBER(38,0)
   ) ;
 
--------------------------------------------------------
--  Constraints for Table LISTITEMS
--------------------------------------------------------

  ALTER TABLE "LISTITEMS" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "LISTITEMS" ADD PRIMARY KEY ("ID") ENABLE;
 
--------------------------------------------------------
--  DDL for Table LISTS
--------------------------------------------------------

  CREATE TABLE "LISTS" 
   (	"ID" NUMBER(38,0), 
	"NAME" VARCHAR2(255 CHAR), 
	"KIND" VARCHAR2(255 CHAR), 
	"KEY" NUMBER(38,0), 
	"PULLED" VARCHAR2(255 CHAR), 
	"CREATED_BY" NUMBER(38,0), 
	"MODIFIED_BY" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE
   ) ;
 
--------------------------------------------------------
--  Constraints for Table LISTS
--------------------------------------------------------

  ALTER TABLE "LISTS" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "LISTS" ADD PRIMARY KEY ("ID") ENABLE;
 
--------------------------------------------------------
--  DDL for Table LIST_STAGINGS
--------------------------------------------------------

  CREATE TABLE "LIST_STAGINGS" 
   (	"ID" NUMBER(38,0), 
	"ISBN" VARCHAR2(255 CHAR), 
	"TITLE" VARCHAR2(255 CHAR), 
	"AUTHOR" VARCHAR2(255 CHAR), 
	"PUBLISHER" VARCHAR2(255 CHAR), 
	"PUBLISHER_ID" VARCHAR2(255 CHAR), 
	"QUANTITY" NUMBER(38,0), 
	"LISTPRICE" NUMBER, 
	"CURRENCY" VARCHAR2(255 CHAR), 
	"CATEGORY" VARCHAR2(255 CHAR), 
	"SUBCATEGORY" VARCHAR2(255 CHAR), 
	"BRANCH_ID" NUMBER(38,0), 
	"ERROR" VARCHAR2(255 CHAR), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE, 
	"LIST_ID" NUMBER(38,0), 
	"CREATED_BY" NUMBER(38,0)
   ) ;
 
--------------------------------------------------------
--  Constraints for Table LIST_STAGINGS
--------------------------------------------------------

  ALTER TABLE "LIST_STAGINGS" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "LIST_STAGINGS" ADD PRIMARY KEY ("ID") ENABLE;
 
--------------------------------------------------------
--  DDL for Package DATA_PULL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "DATA_PULL" AS
  PROCEDURE pr_pull_ibtr_items;
  FUNCTION pull_ibtr_items(p_procurement_id NUMBER) RETURN NUMBER;
  FUNCTION pull_nent_items(p_procurement_id NUMBER, p_list_id NUMBER) RETURN NUMBER;
  
  FUNCTION get_ibtr_items_count RETURN NUMBER;
  PROCEDURE pr_init_data_pull;
  PROCEDURE pr_pull_corelist_items (p_key_id number);
  PROCEDURE pr_pull_newarrival_items (p_key_id NUMBER);
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
  PROCEDURE generate_nent_wl(p_procurement_id NUMBER);
  PROCEDURE regenerate_nent_wl(p_procurement_id NUMBER);
  PROCEDURE pr_create_corelist_wl;
  PROCEDURE pr_create_newentry_wl;
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

  FUNCTION pull_nent_items(p_procurement_id NUMBER, p_list_id NUMBER) 
  RETURN NUMBER
  AS
    v_procurement_item procurementitems%rowtype;
    v_enriched_title enrichedtitles%rowtype;
    v_enriched_title_version enrichedtitle_versions%rowtype;
    v_procurement_item_id       NUMBER;
    v_enriched_title_id         NUMBER;
    v_enriched_title_version_id NUMBER;
    l_count                     NUMBER := 0;    
  BEGIN
    FOR rec IN
    (
      SELECT *
      FROM LISTITEMS 
      WHERE LIST_ID = p_list_id
    )
    loop      
      BEGIN
        --Find by ISBN
        SELECT ID 
        INTO v_enriched_title_id 
        FROM enrichedtitles
        WHERE isbn = rec.isbn OR isbn10 = rec.isbn;
      EXCEPTION
      WHEN no_data_found THEN
        v_enriched_title_id := NULL;
      END;
      
      IF(v_enriched_title_id IS NULL) THEN
        /* Enriched Titles */
        SELECT enrichedtitles_seq.nextval 
        INTO v_enriched_title_id 
        FROM dual;
        v_enriched_title              := NULL;
        v_enriched_title.ID           := v_enriched_title_id;
        v_enriched_title.title_id     := NULL;
        v_enriched_title.title        := rec.title;
        v_enriched_title.author       := rec.author;
        v_enriched_title.isbn         := rec.isbn;
        v_enriched_title.language     := NULL;
        v_enriched_title.CATEGORY     := rec.CATEGORY;
        v_enriched_title.SUBCATEGORY  := rec.subcategory;
        v_enriched_title.isbn10       := NULL;
        v_enriched_title.listprice    := rec.listprice;
        v_enriched_title.currency     := rec.currency;
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
        v_enriched_title_version.language         := NULL;
        v_enriched_title_version.CATEGORY         := rec.CATEGORY;
        v_enriched_title_version.SUBCATEGORY      := rec.subcategory;
        v_enriched_title_version.listprice        := rec.listprice;
        v_enriched_title_version.currency         := rec.currency;
        v_enriched_title_version.isbn10           := null;
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
      v_procurement_item.SOURCE           := 'NENT';
      v_procurement_item.source_id        := rec.id;
      v_procurement_item.enrichedtitle_id := v_enriched_title_id;
      v_procurement_item.branch_id        := rec.branch_id;
      v_procurement_item.member_id        := NULL;
      v_procurement_item.isbn             := rec.isbn;
      v_procurement_item.status           := 'Assigned';
      v_procurement_item.last_action_date := SYSDATE;
      v_procurement_item.created_at       := SYSDATE;
      v_procurement_item.updated_at       := SYSDATE;
      v_procurement_item.procured_cnt     := 0;
      v_procurement_item.received_cnt     := 0;
      v_procurement_item.procurement_id   := p_procurement_id;
      v_procurement_item.title_id         := NULL;
      v_procurement_item.quantity         := rec.quantity;
      INSERT INTO procurementitems VALUES v_procurement_item;
      l_count := l_count + 1;
    END loop;
    
    --Update Pulled status for List
    UPDATE LISTS SET PULLED = 'Y' WHERE ID = p_list_id;
    
    return l_count;
  END pull_nent_items;
  
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
        AND c.title IS NOT NULL
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
          AND c.title IS NOT NULL
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
            AND c.title IS NOT NULL
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
              AND c.title IS NOT NULL
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
                AND c.title IS NOT NULL
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
                  AND c.title IS NOT NULL
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
    OutputRecord := 'PO_NO,TITLE,ISBN,AUTHOR,PUBLISHERNAME,SUPPLIER,QUANTITY,LISTPRICE,CURRENCY,CONV_RATE,INRPRICE,DISCOUNT,COSTPRICE';
    utl_file.put_line(Outputfile, OutputRecord);
    FOR REC IN
    (
      SELECT * FROM PO_VIEW WHERE PO_NO = P_PO_NUMBER
    )
    LOOP
      OutputRecord := REC.PO_NO || ',"' ||  REC.TITLE || '","' || REC.ISBN || '","' || REC.AUTHOR || '","' || REC.PUBLISHERNAME || '","' || 
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
        AND b.title IS NOT NULL
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

  PROCEDURE generate_nent_wl(p_procurement_id NUMBER)
  IS
  BEGIN
    pr_create_no_isbn_wl(p_procurement_id);
    pr_invalid_isbn_wl(p_procurement_id);
    pr_create_details_not_enriched(p_procurement_id);
    pr_create_no_supp_det_wl(p_procurement_id);
  END;
  
  PROCEDURE regenerate_nent_wl(p_procurement_id NUMBER)
  IS
  BEGIN
    if (fn_clear_current_worklists(p_procurement_id)) then
      pr_create_no_isbn_wl(p_procurement_id);
      pr_invalid_isbn_wl(p_procurement_id);
      pr_create_details_not_enriched(p_procurement_id);
      pr_create_no_supp_det_wl(p_procurement_id);
    END IF;
  END;
  
  PROCEDURE pr_create_corelist_wl
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
              l_worklist_id := fn_create_worklist('Procurement Items with PO not generated', NULL, 0);
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
  
  PROCEDURE pr_create_newentry_wl
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
            l_worklist_id := fn_create_worklist('Procurement Items with PO not generated', NULL,0);
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
 