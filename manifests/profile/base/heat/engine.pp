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
# == Class: tripleo::profile::base::heat::engine
#
# Heat Engine profile for tripleo
#
# === Parameters
#
# [*sync_db*]
#   (Optional) Whether to run db sync
#   Defaults to undef
#
# [*manage_service*]
#   (Optional) Whether to manage the heat engine service
#   Defaults to undef
#
# [*enabled*]
#   (Optional) Whether to enable the heat engine service
#   Defaults to undef
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
class tripleo::profile::base::heat::engine (
  $sync_db        = true,
  $manage_service = undef,
  $enabled        = undef,
  $step           = hiera('step'),
) {

  if $step >= 3 and $sync_db {
    include ::heat::db::mysql
  }

  if $step >= 4 or ( $step >= 3 and $sync_db ) {
    include ::tripleo::profile::base::heat
    class { '::heat::engine' :
      sync_db        => $sync_db,
      manage_service => $manage_service,
      enabled        => $enabled,
    }
  }

}
