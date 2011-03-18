create or replace
PACKAGE body data_pull
as
  /* Master Values */
  v_procurement_branch_id NUMBER            := 951;
  v_procurement_pull_status VARCHAR2(255)   := 'Assigned';
  v_days_before NUMBER                      := 3;
  
  PROCEDURE PR_PULL_IBTR_ITEMS
  IS
    v_procurement_item PROCUREMENT_ITEMS%ROWTYPE;
    v_enriched_title ENRICHED_TITLES%ROWTYPE;
    v_enriched_title_version ENRICHED_TITLE_VERSIONS%ROWTYPE;
    
    v_title titles.title@jbclclink%type;
    v_titleid titles.titleid@jbclclink%type;
    v_authorid titles.authorid@jbclclink%type;
    v_publisherid titles.publisherid@jbclclink%type;
    v_isbn_10 titles.isbn_10@jbclclink%type;
    v_isbn_13 titles.isbn_13@jbclclink%type;
    v_language titles.language@jbclclink%type;
    v_category titles.category@jbclclink%type;
    
    v_procurement_item_id       NUMBER;
    v_enriched_title_id         NUMBER;
    v_enriched_title_version_id NUMBER;
    
    l_count NUMBER := 0;
  BEGIN
    for rec in
    (
      SELECT  *
      from ibtrs@link_opac
      WHERE RESPONDENT_ID                  = v_procurement_branch_id
      AND state                            = v_procurement_pull_status
      AND TO_CHAR(created_at, 'DD-MON-RR') = TO_CHAR(sysdate-v_days_before, 'DD-MON-RR')
    )
    loop
      select count(1) into l_count from enriched_titles
        where title_id = rec.title_id;
      IF(L_COUNT < 1) THEN
                
        /* Enriched Titles */
        select titleid,title,authorid,publisherid,isbn_10,isbn_13,language,category
        into v_titleid,v_title,v_authorid,v_publisherid,v_isbn_10,v_isbn_13,v_language,v_category
        FROM titles@jbclclink
        where titleid = rec.title_id;
        
        select enriched_titles_seq.nextval into v_enriched_title_id from dual;
        v_enriched_title              := null;
        v_enriched_title.id           := v_enriched_title_id;
        v_enriched_title.title_id     := v_titleid;
        v_enriched_title.title        := v_title;
        v_enriched_title.author_id    := v_authorid;
        v_enriched_title.publisher_id := v_publisherid;
        v_enriched_title.isbn         := v_isbn_13;
        v_enriched_title.language     := v_language;
        v_enriched_title.category     := v_category;
        v_enriched_title.isbn10       := v_isbn_10;
        v_enriched_title.version      := 1;
        v_enriched_title.created_at   := sysdate;
        v_enriched_title.updated_at   := sysdate;
        insert into enriched_titles values v_enriched_title;
        
        /* Enriched Titles Version*/
        SELECT ENRICHED_TITLE_VERSIONS_SEQ.nextval
        INTO v_enriched_title_version_id
        from dual;
        v_enriched_title_version                   := null;
        v_enriched_title_version.id                := v_enriched_title_version_id;
        v_enriched_title_version.enriched_title_id := v_enriched_title_id;
        v_enriched_title_version.version           := 1;
        v_enriched_title_version.title_id          := v_titleid;
        v_enriched_title_version.title             := v_title;
        v_enriched_title_version.author_id         := v_authorid;
        v_enriched_title_version.publisher_id      := v_publisherid;
        v_enriched_title_version.isbn              := v_isbn_13;
        v_enriched_title_version.language          := v_language;
        v_enriched_title_version.category          := v_category;
        v_enriched_title_version.isbn10            := v_isbn_10;
        v_enriched_title_version.created_at        := sysdate;
        v_enriched_title_version.updated_at        := sysdate;
        insert into enriched_title_versions values v_enriched_title_version;        
      end if;
      
      /* Procurement Items */
      SELECT procurement_items_seq.nextval
      INTO v_procurement_item_id
      from dual;
      v_procurement_item                  := NULL;
      v_procurement_item.id               := v_procurement_item_id;
      v_procurement_item.source           := 'IBTR';
      v_procurement_item.source_id        := 1;
      v_procurement_item.title_id         := rec.title_id;
      v_procurement_item.isbn             := v_isbn_13;
      v_procurement_item.status           := 'Assigned';
      v_procurement_item.last_action_date := sysdate;
      v_procurement_item.created_at       := sysdate;
      v_procurement_item.updated_at       := sysdate;
      insert into procurement_items values v_procurement_item;
      
    END LOOP;
  END;
  
  PROCEDURE pr_init_data_pull IS
  BEGIN
    PR_PULL_IBTR_ITEMS;
  END;
END DATA_PULL;
