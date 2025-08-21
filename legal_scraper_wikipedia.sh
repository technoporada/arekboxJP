#!/bin/bash
# legal_scraper_wikipedia.sh - Nauka scrapowania z legalnych źródeł
# Wymaga: curl, jq

scrape_wikipedia() {
    local query="$1"
    local url="https://pl.wikipedia.org/w/api.php?action=query&list=search&srsearch=$query&format=json"
    
    curl -s "$url" | jq '.query.search[] | "\(.title): \(.snippet)"'
}

# Użycie:
scrape_wikipedia "Linuks"

scrape_gov_data() {
    # Przykład: dane z GUS (statystyki publiczne)
    local url="https://bdl.stat.gov.pl/api/v1/data/by-variable/variable_id"
    curl -s "$url" | jq '.results'
}

