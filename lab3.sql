set serveroutput on size 30000;

-- zad 1
CREATE TABLE DOKUMENTY (
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
);

-- zad 2
DECLARE
    tekst CLOB;
BEGIN
    tekst := '';
    FOR i IN 1..10000 LOOP
        tekst := tekst || 'Oto tekst. ';
    END LOOP;
    INSERT INTO DOKUMENTY VALUES (1, tekst);
END;

-- zad 3
-- a)
SELECT * FROM DOKUMENTY;
-- b)
SELECT UPPER(DOKUMENT) FROM DOKUMENTY;
-- c)
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;
-- d)
SELECT dbms_lob.getlength(DOKUMENT) FROM DOKUMENTY;
-- e)
SELECT SUBSTR(DOKUMENT, 5, 1000) FROM DOKUMENTY;
-- f)
SELECT dbms_lob.substr(DOKUMENT, 1000, 5) FROM DOKUMENTY;

-- zad 4
INSERT INTO DOKUMENTY VALUES (2, EMPTY_CLOB());

-- zad 5
INSERT INTO DOKUMENTY VALUES (3, NULL);
COMMIT;

-- zad 6
-- a)
SELECT * FROM DOKUMENTY;
-- b)
SELECT UPPER(DOKUMENT) FROM DOKUMENTY;
-- c)
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;
-- d)
SELECT dbms_lob.getlength(DOKUMENT) FROM DOKUMENTY;
-- e)
SELECT SUBSTR(DOKUMENT, 5, 1000) FROM DOKUMENTY;
-- f)
SELECT dbms_lob.substr(DOKUMENT, 1000, 5) FROM DOKUMENTY;

-- zad 7
DECLARE
-- 1)
    fil BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    clo CLOB;
    dest_offset NUMBER := 1;
    src_offset NUMBER := 1;
    bfile_csid NUMBER := 0;
    lang_contex NUMBER := 0;
    warn NUMBER := null;
BEGIN
-- 2)
    SELECT DOKUMENT INTO clo
    FROM DOKUMENTY
    WHERE ID = 2
    FOR UPDATE;
-- 3)
    dbms_lob.fileopen(fil);
    dbms_lob.loadclobfromfile(clo, fil, dbms_lob.getlength(fil), dest_offset, src_offset, bfile_csid, lang_contex, warn);    
    dbms_lob.fileclose(fil);
-- 4)
    COMMIT;
-- 5)
    dbms_output.put_line(warn);
END;

-- zad 8
UPDATE DOKUMENTY SET DOKUMENT = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt')) WHERE ID = 3;

-- zad 9
SELECT * FROM DOKUMENTY;

-- zad 10
SELECT ID, dbms_lob.getlength(DOKUMENT) FROM DOKUMENTY;

-- zad 11
DROP TABLE DOKUMENTY;

-- zad 12
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(clo IN OUT CLOB, tekst VARCHAR2) IS
    offset NUMBER := 1;
    dots VARCHAR2(32767); -- max długość stringa
BEGIN
    -- łańcuch kropek o długości tekstu do zmiany - bo jak się zrobi dbms_lob.write(..., '.'); to wywala 'out of range' 
    dots := RPAD('.', LENGTH(tekst), '.');  
    LOOP
        offset := dbms_lob.INSTR(LOB_LOC  => clo, PATTERN  => tekst, OFFSET  => 1, NTH  => 1);
        EXIT WHEN offset = 0;                        
        dbms_lob.write(clo, LENGTH(tekst), offset, dots);   
    END LOOP;          
    dbms_output.put_line(clo);   
END;
/
EXECUTE CLOB_CENSOR('TO JESTE TEST', 'TE');
-- wynik 'TO JES.. ..ST'

-- zad 13
CREATE TABLE BIOGRAPHIES AS SELECT * FROM ZTPD.BIOGRAPHIES;
SELECT * FROM BIOGRAPHIES;
/
DECLARE
    bio CLOB;
BEGIN
    SELECT BIO INTO bio
    FROM BIOGRAPHIES
    FOR UPDATE;

    CLOB_CENSOR(bio, 'Cimrman');
    COMMIT;
END;
/
SELECT * FROM BIOGRAPHIES;

-- zad 14
DROP TABLE BIOGRAPHIES;