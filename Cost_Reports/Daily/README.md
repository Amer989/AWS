# AWS Daily Cost Usage Tracker

A Python tool that generates comprehensive Excel reports of your AWS cost usage data.

## Overview

This tool uses the AWS SDK for Python (boto3) to fetch cost data from AWS Cost Explorer and organizes it into a detailed Excel spreadsheet. The report includes daily cost breakdowns by service, visualizations, and summary analytics to help you understand and manage your AWS spending.

## Features

- **Daily Cost Tracking**: View costs broken down by service for each day
- **Cost Visualization**: Bar charts showing daily total costs
- **Service Analysis**: Summary of total costs by service with percentage breakdown
- **Automated Formatting**: Professional Excel styling with proper headers, borders, and number formatting
- **Multiple Views**: Three worksheet perspectives (Daily Costs, Cost Chart, Cost Summary)

## Requirements

- Python 3.x
- Required Python packages:
  - boto3
  - pandas
  - openpyxl
- AWS credentials properly configured

## Installation

1. Clone this repository or download the script file
2. Install required dependencies:

```bash
pip install boto3 pandas openpyxl
```

3. Configure your AWS credentials using one of these methods:
   - AWS CLI: Run `aws configure`
   - Environment variables: Set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
   - AWS credentials file: `~/.aws/credentials`

## Usage

Run the script from the command line:

```bash
python aws_cost_tracker.py
```

The script will:
1. Fetch the last 30 days of AWS cost data
2. Process and organize the data
3. Generate an Excel file named `AWS_Daily_Costs_YYYYMMDD.xlsx` in the current directory

## Output File Structure

The generated Excel workbook contains three sheets:

1. **Daily Costs**
   - Pivot table showing costs by service for each day
   - Each service has its own column
   - Formatted with currency symbols and proper decimal places

2. **Cost Chart**
   - Bar chart visualization of total daily costs
   - Easy to identify spending trends and spikes

3. **Cost Summary**
   - Total cost by service, sorted from highest to lowest
   - Percentage breakdown of spending by service
   - Bar chart of top services by cost

## Customization

To modify the date range (default is last 30 days), edit the `main()` function:

```python
# Define a custom date range
end_date = "2025-04-27"  # Format: YYYY-MM-DD
start_date = "2025-03-27"  # Format: YYYY-MM-DD
```

## Troubleshooting

- **Authentication errors**: Ensure your AWS credentials are correctly configured
- **Missing data**: Verify that you have Cost Explorer enabled in your AWS account
- **Module not found errors**: Make sure all required packages are installed

## Notes

- The script requires access to AWS Cost Explorer API, which has a small delay in data availability (typically 24-48 hours)
- AWS Cost Explorer API usage may incur charges - check AWS pricing for details
