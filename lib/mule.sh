#!/usr/bin/env bash
#download https://repository-master.mulesoft.org/nexus/service/local/repositories/releases/content/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz

download_mule() {
  local install_dir=${1}
  local cache_dir=${2}

  let start=$(nowms)
  MULE_COMMON_BUILDPACK=${MULE_COMMON_BUILDPACK:-https://repository-master.mulesoft.org/nexus/service/local/repositories/releases/content/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz}
  mkdir -p /opt/mule-standalone-3.9.0/
  curl --retry 3 --silent --location $MULE_COMMON_BUILDPACK | tar xzm -C /opt/mule-standalone-3.9.0/ --strip-components=1
  chmod +x /opt/mule-standalone-3.9.0/bin/mule
  chmod +w /opt/mule-standalone-3.9.0/apps/
  chmod +w /opt/mule-standalone-3.9.0/

  export MULE_HOME=/opt/mule-standalone-3.9.0/
}