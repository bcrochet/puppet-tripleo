# Copyright 2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: tripleo::profile::base::zaqar
#
# Zaqar profile for tripleo
#
# === Parameters
#
# [*sync_db*]
#   (Optional) Whether to run db sync
#   Defaults to true
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::profile::base::zaqar (
  $sync_db          = true,
  $step             = hiera('step'),
) {

  if $step >= 3 and $sync_db {
    include ::zaqar::db::mysql
  }

  if $step >= 4 or ( $step >= 3 and $sync_db ) {
    include ::mongodb::globals
    include ::mongodb::server
    include ::mongodb::client

    include ::zaqar
    include ::zaqar::management::mongodb
    include ::zaqar::messaging::mongodb
    include ::zaqar::keystone::auth
    include ::zaqar::transport::websocket
    include ::zaqar::transport::wsgi

    include ::zaqar::server
    zaqar::server_instance{ 1:
      transport => 'websocket'
    }
  }
}

