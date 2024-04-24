<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="http://www.andrewcashner.com"
  exclude-result-prefixes="aac">

  <!-- TABLES -->
  <xsl:template match="xhtml:table[not(@class='wide' or @class='extra-wide')]">
    <xsl:text>\begin{table}&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:caption" />
    <xsl:text>\begin{center}&#xA;</xsl:text>
    <xsl:text>\begin{tabular}{</xsl:text>
    <xsl:apply-templates select="xhtml:thead/xhtml:tr[1]/xhtml:th" mode="table-setup" />
    <xsl:text>} \toprule&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:thead" />
    <xsl:apply-templates select="xhtml:tbody" />
    <xsl:text>\bottomrule&#xA;\end{tabular}&#xA;</xsl:text>
    <xsl:text>\end{center}&#xA;</xsl:text>
    <xsl:text>\end{table}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:table[@class='wide']">
    <xsl:text>\begin{tabularx}{\linewidth}{</xsl:text>
    <xsl:apply-templates select="xhtml:thead/xhtml:tr[1]/xhtml:th" mode="table-setup" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:caption" />
    <xsl:text>\\ \toprule&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:thead" />
    <xsl:text> \endhead&#xA;</xsl:text>
   <xsl:apply-templates select="xhtml:tbody" />
    <xsl:text>\bottomrule&#xA;</xsl:text>
    <xsl:text>\end{tabularx}&#xA;</xsl:text>
  </xsl:template>


  <xsl:template match="xhtml:table[@class='extra-wide']">
    <xsl:text>\begin{landscapeTable}</xsl:text>
    <xsl:text>\begin{tabularx}{\linewidth}{</xsl:text>
    <xsl:apply-templates select="xhtml:thead/xhtml:tr[1]/xhtml:th" mode="table-setup" />
    <xsl:text>}&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:caption" />
    <xsl:text>\\ \toprule&#xA;</xsl:text>
    <xsl:apply-templates select="xhtml:thead" />
    <xsl:text> \endhead&#xA;</xsl:text>
   <xsl:apply-templates select="xhtml:tbody" />
    <xsl:text>\bottomrule&#xA;</xsl:text>
    <xsl:text>\end{tabularx}&#xA;</xsl:text>
    <xsl:text>\end{landscapeTable}&#xA;</xsl:text>
  </xsl:template>


  <xsl:template match="xhtml:table[not(@class='wide' or @class='extra-wide')]//xhtml:th[not(@class='num')]" mode="table-setup">
    <xsl:text>l</xsl:text>
  </xsl:template>
 
  <xsl:template match="xhtml:table//xhtml:th[@class='num']" mode="table-setup">
    <xsl:text>r</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:table[@class='wide' or @class='extra-wide']//xhtml:th[not(@class='num')]" mode="table-setup">
    <xsl:text>X</xsl:text>
  </xsl:template>
 
  <xsl:template match="xhtml:thead">
    <xsl:apply-templates />
    <xsl:text>\midrule&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:tbody">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="xhtml:tr">
    <xsl:apply-templates />
    <xsl:text> \\&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:td | xhtml:th">
    <xsl:apply-templates />
    <xsl:if test="following-sibling::*">
      <xsl:text> &amp; </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- FIGURES, EXAMPLES, DIAGRAMS -->
  <xsl:template match="xhtml:figure[@class='music']">
    <xsl:text>\begin{example}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{example}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='diagram']">
    <xsl:text>\begin{diagram}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{diagram}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='image']">
    <xsl:text>\begin{figure}&#xA;</xsl:text>
    <xsl:apply-templates />
    <xsl:text>\end{figure}&#xA;</xsl:text>
  </xsl:template>

  <!-- remove file extension for graphics files so web and pdf version can use different file types (e.g., svg for web and png or pdf for print) -->
  <xsl:template match="xhtml:img">
    <xsl:text>\includegraphics[width=\textwidth]{</xsl:text>
    <xsl:value-of select="substring-before(@src, '.')" />
      <xsl:text>}&#xA;</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:caption | xhtml:figCaption">
    <xsl:text>\caption{</xsl:text>
    <xsl:apply-templates />
    <xsl:text> \label{</xsl:text>
    <xsl:value-of select="../@id" />
    <xsl:text>}</xsl:text>
    <xsl:text>}&#xA;</xsl:text>
  </xsl:template>
  
  <!-- CROSS-REFERENCES -->
  <xsl:template match="aac:ref[@type='table']">
    <xsl:choose>
      <xsl:when test="string()">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>table</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> \ref{</xsl:text>
    <xsl:value-of select="substring(@href, 2)" />
    <xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template match="aac:ref[@type='image']">
    <xsl:choose>
      <xsl:when test="string()">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>figure</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> \ref{</xsl:text>
    <xsl:value-of select="substring(@href, 2)" />
    <xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template match="aac:ref[@type='music']">
    <xsl:choose>
      <xsl:when test="string()">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>example</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> \ref{</xsl:text>
    <xsl:value-of select="substring(@href, 2)" />
    <xsl:text>} </xsl:text>
  </xsl:template>

  <xsl:template match="aac:ref[@type='diagram']">
    <xsl:choose>
      <xsl:when test="string()">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>diagram</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> \ref{</xsl:text>
    <xsl:value-of select="substring(@href, 2)" />
    <xsl:text>} </xsl:text>
  </xsl:template>


</xsl:stylesheet>
