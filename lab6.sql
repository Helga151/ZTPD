-- zad 1.A
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
and prior t.owner = t.owner;

-- zad 1.B
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

-- zad 1.C
CREATE TABLE MYST_MAJOR_CITIES (
FIPS_CNTRY VARCHAR2(2),
CITY_NAME VARCHAR2(40),
STGEOM ST_POINT );

-- zad 1.D
SELECT * FROM MAJOR_CITIES;
DESC MAJOR_CITIES;

INSERT INTO MYST_MAJOR_CITIES
SELECT C.FIPS_CNTRY, C.CITY_NAME, 
    TREAT(ST_POINT.FROM_SDO_GEOM(C.GEOM) AS ST_POINT) STGEOM
FROM MAJOR_CITIES C;

SELECT * FROM MYST_MAJOR_CITIES;
-- zad 2.A
INSERT INTO MYST_MAJOR_CITIES
VALUES('PL', 'Szczyrk', ST_POINT(19.036107, 49.718655, 8307));

-- zad 3.A
CREATE TABLE MYST_COUNTRY_BOUNDARIES (
FIPS_CNTRY VARCHAR2(2),
CNTRY_NAME VARCHAR2(40),
STGEOM ST_MULTIPOLYGON );

-- zad 3.B
SELECT * FROM COUNTRY_BOUNDARIES;

INSERT INTO MYST_COUNTRY_BOUNDARIES
SELECT C.FIPS_CNTRY, C.CNTRY_NAME, ST_MULTIPOLYGON(C.GEOM)
FROM COUNTRY_BOUNDARIES C;

-- zad 3.C
SELECT B.STGEOM.ST_GEOMETRYTYPE() AS TYP_OBIEKTU, 
    COUNT(B.STGEOM.ST_GEOMETRYTYPE())  AS ILE
FROM MYST_COUNTRY_BOUNDARIES B
GROUP BY B.STGEOM.ST_GEOMETRYTYPE()
ORDER BY B.STGEOM.ST_GEOMETRYTYPE();

-- zad 3.D
SELECT B.STGEOM.ST_ISSIMPLE()
FROM MYST_COUNTRY_BOUNDARIES B;

-- zad 4.A
SELECT B.CNTRY_NAME, COUNT(*)
FROM MYST_MAJOR_CITIES C, MYST_COUNTRY_BOUNDARIES B
WHERE B.STGEOM.ST_CONTAINS(C.STGEOM) = 1
GROUP BY B.CNTRY_NAME;

-- zad 4.B
SELECT A.CNTRY_NAME AS A_NAME, B.CNTRY_NAME AS B_NAME
FROM MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
WHERE B.CNTRY_NAME = 'Czech Republic' AND
      B.STGEOM.ST_TOUCHES(A.STGEOM) = 1;

-- zad 4.C
SELECT * FROM RIVERS;

SELECT DISTINCT B.CNTRY_NAME, A.NAME
FROM RIVERS A, MYST_COUNTRY_BOUNDARIES B
WHERE B.CNTRY_NAME = 'Czech Republic' AND
      B.STGEOM.ST_CROSSES(ST_LINESTRING(A.GEOM)) = 1;

-- zad 4.D
SELECT TREAT(A.STGEOM.ST_UNION(B.STGEOM) AS ST_POLYGON).ST_AREA() POWIERZCHNIA
FROM MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
WHERE B.CNTRY_NAME = 'Czech Republic' AND
      A.CNTRY_NAME = 'Slovakia';

-- zad 4.E
SELECT B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)) AS OBIEKT, 
    B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)).ST_GEOMETRYTYPE() WEGRY_BEZ
FROM MYST_COUNTRY_BOUNDARIES B, WATER_BODIES W
WHERE B.CNTRY_NAME = 'Hungary' AND
      W.NAME = 'Balaton';

-- zad 5.A
EXPLAIN PLAN FOR
    SELECT B.CNTRY_NAME, COUNT(*)
    FROM MYST_MAJOR_CITIES C, MYST_COUNTRY_BOUNDARIES B
    WHERE SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE' AND
        B.CNTRY_NAME = 'Poland'
    GROUP BY B.CNTRY_NAME;

SELECT plan_table_output FROM TABLE(dbms_xplan.display('plan_table', null, 'basic'));

-- zad 5.B
INSERT INTO USER_SDO_GEOM_METADATA
SELECT 'MYST_MAJOR_CITIES', 'STGEOM', T.DIMINFO, T.SRID
FROM ALL_SDO_GEOM_METADATA T
WHERE T.TABLE_NAME = 'MAJOR_CITIES';

-- zad 5.C
CREATE INDEX MYST_MAJOR_CITIES_IDX ON MYST_MAJOR_CITIES(STGEOM)
indextype IS MDSYS.SPATIAL_INDEX;

-- zad 5.D
EXPLAIN PLAN FOR
    SELECT B.CNTRY_NAME, COUNT(*)
    FROM MYST_MAJOR_CITIES C, MYST_COUNTRY_BOUNDARIES B
    WHERE SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE' AND
        B.CNTRY_NAME = 'Poland'
    GROUP BY B.CNTRY_NAME;

SELECT plan_table_output FROM TABLE(dbms_xplan.display('plan_table', null, 'basic'));

DROP TABLE MYST_MAJOR_CITIES;
DROP TABLE MYST_COUNTRY_BOUNDARIES;