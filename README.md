# oracle.virtualprivatedb.demo
Demonstration of using Virtual Private Database in Oracle 10 - 12c

This demo will work with Oracle 11g (including Oracle Express Edition) - 12c including multitenant and PDB's

To setup use SQL*PLUS or SQLcl complaint client for the database version you want to try the demo for.

1. As SYS or INTERNAL run 1_SYS_VPD_USER.sql
2. As VPD_TEST (See file 1_SYS_VPD_USER.sql for password) run 2_VPD_SCHEMA.sql
   This will take a while since the script will insert 90 0000 rows of testdata
3. As VPD_TEST run 3_VPD_CONTEXT_PKG.sql
4. As SYS or INTERNAL run the script 4_SYS_LOGON_TRIGGER.sq
5. As VPD_TEST finnaly run 5_VPD_TEST_SECURITY_PKG.sql

More to come...

