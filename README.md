# oracle.virtualprivatedb.demo
Demonstration of using Virtual Private Database in Oracle 10 - 12c

This demo will work with Oracle 11g - 12c including multitenant and PDB's. VPD will not work with Oracle Express Edition that will throw ORA-00439: feature not enabled: Fine-grained access control

To setup use SQL*PLUS or SQLcl complaint client for the database version you want to try the demo for.

1. As SYS or INTERNAL run 1_SYS_VPD_USER.sql
2. As VPD_TEST (See file 1_SYS_VPD_USER.sql for password) run 2_VPD_SCHEMA.sql
   This will take a while since the script will insert 90 0000 rows of testdata
3. As VPD_TEST run 3_VPD_CONTEXT_PKG.sql
4. As SYS or INTERNAL run the script 4_SYS_LOGON_TRIGGER.sq
5. As VPD_TEST finnaly run 5_VPD_TEST_SECURITY_PKG.sql

This is the basic setup for testing out the functionality.

First either create a new schema (TRY_VPD) or use a previus schema already in use and grant select on vpd_test.company and the same privilige on the vpd_test.customer table to your schema of choise.

In your schema create views on vpd_test.company and vpd_test.customer tables as

create view v_customer as select * from vpd_test.customer;
create view v_company as select * from vpd_test.company;

Now, to verify that you have a CONTEXT session variable set in the same schema (TRY_VPD) you have priviliges to select and the views created in. Try to select the context settings as

select sys_context('VPD_USER_CONTEXT','USER_ID') from dual;

This should result in a '0' that means this user has no priviliges to query any rows in either table.
Verify the select priviliges by doing

select * from v_customer;
select * from v_company;

Neither view should return any rows at all.

To fix this and give the schema priviliges to the test schema (TRY_VPD) you have to add the priviliges in the table VPD_TEST.VPD_USER.

Add a row in that table (don't forget to commit) as in the exameple below (Remember to replace TRY_VPD with your own schema name)

TRY_VPD, 800

This will now set the privliges to select any data for customers belonging to company_id 800.

Now retry to select the context and select the views after reconnecting to the schema again and you should get data back from your queryies and a context set to 800.
