<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="xhtml:section[@class='unnumbered']/xhtml:h1">
    <h1><xsl:apply-templates /></h1>
  </xsl:template>

  <xsl:template match="xhtml:section[not(@class='unnumbered')]/xhtml:h1">
    <h1>
      <xsl:number 
      format="1. " 
      count="xhtml:section[not(@class='unnumbered')]"
      level="multiple" />
      <xsl:apply-templates />
    </h1>
  </xsl:template>
  
  <xsl:template match="xhtml:section[@class='unnumbered']/xhtml:h2">
    <h2><xsl:apply-templates /></h2>
  </xsl:template>

  <xsl:template match="xhtml:section[not(@class='unnumbered')]/xhtml:h2">
    <h2>
      <xsl:number 
      format="1. " 
      count="xhtml:section[not(@class='unnumbered')]"
      level="multiple" />
      <xsl:apply-templates />
    </h2>
  </xsl:template>


  <!-- TODO subsections h2 etc. -->
  
  <xsl:template match="xhtml:div[@class='tex-page']">
    <xsl:apply-templates />
  </xsl:template>

</xsl:stylesheet>
