<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd" />

    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <title>Hotels catalogue</title>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" />
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
                <style>
                    .yellow {
                        color: orange;
                    }
                </style>
            </head>
            <body>
                <h1 class="text-center mt-5 mb-3 display-4">Hotels catalogue</h1>
                <div id="content" class="p-5">
                    <xsl:call-template name="loadContent" />
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="loadContent">

        <div class="d-flex flex-wrap">
            <xsl:for-each select="catalogue/hotels/hotel">

                <xsl:sort select="stars" data-type="text" order="descending"/>
                <xsl:variable name="regId" select="@region" />
                <xsl:variable name="chainId" select="@chain" />
                <xsl:variable name="parsedImg" select="unparsed-entity-uri(thumbnail/@source)" />

                <div class="col-6 " id="{@id}">
                    <div class="m-3 align-self-stretch d-flex border rounded">
                      
                            <div class="col-md-4 border">
                                <img src="{$parsedImg}" class="img-fluid rounded-start" />
                            </div>
                            <div class="col-md-8">
                                <div class="">
                                    <h5 class="card-title">
                                        <xsl:value-of select="name" />
                                        <small class="text-body-secondary">
                                            <xsl:text>(</xsl:text>
                                            <xsl:value-of select="category" />
                                            <xsl:text>)</xsl:text>
                                        </small>
                                        <span class="p-2" />
                                        <xsl:call-template name="stars">
                                            <xsl:with-param name="starsCount" select="stars" />
                                        </xsl:call-template>
                                    </h5>
                                    <p class="">
                                        <xsl:call-template name="regionShow">
                                            <xsl:with-param name="regId" select="$regId" />
                                        </xsl:call-template>
                                    </p>
                                    <xsl:if test="$chainId != ''">
                                        <p class="card-text">
                                            Part of: <xsl:value-of select="/catalogue/chains/chain[@id=$chainId]" />
                                        </p>
                                    </xsl:if>
                                    <p class=" text-body-secondary">
                                        <xsl:text>Rating: </xsl:text>
                                        <xsl:value-of select="rating" />
                                        <xsl:text> / 10</xsl:text>
                                    </p>
                                </div>
                        </div>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>



    <xsl:template name="stars">
        <xsl:param name="starsCount"/>

        <xsl:call-template name="starIterator">
            <xsl:with-param name="iterations" select="5" />
            <xsl:with-param name="positiveIterations" select="5 - $starsCount" />
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="starIterator">
        <xsl:param name="iterations" />
        <xsl:param name="positiveIterations" />
        <xsl:choose>
            <xsl:when test="$iterations &gt; 0">
                <xsl:choose>
                    <xsl:when test="$iterations &gt; $positiveIterations">
                        <span class="fa fa-star yellow"></span>
                    </xsl:when>

                    <xsl:otherwise>
                        <span class="fa fa-star"></span>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:call-template name="starIterator">
                    <xsl:with-param name="iterations" select="$iterations - 1"/>
                    <xsl:with-param name="positiveIterations" select="$positiveIterations"/>
                </xsl:call-template>

            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="beds">
        <xsl:param name="bedsCount"/>

        <xsl:call-template name="bedIterator">
            <xsl:with-param name="iterations" select="$bedsCount" />
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="bedIterator">
        <xsl:param name="iterations" />
        <xsl:choose>
            <xsl:when test="$iterations &gt; 0">
                <span class="fa fa-bed m-1"></span>

                <xsl:call-template name="bedIterator">
                    <xsl:with-param name="iterations" select="$iterations - 1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="regionShow">
        <xsl:param name="regId"/>
        <span>
            <xsl:value-of select="/catalogue/regions/region[@id=$regId]/country" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="/catalogue/regions/region[@id=$regId]/municipality" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="/catalogue/regions/region[@id=$regId]/city" />
        </span>
    </xsl:template>

</xsl:stylesheet>