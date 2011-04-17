--------------------------------------------------------
--  DDL for Sequence BOXES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "BOXES_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 CACHE 20 NOORDER  NOCYCLE ;
 
--------------------------------------------------------
--  DDL for Sequence CRATES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "CRATES_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 CACHE 20 NOORDER  NOCYCLE ;
 
--------------------------------------------------------
--  DDL for Table BOXES
--------------------------------------------------------

  CREATE TABLE "BOXES" 
   (	"ID" NUMBER(38,0), 
	"BOX_NO" NUMBER(38,0), 
	"PO_NO" VARCHAR2(255 CHAR), 
	"INVOICE_NO" VARCHAR2(255 CHAR), 
	"TOTAL_CNT" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE, 
	"CRATE_ID" NUMBER(38,0)
   ) ;
 
--------------------------------------------------------
--  Constraints for Table BOXES
--------------------------------------------------------

  ALTER TABLE "BOXES" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "BOXES" ADD PRIMARY KEY ("ID") ENABLE;
 
--------------------------------------------------------
--  DDL for Table CRATES
--------------------------------------------------------

  CREATE TABLE "CRATES" 
   (	"ID" NUMBER(38,0), 
	"PO_NO" VARCHAR2(255 CHAR), 
	"INVOICE_NO" VARCHAR2(255 CHAR), 
	"TOTAL_CNT" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE
   ) ;
 
--------------------------------------------------------
--  Constraints for Table CRATES
--------------------------------------------------------

  ALTER TABLE "CRATES" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "CRATES" ADD PRIMARY KEY ("ID") ENABLE;
