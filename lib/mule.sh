#!/usr/bin/env bash
#download https://repository-master.mulesoft.org/nexus/service/local/repositories/releases/content/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz

install_mule() {
  local install_dir=${1}
  local cache_dir=${2}
  echo -n "-----> Installing Mule...$install_dir"
  let start=$(nowms)
  MULE_COMMON_BUILDPACK=${MULE_COMMON_BUILDPACK:-https://repository-master.mulesoft.org/nexus/service/local/repositories/releases/content/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz}
  
  if [ ! -d dist/mule-standalone-3.9.0 ] ; then

    echo -n " Downloading .... "

    mkdir -p dist/mule-standalone-3.9.0/
    curl --retry 3 --silent --location $MULE_COMMON_BUILDPACK | tar xzm -C dist/mule-standalone-3.9.0/ --strip-components=1
    chmod +x dist/mule-standalone-3.9.0/bin/mule
    chmod +w dist/mule-standalone-3.9.0/apps/
    chmod +w dist/mule-standalone-3.9.0/

  fi

  echo -n "$(ls -lha dist)"

  #export MULE_HOME=/app/mule-standalone-3.9.0/

  echo "Done"
}