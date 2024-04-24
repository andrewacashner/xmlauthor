<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:m="http://www.w3.org/1998/Math/MathML" 
  xmlns:aac="http://www.andrewcashner.com"
  exclude-result-prefixes="aac">
 
  <xsl:template match="aac:TODO">
    <strong class="TODO">
      <xsl:text>[</xsl:text>
      <xsl:choose>
        <xsl:when test="string()">
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>TODO</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </strong>
  </xsl:template>

  <xsl:template match="aac:pitch">
    <xsl:value-of select="@pname" />
    <xsl:call-template name="accid">
      <xsl:with-param name="accid" select="@accid" />
    </xsl:call-template>
    <sub>
      <xsl:value-of select="@oct" />
    </sub>
  </xsl:template>

  <xsl:template match="aac:degree">
    <m:math>
      <m:mi>
        <xsl:call-template name="accid">
          <xsl:with-param name="accid" select="@accid" />
        </xsl:call-template>
      </m:mi>
      <m:mover>
        <m:mi>
          <xsl:value-of select="@n" />
        </m:mi>
        <m:mi>&#x02c6;</m:mi>
      </m:mover>
    </m:math>
  </xsl:template>

  <xsl:template name="accid">
    <xsl:param name="accid" />
    <xsl:choose>
      <xsl:when test="@accid='na'">
        <xsl:text>♮</xsl:text>
      </xsl:when>
      <xsl:when test="@accid='fl'">
        <xsl:text>♭</xsl:text>
      </xsl:when>
      <xsl:when test="@accid='sh'">
        <xsl:text>♯</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="aac:na">
    <xsl:text>♮</xsl:text>
  </xsl:template>

  <xsl:template match="aac:fl">
    <xsl:text>♭</xsl:text>
  </xsl:template>
  
  <xsl:template match="aac:sh">
    <xsl:text>♯</xsl:text>
  </xsl:template>

  <xsl:template match="span[@class='add']">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="xhtml:div[@class='note']">
    <a id="{@id}-ref" href="#{@id}">
      <sup>
        <xsl:number count="//xhtml:div[@class='note']" 
                    level="any" format="1" />
      </sup>
    </a>
  </xsl:template>

  <xsl:template name="notes">
    <xsl:if test="//xhtml:div[@class='note']">
      <section id="notes">
        <h1>Notes</h1>
        <ol>
          <xsl:for-each select="//xhtml:div[@class='note']">
            <li id="{@id}">
              <xsl:apply-templates />
              <a href="#{@id}-ref"> ⮍</a> <!-- U+2B8D -->
            </li>
          </xsl:for-each>
        </ol>
      </section>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
