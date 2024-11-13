(:zad 28:)
(:for $k in doc("file:///D:/University/sem9/ztpd/XPath-XSLT/swiat.xml")/SWIAT/KRAJE/KRAJ[starts-with(.,'A')]:)
(:return <KRAJ>:)
(:    {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:zad 29:)
(:for $k in doc("file:///D:/University/sem9/ztpd/XPath-XSLT/swiat.xml")/SWIAT/KRAJE/KRAJ:)
(:where substring($k/NAZWA, 1, 1) = substring($k/STOLICA, 1, 1):)
(:return <KRAJ>:)
(:    {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:zad 30:)
doc("file:///D:/University/sem9/ztpd/XPath-XSLT/swiat.xml")//KRAJ
