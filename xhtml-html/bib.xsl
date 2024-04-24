<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  version="2.0" 
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:bltx="http://biblatex-biber.sourceforge.net/biblatexml"
  xmlns:aac="http://www.andrewcashner.com"
  exclude-result-prefixes="aac bltx">

  <xsl:import href="bltxml_macros.xsl" />

  <!-- Bring in the XML bibliography file, which was derived from the BibTeX file
    - Original BibTeX file must be set in metadata like so:
      <head>
        ...
        <meta name="bibliography" content="biblio.bib" />
      </head>
  -->
  <xsl:variable name="bibtexml-file">
    <xsl:variable name="bibtex-file" select="//xhtml:meta[@name='bibliography']/@content" />
    <xsl:value-of select="replace($bibtex-file, '.bib', '.bltxml')" />
  </xsl:variable>
 
  <xsl:variable name="bibfile" select="document(concat(environment-variable('PWD'), '/aux/', $bibtexml-file))/bltx:entries" />


  <!-- REFERENCE LIST -->

  <!-- Filter the BiblateXML bibliography tree to include only entries cited in the text -->
  <xsl:variable name="references">
    <xsl:variable name="citations" select="distinct-values(//aac:citation/@key)" />
    <bltx:entries>
      <xsl:for-each select="$citations">
        <xsl:copy-of select="$bibfile/bltx:entry[@id=current()]" />
      </xsl:for-each>
    </bltx:entries>
  </xsl:variable>

  <!-- Generate the bibliography/reference list instead of the placeholder -->
  <xsl:template match="aac:bibliography">
    <xsl:if test="//aac:citation">
      <section id="bibliography">
        <h1>References</h1>
        <xsl:apply-templates select="$references" />
      </section>
    </xsl:if>
  </xsl:template>

  <!-- Sort entries by first surname listed and date -->
  <xsl:template match="bltx:entries">
    <ul class="biblio">
      <xsl:apply-templates>
        <xsl:sort select="bltx:names[1]/bltx:name[1]/bltx:namepart[@type='family']" />
        <xsl:sort select="bltx:date" />
      </xsl:apply-templates>
    </ul>
  </xsl:template>

  <!-- Convert bibliography entries --> 

  <!-- Book or collection of essays -->
  <xsl:template match="bltx:entry[@entrytype='book'] | bltx:entry[@entrytype='collection']">
    <xsl:variable name="authors">
      <xsl:call-template name="book-authors" />
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bltx:date" />
      <xsl:text>. </xsl:text>
      <cite><xsl:apply-templates select="bltx:title" /></cite>
      <xsl:text>.</xsl:text>
      <xsl:apply-templates select="bltx:location" />
      <xsl:apply-templates select="bltx:publisher" />
      <xsl:apply-templates select="bltx:url" />
    </li>
  </xsl:template>

  <!-- List of authors or editors of a book or collection -->
  <xsl:template name="book-authors">
    <xsl:choose>
      <xsl:when test="bltx:names[@type='author']">
        <xsl:call-template name="name-list">
          <xsl:with-param name="names" select="bltx:names[@type='author']" />
          <xsl:with-param name="type">lastname-first</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="bltx:names[@type='editor']">
        <xsl:call-template name="name-list">
          <xsl:with-param name="names" select="bltx:names[@type='editor']" />
          <xsl:with-param name="type">lastname-first</xsl:with-param>
        </xsl:call-template>
        <xsl:choose>
          <xsl:when test="count(bltx:names[@type='editor']/bltx:name) > 1">
            <xsl:text>, eds</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>, ed</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Anonymous</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Article -->
  <xsl:template match="bltx:entry[@entrytype='article']">
    <xsl:variable name="authors">
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="bltx:names[@type='author']" />
        <xsl:with-param name="type">lastname-first</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bltx:date" />
      <xsl:text>. </xsl:text>
      <q><xsl:apply-templates select="bltx:title" /></q>
      <xsl:text>. </xsl:text>
      <cite><xsl:apply-templates select="bltx:journaltitle" /></cite>
      <xsl:if test="bltx:volume">
        <xsl:text> </xsl:text>
        <xsl:value-of select="bltx:volume" />
      </xsl:if>
      <xsl:if test="bltx:number">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="bltx:number" />
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:if test="bltx:pages">
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="bltx:pages" />
      </xsl:if>
      <xsl:text>. </xsl:text>
      <xsl:if test="bltx:note">
        <xsl:apply-templates select="bltx:note" />
        <xsl:text>. </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="bltx:url" />
    </li>
  </xsl:template>

  <!-- Article in a collection of essays -->
  <xsl:template match="bltx:entry[@entrytype='incollection']">
    <xsl:variable name="authors">
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="bltx:names[@type='author']" />
      </xsl:call-template>
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bltx:date" />
      <xsl:text>. </xsl:text>
      <q><xsl:apply-templates select="bltx:title" /></q>
      <xsl:text>. In </xsl:text>
      <cite><xsl:apply-templates select="bltx:booktitle" /></cite>
      <xsl:text>, edited by </xsl:text>
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="bltx:names[@type='editor']" />
        <xsl:with-param name="type">firstname-first</xsl:with-param>
      </xsl:call-template>
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="bltx:pages" />
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="bltx:location" />
      <xsl:apply-templates select="bltx:publisher" />
      <xsl:apply-templates select="bltx:url" />
    </li>
  </xsl:template>

  <xsl:template match="bltx:entry[@entrytype='unpublished']">
    <xsl:variable name="authors">
      <xsl:call-template name="name-list">
        <xsl:with-param name="names" select="bltx:names[@type='author']" />
      </xsl:call-template>
    </xsl:variable>
    <li id="{@id}">
      <xsl:value-of select="$authors" />
      <xsl:if test="not(substring($authors, string-length($authors))='.')">
        <xsl:text>.</xsl:text>
      </xsl:if>
      <xsl:text> </xsl:text>
      <xsl:value-of select="bltx:date" />
      <xsl:text>. </xsl:text>
      <xsl:if test="bltx:title">
        <q><xsl:apply-templates select="bltx:title" /></q>
        <xsl:text>. </xsl:text>
      </xsl:if>
      <xsl:if test="bltx:note">
        <xsl:apply-templates select="bltx:note" />
        <xsl:text>. </xsl:text>
      </xsl:if>
    </li>
  </xsl:template>


  <xsl:template name="name-list">
    <xsl:param name="names" />
    <xsl:param name="type" />
    <xsl:variable name="nameCount" select="count($names/bltx:name)" />
    <xsl:for-each select="$names/bltx:name">
      <xsl:choose>
        <xsl:when test="not($type='firstname-first') and position()=1">
          <xsl:apply-templates select="bltx:namepart[@type='family']" />
          <xsl:if test="bltx:namepart[@type='given']">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="bltx:namepart[@type='given']" />
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="bltx:namepart[@type='given']">
            <xsl:apply-templates select="bltx:namepart[@type='given']" />
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:apply-templates select="bltx:namepart[@type='family']" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="and-list">
        <xsl:with-param name="nameCount" select="$nameCount" />
        <xsl:with-param name="position" select="position()" />
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="$names/@morenames='1'">
      <xsl:text>, et al.</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="and-list">
    <xsl:param name="nameCount" />
    <xsl:param name="position" />
    <xsl:choose>
      <xsl:when test="$nameCount > 2 and $position &lt; $nameCount - 1">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:when test="$nameCount > 2 and $position = $nameCount - 1">
        <xsl:text>, and </xsl:text>
      </xsl:when>
      <xsl:when test="$nameCount = 2 and $position = $nameCount)">
        <xsl:text> and </xsl:text>
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:template>

  <!-- Process elements of bibliography entries
    - Remove TeX macros
  -->
  <xsl:template match="bltx:title | bltx:journaltitle | bltx:booktitle | bltx:note">
    <xsl:call-template name="macros" />
  </xsl:template>

  <!-- Names: bltx:namepart elements can be nested; insert space if there is another one after this -->
  <xsl:template match="bltx:namepart">
    <xsl:apply-templates />
    <xsl:if test="not(position()=last())">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="bltx:location">
    <xsl:text> </xsl:text>
    <xsl:call-template name="macros" />
    <xsl:text>: </xsl:text>
  </xsl:template>

  <xsl:template match="bltx:publisher">
    <xsl:call-template name="macros" />
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="bltx:url">
    <xsl:text> </xsl:text>
    <a href="{string()}"><xsl:value-of select="." /></a>
    <xsl:text>.</xsl:text>
  </xsl:template>

  <xsl:template match="bltx:list">
    <xsl:value-of select="bltx:item" separator=" and " />
  </xsl:template>

  <xsl:template match="bltx:pages">
    <xsl:for-each select="bltx:list/bltx:item">
      <xsl:value-of select="bltx:start" />
      <xsl:text>–</xsl:text>
      <xsl:value-of select="bltx:end" />
      <xsl:if test="not(position()=last())">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- IN-TEXT CITATIONS -->
  <!-- Make a link for a single citation and enclose in parentheses -->
  <xsl:template match="aac:citation">
    <xsl:text> (</xsl:text>
    <xsl:call-template name="in-text-citation" />
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- For multiple citations, make links in semicolon-separated list and enclose in parentheses -->
  <xsl:template match="aac:citationList">
    <xsl:text>(</xsl:text>
    <xsl:for-each select="aac:citation">
      <xsl:call-template name="in-text-citation" />
      <xsl:if test="not(position()=last())">
        <xsl:text>; </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- Insert Author-Date text as link to reference-list entry -->
  <xsl:template name="in-text-citation">
    <xsl:variable name="ref" select="$references/bltx:entries/bltx:entry[@id=current()/@key]" />
    <xsl:if test="@pre">
      <xsl:value-of select="@pre" />
      <xsl:text> </xsl:text>
    </xsl:if>
    <a class="citation" href="#{@key}">
      <xsl:choose>
        <xsl:when test="$ref">
          <xsl:variable name="names" select="$ref/bltx:names[1]/bltx:name" />
          <xsl:for-each select="$names/bltx:namepart[@type='family']">
            <xsl:apply-templates />
            <xsl:call-template name="and-list">
              <xsl:with-param name="nameCount" select="count($names)" />
              <xsl:with-param name="position" select="position()" />
            </xsl:call-template>
          </xsl:for-each>
          <xsl:if test="$ref/bltx:names[@type='author']/@morenames='1'">
            <xsl:text> et al.</xsl:text>
          </xsl:if>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$ref/bltx:date[not(@type)]" />
        </xsl:when>
        <xsl:otherwise>
          <strong><xsl:value-of select="@key" /></strong>
        </xsl:otherwise>
      </xsl:choose>
    </a>
    <xsl:if test="@pages">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@pages" />
    </xsl:if>
    <xsl:if test="string()">
      <xsl:text>, </xsl:text>
      <xsl:apply-templates />
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
