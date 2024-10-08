<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Specify text output -->
    <xsl:output method="text"/>

    <!-- Declare parameter -->
    <xsl:param name="inputName"/>

    <!-- Select the entry that matches the input name -->
    <xsl:template match="/">
        <xsl:apply-templates select="//entry[tag/gogod=$inputName]"/>
    </xsl:template>

    <!-- Output only the content of the kanjivariant element -->
    <xsl:template match="entry">
        <xsl:value-of select="surname/jmod"/>
        <xsl:value-of select="given/jmod"/>
    </xsl:template>

</xsl:stylesheet>
