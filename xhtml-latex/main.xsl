<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="http://www.andrewcashner.com">

  <xsl:output method="text" encoding="utf-8" indent="no" />

  <xsl:strip-space elements="*" />

  <xsl:template match="comment()" />

  <!-- Convert newlines in XML input to spaces 
    (avoid spurious paragraph breaks) -->
  <xsl:template match="text()">
    <xsl:variable name="newline">
      <xsl:value-of select="replace(., '&#10;', ' ')" />
    </xsl:variable>
    <xsl:variable name="space">
      <xsl:value-of select="replace($newline, '  ', ' ')" />
    </xsl:variable>
    <xsl:variable name="dollar">
      <xsl:value-of select="replace($space, '\$', '\\\$')" />
    </xsl:variable>
    <xsl:variable name="ampersand">
      <xsl:value-of select="replace($dollar, '&amp;', '\\&amp;{}')" />
    </xsl:variable>
    <xsl:value-of select="$ampersand" />
  </xsl:template>

  <!-- DOCUMENT -->
  <xsl:template match="/">
    <xsl:call-template name="documentclass" />
    <xsl:call-template name="default-packages" />
    <xsl:apply-templates select="//aac:bibliography" mode="setup" />
    <xsl:apply-templates select="//xhtml:header" />
    <xsl:call-template name="pdf-metadata" />
    <xsl:text>\begin{document}&#xA;</xsl:text>
    <xsl:text>\maketitle&#xA;</xsl:text>
    <xsl:apply-templates select="//xhtml:main" />
    <xsl:text>\end{document}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="documentclass">
    <xsl:variable name="default-documentclass">
      <xsl:text>article</xsl:text>
    </xsl:variable>
    <xsl:variable name="documentclass" 
      select="(//xhtml:meta[@name='latex-documentclass']/@content 
               | $default-documentclass)[1]" />
    <xsl:text>\documentclass{</xsl:text>
    <xsl:value-of select="$documentclass" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:variable name="default-package-list">
    <aac:package>semantic-markup</aac:package>
    <aac:package>musicography</aac:package>
    <aac:package options="authordate">biblatex-chicago</aac:package>
    <aac:package>hyperref</aac:package>
  </xsl:variable>

  <xsl:template match="aac:package">
    <xsl:text>\usepackage</xsl:text>
    <xsl:apply-templates select="@options" />
    <xsl:text>{</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="aac:package/@options">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>]</xsl:text>
  </xsl:template>
  
  <xsl:template name="default-packages">
    <xsl:apply-templates select="$default-package-list/aac:package" />
  </xsl:template>

  <xsl:variable name="bibtex-file" select="//xhtml:meta[@name='bibliography']/@content" />

  <!-- TODO eventually you should have an option to do other than author-date -->
  <xsl:template match="aac:bibliography" mode="setup">
    <xsl:text>\addbibresource{</xsl:text>
    <xsl:value-of select="$bibtex-file" />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>


  <xsl:template match="xhtml:header/xhtml:h1">
    <xsl:text>\title{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:header/xhtml:p[@class='author']">
    <xsl:text>\author{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:header/xhtml:p[@class='date']">
    <xsl:text>\date{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template name="pdf-metadata">
    <xsl:text>\hypersetup{&#xA;</xsl:text>
    <xsl:text>pdfauthor={</xsl:text>
    <xsl:value-of select="//xhtml:meta[@name='author']/@content" />
    <xsl:text>},&#xA;</xsl:text>
    <xsl:text>pdftitle={</xsl:text>
    <xsl:value-of select="//xhtml:head/xhtml:title" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:include href="sections.xsl" />
  <xsl:include href="markup.xsl" />
  <xsl:include href="floats.xsl" />
  <xsl:include href="bib.xsl" />

  <xsl:template match="aac:cut" />
</xsl:stylesheet>

