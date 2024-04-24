<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aac="http://www.andrewcashner.com"
  exclude-result-prefixes="aac">
  
  <!-- Internal references with automatic numbers -->
  <xsl:template match="aac:ref[@type='image']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>figure</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:figure[@class='image' and @id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='image']" mode="number">
    <xsl:number count="//xhtml:figure[@class='image']" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='image']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Figure </xsl:text>
      <xsl:number count="xhtml:figure[@class='image']" format="1. " level="any" />
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>


  <!-- Music example -->
  <xsl:template match="aac:ref[@type='music']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>music example</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:figure[@class='music' and @id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='music']" mode="number">
    <xsl:number count="//xhtml:figure[@class='music']" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='music']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Music example </xsl:text>
      <xsl:number count="xhtml:figure[@class='music']" format="1. " level="any" />
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>


  <!-- Table -->
  <xsl:template match="aac:ref[@type='table']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>table</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:table[@id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:table" mode="number">
    <xsl:number count="//xhtml:table" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:table/xhtml:caption">
    <caption>
      <xsl:text>Table </xsl:text>
      <xsl:number count="xhtml:table" format="1. " level="any" />
      <xsl:apply-templates />
    </caption>
  </xsl:template>

  <!-- Diagram -->
  <xsl:template match="aac:ref[@type='diagram']">
    <xsl:variable name="target" select="substring(@href, 2)" />
    <a class="internal" href="{@href}">
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>diagram</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="//xhtml:figure[@class='diagram' and @id=$target]" mode="number" />
    </a>
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='diagram']" mode="number">
    <xsl:number count="//xhtml:figure[@class='diagram']" level="any" />
  </xsl:template>

  <xsl:template match="xhtml:figure[@class='diagram']/xhtml:figCaption">
    <figCaption>
      <xsl:text>Diagram </xsl:text>
      <xsl:number count="xhtml:figure[@class='diagram']" format="1. " level="any" />
      <xsl:apply-templates />
    </figCaption>
  </xsl:template>

</xsl:stylesheet>
