create or replace
PACKAGE BODY WORKLIST_GENERATOR AS
  v_no_supplier_wl_size number := 100; /* Worklist size for Supplier not set recprds*/
  v_no_supplier_wl_commit_size number := 100; /* Min size for Worklist creation */
  
  function fn_create_worklist
  return number is
    v_worklist        worklists%rowtype;
    v_worklist_id     PLS_INTEGER;
  begin
    SELECT WORKLISTS_SEQ.NEXTVAL INTO V_WORKLIST_ID FROM DUAL;
    V_WORKLIST.ID           := v_worklist_id;
    V_WORKLIST.DESCRIPTION  := 'Procurement Items with No Supplier Data';
    V_WORKLIST.STATUS       := 'Open';
    V_WORKLIST.OPEN_DATE    := SYSDATE;
    v_worklist.close_date   := null;
    V_WORKLIST.CREATED_BY   := 'SYSTEM';
    v_worklist.created_at   := sysdate;
    V_WORKLIST.UPDATED_AT   := SYSDATE;
    v_worklist.list_type    := null; --???    
    insert into worklists values v_worklist;
    
    return v_worklist_id;
  END fn_create_worklist;
  
  function fn_populate_worklist_item(pWorklistId IN NUMBER,
    pProcurementItemId IN NUMBER, pItemType IN VARCHAR2,
    pStatus IN VARCHAR2)
  return number is
    v_worklist_item         worklist_items%rowtype;
    v_worklist_item_id      number;
  begin
    select worklist_items_seq.nextval into v_worklist_item_id from dual;
    
    v_worklist_item.id                    := v_worklist_item_id;
    v_worklist_item.worklist_id           := pworklistid;
    v_worklist_item.procurement_item_id   := pprocurementitemid;
    v_worklist_item.item_type             := pitemtype;
    v_worklist_item.status                := pstatus;
    v_worklist_item.created_at            := sysdate;
    v_worklist_item.updated_at            := sysdate;
    insert into worklist_items values v_worklist_item;
    return v_worklist_item_id;
  end fn_populate_worklist_item;
  
  PROCEDURE PR_CREATE_NO_SUPP_WL
  is
    v_worklist_item       worklist_items%rowtype;
    
    l_worklist_id         number := null;
    l_worklist_item_id    number := null;
  BEGIN
    FOR rec IN
    (SELECT A.ID FROM PROCUREMENT_ITEMS A, ENRICHED_TITLES B
      WHERE 
      A.TITLE_ID = B.TITLE_ID
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
      AND ROWNUM <= v_no_supplier_wl_size
    )
    loop
      /* Create Worklist */
      if l_worklist_id is null then
        l_worklist_id := fn_create_worklist;
      end if;
      
      /* Populate Items */
      l_worklist_item_id := fn_populate_worklist_item(l_worklist_id,rec.id, 
                              'IBTR', 'Open');
    END LOOP;
  END;
    
  PROCEDURE PR_INIT
  IS
  BEGIN
    PR_CREATE_NO_SUPP_WL;
  END;
  
  /*PROCEDURE PR_CREATE_CANCELLED_WL
  IS
  BEGIN
    NULL;
  end;
  
  PROCEDURE PR_CREATE_NO_ISBN_WL
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
END WORKLIST_GENERATOR;
