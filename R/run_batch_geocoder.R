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


#' Run Batch Geocoding Pipeline
#'
#' Submits multiple CSV files to the BC Address Geocoder batch service,
#' waits for completion, and downloads results to an output directory.
#'
#' @param input_dir Character string. Directory containing input CSV files.
#' @param output_dir Character string. Directory where geocoded output files
#'   will be written.
#' @param pattern Character string. Regex pattern used to select input files.
#'   Defaults to `"cleaned_part\\d*.csv"`.
#' @param throttle Numeric. Seconds to wait between job submissions.
#'
#' @return Invisibly returns a tibble with file paths, job IDs, and outputs.
#'
#' @details
#' Sequential batch pipeline:
#' - submit_job()
#' - wait_for_job()
#' - download_results()
#'
#' Failures are logged but do not stop execution.
#'
#' @importFrom purrr map_chr pwalk
#' @importFrom dplyr mutate
#' @importFrom tibble tibble
#' @importFrom fs path path_file path_ext_remove
#'
#' @keywords internal
run_batch_geocoder <- function(input_dir,
                               output_dir,
                               pattern = "cleaned_part\\d*.csv",
                               throttle = 20) {
  
  files <- list.files(input_dir, pattern = pattern, full.names = TRUE) |>
    sort()
  
  log_message(
    "Submitting %d files",
    length(files)
  )
  
  jobs <- tibble::tibble(file = files) |>
    dplyr::mutate(
      job_id = purrr::map_chr(file, function(f) {
        id <- submit_job(f)
        Sys.sleep(throttle)
        id
      }),
      output = fs::path(
        output_dir,
        paste0(
          fs::path_ext_remove(fs::path_file(file)),
          "_geocoded.csv"
        )
      )
    )
  
  log_message("Retrieving results")
  
  purrr::pwalk(jobs, function(file, job_id, output) {
    tryCatch({
      wait_for_job(job_id)
      
      download_results(job_id, output)
      
      log_message("Completed %s", basename(file))
    },
    error = function(e) {
      log_message("FAILED %s : %s", basename(file), e$message)
    })
  })
  
  invisible(jobs)
}
