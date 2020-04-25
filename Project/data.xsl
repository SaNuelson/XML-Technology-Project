<?xml version="1.0" encoding="windows-1250" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">

    <xsl:output method="text" indent="yes" />

    <!-- root -->
    <xsl:template match="/">
        <html lang="en">
            <head>
                <title>
                    <xsl:text value="DRM HTML View"/>
                </title>
                <meta charset="utf-8"/>
                <meta name="author">
                    <xsl:attribute name="value">
                        <xsl:value-of select="@owner"/>
                    </xsl:attribute>
                </meta>
            </head>
            <body>

            </body>
        </html>
    </xsl:template>

    <xsl:template name="game">
        <div>
            <xsl:attribute name="id">
                <xsl:value-of select="@id-self"/>
            </xsl:attribute>

            <h3>
                <xsl:value-of select="title"/>
            </h3>

        </div>
    </xsl:template>

</xsl:stylesheet>