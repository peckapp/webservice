# currently syncs the local database tables with the remote for the specified 'scrape_tables'

scrape_tables=( 'resource_types' 'scrape_resources' 'data_resources' 'scrape_resources' )

local_pass='QKyJ2]BbiQD{6W6=H72)iNRV&'
loki_pass='kuvV#4xghgEbz?L*Gg43dRwRG'


read -p "This overrides the remote database tables for scraping. Are you certain? [y/n]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
    touch tmpfile

    for i in "${scrape_tables[@]}"
    do
       :
       # do whatever on $i
       echo $i
       mysqldump -u peck_dev_user "-p$local_pass" peck_development $i > tmpfile
       ssh loki 'echo "test" | cat > testfile'
       cat tmpfile | mysql -u peck_dev_user "-p$local_pass" -h loki.peckapp.com -D peck_development
    done

    rm tmpfile
fi
