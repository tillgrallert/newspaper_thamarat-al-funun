<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    
    <!-- identity transformation -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:variable name="v_bibl-master" select="document('../metadata/thamarat-al-funun.TEIP5.xml')"/>
    <xsl:variable name="v_bibls" select="$v_bibl-master/descendant::tei:text/descendant::tei:biblStruct"/>
    
    <xsl:template match="tei:bibl">
        <xsl:variable name="v_volume" select="descendant::tei:biblScope[@unit='volume']/@from"/>
        <xsl:variable name="v_issue" select="descendant::tei:biblScope[@unit='issue']/@from"/>
        <xsl:choose>
            <xsl:when test="not(tei:ref) and $v_bibls/descendant-or-self::tei:biblStruct[descendant::tei:biblScope[@unit='volume']/@from=$v_volume][descendant::tei:biblScope[@unit='issue']/@from=$v_issue]">
                <xsl:element name="tei:ref">
                    <xsl:attribute name="target" select="concat('../xml/oclc_792755216-i_',$v_issue,'.TEIP5.xml')"/>
                    <xsl:copy>
                        <xsl:apply-templates select="@* | node()"/>
                        <!-- add publication date if not yet present -->
                        <xsl:if test="not(descendant::tei:date)">
                            <xsl:text>, </xsl:text>
                            <xsl:element name="tei:add">
                                <xsl:attribute name="resp" select="'#pers_TG'"/>
                                <xsl:element name="tei:date">
                                    <xsl:attribute name="xml:lang" select="'en'"/>
                                    <xsl:attribute name="when">
                                        <xsl:value-of select="$v_bibls/descendant-or-self::tei:biblStruct[descendant::tei:biblScope[@unit='volume']/@from=$v_volume][descendant::tei:biblScope[@unit='issue']/@from=$v_issue]/descendant::tei:date[1]/@when"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="format-date($v_bibls/descendant-or-self::tei:biblStruct[descendant::tei:biblScope[@unit='volume']/@from=$v_volume][descendant::tei:biblScope[@unit='issue']/@from=$v_issue]/descendant::tei:date[1]/@when,'[D0] [MNn] [Y0001]')"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:copy>
                </xsl:element>
            </xsl:when>
            <!-- fall-back option -->
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>