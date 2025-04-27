# Quarterly AWS Cost Reporter

A powerful Python application that generates comprehensive quarterly AWS cost reports in Excel format, providing detailed analysis and visualization of your AWS spending.

## Overview

This application connects to the AWS Cost Explorer API to retrieve and analyze your AWS costs for a specified quarter. It organizes the data into a professional Excel report featuring multiple worksheets with detailed breakdowns, visualizations, and trend analysis to help you understand your cloud spending patterns.

## Features

- **Quarterly Cost Analysis**: Generate detailed reports for any quarter
- **Flexible Grouping Options**: Group costs by service, account, region, or custom tags
- **Multiple Data Granularities**: View data at daily or monthly levels
- **Comprehensive Excel Reports**: Five detailed worksheets for thorough analysis:
  - Daily/Monthly Breakdown: Costs by time period
  - Quarterly Summary: Total costs with percentages
  - Cost Trends: Visual trends over the quarter
  - Top Cost Drivers: Analysis of biggest spending areas
  - Report Info: Metadata and notes
- **Professional Visualizations**: Multiple chart types for better data understanding
- **Command Line Interface**: Easy to use with customizable parameters

## Requirements

- Python 3.6+
- Required Python packages:
  - boto3
  - pandas
  - openpyxl
- AWS credentials properly configured
- AWS Cost Explorer API access enabled

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

### Basic Usage

To generate a report for the current quarter:

```bash
python quarterly_aws_cost_reporter.py
```

### Specify Quarter and Year

```bash
python quarterly_aws_cost_reporter.py --quarter 2 --year 2025
```

### Change Data Granularity

View monthly data (default):

```bash
python quarterly_aws_cost_reporter.py --granularity monthly
```

View daily data:

```bash
python quarterly_aws_cost_reporter.py --granularity daily
```

### Group by Different Dimensions

```bash
# Group by service (default)
python quarterly_aws_cost_reporter.py --group-by service

# Group by AWS account
python quarterly_aws_cost_reporter.py --group-by account

# Group by AWS region
python quarterly_aws_cost_reporter.py --group-by region

# Group by a specific tag
python quarterly_aws_cost_reporter.py --group-by tag --tag-key Environment
```

### Additional Options

```bash
# Custom output file
python quarterly_aws_cost_reporter.py --output "reports/Q2_2025_Costs.xlsx"

# Use a specific AWS profile
python quarterly_aws_cost_reporter.py --profile production

# Specify AWS region
python quarterly_aws_cost_reporter.py --region us-west-2
```

## Output File

The generated Excel workbook contains five worksheets:

1. **Daily/Monthly Breakdown**
   - Costs broken down by the selected dimension for each day or month
   - Formatted with currency symbols and proper decimal places

2. **Quarterly Summary**
   - Total costs grouped by the selected dimension
   - Percentage breakdown of each item's contribution to total cost
   - Pie chart visualization of cost distribution

3. **Cost Trends**
   - Time-series visualization of costs over the quarter
   - Line chart (daily data) or bar chart (monthly data)

4. **Top Cost Drivers**
   - Analysis of the top 5 cost contributors
   - Bar chart visualization
   - Cost and percentage breakdown

5. **Report Info**
   - Metadata about the report (generation time, period, settings)
   - Notes about data sources and limitations

## Automating Reports

You can schedule this script to run quarterly using cron (Linux/Mac) or Task Scheduler (Windows):

### Linux/Mac Cron Example

```bash
# Run on the 1st day of the first month of each quarter (Jan, Apr, Jul, Oct)
0 1 1 1,4,7,10 * /path/to/python /path/to/quarterly_aws_cost_reporter.py
```

### Windows Task Scheduler

Create a batch file (run_quarterly_report.bat):
```batch
@echo off
cd /d C:\path\to\script\directory
python quarterly_aws_cost_reporter.py
```

Then schedule this batch file to run quarterly.

## Further Customization

This script can be extended to:
- Email reports to stakeholders
- Upload reports to S3 or other storage
- Compare costs against budgets
- Add year-over-year comparisons

## Troubleshooting

- **Authentication errors**: Verify AWS credentials are configured correctly
- **Missing data**: Ensure Cost Explorer is enabled in your AWS account
- **"Access Denied" errors**: Check IAM permissions for Cost Explorer access
- **Missing modules**: Install all required Python packages

## Notes

- AWS Cost Explorer API has a data delay of approximately 24-48 hours
- API usage may incur charges - check AWS pricing details
- For large AWS organizations, report generation may take longer
