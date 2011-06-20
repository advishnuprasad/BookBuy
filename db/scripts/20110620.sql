--------------------------------------------------------
--  DDL for Sequence CSV_STAGES_SEQ
--------------------------------------------------------

CREATE SEQUENCE  "CSV_STAGES_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10040 CACHE 20 NOORDER  NOCYCLE ;

--------------------------------------------------------
--  DDL for Sequence INVOICEITEMS_SEQ
--------------------------------------------------------

CREATE SEQUENCE  "INVOICEITEMS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10040 CACHE 20 NOORDER  NOCYCLE ;

--------------------------------------------------------
--  DDL for Table CSV_STAGES
--------------------------------------------------------

  CREATE TABLE "CSV_STAGES" 
   (	"ID" NUMBER(38,0), 
	"INVOICE_ID" NUMBER(38,0), 
	"QUANTITY" NUMBER(38,0), 
	"AUTHOR" VARCHAR2(255 CHAR), 
	"TITLE" VARCHAR2(255 CHAR), 
	"ISBN" VARCHAR2(255 CHAR), 
	"PUBLISHER" VARCHAR2(255 CHAR), 
	"CURRENCY" VARCHAR2(255 CHAR), 
	"UNIT_PRICE" NUMBER, 
	"UNIT_PRICE_INR" NUMBER, 
	"CONV_RATE" NUMBER, 
	"DISCOUNT" NUMBER, 
	"NET_AMOUNT" NUMBER, 
	"USER_ID" NUMBER(38,0), 
	"ERROR" VARCHAR2(255 CHAR), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE
   ) ;

--------------------------------------------------------
--  Constraints for Table CSV_STAGES
--------------------------------------------------------

  ALTER TABLE "CSV_STAGES" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "CSV_STAGES" ADD PRIMARY KEY ("ID") ENABLE;
 





--------------------------------------------------------
--  DDL for Table INVOICEITEMS
--------------------------------------------------------

  CREATE TABLE "INVOICEITEMS" 
   (	"ID" NUMBER(38,0), 
	"INVOICE_ID" NUMBER(38,0), 
	"QUANTITY" NUMBER(38,0), 
	"AUTHOR" VARCHAR2(255 CHAR), 
	"TITLE" VARCHAR2(255 CHAR), 
	"ISBN" VARCHAR2(255 CHAR), 
	"PUBLISHER" VARCHAR2(255 CHAR), 
	"CURRENCY" VARCHAR2(255 CHAR), 
	"UNIT_PRICE" NUMBER, 
	"UNIT_PRICE_INR" NUMBER, 
	"CONV_RATE" NUMBER, 
	"DISCOUNT" NUMBER, 
	"NET_AMOUNT" NUMBER, 
	"USER_ID" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE
   ) ;
 
--------------------------------------------------------
--  Constraints for Table INVOICEITEMS
--------------------------------------------------------

  ALTER TABLE "INVOICEITEMS" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "INVOICEITEMS" ADD PRIMARY KEY ("ID") ENABLE;