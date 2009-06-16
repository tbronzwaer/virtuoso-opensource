<?xml version="1.0" encoding="UTF-8"?>
<!--
 -
 -  $Id$
 -
 -  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
 -  project.
 -
 -  Copyright (C) 1998-2009 OpenLink Software
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
<!DOCTYPE xsl:stylesheet [
<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#">
<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<!ENTITY bibo "http://purl.org/ontology/bibo/">
<!ENTITY foaf "http://xmlns.com/foaf/0.1/">
<!ENTITY dcterms "http://purl.org/dc/terms/">
<!ENTITY sioc "http://rdfs.org/sioc/ns#">
<!ENTITY gr "http://purl.org/goodrelations/v1#">
]>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:vi="http://www.openlinksw.com/virtuoso/xslt/"
    xmlns:rdf="&rdf;"
    xmlns:foaf="&foaf;"
    xmlns:bibo="&bibo;"
    xmlns:sioc="&sioc;"
    xmlns:dcterms="&dcterms;"
    xmlns:gr="&gr;"
    xmlns:ebay="urn:ebay:apis:eBLBaseComponents">

    <xsl:output method="xml" indent="yes" />

    <xsl:param name="baseUri"/>

    <xsl:variable name="resourceURL">
	<xsl:value-of select="$baseUri"/>
    </xsl:variable>

    <xsl:variable name="ns">urn:ebay:apis:eBLBaseComponents</xsl:variable>

    <xsl:template priority="1" match="Timestamp|Ask|Version|Build"/>

    <xsl:template match="GetSingleItemResponse|Item" priority="1">
	<xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="/">
	<rdf:RDF>
	    <rdf:Description rdf:about="{$resourceURL}">
		<rdf:type rdf:resource="&foaf;Document"/>
		<rdf:type rdf:resource="&bibo;Document"/>
		<rdf:type rdf:resource="&sioc;Container"/>
		<sioc:container_of rdf:resource="{vi:proxyIRI ($resourceURL)}"/>
		<foaf:primaryTopic rdf:resource="{vi:proxyIRI ($resourceURL)}"/>
		<dcterms:subject rdf:resource="{vi:proxyIRI ($resourceURL)}"/>
	    </rdf:Description>
	    <rdf:Description rdf:about="{vi:proxyIRI ($resourceURL)}">
		<rdf:type rdf:resource="&sioc;Item"/>
				<rdf:type rdf:resource="&gr;ProductOrService"/>
		<sioc:has_container rdf:resource="{$resourceURL}"/>
		<xsl:apply-templates/>
	    </rdf:Description>
	</rdf:RDF>
    </xsl:template>

    <xsl:template match="*[starts-with(.,'http://') or starts-with(.,'urn:')]">
    <xsl:if test="string-length(.) &gt; 0">
	<xsl:element namespace="{$ns}" name="{name()}">
	    <xsl:attribute name="rdf:resource">
		<xsl:value-of select="."/>
	    </xsl:attribute>
	</xsl:element>
	</xsl:if>
    </xsl:template>

    <xsl:template match="Title">
		<rdfs:label>
			<xsl:value-of select="."/>
		</rdfs:label>
    </xsl:template>
    
    <xsl:template match="Location">
		<gr:availableAtOrFrom>
			<xsl:value-of select="."/>
		</gr:availableAtOrFrom>
    </xsl:template>

    <xsl:template match="ConvertedCurrentPrice">
		<gr:hasPriceSpecification>
		  <gr:UnitPriceSpecification>
            <gr:hasCurrencyValue rdf:datatype="&xsd;float"><xsl:value-of select="."/></gr:hasCurrencyValue>
            <gr:hasCurrency rdf:datatype="&xsd;string"><xsl:value-of select="@currencyID"/></gr:hasCurrency>
			<gr:valueAddedTaxIncluded rdf:datatype="&xsd;boolean">true</gr:valueAddedTaxIncluded>
          </gr:UnitPriceSpecification>
		</gr:hasPriceSpecification>
    </xsl:template>

    <xsl:template match="*[* and ../../*]">
	<xsl:element namespace="{$ns}" name="{name()}">
	    <xsl:attribute name="rdf:parseType">Resource</xsl:attribute>
	    <xsl:apply-templates select="@*|node()"/>
	</xsl:element>
    </xsl:template>

    <xsl:template match="*">
    <xsl:if test="string-length(.) &gt; 0">
	<xsl:element namespace="{$ns}" name="{name()}">
	    <xsl:apply-templates select="@*|node()"/>
	</xsl:element>
	</xsl:if>
    </xsl:template>
</xsl:stylesheet>
