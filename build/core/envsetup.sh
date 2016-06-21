# cardinal functions that extend build/envsetup.sh

function cardinal_device_combos()
{
    local T list_file variant device

    T="$(gettop)"
    list_file="${T}/vendor/cardinal/cardinal.devices"
    variant="userdebug"

    if [[ $1 ]]
    then
        if [[ $2 ]]
        then
            list_file="$1"
            variant="$2"
        else
            if [[ ${VARIANT_CHOICES[@]} =~ (^| )$1($| ) ]]
            then
                variant="$1"
            else
                list_file="$1"
            fi
        fi
    fi

    if [[ ! -f "${list_file}" ]]
    then
        echo "unable to find device list: ${list_file}"
        list_file="${T}/vendor/cardinal/cardinal.devices"
        echo "defaulting device list file to: ${list_file}"
    fi

    while IFS= read -r device
    do
        add_lunch_combo "cardinal_${device}-${variant}"
    done < "${list_file}"
}

function cardinal_rename_function()
{
    eval "original_cardinal_$(declare -f ${1})"
}

function cardinal_add_hmm_entry()
{
    f_name="${1}"
    f_desc="${2}"
}

function _cardinal_build_hmm() #hidden
{
    printf "%-8s %s" "${1}:" "${2}"
}

function cardinal_append_hmm()
{
    HMM_DESCRIPTIVE=("${HMM_DESCRIPTIVE[@]}" "$(_cardinal_build_hmm "$1" "$2")")
}

function cardinal_add_hmm_entry()
{
    for c in ${!HMM_DESCRIPTIVE[*]}
    do
        if [[ "${1}" == $(echo "${HMM_DESCRIPTIVE[$c]}" | cut -f1 -d":") ]]
        then
            HMM_DESCRIPTIVE[${c}]="$(_cardinal_build_hmm "$1" "$2")"
            return
        fi
    done
    cardinal_append_hmm "$1" "$2"
}

function cardinalemote()
{
    local proj pfx project

    if ! git rev-parse &> /dev/null
    then
        echo "Not in a git directory. Please run this from an Android repository you wish to set up."
        return
    fi
    git remote rm cardinal 2> /dev/null

    proj="$(pwd -P | sed "s#$ANDROID_BUILD_TOP/##g")"

    if (echo "$proj" | egrep -q 'external|system|build|bionic|art|libcore|prebuilt|dalvik') ; then
        pfx="android_"
    fi

    project="${proj//\//_}"

    git remote add cardinal "git@github.com:Cardinal-AOSP/$pfx$project"
    echo "Remote 'cardinal' created"
}

function cmremote()
{
    local proj pfx project

    if ! git rev-parse &> /dev/null
    then
        echo "Not in a git directory. Please run this from an Android repository you wish to set up."
        return
    fi
    git remote rm cm 2> /dev/null

    proj="$(pwd -P | sed "s#$ANDROID_BUILD_TOP/##g")"
    pfx="android_"
    project="${proj//\//_}"
    git remote add cm "git@github.com:CyanogenMod/$pfx$project"
    echo "Remote 'cm' created"
}

function aospremote()
{
    local pfx project

    if ! git rev-parse &> /dev/null
    then
        echo "Not in a git directory. Please run this from an Android repository you wish to set up."
        return
    fi
    git remote rm aosp 2> /dev/null

    project="$(pwd -P | sed "s#$ANDROID_BUILD_TOP/##g")"
    if [[ "$project" != device* ]]
    then
        pfx="platform/"
    fi
    git remote add aosp "https://android.googlesource.com/$pfx$project"
    echo "Remote 'aosp' created"
}

function cafremote()
{
    local pfx project

    if ! git rev-parse &> /dev/null
    then
        echo "Not in a git directory. Please run this from an Android repository you wish to set up."
    fi
    git remote rm caf 2> /dev/null

    project="$(pwd -P | sed "s#$ANDROID_BUILD_TOP/##g")"
    if [[ "$project" != device* ]]
    then
        pfx="platform/"
    fi
    git remote add caf "git://codeaurora.org/$pfx$project"
    echo "Remote 'caf' created"
}

function cardinal_push()
{
    local branch ssh_name path_opt proj
    branch="crd6.0"
    ssh_name="cardinal_review"
    path_opt=

    if [[ "$1" ]]
    then
        proj="$ANDROID_BUILD_TOP/$(echo "$1" | sed "s#$ANDROID_BUILD_TOP/##g")"
        path_opt="--git-dir=$(printf "%q/.git" "${proj}")"
    else
        proj="$(pwd -P)"
    fi
    proj="$(echo "$proj" | sed "s#$ANDROID_BUILD_TOP/##g")"
    proj="$(echo "$proj" | sed 's#/$##')"
    proj="${proj//\//_}"

    if (echo "$proj" | egrep -q 'external|system|build|bionic|art|libcore|prebuilt|dalvik') ; then
        proj="android_$proj"
    fi

    git $path_opt push "ssh://${ssh_name}/Cardinal-AOSP/$proj" "HEAD:refs/for/$branch"
}


cardinal_rename_function hmm
function hmm() #hidden
{
    local i T
    T="$(gettop)"
    original_cardinal_hmm
    echo

    echo "vendor/cardinal extended functions. The complete list is:"
    for i in $(grep -P '^function .*$' "$T/vendor/cardinal/build/envsetup.sh" | grep -v "#hidden" | sed 's/function \([a-z_]*\).*/\1/' | sort | uniq); do
        echo "$i"
    done |column
}

cardinal_append_hmm "cardinalremote" "Add a git remote for matching Cardinal-AOSP repository"
cardinal_append_hmm "cmremote" "Add a git remote for matching CM repository"
cardinal_append_hmm "aospremote" "Add git remote for matching AOSP repository"
cardinal_append_hmm "cafremote" "Add git remote for matching CodeAurora repository."
