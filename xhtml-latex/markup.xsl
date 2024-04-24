<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="http://www.andrewcashner.com"
  exclude-result-prefixes="aac">

  <xsl:template match="xhtml:q">
    <xsl:text>\quoted{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:q[@class='soCalled']">
    <xsl:text>\soCalled{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:em">
    <xsl:text>\emph{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:em[@class='foreign']">
    <xsl:text>\foreign{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:em[@class='term']">
    <xsl:text>\term{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:em[@class='mentioned']">
    <xsl:text>\mentioned{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>


  <xsl:template match="xhtml:cite">
    <xsl:text>\worktitle{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:p[@class='title']">
    <xsl:text>\parttitle{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:strong">
    <xsl:text>\strong{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>
 
  <xsl:template match="aac:TODO">
    <xsl:text>\XXX[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:blockquote">
    <xsl:text>\begin{quotation}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#xA;\end{quotation}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:a">
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="replace(@href, '#', '\\#')" />
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:ol">
    <xsl:text>\begin{enumerate}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{enumerate}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:ul">
    <xsl:text>\begin{itemize}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{itemize}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:li">
    <xsl:text>\item{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:i">
    <xsl:text>\emph{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- MUSIC MARKUP -->
  <xsl:template match="aac:degree">
    <xsl:apply-templates select="@accid" />
    <xsl:text>$\hat </xsl:text>
    <xsl:value-of select="@n" />
    <xsl:text>$ </xsl:text>
  </xsl:template>

  <xsl:template match="aac:pitch">
    <xsl:value-of select="@pname" />
    <xsl:apply-templates select="@accid" />
    <xsl:apply-templates select="@oct" />
  </xsl:template>

  <xsl:template match="@oct">
    <xsl:text>\textsubscript{</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>} </xsl:text>
  </xsl:template>


  <xsl:template name="natural">
    <xsl:text>\na{}</xsl:text>
  </xsl:template>

  <xsl:template name="flat">
    <xsl:text>\fl{}</xsl:text>
  </xsl:template>

  <xsl:template name="sharp">
    <xsl:text>\sh{}</xsl:text>
  </xsl:template>

  <xsl:template match="@accid">
    <xsl:choose>
      <xsl:when test=".='na'">
        <xsl:call-template name="natural" />
      </xsl:when>
      <xsl:when test=".='fl'">
        <xsl:call-template name="flat" />
      </xsl:when>
      <xsl:when test=".='sh'">
        <xsl:call-template name="sharp" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="aac:na">
    <xsl:call-template name="natural" />
  </xsl:template>

  <xsl:template match="aac:fl">
    <xsl:call-template name="flat" />
  </xsl:template>
  
  <xsl:template match="aac:sh">
    <xsl:call-template name="sharp" />
  </xsl:template>
  
  <xsl:template match="xhtml:span[@class='add']">
    <xsl:text>\add{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>} </xsl:text>
  </xsl:template>


  <xsl:template match="xhtml:div[@class='note']">
    <xsl:text>\begin{Footnote}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{Footnote}&#xA;</xsl:text>
  </xsl:template>


</xsl:stylesheet>


