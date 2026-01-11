(function() {
    'use strict';

    window.imageUrlsMap = [];
    window.state = {
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
    const dtdPath = "hotels.dtd";

    window.xsltProcessor = null;
    window.xmlDoc = null;

    function updateImageSource() {
        if (window.imageUrlsMap && window.imageUrlsMap.length > 0) {
            window.imageUrlsMap.forEach(e => { 
                document.querySelectorAll(`[src="${e[0]}"]`).forEach(el => el.setAttribute("src", e[1]));
            });
        }
    }

    async function loadDTD() {
        try {
            const dtdResponse = await fetch(dtdPath);
            const dtdData = await dtdResponse.text();
            window.imageUrlsMap = [];
            const re = /<!ENTITY\s+(\w+)\s+[^"]*"[^"]*"\s+"([^"]+)"[^>]*>/g;
            let m;
            while ((m = re.exec(dtdData)) !== null) {
                window.imageUrlsMap.push([m[1], m[2]]);
            }
        } catch(err) {
            console.error('Error loading DTD:', err);
        }
    }

    const initialize = async () => {
        try {
            const parser = new DOMParser();
            window.xsltProcessor = new XSLTProcessor();

            const xslResponse = await fetch(xslDocPath);
            const xslText = await xslResponse.text();
            const xslStylesheet = parser.parseFromString(xslText, "application/xml");
            window.xsltProcessor.importStylesheet(xslStylesheet);

            const xmlResponse = await fetch(xmlDocPath);
            const xmlText = await xmlResponse.text();
            window.xmlDoc = parser.parseFromString(xmlText, "application/xml");
            
            await loadDTD();
            updateContent();
        } catch(e) {
            console.error('Error loading XML/XSLT:', e);
        }
    };
    
    function updateContent() {
        if (!window.xsltProcessor || !window.xmlDoc) {
            setTimeout(updateContent, 100);
            return;
        }
        
        window.xsltProcessor.clearParameters();

        for (const [key, value] of Object.entries(window.state)) {
            window.xsltProcessor.setParameter(null, key, value);
        }

        let fragment = window.xsltProcessor.transformToFragment(window.xmlDoc, document);

        const contentDiv = document.getElementById("content");
        if (contentDiv) {
            contentDiv.textContent = "";
            contentDiv.appendChild(fragment);
            updateImageSource();
        }
    }

    window.orderBy = function(sortOn, sortOrder, sortType) {
        window.state.sortOn = sortOn;
        window.state.sortOrder = sortOrder;
        window.state.sortType = sortType;
        updateContent();
    };

    window.filterBy = function(filterOn, filterValue) {
        window.state.filterOn = filterOn;
        window.state.filterValue = filterValue;
        updateContent();
    };

    window.showHotelInfo = function(showId) {
        window.state.showAll = "false";
        window.state.showId = showId;
        updateContent();
    };

    window.showAllHotels = function() {
        window.state.showAll = "true";
        window.state.showId = "";
        updateContent();
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        initialize();
    }
})();
