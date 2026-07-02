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

#' Create a BC Address Geocoder HTTP Request
#'
#' Builds a pre-configured `httr2` request object for the BC Address Geocoder
#' batch service using credentials and settings stored in the internal
#' `.geocoder` environment.
#'
#' This function constructs the full request URL using the configured service
#' URL and applies required authentication and timeout settings.
#'
#' @param path Character string specifying the API endpoint path to append to
#'   the base service URL stored in `.geocoder`. Defaults to an empty string.
#'
#' @return An `httr2` request object configured with:
#' \itemize{
#'   \item Basic authentication (username/password from `.geocoder`)
#'   \item A 600-second timeout
#' }
#'
#' @details This function assumes that `configure_geocoder()` has already been
#'   called and that `.geocoder` contains:
#' \itemize{
#'   \item `service_url`
#'   \item `username`
#'   \item `password`
#' }
#'
#' @examples
#' \dontrun{
#' configure_geocoder("config.yml")
#' req <- geocoder_request("/batch/jobs")
#' }
#'
#' @export
geocoder_request <- function(path = "") {
  
  httr2::request(paste0(.geocoder$service_url, path)) |>
    httr2::req_options(
      httpauth = 2L,
      userpwd = paste(.geocoder$username, .geocoder$password, sep = ":")
    ) |>
    httr2::req_timeout(60)
}

#' Log a Timestamped Message
#'
#' Prints a formatted log message to the console with a timestamp prefix.
#' This is a simple utility for lightweight logging during geocoding
#' operations and debugging workflows.
#'
#' @param ... Arguments passed to `sprintf()` to format the message.
#'   The first argument should be a format string, followed by values.
#'
#' @return Invisibly returns `NULL`. The function is called for its side
#'   effect of printing a message to the console.
#'
#' @details The log format is:
#' \preformatted{
#' YYYY/MM/DD|HH:MM:SS|message
#' }
#'
#' @keywords internal
#'
log_message <- function(...) {
  
  cat(
    format(Sys.time(), "%Y/%m/%d|%H:%M:%S|"),
    sprintf(...),
    "\n",
    sep = ""
  )
}