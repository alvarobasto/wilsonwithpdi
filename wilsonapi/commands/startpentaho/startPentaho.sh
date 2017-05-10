#Nao esquecer de dar permissao para esse .sh

cd /Applications/pentaho/pentaho6
./ctlscript.sh start postgresql
sleep 10s
./ctlscript.sh start baserver