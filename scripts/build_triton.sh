#!/usr/bin/env bash
# Copyright (c) 2023, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
export TRITON_SERVER_IMAGE=$1
export PYTRITON_IMAGE_NAME=$2
export PLATFORM=$3

set -x

docker pull -q --platform "${PLATFORM}" "${PYTRITON_IMAGE_NAME}"

if [[ "$(docker images -q "${PYTRITON_IMAGE_NAME}" 2> /dev/null)" == "" ]] || [[ "${PYTRITON_IMAGE_REBUILD}" == "1" ]]; then
  docker build --platform "${PLATFORM}" \
    --build-arg FROM_IMAGE="${TRITON_SERVER_IMAGE}" \
    --file scripts/Dockerfile.build \
    --tag "${PYTRITON_IMAGE_NAME}" .
fi