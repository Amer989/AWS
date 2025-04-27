# Monthly AWS Cost Reporter

A comprehensive Python application that generates detailed monthly AWS cost reports in Excel format.

## Overview

This application pulls AWS cost data for a specified month using the AWS Cost Explorer API and creates a professional Excel report with detailed cost breakdowns, visualizations, and summaries. It allows you to analyze your AWS spending patterns, identify cost drivers, and track spending trends over time.

## Features

- **Monthly Cost Analysis**: Generate detailed reports for any month
- **Flexible Grouping**: Group costs by service, account, region, or custom tags
- **Multiple Report Views**:
  - Daily cost breakdown by dimension
  - Monthly summary with percentages
  - Visual charts and graphs
  - Cost trends tracking
- **Professional Formatting**: Styled Excel reports with proper headers, borders, and formatting
- **Command Line Interface**: Easy to use with customizable parameters
- **AWS Profile Support**: Works with named AWS profiles for multi-account access

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

3. Ensure your AWS credentials are properly configured using one of these methods:
   - AWS CLI: Run `aws configure`
   - Environment variables: Set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
   - AWS credentials file: `~/.aws/credentials`

## Usage

### Basic Usage

To generate a report for the previous month:

```bash
python monthly_aws_cost_reporter.py
```

### Specify Month and Year

To generate a report for a specific month:

```bash
python monthly_aws_cost_reporter.py --month 3 --year 2025
```

### Group by Different Dimensions

Group costs by AWS service (default):

```bash
python monthly_aws_cost_reporter.py --group-by service
```

Group costs by AWS account:

```bash
python monthly_aws_cost_reporter.py --group-by account
```

Group costs by AWS region:

```bash
python monthly_aws_cost_reporter.py --group-by region
```

Group costs by a specific AWS tag:

```bash
python monthly_aws_cost_reporter.py --group-by tag --tag-key Environment
```

### Additional Options

Specify an output file path:

```bash
python monthly_aws_cost_reporter.py --output "reports/March_2025_Costs.xlsx"
```

Use a specific AWS profile:

```bash
python monthly_aws_cost_reporter.py --profile production
```

Specify AWS region:

```bash
python monthly_aws_cost_reporter.py --region us-west-2
```

## Output File

The generated Excel workbook contains five sheets:

1. **Daily Breakdown**
   - Daily costs broken down by the selected dimension (service, account, region, or tag)
   - Includes a title indicating the report period

2. **Monthly Summary**
   - Total monthly cost by dimension, sorted from highest to lowest
   - Percentage breakdown showing contribution to total cost
   - Pie chart visualization of cost distribution (top 10 items)

3. **Daily Cost Chart**
   - Bar chart visualization of daily total costs
   - Makes it easy to identify spending patterns and anomalies

4. **Cost Trends**
   - Template for tracking month-over-month changes
   - Can be populated by combining data from multiple monthly reports

5. **Report Info**
   - Metadata about the report (generation time, period, grouping, etc.)
   - Notes about data sources and limitations

## Advanced Usage

### Automating Reports

You can easily schedule this script to run monthly using cron (Linux/Mac) or Task Scheduler (Windows):

#### Linux/Mac Cron Example

```bash
# Run at 1:00 AM on the 1st day of each month
0 1 1 * * /path/to/python /path/to/monthly_aws_cost_reporter.py
```

#### Windows Task Scheduler

Create a batch file (run_report.bat):
```batch
@echo off
cd /d C:\path\to\script\directory
python monthly_aws_cost_reporter.py
```

Then schedule this batch file to run monthly.

### Integrating with Other Systems

The script can be extended to:
- Email reports automatically
- Upload reports to S3
- Push data to a database
- Generate additional visualizations

## Troubleshooting

- **Authentication errors**: Ensure your AWS credentials are correctly configured
- **Missing data**: Verify that you have Cost Explorer enabled in your AWS account
- **"Access Denied" errors**: Check that your IAM permissions include Cost Explorer access
- **Module not found errors**: Make sure all required packages are installed

## Notes

- AWS Cost Explorer API has a delay in data availability (typically 24-48 hours)
- Cost Explorer API usage may incur charges - check AWS pricing for details
- For large AWS organizations, processing time may be longer due to data volume
