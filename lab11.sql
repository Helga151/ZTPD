-- Operator CONTAINS - Podstawy
-- zad 1
CREATE TABLE CYTATY_1 AS
SELECT * FROM ZTPD.CYTATY;

-- zad 2
SELECT *
FROM CYTATY_1
WHERE UPPER(TEKST) LIKE UPPER('%optymista%') OR
      UPPER(TEKST) LIKE UPPER('%pesymista%');

-- zad 3
CREATE INDEX text_idx ON CYTATY_1(TEKST) INDEXTYPE IS CTXSYS.CONTEXT;

-- zad 4
SELECT *
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'optymista or pesymista') > 0;

-- zad 5
SELECT *
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'pesymista not optymista') > 0;

-- zad 6
SELECT *
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'pesymista and optymista') > 0
  AND CONTAINS(TEKST, 'pesymista and optymista') < 3;

-- zad 7
SELECT *
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'pesymista and optymista') > 0
  AND CONTAINS(TEKST, 'pesymista and optymista') < 10;

-- zad 8
SELECT *
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'życi%') > 0;

-- zad 9
SELECT AUTOR, TEKST, CONTAINS(TEKST, 'życi%') AS DOPASOWANIE
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'życi%') > 0;

-- zad 10
SELECT AUTOR, TEKST, CONTAINS(TEKST, 'życi%') AS DOPASOWANIE
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'życi%') > 0
ORDER BY CONTAINS(TEKST, 'życi%') DESC
FETCH FIRST 1 ROWS ONLY;

-- zad 11
SELECT *
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'fuzzy(probelm)') > 0;

-- zad 12
INSERT INTO CYTATY_1 VALUES (39, 'Bertrand Russell', 'To smutne, że głupcy są tacy pewni
siebie, a ludzie rozsądni tacy pełni wątpliwości.');
COMMIT;

-- zad 13
SELECT *
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'głupcy') > 0;

-- zad 14
SELECT token_text FROM DR$TEXT_IDX$I
WHERE token_text = 'GŁUPCY';

-- zad 15
DROP INDEX text_idx;
CREATE INDEX text_idx ON CYTATY_1(TEKST) INDEXTYPE IS CTXSYS.CONTEXT;

-- zad 16
SELECT token_text FROM DR$TEXT_IDX$I
WHERE token_text = 'GŁUPCY';

SELECT *
FROM CYTATY_1
WHERE CONTAINS(TEKST, 'głupcy') > 0;

-- zad 17
DROP INDEX text_idx;
DROP TABLE CYTATY_1;

-- Zaawansowane indeksowanie i wyszukiwanie
-- zad 1
CREATE TABLE QUOTES_1 AS
SELECT * FROM ZTPD.QUOTES;

-- zad 2
CREATE INDEX text_idx ON QUOTES_1(TEXT) INDEXTYPE IS CTXSYS.CONTEXT;

-- zad 3
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, 'work') > 0;

SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, '$work') > 0;

SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, 'working') > 0;

SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, '$working') > 0;

-- zad 4
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, 'it') > 0;

-- zad 5
SELECT *
FROM CTX_STOPLISTS;

-- zad 6
SELECT *
FROM CTX_STOPWORDS;

-- zad 7
DROP INDEX text_idx;
CREATE INDEX text_idx ON QUOTES_1(TEXT) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST');

-- zad 8
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, 'it') > 0;

-- zad 9
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, 'fool and humans') > 0;

-- zad 10
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, 'fool and computer') > 0;

-- zad 11
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, '(fool and humans) WITHIN SENTENCE') > 0;

-- zad 12
DROP INDEX text_idx;

-- zad 13
begin
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;

-- zad 14
CREATE INDEX group_idx ON QUOTES_1(TEXT) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('section group nullgroup');

-- zad 15
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, '(fool and humans) WITHIN SENTENCE') > 0;

SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, '(fool and computer) WITHIN SENTENCE') > 0;

-- zad 16
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, 'humans') > 0;

-- zad 17
DROP INDEX group_idx;

begin
    ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m','printjoins', '-');
end;

CREATE INDEX lex_idx ON QUOTES_1(TEXT) INDEXTYPE IS CTXSYS.CONTEXT PARAMETERS ('LEXER lex_z_m');

-- zad 18
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, 'humans') > 0;

-- zad 19
SELECT *
FROM QUOTES_1
WHERE CONTAINS(TEXT, 'non\-humans') > 0;

-- zad 20
DROP TABLE QUOTES_1;
BEGIN
    CTX_DDL.DROP_SECTION_GROUP('nullgroup');
    CTX_DDL.DROP_PREFERENCE('lex_z_m');
END;