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

#' Configure BC Address Geocoder Settings
#'
#' Loads geocoder configuration settings from a YAML file and stores them
#' in the internal `.geocoder` environment for use by other package functions.
#'
#' The configuration file is expected to contain a `default` section with
#' the following fields:
#' - `batch_service_url`
#' - `batch_username`
#' - `batch_password`
#' - `batch_email`
#'
#' @param config_file Path to a YAML configuration file. Defaults to
#'   `"config.yml"` in the working directory.
#'
#' @return Invisibly updates the internal `.geocoder` environment.
#' @details This function is typically called once per session before making
#'   any requests to the BC Address Geocoder batch service.
#'
#' @examples
#' \dontrun{
#' configure_geocoder("config.yml")
#' }
#'
#' @export
configure_geocoder <- function(config_file = "config.yml") {
  
  cfg <- yaml::read_yaml(config_file)$default
  
  .geocoder$service_url <- cfg$batch_service_url
  .geocoder$username <- cfg$batch_username
  .geocoder$password <- cfg$batch_password
  .geocoder$email <- cfg$batch_email
}

