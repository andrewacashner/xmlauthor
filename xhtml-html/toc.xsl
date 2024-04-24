<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="http://www.andrewcashner.com"
  exclude-result-prefixes="aac">

  <xsl:template match="aac:tableofcontents">
    <section class="toc">
      <h1>Contents</h1>
      <ul>
        <xsl:apply-templates select="//xhtml:section" mode="toc" />
        <xsl:apply-templates select="../aac:bibliography" mode="toc" />
      </ul>
    </section>
  </xsl:template>

  <xsl:template match="xhtml:section" mode="toc">
    <xsl:if test="xhtml:h1">
      <li>
        <xsl:apply-templates select="xhtml:h1" mode="toc" />
        <xsl:if test="xhtml:section">
          <ul>
            <xsl:apply-templates select="xhtml:section/xhtml:h2" mode="toc" />
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:h1" mode="toc">
    <a href="#{../@id}"><xsl:apply-templates /></a>
  </xsl:template>

  <xsl:template match="xhtml:h2" mode="toc">
    <li><a href="#{../@id}"><xsl:apply-templates /></a></li>
  </xsl:template>

  <xsl:template match="aac:bibliography" mode="toc">
    <li><a href="#bibliography">References</a></li>
  </xsl:template>

</xsl:stylesheet>
