(:zad 31:)
(:doc("file:///D:/University/sem9/ztpd/XPath-XSLT/zesp_prac.xml"):)

(:zad 32:)
(:doc("file:///D:/University/sem9/ztpd/XPath-XSLT/zesp_prac.xml")//NAZWISKO:)

(:zad 33:)
(:doc("file:///D:/University/sem9/ztpd/XPath-XSLT/zesp_prac.xml")/ZESPOLY/ROW[NAZWA = 'SYSTEMY EKSPERCKIE']//NAZWISKO:)

(:zad 34:)
(:count(doc("file:///D:/University/sem9/ztpd/XPath-XSLT/zesp_prac.xml")/ZESPOLY/ROW[ID_ZESP = '10']/PRACOWNICY/ROW):)

(:zad 35:)
(:doc("file:///D:/University/sem9/ztpd/XPath-XSLT/zesp_prac.xml")//PRACOWNICY/ROW[ID_SZEFA = 100]/NAZWISKO:)
(:doc("file:///D:/University/sem9/ztpd/XPath-XSLT/zesp_prac.xml")//PRACOWNICY/ROW:)

(:zad 36:)
sum(doc("file:///D:/University/sem9/ztpd/XPath-XSLT/zesp_prac.xml")//PRACOWNICY/ROW[ID_ZESP = //PRACOWNICY/ROW[NAZWISKO = 'BRZEZINSKI']/ID_ZESP]/PLACA_POD)
