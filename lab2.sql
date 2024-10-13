-- zad 1
CREATE TABLE movies AS SELECT * FROM ZTPD.MOVIES;

-- zad 2
DESC movies;
SELECT * FROM movies;

-- zad 3
SELECT id, title FROM movies WHERE cover IS NULL;

-- zad 4
SELECT id, title, dbms_lob.getlength(cover) AS FILESIZE FROM movies WHERE cover IS NOT NULL;

-- zad 5
SELECT id, title, dbms_lob.getlength(cover) AS FILESIZE FROM movies WHERE cover IS NULL;

-- zad 6
SELECT DIRECTORY_NAME, DIRECTORY_PATH FROM ALL_DIRECTORIES WHERE DIRECTORY_NAME = 'TPD_DIR';

-- zad 7
UPDATE movies SET cover = EMPTY_BLOB(), mime_type = 'image/jpeg' WHERE id = 66;

-- zad 8
SELECT id, title, dbms_lob.getlength(cover) AS FILESIZE FROM movies WHERE id IN (65, 66);

-- zad 9
DECLARE
-- 1.
    fil BFILE := BFILENAME('TPD_DIR', 'escape.jpg');
    bl BLOB;
BEGIN
-- 2.
    SELECT cover INTO bl
    FROM movies
    WHERE id = 66
    FOR UPDATE; -- blokada wiersza

-- 3.
    dbms_lob.fileopen(fil);
    dbms_lob.loadfromfile(bl, fil, dbms_lob.getlength(fil));    
    dbms_lob.fileclose(fil);

-- 4.
    COMMIT;
END;


-- zad 10
CREATE TABLE TEMP_COVERS (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

-- zad 11
INSERT INTO TEMP_COVERS VALUES(65, BFILENAME('TPD_DIR', 'escape.jpg'), 'image/jpeg');
COMMIT;

-- zad 12
SELECT movie_id, dbms_lob.getlength(image) AS FILESIZE FROM TEMP_COVERS;

-- zad 13
DECLARE
-- 1.
    fil BFILE;
    bl BLOB;
    mime VARCHAR2(50);
BEGIN
    SELECT mime_type, image INTO mime, fil
    FROM TEMP_COVERS
    WHERE movie_id = 65; 

-- 2.
    dbms_lob.createtemporary(bl, TRUE);

-- 3.
    dbms_lob.fileopen(fil);
    dbms_lob.loadfromfile(bl, fil, dbms_lob.getlength(fil));    
    dbms_lob.fileclose(fil);

-- 4.
    UPDATE movies SET cover = bl, mime_type = mime WHERE id = 65; 

-- 5.
    dbms_lob.freetemporary(bl);

-- 6.
    COMMIT;
END;

-- zad 14
SELECT id AS MOVIE_ID, dbms_lob.getlength(cover) AS FILESIZE FROM movies WHERE id IN (65, 66);

-- zad 15
DROP TABLE movies;