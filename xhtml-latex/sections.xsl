<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="http://www.andrewcashner.com">

  <xsl:template match="xhtml:article">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xhtml:section">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="section">
    <xsl:param name="type" />
    <xsl:param name="id" />
    <xsl:text>\</xsl:text>
    <xsl:value-of select="$type" />
    <xsl:text>{</xsl:text>
    <xsl:apply-templates />
    <xsl:apply-templates select="$id" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="@id">
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:section[@class='unnumbered']/xhtml:h1">
    <xsl:call-template name="section">
      <xsl:with-param name="type">section*</xsl:with-param>
      <xsl:with-param name="id" select="../@id" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:section[not(@class='unnumbered')]/xhtml:h1">
    <xsl:call-template name="section">
      <xsl:with-param name="type">section</xsl:with-param>
      <xsl:with-param name="id" select="../@id" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:section[@class='unnumbered']/xhtml:h2">
    <xsl:call-template name="section">
      <xsl:with-param name="type">subsection*</xsl:with-param>
      <xsl:with-param name="id" select="../@id" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xhtml:section[not(@class='unnumbered')]/xhtml:h2">
    <xsl:call-template name="section">
      <xsl:with-param name="type">subsection</xsl:with-param>
      <xsl:with-param name="id" select="../@id" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xhtml:section[@class='unnumbered']/xhtml:h3">
    <xsl:call-template name="section">
      <xsl:with-param name="type">subsubsection*</xsl:with-param>
      <xsl:with-param name="id" select="../@id" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xhtml:section[not(@class='unnumbered')]/xhtml:h3">
    <xsl:call-template name="section">
      <xsl:with-param name="type">subsubsection</xsl:with-param>
      <xsl:with-param name="id" select="../@id" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xhtml:section/xhtml:h4">
    <xsl:call-template name="section">
      <xsl:with-param name="type">paragraph</xsl:with-param>
      <xsl:with-param name="id" select="../@id" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xhtml:main//xhtml:p[not(@class='continue')]">
    <xsl:apply-templates />
    <xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:main//xhtml:p[@class='continue']">
    <!-- <xsl:text>\noindent </xsl:text> -->
    <xsl:apply-templates />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:div[@class='tex-pagebreak']">
    <xsl:text>\clearpage&#xA;</xsl:text>
  </xsl:template>


</xsl:stylesheet>
