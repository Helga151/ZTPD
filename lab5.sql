-- zad 1A
INSERT INTO USER_SDO_GEOM_METADATA
VALUES ('FIGURY','KSZTALT', MDSYS.SDO_DIM_ARRAY(
    MDSYS.SDO_DIM_ELEMENT('X', 0, 10, 0.01),
    MDSYS.SDO_DIM_ELEMENT('Y', 0, 8, 0.01) ),
    null
);

-- zad 1B
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(NUMBER_OF_GEOMS  => 3000000,
                                   DB_BLOCK_SIZE  => 8192,
                                   SDO_RTR_PCTFREE  => 10,
                                   NUM_DIMENSIONS  => 2,
                                   IS_GEODETIC  => 0)
FROM FIGURY;

-- zad 1C
CREATE INDEX figura_idx ON FIGURY(KSZTALT) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

-- zad 1D
-- wynik nie odpowiada rzeczywistości. Z punktem (3,3) powiązany jest tylko kwadrat, czyli figura 2
-- to jest spowodowany przez wykonanie tylko pierwszej fazy przetwarzania - wyznaczenie zbioru kandydatów
select ID
from FIGURY
where SDO_FILTER(KSZTALT,
    SDO_GEOMETRY(2001,null,
        SDO_POINT_TYPE(3,3,null),
        null,null)) = 'TRUE';

-- zad 1E
-- wynik jest poprawny
select ID
from FIGURY
where SDO_RELATE(KSZTALT,
    SDO_GEOMETRY(2001,null,
        SDO_POINT_TYPE(3,3,null),
        null,null),
    'mask=ANYINTERACT') = 'TRUE';

-- zad 2A  
select GEOM from MAJOR_CITIES WHERE CITY_NAME = 'Warsaw';

select A.CITY_NAME AS MIASTO, SDO_NN_DISTANCE(1) ODL
from MAJOR_CITIES A
where SDO_NN(GEOM,MDSYS.SDO_GEOMETRY(2001, 8307, NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1, 1),
        MDSYS.SDO_ORDINATE_ARRAY(21.0118794,52.2449452)),
    'sdo_num_res=10 unit=km',1) = 'TRUE'
    AND A.CITY_NAME <> 'Warsaw';

-- zad 2B  
select C.CITY_NAME AS MIASTO
from MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.GEOM,
    SDO_GEOMETRY(2001,
        8307,
        null,
        MDSYS.SDO_ELEM_INFO_ARRAY(1, 1, 1),
        MDSYS.SDO_ORDINATE_ARRAY(21.0118794,52.2449452)),
    'distance=100 unit=km') = 'TRUE'
    AND C.CITY_NAME <> 'Warsaw';

-- zad 2C  
select B.CNTRY_NAME AS KRAJ, C.CITY_NAME
from COUNTRY_BOUNDARIES B, MAJOR_CITIES C
where SDO_RELATE(C.GEOM, B.GEOM,
    'mask=INSIDE') = 'TRUE'
    AND B.CNTRY_NAME = 'Slovakia';

-- zad 2D   
select B.CNTRY_NAME AS PANSTWO, SDO_GEOM.SDO_DISTANCE(A.GEOM, B.GEOM, 1, 'unit=km') ODL
from COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Poland' AND B.CNTRY_NAME <> 'Poland'
    AND NOT SDO_RELATE(A.GEOM, B.GEOM,
    'mask=TOUCH') = 'TRUE';

-- zad 3A  
select B.CNTRY_NAME, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km') ODLEGLOSC
from COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Poland' AND B.CNTRY_NAME <> 'Poland'
    AND SDO_RELATE(A.GEOM, B.GEOM,
    'mask=TOUCH') = 'TRUE';

-- zad 3B  
select A.CNTRY_NAME
from COUNTRY_BOUNDARIES A
order by SDO_GEOM.SDO_AREA(A.GEOM, 1, 'unit=SQ_KM') DESC
FETCH FIRST 1 ROWS ONLY;

-- zad 3C 
select (
    SDO_GEOM.SDO_AREA((
        SDO_GEOM.SDO_MBR(
            SDO_GEOM.SDO_UNION(C.GEOM, D.GEOM, 1)
        )
    ), 1, 'unit=SQ_KM')
) AS SQ_KM
from COUNTRY_BOUNDARIES B, MAJOR_CITIES C, MAJOR_CITIES D
where SDO_RELATE(C.GEOM, B.GEOM,
    'mask=INSIDE') = 'TRUE'
    AND B.CNTRY_NAME = 'Poland'
    AND C.CITY_NAME = 'Warsaw'
    AND D.CITY_NAME = 'Lodz';

-- zad 3D  
select SDO_GEOM.SDO_UNION(B.GEOM, C.GEOM, 1).SDO_GTYPE AS GTYPE
from COUNTRY_BOUNDARIES B, MAJOR_CITIES C
where B.CNTRY_NAME = 'Poland'
    AND C.CITY_NAME = 'Prague';

-- zad 3E  
select  C.CITY_NAME, B.CNTRY_NAME
from COUNTRY_BOUNDARIES B, MAJOR_CITIES C
ORDER BY ROUND(SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(B.GEOM,1), C.GEOM, 1, 'unit=km'))
FETCH FIRST 1 ROWS ONLY;

-- zad 3F    
select C."NAME", SUM(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(B.GEOM, C.GEOM, 1), 1, 'unit=km'))
from COUNTRY_BOUNDARIES B, RIVERS C
where SDO_RELATE(C.GEOM, B.GEOM,
    'mask=ANYINTERACT') = 'TRUE'
    AND B.CNTRY_NAME = 'Poland'
GROUP BY C."NAME";