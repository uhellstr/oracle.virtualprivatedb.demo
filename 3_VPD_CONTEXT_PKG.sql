DROP CONTEXT vpd_user_context;
DROP PUBLIC SYNONYM set_vpd_session_context_pkg;

CREATE CONTEXT vpd_user_context USING vpd_test.set_vpd_session_context_pkg;

CREATE OR REPLACE PACKAGE vpd_test.set_vpd_session_context_pkg AS
  PROCEDURE set_context;
END;
/

CREATE OR REPLACE PACKAGE BODY vpd_test.set_vpd_session_context_pkg IS
  PROCEDURE set_context IS
    v_ouser  VARCHAR2(30);
    v_id     NUMBER;
  begin
    DBMS_SESSION.set_context('VPD_USER_CONTEXT','SETUP','TRUE');
  
    v_ouser := SYS_CONTEXT('USERENV','SESSION_USER');
    
    -- Special handling for APEX
    if v_ouser in ('ANONYMOUS','APEX_PUBLIC_USER') then
      v_ouser := nvl(v('APP_USER'),USER);
    end if;
    
    begin
    
      SELECT company_id
      into   v_id
      from   vpd_test.vpd_users
      WHERE  username = v_ouser;
      
      dbms_session.set_context('VPD_USER_CONTEXT','USER_ID', v_id);
      
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_SESSION.set_context('VPD_USER_CONTEXT','USER_ID', 0);
    END;
    
    dbms_session.set_context('VPD_USER_CONTEXT','SETUP','FALSE');
    
  end set_context;
end set_vpd_session_context_pkg;
/
show errors

GRANT EXECUTE ON vpd_test.set_vpd_session_context_pkg TO PUBLIC;
CREATE PUBLIC SYNONYM set_vpd_session_context_pkg FOR vpd_test.set_vpd_session_context_pkg;
GRANT SELECT ON vpd_test.customer to VPD_DEMO;
GRANT SELECT ON vpd_test.company  to VPD_DEMO;
