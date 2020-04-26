<?xml version="1.0" encoding="windows-1250" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">

    <xsl:output method="html" indent="yes" />

    <!-- Variables(?) -->
    <xsl:param name="stylesheet">
        <xsl:text>style.css</xsl:text>
    </xsl:param>

    <xsl:param name="rights">
        <!-- 'full' for admin access, 'partial' for user access-->
        <xsl:text>full</xsl:text>
    </xsl:param>
    <!-- Variabled end -->


    <xsl:param name="const-rights-full">
        <xsl:text>full</xsl:text>
    </xsl:param>

    <xsl:param name="const-right-partial">
        <xsl:text>partial</xsl:text>
    </xsl:param>

    <!-- root, mode selects if all information is available -->
    <xsl:template match="/">
        <html lang="en">
            <head>
                <title>
                    <xsl:value-of select="/drm/@owner" />
                </title>

                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$stylesheet" />
                    </xsl:attribute>
                </link>
            </head>
            <body>
                <div id="content-wrapper">
                    <h1>
                        <xsl:text>XSLT Transform - </xsl:text>
                        <xsl:value-of select="/drm/@owner" />
                    </h1>
                    <div id="game-wrapper">
                        <h2 class="section-header">
                            Games
                        </h2>
                        <xsl:for-each select="/drm/games/game">
                            <xsl:sort select="title" />
                            <xsl:call-template name="game-transform" />
                        </xsl:for-each>
                    </div>
                    <div id="dev-wrapper">
                        <h2 class="section-header">
                            Developers
                        </h2>
                        <xsl:for-each select="/drm/developers/developer">
                            <xsl:sort select="name" />
                            <xsl:call-template name="dev-transform" />
                        </xsl:for-each>
                    </div>
                    <div id="pub-wrapper">
                        <h2 class="section-header">
                            Publishers
                        </h2>
                        <xsl:for-each select="/drm/publishers/publisher">
                            <xsl:sort select="name" />
                            <xsl:call-template name="pub-transform" />
                        </xsl:for-each>
                    </div>
                    <div id="user-wrapper">
                        <h2 class="section-header">
                            Users
                        </h2>
                        <xsl:for-each select="/drm/users/user">
                            <xsl:sort select="nickname" />
                            <xsl:call-template name="user-transform" />
                        </xsl:for-each>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Named templates -->

    <xsl:template name="game-transform">
        <div class="section-item">
            <xsl:attribute name="id">
                <xsl:value-of select="@id-self" />
            </xsl:attribute>

            <h3 class="title padded-left">
                <xsl:value-of select="title" />
            </h3>

            <p>
                <b>Date published: </b>
                <xsl:value-of select="creation-date" />
            </p>

            <p>
                <xsl:apply-templates select="description" />
            </p>

            <xsl:choose>
                <xsl:when test="reviews/review">
                    <h4>Reviews:</h4>
                    <xsl:apply-templates select="reviews/review" />
                </xsl:when>
                <xsl:otherwise>
                    <h4>-- No reviews --</h4>
                </xsl:otherwise>
            </xsl:choose>

            <div>
                <xsl:choose>
                    <xsl:when test="achievements/achievement">
                        <h4>Achievements:</h4>
                        <xsl:choose>
                            <xsl:when test="$rights=$const-rights-full">
                                <xsl:apply-templates select="achievements/achievement" mode="all" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="achievements/achievement" mode="public" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <h4>-- No achievements available --</h4>
                    </xsl:otherwise>
                </xsl:choose>
            </div>

            <div>
                <xsl:choose>
                    <xsl:when test="ingame-store/ingame-item">
                        <h4>Store:</h4>
                        <xsl:apply-templates select="ingame-store/ingame-item" />
                    </xsl:when>
                    <xsl:otherwise>
                        <h4>-- No store available --</h4>
                    </xsl:otherwise>
                </xsl:choose>
            </div>

        </div>
    </xsl:template>

    <xsl:template name="dev-transform">
        <div>
            <xsl:attribute name="id">
                <xsl:value-of select="@id-self" />
            </xsl:attribute>

            <h3 class="title padded-left">
                <xsl:value-of select="name" />
            </h3>

            <p>
                <b>Date founded: </b>
                <xsl:value-of select="creation-date" />
            </p>

            <xsl:apply-templates select="description" />

        </div>
    </xsl:template>

    <xsl:template name="pub-transform">
        <div>
            <xsl:attribute name="id">
                <xsl:value-of select="@id-self" />
            </xsl:attribute>

            <h3 class="title padded-left">
                <xsl:value-of select="name" />
                <xsl:if test="website/@url">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="website/@url"/>
                        </xsl:attribute>
                        <xsl:text>&#128279;</xsl:text>
                    </a>
                </xsl:if>
            </h3>

            <p>
                <b>Date founded: </b>
                <xsl:value-of select="creation-date" />
            </p>

            <!-- In contrast to applying templates to other descriptions, this one isn't mixed -->
            <p>
                <xsl:value-of select="plain-description" />
            </p>
        </div>
    </xsl:template>

    <xsl:template name="user-transform">
        <div>
            <xsl:attribute name="id">
                <xsl:value-of select="@id-self" />
            </xsl:attribute>

            <h3 class="title padded-left">
                <xsl:value-of select="nickname" />
                <xsl:if test="verified">
                    <span class="accent">&#128504;</span> <!-- TODO img maybe? Sign should be check-mark -->
                </xsl:if>
            </h3>

            <h6>
                <xsl:value-of select="email" />
            </h6>

            <p>Owned games: </p>

            <xsl:if test="owned-games">
                <ul>
                    <xsl:for-each select="owned-games/owned-game">
                        <li>
                            <xsl:call-template name="owned-game-transform" />
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:if>

            <xsl:if test="not(owned-games/owned-game)">
                <p> -- None -- </p>
            </xsl:if>

        </div>
    </xsl:template>

    <xsl:template name="owned-game-transform">
        <div>
            <xsl:variable name="gameId" select="@id-game" />
            <a>
                <xsl:attribute name="href">
                    <xsl:text>&#35;</xsl:text>
                    <xsl:value-of select="$gameId" />
                </xsl:attribute>
                <xsl:value-of select="/drm/games/game[@id-self=$gameId]/title" />
            </a>
            <p>
                <xsl:text>Date bought: </xsl:text>
                <xsl:value-of select="creation-date" />
            </p>
            <p>
                <xsl:text>Time played: </xsl:text>
                <xsl:value-of select="time-played" />
            </p>
            <xsl:if test="ingame-inventory/inventory-item">
                <p>Owned in-game items: </p>
                <ul>
                    <xsl:for-each select="ingame-inventory/inventory-item">
                        <li>
                            <xsl:variable name="itemId" select="@id-item" />
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:text>&#35;</xsl:text>
                                    <xsl:value-of select="$itemId" />
                                </xsl:attribute>
                                <xsl:value-of select="/drm/games/game[@id-self=$gameId]/ingame-store/ingame-item[@id-self=$itemId]/title" />
                            </a>
                            <xsl:text> - </xsl:text>
                            <xsl:value-of select="quantity" />
                            <xsl:text> pieces.</xsl:text>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:if>

            <xsl:if test="@id-achs">
                <p>Achievements: </p>
                <xsl:variable name="achIds" select="@id-achs" />
                <ul>
                    <xsl:for-each select="/drm/games/game[@id-self=$gameId]/achievements/achievement">
                        <xsl:choose>
                            <xsl:when test="contains($achIds,@id-self)">
                                <li class="accent">
                                    <xsl:text>&#9745; </xsl:text>
                                    <xsl:value-of select="title" />
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li class="disabled">
                                    <xsl:text>&#9744; </xsl:text>
                                    <xsl:value-of select="title" />
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>

        </div>
    </xsl:template>

    <!-- Anonymous templates -->

    <xsl:template match="review">
        <div class="padded-left">
            <p>
                <xsl:value-of select="text" />
            </p>

            <p>
                <xsl:variable name="authorId" select="@author" />
                By
                <xsl:value-of select="/drm/users/user[@id-self=$authorId]/nickname" />
                at
                <xsl:value-of select="creation-date" />
            </p>

            <xsl:if test="comment-section">
                <div>
                    <xsl:apply-templates select="comment-section/comment" />
                </div>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="general-reference">
        <a>
            <xsl:attribute name="href">
                <xsl:text>&#35;</xsl:text>
                <xsl:value-of select="@id-reference" />
            </xsl:attribute>
            <xsl:value-of select="text()" />
        </a>
    </xsl:template>

    <xsl:template match="achievement" mode="all">
        <div class="cell position-relative">
            <xsl:attribute name="id">
                <xsl:value-of select="@id-self" />
            </xsl:attribute>
            <h3>
                <xsl:value-of select="title" />
            </h3>
            <!-- Shows if the achievement is secret -->
            <xsl:if test="secret">
                <p class="position-absolute top-10 right-10 m-0 cell">
                    ?
                </p>
            </xsl:if>
            <p>
                <xsl:value-of select="plain-description" />
            </p>
            <p>
                <xsl:text>External data: </xsl:text>
                <xsl:value-of select="external-data" />
            </p>
            <p>
                <xsl:text>Reward: </xsl:text>
                <xsl:value-of select="points" />
            </p>
        </div>
    </xsl:template>

    <xsl:template match="achievement" mode="public">
        <div class="cell">
            <xsl:attribute name="id">
                <xsl:value-of select="@id-self" />
            </xsl:attribute>
            <h3>
                <xsl:value-of select="title" />
            </h3>
            <xsl:choose>
                <xsl:when test="secret">
                    <p>
                        <xsl:value-of select="plain-description" />
                    </p>
                </xsl:when>
                <xsl:otherwise>
                    <p>
                        <xsl:text>Pst! It's a secret.</xsl:text>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
            <p>
                <xsl:text>External data: </xsl:text>
                <xsl:value-of select="external-data" />
            </p>
            <p>
                <xsl:text>Reward: </xsl:text>
                <xsl:value-of select="points" />
            </p>
        </div>
    </xsl:template>

    <xsl:template match="ingame-item">
        <div class="cell">
            <xsl:attribute name="id">
                <xsl:value-of select="@id-self" />
            </xsl:attribute>
            <h3>
                <xsl:value-of select="title" />
            </h3>
            <p>
                <xsl:value-of select="plain-description" />
            </p>
            <xsl:if test="max-per-user > 0">
                <p>
                    <xsl:text>Limit per user: </xsl:text>
                    <xsl:value-of select="max-per-user" />
                </p>
            </xsl:if>
            <p>
                <xsl:text>Price: </xsl:text>
                <xsl:value-of select="price" />
            </p>
        </div>
    </xsl:template>

</xsl:stylesheet>