<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="http://www.andrewcashner.com">

  <xsl:output method="html" version="5.0" encoding="utf-8" indent="yes" />

  <xsl:strip-space elements="*" />

  <xsl:template match="comment()" priority="1" />

  <xsl:template match="@* | node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xhtml:html">
    <html lang="{@xml:lang}">
      <xsl:apply-templates />
    </html>
  </xsl:template>

  <xsl:template match="@xml:lang" />
  <xsl:template match="@xml:base" />
  
 
  <xsl:template match="xhtml:head">
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <xsl:apply-templates />
    </head>
  </xsl:template>

  <xsl:template match="xhtml:footer">
    <footer>
      <xsl:call-template name="notes" />
      <xsl:apply-templates />
    </footer>
  </xsl:template>

  <!-- remove metadata used only in build process -->
  <xsl:template match="xhtml:meta[@name='bibliography']" />
  <xsl:template match="xhtml:meta[@name='latex-documentclass']" />

  <xsl:include href="markup.xsl" />

  <xsl:include href="sections.xsl" />

  <xsl:include href="toc.xsl" />

  <xsl:include href="floats.xsl" />

  <xsl:include href="bib.xsl" /> 

  <xsl:template match="aac:cut" />
  
</xsl:stylesheet>
