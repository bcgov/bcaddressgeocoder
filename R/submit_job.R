# Copyright 2026 Province of British Columbia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.


#' Submit a Batch Geocoding Job
#'
#' Submits a CSV file to the BC Address Geocoder batch service for processing
#' and returns the assigned job ID.
#'
#' The function sends a multipart/form-data request containing the input file
#' and required geocoding parameters, then parses the response to extract the
#' job identifier.
#'
#' @param file Character string. Path to a CSV file containing input addresses
#'   to be geocoded.
#'
#' @return A character string representing the geocoder job ID.
#'
#' @details
#' The submitted job uses the following default parameters:
#' \itemize{
#'   \item Input format: CSV
#'   \item Output format: CSV
#'   \item Coordinate system: EPSG:4326
#'   \item Interpolation: adaptive
#'   \item Location descriptor: any
#'   \item Echo input: enabled
#' }
#'
#' If `.geocoder$email` is configured (via `configure_geocoder()`), it is
#' included as a notification email for job completion.
#'
#' The function relies on `geocoder_request()` for authentication and request
#' configuration, and uses `.geocoder` internal state.
#'
#' @seealso
#' \code{\link{configure_geocoder}}, \code{\link{geocoder_request}}
#'
#' @examples
#' \dontrun{
#' configure_geocoder("config.yml")
#' job_id <- submit_job("addresses.csv")
#' }
#'
#' @keywords internal
#'
submit_job <- function(file) {
  
  log_message("Submitting %s", basename(file))

  fields <- list(
    inputDataContentType = "csv",
    resultSrid = "4326",
    echo = "on",
    interpolation = "adaptive",
    locationDescriptor = "any",
    resultDataContentType = "csv",
    media = "application/json"
  )
  
  if (!is.null(.geocoder$email)) {
    fields$notificationEmail <- .geocoder$email
  }
  
  req <- geocoder_request("apps/geocoder/multiple.json") |>
    httr2::req_body_multipart(
      !!!fields,
      inputData = curl::form_file(file)
    )
  
  resp <- httr2::req_perform(req)
  
  job <- stringr::str_match(resp$url, "/jobs/(\\d+)/")[,2]
  
  if (is.na(job)) {
    body <- httr2::resp_body_json(resp)
    job <- stringr::str_match(body$id, "/jobs/(\\d+)/")[,2]
  }
  
  job
}
