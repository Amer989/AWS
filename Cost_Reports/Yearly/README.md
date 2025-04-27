# AWS Cost Analysis Tool Suite

A collection of Python scripts for generating detailed AWS cost reports at different time intervals (daily, monthly, quarterly, and yearly).

## Overview

This repository contains four Python applications designed to help AWS customers analyze and understand their cloud spending patterns. Each tool connects to the AWS Cost Explorer API and generates comprehensive Excel reports with breakdowns, visualizations, and analysis.

## Available Tools

### 1. Daily AWS Cost Tracker
- Tracks daily AWS costs
- Organizes costs by service, account, region, or tag
- Creates detailed Excel reports with daily breakdowns

### 2. Monthly AWS Cost Reporter
- Generates monthly cost analysis
- Provides service-level breakdowns
- Creates visualizations of cost patterns

### 3. Quarterly AWS Cost Reporter
- Analyzes costs over an entire quarter
- Supports daily or monthly granularity
- Identifies quarterly trends and top cost drivers

### 4. Yearly AWS Cost Reporter
- Provides comprehensive annual cost analysis
- Supports monthly or quarterly views
- Enables year-over-year comparisons

## Features

- **Flexible Grouping Options**: Group costs by service, account, region, or custom tags
- **Multiple Granularity Options**: View data at daily, monthly, or quarterly levels
- **Rich Visualizations**: Charts and graphs for better data understanding
- **Detailed Excel Reports**: Multiple worksheets with different analysis views
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

1. Clone this repository
2. Install required dependencies:

```bash
pip install boto3 pandas openpyxl
```

3. Configure your AWS credentials using one of these methods:
   - AWS CLI: Run `aws configure`
   - Environment variables: Set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
   - AWS credentials file: `~/.aws/credentials`

## Usage

### Daily Cost Tracker

```bash
python aws_cost_tracker.py
```

### Monthly Cost Reporter

Basic usage (generates report for previous month):
```bash
python monthly_aws_cost_reporter.py
```

Specify month and year:
```bash
python monthly_aws_cost_reporter.py --month 3 --year 2025
```

### Quarterly Cost Reporter

Basic usage (generates report for current quarter):
```bash
python quarterly_aws_cost_reporter.py
```

Specify quarter and year:
```bash
python quarterly_aws_cost_reporter.py --quarter 2 --year 2025
```

### Yearly Cost Reporter

Basic usage (generates report for previous year):
```bash
python yearly_aws_cost_reporter.py
```

Specify year:
```bash
python yearly_aws_cost_reporter.py --year 2024
```

### Common Options for All Scripts

Group costs by different dimensions:
```bash
python [script_name].py --group-by service  # Options: service, account, region, tag
```

Group by a specific tag:
```bash
python [script_name].py --group-by tag --tag-key Environment
```

Custom output file:
```bash
python [script_name].py --output "path/to/report.xlsx"
```

Use a specific AWS profile:
```bash
python [script_name].py --profile production
```

Specify AWS region:
```bash
python [script_name].py --region us-west-2
```

## Output Files

Each tool generates an Excel workbook containing multiple worksheets:

1. **Cost Breakdown**: Costs broken down by the selected dimension for each time period
2. **Summary**: Total costs with percentage breakdowns
3. **Visualizations**: Charts and graphs showing cost patterns
4. **Analysis**: Top cost drivers and comparative analysis
5. **Reference**: Metadata and notes about the report

## Automating Reports

You can schedule these scripts using cron (Linux/Mac) or Task Scheduler (Windows):

### Example: Monthly Report (Linux Cron)
```bash
# Run at 1:00 AM on the 3rd day of each month
0 1 3 * * /path/to/python /path/to/monthly_aws_cost_reporter.py
```

### Example: Yearly Report (Windows Task Scheduler)

Create a batch file:
```batch
@echo off
cd /d C:\path\to\script\directory
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set year=%datetime:~0,4%
set /a lastyear=%year%-1
python yearly_aws_cost_reporter.py --year %lastyear%
```

Then schedule this batch file to run annually.

## Best Practices

- Run reports a few days after the period ends to ensure all data is available
- Use consistent grouping dimensions for better cross-report comparisons
- Consider using the `--profile` option for multi-account environments
- Export data to BI tools for deeper analysis and custom dashboards
- Archive reports for historical tracking

## Troubleshooting

- **Authentication errors**: Verify AWS credentials are configured correctly
- **Missing data**: Ensure Cost Explorer is enabled in your AWS account
- **"Access Denied" errors**: Check IAM permissions for Cost Explorer access
- **Module not found errors**: Make sure all required packages are installed

## Notes

- AWS Cost Explorer API has a data delay of approximately 24-48 hours
- Cost Explorer API usage may incur charges - check AWS pricing for details
- For large AWS organizations, processing time may be longer due to data volume
