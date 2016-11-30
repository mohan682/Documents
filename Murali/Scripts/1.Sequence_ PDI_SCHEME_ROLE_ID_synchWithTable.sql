 DECLARE
    maxid NUMBER;
    maxseq NUMBER;
   -- temp  NUMBER;  -- without this variable Oracle would skip to query the sequence
BEGIN
    SELECT MAX(PDI_SCHEME_ROLE_ID) INTO maxid FROM PDI_SCHEME_ROLE;
    
    SELECT PDI_SCHEME_ROLE_ID_SEQ.NEXTVAL INTO maxseq FROM DUAL;
    
    while (maxseq=maxid) loop
     SELECT PDI_SCHEME_ROLE_ID_SEQ.NEXTVAL INTO maxseq FROM DUAL;
    end loop;
END;