[![img](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)

# bcAddressGeocodeR

This package is for interacting with the 
[**BC Address Batch Geocoder Service**](https://www2.gov.bc.ca/gov/content/data/geographic-data-services/location-services/geocoder),
providing tools to submit, monitor, and retrieve batch geocoding jobs. This package is not a geocoder itself.

The code is based on the [ols-devkit python code](https://github.com/bcgov/ols-devkit/blob/gh-pages/als/batch_address_list_submitter_py3_3.py), 
and translated with the help of AI.

`bc_address_geocoder_r` provides a simple workflow for batch geocoding:

1. Configure API credentials
2. Run geocoding process

## Features

- Submit CSV files to the Batch Geocoder Service
- Poll job status until completion
- Download results automatically
- Batch processing support for multiple files
- Basic logging for monitoring progress

## Installation

Install the development version from GitHub:

```r
remotes::install_github("bcgov/bc_address_geocoder_r")
```
## Usage
### 1. Configure credentials
```r
configure_geocoder("config.yml")
```
Example config.yml:
```yaml
default:
  batch_service_url: "https://..."
  batch_username: "your-username"
  batch_password: "your-password"
  batch_email: "your-email@example.com"
```
### 2. Run batch processing
```r
run_batch_geocoder(
  input_dir = "data/input",
  output_dir = "data/output"
)
```

### Single job
Alternately, this package can be used to run a single job
```r
job_id <- submit_job("data/addresses.csv")
wait_for_job(job_id)
download_results(job_id, "results.csv")
```

## Project Status

Experimental

## Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/bcsapps/issues/).

## How to Contribute

If you would like to contribute to the package, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

## License

    Copyright 2026 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.
