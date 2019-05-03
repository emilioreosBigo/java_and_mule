#!/usr/bin/env bash
#download https://repository-master.mulesoft.org/nexus/service/local/repositories/releases/content/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz

install_mule() {
  local install_dir=${1}
  local cache_dir=${2}
  echo -n "-----> Installing Mule...$install_dir"
  let start=$(nowms)
  MULE_COMMON_BUILDPACK=${MULE_COMMON_BUILDPACK:-https://repository-master.mulesoft.org/nexus/service/local/repositories/releases/content/org/mule/distributions/mule-standalone/3.9.0/mule-standalone-3.9.0.tar.gz}
  
  if [ ! -d $cache_dir/mule-standalone-3.9.0 ] ; then

    echo -n " Downloading .... "

    mkdir -p $cache_dir/mule-standalone-3.9.0/
    curl --retry 3 --silent --location $MULE_COMMON_BUILDPACK | tar xzm -C $cache_dir/mule-standalone-3.9.0/ --strip-components=1
    #chmod 555 $cache_dir/mule-standalone-3.9.0/bin/mule
    #chmod 666 $cache_dir/mule-standalone-3.9.0/apps/
    #chmod 666 -R $cache_dir/mule-standalone-3.9.0/

  fi

  if [ ! -d $install_dir/vendor ] ; then
    mkdir -p $install_dir/vendor/mule-standalone-3.9.0
  fi

  #mkdir -p $install_dir/.mule/
  cp -r $cache_dir/mule-standalone-3.9.0/ $install_dir/vendor/
  echo "START" > $install_dir/mule-standalone-3.9.0/logs/mule.log
  #echo "chmod -R 777 ${install_dir}/vendor/mule-standalone-3.9.0/" >> $install_dir/.mule/deploy
  #echo "/app/vendor/mule-standalone-3.9.0/bin/mule start" >> $install_dir/.mule/deploy
  
  export MULE_HOME=$install_dir/vendor/mule-standalone-3.9.0/

  echo "Done"
}

deploy_mule_app(){
  local build_dir=${1}
  cp $build_dir/target/*.zip $build_dir/vendor/mule-standalone-3.9.0/apps/
}