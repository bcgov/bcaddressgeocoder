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


#' BC Address Geocoder Internal State
#'
#' Internal environment used to store configuration settings for the BC Address
#' Geocoder batch service.
#'
#' This environment is created at package load time and is intended for
#' internal use only. It stores credentials and service configuration
#' required to authenticate and submit geocoding requests.
#'
#' @section Stored fields:
#' \describe{
#'   \item{service_url}{Base URL for the batch geocoder service}
#'   \item{username}{API username for authentication}
#'   \item{password}{API password for authentication}
#'   \item{email}{User email associated with the geocoder account}
#' }
#'
#' @keywords internal
#' @name geocoder-env
NULL

# Internal environment (not exported)
.geocoder <- new.env(parent = emptyenv())