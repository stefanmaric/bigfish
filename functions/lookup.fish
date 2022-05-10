function lookup --argument file --description 'Print out the path of the first ancestor of the current dir containing a <file>, if any'
    if [ (count $argv) -ne 1 ]
        echo "Usage: $_ <file>"
        return 1
    end

    pushd .

    while [ (pwd) != / ]
        if [ -e "$file" ]
            pwd
            popd
            return 0
        end

        cd ..
    end

    popd

    return 1
end
