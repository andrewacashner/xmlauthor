<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="http://www.andrewcashner.com"
  exclude-result-prefixes="aac">

  <xsl:template match="aac:citation">
    <xsl:text> \autocite</xsl:text>
    <xsl:call-template name="in-text-citation" />
  </xsl:template>
  
  <xsl:template match="aac:citationList">
    <xsl:text> \autocites</xsl:text>
    <xsl:for-each select="aac:citation">
      <xsl:call-template name="in-text-citation" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="in-text-citation">
    <xsl:if test="string()"> 
      <xsl:text>[</xsl:text>
      <xsl:value-of select="string()" />
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="@key" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="aac:bibliography">
    <xsl:text>\printbibliography&#xA;</xsl:text>
  </xsl:template>

</xsl:stylesheet> 
