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


#' Wait for a Geocoding Job to Complete
#'
#' Polls the BC Address Geocoder batch service until a submitted job reaches
#' a completed state or a timeout is exceeded.
#'
#' This function repeatedly checks job status at a controlled interval and
#' blocks execution until results are available.
#'
#' @param job_id Character string. The geocoder job ID returned by
#'   `submit_job()`.
#'
#' @param timeout Numeric. Maximum time in seconds to wait for job completion.
#'   Defaults to 600 seconds (10 minutes).
#'
#' @return Invisibly returns the `job_id` once the job reaches
#'   `"resultsCreated"` status.
#'
#' @details
#' The function polls the endpoint:
#' \code{jobs/{job_id}.json}
#'
#' at intervals specified by the service response field
#' `secondsToWaitForStatusCheck`, with safeguards:
#' \itemize{
#'   \item Minimum wait: 1 second
#'   \item Maximum wait: 30 seconds
#'   \item Default fallback: 5 seconds if missing
#' }
#'
#' The function stops with an error if the elapsed time exceeds `timeout`.
#'
#' @section Status behaviour:
#' The loop exits only when:
#' \itemize{
#'   \item `jobStatus == "resultsCreated"` (success)
#' }
#'
#' @seealso
#' \code{\link{submit_job}}, \code{\link{geocoder_request}}
#'
#' @examples
#' \dontrun{
#' job_id <- submit_job("addresses.csv")
#' wait_for_job(job_id)
#' }
#'
#' @keywords internal
#'
wait_for_job <- function(job_id,
                         timeout = 600) {
  
  start <- Sys.time()
  
  repeat {
    
    status <- geocoder_request(
      paste0("jobs/", job_id, ".json")
    ) |>
      httr2::req_perform() |>
      httr2::resp_body_json()
    
    if (status$jobStatus == "resultsCreated")
      return(invisible(job_id))
    
    elapsed <- as.numeric(
      difftime(Sys.time(), start, units = "secs")
    )
    
    if (elapsed > timeout)
      stop("Job timed out.")
    
    wait <- dplyr::coalesce(status$secondsToWaitForStatusCheck, 5)
    
    Sys.sleep(min(max(wait, 1), 30))
  }
}
