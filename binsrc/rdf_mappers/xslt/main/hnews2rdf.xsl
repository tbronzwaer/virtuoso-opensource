<?xml version="1.0" encoding="Windows-1252"?>
<!--
 -
 -  $Id$
 -
 -  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
 -  project.
 -
 -  Copyright (C) 1998-2010 OpenLink Software
 -
 -  This project is free software; you can redistribute it and/or modify it
 -  under the terms of the GNU General Public License as published by the
 -  Free Software Foundation; only version 2 of the License, dated June 1991.
 -
 -  This program is distributed in the hope that it will be useful, but
 -  WITHOUT ANY WARRANTY; without even the implied warranty of
 -  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 -  General Public License for more details.
 -
 -  You should have received a copy of the GNU General Public License along
 -  with this program; if not, write to the Free Software Foundation, Inc.,
 -  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
-->
<xsl:stylesheet
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:rss="http://purl.org/rss/1.0/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
xmlns:foaf="http://xmlns.com/foaf/0.1/"
xmlns:skos="http://www.w3.org/2004/02/skos/core#"
xmlns:dcterms="http://purl.org/dc/terms/"
xmlns:admin="http://webns.net/mvcb/"
xmlns:h="http://www.w3.org/1999/xhtml"
xmlns:owl="http://www.w3.org/2002/07/owl#"
xmlns:hrev="http:/www.purl.org/stuff/hrev#"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:bibo="http://purl.org/ontology/bibo/"
xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
xmlns:geo  ="http://www.w3.org/2003/01/geo/wgs84_pos#"
xmlns:vi="http://www.openlinksw.com/virtuoso/xslt/"
version="1.0">

  <xsl:output indent="yes" omit-xml-declaration="yes" method="xml"/>
  
  <xsl:param name="baseUri" />
  
  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates />
    </rdf:RDF>
  </xsl:template>


  <xsl:template match="*[contains(@class, 'hnews hentry')]">
    <rdf:Description rdf:about="{$baseUri}">
      <foaf:primaryTopic rdf:resource="{vi:proxyIRI ($baseUri)}"/>
    </rdf:Description>
    <bibo:Article rdf:about="{vi:proxyIRI ($baseUri)}">
      <xsl:apply-templates mode="hnews"/>
    </bibo:Article>
  </xsl:template>

  <xsl:template match="*" mode="hnews">
    <xsl:variable name="class" select="@class" />
    
    <xsl:variable name="field">
      <xsl:choose>
        <xsl:when test="substring($class, string-length($class)-1)= 'fn' and substring($class, 1, string-length($class)-3) != ''">
          <xsl:value-of select="substring($class, 1, string-length($class)-3)" />
        </xsl:when>
        <xsl:when test="substring($class, 1, 3)='fn' and substring($class, 3, string-length($class)+1) != ''">
          <xsl:value-of select="substring($class, 3, string-length($class)+1)" />
        </xsl:when>
        <xsl:when test="$class='reviewbody description'">
          <xsl:value-of select="'description'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$class" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="rel">
      <xsl:value-of select="@rel" />
    </xsl:variable>
    
    <xsl:choose>
      
      <xsl:when test="contains($field, 'entry-title')">
        <dc:title>
          <xsl:value-of select="." />
        </dc:title>
        <xsl:if test="@rel='bookmark'">
          <bibo:uri rdf:resource="{@href}" />
        </xsl:if>
      </xsl:when>

      <xsl:when test="contains($field, 'updated')">
        <dcterms:modified>
          <xsl:value-of select="@title" />
        </dcterms:modified>
      </xsl:when>

      <xsl:when test="contains($field, 'dateline')">
        <vcard:locality>
          <xsl:value-of select="."/>
        </vcard:locality>
      </xsl:when>

      <xsl:when test="$field='author vcard'">
        <dcterms:creator>
          <foaf:Person>
            <foaf:name>
              <xsl:value-of select="./*[@class='fn']"/>
            </foaf:name>
          </foaf:Person>
        </dcterms:creator>
      </xsl:when>
      
      <xsl:when test="contains($field, 'entry-content')">
        <bibo:content>
          <xsl:value-of select="."/>
        </bibo:content>
      </xsl:when>

      <xsl:when test="contains($field, 'latitude')">
        <geo:lat rdf:datatype="http://www.w3.org/2001/XMLSchema#double">
          <xsl:value-of select="."/>
        </geo:lat>
      </xsl:when>

      <xsl:when test="contains($field, 'longitude')">
        <geo:long rdf:datatype="http://www.w3.org/2001/XMLSchema#double">
          <xsl:value-of select="."/>
        </geo:long>
      </xsl:when>

      <xsl:when test="contains($rel, 'item-license')">
        <dc:rights>
          <xsl:value-of select=".."/>
        </dc:rights>
      </xsl:when>

      <xsl:when test="contains($rel, 'principles')">
        <rdfs:seeAlso rdf:resource="{@href}"/>
      </xsl:when>
      
    </xsl:choose>

    <xsl:apply-templates mode="hnews" />

  </xsl:template>

  <xsl:template match="text()" mode="hnews" />
  <xsl:template match="text()" />

</xsl:stylesheet>
