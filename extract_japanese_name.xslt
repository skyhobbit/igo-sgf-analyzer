<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- テキスト出力を指定 -->
    <xsl:output method="text"/>

    <!-- パラメータの宣言 -->
    <xsl:param name="inputName"/>

    <!-- 入力された名前で一致するエントリを選択 -->
    <xsl:template match="/">
        <xsl:apply-templates select="//entry[tag/gogod=$inputName]"/>
    </xsl:template>

    <!-- kanjivariant要素の内容だけをテキストとして出力 -->
    <xsl:template match="entry">
        <xsl:value-of select="surname/jmod"/>
        <xsl:value-of select="given/jmod"/>
    </xsl:template>

</xsl:stylesheet>
