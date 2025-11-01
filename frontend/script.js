const apiEndpoint = "https://nlj7rqkia6.execute-api.us-east-1.amazonaws.com/prod/stocks"; // Your API Gateway URL
const stocksContainer = document.getElementById("stocks-container");
const alertsContainer = document.getElementById("alerts-container");

async function fetchStockData() {
  try {
    const response = await fetch(apiEndpoint);
    const data = await response.json();

    // Clear previous data
    stocksContainer.innerHTML = '';
    alertsContainer.innerHTML = '';

    data.forEach(stock => {
      // Safely extract values
      const symbol = stock.symbol || "N/A";
      const price = typeof stock.price === "number" ? stock.price.toFixed(2) : "N/A";
      const timestamp = stock.timestamp || "Unknown time";

      // Create stock card
      const card = document.createElement("div");
      card.className = "stock-card";

      card.innerHTML = `
        <h3>${symbol}</h3>
        <p class="price">$${price}</p>
        <p class="timestamp">⏰ ${timestamp}</p>
      `;

      stocksContainer.appendChild(card);
    });

  } catch (err) {
    console.error("Error fetching stock data:", err);
  }
}

// Initial fetch
fetchStockData();

// Auto-refresh every 30s
setInterval(fetchStockData, 30000);
