# Stock Service

## Features
- Fetch stock data for a given ticker symbol over a specified date range.
- Consolidate fetched data to calculate maximum, minimum, and average prices, as well as trading volumes.
- Use environment variables to securely manage API keys.
- Implement efficient error handling for non-existent tickers or API errors.


## Requirements
- Ruby 3.3.0
- HTTParty for making HTTP requests.
- Dotenv for managing environment variables.

## Installation

Clone the repository to your local machine:
```bash
git clone https://your-repository-url.git
cd your-repository-directory
```

Install the required gems:
```bash
bundle install
```

Set up your .env file with your Polygon.io API key:
```bash
POLYGON_API_KEY=your_api_key_here
```

## Testing

To run the tests, ensure you have RSpec installed and simply execute:
```bash
bundle exec rspec
```