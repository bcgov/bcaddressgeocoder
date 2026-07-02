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

#' Download Geocoding Job Results
#'
#' Downloads the completed results of a BC Address Geocoder batch job and
#' writes them to a local file.
#'
#' The function first retrieves the job metadata to locate the result file,
#' then downloads the result content and saves it as a binary file.
#'
#' @param job_id Character string. The geocoder job ID returned by
#'   `submit_job()`.
#'
#' @param output_file Character string. Path to the file where results will
#'   be saved (e.g., `"results.csv"`).
#'
#' @return Invisibly returns `output_file`.
#'
#' @details
#' The function performs two steps:
#' \enumerate{
#'   \item Queries \code{jobs/{job_id}/results.json} to obtain the result
#'   resource URI.
#'   \item Downloads the result file using HTTP digest authentication.
#' }
#'
#' The downloaded file is written using `writeBin()` without modification.
#'
#' @seealso
#' \code{\link{submit_job}}, \code{\link{wait_for_job}}
#'
#' @examples
#' \dontrun{
#' job_id <- submit_job("addresses.csv")
#' wait_for_job(job_id)
#' download_results(job_id, "results.csv")
#' }
#'
#' @export
#'
download_results <- function(job_id,
                             output_file) {
  
  results <- geocoder_request(
    paste0("jobs/", job_id, "/results.json")
  ) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  
  url <- results$resources[[1]]$resourceUri
  
  raw <- httr2::request(url) |>
    httr2::req_options(
      httpauth = 2L,
      userpwd = paste(.geocoder$username, .geocoder$password, sep = ":")
    ) |>
    httr2::req_perform() |>
    httr2::resp_body_raw()
  
  writeBin(raw, output_file)
  
  invisible(output_file)
}