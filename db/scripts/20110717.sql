--------------------------------------------------------
--  DDL for Sequence CURRENCIES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "CURRENCIES_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10020 CACHE 20 NOORDER  NOCYCLE ;
 

--------------------------------------------------------
--  DDL for Sequence CURRENCYRATES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "CURRENCYRATES_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 CACHE 20 NOORDER  NOCYCLE ;
 

--------------------------------------------------------
--  DDL for Table CURRENCIES
--------------------------------------------------------

  CREATE TABLE "CURRENCIES" 
   (	"ID" NUMBER(38,0), 
	"NAME" VARCHAR2(255 CHAR), 
	"CODE" VARCHAR2(255 CHAR), 
	"CREATED_BY" NUMBER(38,0), 
	"MODIFIED_BY" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE
   ) ;
 

--------------------------------------------------------
--  Constraints for Table CURRENCIES
--------------------------------------------------------

  ALTER TABLE "CURRENCIES" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "CURRENCIES" ADD PRIMARY KEY ("ID") ENABLE;
 

--------------------------------------------------------
--  DDL for Table CURRENCYRATES
--------------------------------------------------------

  CREATE TABLE "CURRENCYRATES" 
   (	"ID" NUMBER(38,0), 
	"CODE1" VARCHAR2(255 CHAR), 
	"CODE2" VARCHAR2(255 CHAR), 
	"RATE" NUMBER, 
	"EFFECTIVE_FROM" DATE, 
	"CREATED_BY" NUMBER(38,0), 
	"MODIFIED_BY" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE
   ) ;
 

--------------------------------------------------------
--  Constraints for Table CURRENCYRATES
--------------------------------------------------------

  ALTER TABLE "CURRENCYRATES" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "CURRENCYRATES" ADD PRIMARY KEY ("ID") ENABLE;
 
--------------------------------------------------------
--  DDL for Index INDEX_CURRENCIES_ON_CODE
--------------------------------------------------------

  CREATE UNIQUE INDEX "INDEX_CURRENCIES_ON_CODE" ON "CURRENCIES" ("CODE") 
  ;