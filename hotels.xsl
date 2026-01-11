<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes" omit-xml-declaration="yes" />

    <xsl:param name="loadDocument">true</xsl:param>
    <xsl:param name="showAll">true</xsl:param>
    <xsl:param name="showId"></xsl:param>
    <xsl:param name="sortOn"></xsl:param>
    <xsl:param name="sortOrder">ascending</xsl:param>
    <xsl:param name="sortType">text</xsl:param>
    <xsl:param name="filterOn"></xsl:param>
    <xsl:param name="filterValue"></xsl:param>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$loadDocument = 'true'">
                <xsl:call-template name="loadDocument" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="loadContent" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="loadDocument">
        <html lang="en">
            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <title>Luxury Hotel Catalogue</title>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous"/>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
                <link rel="stylesheet" href="hotels-styles.css" />
            </head>
            <body>
                <nav class="navbar navbar-dark bg-primary mb-4">
                    <div class="container">
                        <span class="navbar-brand mb-0 h1">
                            <i class="fas fa-hotel me-2"></i>
                            Luxury Hotel Catalogue
                        </span>
                    </div>
                </nav>
                <div id="content" class="container">
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"/>
                <script src="script.js"></script>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="loadContent">
        <xsl:choose>
            <xsl:when test="$showAll = 'true'">
                <div class="row mb-5">
                    <div class="col-12">
                        <div class="filter-card">
                            <div class="card-body">
                                <h5 class="mb-4" style="color: #111827; font-weight: 600;">
                                    <i class="fas fa-sliders-h me-2" style="color: #667eea;"></i>Filter &amp; Sort
                                </h5>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label small text-muted mb-2">Property Type</label>
                                        <div class="dropdown">
                                            <button class="btn btn-outline-primary dropdown-toggle w-100" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                <i class="fas fa-building me-2"></i>Property Type
                                            </button>
                                            <ul class="dropdown-menu w-100">
                                                <li><button onclick="filterBy('','')" class="dropdown-item"><i class="fas fa-th me-2"></i>All Properties</button></li>
                                                <li><hr class="dropdown-divider"/></li>
                                                <li><button onclick="filterBy('property','hotel')" class="dropdown-item"><i class="fas fa-hotel me-2"></i>Hotels</button></li>
                                                <li><button onclick="filterBy('property','resort')" class="dropdown-item"><i class="fas fa-umbrella-beach me-2"></i>Resorts</button></li>
                                                <li><button onclick="filterBy('property','apartment')" class="dropdown-item"><i class="fas fa-home me-2"></i>Apartments</button></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small text-muted mb-2">Category</label>
                                        <div class="dropdown">
                                            <button class="btn btn-outline-primary dropdown-toggle w-100" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                <i class="fas fa-star me-2"></i>Category
                                            </button>
                                            <ul class="dropdown-menu w-100">
                                                <li><button onclick="filterBy('','')" class="dropdown-item"><i class="fas fa-th me-2"></i>All Categories</button></li>
                                                <li><hr class="dropdown-divider"/></li>
                                                <li><button onclick="filterBy('category','business')" class="dropdown-item"><i class="fas fa-briefcase me-2"></i>Business</button></li>
                                                <li><button onclick="filterBy('category','boutique')" class="dropdown-item"><i class="fas fa-gem me-2"></i>Boutique</button></li>
                                                <li><button onclick="filterBy('category','beach')" class="dropdown-item"><i class="fas fa-umbrella-beach me-2"></i>Beach</button></li>
                                                <li><button onclick="filterBy('category','budget')" class="dropdown-item"><i class="fas fa-wallet me-2"></i>Budget</button></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small text-muted mb-2">Sort By</label>
                                        <div class="dropdown">
                                            <button class="btn btn-outline-success dropdown-toggle w-100" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                <i class="fas fa-sort me-2"></i>Sort
                                            </button>
                                            <ul class="dropdown-menu w-100">
                                                <li><button onclick="orderBy('rating','descending','number')" class="dropdown-item"><i class="fas fa-star me-2"></i>Rating (High to Low)</button></li>
                                                <li><button onclick="orderBy('stars','descending','number')" class="dropdown-item"><i class="fas fa-star me-2"></i>Stars (5 to 1)</button></li>
                                                <li><hr class="dropdown-divider"/></li>
                                                <li><button onclick="orderBy('price','ascending','number')" class="dropdown-item"><i class="fas fa-arrow-up me-2"></i>Price (Low to High)</button></li>
                                                <li><button onclick="orderBy('price','descending','number')" class="dropdown-item"><i class="fas fa-arrow-down me-2"></i>Price (High to Low)</button></li>
                                                <li><button onclick="orderBy('name','ascending','text')" class="dropdown-item"><i class="fas fa-sort-alpha-down me-2"></i>Name (A to Z)</button></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                        <xsl:choose>
                        <xsl:when test="$sortOn = 'rating'">
                            <xsl:for-each select="catalogue/hotels/hotel">
                                <xsl:sort select="rating" data-type="number" order="{$sortOrder}"/>
                                <xsl:call-template name="renderHotelCard"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$sortOn = 'stars'">
                            <xsl:for-each select="catalogue/hotels/hotel">
                                <xsl:sort select="stars" data-type="number" order="{$sortOrder}"/>
                                <xsl:call-template name="renderHotelCard"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$sortOn = 'price'">
                            <xsl:for-each select="catalogue/hotels/hotel">
                                <xsl:sort select="price" data-type="number" order="{$sortOrder}"/>
                                <xsl:call-template name="renderHotelCard"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$sortOn = 'name'">
                            <xsl:for-each select="catalogue/hotels/hotel">
                                <xsl:sort select="name" data-type="text" order="{$sortOrder}"/>
                                <xsl:call-template name="renderHotelCard"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                            <xsl:for-each select="catalogue/hotels/hotel">
                                <xsl:call-template name="renderHotelCard"/>
                            </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="mb-4">
                    <button onclick="showAllHotels()" class="btn btn-outline-primary" style="border-radius: 10px; padding: 0.6rem 1.5rem;">
                        <i class="fas fa-arrow-left me-2"></i>Back to All Hotels
                    </button>
                </div>
                
                <xsl:variable name="hotel" select="catalogue/hotels/hotel[@id=$showId]"/>
                
                <div class="card hotel-card">
                    <div class="row g-0">
                        <div class="col-lg-6">
                            <img src="{$hotel/thumbnail/@source}" class="img-fluid h-100" style="object-fit: cover;" alt="{$hotel/name}"/>
                        </div>
                        <div class="col-lg-6">
                            <div class="card-body h-100 d-flex flex-column">
                                <div class="mb-3">
                                    <h2 class="card-title mb-2"><xsl:value-of select="$hotel/name"/></h2>
                                    <div class="d-flex align-items-center mb-2">
                                        <div class="star-rating me-3">
                                            <xsl:call-template name="stars">
                                                <xsl:with-param name="starsCount" select="$hotel/stars"/>
                                            </xsl:call-template>
                                        </div>
                                        <div class="rating-badge me-3">
                                            <strong><xsl:value-of select="$hotel/rating"/></strong>
                                        </div>
                                        <small class="text-muted"><xsl:value-of select="$hotel/review_count"/> reviews</small>
                                    </div>
                                    <span class="category-badge mb-2 d-inline-block">
                                        <i class="fas fa-building me-2"></i>
                                        <xsl:value-of select="$hotel/category"/>
                                        <xsl:text> • </xsl:text>
                                        <xsl:value-of select="$hotel/@property_type"/>
                                    </span>
                                    <p class="text-muted">
                                        <i class="fas fa-map-marker-alt me-2"></i><xsl:value-of select="$hotel/address"/>
                                    </p>
                                </div>
                                
                                <p class="card-text mb-3"><xsl:value-of select="$hotel/description"/></p>
                                
                                <div class="row mb-3">
                                    <div class="col-6">
                                        <small class="text-muted d-block">Check-in</small>
                                        <strong><xsl:value-of select="$hotel/checkin_time"/></strong>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted d-block">Check-out</small>
                                        <strong><xsl:value-of select="$hotel/checkout_time"/></strong>
                                    </div>
                                </div>
                                
                                <div class="mt-auto pt-3" style="border-top: 2px solid #f3f4f6;">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="price-highlight">
                                            <strong>
                                                <xsl:value-of select="$hotel/price"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:call-template name="currencySymbol">
                                                    <xsl:with-param name="currencyCode" select="$hotel/price/@currency"/>
                                                </xsl:call-template>
                                            </strong>
                                            <small>per night</small>
                                        </div>
                                        <div>
                                            <a href="tel:{$hotel/phone}" class="btn btn-outline-primary me-2" style="border-radius: 10px; padding: 0.6rem 1.2rem;">
                                                <i class="fas fa-phone me-2"></i>Call
                                            </a>
                                            <a href="{$hotel/website}" target="_blank" class="btn btn-booking">
                                                <i class="fas fa-calendar-check me-2"></i>Book Now
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <xsl:if test="$hotel/gallery/image">
                    <div class="card hotel-card mt-4">
                        <div class="card-body">
                            <h4 class="card-title mb-4" style="color: #111827; font-weight: 700;">
                                <i class="fas fa-images me-2" style="color: #667eea;"></i>Photo Gallery
                            </h4>
                            <div class="row g-3">
                                <xsl:for-each select="$hotel/gallery/image">
                                    <div class="col-md-4 col-sm-6">
                                        <div class="gallery-item">
                                            <img src="{@source}" class="img-fluid w-100 gallery-image" alt="{$hotel/name} - Image {position()}"/>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                    </div>
                </xsl:if>
                
                <div class="card hotel-card mt-4">
                    <div class="card-body">
                        <h4 class="card-title mb-4" style="color: #111827; font-weight: 700;">
                            <i class="fas fa-concierge-bell me-2" style="color: #667eea;"></i>Hotel Amenities
                        </h4>
                        <div class="row">
                            <xsl:for-each select="$hotel/amenities/@*">
                                <xsl:variable name="amenityClass">
                                    <xsl:choose>
                                        <xsl:when test=". = 'false'">false</xsl:when>
                                        <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                                <div class="col-md-3 col-sm-6 mb-2">
                                    <span class="amenity-badge {$amenityClass}">
                                        <xsl:choose>
                                            <xsl:when test="name() = 'wi-fi'"><i class="fas fa-wifi me-1"></i>WiFi</xsl:when>
                                            <xsl:when test="name() = 'parking'"><i class="fas fa-parking me-1"></i>Parking</xsl:when>
                                            <xsl:when test="name() = 'pool'"><i class="fas fa-swimming-pool me-1"></i>Pool</xsl:when>
                                            <xsl:when test="name() = 'spa'"><i class="fas fa-spa me-1"></i>Spa</xsl:when>
                                            <xsl:when test="name() = 'fitness'"><i class="fas fa-dumbbell me-1"></i>Fitness</xsl:when>
                                            <xsl:when test="name() = 'restaurant'"><i class="fas fa-utensils me-1"></i>Restaurant</xsl:when>
                                            <xsl:when test="name() = 'bar'"><i class="fas fa-cocktail me-1"></i>Bar</xsl:when>
                                            <xsl:when test="name() = 'breakfast'"><i class="fas fa-coffee me-1"></i>Breakfast</xsl:when>
                                            <xsl:when test="name() = 'room-service'"><i class="fas fa-room-service me-1"></i>Room Service</xsl:when>
                                            <xsl:when test="name() = 'airport-shuttle'"><i class="fas fa-bus me-1"></i>Airport Shuttle</xsl:when>
                                            <xsl:when test="name() = 'conference-rooms'"><i class="fas fa-users me-1"></i>Conference Rooms</xsl:when>
                                            <xsl:when test="name() = 'pets'"><i class="fas fa-paw me-1"></i>Pet Friendly</xsl:when>
                                            <xsl:otherwise><i class="fas fa-check me-1"></i><xsl:value-of select="translate(name(), '-', ' ')"/></xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:if test=". = 'false'"> <i class="fas fa-times ms-1"></i></xsl:if>
                                    </span>
                                </div>
                            </xsl:for-each>
                        </div>
                    </div>
                </div>
                
                <div class="card hotel-card mt-4">
                    <div class="card-body">
                        <h4 class="card-title mb-4" style="color: #111827; font-weight: 700;">
                            <i class="fas fa-bed me-2" style="color: #667eea;"></i>Available Rooms
                        </h4>
                        <div class="row">
                            <xsl:for-each select="$hotel/rooms/room">
                                <div class="col-lg-6 mb-3">
                                    <div class="room-card p-3">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h6 class="mb-1"><xsl:value-of select="type"/></h6>
                                                <small class="text-muted">
                                                    <i class="fas fa-bed me-1"></i><xsl:value-of select="beds"/> bed(s) • 
                                                    <i class="fas fa-users ms-2 me-1"></i><xsl:value-of select="capacity"/> guests • 
                                                    <i class="fas fa-expand-arrows-alt ms-2 me-1"></i><xsl:value-of select="size"/>m²
                                                </small>
                                            </div>
                                            <div class="text-end">
                                                <div class="price-highlight">
                                                    <strong>
                                                        <xsl:value-of select="price_per_night"/>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:call-template name="currencySymbol">
                                                            <xsl:with-param name="currencyCode" select="../../price/@currency"/>
                                                        </xsl:call-template>
                                                    </strong>
                                                    <small class="text-muted">/night</small>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="mt-2">
                                            <small class="text-muted d-block mb-1">Room Features:</small>
                                            <div class="d-flex flex-wrap">
                                                <xsl:for-each select="facilities/@*[. = 'true']">
                                                    <small class="amenity-badge me-1 mb-1" style="font-size: 0.75rem;">
                                                        <xsl:value-of select="translate(name(), '-_', '  ')"/>
                                                    </small>
                                                </xsl:for-each>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="renderHotelCard">
                        <xsl:variable name="shouldShow">
                            <xsl:choose>
                <xsl:when test="$filterOn = 'property' and @property_type = $filterValue">true</xsl:when>
                <xsl:when test="$filterOn = 'category' and category = $filterValue">true</xsl:when>
                                <xsl:when test="$filterOn = ''">true</xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:if test="$shouldShow = 'true'">
                            <div class="col-lg-6 col-xl-4 mb-4">
                                <div class="card hotel-card h-100">
                                    <img src="{thumbnail/@source}" class="hotel-image" alt="{name}"/>
                                    <div class="card-body d-flex flex-column">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h5 class="card-title mb-1"><xsl:value-of select="name"/></h5>
                                                <div class="star-rating mb-1">
                                                    <xsl:call-template name="stars">
                                                        <xsl:with-param name="starsCount" select="stars"/>
                                                    </xsl:call-template>
                                                </div>
                                                <span class="category-badge">
                                                    <xsl:value-of select="category"/>
                                                    <xsl:text> • </xsl:text>
                                                    <xsl:value-of select="@property_type"/>
                                                </span>
                                            </div>
                                            <div class="text-end">
                                                <div class="rating-badge mb-1">
                                                    <strong><xsl:value-of select="rating"/></strong>
                                                </div>
                                                <small class="text-muted"><xsl:value-of select="review_count"/> reviews</small>
                                            </div>
                                        </div>
                                        
                                        <p class="card-text flex-grow-1 mb-3" style="color: #555; line-height: 1.6;">
                                            <xsl:value-of select="substring(description, 1, 120)"/>
                                            <xsl:if test="string-length(description) > 120">...</xsl:if>
                                        </p>
                                        
                                        <div class="mb-3">
                                            <div class="d-flex flex-wrap align-items-center">
                                                <xsl:if test="amenities/@wi-fi = 'true'">
                                                    <span class="amenity-badge"><i class="fas fa-wifi me-1"></i>Free WiFi</span>
                                                </xsl:if>
                                                <xsl:if test="amenities/@parking = 'true'">
                                                    <span class="amenity-badge"><i class="fas fa-parking me-1"></i>Parking</span>
                                                </xsl:if>
                                                <xsl:if test="amenities/@pool = 'true'">
                                                    <span class="amenity-badge"><i class="fas fa-swimming-pool me-1"></i>Pool</span>
                                                </xsl:if>
                                                <xsl:if test="amenities/@spa = 'true'">
                                                    <span class="amenity-badge"><i class="fas fa-spa me-1"></i>Spa</span>
                                                </xsl:if>
                                                <xsl:if test="amenities/@breakfast = 'true'">
                                                    <span class="amenity-badge"><i class="fas fa-coffee me-1"></i>Breakfast</span>
                                                </xsl:if>
                                                <xsl:if test="amenities/@restaurant = 'true'">
                                                    <span class="amenity-badge"><i class="fas fa-utensils me-1"></i>Restaurant</span>
                                                </xsl:if>
                                            </div>
                                        </div>
                                        
                                        <div class="d-flex justify-content-between align-items-center mt-auto pt-3" style="border-top: 2px solid #f3f4f6; padding-top: 1.25rem;">
                                            <div class="price-highlight">
                                                <strong>
                                                    <xsl:value-of select="price"/>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:call-template name="currencySymbol">
                                                        <xsl:with-param name="currencyCode" select="price/@currency"/>
                                                    </xsl:call-template>
                                                </strong>
                                                <small>/night</small>
                                            </div>
                                            <button onclick="showHotelInfo('{@id}')" class="btn btn-booking">
                                                <i class="fas fa-arrow-right me-2"></i>View Details
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </xsl:if>
    </xsl:template>

    <xsl:template name="currencySymbol">
        <xsl:param name="currencyCode"/>
        <xsl:choose>
            <xsl:when test="$currencyCode = 'EUR'">€</xsl:when>
            <xsl:when test="$currencyCode = 'USD'">$</xsl:when>
            <xsl:when test="$currencyCode = 'BGN'">лв</xsl:when>
            <xsl:when test="$currencyCode = 'GBP'">£</xsl:when>
            <xsl:when test="$currencyCode = 'JPY'">¥</xsl:when>
            <xsl:when test="$currencyCode = 'CHF'">CHF</xsl:when>
            <xsl:when test="$currencyCode = 'CAD'">C$</xsl:when>
            <xsl:when test="$currencyCode = 'AUD'">A$</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$currencyCode"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="stars">
        <xsl:param name="starsCount"/>
        <xsl:call-template name="generateStars">
            <xsl:with-param name="positiveIterations" select="$starsCount"/>
            <xsl:with-param name="negativeIterations" select="5 - $starsCount"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="generateStars">
        <xsl:param name="positiveIterations"/>
        <xsl:param name="negativeIterations"/>
        
        <xsl:if test="$positiveIterations > 0">
            <i class="fas fa-star"></i>
            <xsl:call-template name="generateStars">
                <xsl:with-param name="positiveIterations" select="$positiveIterations - 1"/>
                <xsl:with-param name="negativeIterations" select="0"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="$negativeIterations > 0">
            <i class="far fa-star"></i>
            <xsl:call-template name="generateStars">
                <xsl:with-param name="positiveIterations" select="0"/>
                <xsl:with-param name="negativeIterations" select="$negativeIterations - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
