#!/usr/bin/env bash
#download https://repository-master.mulesoft.org/nexus/service/local/repositories/releases/content/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz

install_mule() {
  local install_dir=${1}
  local cache_dir=${2}
  echo -n "-----> Installing Mule..."
  let start=$(nowms)
  MULE_COMMON_BUILDPACK=${MULE_COMMON_BUILDPACK:-https://repository-master.mulesoft.org/nexus/service/local/repositories/releases/content/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz}
  
  if [ ! -f $HOME/mule-standalone-3.9.0 ] ; then

    echo -n " Downloading .... "

    mkdir -p $HOME/mule-standalone-3.9.0/
    curl --retry 3 --silent --location $MULE_COMMON_BUILDPACK | tar xzm -C $HOME/mule-standalone-3.9.0/ --strip-components=1
    chmod +x $HOME/mule-standalone-3.9.0/bin/mule
    chmod +w $HOME/mule-standalone-3.9.0/apps/
    chmod +w $HOME/mule-standalone-3.9.0/

  fi

  export MULE_HOME=$HOME/mule-standalone-3.9.0/

  echo "Done"
}