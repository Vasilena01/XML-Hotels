<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
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
                <style>
                    <xsl:text>
                    .hotel-card {
                        border-radius: 12px;
                        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                        transition: transform 0.2s ease;
                        margin-bottom: 2rem;
                    }
                    .hotel-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 8px 25px rgba(0,0,0,0.15);
                    }
                    .hotel-image {
                        height: 250px;
                        object-fit: cover;
                        border-radius: 12px 12px 0 0;
                    }
                    .star-rating {
                        color: #FFD700;
                    }
                    .rating-badge {
                        background: #003580;
                        color: white;
                        border-radius: 8px;
                        padding: 0.3rem 0.6rem;
                    }
                    .price-highlight {
                        color: #FF6B35;
                        font-weight: bold;
                    }
                    .amenity-badge {
                        background: #E8F5E8;
                        color: #2E7D32;
                        border-radius: 20px;
                        padding: 0.2rem 0.8rem;
                        margin: 0.2rem;
                        font-size: 0.85rem;
                    }
                    .amenity-badge.false {
                        background: #FFEBEE;
                        color: #C62828;
                    }
                    .room-card {
                        border: 1px solid #e0e0e0;
                        border-radius: 8px;
                        margin-bottom: 1rem;
                        transition: all 0.2s ease;
                    }
                    .room-card:hover {
                        border-color: #003580;
                        box-shadow: 0 2px 8px rgba(0,53,128,0.1);
                    }
                    .btn-booking {
                        background: #006CE4;
                        color: white;
                        border-radius: 4px;
                        padding: 0.5rem 1.5rem;
                        border: none;
                        font-weight: 600;
                    }
                    .btn-booking:hover {
                        background: #003580;
                        color: white;
                    }
                    </xsl:text>
                </style>
            </head>
            <body class="bg-light">
                <nav class="navbar navbar-dark bg-primary mb-4">
                    <div class="container">
                        <span class="navbar-brand mb-0 h1">
                            <i class="fas fa-hotel me-2"></i>
                            Luxury Hotel Catalogue
                        </span>
                    </div>
                </nav>
                <div id="content" class="container">
                    <!-- Content will be loaded dynamically by JavaScript -->
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"/>

                <script defer="true">
                    let imageUrlsMap = [
                    <xsl:for-each select="//*[boolean(@source)]">
                        <xsl:text>["</xsl:text>
                        <xsl:value-of select="@source"/>
                        <xsl:text>" , "</xsl:text>
                        <xsl:value-of select="unparsed-entity-uri(@source)"/>
                        <xsl:text>"], </xsl:text>
                    </xsl:for-each>
                    ];

                    const updateImageSource = () => {
                        imageUrlsMap.forEach(e => { 
                            document.querySelectorAll(`[src="${e[0]}"]`).forEach(el => el.setAttribute("src",e[1]));
                        });
                    };

                    let state = {
                        loadDocument: "false",
                        showAll: "true",
                        showId: "",
                        sortOn: "",
                        sortOrder: "ascending",
                        sortType: "text",
                        filterOn: "",
                        filterValue: ""
                    };

                    const xmlDocPath = "hotels.xml";
                    const xslDocPath = "hotels.xsl";

                    let xsltProcessor;
                    let xmlDoc;

                    const initialize = async () => {
                        try {
                            const parser = new DOMParser();
                            xsltProcessor = new XSLTProcessor();

                            const xslResponse = await fetch(xslDocPath);
                            const xslText = await xslResponse.text();
                            const xslStylesheet = parser.parseFromString(xslText, "application/xml");
                            xsltProcessor.importStylesheet(xslStylesheet);

                            const xmlResponse = await fetch(xmlDocPath);
                            const xmlText = await xmlResponse.text();
                            xmlDoc = parser.parseFromString(xmlText, "application/xml");
                        } catch(e) {
                            console.log('Error loading XML/XSLT:', e);
                        }

                        updateImageSource();
                    };
                    
                    const updateContent = () => {
                        if (!xsltProcessor || !xmlDoc) return;
                        
                        xsltProcessor.clearParameters();

                        for (const [key, value] of Object.entries(state)) {
                            xsltProcessor.setParameter(null, key, value);
                        }

                        let fragment = xsltProcessor.transformToFragment(xmlDoc,document);

                        document.getElementById("content").textContent = "";
                        document.getElementById("content").appendChild(fragment);

                        updateImageSource();
                    };

                    const orderBy = (sortOn, sortOrder, sortType) => {
                        state.sortOn = sortOn;
                        state.sortOrder = sortOrder;
                        state.sortType = sortType;
                        updateContent();
                    };

                    const filterBy = (filterOn, filterValue) => {
                        state.filterOn = filterOn;
                        state.filterValue = filterValue;
                        updateContent();
                    };

                    const showHotelInfo = (showId) => {
                        state.showAll = "false";
                        state.showId = showId;
                        updateContent();
                    };

                    const showAllHotels = () => {
                        state.showAll = "true";
                        state.showId = "";
                        updateContent();
                    };

                    initialize();
                </script>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="loadContent">
        <xsl:choose>
            <xsl:when test="$showAll = 'true'">
                <!-- Filter and Sort Controls -->
                <div class="row mb-4">
                    <div class="col-md-8 offset-md-2">
                        <div class="card">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-4">
                                        <div class="dropdown">
                                            <button class="btn btn-outline-primary dropdown-toggle w-100" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                <i class="fas fa-filter me-2"></i>Filter by Property Type
                                            </button>
                                            <ul class="dropdown-menu w-100">
                                                <li><button onclick="filterBy('','')" class="dropdown-item">All Properties</button></li>
                                                <li><button onclick="filterBy('property','hotel')" class="dropdown-item">Hotels</button></li>
                                                <li><button onclick="filterBy('property','resort')" class="dropdown-item">Resorts</button></li>
                                                <li><button onclick="filterBy('property','apartment')" class="dropdown-item">Apartments</button></li>
                                                <li><button onclick="filterBy('property','villa')" class="dropdown-item">Villas</button></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="dropdown">
                                            <button class="btn btn-outline-primary dropdown-toggle w-100" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                <i class="fas fa-star me-2"></i>Filter by Category
                                            </button>
                                            <ul class="dropdown-menu w-100">
                                                <li><button onclick="filterBy('','')" class="dropdown-item">All Categories</button></li>
                                                <li><button onclick="filterBy('category','luxury')" class="dropdown-item">Luxury</button></li>
                                                <li><button onclick="filterBy('category','business')" class="dropdown-item">Business</button></li>
                                                <li><button onclick="filterBy('category','boutique')" class="dropdown-item">Boutique</button></li>
                                                <li><button onclick="filterBy('category','budget')" class="dropdown-item">Budget</button></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="dropdown">
                                            <button class="btn btn-outline-success dropdown-toggle w-100" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                <i class="fas fa-sort me-2"></i>Sort Hotels
                                            </button>
                                            <ul class="dropdown-menu w-100">
                                                <li><button onclick="orderBy('rating','descending','number')" class="dropdown-item">Rating (High to Low)</button></li>
                                                <li><button onclick="orderBy('stars','descending','number')" class="dropdown-item">Stars (5 to 1)</button></li>
                                                <li><button onclick="orderBy('price','ascending','number')" class="dropdown-item">Price (Low to High)</button></li>
                                                <li><button onclick="orderBy('price','descending','number')" class="dropdown-item">Price (High to Low)</button></li>
                                                <li><button onclick="orderBy('name','ascending','text')" class="dropdown-item">Name (A to Z)</button></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hotels Grid -->
                <div class="row">
                    <xsl:variable name="hotels" select="catalogue/hotels/hotel"/>
                    <xsl:variable name="sortedHotels">
                        <xsl:choose>
                            <xsl:when test="$sortOn != ''">
                                <xsl:for-each select="$hotels">
                                    <xsl:sort select="*[name(.) = $sortOn]" data-type="{$sortType}" order="{$sortOrder}"/>
                                    <xsl:copy-of select="."/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="$hotels"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:for-each select="$sortedHotels/hotel">
                        <xsl:variable name="shouldShow">
                            <xsl:choose>
                                <xsl:when test="$filterOn = 'property' and @property = $filterValue">true</xsl:when>
                                <xsl:when test="$filterOn = 'category' and @category = $filterValue">true</xsl:when>
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
                                                <small class="text-muted text-capitalize"><xsl:value-of select="@category"/> <xsl:value-of select="@property"/></small>
                                            </div>
                                            <div class="text-end">
                                                <div class="rating-badge mb-1">
                                                    <strong><xsl:value-of select="rating"/></strong>
                                                </div>
                                                <small class="text-muted"><xsl:value-of select="review_count"/> reviews</small>
                                            </div>
                                        </div>
                                        
                                        <p class="card-text flex-grow-1">
                                            <xsl:value-of select="substring(description, 1, 120)"/>
                                            <xsl:if test="string-length(description) > 120">...</xsl:if>
                                        </p>
                                        
                                        <!-- Amenities Preview -->
                                        <div class="mb-3">
                                            <div class="d-flex flex-wrap">
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
                                            </div>
                                        </div>
                                        
                                        <div class="d-flex justify-content-between align-items-center mt-auto">
                                            <div class="price-highlight">
                                                <strong><xsl:value-of select="price"/>€</strong>
                                                <small class="text-muted">/night</small>
                                            </div>
                                            <button onclick="showHotelInfo('{@id}')" class="btn btn-booking">
                                                View Details
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </xsl:if>
                    </xsl:for-each>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <!-- Individual Hotel Detail View -->
                <div class="mb-3">
                    <button onclick="showAllHotels()" class="btn btn-outline-primary">
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
                                    <p class="text-muted text-capitalize mb-2">
                                        <i class="fas fa-building me-2"></i><xsl:value-of select="$hotel/@category"/> <xsl:value-of select="$hotel/@property"/>
                                    </p>
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
                                
                                <div class="mt-auto">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="price-highlight">
                                            <h4 class="mb-0"><xsl:value-of select="$hotel/price"/>€</h4>
                                            <small class="text-muted">per night</small>
                                        </div>
                                        <div>
                                            <a href="tel:{$hotel/phone}" class="btn btn-outline-primary me-2">
                                                <i class="fas fa-phone"></i>
                                            </a>
                                            <a href="{$hotel/website}" target="_blank" class="btn btn-booking">
                                                Book Now
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Amenities Section -->
                <div class="card hotel-card mt-4">
                    <div class="card-body">
                        <h4 class="card-title mb-3"><i class="fas fa-concierge-bell me-2"></i>Hotel Amenities</h4>
                        <div class="row">
                            <xsl:for-each select="$hotel/amenities/@*">
                                <div class="col-md-3 col-sm-6 mb-2">
                                    <span class="amenity-badge {if(. = 'false') then 'false' else ''}">
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
                
                <!-- Rooms Section -->
                <div class="card hotel-card mt-4">
                    <div class="card-body">
                        <h4 class="card-title mb-3"><i class="fas fa-bed me-2"></i>Available Rooms</h4>
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
                                                    <strong><xsl:value-of select="price_per_night"/></strong>
                                                    <small class="text-muted">/night</small>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Room Facilities -->
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

    <!-- Stars Template -->
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
                <xsl:with-param name="negativeIterations" select="$negativeIterations"/>
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
