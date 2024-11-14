<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:template match="/">
        <html>
            <body>
                <!--ZAD 5-->
                <h1> Zespoły: </h1>
                <!--ZAD 6-->
                <ol>
<!--                    <xsl:for-each select="ZESPOLY/ROW">-->
<!--                        <li><xsl:value-of select="NAZWA"/></li>-->
<!--                    </xsl:for-each>-->
                    <xsl:apply-templates select="ZESPOLY/ROW" mode="zad6"/>
                </ol>
                <!--ZAD 7-->
                <xsl:apply-templates select="ZESPOLY/ROW" mode="zad7"/>
            </body>
        </html>
    </xsl:template>
    <!--ZAD 6-->
    <xsl:template match="ROW" mode="zad6">
        <!--ZAD 9 link -->
        <li><a href='#{ID_ZESP}'><xsl:apply-templates select="NAZWA"/></a></li>
    </xsl:template>

    <xsl:template match="ROW" mode="zad7">
        <!--ZAD 9 link -->
        <h4 id="{ID_ZESP}">NAZWA: <xsl:value-of select="NAZWA"/></h4>
        <h4 id="{ID_ZESP}">ADRES: <xsl:value-of select="ADRES"/></h4>
        <!--ZAD 14-->
        <xsl:if test="count(PRACOWNICY/ROW)>0">
            <!--ZAD 8-->
            <table border="1">
                <tr>
                    <th>Nazwisko</th>
                    <th>Etat</th>
                    <th>Zatrudniony</th>
                    <th>Płaca pod.</th>
                    <th>Szef</th>
                </tr>
                <xsl:apply-templates select="PRACOWNICY/ROW" mode="zad8_wiersz">
                    <!--ZAD 10 sort -->
                    <xsl:sort select="NAZWISKO"/>
                </xsl:apply-templates>
            </table>
        </xsl:if>
        <!--ZAD 13-->
        <p>Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/></p>
    </xsl:template>

    <xsl:template match="PRACOWNICY/ROW" mode="zad8_wiersz">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <!--ZAD 11 id_szefa na nazw -->
            <td>
                <!--ZAD 12 warunek -->
                <xsl:choose>
                    <xsl:when test="ID_SZEFA">
                        <xsl:value-of select="//PRACOWNICY/ROW[ID_PRAC = current()/ID_SZEFA]/NAZWISKO"/>
                    </xsl:when>
                    <xsl:otherwise>brak</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>