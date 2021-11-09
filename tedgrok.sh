json=$(curl "https://api.github.com/repos/fatedier/frp/releases/latest")
regexURL="(https://github.com/\S*linux\S*amd64\S*.tar.gz)"
regexDir="/([^/]+).tar.gz"

if [[ $json =~ $regexURL ]]
then
    url="${BASH_REMATCH[1]}"
    echo "$url"
    if [[ $url =~ $regexDir ]]
    then
        filename="${BASH_REMATCH[1]}"
        echo $filename
        if [[ -d $filename ]]
        then
            echo "No need to download $filename"
        else
            wget $url
            tar -xvzf $filename.tar.gz
            chmod +x $filename/frps
        fi
        cd $filename
        ./frps -c ../frps.ini
    else
        echo "Version detection failed"
    fi
else
    echo "URL detection failed"
fi
