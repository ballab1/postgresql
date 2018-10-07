# postgres

declare -A CS=(
    ['version']=${CS_VERSION:?}
    ['file']="/tmp/config.sub.${CS['version']}"
    ['url']="https://git.savannah.gnu.org/cgit/config.git/plain/config.sub?id=${CS['version']}"
    ['sha256_7d3d27baf8107b630586c962c057e22149653deb']="52d7418817df4a0bd139446cf014f9dfd5bb3406a95c3109ca6fd578068be472"
    ['sha256']="${CS['sha256_'${CS['version']}]}"
)
